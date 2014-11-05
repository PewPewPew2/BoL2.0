local sLine = { spell = {}, obj = {} }
local sAoe = { spell = {}, obj = {} }
local sCone = { spell = {}, obj = {} }
local danger0Clip = Geometry.Clipper()
local danger1Clip = Geometry.Clipper()
local danger2Clip = Geometry.Clipper()
local lvl0Poly = nil
local lvl1Poly = nil
local lvl2Poly = nil
local linP = {}
local aoeP = {}
local conP = {}

local iTable = {
	aatrox = function()
		aoeP.aatroxq = { danger = 2, object = "aatrox", object2 = "q_tar_red.troy", radius = 250, id = 38545 }
		linP.aatroxe = { danger = 1, object = "aatrox", object2 = "emissile.troy", length = 1100, width = 70, id = 25541 }
	end,
	ahri = function()
		linP.ahriseduce = { danger = 2, object = "ahri", object2 = "charm_mis.troy", length = 1100, width = 70, id = 57573 } 
		
		linP.ahriorbofdeception = { danger = 0, object = "ahri", object2 = "orb_mis.troy", length = 1050, width = 70, id = 61733,
													uniqueObj = function(obj)
														if obj.name:lower():find("ahri_orb_mis_02.troy") then 
															for i=0, Game.HeroCount(), 1 do
																local hero = Game.Hero(i)
																if hero.charName:lower():find("ahri") then
																	sLine.obj[47726] = { object = obj }
																	sLine.spell[47726] = {
																							endPos = hero.pos,
																							startPos = Geometry.Vector3(obj.pos.x, obj.pos.y, obj.pos.z),
																							danger = 0,
																							length = 950,
																							width = 70,
																							}
																end
															end
														end
													end,
									}
	end,
	amumu = function()
		linP.bandagetoss = { danger = 2, object = "bandage", object2 = "beam.troy", length = 1150, width = 50, id = 65107 }
	end,
	anivia = function()
		linP.flashfrost = { danger = 2, object = "flashfrost", object2 = "mis.troy", length = 1200, width = 70, id = 56940 }
	end,
	annie = function()
		conP.incinerate = { danger = 1, object = "noobject", object2 = "noobject", radius = 300, length = 900, width = 500, center = 350, id = 696969,
													uniqueObj = function(obj)
														if obj.name == "DrawFX" then 
															for coneSpell in pairs(sCone.spell) do
																if coneSpell and coneSpell == 696969 then
																	if obj.pos:DistanceTo(sCone.spell[coneSpell].startPos) == 0 then
																		sCone.obj[coneSpell] = { object = obj }
																	end
																end
															end
														end
													end,							
								}
		aoeP.infernalguardian = { danger = 2, object = "annietibbers", object2 = "idle_head.troy", radius = 275, id = 10590 }
	end,
	ashe = function()
		conP.volley = { danger = 1, object = "ashe", object2 = "w_mis.troy", radius = 700, length = 1500, width = 600, center = 700, id = 38235 }
		linP.enchantedcrystalarrow = { danger = 2, object = "ashe", object2 = "r_mis.troy", length = 50000, width = 90, id = 42295 }
	end,
	blitzcrank = function()
		linP.rocketgrab = { danger = 2, object = "fistgrab", object2 = "mis.troy", length = 1100, width = 60, id = 17301 }
	end,
	brand = function()
		linP.brandblaze = { danger = 2, object = "brandblaze", object2 = "mis.troy", length = 1100, width =70, id = 34597 }
		aoeP.brandfissure = { danger = 0, object = "brandpof", object2 = "tar_red.troy", radius = 275, id = 10277 }
	end,
	braum = function()
		linP.braumq = { danger = 1, object = "braum", object2 = "q_mis.troy", length = 1100, width = 60, id = 23557 }
		linP.braumrwrapper = { danger = 2, object = "braum", object2 = "r_mis.troy", length = 1400, width = 100, id = 23765 }
	end,
	caitlyn = function()
		linP.caitlynpiltoverpeacemaker = { danger = 0, object = "caitlyn", object2 = "q_mis.troy", length = 1375, width = 40, id = 41074 }
		linP.caitlynentrapmentmissile = { danger = 1, object = "caitlyn", object2 = "entrapment_mis.troy", length = 1150, width = 50, id = 27397 }
	end,
	cassiopeia = function()
		aoeP.cassiopeianoxiousblast = { danger = 0, object = "cassiopeia", object2 = "q_hit_red.troy", radius = 185, id = 13716 }
		aoeP.cassiopeiamiasma = { danger = 1, object = "cassiopeia", object2 = "miasma_tar_red.troy", radius = 190, id = 31585 }
		conP.cassiopeiapetrifyinggaze = { danger = 2, object = "cassiopeia", object2 = "r_cas.troy", radius = 500, length = 1500, width = 800, center = 500, id = 30869 }
	end,
	chogath = function()
		aoeP.rupture = { danger = 2, object = "rupture_cas", object2 = "red_team.troy", radius = 275, id = 48373 }
		conP.feralscream = { danger = 1, object = "noobject", object2 = "noobject", radius = 300, length = 800, width = 315, center = 300, id = 17405,
													uniqueObj = function(obj)
														if obj.name == "DrawFX" then 
															for coneSpell in pairs(sCone.spell) do
																if coneSpell and coneSpell == 17405 then
																	if obj.pos:DistanceTo(sCone.spell[coneSpell].startPos) == 0 then
																		sCone.obj[coneSpell] = { object = obj }
																	end
																end
															end
														end
													end, 
								}
	end,
	corki = function()
		aoeP.phosphorusbomb = { danger = 0, object = "corki", object2 = "q_indicator_red.troy", radius = 275, id = 50 }
		linP.missilebarragemissile = { danger = 0, object = "corki", object2 = "misslebarrage_mis.troy", length = 1300, width = 60, id = 48741 }
		linP.missilebarragemissile2 = { danger = 0, object = "corki", object2 = "dd_mis.troy", length = 1500, width = 80, id = 59042 }
	end,
	darius = function()
		conP.dariusaxegrabcone = { danger = 2, object = "noobject", object2 = "noobject", radius = 325, length = 750, width = 315, center = 325, id = 2213,
													uniqueObj = function(obj)
														if obj.name == "DrawFX" then 
															for coneSpell in pairs(sCone.spell) do
																if coneSpell and coneSpell == 2213 then
																	if obj.pos:DistanceTo(sCone.spell[coneSpell].startPos) == 0 then
																		sCone.obj[coneSpell] = { object = obj }
																	end
																end
															end
														end
													end, 
								}
	end,
	drmundo = function()
		linP.infectedcleavermissilecast = { danger = 1, object = "dr_mundo", object2 = "infected_cleaver_mis.troy", length = 1300, width = 60, id = 61141 }
	end,
	draven = function()
		linP.dravendoubleshot = { danger = 1, object = "draven", object2 = "e_mis.troy", length = 1300, width = 80, id = 35365 }
		--[[table.insert(linP, (index+2), { name = "DravenRCast", danger = 0, object = 0, object2 = 0, length = 50000, width = 80, varDist = false, id = 4196,
										uniqueObj = function(obj)
														if string.find(string.lower(obj.name), ("draven" and "r_mis.troy")) then
															local index = (table.maxn(sLine.obj)+1)
															table.insert(sLine.obj, index, { object = obj, id = 4196 } )	
															Callback.Bind('Tick', function() UniqueDraven() end)
														end
													end,
										})]]
	end,
	elise = function()
		linP.elisehumane = { danger = 2, object = "elise_human", object2 = "e_mis.troy", length = 1300, width = 70, id = 2261 }
	end,
	ezreal = function()
		linP.ezrealmysticshot = { danger = 0, object = "ezreal", object2 = "mysticshot_mis.troy", length = 1300, width = 90, id = 40165 }
		linP.ezrealessenceflux = { danger = 0, object = "ezreal", object2 = "essenceflux_mis.troy", length = 1100, width = 80, id = 45845 }
		linP.ezrealtrueshotbarrage = { danger = 0, object = "ezreal", object2 = "trueshot_mis.troy", length = 50000, width = 100, id = 18421 }
	end,
	fizz = function()
		linP.fizzmarinerdoom = { danger = 2, object = "fizz", object2 = "ultimatemissile.troy", length = nil, width = 80, id = 34117,
										uniqueObj = function(obj)
														if obj.name:lower():find("fizz") and obj.name:lower():find("ring_red.troy") then
															sAoe.obj[20910] = { object = obj, danger = 2, radius = 275, }
															sAoe.spell[20910] = {
																				endPos = Geometry.Vector3(obj.pos.x, obj.pos.y, obj.pos.z),
																				danger = 2,
																				radius = 275,
																				}
														end
													end,
										}
	end,
	galio = function()
		linP.galiorighteousgust = { danger = 0, object = "galio", object2 = "windtunnel_mis_02.troy", length = 1300, width = 70, id = 9796 }
		aoeP.galioresolutesmite = { danger = 1, object = "galio", object2 = "concussiveblast_mis.troy", radius = 275, id = 21253 }
	end,
	gnar = function()
		linP.gnarq = { danger = 0, object = "gnar", object2 = "q_mis.troy", length = 1250, width = 70, id = 6053 }
		linP.gnarbigq = { danger = 1, object = "gnarbig", object2 = "q_rock.troy", length = 1000, width = 70, id = 4197 }
	end,
	gragas = function()
		aoeP.gragasq = { danger = 1, object = "gragas", object2 = "q_enemy.troy", radius = 275, id = 21253 }
		aoeP.gragasr = { danger = 1, object = "gragas", object2 = "r_end.troy", radius = 300, id = 5005 }
	end,
	graves = function()
		conP.gravesclustershot = { danger = 0, object = "graves", object2 = "clustershot_mis.troy", radius = 450, length = 1200, width = 425, center = 450, id = 35995 }
		aoeP.gravessmokegrenade = { danger = 1, object = "graves_smokegrenade", object2 = "team_red.troy", radius = 275, id = 40701 }
		linP.graveschargeshot = { danger = 0, object = "graves", object2 = "chargedshot_mis.troy", length = 1300, width = 80, id = 36484 }
	end,
	heimerdinger = function()
		aoeP.heimerdingere = { danger = 2, object = "heimerdinger", object2 = "e_mis.troy", radius = 275, id = 9772 }
		--linP.heimerdingerw = { danger = 0, object = "heimerdinger", object2 = "mis.troy", length = 1300, width = 80, id = 32370 }
	end,
	irelia = function()
		linP.ireliatranscendentblades = { danger = 0, object = "irelia", object2 = "dagger_mis.troy", length = 1300, width = 80, id = 2908 }
	end,
	janna = function()
		linP.howlinggale = { danger = 2, object = "howlinggale", object2 = "mis.troy", length = 1900, width = 70, varDist = false, id = 16780, 
										uniqueObj = function(obj)
														if obj.name == "HowlingGale_cas.troy" then
															for linSpell in pairs(sLine.spell) do
																if sLine.spell[linSpell].id == 16780 then
																	local objEnd = sLine.spell[linSpell].endPos
																	sLine.spell[linSpell] = nil
																	sLine.spell[linSpell] = {
																							endPos = objEnd,
																							startPos = Geometry.Vector3(obj.pos.x, obj.pos.y, obj.pos.z),
																							danger = 2,
																							length = 1600,  --dynamic range
																							width = 70,
																							id = 16780
																							}
																end
															end
														end
													end,
							}
	end,
	jarvaniv = function()
		linP.jarvanivdragonstrike = { danger = 0, object = "noobject", object2 = "noobject", length = 900, width = 60, id = 30325,
													uniqueObj = function(obj)
														if obj.name == "DrawFX" then 
															for linear in pairs(sLine.spell) do
																if linear and linear == 30325 then
																	if obj.pos:DistanceTo(sLine.spell[linear].startPos) == 0 then
																		sLine.obj[linear] = { object = obj }
																	end
																end
															end
														end
													end,
							}
		aoeP.jarvanivdemacianstandard = { danger = 0, object = "beacon", object2 = "beacon", radius = 175, id = 62868 }
	end,
	jayce = function()
		linP.jayceshockblast = { danger = 0, object = "jayce", object2 = "orblightning.troy", length = 1100, width = 60, id = 60499,
													uniqueObj = function(obj)
														if obj.name:lower():find("jayceorblightningcharged.troy") then
															for linear in pairs(sLine.spell) do
																if linear and linear == 60499 then
																	sLine.obj[linear] = { object = obj }
																	sLine.spell[linear].length = 1800
																	sLine.spell[linear].width = 90
																end
															end
														end
													end,
							}
	end,
	jinx = function()
		linP.jinxw = { danger = 1, object = "jinx", object2 = "w_mis.troy", length = 1500, width = 70, id = 49605 }
		linP.jinxr = { danger = 0, object = "jinx", object2 = "r_mis.troy", length = 50000, width = 90, id = 1522 }
	end,
	karma = function()
		linP.karmaq = { danger = 1, object = "karma", object2 = "q_mis", length = 1175, width = 70, id = 43061 }							
		--table.insert(aoeP, (index+1), { name = "KarmaQ", danger = 1, object = "karma", object2 = "q_unit_tar.troy", radius = 275, id = 62385 })
	end,
	karthus = function()
		aoeP.karthuslaywaste = { danger = 0, object = "karthus", object2 = "q_tar_red.troy", radius = 175, id = 2529 }
	end,
	kassadin = function()
		conP.forcepulse = { danger = 1, object = "kassadin", object2 = "e_cas.troy", radius = 400, length = 1300, width = 800, center = 400, id = 29973 }
	end,
	kennen = function()
		linP.kennenshuriken = { danger = 0, object = "kennen", object2 = "mis.troy", length = 1100, width = 70, id = 12289 }
	end,
	khazix = function()
		--linP.khazixw = { danger = 1, object = "khazix", object2 = "w_mis.troy", length = 1000, width = 70, id = 39157 }
		--conP.khazixwevo = { danger = 1, object = "khazix", object2 = "w_mis.troy", radius = 400, length = 1300, width = 800, center = 400, id = 39157 }
	end,
	kogmaw = function()
		linP.kogmawq = { danger = 0, object = "kogmaw", object2 = "q_mis.troy", length = 950, width = 70, id = 26595 }
		linP.kogmawvoidooze = { danger = 1, object = "kogmaw", object2 = "e_mis.troy", length = 1500, width = 100, id = 37349 }
		aoeP.kogmawlivingartillery = { danger = 0, object = "kogmaw", object2 = "r_mis.troy", radius = 175, id = 1163460710 }
	end,
	leesin = function()
		linP.blindmonkqone = { danger = 1, object = "blindmonk", object2 = "q_mis_01.troy", length = 1100, width = 50, id = 20261 }
	end,
	leblanc = function()
		linP.leblancsoulshackle = { danger = 2, object = "leblanc", object2 = "e_mis.troy", length = 1000, width = 70, id = 31893 }
	end,
	leona = function()
		linP.leonazenithblade = { danger = 2, object = "leona", object2 = "zenithblade_mis.troy", length = 975, width = 70, id = 29765 }
		aoeP.leonasolarflare = { danger = 2, object = "leona", object2 = "solarflare_tar.troy", radius = 275, id = 53349 }
	end,
	lissandra = function()
		linP.lissandraqmissile = { danger = 0, object = "lissandra", object2 = "q_mis.troy", length = 750, width = 70, id = 7893 }
		linP.lissandraemissile = { danger = 0, object = "lissandra", object2 = "e_missile.troy", length = 1150, width = 70, id = 4885 }
	end,
	lucian = function()
		linP.lucianq = { danger = 0, object = "lucian", object2 = "q_laser_red.troy", length = 1300, width = 70, id = 63527 }
		linP.lucianw = { danger = 0, object = "lucian", object2 = "w_mis.troy", length = 1150, width = 70, id = 7893 }
		--linP.lucianr = { danger = 0, object = "lucian", object2 = "r_self.troy", length = 1400, width = 70, id = 7909 }
	end,
	lulu = function()
		linP.luluqmissile = { danger = 1, object = "lulu", object2 = "q_mis.troy", length = 1000, width = 70, id = 39103 }
	end,
	lux = function()
		linP.luxlightbinding = { danger = 2, object = "lux", object2 = "lightbinding_mis.troy", length = 1300, width = 70, id = 5129 }
		aoeP.luxlightstrikekugel = { danger = 1, object = "lux", object2 = "lightstrike_mis.troy", radius = 275, id = 10972 }
		linP.luxmalicecannonmis = { danger = 0, object = "lux", object2 = "malicecannon_cas.troy", length = 3340, width = 90, id = 6403 }
	end,
	maokai = function()
		linP.maokaitrunklinemissile = { danger = 2, object = "maoki", object2 = "trunksmash_mis.troy", length = 700, width = 70, id = 6981 }
		aoeP.maokaisapling2boom = { danger = 1, object = "maokai", object2 = "sapling_mis.troy", radius = 200, id = 42973 }		
	end,
	mordekaiser = function()
		conP.mordekaisersyphonofdestruction = { danger = 0, object = "noobject", object2 = "noobject", radius = 325, length = 750, width = 315, center = 325, id = 25294,
													uniqueObj = function(obj)
														if obj.name == "DrawFX" then 
															for coneSpell in pairs(sCone.spell) do
																if coneSpell and coneSpell == 25294 then
																	if obj.pos:DistanceTo(sCone.spell[coneSpell].startPos) == 0 then
																		sCone.obj[coneSpell] = { object = obj }
																	end
																end
															end
														end
													end, 
								}	
	end,
	morgana = function()
		linP.darkbindingmissile = { danger = 2, object = "darkbinding", object2 = "mis.troy", length = 1300, width = 60, id = 60229 }
	end,
	nami = function()
		aoeP.namiq = { danger = 2, object = "nami", object2 = "q_mis.troy", radius = 200, id = 57509 }	
		linP.namirmissile = { danger = 2, object = "nami", object2 = "r_mis.troy", length = 2700, width = 250, id = 57525 }
	end,
	nautilus = function()
		linP.nautilusanchordragmissile = { danger = 2, object = "nautilus", object2 = "q_mis.troy", length = 1200, width = 70, id = 57941 }
	end,
	nidalee= function()
		linP.javelintoss = { danger = 0, object = "nidalee", object2 = "q_mis.troy", length = 1475, width = 60, id = 14947 }
	end,
	nocturne = function()
		linP.nocturneduskbringer = { danger = 0, object = "nocturne", object2 = "duskbringer_mis.troy", length = 1200, width = 70, id = 14546 }
	end,
	olaf = function()
		linP.olafaxethrowcast = { danger = 1, object = "olaf", object2 = "axe_mis.troy", length = nil, width = 70, id = 34279 }
	end,
	orianna = function()
		linP.orianaizunacommand = { danger = 0, object = "oriana", object2 = "ghost_mis.troy", length = nil, width = 70, id = 38337 }
		--aoeP.orianadissonancecommand = { danger = 1, object = "oriana", object2 = "dissonace_ball_red.troy", radius = 200, id = 64724 }  --drawing on ori	
		linP.orianaredactcommand = { danger = 0, object = "oriana", object2 = "protect.troy", length = nil, width = 70, id = 24548 }
		--aoeP.orianadetonatecommand = { danger = 1, object = "oriana", object2 = "shockwave_nova.troy", radius = 250, id = 2974023680 }   --drawing on ori
	end,
	quinn = function()
		linP.quinnqmissile = { danger = 1, object = "quinn", object2 = "q_mis.troy", length = 1000, width = 70, id = 52021 }
	end,
	rengar = function()
		linP.rengarefinal = { danger = 1, object = "rengar", object2 = "e_mis.troy", length = 1000, width = 70, id = 51708 }
		linP.rengarefinalmax = { danger = 2, object = "rengar", object2 = "e_max_mis.troy", length = 1000, width = 70, id = 52021 }
	end,
	rumble = function()
		linP.rumblegrenademissile = { danger = 1, object = "rumble", object2 = "taze_mis.troy", length = 1000, width = 70, id = 51957 }
	end,
	sejuani = function()
		linP.sejuaniglacialprisoncast = { danger = 2, object = "sejuani", object2 = "r_mis.troy", length = 1000, width = 70, id = 63988 }
	end,
	shyvana = function()
		linP.shyvanafireball = { danger = 0, object = "shyvana", object2 = "flamebreath_mis.troy", length = 1000, width = 70, id = 24597 }
	end,
	sion = function()
		linP.sione = { danger = 1, object = "sion", object2 = "e_mis.troy", length = 900, width = 70, id = 64741 }
	end,
	sivir = function()
		linP.sivirq = { danger = 0, object = "sivir", object2 = "q_mis.troy", length = 1300, width = 80, id = 38709,
										uniqueObj = function(obj)
														if obj.name:lower():find("sivir") and obj.name:lower():find("q_mis_return.troy") then
															for i=1, Game.HeroCount(), 1 do
																local hero = Game.Hero(i)
																if hero.charName == "Sivir" then
																	sLine.obj[11198] = { object = obj }
																	sLine.spell[11198] = {
																						endPos = hero.pos,
																						startPos = Geometry.Vector3(obj.pos.x, obj.pos.y, obj.pos.z),
																						danger = 0,
																						length = 1300,
																						width = 80,
																						id = 11198
																						}
																	
																end
															end
														end
													end,
										}
	end,
	skarner = function()
		linP.skarnerfracturemissile = { danger = 1, object = "skarner", object2 = "e_mis.troy", length = 900, width = 70, id = 31973 }
	end,
	sona = function()
		linP.sonar = { danger = 2, object = "sona", object2 = "r_missile.troy", length = 1100, width = 120, id = 25730 }
	end,
	soraka = function()
		aoeP.sorakaq = { danger = 1, object = "soraka", object2 = "q_mis.troy", radius = 250, id = 33221 }
		aoeP.sorakae = { danger = 2, object = "soraka", object2 = "e_beam.troy", radius = 250, id = 33222 }
	end,
	swain = function()
		aoeP.swainshadowgrasp = { danger = 2, object = "swain", object2 = "shadowgrasp", radius = 250, id = 65165164 }
	end,
	syndra = function()
		aoeP.syndraq = { danger = 0, object = "syndra", object2 = "q_aoe_gather_enemy.troy", radius = 200, id = 8620 }
		aoeP.syndrawcast = { danger = 1, object = "syndra", object2 = "w_fling.troy", radius = 250, id = 1891654 }
		conP.syndrae = { danger = 2, object = "syndra", object2 = "e_mis.troy", radius = 400, length = 1100, width = 400, center = 400, id = 8245 }
	end,
	talon = function()
		conP.talonrake = { danger = 1, object = "talon", object2 = "w_mis.troy", radius = 400, length = 1100, width = 400, center = 400, id = 57621 }
	end,
	thresh = function()
		linP.threshq = { danger = 2, object = "thresh", object2 = "q_whip_beam.troy", length = 1250, width = 70, id = 2245 }
	end,
	twistedfate = function()
		--linP.wildcards = { danger = 0, object = "mis.troy", object2 = "roulette", length = 1250, width = 70, id = 27597 }
	end,
	twitch = function()
		aoeP.twitchvenomcaskmissile = { danger = 1, object = "twitch", object2 = "w_mis.troy", radius = 300, id = 41125 }
	end,
	urgot = function()
		linP.urgotheatseekinglinemissile = { danger = 0, object = "urgot", object2 = "q_linemissile_mis.troy", length = 950, width = 70, id = 19941 }
		aoeP.urgotplasmagrenadeboom = { danger = 0, object = "urgot", object2 = "plasmagrenade_mis.troy", radius = 250, id = 64157 }
	end,
	varus = function()
		linP.specialvarus = { danger = 0, object = "noobject", object2 = "noobject", length = 1500, width = 70, id = 22021,
										uniqueObj = function(obj)
														if obj.name:lower():find("varus") and obj.name:lower():find("q_mis.troy") then
															for i=0, Game.HeroCount(), 1 do
																local hero = Game.Hero(i)
																if hero.charName == "Varus" then
																	Utility.DelayAction(function() 
																								sLine.spell[22021] = {
																								endPos = Geometry.Vector3(obj.pos.x, obj.pos.y, obj.pos.z),
																								startPos = Geometry.Vector3(hero.pos.x, hero.pos.y, hero.pos.z),
																								danger = 0,
																								length = 1800,  --dynamic range
																								width = 70,
																								id = 22021,
																								} end, 100)
																	sLine.obj[22021] = { object = obj }
																end
															end												
														end
													end,
										}
		aoeP.varusemissile = { danger = 1, object = "varus", object2 = "emissilelong.troy", radius = 250, id = 22469 }
		linP.varusr = { danger = 2, object = "varus", object2 = "rmissile.troy", length = 1300, width = 70, id = 21813 }
	end,
	veigar = function()
		aoeP.veigardarkmatter = { danger = 0, object = "veigar", object2 = "w_cas_red.troy", radius = 250, id = 55618 }
	end,
	velkoz = function()
		linP.velkozw = { danger = 0, object = "velkoz", object2 = "w_turret.troy", length = 1000, width = 80, id = 59925 }
		aoeP.velkoze = { danger = 2, object = "velkoz", object2 = "e_aoe_red.troy", radius = 225, id = 59829 }
	end,
	viktor = function()
		linP.viktordeathray = { danger = 0, object = "viktor", object2 = "deathray_fix_mis.troy", length = nil, width = 80, id = 57717 }
		aoeP.viktorgravitonfield = { danger = 2, object = "viktor", object2 = "catalyst_red.troy", radius = 250, id = 32324 }		
	end,
	xerath = function()
		linP.specialxerath = { danger = 0, object = "noobject", object2 = "noobject", length = 1500, width = 70, id = 6514,
										uniqueObj = function(obj)
														if obj.name:lower():find("xerath") and obj.name:lower():find("q_beam.troy") then
															for i=0, Game.HeroCount(), 1 do
																local hero = Game.Hero(i)
																if hero.charName:lower():find("xerath") then
																	sLine.spell[6514] = {
																						endPos = Geometry.Vector3(obj.pos.x, obj.pos.y, obj.pos.z),
																						startPos = Geometry.Vector3(hero.pos.x, hero.pos.y, hero.pos.z),
																						danger = 0,
																						length = 3400,
																						width = 90,
																						id = 6514,
																						}
																	sLine.obj[6514] = { object = obj }
																end
															end												
														end
													end,
							}
		aoeP.xeratharcanebarrage2 = { danger = 1, object = "xerath", object2 = "w_aoe_red.troy", radius = 225, id = 40802 }
		linP.xerathmagespearmissile = { danger = 2, object = "xerath", object2 = "e_mis.troy", length = 1100, width = 80, id = 64965 }
		aoeP.xerathlocuspulse = { danger = 0, object = "xerath", object2 = "r_mis.troy", radius = 225, id = 64514 }
	end,
	yasuo = function()
		linP.yasuoq = { danger = 0, object = "yasuo", object2 = "q_windstrike.troy", length = 500, width = 80, id = 65451981 }
		linP.yasuoq2 = { danger = 0, object = "yasuo", object2 = "q_windstrike_02.troy", length = 500, width = 80, id = 8974198 }
		linP.yasuoq3 = { danger = 2, object = "yasuo", object2 = "q_wind_mis.troy", length = 1100, width = 80, id = 31907 }
	end,
	zac = function()
		linP.zacq = { danger = 0, object = "noobject", object2 = "noobject", length = 600, width = 70, id = 23086,
													uniqueObj = function(obj)
														if obj.name == "DrawFX" then 
															for linear in pairs(sLine.spell) do
																if linear and linear == 23086 then
																	if obj.pos:DistanceTo(sLine.spell[linear].startPos) == 0 then
																		sLine.obj[linear] = { object = obj }
																	end
																end
															end
														end
													end,
							}
	end,
	zed = function()
		linP.zedshuriken = { danger = 0, object = "zed", object2 = "q_mis.troy", length = 900, width = 60, id = 57461,
													uniqueObj = function(obj)
														if obj.name == "Zed_Q2_Mis.troy" then 
															for i=1, Game.ObjectCount(), 1 do
																local shadow = Game.Object(i)
																if shadow and shadow.name == "Shadow" then
																	sLine.spell[61935] = {
																						endPos = sLine.spell[57461].endPos,
																						startPos = shadow.pos,
																						danger = 0,
																						length = 900,
																						width = 60,
																						source = shadow
																						}
																	sLine.obj[61935] = { object = obj }
																	break
																end
															end
														end
													end,
							}
	end,
	ziggs = function()
		linP.ziggsq = { danger = 0, object = "ziggs", object2 = "q3.troy", length = function() return sLine.spell[38860].startPos:DistanceTo(sLine.spell[38860].endPos)*1.8 end, width = 80, id = 38860, }
		aoeP.ziggsw = { danger = 1, object = "ziggs", object2 = "w_mis.troy", radius = 250, id = 56999 }
		aoeP.ziggse = { danger = 1, object = "ziggse", object2 = "mis_small.troy", radius = 250, id = 59650 }
		aoeP.ziggsr = { danger = 0, object = "ziggsr", object2 = "mis_nuke.troy", radius = 500, id = 39821 }
	end,
	zyra = function()
		aoeP.zyraqfissure = { danger = 0, object = "zyra", object2 = "qfissure_cas_red.troy", radius = 265, id = 9461 }
		linP.zyragraspingroots = { danger = 2, object = "zyra", object2 = "e_sequence", length = 1300, width = 80, id = 2083, }
		aoeP.zyrabramblezone = { danger = 2, object = "zyra", object2 = "ult_cas_target_center.troy", radius = 550, id = 15592 }		
	end,
}
	
