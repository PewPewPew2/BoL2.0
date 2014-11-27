local clickDraw = {pos=nil, color='green'}
local CO, SC, FO, RE, WA, SA, AB, GE, IC, AL, SS
Callback.Bind('Load', function() Callbacks() end)

class 'Follow'
function Follow:__init() 
	self.Target = {Primary = nil, Secondary = nil}
	self.tickTime = 0
	self.mostFedTime = 1600
	self.PrimaryLastMove = 0
	self.lastAction = 0
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
	Callback.Bind('ProcessSpell', function(unit, spell) self:ProcessSpell(unit, spell) end)
end

function Follow:Tick()
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
		FO.Target.Primary = LastCandidate
		General:Print('Primary - '..LastCandidate.charName)
	else
		self:getPrimaryBackup()
	end
end

function Follow:getPrimaryBackup()
	if Game.Timer() < 80 then 
		--self:getPrimaryBackup()
	return end
	local FromBottom = Geometry.Vector3(12321, 54, 1643)
	local closest = nil
	for _, ally in ipairs(CO.allies) do
		if ally and self:smiteCheck(ally) then
			if closest == nil or ally.pos:DistanceTo(FromBottom) < closest.pos:DistanceTo(FromBottom) then
				closest = ally
			end
		end
	end		
	FO.Target.Primary = closest
	General:Print('Primary - '..closest.charName)
end

function Follow:smiteCheck(ally)
	return ally:GetSpellData(Game.Slots.SUMMONER_1).name:lower():find('smite') == nil and ally:GetSpellData(Game.Slots.SUMMONER_2).name:lower():find('smite') == nil
end

function Follow:moveToBotLane()
	if myHero.team == 100 and myHero.pos:DistanceTo(GE.StartPos) < 600 then
		myHero:Move(9865, 1090)
	elseif myHero.team == 200 and myHero.pos:DistanceTo(GE.StartPos) < 600 then
		myHero:Move(12850, 4200)
	end	
end

function Follow:HugTurret()
	if Game.Timer() > 1300 then return end
	for i, turret in ipairs(CO.atowers) do
		Core.OutputDebugString(tostring(i))
		if turret and not turret.dead and turret.valid and turret.name and turret.name:find('R_03') and turret.health and turret.health > 400 then
			FO.Target.Secondary = turret
			return
		end
	end
	FO.Target.Secondary = nil
end

function Follow:ProcessSpell(unit, spell)
	if unit and unit == FO.Target.Primary then
		FO.PrimaryLastMove = os.clock()
	end
end

function Follow:OnRecvPacket(p)
	if p.header == 97 and FO.Target.Primary then
		p.pos = 12
		if p:Decode4() == FO.Target.Primary.networkID then
			FO.PrimaryLastMove = os.clock()
		end
	end	
end

class 'Recall'

function Recall:__init()
	self.RecallPosition = nil
	self.GoingHome = false
end

