local spellList = {
	 ['ireliagatotsu'] = {character = 'irelia', slot = 'Q', cc = false, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['zyraqfissure'] = {character = 'zyra', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['veigarbalefulstrike'] = {character = 'veigar', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['timebomb'] = {character = 'zilean', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['riventricleave_03'] = {character = 'riven', slot = 'Q', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['blindmonkqone'] = {character = 'leesin', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['rocketgrabmissile'] = {character = 'blitzcrank', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['zedshuriken'] = {character = 'zed', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['yasuoqw'] = {character = 'yasuo', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['overload'] = {character = 'ryze', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['urgotheatseekingmissile'] = {character = 'urgot', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['yorickspectral'] = {character = 'yorick', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['sejuaniarcticassault'] = {character = 'sejuani', slot = 'Q', cc = true, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['starcall'] = {character = 'soraka', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['yasuoq2w'] = {character = 'yasuo', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['dariuscleave'] = {character = 'darius', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['poisentrail'] = {character = 'singed', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['pulverize'] = {character = 'alistar', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['xenzhaocombotarget'] = {character = 'xinzhao', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['xeratharcanopulsechargeup'] = {character = 'xerath', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['khazixqlong'] = {character = 'khazix', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['trundletrollsmash'] = {character = 'trundle', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['hungeringstrike'] = {character = 'warwick', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['nocturneduskbringer'] = {character = 'nocturne', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['mordekaisermaceofspades'] = {character = 'mordekaiser', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['luxlightbinding'] = {character = 'lux', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['jarvanivdragonstrike'] = {character = 'jarvaniv', slot = 'Q', cc = false, type = 'linear', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['galioresolutesmite'] = {character = 'galio', slot = 'Q', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['vladimirtransfusion'] = {character = 'vladimir', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['flashfrost'] = {character = 'anivia', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['viq'] = {character = 'vi', slot = 'Q', cc = true, type = 'linear', gapClose = 'unit', interuptable = true, exhaust = false},
	 ['vaynetumble'] = {character = 'vayne', slot = 'Q', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['seismicshard'] = {character = 'malphite', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['velkozqplitactive'] = {character = 'velkoz', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['velkozqmissle'] = {character = 'velkoz', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['elisespiderqcast'] = {character = 'elise', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['pantheon_throw'] = {character = 'pantheon', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['rumbleflamethrower'] = {character = 'rumble', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['nautilusanchordrag'] = {character = 'nautilus', slot = 'Q', cc = true, type = 'aoe', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['missfortunericochetshot'] = {character = 'missfortune', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['hecarimrapidslash'] = {character = 'hecarim', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['terrify'] = {character = 'fiddlesticks', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['varusq'] = {character = 'varus', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = true, exhaust = false},
	 ['zacq'] = {character = 'zac', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['threshq'] = {character = 'thresh', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['aatroxq'] = {character = 'aatrox', slot = 'Q', cc = true, type = 'aoe', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['akalimota'] = {character = 'akali', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['darkbindingmissile'] = {character = 'morgana', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['nulllance'] = {character = 'kassadin', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['ahriorbofdeception'] = {character = 'ahri', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['dianaarc'] = {character = 'diana', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['viktorpowertransfer'] = {character = 'viktor', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['syndraq'] = {character = 'syndra', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['frostarrow'] = {character = 'ashe', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['wildcards'] = {character = 'twistedfate', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['lissandraq'] = {character = 'lissandra', slot = 'Q', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['alphastrike'] = {character = 'masteryi', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['disintegrate'] = {character = 'annie', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['skarnervirulentslash'] = {character = 'skarner', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['cassiopeianoxiousblast'] = {character = 'cassiopeia', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['rupture'] = {character = 'chogath', slot = 'Q', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['blindingdart'] = {character = 'teemo', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['quinnq'] = {character = 'quinn', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['namiq'] = {character = 'nami', slot = 'Q', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['braumq'] = {character = 'braum', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['katarinaq'] = {character = 'katarina', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['braumqmissle'] = {character = 'braum', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['crypticgaze'] = {character = 'sion', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['fioraq'] = {character = 'fiora', slot = 'Q', cc = false, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['gragasbarrelroll'] = {character = 'gragas', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['swaindecrepify'] = {character = 'swain', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['yasuoq3w'] = {character = 'yasuo', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['sonahymnofvalor'] = {character = 'sona', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['judicatorreckoning'] = {character = 'kayle', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['sivirq'] = {character = 'sivir', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['infectedcleavermissilecast'] = {character = 'drmundo', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['velkozq'] = {character = 'velkoz', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['howlinggale'] = {character = 'janna', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['riventricleav'] = {character = 'riven', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['jaycetotheskies'] = {character = 'jayce', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['jaxleapstrike'] = {character = 'jax', slot = 'Q', cc = false, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['renektoncleave'] = {character = 'renekton', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['lucianq'] = {character = 'lucian', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['powerball'] = {character = 'rammus', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['maokaitrunkline'] = {character = 'maokai', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['caitlynpiltoverpeacemaker'] = {character = 'caitlyn', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['luluq'] = {character = 'lulu', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['orianaizunacommand'] = {character = 'orianna', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['olafaxethrowcast'] = {character = 'olaf', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['javelintoss'] = {character = 'nidalee', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['consume'] = {character = 'nunu', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['parley'] = {character = 'gangplank', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['ezrealmysticshot'] = {character = 'ezreal', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['fizzpiercingstrike'] = {character = 'fizz', slot = 'Q', cc = false, type = 'targeted', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['jayceshockblast'] = {character = 'jayce', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['leblancchaosorb'] = {character = 'leblanc', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['blindmonkqtwodash'] = {character = 'leesin', slot = 'Q', cc = false, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['riventricleave'] = {character = 'riven', slot = 'Q', cc = false, type = 'linear', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['threshqleap'] = {character = 'thresh', slot = 'Q', cc = false, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['volibearq'] = {character = 'volibear', slot = 'Q', cc = true, type = 'targeted', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['brandblaze'] = {character = 'brand', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['bandagetoss'] = {character = 'amumu', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['ziggsq'] = {character = 'ziggs', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['shenvorpalstar'] = {character = 'shen', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['karmaq'] = {character = 'karma', slot = 'Q', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['khazixq'] = {character = 'khazix', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['elisehumanq'] = {character = 'elise', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['gravesclustershot'] = {character = 'graves', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['kennenshurikenhurlmissile1'] = {character = 'kennen', slot = 'Q', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['evelynnq'] = {character = 'evelynn', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['phosphorusbomb'] = {character = 'corki', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['gragasbarrelrolltoggle'] = {character = 'gragas', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['laywaste'] = {character = 'karthus', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['kogmawcausticspittle'] = {character = 'kogmaw', slot = 'Q', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['blindmonkqtwo'] = {character = 'leesin', slot = 'Q', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['alzaharcallofthevoid'] = {character = 'malzahar', slot = 'Q', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['mockingshout'] = {character = 'tryndamere', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['volley'] = {character = 'ashe', slot = 'W', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['cassiopeiamiasma'] = {character = 'cassiopeia', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['rengarw'] = {character = 'rengar', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['hecarimw'] = {character = 'hecarim', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['vladimirsanguinepool'] = {character = 'vladimir', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['caitlynyordletrap'] = {character = 'caitlyn', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['zacw'] = {character = 'zac', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['alzaharnullzone'] = {character = 'malzahar', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['jaxempowertwo'] = {character = 'jax', slot = 'W', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['shatter'] = {character = 'taric', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['xeratharcanebarrage2'] = {character = 'xerath', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['luluw'] = {character = 'lulu', slot = 'W', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['hunterscall'] = {character = 'warwick', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['gravessmokegrenadeboom'] = {character = 'graves', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['volibearw'] = {character = 'volibear', slot = 'W', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['sowthewind'] = {character = 'janna', slot = 'W', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['viktorgravitonfield'] = {character = 'viktor', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['twitchvenomcask'] = {character = 'twitch', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['elisehumanw'] = {character = 'elise', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['kogmawbioarcanbarrage'] = {character = 'kogmaw', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['gravessmokegrenade'] = {character = 'graves', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['carpetbomb'] = {character = 'corki', slot = 'W', cc = false, type = 'linear', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['burningagony'] = {character = 'drmundo', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['lucianw'] = {character = 'lucian', slot = 'W', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['jinxw'] = {character = 'jinx', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['veigardarkmatter'] = {character = 'veigar', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['urgotterrorcapacitoractive2'] = {character = 'urgot', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['lissandraw'] = {character = 'lissandra', slot = 'W', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['leblancslide'] = {character = 'leblanc', slot = 'W', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['katarinaw'] = {character = 'katarina', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['pickacard'] = {character = 'twistedfate', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['rocketjump'] = {character = 'tristana', slot = 'W', cc = false, type = 'aoe', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['brandfissure'] = {character = 'brand', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['velkozw'] = {character = 'velkoz', slot = 'W', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['wallofpain'] = {character = 'karthus', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['bushwhack'] = {character = 'nidalee', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['talonrake'] = {character = 'talon', slot = 'W', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['pounce'] = {character = 'nidalee', slot = 'W', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['incinerate'] = {character = 'annie', slot = 'W', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['maokaiunstablegrowth'] = {character = 'maokai', slot = 'W', cc = true, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['rivenmartyr'] = {character = 'riven', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['swainshadowgrasp'] = {character = 'swain', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['heimerdingerw'] = {character = 'heimerdinger', slot = 'W', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['orianadissonancecommand'] = {character = 'orianna', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['sivirw'] = {character = 'sivir', slot = 'W', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['drain'] = {character = 'fiddlesticks', slot = 'W', cc = false, type = 'targeted', gapClose = nil, interuptable = true, exhaust = false},
	 ['deathscaressfull'] = {character = 'sion', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['pantheonw'] = {character = 'pantheon', slot = 'W', cc = true, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['runeprison'] = {character = 'ryze', slot = 'W', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['syndraw '] = {character = 'syndra', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['megaadhesive'] = {character = 'singed', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['dariusnoxiantacticsonh'] = {character = 'darius', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['tormentedsoil'] = {character = 'morgana', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['jackinthebox'] = {character = 'shaco', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['sejuaninorthernwinds'] = {character = 'sejuani', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['pantheon_leapbash'] = {character = 'pantheon', slot = 'W', cc = true, type = 'targeted', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['khazixw'] = {character = 'khazix', slot = 'W', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['jaycestaticfield'] = {character = 'jayce', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['ziggsw'] = {character = 'ziggs', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['akalismokebomb'] = {character = 'akali', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['headbutt'] = {character = 'alistar', slot = 'W', cc = true, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['feralscream'] = {character = 'chogath', slot = 'W', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['dianaorbs'] = {character = 'diana', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['kennenbringthelight'] = {character = 'kennen', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['khazixwlong'] = {character = 'khazix', slot = 'W', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['ezrealessenceflux'] = {character = 'ezreal', slot = 'W', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['auraofdespair'] = {character = 'amumu', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['jarvanivgoldenaegis'] = {character = 'jarvaniv', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['ahrifoxfire'] = {character = 'ahri', slot = 'W', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['karmaspiritbind'] = {character = 'karma', slot = 'W', cc = true, type = 'targeted', gapClose = nil, interuptable = true, exhaust = false},
	 ['twitchvenomcaskmissle'] = {character = 'twitch', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['namiw'] = {character = 'nami', slot = 'W', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['yorickdecayed'] = {character = 'yorick', slot = 'W', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['zyragraspingroots'] = {character = 'zyra', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['vorpalspikes'] = {character = 'chogath', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['dianavortex'] = {character = 'diana', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['fiddlesticksdarkwind'] = {character = 'fiddlesticks', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['timewarp'] = {character = 'zilean', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['olafrecklessstrike'] = {character = 'olaf', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['katarinae'] = {character = 'katarina', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['ziggse'] = {character = 'ziggs', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['zedpbaoedummy'] = {character = 'zed', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['gragasbodyslam'] = {character = 'gragas', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['shyvanafireball'] = {character = 'shyvana', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['ahriseduce'] = {character = 'ahri', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['garene'] = {character = 'garen', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['yasuodashwrapper'] = {character = 'yasuo', slot = 'E', cc = false, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['monkeykingnimbus'] = {character = 'monkeyking', slot = 'E', cc = false, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['heimerdingere'] = {character = 'heimerdinger', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['pantheon_heartseeker'] = {character = 'pantheon', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = true, exhaust = false},
	 ['xerathmagespear'] = {character = 'xerath', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['landslide'] = {character = 'malphite', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['blooscent'] = {character = 'warwick', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['spellflux'] = {character = 'ryze', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['dazzle'] = {character = 'taric', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['rengare'] = {character = 'rengar', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['vladimirtidesofblood'] = {character = 'vladimir', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['forcepulse'] = {character = 'kassadin', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['alzaharmaleficvisions'] = {character = 'malzahar', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['viktordeathra'] = {character = 'viktor', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['ezrealarcaneshift'] = {character = 'ezreal', slot = 'E', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['dariusaxegrabcone'] = {character = 'darius', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['puncturingtaunt'] = {character = 'rammus', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['velkoze'] = {character = 'velkoz', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['gnare'] = {character = 'gnar', slot = 'E', cc = false, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['gnarbige'] = {character = 'gnar', slot = 'E', cc = true, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['gragase'] = {character = 'gragas', slot = 'E', cc = true, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['gravesmove'] = {character = 'graves', slot = 'E', cc = false, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['luciane'] = {character = 'lucian', slot = 'E', cc = false, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['quinnvalore'] = {character = 'quinn', slot = 'E', cc = false, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['iceblast'] = {character = 'nunu', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['infusewrapper'] = {character = 'soraka', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['veigareventhorizon'] = {character = 'veigar', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['vaynecondemm'] = {character = 'vayne', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['zace'] = {character = 'zac', slot = 'E', cc = true, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['galiorighteousgust'] = {character = 'galio', slot = 'E', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['khazixe'] = {character = 'khazix', slot = 'E', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['urgotplasmagrenade'] = {character = 'urgot', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['taloncutthroat'] = {character = 'talon', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['dravendoubleshot'] = {character = 'draven', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['slashcast'] = {character = 'tryndamere', slot = 'E', cc = false, type = 'aoe', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['trundlecircle'] = {character = 'trundle', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['quinne'] = {character = 'quinn', slot = 'E', cc = true, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['detonatingshot'] = {character = 'tristana', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['renektonsliceanddice'] = {character = 'renekton', slot = 'E', cc = true, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['leonazenithblade'] = {character = 'leona', slot = 'E', cc = true, type = 'linear', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['skarnerfracture'] = {character = 'skarner', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['powerfist'] = {character = 'blitzcrank', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['xenzhaosweep'] = {character = 'xinzhao', slot = 'E', cc = true, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['syndrae'] = {character = 'syndra', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['caitlynentrapment'] = {character = 'caitlyn', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['khazixelong'] = {character = 'khazix', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['luxlightstriketoggle'] = {character = 'lux', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['fizzjump'] = {character = 'fizz', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['jarvanivdemacianstandard'] = {character = 'jarvaniv', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['blindmonkeone'] = {character = 'leesin', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['enrage'] = {character = 'sion', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['fling'] = {character = 'singed', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['frostbite'] = {character = 'anivia', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['rumbegrenade'] = {character = 'rumble', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['cardmasterstack'] = {character = 'twistedfate', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['nautilussplashzone'] = {character = 'nautilus', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['shenshadowdash'] = {character = 'shen', slot = 'E', cc = true, type = 'linear', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['elisehumane'] = {character = 'elise', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['maokaisapling2'] = {character = 'maokai', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['threshe'] = {character = 'thresh', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['jaycethunderingblow'] = {character = 'jayce', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['leonazenithblademissle'] = {character = 'leona', slot = 'E', cc = true, type = 'linear', gapClose = 'unit', interuptable = false, exhaust = false},
	 ['moltenshield'] = {character = 'annie', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['sejuaniwintersclaw'] = {character = 'sejuani', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['yorickravenous'] = {character = 'yorick', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['mordekaisersyphoneofdestruction'] = {character = 'mordekaiser', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['ggun'] = {character = 'corki', slot = 'E', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['expunge'] = {character = 'twitch', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['orianaredactcommand'] = {character = 'orianna', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['brandconflagration'] = {character = 'brand', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['varuse'] = {character = 'varus', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['twoshivpoisen'] = {character = 'shaco', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['swipe'] = {character = 'nidalee', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['nasuse'] = {character = 'nasus', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['leblancsoulshackle'] = {character = 'leblanc', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['fizzjumptwo'] = {character = 'fizz', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['kogmawvoidooze'] = {character = 'kogmaw', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['missfortunescattershot'] = {character = 'missfortune', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['swaintorment'] = {character = 'swain', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['aatroxe'] = {character = 'aatrox', slot = 'E', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['lulue'] = {character = 'lulu', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['luxlightstrikekugel'] = {character = 'lux', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['defile'] = {character = 'karthus', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['cassiopeiatwinfang'] = {character = 'cassiopeia', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['tantrum'] = {character = 'amumu', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['blindmonketwo'] = {character = 'leesin', slot = 'E', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['akalishadowswipe'] = {character = 'akali', slot = 'E', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['ireliaequilibriumstrike'] = {character = 'irelia', slot = 'E', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['lissandrae'] = {character = 'lissandra', slot = 'E', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['evelynne'] = {character = 'evelynn', slot = 'E', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['poppyheroiccharge'] = {character = 'poppy', slot = 'E', cc = true, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['braumr'] = {character = 'braum', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['zyrabramblezone'] = {character = 'zyra', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['ziggsr'] = {character = 'ziggs', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['jarvanivcataclysm'] = {character = 'jarvaniv', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['zedult'] = {character = 'zed', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['shyvanatransformcast'] = {character = 'shyvana', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = true, exhaust = false},
	 ['zacr'] = {character = 'zac', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['katarinar'] = {character = 'katarina', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = true, exhaust = true},
	 ['tremors2'] = {character = 'rammus', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['missfortunebullettime'] = {character = 'missfortune', slot = 'R', cc = false, type = 'linear', gapClose = nil, interuptable = true, exhaust = true},
	 ['ireliatranscendentblades'] = {character = 'irelia', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['sonacrescendo'] = {character = 'sona', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['leonasolarflare'] = {character = 'leona', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['fallenone'] = {character = 'karthus', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = true, exhaust = true},
	 ['gragasexplosivecask'] = {character = 'gragas', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['luxmalicecannon'] = {character = 'lux', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['jaxrelentlessasssault'] = {character = 'jax', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['galioidolofdurand'] = {character = 'galio', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = true, exhaust = true},
	 ['monkeykingspintowin'] = {character = 'monkeyking', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['infiniteduress'] = {character = 'warwick', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = true, exhaust = false},
	 ['viktorchaosstorm'] = {character = 'viktor', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['Highlander'] = {character = 'masteryi', spellSlot = 'R', type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['vladimirhemoplague'] = {character = 'vladimir', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['dariusexecute'] = {character = 'darius', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['curseofthesadmumm'] = {character = 'amumu', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['crowstorm'] = {character = 'fiddlesticks', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = true, exhaust = true},
	 ['velkozr'] = {character = 'velkoz', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = true, exhaust = true},
	 ['quinnr'] = {charName = 'quinn', spellSlot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['cannibalism'] = {character = 'sion', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['leblancchaosorbm'] = {character = 'leblanc', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['xerathlocusofpower2'] = {character = 'xerath', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = true, exhaust = false},
	 ['kogmawlivingartillery'] = {character = 'kogmaw', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['varusr'] = {character = 'varus', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['staticfield'] = {character = 'blitzcrank', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['urgotswap2'] = {character = 'urgot', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = true, exhaust = false},
	 ['blindmonkrkick'] = {character = 'leesin', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['missilebarrage'] = {character = 'corki', slot = 'R', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['leblancslidem'] = {character = 'leblanc', slot = 'R', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['fullautomatic'] = {character = 'twitch', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['orianadetonatecommand'] = {character = 'orianna', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['garenr'] = {character = 'garen', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['alzaharnethergrasp'] = {character = 'malzahar', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = true, exhaust = false},
	 ['lulur'] = {character = 'lulu', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['sejuaniglacialprisonstart'] = {character = 'sejuani', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['trundlepain'] = {character = 'trundle', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['bustershot'] = {character = 'tristana', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['desperatepower'] = {character = 'ryze', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['vayneinquisition'] = {charName = 'vayne', spellSlot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['bantamtrap'] = {character = 'teemo', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['maokaidrain3'] = {character = 'maokai', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['xenzhaoparry'] = {character = 'xinzhao', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['pantheon_grandskyfall_jump'] = {character = 'pantheon', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = true, exhaust = false},
	 ['infernalguardian'] = {character = 'annie', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['skarnerimpale'] = {character = 'skarner', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = true, exhaust = false},
	 ['swainmetamorphism'] = {character = 'swain', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['fioradance'] = {character = 'fiora', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['veigarprimordialburst'] = {character = 'veigar', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['brandwildfire'] = {character = 'brand', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['tarichammersmash'] = {character = 'taric', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['threshrpenta'] = {character = 'thresh', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['talonshadowassault'] = {character = 'talon', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['rumblecarpetbomb'] = {character = 'rumble', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = true},
	 ['nasusr'] = {character = 'nasus', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['rivenizunablade'] = {character = 'riven', slot = 'R', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = true},
	 ['renektonreignofthetyrant'] = {character = 'renekton', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['evelynnr'] = {character = 'evelynn', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['absolutezero'] = {character = 'nunu', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = true, exhaust = true},
	 ['nocturneparanoia'] = {character = 'nocturne', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['enchantedcrystalarrow'] = {character = 'ashe', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['nautilusgandline'] = {character = 'nautilus', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['namir'] = {character = 'nami', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['mordekaiserchildrenofthegrave'] = {character = 'mordekaiser', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['leblancsoulshacklem'] = {character = 'leblanc', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['dravenrcast'] = {character = 'draven', slot = 'R', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['hallucinatefull'] = {character = 'shaco', slot = 'R', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['ufslash'] = {character = 'malphite', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['akalishadowdance'] = {character = 'akali', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['glacialstorm'] = {character = 'anivia', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['caitlynaceinthehole'] = {character = 'caitlyn', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = true, exhaust = true},
	 ['lucianr'] = {character = 'lucian', slot = 'R', cc = false, type = 'linear', gapClose = nil, interuptable = true, exhaust = false},
	 ['kennenshurikenstorm '] = {character = 'kennen', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['feast'] = {character = 'chogath', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['hecarimult'] = {character = 'hecarim', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['fizzmarinerdoom'] = {character = 'fizz', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['graveschargeshot'] = {character = 'graves', slot = 'R', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['jinxrwrapper'] = {character = 'jinx', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
	 ['syndrar'] = {character = 'syndra', slot = 'R', cc = false, type = 'targeted', gapClose = nil, interuptable = false, exhaust = true},
	 ['soulshackles'] = {character = 'morgana', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['cassiopeiapetrifyinggaze'] = {character = 'cassiopeia', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['lissandrar'] = {character = 'lissandra', slot = 'R', cc = true, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['vir'] = {character = 'vi', slot = 'R', cc = true, type = 'targeted', gapClose = nil, interuptable = false, exhaust = false},
	 ['ahritumble'] = {character = 'ahri', slot = 'R', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['riftwalk'] = {character = 'kassadin', slot = 'R', cc = false, type = 'aoe', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['aatroxr'] = {character = 'aatrox', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['cannonbarrage'] = {character = 'gangplank', slot = 'R', cc = true, type = 'aoe', gapClose = nil, interuptable = false, exhaust = true},
	 ['dianateleport'] = {character = 'diana', slot = 'R', cc = true, type = 'targeted', gapClose = 'spell', interuptable = false, exhaust = false},
	 ['ezrealtruehotbarrage'] = {character = 'ezreal', slot = 'R', cc = false, type = 'linear', gapClose = nil, interuptable = false, exhaust = false},
	 ['yasuorknockupcombow'] = {character = 'yasuo', slot = 'R', cc = false, type = 'aoe', gapClose = nil, interuptable = false, exhaust = false},
}
local buffList = {
	['aatrox'] = {ccName = 'aatroxqknockup'},
	['ahri'] = {ccName = 'ahriseducedoom'},
	['amumu'] = {ccName = 'CurseoftheSadMummy'},
	['blitzcrank'] = {ccName = 'powerfistslow'},
	['braum'] = {ccName = 'braumstundebuff', 'braumpulselineknockup'},
	['chogath'] = {ccName = 'rupturetarget'},
	['elise'] = {ccName = 'EliseHumanE'},
	['janna'] = {ccName = 'HowlingGaleSpell'},
	['jarvanIV'] = {ccName = 'jarvanivdragonstrikeph2'},
	['karma'] = {ccName = 'karmaspiritbindroot'},
	['lux'] = {ccName = 'LuxLightBindingMis'},
	['lissandra'] = {ccName = 'lissandrawfrozen', 'lissandraenemy2'},
	['malphite'] = {ccName = 'unstoppableforceestun'},
	['maokai'] = {ccName = 'maokaiunstablegrowthroot'},
	['monkeyking'] = {ccName = 'monkeykingspinknockup'},
	['morgana'] = {ccName = 'DarkBindingMissile'},
	['nami'] = {ccName = 'namiqdebuff'},
	['nautilus'] = {ccName = 'nautilusanchordragroot'},
	['ryze'] = {ccName = 'RunePrison'},
	['sejuani'] = {ccName = 'sejuaniglacialprison'},
	['sona'] = {ccName = 'SonaR'},
	['swain'] = {ccName = 'swainshadowgrasproot'},
	['thresh'] = {ccName = 'threshqfakeknockup'},
	['veigar'] = {ccName = 'VeigarStun'},	
	['velkoz'] = {ccName = 'velkozestun'},
	['vi'] = {ccName = 'virdunkstun'},
	['viktor'] = {ccName = 'viktorgravitonfieldstun'},
	['yasuo'] = {ccName = 'yasuoq3mis'},
	['zyra'] = {ccName = 'zyragraspingrootshold', 'zyrabramblezoneknockup'},
}
local enemyHeroes = {}
local allyHeroes = {}
local spellData = {
	['Q'] = { range = 1050 },
	['W'] = { range = 700 },
	['E'] = { range = 800 },
}
local gameSpells = {}
local gameBuffs = {
	["caitlynyordletrapdebuff"] = true,
	["Flee"] = true,
	["Stun"] = true,
	["supression"] = true,
	["Taunt"] = true,
}
local gameExhaust = {}
local gameInterupt = {}
local orbWalk = {
	['totalRange'] = 540,
	['canAttack'] = 0,
	['canMove'] = 0
}
local igniteSlot = nil
local exhaustSlot = nil
local clockCheck = 0

Callback.Bind('Load', function() Callback.Bind('GameStart', function() OnGameStart() end) end)

function OnGameStart()
	if not myHero.charName:lower():find('janna') then return end
	
	createTables()
	
	Menu = MenuConfig('Janna')
	Menu:Section('keys', 'Modes')
	Menu:Boolean('enableOW', 'Enable Script Orbwalk', true)
	Menu.enableOW:Note("Highly suggest using SxOrb or myOrbwalk, in built orbwalk really blows")
	Menu:KeyBinding('escape', 'Escape Mode', 'Q')
	Menu.escape:Note("Casts Q & W, peels any nearby enemies, will not AA")
	Menu:KeyBinding('harass', 'Harass Mode', 'W')
	Menu.harass:Note("Casts W & AA's if Orbwalk is enable, if Orbwalk is not enabled just casts W")
	Menu:KeyBinding('lastHit', 'Last Hit', 'S')
	Menu.lastHit:Note("Tries to last hit minions, sucks though lol, use a real orbwalk")
	Menu:KeyBinding('clear', 'Wave Clear', 'A')
	Menu.clear:Note("Attacks any nearby minion, also sucks")
	Menu:Section('shield', 'Auto Shield')
	Menu:Slider('minDmg', 'Min. Shield Damage', 50, 0, 500, 5)
	Menu:Boolean('ccShield', 'Shield CC', true)
	Menu:Section('gap', 'Anti Gap Close')	
	for gaps in pairs(gameSpells) do
		if gameSpells[gaps].gapClose ~= nil then
			local gapName = "Use Q on - "..gameSpells[gaps].character.." "..gameSpells[gaps].slot
			Menu:Boolean("gap"..gaps, gapName, true)
		end
	end
	Menu:Section('inter', 'Interupatable Spells')
	for int in pairs(gameSpells) do
		if gameSpells[int].interuptable then
			local intName = "Use Q on - "..gameSpells[int].character.." "..gameSpells[int].slot
			Menu:Boolean("int"..int, intName, true)
		end
	end
	Menu:Section('items', 'Items')
	Menu:Boolean('hpPot', 'Use HP Pots', true)
	Menu:Slider('minHPPot', 'Min. Health% for HP Pot', 30, 0, 100, 1)
	Menu:Boolean('manaPot', 'Use Mana Pots', true)
	Menu:Slider('minManaPot', 'Min. Mana% for Mana Pot', 30, 0, 100, 1)
	Menu:Boolean('locket', 'Use Locket of Iron Solari', true)
	Menu:Slider('minLocket', 'Min. Locket Damage', 100, 0, 500, 5)
	Menu:Boolean('talisman', 'Use Talisman of Ascension', true)
	Menu:Boolean('crucible', 'Use Mikaels Crubible', true)
	Menu:Boolean('fqc', 'Use Frost Queens Claim', true)
	Menu:Section('summs', 'Summoner Spells')
	if myHero:GetSpellData(12).name:find("dot") then
		Menu:Boolean('summIgnite', 'Use Ignite', true)		
		igniteSlot = 12
	elseif myHero:GetSpellData(13).name:find("dot") then
		Menu:Boolean('summIgnite', 'Use Ignite', true)
		igniteSlot = 13
	end
	if myHero:GetSpellData(12).name:find("exhaust") then
		Menu:Boolean('summExhaust', 'Use Exhaust', true)
		for exh in pairs(gameSpells) do
			if gameSpells[exh].exhaust then
				local exhName = "Use Exhaust on - "..gameSpells[exh].character.." "..gameSpells[exh].slot
				Menu:Boolean("exh"..exh, exhName, true)
			end
		end
		exhaustSlot = 12
	elseif myHero:GetSpellData(13).name:find("exhaust") then
		Menu:Boolean('summExhaust', 'Use Exhaust', true)
		for exh in pairs(gameSpells) do
			if gameSpells[exh].exhaust then
				local exhName = "Use Exhaust on - "..gameSpells[exh].character.." "..gameSpells[exh].slot
				Menu:Boolean("exh"..exh, exhName, true)
			end
		end		
		exhaustSlot = 13
	end
	
	Callback.Bind('Tick', function() OnTick() end)
	Callback.Bind('ProcessSpell', function(unit, spell) OnProcessSpell(unit, spell) end)
end

function OnProcessSpell(unit, spell)
	if unit and spell then
		if unit.team ~= myHero.team and not myHero.dead and not unit.name:lower():find('minion') then
			if unit.type == 'AIHeroClient' then	
				local fromTable = gameSpells[spell.name:lower()]
				if fromTable ~= nil then
					if (myHero:CanUseSpell(2) == 0) then
						if fromTable.type == 'targeted' and myHero.pos:DistanceTo(spell.target.pos) < spellData.E.range and ((Menu.ccShield:Value() and fromTable.cc) or SpellDamage.GetDamage(fromTable.slot, spell.target, unit) > Menu.minDmg:Value()) then
							myHero:CastSpell(2, spell.target)
						elseif fromTable.type == 'linear' then
							for _, ally in ipairs(allyHeroes) do
								if ally and myHero.pos:DistanceTo(ally.pos) < spellData.E.range and ((Menu.ccShield:Value() and fromTable.cc) or SpellDamage.GetDamage(fromTable.slot, ally, unit) > Menu.minDmg:Value()) and MayHit(ally.pos, unit.pos, spell.endPos) then
									myHero:CastSpell(2, ally)
								end
							end
						elseif fromTable.type == 'aoe' then
							for _, ally in ipairs(allyHeroes) do
								if ally.pos:DistanceTo(spell.endPos) < 300 and myHero.pos:DistanceTo(ally.pos) < spellData.E.range and ((Menu.ccShield:Value() and fromTable.cc) or SpellDamage.GetDamage(fromTable.slot, ally, unit) > Menu.minDmg:Value()) then
									myHero:CastSpell(2, ally)
								end
							end
						end
					elseif Menu.locket:Value() and CanUseItem(3190) then
						if fromTable.type == 'targeted' and myHero.pos:DistanceTo(spell.target.pos) < 650 and ((Menu.ccShield:Value() and fromTable.cc) or SpellDamage.GetDamage(fromTable.slot, spell.target, unit) > Menu.minLocket:Value()) then
							myHero:CastSpell(CanUseItem(3190))
						elseif fromTable.type == 'linear' then
							for _, ally in ipairs(allyHeroes) do
								if ally and myHero.pos:DistanceTo(ally.pos) < 650 and ((Menu.ccShield:Value() and fromTable.cc) or SpellDamage.GetDamage(fromTable.slot, ally, unit) > Menu.minLocket:Value()) and MayHit(ally.pos, unit.pos, spell.endPos) then
									myHero:CastSpell(CanUseItem(3190))
								end
							end
						elseif fromTable.type == 'aoe' then
							for _, ally in ipairs(allyHeroes) do
								if ally.pos:DistanceTo(spell.endPos) < 300 and myHero.pos:DistanceTo(ally.pos) < 650 and ((Menu.ccShield:Value() and fromTable.cc) or SpellDamage.GetDamage(fromTable.slot, ally, unit) > Menu.minLocket:Value()) then
									myHero:CastSpell(CanUseItem(3190))
								end
							end
						end						
					end
					if (myHero:CanUseSpell(0) == 0) then
						if fromTable.gapClose ~= nil and Menu["gap"..spell.name:lower()]:Value() then
							if fromTable.gapClose == 'unit' then
								if myHero.pos:DistanceTo(unit.pos) < spellData.Q.range then
									CastQ(unit.pos.x, unit.pos.z)
								end
							elseif fromTable.gapClose == 'spell' then
								if myHero.pos:DistanceTo(spell.endPos) < spellData.Q.range then
									CastQ(spell.endPos.x, spell.endPos.z)
								end							
							end
						end
					end
				elseif gameInterupt[spell.name:lower()] and Menu["int"..spell.name:lower()]:Value() then
					if (myHero:CanUseSpell(0) == 0) then
						if myHero.pos:DistanceTo(unit.pos) < spellData.Q.range then
							CastQ(unit.pos.x, unit.pos.z)
						end
					end				
				elseif gameExhaust[spell.name:lower()] and exhaustSlot ~= nil and Menu.summExhaust:Value() and Menu["exh"..spell.name:lower()]:Value() then
					if (myHero:CanUseSpell(exhaustSlot) == 0) then
						if myHero.pos:DistanceTo(unit.pos) < 600 then
							myHero:CastSpell(exhaustSlot, unit)
						end
					end					
				elseif spell.name:lower():find("attack") then
					if spell.target.type == myHero.type and myHero.pos:DistanceTo(spell.target.pos) < spellData.E.range and SpellDamage.GetDamage("AD", spell.target, unit) > Menu.minDmg:Value() then
						myHero:CastSpell(2, spell.target)
					end
				end
			end
		end
		if unit.isMe and spell.name and spell.name:lower():find("attack") then
			orbWalk.canAttack = (os.clock()+spell.windUpTime+(spell.animationTime*0.35))
			orbWalk.canMove = orbWalk.canAttack+spell.windUpTime+(spell.animationTime*0.35)
		end
	end
end

function OnTick()
	if Menu.escape:IsPressed() then
		if (myHero:CanUseSpell(0) == 0) then
			for _, enemy in ipairs(enemyHeroes) do
				if myHero.pos:DistanceTo(enemy.pos) < spellData.Q.range and not enemy.dead and enemy.visible then
					CastQ(enemy.x, enemy.z)
					break
				end
			end
		elseif Menu.fqc:Value() and CanUseItem(3092) then
			for _, enemy in ipairs(enemyHeroes) do
				if myHero.pos:DistanceTo(enemy.pos) < 850 and not enemy.dead and enemy.visible then
					myHero:CastSpell(CanUseItem(3092), enemy.pos.x, enemy.pos.z)
					break
				end
			end		
		end
		if (myHero:CanUseSpell(1) == 0) then
			for _, enemy in ipairs(enemyHeroes) do
				if myHero.pos:DistanceTo(enemy.pos) < spellData.W.range and not enemy.dead and enemy.visible then
					myHero:CastSpell(1, enemy)
					break
				end
			end
		end
		if Menu.enableOW:Value() then
			myHero:Move(mousePos.x, mousePos.z)
		end
	end
	if Menu.harass:IsPressed() then
		if Menu.enableOW:Value() then
			if os.clock() > orbWalk.canMove then
				for _, enemy in pairs(enemyHeroes) do
					if enemy and enemy.valid and enemy.visible and not enemy.dead and myHero.pos:DistanceTo(enemy.pos) < orbWalk.totalRange then
						myHero:Attack(enemy)
						goto continue
					end
				end
				myHero:Move(mousePos.x, mousePos.z)
				::continue::
			elseif os.clock() > orbWalk.canAttack then
				myHero:Move(mousePos.x, mousePos.z)				
			end
		end
		if (myHero:CanUseSpell(1) == 0) then
			for _, enemy in ipairs(enemyHeroes) do
				if myHero.pos:DistanceTo(enemy.pos) < spellData.W.range and not enemy.dead and enemy.visible then
					myHero:CastSpell(1, enemy)
					break
				end
			end
		elseif Menu.fqc:Value() and CanUseItem(3092) then
			for _, enemy in ipairs(enemyHeroes) do
				if myHero.pos:DistanceTo(enemy.pos) < 850 and not enemy.dead and enemy.visible then
					myHero:CastSpell(CanUseItem(3092), enemy.pos.x, enemy.pos.z)
					break
				end
			end		
		end
	end
	if Menu.lastHit:IsPressed() then
		if Menu.enableOW:Value() then
			if os.clock() > orbWalk.canMove then
				for minion in Object.Minions do
					if minion and minion.team ~= myHero.team and not minion.dead and minion.valid and myHero.pos:DistanceTo(minion.pos) < orbWalk.totalRange and SpellDamage.GetDamage("AD", minion, myHero) > (0.9*minion.health) then
						myHero:Attack(minion)
						goto continue
					end
				end
				myHero:Move(mousePos.x, mousePos.z)
				::continue::
			elseif os.clock() > orbWalk.canAttack then
				myHero:Move(mousePos.x, mousePos.z)				
			end
		end
	end
	if Menu.clear:IsPressed() then
		if Menu.enableOW:Value() then
			if os.clock() > orbWalk.canMove then
				for minion in Object.Minions do
					if minion and minion.team ~= myHero.team and not minion.dead and minion.valid and myHero.pos:DistanceTo(minion.pos) < orbWalk.totalRange then
						myHero:Attack(minion)
						goto continue
					end
				end
				myHero:Move(mousePos.x, mousePos.z)
				::continue::
			elseif os.clock() > orbWalk.canAttack then
				myHero:Move(mousePos.x, mousePos.z)				
			end
		end
	end
	if clockCheck < os.clock() then
		local enemyInRange = false
		for _, enemy in pairs(enemyHeroes) do
			if enemy and enemy.valid and not enemy.dead and myHero.pos:DistanceTo(enemy.pos) < 1000 then
				enemyInRange = true
				break
			end
		end		
		if Menu.hpPot:Value() and ((myHero.health*100)/myHero.maxHealth) < Menu.minHPPot:Value() and NotUsingHPPot() and enemyInRange then
			if CanUseItem(2010) ~= nil then
				myHero:CastSpell(CanUseItem(2010))
			elseif CanUseItem(2003) ~= nil then
				myHero:CastSpell(CanUseItem(2003))
			end
		end
		if Menu.manaPot:Value() and ((myHero.mana*100)/myHero.maxMana) < Menu.minManaPot:Value() and NotUsingManaPot() and enemyInRange then
			if CanUseItem(2004) ~= nil then
				myHero:CastSpell(CanUseItem(2004))
			end
		end
		if Menu.talisman:Value() and CanUseItem(3069) then
			local allyCount = 0
			local enemyCount = 0
			for _, ally in pairs(allyHeroes) do
				if not ally.dead and ally.valid and myHero.pos:DistanceTo(ally.pos) < 650 then
					allyCount = allyCount + 1
				end
			end
			for _, enemy in pairs(enemyHeroes) do
				if enemy.valid and not enemy.dead and myHero.pos:DistanceTo(enemy.pos) < 1000 then
					enemyCount = enemyCount + 1
				end
			end
			if allyCount >= 3 and enemyCount >= 3 then
				myHero:CastSpell(CanUseItem(3069))
			end
		end
		clockCheck = os.clock()+1
	end
	if Menu.crucible:Value() and CanUseItem(3222) then
		for _, ally in ipairs(allyHeroes) do 
			if myHero.pos:DistanceTo(ally.pos) < 700 and (ally.health/ally.maxHealth) < 0.6 then
				for i = 1, ally.buffCount do
					tBuff = ally:GetBuff(i)
					if tBuff.valid then
						if gameBuffs[tBuff.name] then
							myHero:CastSpell(CanUseItem(3222), ally)
							goto theEnd
						end
					end	
				end
			end
		end	
		::theEnd::
	end
	if igniteSlot ~= nil and Menu.summIgnite:Value() and myHero:CanUseSpell(igniteSlot) == 0 then
		for _, enemy in pairs(enemyHeroes) do
			if enemy and enemy.valid and not enemy.dead and myHero.pos:DistanceTo(enemy.pos) < 550 and SpellDamage.GetDamage("IGNITE", enemy, myHero) > enemy.health then
				myHero:CastSpell(igniteSlot, enemy)
				break
			end
		end
	end
end

function CastQ(x, z)
	myHero:CastSpell(0, x, z)
	local p = Network.EnetPacket(154)
	p.pos = 1
	p:Encode4(myHero.networkID)
	p:Encode2(234)
	p:EncodeF(x)
	p:EncodeF(z)
	p:EncodeF(x)
	p:EncodeF(z)
	p:Encode4(myHero.networkID)
	p:Send()
end

function createTables()
	for i=1, Game.HeroCount() do		
		local hero = Game.Hero(i)
		if hero.team ~= myHero.team then
			table.insert(enemyHeroes, table.maxn(enemyHeroes)+1, hero)
		else
			table.insert(allyHeroes, table.maxn(allyHeroes)+1, hero)
		end
	end
	for _, enemy in pairs(enemyHeroes) do
		local lowered = enemy.charName:lower()
		for spellName in pairs(spellList) do
			if lowered:match(spellList[spellName].character) then
				gameSpells[spellName] = spellList[spellName]
				if spellList[spellName].interuptable then
					gameInterupt[spellName] = true
				end
				if spellList[spellName].exhaust then
					gameExhaust[spellName] = true
				end
			end
		end
	end
	for _, enemy in pairs(enemyHeroes) do
		local lowered = enemy.charName:lower()
		for buffName in pairs(buffList) do
			if lowered:match(buffName) then
				gameBuffs[buffName] = true
			end
		end
	end
end

function MayHit(allyPos, startPos, endPos)
	local direction = startPos-endPos
	local endLeftDir = endPos + Perpendicular2(direction)
	local endRightDir = endPos + Perpendicular(direction)
	local endLeft = endPos + (endPos-endLeftDir):Normalize()*100
	local endRight = endPos + (endPos-endRightDir):Normalize()*100	
	local direction2 = endPos-startPos
	local startLeftDir = startPos + Perpendicular2(direction2)
	local startRightDir = startPos + Perpendicular(direction2)
	local startLeft = startPos + (startPos-startLeftDir):Normalize()*100
	local startRight = startPos + (startPos-startRightDir):Normalize()*100
	local p1 = Graphics.WorldToScreen(Geometry.Vector3(endLeft.x, myHero.pos.y, endLeft.z))
	local p2 = Graphics.WorldToScreen(Geometry.Vector3(endRight.x, myHero.pos.y, endRight.z))
	local p3 = Graphics.WorldToScreen(Geometry.Vector3(startLeft.x, myHero.pos.y, startLeft.z))
	local p4 = Graphics.WorldToScreen(Geometry.Vector3(startRight.x, myHero.pos.y, startRight.z))
	local spellPoly = Geometry.Polygon()
	spellPoly:Add(Geometry.Point(p3.x, p3.y))
	spellPoly:Add(Geometry.Point(p4.x, p4.y))
	spellPoly:Add(Geometry.Point(p1.x, p1.y))
	spellPoly:Add(Geometry.Point(p2.x, p2.y))
	local allyWTS = Graphics.WorldToScreen(allyPos)
	local allyPoint = Geometry.Point(allyWTS.x, allyWTS.y)
	if allyPoint:IsInside(spellPoly) then
		return true
	else
		return false
	end
end

function Perpendicular2(v)
    return Geometry.Vector3(v.z, v.y, -v.x)
end

function Perpendicular(v)
    return Geometry.Vector3(-v.z, v.y, v.x)
end

function CanUseItem(id)
	for i=4, 10, 1 do
		local itemID = myHero:GetInventorySlot(i)
		if itemID == id and myHero:CanUseSpell(i) == 0 then
			return i
		end
	end
	return nil
end

function NotUsingHPPot()
	for i = 1, myHero.buffCount do
		tBuff = myHero:GetBuff(i)
		if tBuff.valid then
			if tBuff.name == "RegenerationPotion" or tBuff.name == "ItemMiniRegenPotion" then
				return false
			end
		end	
	end
	return true
end

function NotUsingManaPot()
	for i = 1, myHero.buffCount do
		tBuff = myHero:GetBuff(i)
		if tBuff.valid and tBuff.name == "FlaskOfCrystalWater" then
			return false
		end	
	end
	return true
end
		
		
		
		
		


