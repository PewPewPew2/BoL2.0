Callback.Bind('Load', function() Callbacks.OnLoad() end)

Follow = {
	["Target"] = {Primary = nil, Secondary = nil},
	["Control"] = {tickTime = 0, lastAction = 0},
	["Tick"] = function()
					if Recall.Control.GoingHome then return end
					Follow.Control.tickTime = Game.Timer()
					
					if Follow.Target.Primary ~= nil and Follow.allyInBase(Follow.Target.Primary) or General.AFKCheck() then
						if Follow.Target.Secondary == nil or Follow.allyInBase(Follow.Target.Secondary) then
							Follow.getSecondary()
						elseif Follow.Target.Secondary ~= nil then
							Follow.Pursue(Follow.Target.Secondary)
						--[[PUT WARD ROAMING HERE]]
						end
					elseif Follow.Target.Primary then
						Follow.Pursue(Follow.Target.Primary)
						Follow.Target.Secondary = nil
					end
				end,
	["Allow"] = function(ally)
					if ally.dead or General.IsRecalling(ally) then 
						return false 
					elseif myHero:DistanceTo(ally) > 625 then
						if General.Control.StartPos and ally:DistanceTo(General.Control.StartPos) < 3800 then
							return false
						else
							return true
						end
					else 
						return false
					end
				end,
	["Pursue"] = function(ally)
					local asc = General.ActionSpamCheck()
					if asc > 2.2 then			
						local r = math.random(-350, 350)
						local v3b = Geometry.Vector3(ally.x+r, ally.y, ally.z+r) + Geometry.Vector3(ally.x-myHero.x, ally.y-myHero.y, ally.z-myHero.z):Normalize()*math.random(350, 600)
						if v3b then
							myHero:Move(v3b.x, v3b.z)
							Follow.Control.lastAction = Game.Timer()
							--Game.ShowCursorClick(v3c, true)
						end
					elseif asc > 0.7 then
						Follow.autoAttack()
					elseif asc > 0.4 then
						if Follow.Allow(ally) then
							local r = math.random(-225, 225)
							local v3a = Geometry.Vector3(ally.x+r, ally.y, ally.z+r) + Geometry.Vector3(ally.x-myHero.x, ally.y-myHero.y, ally.z+-myHero.z):Normalize()*math.random(400, 850)
							if v3a then	
								myHero:Move(v3a.x, v3a.z)
								Follow.Control.lastAction = Game.Timer()
								--Game:ShowCursorClick(v3a)
							end			
						end
					end
				end,
	["autoAttack"] = function()
					for i=1, Game.HeroCount() do		
						local obj = Game.Hero(i)
						if obj and obj.valid and obj.visible and obj.team ~= myHero.team and myHero:DistanceTo(obj) < myHero.range and not obj.dead then
							myHero:Attack(obj)
							Follow.Control.lastAction = Follow.Control.tickTime
							--Game.ShowCursorClick(Geometry.Vector3(obj.x, obj.y, obj.z), true)
						end
					end					
					for i=CustomObjects.iter.itower, CustomObjects.iter.ntower do
						if obj and obj.type == "obj_AI_Turret" and obj.team ~= myHero.team and obj.valid and obj.visible and myHero:DistanceTo(obj) < myHero.range and (obj.health/obj.maxHealth) > 0.05 then
							myHero:Attack(obj)
							Follow.Control.lastAction = Follow.Control.tickTime
							--Game.ShowCursorClick(Geometry.Vector3(obj.x, obj.y, obj.z), true)						
						end
					end
					if myHero.level == 1 or myHero.level >= 11 then
						for i=CustomObjects.iter.iEminion, CustomObjects.iter.nEminion do
							local obj = Game.Object(i)
							if obj and obj.type == "obj_AI_Minion" and obj.team ~= myHero.team and obj.valid and obj.visible and myHero:DistanceTo(obj) < myHero.range and not obj.dead and obj.health > 200 then
								myHero:Attack(obj)
								Follow.Control.lastAction = Follow.Control.tickTime
								--Game.ShowCursorClick(Geometry.Vector3(obj.x, obj.y, obj.z), true)
							end
						end
					end
				end,
	["allyInBase"] = function(ally)
					if ally.dead or ally:DistanceTo(General.Control.StartPos) < 1200 or General.IsRecalling(ally) then
						return true
					else
						return false
					end
				end,
	["getSecondary"] = function()
					local allyClosest = nil
					for i=1, Game.HeroCount() do
						local ally = Game.Hero(i)
						if ally and ally.team == myHero.team and ally ~= myHero and ally ~= Follow.Target.Primary and not Follow.allyInBase(ally) then
							if allyClosest == nil then
								allyClosest = ally
							elseif allyClosest and myHero:DistanceTo(ally) < myHero:DistanceTo(allyClosest) then
								allyClosest = ally
							end
						end
					end	
					if allyClosest ~= nil then 
						Follow.Target.Secondary = allyClosest
						Game.Chat.Print("Secondary - "..allyClosest.name)
					else 
						Follow.Target.Secondary = nil
					end
				end,
	["ADCCheck"] = function(string)
					local ADCcharNames = {
						"ashe",
						"corki",
						"ezreal",
						"caitlyn",
						"draven",
						"graves",
						"jinx",
						"kogmaw",
						"lucian",
						"missfortune",
						"quinn",
						"sivir",
						"tristana",
						"twitch",
						"varus",
						"vayne",
						"urgot",
						"twistedfate"
					}
					local toLowerString = string.lower(string)
					for _, v in ipairs(ADCcharNames) do
						if (string.find(toLowerString, v)) then
							return true
						end
					end
						return false
				end,
	["getPrimary"] = function()
					local possibleADC = 0
					for i=1, Game.HeroCount() do
						local ally = Game.Hero(i)
						if ally.team == myHero.team and ally ~= myHero and Follow.smiteCheck(ally) and Follow.ADCCheck(ally.charName) then 
							LastCandidate = ally
							possibleADC = possibleADC + 1
						end
					end	
					if possibleADC == 1 then 
						Follow.Target.Primary = LastCandidate
						Game.Chat.Print("Primary - "..LastCandidate.name)
					else
						Utility.DelayAction(function() Follow.getPrimaryBackup() end, 123000)
					end
				end,
	["getPrimaryBackup"] = function()
					local FromBottom = Geometry.Vector3(12321, 54, 1643)
					local closest = nil
					for i=1, Game.HeroCount() do
						local ally = Game.Hero(i)
						if ally and ally.team == myHero.team and Follow.smiteCheck(ally) then
							if closest == nil then
								closest = ally
							elseif closest and ally:DistanceTo(FromBottom) < closest:DistanceTo(FromBottom) then
								closest = ally
							end
						end
					end		
					Follow.Target.Primary = closest
					Game.Chat.Print("Primary - "..closest.name)
				end,					
	["smiteCheck"] = function(ally)
					if ally:GetSpellData(12).name ~= "summonersmite" and ally:GetSpellData(13).name ~= "summonersmite" then
						return true
					else
						return false
					end
				end,
	["moveToBotLane"] = function()
					if myHero.team == 100 and myHero:DistanceTo(General.Control.StartPos) < 600 then
						Utility.DelayAction(function() myHero:Move(9865, 1090) end, 10000)
					elseif myHero.team == 200 and myHero:DistanceTo(General.Control.StartPos) < 600 then
						Utility.DelayAction(function() myHero:Move(12850, 4200) end, 10000)
					end
				end,
}