Callback.Bind('Load', function() OnLoad() end)

function OnLoad() Callback.Bind('GameStart', function() OnGameStart() end) end
				
function OnGameStart()
	if iTable[myHero.charName:lower()] ~= nil then
		iTable[myHero.charName:lower()]()
	end
	for i=1, Game.HeroCount() do
		local enemy = Game.Hero(i)
		if enemy and enemy.team ~= myHero.team and iTable[enemy.charName:lower()] ~= nil then
			iTable[enemy.charName:lower()]()
		end
	end
	
	mMenu = MenuConfig('nMenu', '<font color=\"#FF66CC\">Dancing Shoes</font>')
	mMenu:Icon('fa-fire')
	mMenu:Section('sec1', 'Options Menu')
	mMenu:KeyBinding('key', 'Stop Evading', 'T')
	--mMenu:Slider('slider', 'Calc Accuracy', 25, 5, 25)

	Callback.Bind('Draw', function() OnDraw() end)
	Callback.Bind('Tick', function() OnTick() end)
	Callback.Bind('CreateObj', function(obj) OnCreateObj(obj) end)
	Callback.Bind('DeleteObj', function(obj) OnDeleteObj(obj) end)
	Callback.Bind('ProcessSpell', function(unit, spell) OnProcessSpell(unit, spell) end)
	Callback.Bind('RecvPacket', function(p) OnRecvPacket(p) end)
	Callback.Bind('BugSplat', function(obj) OnCrash(obj) end)
	
	Game.Chat.Print("<font color=\"#FF66CC\">DancingShoes Loaded.</font>")