function Recall:Tick()
	if self:ShouldRecall() and RE.RecallPosition == nil and not RE.GoingHome then
		self:GetSafeRecallPos()
		RE.GoingHome = true
	end
	if myHero.pos:DistanceTo(GE.StartPos) < 700 and (myHero.health/myHero.maxHealth) >= 0.9 and (myHero.mana/myHero.maxMana) >= 0.9 then
		RE.GoingHome = false
		RE.RecallPosition = nil
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
		RE.RecallPosition = SafeSpot
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
	local asc = General:ActionSpamCheck()
	if myHero.dead then return end
	if RE.RecallPosition then 
		if myHero.pos:DistanceTo(RE.RecallPosition) < 100 then
			if self:RecallSafetyCheck() then
				myHero:CastSpell(Game.Slots.RECALL)
			else
				self:GetSafeRecallPos()
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
				table.insert(WA.wardPositions, #WA.wardPositions+1, { pos = v3, id = wardID })
			end
		end
	end		
	if p.header == 158 then
		p.pos = 1
		local wardId = p:Decode4()
		for i=1, #WA.wardPositions do
			if WA.wardPositions[i] and WA.wardPositions[i].id and WA.wardPositions[i].id == wardId then
				table.remove(WA.wardPositions, i)
				break
			end
		end
	end
end
				
function Warding:Tick()
	local currentTime = os.clock()
	if (WA.LastWard+4) > currentTime then return end
	
	local WardSlot = self:GetWardSlot()
	if WardSlot then
		for i=1, #WA.wardSpots do 
			local spot = Geometry.Vector3(WA.wardSpots[i].x, WA.wardSpots[i].y, WA.wardSpots[i].z)
			if spot and myHero.pos:DistanceTo(spot) <= 600 then
				local wardNear = nil
				for i=1, #WA.wardPositions do
					local ward = WA.wardPositions[i]
					if ward then
						if wardNear == nil or spot:DistanceTo(ward.pos) < spot:DistanceTo(wardNear.pos) then
							wardNear = ward
						end
					end
				end			
				if wardNear == nil or (wardNear and spot:DistanceTo(wardNear.pos) > 1200) then  			
					FO.lastAction = os.clock()
					myHero:CastSpell(WardSlot, spot.x, spot.z)
					WA.LastWard = os.clock()
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
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
end

function Safety:AvoidTowers()
	if SA.HaveTowerAgro and SA.EscapeTurret ~= nil then
		local EscapeTo = General:GetClosestTurret(myHero, myHero.team)
		if EscapeTo then 
			myHero:Move(EscapeTo.x, EscapeTo.z)
			FO.lastAction = os.clock()
		end
	end
end

function Safety:InDanger()
	-- or SA.DragonAggro or SA.BaronAggro
	return SA.HaveTowerAgro or SA.HeroAggro >= 1 or SA.MinionAggro >= (myHero.level+1) or SA.FallBackPing > os.clock() or (GE.ClosestEnemy ~= nil and not GE.ClosestEnemy.dead and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < 250) or SA.MinionAggro >= (myHero.level+1)
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
		if o.name:lower():find('minion') then
			if aggro >= 20 then
				SA.MinionAggro = SA.MinionAggro + 1
			elseif SA.MinionAggro ~= 0 then
				if not o.visible or aggro == 0 then
					SA.MinionAggro = SA.MinionAggro - 1
				end
			end
		end
		--[[if o.name == 'Dragon6.1.1' then
			if aggro == 29 then
				SA.DragonAggro = true
			elseif aggro == 0 or not o.visible then
				SA.DragonAggro = false
			end
		end
		if o.name == 'Worm12.1.1' then
			if aggro == 29 then
				SA.BaronAggro = true
			elseif aggro == 0 or not o.visible then
				SA.BaronAggro = false
			end
		end--]]
		if o.name:lower():find('turret') then
			if aggro >= 20 then
				SA.HaveTowerAgro = true
				SA.EscapeTurret = General:GetClosestTurret(myHero, 0)
			elseif aggro == 0 or not o.visible then
				SA.HaveTowerAgro = false
				SA.EscapeTurret = nil
			end
		end
		if o.type == myHero.type then
			if aggro >= 20 then
				SA.HeroAggro = SA.HeroAggro + 1
			elseif aggro == 0 or not o.visible then
				SA.HeroAggro = SA.HeroAggro - 1
			end
		end
	end
	if p.header == 64 then
		p.pos = 5
		if myHero.pos:DistanceTo(Geometry.Vector3(p:DecodeF(), 0 , p:DecodeF())) < 1200 then		
			p.pos = 21
			local pType = p:Decode1()
			if pType == 5 or pType == 2 then
				SA.FallBackPing = os.clock() + 2
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
end

function AutoBuy:TableInit()
	if myHero.charName == 'Lux' or myHero.charName == 'Morgana' then
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
	elseif myHero.charName == 'Zilean' or myHero.charName == 'Sona' then
		self.BuyList = {
			[1] = {itemID = 3303, haveBought = false, name = 'Spellthief'}, --1
			[2] = {itemID = 3340, haveBought = false, name = 'WardTrinket'},
			[3] = {itemID = 1027, haveBought = false, name = 'ManaCrystal'}, --2
			[4] = {itemID = 3070, haveBought = false, name = 'Tear'},			
			[5] = {itemID = 1028, haveBought = false, name = 'RubyCrystal'}, --3
			[6] = {itemID = 2049, haveBought = false, name = 'Sightstone'},
			[7] = {itemID = 1001, haveBought = false, name = 'BootsT1'}, --4
			[8] = {itemID = 3098, haveBought = false, name = 'FrostFang'}, 
			[9] = {itemID = 3028, haveBought = false, name = 'Chalice'}, --5
			[10] = {itemID = 3092, haveBought = false, name = 'FrostQueen'},
			[11] = {itemID = 3114, haveBought = false, name = 'ForbiddenIdol'},
			[12] = {itemID = 3111, haveBought = false, name = 'MercTreads'},
			[13] = {itemID = 3222, haveBought = false, name = 'Crucible'},
			[14] = {itemID = 2045, haveBought = false, name = 'RubySightstone'},
			[15] = {itemID = 3362, haveBought = false, name = 'TrinketT2'},
			[16] = {itemID = 3024, haveBought = false, name = 'Glacial'}, --6
			[17] = {itemID = 3110, haveBought = false, name = 'FrozenHeart'},
			[18] = {itemID = 3007, haveBought = false, name = 'ArchStaff'},	
			[19] = {itemID = 3275, haveBought = false, name = 'Homeguard'},
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
		for i=1, #AB.BuyList do
			if self:CheckForItem(AB.BuyList[i].itemID) ~= 0 then
				AB.BuyList[i].haveBought = true				
			elseif not AB.BuyList[i].haveBought and (i == 1 or AB.BuyList[i-1].haveBought) then			
				Game.BuyItem(AB.BuyList[i].itemID)
				AB.LastBuy = os.clock() + 0.25
			end
		end
	end
end

function AutoBuy:Potions()
	if os.clock() < 1200 then
		if self:CheckForItem(2003) == 0 and AB.LastHpBuy < os.clock() then 
			Game.BuyItem(2003)
			AB.LastHpBuy = os.clock() + 2
		end	
		if self:CheckForItem(2004) == 0 and AB.LastManaBuy < os.clock() then 
			Game.BuyItem(2004)
			AB.LastManaBuy = os.clock() + 2
		end	
	end
end

function AutoBuy:TimeCheck()
	return AB.LastBuy < os.clock()
end

function AutoBuy:ReloadCheck()
	for i=#AB.BuyList, 1, -1 do
		if AB.BuyList[i].itemID ~= nil and self:CheckForItem(AB.BuyList[i].itemID) ~= 0 then
			AB.BuyList[i].haveBought = true
			for j=i, 1, -1 do
				AB.BuyList[j].haveBought = true
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
	self.StayInBrush = false
	self.StartPos = nil
	self.killCount = {}
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
	Callback.Bind('SendPacket', function(p) self:OnSendPacket(p) end)
end

function General:Tick()
	GE.ClosestEnemy = self:GetClosestEnemyHero()
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
	if GE.ClosestEnemy == nil or (GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) > 400) then
		if FO.Target.Primary and Game.IsGrass(FO.Target.Primary.pos) then
			GE.StayInBrush = true
			return
		end
	end	
	GE.StayInBrush = false
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
		if killer.team == myHero.team then
			for name, kills in pairs(GE.killCount) do
				if name == killer.name then
					GE.killCount[name] = kills+1
					return
				end
			end
			GE.killCount[killer.name] = 1
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
		local object = Game.Object(i)
		if object then
			if object.type == 'obj_AI_Turret' then
				if object.team == myHero.team then
					table.insert(self.atowers, #self.atowers+1, object)
				else
					table.insert(self.etowers, #self.etowers+1, object)
				end
			end
			if self:IsValid(object) then 
				table.insert(self.eMinions, object)
			end			
		end
	end
	for i=1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero and hero.team == myHero.team then
			table.insert(self.allies, #self.allies+1, hero)
		else
			table.insert(self.enemies, #self.enemies+1, hero)
		end
	end
	Callback.Bind('Tick', function() self:OnTick()	end)
	Callback.Bind('CreateObj', function(o) self:OnCreateObj(o) end)
	Callback.Bind('DeleteObj', function(o) self:OnDeleteObj(o) end)	
end

function CustomObjects:IsValid(obj)
	return obj and obj.valid and not obj.dead and obj.health > 0 and obj.type:find("Minion") and obj.charName and obj.charName ~= "TestCubeRender" and obj.team ~= myHero.team and obj.name 
end

function CustomObjects:OnTick()
	for i, m in ipairs(CO.eMinions) do
		if not self:IsValid(m) then
			table.remove(CO.eMinions, i)
			i = i - 2
		end
	end
end

function CustomObjects:OnCreateObj(o)
	if self:IsValid(o) then
		table.insert(CO.eMinions, o)
	end
end

function CustomObjects:OnDeleteObj(o)
	for i, m in ipairs(CO.eMinions) do
		if m == o then
			table.remove(CO.eMinions, i)
			return
		end
	end
	for i, t in ipairs(CO.etowers) do
		if t == o then
			table.remove(CO.etowers, i)
			return
		end
	end
	for i, t in ipairs(CO.atowers) do
		if t == o then
			table.remove(CO.atowers, i)
			return
		end
	end
	if o and o.name and o.name:find('nexus_explosion.troy') then
		os.execute('TASKKILL /IM "League of Legends.exe"')
	end
end

class 'Callbacks'

function Callbacks:__init()
	Callback.Bind('GameStart', function() self:OnGameStart() end)
end

function Callbacks:OnGameStart()
	CO = CustomObjects()
	SC = SpellCast()
	FO = Follow()
	RE = Recall()
	WA = Warding()
	SA = Safety()
	AB = AutoBuy()
	GE = General()
	IC = ItemCast()
	AL = AutoLevel()
	SS = SummSpells()
	
	GE.StartPos = (myHero.team == 100) and Geometry.Vector3(200, 90, 500) or Geometry.Vector3(13945, 90, 14210)
	
	Menu = MenuConfig('Follower')
	Menu:KeyBinding('fFollow', 'Force On Selected', 'T')
		
	Follow:moveToBotLane()
	Follow:getPrimary()
	AutoBuy:ReloadCheck()
	
	Callback.Bind('Tick', function() self:OnTick() end)
	Callback.Bind('Draw', function() self:OnDraw() end)
	Callback.Bind('WndMsg', function(msg, key) self:OnWndMsg(msg, key) end)
	General:Print('Loaded')
end

function Callbacks:OnTick()
	General:Tick()
	--Core.OutputDebugString('General')
	SpellCast:Tick()
	--Core.OutputDebugString('SpellCast')
	ItemCast:Tick()
	--Core.OutputDebugString('ItemCast')
	Recall:Tick()
	--Core.OutputDebugString('Recall')
	SummSpells:Tick()
	--Core.OutputDebugString('SummonerSpells')
	AutoBuy:Tick()
	--Core.OutputDebugString('AutoBuy')
	if RE.GoingHome then Recall:CastRecall() return end
	--Core.OutputDebugString('CastRecall')
	Safety:AvoidTowers()
	--Core.OutputDebugString('AvoidTowers')
	if Safety:InDanger() then Safety:Fallback() return end
	--Core.OutputDebugString('Fallback')
	Follow:Tick()
	--Core.OutputDebugString('Follow')
	Warding:Tick()	
	--Core.OutputDebugString('Warding')
end

function Callbacks:OnDraw()
	if FO.Target.Primary ~= nil then
		Graphics.DrawCircle(FO.Target.Primary.x, FO.Target.Primary.y, FO.Target.Primary.z, 100, Graphics.ARGB(0xFF,0,0xFF,0))
	end
	if FO.Target.Secondary ~= nil then
		Graphics.DrawCircle(FO.Target.Secondary.x, FO.Target.Secondary.y, FO.Target.Secondary.z, 100, Graphics.ARGB(0xFF,0,0,0xFF))
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

function Callbacks:OnWndMsg(m, k)
	if k == string.byte(Menu.fFollow:Value()) and m == 256 then
		local sAlly = Game.Target()
		if sAlly and sAlly.type == myHero.type and sAlly.team == myHero.team then
			FO.Target.Primary = sAlly
			General:Print('Primary Manually set to: '..sAlly.charName)
		end
	end
	if k == string.byte('X') and m == 256 then
		General:Print(tostring(mousePos.x).."   "..tostring(mousePos.z))
	end
end

class 'ItemCast'

function ItemCast:__init()
	
end

function ItemCast:Tick()
	self:MikaelsCrucible()
	self:FrostQueen()
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

class 'SpellCast'

function SpellCast:__init()
	self.SpellData = { qRange = 700, eRange = 700, rRange = 900, }
end

function SpellCast:Tick()
	if General:IsRecalling(myHero) then return end
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
	if GE.ClosestEnemy and myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < SC.SpellData.qRange then
		myHero:CastSpell(Game.Slots.SPELL_1, GE.ClosestEnemy)			
	end
end

function SpellCast:AutoW()
	if myHero:GetSpellData(Game.Slots.SPELL_1).cd - myHero:GetSpellData(Game.Slots.SPELL_1).currentCd < 6 and General:myManaPct() > 40 then
		myHero:CastSpell(Game.Slots.SPELL_2)
	elseif myHero:GetSpellData(Game.Slots.SPELL_3).cd - myHero:GetSpellData(Game.Slots.SPELL_3).currentCd < 6 and General:myManaPct() > 40 and myHero.level > 10 then
		myHero:CastSpell(Game.Slots.SPELL_2)
	end	
end

function SpellCast:AutoE()
	if GE.ClosestEnemy and (General:myManaPct() > 70 or myHero.level > 11) then
		if myHero.pos:DistanceTo(GE.ClosestEnemy.pos) < SC.SpellData.eRange then
			myHero:CastSpell(Game.Slots.SPELL_3, GE.ClosestEnemy)
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
				if myHero.pos:DistanceTo(closestAlly.pos) < SC.SpellData.eRange and not self:HasEBuff(closestAlly) then
					myHero:CastSpell(Game.Slots.SPELL_3, closestAlly)
				elseif not self:HasEBuff(myHero) then
					myHero:CastSpell(Game.Slots.SPELL_3, myHero)
				end
			end
		end
	end
end

function SpellCast:AutoR()
	for i, ally in ipairs(CO.allies) do
		if ally and not ally.dead and (ally.health/ally.maxHealth) < 0.2 and myHero.pos:DistanceTo(ally.pos) < SC.SpellData.rRange and GE.ClosestEnemy and ally.pos:DistanceTo(GE.ClosestEnemy.pos) < 700 then
			myHero:CastSpell(Game.Slots.SPELL_4, ally)
		end
	end	
end

function SpellCast:HasEBuff(unit)
	for i = 1, unit.buffCount do
		eBuff = unit:GetBuff(i)
		if eBuff.valid then
			if eBuff.name:lower():find('timewarp') then
				return true
			end
		end	
	end
	return false
end

class 'SummSpells'

function SummSpells:__init()
	local s1 = myHero:GetSpellData(Game.Slots.SUMMONER_1).name:lower()
	local s2 = myHero:GetSpellData(Game.Slots.SUMMONER_2).name:lower()
	self.summoner1 = (s1:find('summonerdot') and 'Ignite') or (s1:find('exhaust') and 'Exhaust') or (s1:find('flash') and 'Flash') or (s1:find('heal') and 'Heal') or nil
	self.summoner2 = (s2:find('summonerdot') and 'Ignite') or (s2:find('exhaust') and 'Exhaust') or (s2:find('flash') and 'Flash') or (s2:find('heal') and 'Heal') or nil
end

function SummSpells:Tick()
	if SS.summoner1 then
		self[SS.summoner1]()
	end
	if SS.summoner2 then
		self[SS.summoner2]()
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
	if myHero.charName == 'Zilean' then
		self.SkillSequence = {0,1,0,2,0,3,0,2,0,2,2,2,1,1,1,1,3,3}
		if myHero.level == 1 then
			Game.LevelSpell(self.SkillSequence[1])
		end					
	elseif myHero.charName == 'Lux' then
		self.SkillSequence = {0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1}
		if myHero.level == 1 then
			Game.LevelSpell(self.SkillSequence[1])
		end							
	end
	Callback.Bind('RecvPacket', function(p) self:OnRecvPacket(p) end)
end

function AutoLevel:OnRecvPacket(p)
	if p.header == 63 then
		p.pos = 1
		if p:Decode4() == myHero.networkID then
			Game.LevelSpell(AL.SkillSequence[self:GetHeroLeveled() + 1])
		end
	end	
end

function AutoLevel:GetHeroLeveled()
	return myHero:GetSpellData(Game.Slots.SPELL_1).level + myHero:GetSpellData(Game.Slots.SPELL_2).level + myHero:GetSpellData(Game.Slots.SPELL_3).level + myHero:GetSpellData(Game.Slots.SPELL_4).level
end