Recall = {
	["Control"] = { RecallPosition = nil, GoingHome = false },
	["Tick"] = function()
					if (Recall.ShouldRecall() and Recall.Control.RecallPosition == nil and not Recall.Control.GoingHome) then
						Recall.GetSafeRecallPos()
						Recall.Control.GoingHome = true
					return end
				end,
	["ShouldRecall"] = function()
					if myHero.dead or myHero:DistanceTo(General.Control.StartPos) < 600 then
						return false
					elseif General.myHealthPct() < 35 or myHero.health < 100 then 
						return true
					elseif General.myManaPct() < 15 or myHero.mana < 60 then	
						for i=4, 10, 1 do
							local id = myHero:GetInventorySlot(i)
							if id == 2004 then
								return false
							end
						end		
						if Recall.ManaPotionBuff() then
							return false
						elseif General.myHealthPct() < 50 then
							return true
						end	
					else
						return false
					end
				end,
	["ManaPotionBuff"] = function()
					for i = 1, myHero.buffCount do
						tBuff = myHero:GetBuff(i)
						if tBuff.name == "FlaskOfCrystalWater" and tBuff.valid then
							return true
						end	
					end
					return false
				end,
	["GetSafeRecallPos"] = function() --NEEDS REWORK
					local ClosestTower = General.GetClosestTurret(myHero, myHero.team)
					local SafeSpot = (ClosestTower and Geometry.Vector3(ClosestTower.x, ClosestTower.y, ClosestTower.z) + Geometry.Vector3(General.Control.StartPos.x-ClosestTower.x, General.Control.StartPos.y-ClosestTower.y, General.Control.StartPos.z-ClosestTower.z):Normalize()*1500)
					if SafeSpot then
						Recall.Control.RecallPosition = SafeSpot
					end
				end,
	["CastRecall"] = function()
					local asc = General.ActionSpamCheck()
					if myHero.dead then return end
					if Recall.Control.RecallPosition then 
						if myHero:DistanceTo(Recall.Control.RecallPosition) < 200 then
							if Recall.RecallSafetyCheck() then
								myHero:CastSpell(11)
							elseif asc > 0.2 then
								myHero:Move(General.Control.StartPos.x, General.Control.StartPos.z)
							end
						elseif asc > 0.2 then
							myHero:Move(Recall.Control.RecallPosition.x, Recall.Control.RecallPosition.z)
						end	
					elseif asc > 0.2 then
						myHero:Move(General.Control.StartPos.x, General.Control.StartPos.z)
					end
					
					if myHero:DistanceTo(General.Control.StartPos) < 700 then
						Recall.Control.GoingHome = false
						Recall.Control.RecallPosition = nil
					end
				end,
	["RecallSafetyCheck"] = function()
					if General.Control.ClosestEnemy and myHero:DistanceTo(General.Control.ClosestEnemy) > 1300 then 
						return true
					elseif General.Control.ClosestEnemy == nil then
						return true
					else
						return false
					end
				end,
}