end

function OnTick()
	danger0Clip:Clear()
	--danger1Clip:Clear()
	--danger2Clip:Clear()
	--WallPolygon()
	for linSpell in pairs(sLine.spell) do
		if sLine.spell[linSpell] ~= nil then
			local foundObj = false
			for linObj in pairs(sLine.obj) do
				if sLine.obj[linObj] ~= nil and linObj == linSpell then
					foundObj = true					
					AddRectangle(sLine.spell[linSpell].startPos, sLine.spell[linSpell].endPos, sLine.spell[linSpell].length, sLine.spell[linSpell].width, sLine.obj[linObj].object, sLine.spell[linSpell].danger)
				end
			end
			if not foundObj and not sLine.spell[linSpell].source.charName:lower():find("janna") then
				AddRectangle(sLine.spell[linSpell].startPos, sLine.spell[linSpell].endPos, sLine.spell[linSpell].length, sLine.spell[linSpell].width, sLine.spell[linSpell].source, sLine.spell[linSpell].danger)
			end
		end
	end
	for aoeSpell in pairs(sAoe.spell) do
		if aoeSpell ~= nil then
			AddCircle(sAoe.spell[aoeSpell].radius, sAoe.spell[aoeSpell].endPos, sAoe.spell[aoeSpell].danger)
		end
	end
	for coneSpell in pairs(sCone.spell) do
		if sCone.spell[coneSpell] ~= nil then
			for coneObj in pairs(sCone.obj) do
				if coneObj ~= nil then
					AddCone(sCone.spell[coneSpell].radius, sCone.spell[coneSpell].endPos, sCone.spell[coneSpell].startPos, sCone.spell[coneSpell].center, sCone.obj[coneObj].object, sCone.spell[coneSpell].length, sCone.spell[coneSpell].width, sCone.spell[coneSpell].danger)
				end
			end
		end	
	end
	lvl0Poly = danger0Clip:Execute(Geometry.Clipper.XOR, Geometry.Clipper.EVEN_ODD, Geometry.Clipper.NON_ZERO)
	--lvl1Poly = danger1Clip:Execute(Geometry.Clipper.XOR, Geometry.Clipper.EVEN_ODD, Geometry.Clipper.NON_ZERO)
	--lvl2Poly = danger2Clip:Execute(Geometry.Clipper.XOR, Geometry.Clipper.EVEN_ODD, Geometry.Clipper.NON_ZERO)

	local myWTS = Graphics.WorldToScreen(Geometry.Vector3(myHero.x, myHero.y, myHero.z))			
	local myPoint = Geometry.Point(myWTS.x, myWTS.y)
	for i=1, #lvl0Poly, 1 do
		local curr = lvl0Poly:Get(i)
		if myPoint:IsInside(curr) then
			local movePoint = NearestNonPoly(myHero.x, myHero.y, myHero.z, 400, 25, curr)
			if movePoint then
				myHero:Move(movePoint.x, movePoint.z)
			end
		end
	end
	--[[for i=1, #lvl1Poly, 1 do
		local curr = lvl1Poly:Get(i)
		if myPoint:IsInside(curr) then
			local movePoint = NearestNonPoly(myHero.x, myHero.y, myHero.z, 400, 25, curr)
			if movePoint then
				myHero:Move(movePoint.x, movePoint.z)
			end
		end
	end
	for i=1, #lvl2Poly, 1 do
		local curr = lvl2Poly:Get(i)
		if myPoint:IsInside(curr) then
			local movePoint = NearestNonPoly(myHero.x, myHero.y, myHero.z, 400, 25, curr)
			if movePoint then
				myHero:Move(movePoint.x, movePoint.z)
			end
		end
	end]]
