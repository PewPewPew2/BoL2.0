local clickDraw = {pos=nil, color='green'}
local CO, FO, RE, SA, GE

Callback.Bind('GameStart', function()
	CO = CustomObjects()
	GE = General()
	FO = Follow()
	RE = Recall()
	SA = Safety()
	
	AutoBuy()
	Warding()
	SpellCast()
	ItemCast()
	AutoLevel()
	SummSpells()
	Unique()
	
	Menu = MenuConfig('Follower')
	Menu:KeyBinding('fFollow', 'Set Primary to Selected Ally', 'T')
	General:Print('Loaded')
end)

class 'Follow'
function Follow:__init() 
	self.Target = {Primary = nil, Secondary = nil}
	self.tickTime = 0
	self.mostFedTime = 1600
	self.PrimaryLastMove = 0
	self.lastAction = 0
	self:getPrimary()
	Callback.Bind('Tick', function() self:Tick() end)
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
	Callback.Bind('ProcessSpell', function(unit, spell) self:ProcessSpell(unit, spell) end)
	Callback.Bind('Draw', function() self:Draw() end)
	Callback.Bind('WndMsg', function(m, k) self:WndMsg(m, k) end)
end

function Follow:Tick()
	if Safety:InDanger() then Safety:Fallback() return end
	if RE.GoingHome then return end
	FO.tickTime = os.clock()
	if FO.tickTime > FO.mostFedTime then
		Follow:getMostFed()
		FO.mostFedTime = FO.mostFedTime + 300
	end
	if FO.Target.Primary then
		if self:allyInBase(FO.Target.Primary) or self:AFKCheck() then
			if FO.Target.Secondary == nil or self:allyInBase(FO.Target.Secondary) then
				self:HugTurret()
				if FO.Target.Secondary == nil then
					self:getSecondary()
				end
			else
				self:Pursue(FO.Target.Secondary)  --[[PUT WARD ROAMING HERE]]
			end
		else
			self:Pursue(FO.Target.Primary)
			FO.Target.Secondary = nil
		end
	end
end

function Follow:AFKCheck()
	return FO.Target.Primary ~= nil and os.clock() >= FO.PrimaryLastMove + 60
end

function Follow:Allow(ally)
	return myHero.pos:DistanceTo(ally.pos) > 525 and not ally.dead and not General:IsRecalling(ally) and ally.pos:DistanceTo(GE.StartPos) > 3500
end

function Follow:Pursue(ally)
	local ASC = General:ActionSpamCheck()
	if ASC > 2.2 then
		local r = math.random(-350, 350)
		local v3b = Geometry.Vector3(ally.x+r, ally.y, ally.z+r) + (ally.pos-myHero.pos):Normalize()*math.random(350, 600)
		if v3b then
			myHero:Move(v3b.x, v3b.z)
			FO.lastAction = os.clock()
			--Game.ShowGreenClick(v3b)
			clickDraw.pos = v3b
			clickDraw.color = 'green'
		end
	elseif ASC > 0.7 then
		self:autoAttack()
	elseif ASC > 0.4 then
		if self:Allow(ally) then
			local r = math.random(-225, 225)
			local v3a = Geometry.Vector3(ally.x+r, ally.y, ally.z+r) + (ally.pos-myHero.pos):Normalize()*math.random(400, 850)
			if v3a then	
				myHero:Move(v3a.x, v3a.z)
				FO.lastAction = os.clock()
				clickDraw.pos = v3a
				clickDraw.color = 'green'
			end			
		end
	end	
end

function Follow:getMostFed()
	local mostKills = {ally=nil, count=0}
	for name, count in pairs(GE.killCount) do
		if name ~= myHero.name and (mostKills.ally == nil or mostKills.count < count) then
			mostKills.ally = name
			mostKills.count = count
		end
	end
	if mostKills.ally then
		for _, ally in ipairs(CO.allies) do
			if ally.name == mostKills.ally then
				FO.Target.Primary = ally
				General:Print('Primary set to(most fed): '..ally.charName)
				break
			end
		end
	end
end

function Follow:autoAttack()
	local trueRange = myHero.range+myHero.boundingRadius
	for _, enemy in ipairs(CO.enemies) do
		if enemy and enemy.valid and enemy.visible and myHero.pos:DistanceTo(enemy.pos) < trueRange and not enemy.dead then
			myHero:Attack(enemy)
			FO.lastAction = os.clock()
			clickDraw.pos = enemy.pos
			clickDraw.color = 'red'
		end
	end					
	for _, tower in ipairs(CO.etowers) do
		if tower and tower.valid and tower.visible and myHero.pos:DistanceTo(tower.pos) < trueRange and (tower.health/tower.maxHealth) > 0.05 then
			myHero:Attack(tower)
			FO.lastAction = os.clock()
			clickDraw.pos = tower.pos
			clickDraw.color = 'red'					
		end
	end
	if myHero.level == 1 or myHero.level >= 11 then
		for _, minion in pairs(CO.eMinions) do
			if minion and minion.valid and minion.visible and myHero.pos:DistanceTo(minion.pos) < trueRange and not minion.dead and minion.health > 200 then
				myHero:Attack(minion)
				FO.lastAction = os.clock()
				clickDraw.pos = minion.pos
				clickDraw.color = 'red'
			end
		end
	end
end

function Follow:allyInBase(ally)
	return ally.dead or (ally.pos:DistanceTo(GE.StartPos) < 3000 and myHero.pos:DistanceTo(ally.pos) > 3000) or General:IsRecalling(ally)
end

function Follow:getSecondary()
	local allyClosest = nil
	for _, ally in ipairs(CO.allies) do
		if ally and not ally.dead and ally ~= myHero and ally ~= FO.Target.Primary and not self:allyInBase(ally) then
			if allyClosest == nil or myHero.pos:DistanceTo(ally.pos) < myHero.pos:DistanceTo(allyClosest.pos) then
				allyClosest = ally
			end
		end
	end	
	if allyClosest then 
		FO.Target.Secondary = allyClosest
		General:Print('Secondary - '..allyClosest.charName)
	else 
		FO.Target.Secondary = nil
		Recall:GetSafeRecallPos()
		RE.GoingHome = true
	end
end

function Follow:ADCCheck(charName)
	local ADCcharNames = {'ashe','corki','ezreal','caitlyn','draven','graves','jinx','kogmaw','lucian','missfortune','quinn','sivir','tristana','twitch','varus','vayne','urgot','twistedfate','kalista',}
	for _, v in ipairs(ADCcharNames) do
		if charName:lower():find(v) then
			return true
		end
	end
	return false
end

function Follow:getPrimary()
	local possibleADC = 0
	local LastCandidate
	for _, ally in ipairs(CO.allies) do
		if ally ~= myHero and self:smiteCheck(ally) and self:ADCCheck(ally.charName) then 
			LastCandidate = ally
			possibleADC = possibleADC + 1
		end
	end	
	if possibleADC == 1 then 
		self.Target.Primary = LastCandidate
		General:Print('Primary - '..LastCandidate.charName)
	else
		Utility.DelayAction(function() self:getPrimaryBackup() end, 120000)
	end
end