Warding = {
	["Control"] = { LastWard = 0,
					wardPositions = {},
					wardSpots = {
						{ x = 2823.37, y = 55.03, z = 7617.03},     -- BLUE GOLEM
						{ x = 7422, y = 46.53, z = 3282},     -- BLUE LIZARD
						{ x = 10148, y = 44.41, z = 2839},     -- BLUE TRI BUSH
						{ x = 6269, y = 42.51, z = 4445},     -- BLUE PASS BUSH
						{ x = 7151.64, y = 51.67, z = 4719.66},     -- BLUE RIVER ENTRANCE
						{ x = 4728, y = -51.29, z = 8336},     -- BLUE RIVER ROUND BUSH
						{ x = 6762.52, y = 55.68, z = 2918.75},     -- BLUE SPLIT PUSH BUSH
						{ x = 11217.39, y = 54.87, z = 6841.89},     -- PURPLE GOLEM
						{ x = 6610.35, y = 54.45, z = 11064.61},    -- PURPLE LIZARD
						{ x = 3883, y = 39.87, z = 11577},    -- PURPLE TRI BUSH
						{ x = 7775, y = 43.14, z = 10046.49}, -- PURPLE PASS BUSH
						{ x = 6867.68, y = 57.01, z = 9567.63},     -- PURPLE RIVER ENTRANCE
						{ x = 9720.86, y = 54.85, z = 7501.50},     -- PURPLE ROUND BUSH
						{ x = 9233.13, y = -44.63, z = 6094.48},     -- PURPLE RIVER ROUND BUSH
						{ x = 7282.69, y = 52.59, z = 11482.53},    -- PURPLE SPLIT PUSH BUSH
						{ x = 10180.18, y = -62.32, z = 4969.32},      -- DRAGON
						{ x = 8875.13, y = -64.07, z = 5390.57}, -- DRAGON BUSH
						{ x = 3920.88, y = -60.42, z = 9477.78},      -- BARON
						{ x = 5017.27, y = -62.70, z = 8954.09}, -- BARON BUSH   
						{ x = 12657.58, y = 49.99, z = 1969.98}, -- BOT SIDE BUSH
						{ x = 12321.70, y = 49.77, z = 1643.73}, -- BOT SIDE BUSH
						{ x = 9641.6591796875,  y = 53.01416015625,  z = 6368.748046875},
						{ x = 8081.4360351563,  y = 55.9482421875,  z = 4683.443359375},
						{ x = 5943.51953125,  y = 53.189331054688,  z = 9792.4091796875},
						{ x = 4379.513671875,  y = 42.734619140625,  z = 8093.740234375},
						{ x = 4222.724609375,  y = 53.612548828125,  z = 7038.5805664063},
						{ x = 9068.0224609375,  y = 53.22705078125,  z = 11186.685546875},
						{ x = 7970.822265625,  y = 53.527709960938,  z = 10005.072265625},
						{ x = 4978.1943359375,  y = 54.343017578125,  z = 3042.6975097656},
						{ x = 7907.6357421875,  y = 49.947143554688,  z = 11629.322265625},
						{ x = 7556.0654296875,  y = 50.61547851625,  z = 11739.625},
						{ x = 5973.4853515625,  y = 54.348999023438,  z = 11115.6875},
						{ x = 5732.8198242188,  y = 53.397827148438,  z = 10289.76953125},
						{ x = 7969.15625,  y = 56.940795898438,  z = 3307.5673828125},
						{ x = 12073.184570313,  y = 52.322265625,  z = 4795.50390625},
						{ x = 4044.1313476563,  y = 48.591918945313,  z = 11600.502929688},
						{ x = 5597.6669921875,  y = 39.739379882813,  z = 12491.047851563},
						{ x = 10070.202148438,  y = -60.332153320313,  z = 4132.4536132813},
						{ x = 8320.2890625,  y = 56.473876953125,  z = 4292.8090820313},
						{ x = 9603.5205078125,  y = 54.713745117188,  z = 7872.2368164063},
						{x = 9843.38, y = 43.02, z = 3125.16},
						{x = 4214.93, y = 36.62, z = 11202.01},
						{x = 2267.97, y = 44.20, z = 10783.37},
						{x = 5688.96, y = 45.64, z = 7825.20},
						{x = 7927.65, y = 47.71, z = 4239.77},
						{x = 8539.27, y = 46.98, z = 6637.38},
						{x = 11974.23, y = 42.84, z = 3807.21},
						},
					},
	["Tick"] = function()
					local currentTime = Game.Timer()
					if #Warding.Control.wardPositions >= 4 or (Warding.Control.LastWard+4) > currentTime then return end
					
					local WardSlot = Warding.GetWardSlot()
					if WardSlot then
						for i=1, #Warding.Control.wardSpots do 
							local spot = Warding.Control.wardSpots[i]		
							if spot and myHero:DistanceTo(Geometry.Vector3(spot.x, spot.y, spot.z)) <= 600 then
								local wardNear = nil
								for i = 0,Game.ObjectCount() do
									local obj = Game.Object(i)
									if obj and string.find(obj.name, "Ward") then
										if wardNear == nil then
											wardNear = obj
										elseif wardNear and myHero:DistanceTo(obj) < myHero:DistanceTo(wardNear) then
											wardNear = obj
										end
									end
								end			
								if wardNear == nil or (wardNear and myHero:DistanceTo(wardNear) > 1200) then  			
									Follow.lastAction = Game.Timer()
									myHero:CastSpell(WardSlot, spot.x, spot.z)
									Warding.Control.LastWard = Game.Timer()
									Warding.addPlacedWard(spot.x, spot.y, spot.z)
								end
							end
						end
					end	
				end,
	["GetWardSlot"] = function()
					local WardIDs = {
						"3340",
						"2049",
						"2045",
						"3362"
					}
					for _, id in pairs(WardIDs) do
						local toNumb = tonumber(id)
						if Warding.CheckForWard(toNumb) ~= 0 then
							return Warding.CheckForWard(toNumb)
						end
					end
				end,
	["CheckForWard"] = function(id)
					for i=4, 10, 1 do
						local identifier = myHero:GetInventorySlot(i)
						if identifier == id and myHero:CanUseSpell(i) == 0 then
							return i
						end
					end
					return 0
				end,
	["addPlacedWard"] = function(posX, posY, posZ)
					local tmpID = math.random(1,10000)
					table.insert(Warding.Control.wardPositions, {id = tmpID, pos = Geometry.Vector3(posX, posY, posZ)})
					Utility.DelayAction(function() Warding.removePlacedWard(tmpID) end, 110000)
				end,
	["removePlacedWard"] = function(id)
					for i, ward in pairs(Warding.Control.wardPositions) do
						if ward.id == id then
							table.remove(Warding.Control.wardPositions, i)
							break
						end
					end
				end,

}