end

function AddRectangle(startPos, endPos, length, width, object, danger)
	local finalPos = nil
	if type(length) == "function" then
		length = length()
		finalPos = startPos + (endPos - startPos):Normalize()*length
	elseif legnth ~= nil then
		finalPos = startPos + (endPos - startPos):Normalize()*length
	else
		finalPos = endPos
	end
	local projectile = object
	local proWidth = width			
	
	local h = projectile.pos-finalPos
	
	local m1 = finalPos + Perpendicular2(h)
	local n1 = finalPos + Perpendicular(h)
	local f1 = finalPos + (finalPos-m1):Normalize()*proWidth
	local f2 = finalPos + (finalPos-n1):Normalize()*proWidth
	
	local k = finalPos-projectile.pos

	local m2 = projectile.pos + Perpendicular2(k)
	local n2 = projectile.pos + Perpendicular(k)
	local f3 = projectile.pos + (projectile.pos-m2):Normalize()*proWidth
	local f4 = projectile.pos + (projectile.pos-n2):Normalize()*proWidth
	
	
	local x1 = Graphics.WorldToScreen(Geometry.Vector3(f1.x, myHero.y, f1.z)) --endpos f3
	local x2 = Graphics.WorldToScreen(Geometry.Vector3(f2.x, myHero.y, f2.z)) -- f4
	local x3 = Graphics.WorldToScreen(Geometry.Vector3(f3.x, myHero.y, f3.z)) --object f3
	local x4 = Graphics.WorldToScreen(Geometry.Vector3(f4.x, myHero.y, f4.z)) -- f4
	
	local op = Geometry.Polygon()
	op:Add(Geometry.Point(x3.x, x3.y))
	op:Add(Geometry.Point(x4.x, x4.y))
	op:Add(Geometry.Point(x1.x, x1.y))
	op:Add(Geometry.Point(x2.x, x2.y))
	
	--local dangerLevel = danger
	--if dangerLevel == 0 then
		danger0Clip:AddClip(op, true)
	--elseif dangerLevel == 1 then
		--danger1Clip:AddClip(op, true)
	--elseif dangerLevel == 2 then
		--danger2Clip:AddClip(op, true)
	--end	
