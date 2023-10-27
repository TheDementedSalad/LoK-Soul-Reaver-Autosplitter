// Legacy of Kain: Soul Reaver Any% Glitchless Autosplitter Version 1.0 07/06/2020
// Supports real time
// Splits can be obtained from: https://www.speedrun.com/lok_sr/resources
// Original Script by Veictas
// Splits and New Script by TheDementedSalad

// Special thanks to:
// Veictas - Creator of the original script, found gameState & map
// TheDementedSalad - Found levels and no. of cutscenes for each split. Added most splits. Tested splits.

state("kain2")
{
	//Windows 10
	byte		PO:			0x708820;
	byte 		gameState: 	0x866E67;
	string10 	map: 		0x866E7C;
	int			x:			0x6F8AA8, 0x14;
}

startup
{
	
	//This allows is to look through a bitmask in order to get split information
	vars.bitCheck = new Func<byte, int, bool>((byte val, int b) => (val & (1 << b)) != 0);
	
	vars.completedArea = new List<string>();
	vars.completedBoss = new bool[8];
	vars.finalSplit = 0;
	
	// Main LiveSplit settings.
	settings.Add("Area", false, "Area & Puzzle Splitter");
	vars.Levels = new Dictionary<string,string>
	{
		{"train6","Defeated Sluagh"},
		{"pillars9","Finish Tutorial"},
		{"huba4","Dumahim Ambush"},
		{"out1","Reach The Necropolis"},
		{"skinnr14","Finish Weights Puzzle"},
		{"skinnr5","Reach Machinary Room"},
		{"skinnr9","Reach Melchiah's Sanctum"},
		{"pillars1","Reach Pillars of Nosgoth"},
		{"aluka27", "Reach The Drowned Abbey"},
		{"aluka20", "Reach the Sunken Church"},
		{"Aluka6", "Reach Rahab's Sanctum"},
		{"cathy1","Reach The Silent Cathedral"},
		{"cathy8","Reach Main Cathedral"},
		{"platx", "Extend the Platform"},
		{"cathy15","Ascend to Second Floor"},
		{"glass1", "First Glass Puzzle"},
		{"glass2", "Second Glass Puzzle"},
		{"glass3", "Third Glass Puzzle"},
		{"glass4", "Fourth Glass Puzzle"},
		{"cathy33", "Ascend to Third Floor"},
		{"valve1", "Turn the First Handle"},
		{"valve2", "Turn the Second Handle"},
		{"valve3", "Turn the Third Handle"},
		{"cathy47", "Ascend to Zephon's Sanctum"},
		{"add1", "Reach the Tomb of the Sarafan"},
		{"nightA1", "Reach The Ruined City"},
		{"nightA6", "Finish Block Puzzle"},
		{"nightb1", "Lowered Bridge"},
		{"nightb3", "Reach Duham's Sanctum"},
		{"mrlock14", "Enter the Oracle Cave"},
		{"oracle9", "Finish Block Puzzle"},
		{"oracle11", "Exit Spinning Fire Room"},
		{"oracle14", "Finish Puzzle 1"},
		{"oracle16", "Finish Puzzle 2"},
		{"puzzle3", "Finish Puzzle 3"},
		{"chrono2", "Finish Puzzle 4"},
		{"chrono1", "Reach Time Streaming Room"},
	};
	
	 foreach (var Tag in vars.Levels)
		{
			settings.Add(Tag.Key, false, Tag.Value, "Area");
    	};

		settings.CurrentDefaultParent = null;
	
	settings.Add("Boss", false, "Boss Splitter");
	vars.Levels = new Dictionary<string,string>
	{
		{"PO_1","Kill Melchiah"},
		{"PO_4","Defeat Kain I"},
		{"PO_2","Kill Zephon"},
		{"PO_3","Kill the Turelim"},
		{"PO_5","Kill Rahab"},
		{"PO_6","Kill Dumah"},
	};
	foreach (var Tag in vars.Levels)
		{
			settings.Add(Tag.Key, false, Tag.Value, "Boss");
    	};

		settings.CurrentDefaultParent = null;

	
	settings.Add("End", true, "End Split- Always Active");
}

init
{

}

onStart
{
	//resets the splits when a new run starts
	vars.completedArea = new List<string>();
	vars.completedBoss = new bool[8];
	vars.finalSplit = 0;
}

update
{	
	if(current.map == "chrono1" && current.gameState == 2 && old.gameState == 0){
		vars.finalSplit++;
		return true;
	}
	//print(modules.First().ModuleMemorySize.ToString());
}

start
{
	// Start the timer when a new game has just been started.
	if (current.gameState == 1 && old.gameState == 0)
	{
		return true;
	}
}

reset
{
	// Reset the timer when a new game has just been started.
	if (current.gameState == 1 && old.gameState == 0)
	{
		vars.cutsceneSplits = vars.GetCutsceneSplitList();
		
		vars.cutsceneCounters = vars.GetCutsceneCounters();
		
		return true;
	}
}

split
{
	vars.powerStr = current.powers.ToString();
	
	if(settings["Area"]){
		if(settings["" + current.map] && !vars.completedArea.Contains(current.map) ||
		settings["platx"] &&  current.map == "cathy13" && !vars.completedArea.Contains(current.map) && current.gameState == 2 || 
		settings["glass1"] && (current.map == "cathy59" || current.map == "cathy75") && !vars.completedArea.Contains(current.map) && current.gameState == 2 || 
		settings["glass2"] && (current.map == "cathy60" || current.map == "cathy76") && !vars.completedArea.Contains(current.map) && current.gameState == 2 || 
		settings["glass3"] && current.map == "cathy25" && !vars.completedArea.Contains(current.map) && current.gameState == 2 || 
		settings["glass4"] && current.map == "cathy22" && !vars.completedArea.Contains(current.map) && current.gameState == 2 || 
		settings["vent1"] && current.map == "cathy38" && !vars.completedArea.Contains(current.map) && current.gameState == 2 || 
		settings["vent2"] && current.map == "cathy42" && !vars.completedArea.Contains(current.map) && current.gameState == 2 && current.x == -812 || 
		settings["vent3"] && current.map == "cathy46" && !vars.completedArea.Contains(current.map) && current.gameState == 2 && current.x == -4707 || 
		settings["puzzle3"] && current.map == "oracle18" && !vars.completedArea.Contains(current.map) && current.gameState == 2){
			vars.completedArea.Add(current.map);
			return true;
		}
	}
	
	if(settings["Boss"]){
		for(int i = 0; i < 8; i++){
			if(settings["PO_" + i] && vars.bitCheck(current.PO, i) && !vars.completedBoss[0 + i]){
				return vars.completedBoss[0 + i]  = true;
			}
		}
	}
	
	if(current.map == "chrono1" && vars.finalSplit == 3 && current.gameState == 2 && old.gameState == 0){
		return true;
	}
}