Safety = {
	["Control"] = { HaveTowerAgro = false, EscapeTurret = nil, MinionAggro = 0, HeroAggro = 0, DragonAggro = false, BaronAggro = false, FallBackPing = 0, },
	["AvoidTowers"] = function()
						if Safety.Control.HaveTowerAgro and Safety.Control.EscapeTurret ~= nil then
							local EscapeTo = General.GetClosestTurret(myHero, myHero.team)
							if EscapeTo then 
								myHero:Move(EscapeTo.x, EscapeTo.z)
								Follow.Control.lastAction = Game.Timer()
							end
						end
					end,
	["InDanger"] = function()
						if Safety.Control.HaveTowerAgro then
							return true
						elseif General.ClosestEnemy ~= nil and not General.ClosestEnemy.dead and myHero:DistanceTo(General.ClosestEnemy) < 300 then
							return true
						elseif Safety.Control.HeroAggro >= 2 then
							return true
						elseif Safety.Control.MinionAggro >= (myHero.level+1) then
							return true
						elseif Safety.Control.DragonAggro then
							return true
						elseif Safety.Control.BaronAggro then
							return true	
						elseif Safety.Control.FallBackPing > Game.Timer() then
							return true
						else 
							return false
						end
					end,
	["Fallback"] = function()
						myHero:Move(General.Control.StartPos.x, General.Control.StartPos.z)
						Follow.lastAction = Game.Timer()
					end,
}

AutoBuy = {
	["Control"] = { LastBuy = 0, LastPotionBuy = 0, BuyList = {}, },
	["TableInit"] = function ()
					if myHero.charName == "Soraka" or myHero.charName == "Morgana" then
						AutoBuy.Control.BuyList = {
							[1] = {itemID = "3301", haveBought = false, name = "Coin"},
							[2] = {itemID = "3340", haveBought = false, name = "WardTrinket"},
							[3] = {itemID = "1028", haveBought = false, name = "RubyCrystal"},
							[4] = {itemID = "2049", haveBought = false, name = "Sightstone"},
							[5] = {itemID = "1004", haveBought = false, name = "FairieCharm"},
							[6] = {itemID = "1001", haveBought = false, name = "BootsT1"},
							[7] = {itemID = "3028", haveBought = false, name = "Chalice"},
							[8] = {itemID = "3096", haveBought = false, name = "Nomad"},
							[9] = {itemID = "3114", haveBought = false, name = "ForbiddenIdol"},
							[10] = {itemID = "3069", haveBought = false, name = "Talisman"},
							[11] = {itemID = "3111", haveBought = false, name = "MercTreads"},
							[12] = {itemID = "3222", haveBought = false, name = "Crucible"},
							[13] = {itemID = "2045", haveBought = false, name = "RubySightstone"},
							[14] = {itemID = "3362", haveBought = false, name = "TrinketT2"},
							[15] = {itemID = "1057", haveBought = false, name = "Negatron"},
							[16] = {itemID = "3105", haveBought = false, name = "Aegis"},
							[17] = {itemID = "3190", haveBought = false, name = "Locket"},
							[18] = {itemID = "3082", haveBought = false, name = "Wardens"},
							[19] = {itemID = "1011", haveBought = false, name = "GiantsBelt"},
							[20] = {itemID = "3143", haveBought = false, name = "Randuins"},	
							[21] = {itemID = "3275", haveBought = false, name = "Homeguard"},
						}
					elseif myHero.charName == "Zilean" or myHero.charName == "Sona" then
						AutoBuy.Control.BuyList = {
							[1] = {itemID = "3303", haveBought = false, name = "Spellthief"}, --1
							[2] = {itemID = "3340", haveBought = false, name = "WardTrinket"},
							[3] = {itemID = "1027", haveBought = false, name = "ManaCrystal"}, --2
							[4] = {itemID = "3070", haveBought = false, name = "Tear"},			
							[5] = {itemID = "1028", haveBought = false, name = "RubyCrystal"}, --3
							[6] = {itemID = "2049", haveBought = false, name = "Sightstone"},
							[7] = {itemID = "1001", haveBought = false, name = "BootsT1"}, --4
							[8] = {itemID = "3098", haveBought = false, name = "FrostFang"}, 
							[9] = {itemID = "3028", haveBought = false, name = "Chalice"}, --5
							[10] = {itemID = "3092", haveBought = false, name = "FrostQueen"},
							[11] = {itemID = "3114", haveBought = false, name = "ForbiddenIdol"},
							[12] = {itemID = "3111", haveBought = false, name = "MercTreads"},
							[13] = {itemID = "3222", haveBought = false, name = "Crucible"},
							[14] = {itemID = "2045", haveBought = false, name = "RubySightstone"},
							[15] = {itemID = "3362", haveBought = false, name = "TrinketT2"},
							[16] = {itemID = "3024", haveBought = false, name = "Glacial"}, --6
							[17] = {itemID = "3110", haveBought = false, name = "FrozenHeart"},
							[18] = {itemID = "3007", haveBought = false, name = "ArchStaff"},	
							[19] = {itemID = "3275", haveBought = false, name = "Homeguard"},
						}
					end
				end,
	["Tick"] = function()
					if myHero:DistanceTo(General.Control.StartPos) < 500 or myHero.dead then
						AutoBuy.Items()
						AutoBuy.Potions()
					end
				end,		

	["Items"] = function()
				if AutoBuy.TimeCheck() then
					for i=1, #AutoBuy.Control.BuyList do
						if AutoBuy.CheckForItem(tonumber(AutoBuy.Control.BuyList[i].itemID)) ~= 0 then
							AutoBuy.Control.BuyList[i].haveBought = true				
						elseif not AutoBuy.Control.BuyList[i].haveBought and (i == 1 or AutoBuy.Control.BuyList[i-1].haveBought) then			
							Game.BuyItem(tonumber(AutoBuy.Control.BuyList[i].itemID))
							AutoBuy.Control.LastBuy = Game.Timer() + 1
						end
					end
				end
			end,
	["Potions"] = function()
				if Game.Timer() < 1200 then
					if AutoBuy.CheckForItem(2010) == 0 and AutoBuy.PotionCheck() then 
						Game.BuyItem(2003)
						AutoBuy.Control.LastPotionBuy = Game.Timer() + 2
					end	
					if AutoBuy.CheckForItem(2004) == 0 and AutoBuy.PotionCheck() then 
						Game.BuyItem(2004)
						Utility.DelayAction(function() Game.BuyItem(2004) end , 1500)
						Utility.DelayAction(function() Game.BuyItem(2004) end , 3000)
						AutoBuy.Control.LastPotionBuy = Game.Timer() + 2
					end	
				end
			end,
	["TimeCheck"] = function()
				if AutoBuy.Control.LastBuy < Game.Timer() then
					return true
				else
					return false
				end
			end,

	["PotionCheck"] = function()
				if AutoBuy.Control.LastPotionBuy < Game.Timer() then
					return true
				else
					return false
				end
			end,
	["ReloadCheck"] = function()
				for i=#AutoBuy.Control.BuyList, 1, -1 do
					if AutoBuy.Control.BuyList[i].itemID ~= nil and AutoBuy.CheckForItem(tonumber(AutoBuy.Control.BuyList[i].itemID)) ~= 0 then
						AutoBuy.Control.BuyList[i].haveBought = true
						for j=i, 1, -1 do
							AutoBuy.Control.BuyList[j].haveBought = true
						end
						break
					end
				end
			end,
	["CheckForItem"] = function(id)
					for i=4, 10, 1 do
						local identifier = myHero:GetInventorySlot(i)
						if identifier == id then
							return i
						end
					end
					return 0
				end,
}