end

function AddCircle(radius, pos, danger)
	local quality = (2 * math.pi / (radius / 5))
	local x = pos.x
	local y = pos.y
	local z = pos.z
	local circle = Geometry.Polygon()
	for i=0, 2 * math.pi + quality, quality do
		local c = Graphics.WorldToScreen(Geometry.Vector3(x + radius * math.cos(i), y, z - radius * math.sin(i)))
		circle:Add(Geometry.Point(c.x, c.y))
	end
	--local dangerLevel = danger
	--if dangerLevel == 0 then
		danger0Clip:AddClip(circle, true)
	--elseif dangerLevel == 1 then
	--	danger1Clip:AddClip(circle, true)
	--elseif dangerLevel == 2 then
	--	danger2Clip:AddClip(circle, true)
	--end
end

function AddCone(radius, endPos, startPos, center, object, length, width, danger )
	local quality = (2 * math.pi / (radius / 5))
	local endPos = startPos + (endPos - startPos):Normalize()*center
	local x = endPos.x
	local y = startPos.y
	local z = endPos.z
	local circle = Geometry.Polygon()
	for i=0, 2 * math.pi + quality, quality do
		local c = Graphics.WorldToScreen(Geometry.Vector3(x + radius * math.cos(i), y, z - radius * math.sin(i)))
		circle:Add(Geometry.Point(c.x, c.y))
	end
	local coneClip = Geometry.Clipper()
	coneClip:AddSubject(circle, true)			
	local sector = Geometry.Polygon()
	local vectorTo = Geometry.Vector3(endPos.x, startPos.y, endPos.z)
	local vectorFrom = Geometry.Vector3(startPos.x, startPos.y, startPos.z)
	local objVector = Geometry.Vector3(object.pos.x, object.pos.y, object.pos.z)
	local drawDist = vectorFrom:DistanceTo(objVector)*1.04
	local drawVec = vectorFrom + (vectorTo - vectorFrom):Normalize()*drawDist
	local fromWTS = Graphics.WorldToScreen(drawVec)
	sector:Add(Geometry.Point(fromWTS.x, fromWTS.y))
	local center = vectorFrom + (vectorFrom-vectorTo):Normalize()*legnth	
	local centerTheta = vectorFrom-center
	local sideATheta = center + Perpendicular2(centerTheta)
	local sideBTheta = center + Perpendicular(centerTheta)
	local sideAVec = center + (center-sideATheta):Normalize()*(width+(drawDist))
	local sideBVec = center + (center-sideBTheta):Normalize()*(width+(drawDist))
	local polyAVec = vectorFrom + (vectorFrom-sideAVec):Normalize()*(length+drawDist)
	local polyBVec = vectorFrom + (vectorFrom-sideBVec):Normalize()*(length+drawDist)
	local polyAWTS = Graphics.WorldToScreen(Geometry.Vector3(polyAVec.x, polyAVec.y, polyAVec.z))
	local polyBWTS = Graphics.WorldToScreen(Geometry.Vector3(polyBVec.x, polyBVec.y, polyBVec.z))			
	sector:Add(Geometry.Point(polyAWTS.x, polyAWTS.y))
	sector:Add(Geometry.Point(polyBWTS.x, polyBWTS.y))		
	coneClip:AddClip(sector, true)
	local coneDrawing = coneClip:Execute(Geometry.Clipper.INTERSECTION, Geometry.Clipper.POSITIVE, Geometry.Clipper.NON_ZERO)
	
	--local dangerLevel = danger
	--if dangerLevel == 0 then
		danger0Clip:AddClip(coneDrawing, true)
	--elseif dangerLevel == 1 then
	--	danger1Clip:AddClip(coneDrawing, true)
	--elseif dangerLevel == 2 then
	--	danger2Clip:AddClip(coneDrawing, true)
	--end