function Follow:getPrimaryBackup()
	for i, turret in ipairs(CO.atowers) do
		if turret and not turret.dead and turret.valid and turret.name and turret.name:find('R_03') then
			local botCount = {}
			for _, ally in ipairs(CO.allies) do
				if ally and self:smiteCheck(ally) and ally.pos:DistanceTo(turret.pos) < 3000 then
					table.insert(botCount, #botCount+1, ally)
				end
			end
			if #botCount == 1 then
				self.Target.Primary = botCount[1]
				General:Print('Primary - '..botCount[1].charName)
				return
			end
		end
	end
	for i, turret in ipairs(CO.atowers) do
		if turret and not turret.dead and turret.valid and turret.name and turret.name:find('L_03') then
			local topCount = {}
			for _, ally in ipairs(CO.allies) do
				if ally and self:smiteCheck(ally) and ally.pos:DistanceTo(turret.pos) < 3000 then
					table.insert(topCount, #topCount+1, ally)
				end
			end
			if #topCount == 1 then
				self.Target.Primary = topCount[1]
				General:Print('Primary - '..topCount[1].charName)
				return
			end
		end
	end
end

function Follow:smiteCheck(ally)
	return ally:GetSpellData(Game.Slots.SUMMONER_1).name:lower():find('smite') == nil and ally:GetSpellData(Game.Slots.SUMMONER_2).name:lower():find('smite') == nil
end

function Follow:HugTurret()
	if Game.Timer() > 1080 then return end
	for i, turret in ipairs(CO.atowers) do
		if turret and not turret.dead and turret.valid and turret.name and turret.name:find('R_03') and turret.health and turret.health > 400 then
			for _, minion in ipairs(CO.eMinions) do
				if minion and turret.pos:DistanceTo(minion.pos) < 1800 then
					FO.Target.Secondary = turret
					return
				end
			end
		end
	end
	FO.Target.Secondary = nil
end

function Follow:ProcessSpell(unit, spell)
	if unit and unit == self.Target.Primary then
		self.PrimaryLastMove = os.clock()
	end
end

function Follow:OnRecvPacket(p)
	if p.header == 97 and self.Target.Primary then
		p.pos = 12
		if p:Decode4() == self.Target.Primary.networkID then
			self.PrimaryLastMove = os.clock()
		end
	end	
end

function Follow:Draw()
	if self.Target.Primary ~= nil then
		Render.GameCircle(self.Target.Primary, 100, Graphics.ARGB(255, 0, 255, 0):ToNumber()):Draw()
	end
	if self.Target.Secondary ~= nil then
		Render.GameCircle(self.Target.Secondary, 100, Graphics.ARGB(255, 0, 0, 255):ToNumber()):Draw()
	end
	if clickDraw.pos ~= nil then
		local wts = Graphics.WorldToScreen(clickDraw.pos)
		local v2 = Geometry.Point(wts.x, wts.y)
		if clickDraw.color == 'red' then
			Graphics.DrawText("X", 35, v2.x, v2.y, Graphics.ARGB(255,255,0,0))
		else
			Graphics.DrawText("X", 35, v2.x, v2.y, Graphics.ARGB(255,0,255,0))
		end					
	end
end

function Follow:WndMsg(m, k)
	if k == string.byte(Menu.fFollow:Value()) and m == 256 then
		local sAlly = Game.Target()
		if sAlly and sAlly.type == myHero.type and sAlly.team == myHero.team then
			self.Target.Primary = sAlly
			General:Print('Primary Manually set to: '..sAlly.charName)
		end
	end
	if k == string.byte('X') and m == 256 then
		General:Print(tostring(mousePos.x).."   "..tostring(mousePos.z))
	end
end

class 'Recall'

function Recall:__init()
	self.RecallPosition = nil
	self.GoingHome = false
	Callback.Bind('Tick', function() self:Tick() end)
end

function Recall:Tick()
	if RE.GoingHome then Recall:CastRecall() end
	Core.OutputDebugString('Not Going Home')
	if self:ShouldRecall() then
		Core.OutputDebugString('Should Recall')
		if self.RecallPosition == nil then
			Core.OutputDebugString('RecallPosNil')
			if not self.GoingHome then
				Core.OutputDebugString('Getting Recall Pos')
				self:GetSafeRecallPos()
				self.GoingHome = true
			end
		end
	end
	if myHero.pos:DistanceTo(GE.StartPos) < 700 and (myHero.health/myHero.maxHealth) >= 0.9 and (myHero.mana/myHero.maxMana) >= 0.9 then
		Core.OutputDebugString('Recall Complete')
		self.GoingHome = false
		self.RecallPosition = nil
	end	
end

function Recall:ShouldRecall()
	return myHero.pos:DistanceTo(GE.StartPos) > 600 and not myHero.dead and (General:myHealthPct() < 30 or (General:myManaPct() < 15 and General:myHealthPct() < 50))
end

function Recall:GetSafeRecallPos()
	local ClosestTower = General:GetClosestTurret(myHero, myHero.team)
	local SafeSpot
	if myHero.pos:DistanceTo(ClosestTower.pos) < 3500 then
		SafeSpot = ClosestTower.pos+(GE.StartPos-ClosestTower.pos):Normalize()*1500
	else	
		SafeSpot = self:SafetyBush()
	end
	if SafeSpot and (GE.ClosestEnemy == nil or SafeSpot:DistanceTo(GE.ClosestEnemy.pos) > 1300) then
		self.RecallPosition = SafeSpot
	end
end

function Recall:SafetyBush()
	if GE.StartPos.x == 200 then
		for i=myHero.x, GE.StartPos.x, -50 do
			for j=myHero.z, GE.StartPos.z, -50 do
				if Game.IsGrass(Geometry.Vector3(i, 0, j)) and (GE.ClosestEnemy == nil or Geometry.Vector3(i, 0, j):DistanceTo(GE.ClosestEnemy.pos) > 1300) then
					return Geometry.Vector3(i, 0, j)
				end
			end
		end
	else
		for i=myHero.x, GE.StartPos.x, 50 do
			for j=myHero.z, GE.StartPos.z, 50 do
				if Game.IsGrass(Geometry.Vector3(i, 0, j)) and (GE.ClosestEnemy == nil or Geometry.Vector3(i, 0, j):DistanceTo(GE.ClosestEnemy.pos) > 1300) then
					return Geometry.Vector3(i, 0, j)
				end
			end
		end		
	end
end

function Recall:CastRecall()
	Core.OutputDebugString('Should Be Recalling')
	local asc = General:ActionSpamCheck()
	if myHero.dead then return end
	if RE.RecallPosition then 
		if myHero.pos:DistanceTo(RE.RecallPosition) < 100 then
			if RE:RecallSafetyCheck() then
				myHero:CastSpell(Game.Slots.RECALL)
			else
				RE:GetSafeRecallPos()
			end
		elseif asc > 0.2 then
			myHero:Move(RE.RecallPosition.x, RE.RecallPosition.z)
			clickDraw.pos = RE.RecallPosition
			clickDraw.color = 'green'
		end
	end
end

function Recall:RecallSafetyCheck()
	return GE.ClosestEnemy == nil or myHero.pos:DistanceTo(GE.ClosestEnemy.pos) > 1300
end

class 'Warding'

function Warding:__init()
	self.LastWard = 0
	self.wardPositions = {}
	self.wardSpots = {
		{ x = 3310, 	y = 55, 	z = 7800},
		{ x = 7110, 	y = 46, 	z = 3087},
		{ x = 10400,	y = 44, 	z = 3036},
		{ x = 6580, 	y = 42, 	z = 4690},
		{ x = 7950, 	y = 51, 	z = 5500},
		{ x = 4850, 	y = 51, 	z = 8345},
		{ x = 6625, 	y = 55, 	z = 3125},
		{ x = 11602, 	y = 54, 	z = 7067},
		{ x = 6471, 	y = 54, 	z = 11357},
		{ x = 2939, 	y = 39, 	z = 11294},
		{ x = 7242, 	y = 43, 	z = 9768},
		{ x = 6613, 	y = 57, 	z = 8375},
		{ x = 10073,	y = 54, 	z = 7762},
		{ x = 9387, 	y = 44, 	z = 5682},
		{ x = 7053, 	y = 52, 	z = 11376},
		{ x = 10553, 	y = 62, 	z = 5105},
		{ x = 8267, 	y = 64, 	z = 5559},
		{ x = 4337, 	y = 60, 	z = 9777},
		{ x = 5245, 	y = 62, 	z = 9125},
		{ x = 13382, 	y = 49, 	z = 2437},
		{ x = 12465, 	y = 49, 	z = 1457},
		{ x = 9719,  	y = 53,  	z = 6347},
		{ x = 8500,  	y = 55,  	z = 4843},
		{ x = 6284,  	y = 53,  	z = 10085},
		{ x = 4137,  	y = 42,  	z = 7970},
		{ x = 4698,  	y = 53,  	z = 7182},
		{ x = 9241,  	y = 53,  	z = 11349},
		{ x = 8271,  	y = 53,  	z = 10217},
		{ x = 5465,  	y = 54,  	z = 3493},
		{ x = 8253,  	y = 49,  	z = 11782},
		{ x = 7754,  	y = 50,  	z = 11845},
		{ x = 2306,  	y = 54,  	z = 9700},
		{ x = 5492,  	y = 53,  	z = 10406},
		{ x = 8010,  	y = 56,  	z = 3440},
		{ x = 12543,  	y = 52,  	z = 5096},
		{ x = 4396,  	y = 48,  	z = 11794},
		{ x = 5650,  	y = 39,  	z = 12692},
		{ x = 9514,  	y = 60,  	z = 4154},
		{ x = 7549,  	y = 56,  	z = 7404},
		{ x = 9170,  	y = 54,  	z = 2170},
		{ x = 2300, 	y = 44, 	z = 9703},
		{ x = 8424, 	y = 46, 	z = 6487},
		{ x = 11823, 	y = 42, 	z = 3873},
	}
	Callback.Bind('Tick', function() self:Tick() end)
	Callback.Bind('RecvPacket', function(p) self:RecvPacket(p) end)
end

function Warding:RecvPacket(p)
	if p.header == 181 then
		p.pos = 1
		local hero = Game.ObjectByNetworkId(p:Decode4())
		if hero and hero.team == myHero.team then
			p:Skip(7)
			local packetID = p:Decode2()
			local wardIDS = {[14481] = true, [14482] = true, [41332] = true, [18926] = true, [15470] = true, [58660] = true, [14483] = true, [2084] = true, [35170] = true,}		
			if wardIDS[packetID] then
				p:Skip(2)
				local wardID = p:Decode4()+1
				p:Skip(21)
				local v3 = Geometry.Vector3(p:DecodeF(), p:DecodeF(), p:DecodeF())
				table.insert(self.wardPositions, #self.wardPositions+1, { pos = v3, id = wardID })
			end
		end
	end		
	if p.header == 158 then
		p.pos = 1
		local wardId = p:Decode4()
		for i=1, #self.wardPositions do
			if self.wardPositions[i] and self.wardPositions[i].id and self.wardPositions[i].id == wardId then
				table.remove(self.wardPositions, i)
				break
			end
		end
	end
end
				
function Warding:Tick()
	local currentTime = os.clock()
	if (self.LastWard+4) > currentTime then return end
	
	local WardSlot = self:GetWardSlot()
	if WardSlot then
		for i=1, #self.wardSpots do 
			local spot = Geometry.Vector3(self.wardSpots[i].x, self.wardSpots[i].y, self.wardSpots[i].z)
			if spot and myHero.pos:DistanceTo(spot) <= 600 then
				local wardNear = nil
				for i=1, #self.wardPositions do
					local ward = self.wardPositions[i]
					if ward then
						if wardNear == nil or spot:DistanceTo(ward.pos) < spot:DistanceTo(wardNear.pos) then
							wardNear = ward
						end
					end
				end			
				if wardNear == nil or (wardNear and spot:DistanceTo(wardNear.pos) > 1200) then  			
					FO.lastAction = os.clock()
					myHero:CastSpell(WardSlot, spot.x, spot.z)
					self.LastWard = os.clock()
				end
			end
		end
	end
end

function Warding:GetWardSlot()
	local WardIDs = {3340,2049,2045,3362,}
	for _, id in ipairs(WardIDs) do
		if self:CheckForWard(id) ~= 0 then
			return self:CheckForWard(id)
		end
	end
end

function Warding:CheckForWard(id)
	for i=Game.Slots.ITEM_1, Game.Slots.ITEM_7 do
		local identifier = myHero:GetInventorySlot(i)
		if identifier == id and myHero:CanUseSpell(i) == Game.SpellState.READY then
			return i
		end
	end
	return 0
end

class 'Safety'

function Safety:__init()
	self.HaveTowerAgro = false
	self.EscapeTurret = nil
	self.MinionAggro = 0
	self.HeroAggro = 0
	self.DragonAggro = false
	self.BaronAggro = false
	self.FallBackPing = 0
	Callback.Bind('Tick', function() self:Tick() end)
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
end

function Safety:Tick()
	if self.HaveTowerAgro and self.EscapeTurret ~= nil then
		local EscapeTo = General:GetClosestTurret(myHero, myHero.team)
		if EscapeTo then 
			myHero:Move(EscapeTo.x, EscapeTo.z)
			FO.lastAction = os.clock()
		end
	end
end

function Safety:InDanger()
	-- or SA.DragonAggro or SA.BaronAggro
	return SA.HaveTowerAgro or SA.HeroAggro >= 2 or SA.MinionAggro >= (myHero.level+1) or SA.FallBackPing > os.clock() or (GE.ClosestEnemy ~= nil and not GE.ClosestEnemy.dead and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < 250 and General:myHealthPct() < 75) or SA.MinionAggro >= (myHero.level+1)
end

function Safety:Fallback()
	myHero:Move(GE.StartPos.x, GE.StartPos.z)
	clickDraw.pos = GE.StartPos
	clickDraw.color = 'green'
	FO.lastAction = os.clock()
end

function Safety:OnRecvPacket(p)
	if p.header == 192 then
		p.pos = 1
		local o = Game.ObjectByNetworkId(p:Decode4())
		local aggro = p:Decode1()
		if o and o.name:lower():find('minion') then
			if aggro >= 20 then
				self.MinionAggro = self.MinionAggro + 1
			elseif self.MinionAggro ~= 0 then
				if not o.visible or aggro == 0 then
					self.MinionAggro = self.MinionAggro - 1
				end
			end
		end
		--[[if o.name == 'Dragon6.1.1' then
			if aggro == 29 then
				self.DragonAggro = true
			elseif aggro == 0 or not o.visible then
				self.DragonAggro = false
			end
		end
		if o.name == 'Worm12.1.1' then
			if aggro == 29 then
				self.BaronAggro = true
			elseif aggro == 0 or not o.visible then
				self.BaronAggro = false
			end
		end--]]
		if o.name:lower():find('turret') then
			if aggro >= 20 then
				self.HaveTowerAgro = true
				self.EscapeTurret = General:GetClosestTurret(myHero, 0)
			elseif aggro == 0 or not o.visible then
				self.HaveTowerAgro = false
				self.EscapeTurret = nil
			end
		end
		if o.type == myHero.type then
			if aggro >= 20 then
				self.HeroAggro = self.HeroAggro + 1
			elseif aggro == 0 or not o.visible then
				self.HeroAggro = self.HeroAggro - 1
			end
		end
	end
	if p.header == 64 then
		p.pos = 5
		if myHero.pos:DistanceTo(Geometry.Vector3(p:DecodeF(), 0 , p:DecodeF())) < 1200 then		
			p.pos = 21
			local pType = p:Decode1()
			if pType == 5 or pType == 2 then
				self.FallBackPing = os.clock() + 2
			end
		end
	end	
end

class 'AutoBuy'

function AutoBuy:__init()
	self.LastBuy = 0
	self.LastHpBuy = 0
	self.LastManaBuy = 0
	self.BuyList = {}
	self:TableInit()
	self:ReloadCheck()
	Callback.Bind('Tick', function() self:Tick() end)
end

function AutoBuy:TableInit()
	local ListOne   = { ['Lux'] = true, ['Morgana'] = true, }
	local ListTwo   = { ['Zilean'] = true, ['Sona'] = true, }
	local ListThree = { ['Blitzcrank'] = true, ['Soraka'] = true, }
	local ListFour  = { ['FiddleSticks'] = true, }
	
	if ListOne[myHero.charName] then
		self.BuyList = {
			{itemID = 3301, haveBought = false, name = 'Coin'},
			{itemID = 3340, haveBought = false, name = 'WardTrinket'},
			{itemID = 1028, haveBought = false, name = 'RubyCrystal'},
			{itemID = 2049, haveBought = false, name = 'Sightstone'},
			{itemID = 1004, haveBought = false, name = 'FairieCharm'},
			{itemID = 1001, haveBought = false, name = 'BootsT1'},
			{itemID = 3028, haveBought = false, name = 'Chalice'},
			{itemID = 3096, haveBought = false, name = 'Nomad'},
			{itemID = 3114, haveBought = false, name = 'ForbiddenIdol'},
			{itemID = 3069, haveBought = false, name = 'Talisman'},
			{itemID = 3111, haveBought = false, name = 'MercTreads'},
			{itemID = 3222, haveBought = false, name = 'Crucible'},
			{itemID = 2045, haveBought = false, name = 'RubySightstone'},
			{itemID = 3362, haveBought = false, name = 'TrinketT2'},
			{itemID = 1057, haveBought = false, name = 'Negatron'},
			{itemID = 3105, haveBought = false, name = 'Aegis'},
			{itemID = 3190, haveBought = false, name = 'Locket'},
			{itemID = 3082, haveBought = false, name = 'Wardens'},
			{itemID = 1011, haveBought = false, name = 'GiantsBelt'},
			{itemID = 3143, haveBought = false, name = 'Randuins'},	
			{itemID = 3275, haveBought = false, name = 'Homeguard'},
		}
	elseif ListTwo[myHero.charName] then
		self.BuyList = {
			{itemID = 3303, haveBought = false, name = 'Spellthief'}, --1
			{itemID = 3340, haveBought = false, name = 'WardTrinket'},
			{itemID = 1027, haveBought = false, name = 'ManaCrystal'}, --2
			{itemID = 3070, haveBought = false, name = 'Tear'},			
			{itemID = 1028, haveBought = false, name = 'RubyCrystal'}, --3
			{itemID = 2049, haveBought = false, name = 'Sightstone'},
			{itemID = 1001, haveBought = false, name = 'BootsT1'}, --4
			{itemID = 3098, haveBought = false, name = 'FrostFang'}, 
			{itemID = 3028, haveBought = false, name = 'Chalice'}, --5
			{itemID = 3092, haveBought = false, name = 'FrostQueen'},
			{itemID = 3114, haveBought = false, name = 'ForbiddenIdol'},
			{itemID = 3111, haveBought = false, name = 'MercTreads'},
			{itemID = 3222, haveBought = false, name = 'Crucible'},
			{itemID = 2045, haveBought = false, name = 'RubySightstone'},
			{itemID = 3362, haveBought = false, name = 'TrinketT2'},
			{itemID = 3024, haveBought = false, name = 'Glacial'}, --6
			{itemID = 3110, haveBought = false, name = 'FrozenHeart'},
			{itemID = 3003, haveBought = false, name = 'ArchStaff'},	
			{itemID = 3275, haveBought = false, name = 'Homeguard'},
		}
	elseif ListThree[myHero.charName] then
		self.BuyList = {
			{itemID = 3301, haveBought = false, name = 'Coin'}, --1
			{itemID = 3340, haveBought = false, name = 'WardTrinket'},
			{itemID = 1028, haveBought = false, name = 'RubyCrystal'}, --2
			{itemID = 2049, haveBought = false, name = 'Sightstone'},
			{itemID = 1001, haveBought = false, name = 'BootsT1'}, --3
			{itemID = 3096, haveBought = false, name = 'Nomad'},
			{itemID = 3111, haveBought = false, name = 'MercTreads'},
			{itemID = 1033, haveBought = false, name = 'NullMantle'}, --4
			{itemID = 3082, haveBought = false, name = 'Wardens'}, --5
			{itemID = 3105, haveBought = false, name = 'Aegis'},
			{itemID = 3190, haveBought = false, name = 'Locket'},
			{itemID = 1011, haveBought = false, name = 'GiantsBelt'},
			{itemID = 3143, haveBought = false, name = 'Randuins'},
			{itemID = 2045, haveBought = false, name = 'RubySightstone'},
			{itemID = 3362, haveBought = false, name = 'TrinketT2'},
			{itemID = 3069, haveBought = false, name = 'Talisman'},
			{itemID = 3024, haveBought = false, name = 'Glacial'}, --6
			{itemID = 3110, haveBought = false, name = 'FrozenHeart'},
			{itemID = 3275, haveBought = false, name = 'Homeguard'},
		}
	elseif ListFour[myHero.charName] then
		self.BuyList = {
			{itemID = 3303, haveBought = false, name = 'Spellthief'}, --1
			{itemID = 3340, haveBought = false, name = 'WardTrinket'},
			{itemID = 1028, haveBought = false, name = 'RubyCrystal'}, --2
			{itemID = 2049, haveBought = false, name = 'Sightstone'},
			{itemID = 3098, haveBought = false, name = 'FrostFang'}, 
			{itemID = 1001, haveBought = false, name = 'BootsT1'}, --3 
			{itemID = 1052, haveBought = false, name = 'AmpTome'}, --4 
			{itemID = 3136, haveBought = false, name = 'HauntGuise'}, 
			{itemID = 3020, haveBought = false, name = 'SorcShoes'},
			{itemID = 3191, haveBought = false, name = 'SeekArmGuard'}, --5 
			{itemID = 3092, haveBought = false, name = 'FrostQueen'},
			{itemID = 1058, haveBought = false, name = 'LargeRod'}, 
			{itemID = 3157, haveBought = false, name = 'Zhonyas'}, 
			{itemID = 1026, haveBought = false, name = 'BlastingWand'}, --6 
			{itemID = 3151, haveBought = false, name = 'Liandrys'}, 
			{itemID = 3089, haveBought = false, name = 'Rabadons'},
			{itemID = 3362, haveBought = false, name = 'TrinketT2'},
			{itemID = 3275, haveBought = false, name = 'Homeguard'},
			
		}
	end
end

function AutoBuy:Tick()
	if myHero.pos:DistanceTo(GE.StartPos) < 500 or myHero.dead then
		SA.HeroAggro = 0
		self:Items()
		self:Potions()
	end
end

function AutoBuy:Items()
	if self:TimeCheck() then
		for i=1, #self.BuyList do
			if self:CheckForItem(self.BuyList[i].itemID) ~= 0 then
				self.BuyList[i].haveBought = true				
			elseif not self.BuyList[i].haveBought and (i == 1 or self.BuyList[i-1].haveBought) then			
				Game.BuyItem(self.BuyList[i].itemID)
				self.LastBuy = os.clock() + 0.25
			end
		end
	end
end

function AutoBuy:Potions()
	if os.clock() < 1200 then
		if self:CheckForItem(2003) == 0 and self.LastHpBuy < os.clock() then 
			Game.BuyItem(2003)
			Game.BuyItem(2003)
			self.LastHpBuy = os.clock() + 2
		end	
		if self:CheckForItem(2004) == 0 and self.LastManaBuy < os.clock() then 
			Game.BuyItem(2004)
			Game.BuyItem(2004)
			self.LastManaBuy = os.clock() + 2
		end	
	end
end

function AutoBuy:TimeCheck()
	return self.LastBuy < os.clock()
end

function AutoBuy:ReloadCheck()
	for i=#self.BuyList, 1, -1 do
		if self.BuyList[i].itemID ~= nil and self:CheckForItem(self.BuyList[i].itemID) ~= 0 then
			self.BuyList[i].haveBought = true
			for j=i, 1, -1 do
				self.BuyList[j].haveBought = true
			end
			break
		end
	end
end

function AutoBuy:CheckForItem(id)
	for i=Game.Slots.ITEM_1, Game.Slots.ITEM_7 do
		local identifier = myHero:GetInventorySlot(i)
		if identifier == id then
			return i
		end
	end
	return 0
end

class 'General'

function General:__init()
	self.ClosestEnemy = nil
	self.ClosestAlly = nil
	self.StayInBrush = false
	self.StartPos = (myHero.team == 100) and Geometry.Vector3(200, 90, 500) or Geometry.Vector3(13945, 90, 14210)
	self.killCount = {}
	Callback.Bind('Tick', function() self:Tick() end)
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
	Callback.Bind('SendPacket', function(p) self:OnSendPacket(p) end)
end

function General:Tick()
	self.ClosestEnemy = self:GetClosestEnemyHero()
	self.ClosestAlly = self:GetClosestAllyHero()
	--self:checkWaypoints()
end

function General:checkWaypoints()
	Core.OutputDebugString('Starting Waypoint Check')
	local wayPoints = myHero.path
	for i=wayPoints.curPath, wayPoints.count do
		local cP = (type(wayPoints:Path(i)) == 'Vector3') and wayPoints:Path(i) or nil
		if cP then
			for _, tower in ipairs(CO.etowers) do
				if not tower.dead and cP:DistanceTo(tower.pos) < 1200 then
					General:Print('Walking into a Tower')
				end
			end
		end
	end
	Core.OutputDebugString('Finished Waypoint Check')
end

function General:IsRecalling(unit)
	for i = 1, unit.buffCount do
		local recallBuff = unit:GetBuff(i)
		if recallBuff.valid and recallBuff.name:lower():find('recall') then
			if unit == FO.Target.Primary and os.clock() < 1200 then
				if (myHero.health/myHero.maxHealth) < 0.7 or (myHero.mana/myHero.maxMana) < 0.5 then
					Recall:GetSafeRecallPos()
					RE.GoingHome = true									
				end
			end
			return true
		end	
	end
	return false	
end

function General:ActionSpamCheck()
	return (self:StayAtFountain() or self:BlockRecallMovement()) and 15 or os.clock() - FO.lastAction
end

function General:Print(text)
	Game.Chat.Print("<font color=\"#0099FF\">[Follower]</font> <font color=\"#FF6600\">"..text..".</font>")
end

function General:myManaPct()
	return ((myHero.mana*100)/myHero.maxMana)
end

function General:myHealthPct()
	return ((myHero.health*100)/myHero.maxHealth)
end

function General:StayAtFountain()
	return myHero.pos:DistanceTo(GE.StartPos) < 500 and (self:myHealthPct() < 90 or self:myManaPct() < 90)
end

function General:BlockRecallMovement()	
	return self:IsRecalling(myHero) and (GE.ClosestEnemy == nil or myHero.pos:DistanceTo(GE.ClosestEnemy.pos) > 1400)
end

function General:GetClosestTurret(unit, team)
	local ClosestTurretFromPos = nil
	if team == myHero.team then
		for _, tower in ipairs(CO.atowers) do
			if tower and tower.valid and (tower.health/tower.maxHealth) > 0.1 then
				if ClosestTurretFromPos == nil or unit.pos:DistanceTo(tower.pos) < unit.pos:DistanceTo(ClosestTurretFromPos.pos) then
					ClosestTurretFromPos = tower
				end						
			end
		end
	else
		for _, tower in ipairs(CO.etowers) do
			if tower and tower.valid and (tower.health/tower.maxHealth) > 0.1 then
				if ClosestTurretFromPos == nil or unit.pos:DistanceTo(tower.pos) < unit.pos:DistanceTo(ClosestTurretFromPos.pos) then
					ClosestTurretFromPos = tower
				end						
			end						
		end					
	end
	return ClosestTurretFromPos
end

function General:GetClosestAllyHero()
	local closest = nil
	for _, ally in ipairs(CO.allies) do
		if ally and not ally.dead and ally ~= myHero then
			if closest == nil or myHero.pos:DistanceTo(ally.pos) < myHero.pos:DistanceTo(closest.pos) then
				closest = ally
			end
		end
	end	
	return closest
end

function General:GetClosestEnemyHero()
	local closest = nil
	for _, enemy in ipairs(CO.enemies) do
		if enemy and not enemy.dead and enemy.visible then
			if closest == nil or myHero.pos:DistanceTo(enemy.pos) < myHero.pos:DistanceTo(closest.pos) then
				closest = enemy
			end
		end
	end	
	return closest
end

function General:PrimaryInBrush()
	if self.ClosestEnemy == nil or (self.ClosestEnemy and myHero.pos:DistanceTo(self.ClosestEnemy.pos) > 400) then
		if FO.Target.Primary and Game.IsGrass(FO.Target.Primary.pos) then
			self.StayInBrush = true
			return
		end
	end	
	self.StayInBrush = false
end

function General:HasBuff(unit, buff)
	for i = 1, unit.buffCount do
		local eBuff = unit:GetBuff(i)
		if eBuff.valid then
			if eBuff.name:lower():find(buff) then
				return true
			end
		end	
	end
	return false
end

function General:OnRecvPacket(p)
	if p.header == 201 then
		p.pos = 10
		local yesCount = p:Decode1()
		local noCount = p:Decode1()
		local totalVotes = p:Decode1()
		if p:Decode4() == myHero.team then
			if (totalVotes == 5 and yesCount == 3) or (totalVotes < 5 and yesCount == 2) then
				Game.Chat.Send('/ff')				
			elseif noCount == 2 then
				Game.Chat.Send('/noff')
			end
		end
	end
	if p.header == 94 then	
		p.pos=10
		local killer = Game.ObjectByNetworkId(p:Decode4())
		if killer and killer.team == myHero.team then
			for name, kills in pairs(self.killCount) do
				if name == killer.name then
					self.killCount[name] = kills+1
					return
				end
			end
			self.killCount[killer.name] = 1
		end
	end
end

function General:OnSendPacket(p)
	if p.header == 114 or p.header == 154 then	
		if self:BlockRecallMovement() or self:StayAtFountain() then
			p.pos = 1
			if p:Decode4() == myHero.networkID then
				p:Block()
			end	
		end
	end
end

class 'CustomObjects'

function CustomObjects:__init()
	self.etowers = {}
	self.atowers = {}
	self.enemies = {}
	self.allies = {}
	self.eMinions = {}
	for i=1, Game.ObjectCount() do
		local o = Game.Object(i)
		if o then
			if o.type == 'obj_AI_Turret' then
				table.insert((o.team == myHero.team) and self.atowers or self.etowers, (o.team == myHero.team) and #self.atowers+1 or #self.etowers+1, o)
			end
			if self:IsValid(o) then 
				table.insert(self.eMinions, o)
			end			
		end
	end
	for i=1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero then
			table.insert((hero.team == myHero.team) and self.allies or self.enemies, (hero.team == myHero.team) and #self.allies+1 or #self.enemies+1, hero)
		end
	end
	Callback.Bind('Tick', function() self:OnTick() end)
	Callback.Bind('CreateObj', function(o) self:OnCreateObj(o) end)
	Callback.Bind('DeleteObj', function(o) self:OnDeleteObj(o) end)	
end

function CustomObjects:IsValid(obj)
	return obj and obj.valid and not obj.dead and obj.health > 0 and obj.type:find("Minion") and obj.charName and obj.charName ~= "TestCubeRender" and obj.team ~= myHero.team and obj.name 
end

function CustomObjects:OnTick()
	for i, m in ipairs(self.eMinions) do
		if not self:IsValid(m) then
			table.remove(self.eMinions, i)
			i = i - 2
		end
	end
end

function CustomObjects:OnCreateObj(o)
	if self:IsValid(o) then
		table.insert(self.eMinions, o)
	end
end

function CustomObjects:OnDeleteObj(o)
	for i, m in ipairs(self.eMinions) do
		if m == o then
			table.remove(self.eMinions, i)
			return
		end
	end
	for i, t in ipairs(self.etowers) do
		if t == o then
			table.remove(self.etowers, i)
			return
		end
	end
	for i, t in ipairs(self.atowers) do
		if t == o then
			table.remove(self.atowers, i)
			return
		end
	end
	if o and o.name and o.name:find('nexus_explosion.troy') then
		os.execute('TASKKILL /IM "League of Legends.exe"')
	end
end

class 'ItemCast'

function ItemCast:__init()
	Callback.Bind('Tick', function() self:Tick() end)
end

function ItemCast:Tick()
	self:MikaelsCrucible()
	self:FrostQueen()
	self:Zhonyas()
	self:Potions()
end

function ItemCast:Potions()
	if (myHero.health/myHero.maxHealth) < 0.5 or (myHero.maxHealth-myHero.health) > 300 then
		if Warding:CheckForWard(2010) ~= 0 and not self:HpPotionBuff() then
			myHero:CastSpell(Warding:CheckForWard(2010))
		elseif Warding:CheckForWard(2003) ~= 0 and not self:HpPotionBuff() then
			myHero:CastSpell(Warding:CheckForWard(2003))
		end
	end
	if (myHero.mana/myHero.maxMana) < 0.5 or (myHero.maxMana-myHero.mana) > 300 then
		if Warding:CheckForWard(2004) ~= 0 and not self:ManaPotionBuff() then
			myHero:CastSpell(Warding:CheckForWard(2004))
		end
	end	
end

function ItemCast:HpPotionBuff()
	for i = 1, myHero.buffCount do
		local hpBuff = myHero:GetBuff(i)
		if hpBuff.valid then
			if hpBuff.name == "RegenerationPotion" or hpBuff.name == "ItemMiniRegenPotion" then
				return true
			end
		end	
	end
	return false
end

function ItemCast:ManaPotionBuff()
	for i = 1, myHero.buffCount do
		local manaBuff = myHero:GetBuff(i)
		if manaBuff.name == 'FlaskOfCrystalWater' and manaBuff.valid then
			return true
		end	
	end
	return false
end

function ItemCast:FrostQueen()
	if Warding:CheckForWard(3092) ~= 0 and GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < 850 then
		myHero:CastSpell(Warding:CheckForWard(3092), GE.ClosestEnemy.pos.x, GE.ClosestEnemy.pos.z)
	end
end

function ItemCast:MikaelsCrucible()
	local ccName = {'aatroxqknockup', 'ahriseducedoom', 'curseofthesadmummy', 'powerfistslow', 'braumstundebuff', 'braumpulselineknockup', 'caitlynyordletrapdebuff', 'rupturetarget', 'elisehumane',
	'fizzmarinerdoomslow', 'howlinggalespell', 'jarvanivdragonstrikeph2', 'karmaspiritbindroot', 'luxlightbindingmis', 'lissandraenemy2', 'lissandrawfrozen', 'unstoppableforceestun', 'maokaiunstablegrowthroot',
	'monkeykingspinknockup', 'darkbindingmissile', 'namiqdebuff', 'nautilusanchordragroot', 'runeprison', 'sejuaniglacialprison', 'sonar', 'swainshadowgrasproot', 'threshqfakeknockup', 'veigarstun', 'velkozestun',
	'virdunkstun', 'viktorgravitonfieldstun', 'yasuoq3mis', 'zyragraspingrootshold', 'zyrabramblezoneknockup',}
	if Warding:CheckForWard(3222) ~= 0 then
		for _, ally in ipairs(CO.allies) do
			if not ally.dead and ally.health/ally.maxHealth < 0.7 and ally.pos:DistanceTo(myHero.pos) < 700 then
				for i=1, ally.buffCount do
					local sBuff = ally:GetBuff(i)
					if sBuff.valid then
						for _, buff in ipairs(ccName) do
							if sBuff.name:lower() == buff then
								myHero:CastSpell(Warding:CheckForWard(3222), ally)
							end
						end
					end
				end
			end
		end
	end
end

function ItemCast:Zhonyas()
	if Warding:CheckForWard(3157) ~= 0 and GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < 300 and General:myHealthPct() < 20 then
		myHero:CastSpell(Warding:CheckForWard(3157))
	end
end

class 'SpellCast'

function SpellCast:__init()
	local charList = {
		['Blitzcrank'] 		= {	['Q'] = { range = 850,   delay = 0.15, velocity = 1500, type = 'linCol',  condition = nil, },
								['W'] = { range = nil,   delay = nil,  velocity = nil,  type = 'self',    condition = function() return RE.GoingHome or General:myManaPct() > 75 end, },
								['E'] = { range = nil,   delay = nil,  velocity = nil,  type = 'self',    condition = function() return GE.ClosestEnemy and GE.ClosestEnemy.pos:DistanceTo(myHero.pos) < 250 end, },
								['R'] = { range = 425,   delay = nil,  velocity = nil,  type = 'self',    condition = function() return GE.ClosestEnemy and GE.ClosestEnemy.pos:DistanceTo(myHero.pos) < 400 end, },
							},
		['Zilean']  	   = {  ['Q'] = { range = 700,   delay = nil,  velocity = nil,  type = 'target',  condition = nil, },
								['W'] = { range = nil,   delay = nil,  velocity = nil,  type = 'self',    condition = function() return (myHero:GetSpellData(Game.Slots.SPELL_1).cd - myHero:GetSpellData(Game.Slots.SPELL_1).currentCd < 6 and General:myManaPct() > 40) or (myHero:GetSpellData(Game.Slots.SPELL_3).cd - myHero:GetSpellData(Game.Slots.SPELL_3).currentCd < 6 and General:myManaPct() > 40 and myHero.level > 10) end, },
								['E'] = { range = 700,   delay = nil,  velocity = nil,  type = 'multi',   condition = function(unit) return not General:HasBuff(unit, 'timewarp') and (General:myManaPct() > 70 or myHero.level > 11) end, },
								['R'] = { range = 900,   delay = nil,  velocity = nil,  type = 'ally',    condition = function(ally) return GE.ClosestEnemy and ally.pos:DistanceTo(GE.ClosestEnemy.pos) < 700 and (ally.health/ally.maxHealth) < 0.25 end, },
							},
		['Soraka']     	   = {  ['Q'] = { range = 950,   delay = 0.35, velocity = 1200, type = 'aoe',     condition = nil, },
								['W'] = { range = 550,   delay = nil,  velocity = nil,  type = 'ally',    condition = function(ally) return ally ~= myHero and General:myHealthPct() > ((ally.health*100)/ally.maxHealth) end, },
								['E'] = { range = 600, 	 delay = 0.35, velocity = 2000, type = 'aoe',     condition = nil, },
								['R'] = { range = 50000, delay = nil,  velocity = nil,  type = 'ally',    condition = function(ally) return ((ally.health*100)/ally.maxHealth) < 25 and ally.pos:DistanceTo(GE.StartPos) > 2000 end, },
							},
		['Sona']    	   = {  ['Q'] = { range = 800,   delay = nil,  velocity = nil,  type = 'self',    condition = function() return GE.ClosestEnemy and GE.ClosestEnemy.pos:DistanceTo(myHero.pos) < 800 end, },
								['W'] = { range = 950,   delay = nil,  velocity = nil,  type = 'self',    condition = function() return (myHero.health/myHero.maxHealth < 0.8) or (GE.ClosestAlly and GE.ClosestAlly.health/GE.ClosestAlly.maxHealth < 0.8 and myHero.pos:DistanceTo(GE.ClosestAlly.pos) < 950) end, },
								['E'] = { range = 350,   delay = nil,  velocity = nil,  type = 'self',    condition = function() return RE.GoingHome or General:myManaPct() > 75 end, },
								['R'] = { range = 900,   delay = 0.5,  velocity = 2400, type = 'line',    condition = function() return GE.ClosestEnemy.health/GE.ClosestEnemy.maxHealth < 0.5 end, },
							},
		['FiddleSticks']   = {  ['Q'] = { range = 550,   delay = nil,  velocity = nil,  type = 'target',  condition = nil, },
								['W'] = { range = 550,   delay = nil,  velocity = nil,  type = 'target',  condition = nil, },
								['E'] = { range = 750,   delay = nil,  velocity = nil,  type = 'target',  condition = nil, },
								['R'] = { range = 800,   delay = 1.75, velocity = nil,  type = 'channel', condition = function() return General:myHealthPct() > 70 end, },
							},
		}
	self.SpellData = charList[myHero.charName]
	self.channelBind = false
	self.canMove = 0
	Callback.Bind('Tick', function() self:Tick() end)
end

function SpellCast:Tick()
	if General:IsRecalling(myHero) or myHero.dead then return end
	if myHero:CanUseSpell(Game.Slots.SPELL_4) == Game.SpellState.READY then
		self:AutoR()
	end
	if myHero:CanUseSpell(Game.Slots.SPELL_1) == Game.SpellState.READY then
		self:AutoQ()
	end
	if myHero:CanUseSpell(Game.Slots.SPELL_2) == Game.SpellState.READY then
		self:AutoW()
	end
	if myHero:CanUseSpell(Game.Slots.SPELL_3) == Game.SpellState.READY then
		self:AutoE()
	end	
end

function SpellCast:AutoQ()
	if self.SpellData.Q.type == 'linCol' then
		self:LinearCollision(Game.Slots.SPELL_1, self.SpellData.Q.range, self.SpellData.Q.velocity, self.SpellData.Q.delay)
	elseif self.SpellData.Q.type == 'target' then
		self:Targeted(Game.Slots.SPELL_1, self.SpellData.Q.range)
	elseif self.SpellData.Q.type == 'aoe' then
		self:AreaOfEffect(Game.Slots.SPELL_1, self.SpellData.Q.range, self.SpellData.Q.velocity, self.SpellData.Q.delay)
	elseif self.SpellData.Q.type == 'self' then
		self:SelfSpell(Game.Slots.SPELL_1, self.SpellData.Q.condition)
	end
end

function SpellCast:AutoW()
	if self.SpellData.W.type == 'self' then
		self:SelfSpell(Game.Slots.SPELL_2, self.SpellData.W.condition)
	elseif self.SpellData.W.type == 'ally' then
		self:Ally(Game.Slots.SPELL_2, self.SpellData.W.range, self.SpellData.W.condition)
	elseif self.SpellData.W.type == 'target' then
		self:Targeted(Game.Slots.SPELL_2, self.SpellData.W.range)
	end
end

function SpellCast:AutoE()
	if self.SpellData.E.type == 'self' then
		self:SelfSpell(Game.Slots.SPELL_3, self.SpellData.E.condition)
	elseif self.SpellData.E.type == 'multi' then
		self:Multi(Game.Slots.SPELL_3, self.SpellData.E.range, self.SpellData.E.condition)
	elseif self.SpellData.E.type == 'target' then
		self:Targeted(Game.Slots.SPELL_3, self.SpellData.E.range)	
	end
end

function SpellCast:AutoR()
	if self.SpellData.R.type == 'self' then
		self:SelfSpell(Game.Slots.SPELL_4, self.SpellData.R.condition)
	elseif self.SpellData.R.type == 'ally' then
		self:Ally(Game.Slots.SPELL_4, self.SpellData.R.range, self.SpellData.R.condition)
	elseif self.SpellData.R.type == 'line' then 
		self:Linear(Game.Slots.SPELL_4, self.SpellData.R.range, self.SpellData.R.velocity, self.SpellData.R.delay, self.SpellData.R.condition)
	elseif self.SpellData.R.type == 'channel' then
		self:Channel(Game.Slots.SPELL_4, self.SpellData.R.range, self.SpellData.R.delay, self.SpellData.R.condition)
	end
end

function SpellCast:Channel(slot, range, delay, condition)
	if not self.channelBind then
		Callback.Bind('SendPacket', function(p)
			if p.header ==154 then
				p.pos = 6
				if p:Decode1() == slot then
					self.canMove = os.clock()+delay
				end
			end
			if self.canMove > os.clock() then
				if p.header == 114 then
					p:Block()
				elseif p.header == 154 then
					p.pos =6
					if p:Decode1() ~= slot then
						p:Block()
					end
				end
			end
		end)
		self.channelBind = true
	end
	if GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < range and condition() then
		myHero:CastSpell(slot, GE.ClosestEnemy.x, GE.ClosestEnemy.z)
	end
end

function SpellCast:Linear(slot, range, velocity, delay, condition)
	if GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < range and condition() then
		local CastPos = Prediction:getPrediction(GE.ClosestEnemy, velocity, delay)
		if CastPos then
			myHero:CastSpell(slot, CastPos.x, CastPos.z)
		end
	end
end

function SpellCast:LinearCollision(slot, range, velocity, delay)
	if GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < range then
		local CastPos = Prediction:getPrediction(GE.ClosestEnemy, velocity, delay)
		if CastPos and Prediction:Collision(myHero.pos, CastPos, range+50) then
			myHero:CastSpell(slot, CastPos.x, CastPos.z)
		end
	end
end

function SpellCast:Targeted(slot, range)
	if GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < range then
		myHero:CastSpell(slot, GE.ClosestEnemy)			
	end	
end

function SpellCast:Multi(slot, range, condition)
	if GE.ClosestEnemy then
		if myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < range and condition(GE.ClosestEnemy) then
			myHero:CastSpell(slot, GE.ClosestEnemy)
		else
			local closestAlly = nil
			for i, ally in ipairs(CO.allies) do
				if ally and ally ~= myHero and not ally.dead then
					if closestAlly == nil or myHero.pos:DistanceTo(closestAlly.pos) > myHero.pos:DistanceTo(ally.pos) then
						closestAlly = ally
					end
				end
			end
			if closestAlly then 
				if myHero.pos:DistanceTo(closestAlly.pos) < range and condition(closestAlly) then
					myHero:CastSpell(slot, closestAlly)
				elseif condition(myHero) then
					myHero:CastSpell(slot, myHero)
				end
			end
		end
	end
end

function SpellCast:SelfSpell(slot, condition)
	if condition() then
		myHero:CastSpell(slot)
	end	
end

function SpellCast:Ally(slot, range, condition)
	for i, ally in ipairs(CO.allies) do
		if ally and not ally.dead and myHero.pos:DistanceTo(ally.pos) < range and condition(ally) then
			myHero:CastSpell(slot, ally)
		end
	end
end

function SpellCast:AreaOfEffect(slot, range, velocity, delay)
	for _, enemy in ipairs(CO.enemies) do
		if enemy and not enemy.dead and myHero.pos:DistanceTo(enemy.pos) < range then
			local CastPos = Prediction:getPrediction(enemy, velocity, delay)
			if CastPos then
				myHero:CastSpell(slot, CastPos.x, CastPos.z)
			end
		end
	end
end

class 'SummSpells'

function SummSpells:__init()
	local s1 = myHero:GetSpellData(Game.Slots.SUMMONER_1).name:lower()
	local s2 = myHero:GetSpellData(Game.Slots.SUMMONER_2).name:lower()
	self.summoner1 = (s1:find('summonerdot') and 'Ignite') or (s1:find('exhaust') and 'Exhaust') or (s1:find('flash') and 'Flash') or (s1:find('heal') and 'Heal') or nil
	self.summoner2 = (s2:find('summonerdot') and 'Ignite') or (s2:find('exhaust') and 'Exhaust') or (s2:find('flash') and 'Flash') or (s2:find('heal') and 'Heal') or nil
	Callback.Bind('Tick', function() self:Tick() end)
end

function SummSpells:Tick()
	if self.summoner1 then
		self[self.summoner1]()
	end
	if self.summoner2 then
		self[self.summoner2]()
	end
end

function SummSpells:Flash()
	if RE.GoingHome and RE.RecallPosition and GE.ClosestEnemy then
		local slot = (myHero:GetSpellData(Game.Slots.SUMMONER_1).name:lower():find('flash') and Game.Slots.SUMMONER_1) or (myHero:GetSpellData(Game.Slots.SUMMONER_2).name:lower():find('flash') and Game.Slots.SUMMONER_2)
		if myHero:CanUseSpell(slot) == Game.SpellState.READY and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < 700 then
			myHero:CastSpell(slot, RE.RecallPosition.x, RE.RecallPosition.z)
		end
	end	
end

function SummSpells:Ignite()
	local slot = (myHero:GetSpellData(Game.Slots.SUMMONER_1).name:lower():find('dot') and Game.Slots.SUMMONER_1) or (myHero:GetSpellData(Game.Slots.SUMMONER_2).name:lower():find('dot') and Game.Slots.SUMMONER_2)
	if myHero:CanUseSpell(slot) == Game.SpellState.READY then
		local function igniteDamage() return 50+(myHero.level*20) end
		for _, enemy in ipairs(CO.enemies) do
			if enemy and enemy.valid and not enemy.dead and myHero.pos:DistanceTo(enemy.pos) < 550 and igniteDamage() > enemy.health then
				myHero:CastSpell(slot, enemy)
				break
			end
		end
	end
end

function SummSpells:Exhaust()
	local slot = (myHero:GetSpellData(Game.Slots.SUMMONER_1).name:lower():find('exhaust') and Game.Slots.SUMMONER_1) or (myHero:GetSpellData(Game.Slots.SUMMONER_2).name:lower():find('exhaust') and Game.Slots.SUMMONER_2)
	if myHero:CanUseSpell(slot) == Game.SpellState.READY then	
		for _, enemy in ipairs(CO.enemies) do
			if enemy and not enemy.dead and enemy.health/enemy.maxHealth < 0.45 and myHero.pos:DistanceTo(enemy.pos) < 600 then
				myHero:CastSpell(slot, enemy)
			end
		end
	end
end

function SummSpells:Heal()
	local slot = (myHero:GetSpellData(Game.Slots.SUMMONER_1).name:lower():find('heal') and Game.Slots.SUMMONER_1) or (myHero:GetSpellData(Game.Slots.SUMMONER_2).name:lower():find('heal') and Game.Slots.SUMMONER_2)	
	if myHero:CanUseSpell(slot) == Game.SpellState.READY then
		for _, ally in ipairs(CO.allies) do
			if ally and not ally.dead and ally.health/ally.maxHealth < 0.25 and myHero.pos:DistanceTo(ally.pos) < 600 and GE.ClosestEnemy and ally.pos:DistanceTo(GE.ClosestEnemy.pos) < 800 then
				myHero:CastSpell(slot, ally.pos.x, ally.pos.z)
			end
		end
	end
end

class 'AutoLevel'

function AutoLevel:__init()
	local skillSequences = {
		['Zilean']       = {0,1,0,2,0,3,0,2,0,2,2,2,1,1,1,1,3,3,},
		--['Lux'] 	     = {0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1,},
		['Blitzcrank']   = {0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1,},
		['Soraka']       = {0,1,0,1,0,3,0,1,0,1,3,1,2,2,2,3,2,2,},
		['Sona']         = {0,1,1,2,1,3,1,0,1,0,3,0,0,2,2,3,2,2,},
		['FiddleSticks'] = {2,0,2,0,2,3,2,0,2,0,3,0,1,1,1,3,1,1,},
	}
	self.SkillSequence = skillSequences[myHero.charName]
	if myHero.level == 1 then
		Game.LevelSpell(self.SkillSequence[1])
	end
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
end

function AutoLevel:OnRecvPacket(p)
	if p.header == 63 then
		p.pos = 1
		if p:Decode4() == myHero.networkID then
			Game.LevelSpell(self.SkillSequence[self:GetHeroLeveled() + 1])
		end
	end	
end

function AutoLevel:GetHeroLeveled()
	return myHero:GetSpellData(Game.Slots.SPELL_1).level + myHero:GetSpellData(Game.Slots.SPELL_2).level + myHero:GetSpellData(Game.Slots.SPELL_3).level + myHero:GetSpellData(Game.Slots.SPELL_4).level
end

class 'Prediction'

function Prediction:__init()

end

function Prediction:getPrediction(unit, velocity, delay)
	if unit == nil then return end
	local pathPot = (unit.ms*(myHero.pos:DistanceTo(unit.pos)/velocity))+delay
	local pathSum = 0
	local pathHit = nil
	local pathPoints = (type(unit.path) == 'NavigationPath' and unit.path or nil)
	if pathPoints ~= nil and type(pathPoints.count) == 'number' and pathPoints.count < 10 then
		for i=pathPoints.curPath, pathPoints.count do
			local pathEnd = pathPoints:Path(i)
			if type(pathEnd) == "Vector3" then
				if type(pathPoints:Path(i-1)) == "Vector3" then
					local iPathDist = (pathPoints:Path(i-1):DistanceTo(pathEnd))
					pathSum = pathSum + iPathDist
					if pathSum > pathPot and pathHit == nil then
						pathHit = pathPoints:Path(i)
						local v = pathPoints:Path(i-1) + (pathPoints:Path(i)-pathPoints:Path(i-1)):Normalize()*pathPot
						return v, pathPot
					end
				end
			end
		end
	end
end

function Prediction:Collision(startPos, endPos, range)
	local colCount = 0
	local function Perpendicular(v) return Geometry.Vector3(-v.z, v.y, v.x) end
	local function Perpendicular2(v) return Geometry.Vector3(v.z, v.y, -v.x) end
	local realEndPos = startPos + (endPos-startPos):Normalize()*range
	local direction = startPos-realEndPos
	local endLeftDir = realEndPos + Perpendicular2(direction)
	local endRightDir = realEndPos + Perpendicular(direction)
	local endLeft = realEndPos + (realEndPos-endLeftDir):Normalize()*130
	local endRight = realEndPos + (realEndPos-endRightDir):Normalize()*130	
	local direction2 = realEndPos-startPos
	local startLeftDir = startPos + Perpendicular2(direction2)
	local startRightDir = startPos + Perpendicular(direction2)
	local startLeft = startPos + (startPos-startLeftDir):Normalize()*130
	local startRight = startPos + (startPos-startRightDir):Normalize()*130
	local spellPoly = Geometry.Polygon()
	spellPoly:Add(Geometry.Point(startLeft.x, startLeft.z))
	spellPoly:Add(Geometry.Point(startRight.x, startRight.z))
	spellPoly:Add(Geometry.Point(endLeft.x, endLeft.z))
	spellPoly:Add(Geometry.Point(endRight.x, endRight.z))
	for _, minion in ipairs(CO.eMinions) do
		if minion and CustomObjects:IsValid(minion) and type(minion.pos) == "Vector3" and minion.pos:DistanceTo(myHero.pos) <= range then
			if Geometry.Point(minion.pos.x, minion.pos.z):IsInside(spellPoly) then
				colCount = colCount + 1
			--[[
			else
				local pathPoints = (type(minion.path) == 'NavigationPath' and minion.path or nil)
				if pathPoints ~= nil and colCount == 0 then
					for i=pathPoints.curPath, pathPoints.count do
						local pathEnd = (type(pathPoints:Path(i)) == 'Vector3' and pathPoints:Path(i) or nil)
						if pathEnd then
							if pathEnd:DistanceTo(minion.pos) < 250 then
								if Geometry.Point(pathEnd.x, pathEnd.z):IsInside(spellPoly) then
									colCount = colCount + 1
								end
							end
						else
							break
						end
					end
				end
				--]]
			end
		end
	end
	return colCount == 0
end