General = {
	["Control"] = { ClosestEnemy = nil, PrimaryLastMove = 0, SurrenderCount = 0, StayInBrush = false, StartPos = nil },
	["Tick"] = function()
					General.Control.ClosestEnemy = General.GetClosestEnemyHero()
				end,
	["IsRecalling"] = function(unit)
					for i = 1, unit.buffCount do
						tBuff = unit:GetBuff(i)
						if tBuff.valid then
							if tBuff.name == "Recall" or tBuff.name == "RecallImproved" then
								if unit == Follow.Target.Primary and Game.Timer() < 1200 then
									if (myHero.health/myHero.maxHealth) < 0.7 or (myHero.mana/myHero.maxMana) < 0.5 then
										Recall.GetSafeRecallPos()
										Recall.Control.GoingHome = true									
									end									
								else
									return true
								end	
							end
						end	
					end
					return false
				end,
	["ActionSpamCheck"] = function()
					if General.StayAtFountain() or General.BlockRecallMovement() then
						return 15
					else
						return math.abs(Game.Timer() - Follow.Control.lastAction)
					end	
				end,
	["myManaPct"] = function() 
					return (myHero.mana * 100) / myHero.maxMana 
				end,

	["myHealthPct"] = function() 
					return (myHero.health * 100) / myHero.maxHealth 
				end,
	["StayAtFountain"] = function()
					if myHero:DistanceTo(General.Control.StartPos) < 500 then
						if (General.myHealthPct() < 90 or General.myManaPct() < 90) then
							return true
						else
							return false
						end
					else 
						return false
					end
				end,
	["BlockRecallMovement"] = function()
					if General.IsRecalling(myHero) then
						if General.Control.ClosestEnemy and myHero:DistanceTo(General.Control.ClosestEnemy) < 1150 then
							return false
						else 
							return true
						end
					else
						return false
					end
				end,
	["GetClosestTurret"] = function(unit, team)
					local ClosestTurretFromPos = nil
					for i=CustomObjects.iter.itower, CustomObjects.iter.ntower do
						local obj = Game.Object(i)
						if obj and obj.valid and obj.type == "obj_AI_Turret" and obj.visible and obj.team == team and (obj.health/obj.maxHealth > 0.1) then
							if ClosestTurretFromPos == nil then
								ClosestTurretFromPos = obj
							elseif unit and ClosestTurretFromPos and unit:DistanceTo(obj) < unit:DistanceTo(ClosestTurretFromPos) then
								ClosestTurretFromPos = obj
							end
						end
					end	
					return ClosestTurretFromPos
				end,
	["GetClosestEnemyHero"] = function()
					local closest = nil
					for i=1, Game.HeroCount() do
						local enemy = Game.Hero(i)
						if enemy and enemy.team ~= myHero.team and not enemy.dead and enemy.visible then
							if closest == nil then
								closest = enemy
							elseif closest and myHero:DistanceTo(enemy) < closest:DistanceTo(closest) then
								closest = enemy
							end
						end
					end	
					return closest
				end,
	["PrimaryInBrush"] = function()
					if General.Control.ClosestEnemy == nil or (General.Control.ClosestEnemy and myHero:DistanceTo(General.Control.ClosestEnemy) > 400) then
						if Follow.Target.Primary and Game.IsGrass(Geometry.Vector3(Follow.Target.Primary.x, 0, Follow.Target.Primary.z)) then
							General.Control.StayInBrush = true
						else 
							General.Control.StayInBrush = false
						end
					else
						General.Control.StayInBrush = false
					end		
				end,
	["SurrenderVote"] = function()
					if General.Control.SurrenderCount >= 3 then
						Game.Chat.Print("Voted.")
						Game.Chat.Send("/ff")
					end
				end,
	["AFKCheck"] = function()
					if Follow.Target.Primary ~= nil then
						if Game.Timer() >= General.Control.PrimaryLastMove + 15 then
							return true
						else
							return false
						end
					end
				end,
}