end

function OnDraw()
	lvl0Poly:DrawOutline(2, Graphics.ARGB(255, 255, 255, 255))
	--lvl1Poly:DrawOutline(2, Graphics.ARGB(255, 255, 255, 0))
	--lvl2Poly:DrawOutline(2, Graphics.ARGB(255, 255, 0, 0))
end	

function OnRecvPacket(p)
	if p.header == 59 then
		local ss = {}
		p.pos = 1
		ss.ProjectileID		= p:DecodeF()
		ss.startPos			= Geometry.Vector3(p:DecodeF(), p:DecodeF(), p:DecodeF())
		p:Skip(12) 			--Another startPos
		ss.AngleX			= p:DecodeF()
		p:Skip(4)			--unknown, dont care
		ss.AngleZ			= p:DecodeF()
		p:Skip(12)			--OnScreen??
		p:Skip(12)			--Another startPos
		ss.endPos			= Geometry.Vector3(p:DecodeF(), p:DecodeF(), p:DecodeF())
		ss.sourcePos		= Geometry.Vector3(p:DecodeF(), p:DecodeF(), p:DecodeF())
		ss.delay			= p:DecodeF()*1000
		ss.Range			= p:DecodeF()
		p:Skip(15)			--unknown 97
		ss.spellID			= p:Decode2()
		p:Skip(11)			--unknown, contains projectileID 99, nothing useful
		ss.source			= Game.ObjectByNetworkId(p:Decode4())
		p:Skip(12)			--unknown, contains projectileID, contains second source netID 114
		p:Skip(12)			--Another endPos/castPos
		ss.castPos			= Geometry.Vector3(p:DecodeF(), p:DecodeF(), p:DecodeF())
		p:Skip(13)			--unknown
		ss.cd				= p:DecodeF()
		
		if ss.source.team ~= myHero.team and myHero:DistanceTo(ss.sourcePos) < 2000 and (not ss.source.visible or ss.source.charName:lower():find("janna")) then
			for linear in pairs(linP) do
				if linP[linear].id == ss.spellID then			
					for linSpell in pairs(sLine.spell) do
						if sLine.spell[linSpell] == linP[linear].id then
							return 
						end
					end
					sLine.spell[linP[linear].id] = 	{
												endPos = ss.endPos,
												startPos = ss.startPos,
												danger = linP[linear].danger,
												length = linP[linear].length,
												width = linP[linear].width,
												source = ss.source
												}
				elseif linP[linear].uniqueSpell ~= nil then
					linP[linear].uniqueSpell(unit, spell)
				end
			end
			
			for aoeSpell in pairs(aoeP) do
				if aoeSpell and aoeP[aoeSpell].id == ss.spellID then
					sAoe.spell[aoeP[aoeSpell].id] = {
												endPos = ss.endPos,
												danger = aoeP[aoeSpell].danger,
												radius = aoeP[aoeSpell].radius,
												}
				end
			end
			for coneSpell in pairs(conP) do
				if coneSpell and conP[coneSpell].id == ss.spellID then
					if sCone.spell[conP[coneSpell].id] == nil then
						sCone.spell[conP[coneSpell].id] = {
													endPos = ss.endPos,
													startPos = ss.startPos,
													danger = conP[coneSpell].danger,
													length = conP[coneSpell].length,
													radius = conP[coneSpell].radius,
													width = conP[coneSpell].width,
													center = conP[coneSpell].center
													}
					end
				end
			end			
		end
	end
end

function NearestNonPoly( x0, y0, z0, maxRadius, precision, polygon )
    local radius, gP = 1, precision or 50
    x0, y0, z0, maxRadius = math.ceil(x0/gP)*gP, math.ceil(y0/gP)*gP, math.ceil(z0/gP)*gP, maxRadius and math.floor(maxRadius/gP) or math.huge
    local function toGamePos(x, y) return x0+x*gP, y0, z0+y*gP end
    while radius<=maxRadius do
        for i = 1, 4 do
			local p = Geometry.Vector3(toGamePos((i==2 and radius) or (i==4 and -radius) or 0,(i==1 and radius) or (i==3 and -radius) or 0))
			local wts = Graphics.WorldToScreen(p)			
			local wtsp = Geometry.Point(wts.x, wts.y)		   
		   if not wtsp:IsInside(polygon) then return p end
        end
        local f, x, y = 1-radius, 0, radius
        while x<y-1 do
            x = x + 1
            if f < 0 then f = f+1+x+x
            else y, f = y-1, f+1+x+x-y-y end
            for i=1, 8 do
                local w = math.ceil(i/2)%2==0
                local p = Geometry.Vector3(toGamePos(((i+1)%2==0 and 1 or -1)*(w and x or y),(i<=4 and 1 or -1)*(w and y or x)))
				local wts = Graphics.WorldToScreen(p)			
				local wtsp = Geometry.Point(wts.x, wts.y)               
				if not wtsp:IsInside(polygon) then return p end
            end
        end
        radius = radius + 1
    end
	return nil