CustomObjects = {
	["iter"] = { 
					itower = 0, 
					ntower = 0,
					iAminion = 0, 
					nAminion = 0,
					iEminion = 0, 
					nEminion = 0,
					lastUpdate = 0,
					},
	["Initialize"] = function()
				coMenu = AddonConfig('CustomObjects') {
					Options = AddonConfig.Menu('Options') {
						Buffer = AddonConfig.Number('Update Buffer', 5000),
						}
					}					
					
					for i=0, Game.ObjectCount() do
						local object = Game.Object(i)
						if object and object.type == "obj_AI_Turret" then
							CustomObjects.iter.itower = i
							break
						end
					end	
					
					for i=Game.ObjectCount(), 0, -1 do
						local object = Game.Object(i)
						if object and object.type == "obj_AI_Turret" then
							CustomObjects.iter.ntower = i
							break
						end
					end
				end,
	["Update"] = function()
					local currTick = Core.GetTickCount()
					if CustomObjects.iter.lastUpdate < currTick then
						for i=0, Game.ObjectCount() do
							local object = Game.Object(i)
							if object and object.type == "obj_AI_Minion" and object.team == myHero.team then
								CustomObjects.iter.iAminion = i
								break
							end
						end					
						
						for i=Game.ObjectCount(), 0, -1 do
							local object = Game.Object(i)
							if object and object.type == "obj_AI_Minion" and object.team == myHero.team then
								CustomObjects.iter.nAminion = i
								break
							end
						end
						for i=0, Game.ObjectCount() do
							local object = Game.Object(i)
							if object and object.type == "obj_AI_Minion" and object.team == TEAM_ENEMY then
								CustomObjects.iter.iEminion = i
								break
							end
						end					
						
						for i=Game.ObjectCount(), 0, -1 do
							local object = Game.Object(i)
							if object and object.type == "obj_AI_Minion" and object.team == TEAM_ENEMY then
								CustomObjects.iter.nEminion = i
								break
							end
						end						
						CustomObjects.iter.lastUpdate = currTick + coMenu.Options.Buffer:Value()
					end
				end,
}

Callbacks = {
	["OnLoad"] = function()
					Callback.Bind('GameStart', function() Callbacks.OnGameStart() end)
				end,
	["OnGameStart"] = function()
					if myHero.team == 100 then		
						General.Control.StartPos = Geometry.Vector3(200, 90, 500)
					else
						General.Control.StartPos = Geometry.Vector3(200, 90, 500)
					end
					Menu = AddonConfig('Follower') {
						Follower = AddonConfig.Menu('Options') {
							Follower = AddonConfig.Section("Options Menu"),
							fFollow = AddonConfig.KeyBinding('Force On Selected', 'T'),
							}
					
					}
					
					CustomObjects.Initialize()
					SpellCast.Initialize()
					Follow.moveToBotLane()
					Follow.getPrimary()
					AutoBuy.TableInit()
					AutoBuy.ReloadCheck()
					AutoLevel.Initialize()
					
					Callback.Bind('Tick', function() Callbacks.OnTick() end)
					Callback.Bind('Draw', function() Callbacks.OnDraw() end)
					Callback.Bind('SendPacket', function(p) Callbacks.OnSendPacket(p) end)
					Callback.Bind('RecvPacket', function(p) Callbacks.OnRecvPacket(p) end)
					Callback.Bind('DeleteObj', function(object) Callbacks.OnDeleteObj(object) end)
					Callback.Bind('WndMsg', function(msg, key) Callbacks.OnWndMsg(msg, key) end)
					Game.Chat.Print("Follower loaded.")	
				end,
	["OnTick"] = function()					
					General.Tick()	
					SpellCast.Tick()
					ItemCast.Tick()
					Recall.Tick()
					if Recall.Control.GoingHome then Recall.CastRecall() return end		
					Safety.AvoidTowers()
					if Safety.InDanger() then Utility.DelayAction(function() Safety.Fallback() end, 150) return end			
					Follow.Tick()
					Warding.Tick()
					CustomObjects.Update()
					
					
					AutoBuy.Tick()
				end,	
	["OnDraw"] = function()
					if Follow.Target.Primary ~= nil then
						Graphics.DrawCircle(Follow.Target.Primary.x, Follow.Target.Primary.y, Follow.Target.Primary.z, 100, Graphics.ARGB(0xFF,0,0xFF,0))
					end
					if Follow.Target.Secondary ~= nil then
						Graphics.DrawCircle(Follow.Target.Secondary.x, Follow.Target.Secondary.y, Follow.Target.Secondary.z, 100, Graphics.ARGB(0xFF,0,0,0xFF))
					end
				end,
	["OnSendPacket"] = function(p)
					if General.BlockRecallMovement() or General.StayAtFountain() then
						if p.header == 114 then
							p.pos = 19
							local myNetId = p:Decode4()
							if myNetId == myHero.networkID then
								p:Block()
							end
						elseif p.header == 154 then
							p.pos = 1
							local myNetId = p:Decode4()
							if myNetId == myHero.networkID then
								p:Block()
							end	
						end
					end
					
					if General.PrimaryInBrush() then
						if p.header == 114 then
							p.pos = 19
							local myNetId = p:Decode4()
							if myNetId == myHero.networkID then
								p.pos = 6
								local Xpos = p:DecodeF()
								p.pos = 10
								local Zpos = p:DecodeF()
								if not Game.IsGrass(Geometry.Vector3(Xpos, 0, Zpos)) then
									p:Block()
									if Follow.Target.Primary then
										myHero:Move(Follow.Target.Primary.x, Follow.Target.Primary.z)
										--Packet('S_MOVE',{x = PrimaryFollow.x, y = PrimaryFollow.z}):send()
									end				
								end
							end
						end
					end
				end,
	["OnRecvPacket"] = function(p)
					if p.header == 64 then
						p.pos = 21
						local pType = p:Decode1()
						if pType == 178 or pType == 181 then
							p.pos = 5
							local Xpos = p:DecodeF()
							p.pos = 9
							local Zpos = p:DecodeF()
							if Xpos and Zpos and myHero:DistanceTo(Geometry.Vector3(Xpos, 0 , Zpos)) < 1200 then
								Safety.Control.FallBackPing = Game.Timer() + 2
							end
						end
					end
					
					if p.header == 97 and Follow.Target.Primary then
						p.pos = 12
						local netID = p:Decode4()
						if netID == Follow.Target.Primary.networkID then
							General.Control.PrimaryLastMove = Game.Timer()
						end
					end
					
					if p.header == 63 then
						p.pos = 1
						local netID = p:Decode4()
						if netID == myHero.networkID then
							Game.LevelSpell(AutoLevel.Control.SkillSequence[AutoLevel.GetHeroLeveled() + 1])
						end
					end
					
				   if p.header == 165 then -- End of Voted
						General.Control.SurrenderCount = 0
						Game.Chat.Print("Vote Ended")
				   elseif p.header == 201 then  --Currently Couting yes and no votes.
						General.Control.SurrenderCount = General.Control.SurrenderCount + 1
						Game.Chat.Print(General.Control.SurrenderCount)
						Utility.DelayAction(function() General.SurrenderVote() end, 50000)
					end
					
					if p.header == 192 then
						p.pos = 1
						local objNetId = p:Decode4()
						local object = Game.ObjectByNetworkId(objNetId)
						p.pos = 5
						local aggro = p:Decode1()
						if object.type == "obj_AI_Minion" then
							if aggro == 25 then
								Safety.Control.MinionAggro = Safety.Control.MinionAggro + 1
							elseif Safety.Control.MinionAggro ~= 0 then
								if not object.visible or aggro == 0 then
									Safety.Control.MinionAggro = Safety.Control.MinionAggro - 1
								end
							end
						end
						if object.name == "Dragon6.1.1" then
							if aggro == 25 then
								Safety.Control.DragonAggro = true
							elseif aggro == 0 or not object.visible then
								Safety.Control.DragonAggro = false
							end
						end
						if object.name == "Worm12.1.1" then
							if aggro == 25 then
								Safety.Control.BaronAggro = true
							elseif aggro == 0 or not object.visible then
								Safety.Control.BaronAggro = false
							end
						end
						if object.type == "obj_AI_Turret" then
							if aggro == 25 then
								Safety.Control.HaveTowerAgro = true
								Safety.Control.EscapeTurret = General.GetClosestTurret(myHero, TEAM_ENEMY)
							elseif aggro == 0 or not object.visible then
								Safety.Control.HaveTowerAgro = false
								Safety.Control.EscapeTurret = nil
							end
						end
						if object.type == myHero.type then
							if aggro == 25 then
								Safety.Control.HeroAggro = Safety.Control.HeroAggro + 1
							elseif aggro == 0 or not object.visible then
								Safety.Control.HeroAggro = Safety.Control.HeroAggro - 1
							end
						end
					end
				end,
	["OnDeleteObj"] = function(object)
					if object.name:find("Ward") and object.team == myHero.team then
						for i, ward in pairs(Warding.Control.wardPositions) do
							if ward and object:DistanceTo(ward.pos) < 80 then 
							table.remove(Warding.Control.wardPositions, i)
							break
							end
						end
					end
				end,
	["OnWndMsg"] = function(msg, key)
					if key == string.byte(Menu.Follower.fFollow:Value()) and msg == 256 then
						local selectedAlly = Game.Target()
						local selectedAlly = Game.Target()
						if selectedAlly and selectedAlly.type == myHero.type and selectedAlly.team == myHero.team then
							Follow.Target.Primary = selectedAlly
						end
					end
				end,
}