end

function OnCreateObj(obj)
	if myHero:DistanceTo(obj) > 2000 then return end
	local name = obj.name:lower()
	for linear in pairs(linP) do
		if linear then
			if name:find(linP[linear].object2) and name:find(linP[linear].object) then
				sLine.obj[linP[linear].id] = { object = obj }
			elseif linP[linear].uniqueObj ~= nil then
				linP[linear].uniqueObj(obj)
			end
		end
	end
	for aoe in pairs(aoeP) do
		if aoe and name:find(aoeP[aoe].object2) and name:find(aoeP[aoe].object) then
			sAoe.obj[aoeP[aoe].id] = {object = obj, danger = aoeP[aoe].danger, radius = aoeP[aoe].radius}
		end		
	end
	for cone in pairs(conP) do
		if cone and name:find(conP[cone].object2) and name:find(conP[cone].object) then
			if sCone.obj[conP[cone].id] == nil then
				sCone.obj[conP[cone].id] = { object = obj }
			end	
		elseif conP[cone].uniqueObj ~= nil then
			conP[cone].uniqueObj(obj)
		end
	end
end

function OnDeleteObj(obj)
	for linearObj in pairs(sLine.obj) do
		if linearObj and sLine.obj[linearObj].object == obj then
			for linearSpell in pairs(sLine.spell) do
				if linearSpell and linearObj == linearSpell then
					sLine.obj[linearObj] = nil
					sLine.spell[linearSpell] = nil
					return
				end
			end
		end
	end
	for aoeObj in pairs(sAoe.obj) do
		if aoeObj and sAoe.obj[aoeObj].object == obj then
			for aoeSpell in pairs(sAoe.spell) do
				if aoeSpell and aoeSpell == aoeObj then
					sAoe.obj[aoeObj] = nil
					sAoe.spell[aoeSpell] = nil
				end
			end
		end
	end
	for coneObj in pairs(sCone.obj) do
		if coneObj and sCone.obj[coneObj].object == obj then
			for coneSpell in pairs(sCone.spell) do
				if coneSpell and coneSpell == coneObj then
					sCone.obj[coneObj] = nil
					sCone.spell[coneSpell] = nil
				end
			end
		end
	end
end

function OnProcessSpell(unit, spell)
	if unit and (unit.team == myHero.team or unit.type ~= myHero.type or myHero:DistanceTo(unit) > 2000) then return end
	for linear in pairs(linP) do
		if spell.name:lower():find(linear) then
			for linSpell in pairs(sLine.spell) do
				if linSpell == linP[linear].id then
					return 
				end
			end
			sLine.spell[linP[linear].id] = 	{
										endPos = Geometry.Vector3(spell.endPos.x, spell.endPos.y, spell.endPos.z),
										startPos = unit.pos,
										danger = linP[linear].danger,
										length = linP[linear].length,
										width = linP[linear].width,
										source = unit
										}
			return
		elseif linP[linear].uniqueSpell ~= nil then
			linP[linear].uniqueSpell(unit, spell)
		end
	end
	
	for aoeSpell in pairs(aoeP) do
		if spell.name:lower():find(aoeSpell) then
			sAoe.spell[aoeP[aoeSpell].id] = {
										endPos = Geometry.Vector3(spell.endPos.x, spell.endPos.y, spell.endPos.z),
										danger = aoeP[aoeSpell].danger,
										radius = aoeP[aoeSpell].radius,
										}
		end
	end
	for coneSpell in pairs(conP) do
		if spell.name:lower():find(coneSpell) then
			sCone.spell[conP[coneSpell].id] = {
										endPos = Geometry.Vector3(spell.endPos.x, spell.endPos.y, spell.endPos.z),
										startPos = unit.pos,
										danger = conP[coneSpell].danger,
										length = conP[coneSpell].length,
										radius = conP[coneSpell].radius,
										width = conP[coneSpell].width,
										center = conP[coneSpell].center
										}
		end
	end
end

function WallPolygon()
	local x0 = mMenu.slider:Value()
	for x=(myHero.x-400), (myHero.x+400), (2*x0) do
		for z=(myHero.z-400), (myHero.z+400), (2*x0) do		
			if Game.IsWall(Geometry.Vector3(x, myHero.y, z)) then				
				local x1 = Graphics.WorldToScreen(Geometry.Vector3(x-x0, myHero.y, z-x0))
				local x2 = Graphics.WorldToScreen(Geometry.Vector3((x+x0), myHero.y, (z-x0)))
				local x3 = Graphics.WorldToScreen(Geometry.Vector3((x-x0), myHero.y, (z+x0)))
				local x4 = Graphics.WorldToScreen(Geometry.Vector3((x+x0), myHero.y, (z+x0)))			
				local lp = Geometry.Polygon()
				lp:Add(Geometry.Point(x1.x, x1.y))
				lp:Add(Geometry.Point(x2.x, x2.y))
				lp:Add(Geometry.Point(x4.x, x4.y))
				lp:Add(Geometry.Point(x3.x, x3.y))				
				danger0Clip:AddClip(lp, true)
			end
		end
	end	
end

function Perpendicular2(v)
    return Geometry.Vector3(v.z, v.y, -v.x)
end

function Perpendicular(v)
    return Geometry.Vector3(-v.z, v.y, v.x)
end

function UniqueDraven()
	for i=1, #sLine.obj, 1 do
		if sLine.obj[i] and sLine.obj[i].id == 4196 then
			Game.Chat.Print(tostring(sLine.obj[i].object.pos.z))
			if sLine.obj[i].object.pos.x >= 13800 or sLine.obj[i].object.pos.x <= 75 or sLine.obj[i].object.pos.z >= 12000 or sLine.obj[i].object.pos.z <= 1000 then
				for j=1, #sLine.spell, 1 do
					if sLine.spell[j] and sLine.spell[j].id == 4196 then
						local objEnd = sLine.spell[j].startPos
						table.remove(sLine.spell, j)
						table.insert(sLine.spell, j, {
													endPos = objEnd,
													startPos = Geometry.Vector3(sLine.obj[i].object.pos.x, sLine.obj[i].object.pos.y, sLine.obj[i].object.pos.z),
													danger = 0,
													length = 1600,
													width = 70,
													id = 4196
													})
						Callback.Unbind('Tick', function() UniqueDraven() end)
					end
				end
			end		
		end																
	end
end

function OnCrash(obj)
	local file = io.open("C:\\Users\\Maximus\\something.txt", "a")
	file:write("\n CRASHED HAHAHA!")
	file:close()
end