ItemCast = {
	["Tick"] = function()
					ItemCast.Potions()
				end,
	["Potions"] = function()
					if (myHero.health/myHero.maxHealth) < 0.5 or (myHero.maxHealth-myHero.health) > 600 then
						if Warding.CheckForWard(2010) ~= 0 then
							myHero:CastSpell(Warding.CheckForWard(2010))
						elseif Warding.CheckForWard(2003) ~= 0 then
							myHero:CastSpell(Warding.CheckForWard(2003))
						end
					end
					if (myHero.mana/myHero.maxMana) < 0.5 or (myHero.maxMana-myHero.mana) > 600 then
						if Warding.CheckForWard(2004) ~= 0 and not Recall.ManaPotionBuff() then
							myHero:CastSpell(Warding.CheckForWard(2004))
						end
					end				
				end,
	["Talisman"] = function()
	
				end,
	["FrostQueen"] = function()
	
				end,
	["Crucible"] = function()
	
				end,
	["Locket"] = function()
	
				end,
	["Randuins"] = function()
	
				end,
	["ArchStaff"] = function()
	
				end,
	
}

SpellCast = {
	["Control"] = {},
	["Tick"] = function()
					if General.IsRecalling(myHero) then return end
					if myHero:CanUseSpell(3) == 0 then
						SpellCast.AutoR()
					end
					if myHero:CanUseSpell(0) == 0 then
						SpellCast.AutoQ()
					end
					if myHero:CanUseSpell(1) == 0 then
						SpellCast.AutoW()
					end
					if myHero:CanUseSpell(2) == 0 then
						SpellCast.AutoE()
					end
				end,
	["Initialize"] = function()
					if myHero.charName == "Zilean" then
						SpellCast.Control["SpellData"] = { qRange = 700, eRange = 700, rRange = 900, }
						SpellCast["AutoQ"] = function()
												if General.Control.ClosestEnemy and myHero:DistanceTo(General.Control.ClosestEnemy) < SpellCast.Control.SpellData.qRange then
													myHero:CastSpell(0, General.Control.ClosestEnemy)			
												end
											end
						SpellCast["AutoW"] = function()
												if myHero:GetSpellData(0).currentCd > 6 then
													Utility.DelayAction(function() myHero:CastSpell(1) end, 500)
												elseif myHero:GetSpellData(2).currentCd > 10 then
													Utility.DelayAction(function() myHero:CastSpell(1) end, 500)
												end										
											end
						SpellCast["AutoE"] = function()
												if General.Control.ClosestEnemy then
													if myHero:DistanceTo(General.Control.ClosestEnemy) < SpellCast.Control.SpellData.eRange then
														myHero:CastSpell(2, General.Control.ClosestEnemy)
													else
														local closestAlly = nil
														for i=1, Game.HeroCount() do
															local ally = Game.Hero(i)
															if ally and ally ~= myHero and ally.team == myHero.team and not ally.dead then
																if closestAlly == nil then
																	closestAlly = ally
																elseif closestAlly and myHero:DistanceTo(closestAlly) > myHero:DistanceTo(ally) then
																	closestAlly = ally
																end
															end
														end
														if closestAlly then 
															if myHero:DistanceTo(closestAlly) < SpellCast.Control.SpellData.eRange and not SpellCast.HasEBuff(closestAlly) then
																myHero:CastSpell(2, closestAlly)
															elseif myHero:DistanceTo(closestAlly) > SpellCast.Control.SpellData.eRange and not SpellCast.HasEBuff(myHero) then
																myHero:CastSpell(2, myHero)
															end
														end
													end
												end

											end
						SpellCast["AutoR"] = function()													
												for i=1, Game.HeroCount() do
													local ally = Game.Hero(i)
													if ally and ally.team == myHero.team and not ally.dead and (ally.health/ally.maxHealth) < 0.2 and myHero:DistanceTo(ally) < SpellCast.Control.SpellData.rRange and General.Control.ClosestEnemy and ally:DistanceTo(General.Control.ClosestEnemy) < 550 then
														myHero:CastSpell(3, ally)
													end
												end												
											end
						SpellCast["HasEBuff"] = function(unit)													
												for i = 1, unit.buffCount do
													tBuff = unit:GetBuff(i)
													if tBuff.valid then
														if tBuff.name == "TimeWarp" or tBuff.name == "timewarpslow" then
															return true
														end
													end	
												end
												return false											
											end
					end--add here
				end,

}

AutoLevel = {
	["Control"] = { SkillSequence = {}, },
	["Initialize"] = function()
					if myHero.charName == "Zilean" then
						AutoLevel.Control.SkillSequence = {0,2,0,1,0,3,0,2,0,2,2,2,1,1,1,1,3,3}
						if myHero.level == 1 then
							Game.LevelSpell(AutoLevel.Control.SkillSequence[1])
						end					
					end
				end,
	["LevelUp"] = function()
					if myHero.level > AutoLevel.GetHeroLeveled() then
						Game.LevelSpell(AutoLevel.Control.SkillSequence[AutoLevel.GetHeroLeveled() + 1])
					end
				end,
	["GetHeroLeveled"] = function()
					return myHero:GetSpellData(0).level + myHero:GetSpellData(1).level + myHero:GetSpellData(2).level + myHero:GetSpellData(3).level
				end,
}









































