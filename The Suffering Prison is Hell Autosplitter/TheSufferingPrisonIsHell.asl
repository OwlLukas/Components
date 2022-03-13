/*	The Suffering: Prison is Hell (2004) [PC] AutoSplitter by OwlLukas.
	If your game version does not work with this autospliter, or you get the "unknown" version, please contact me on discord or speedrun.com.

	Updated V1.1:

	- Added the Retail Patch 1.0.0.1 version.
	- Added a load remover.
	- Splitting will now occur at the loading screen, and not in the chapter fade-out.
	- Added settings for starting, and splitting.
*/

//All-in-One fix by UCyborg that is build on top of the 1.1 patch. (AiO 1.0.4) (Exe version 1.1.0.1)
state("Suffering", "AiO")
{
	byte missioNumber: 		"Suffering.rfl", 0x178660;					//Displays the current mission number. (Changes before the loading screen).
	byte isMainMenu:		"Suffering.rfl", 0x178520;					//Game is currently in the main menu.
    	byte isCutsceneActive: 		"Suffering.rfl", 0x17BF30, 0x34;				//Indicates if a cutscene is currently playing (Flashback and visions excluded).
	byte loading: 			"Suffering.rfl", 0x17BBFE;					//During loads of any kind this seems to switch between 3 values that seem to be chapter-unique.
	byte isPausedOrMainMenu: 	"Suffering.exe", 0x1C9C52;					//Game is currently either paused or inside the main menu.
	float progressCoordinate:	"Suffering.exe", 0x1CA988;					//Level coordinate indicating progress.
	byte isFlashbackActive: 	"wmvdecod.dll",  0x218004;					//Game is currenlty displaying a flashback (Cutscenes and Visions excluded).
	string25 FileLevel:		"Suffering.exe", 0x1C6B1C;					//Contains the current level name. Not a perfectly cropped string, but works fine.
}

//1.1 Version from gog (Exe version 1.1.0.1)
state("SUFFERING", "GoG Patch 1.1.0.1")
{
	byte missioNumber: 		"Suffering.rfl", 0x178660;
	byte isMainMenu:		"Suffering.rfl", 0x178520;
    	byte isCutsceneActive: 		"Suffering.rfl", 0x17BF30, 0x34;
	byte loading: 			"Suffering.rfl", 0x17BBFE;
	byte isPausedOrMainMenu: 	"Suffering.exe", 0x1C9C52;
	float progressCoordinate:	"Suffering.exe", 0x1CA988;
	byte isFlashbackActive: 	"wmvdecod.dll",  0x218004;
	string25 FileLevel:		"Suffering.exe", 0x1C6B1C;
}

//Retail version (Exe version 1.0.0.1)
state("SUFFERING", "Retail Patch 1.0.0.1")
{
	byte missioNumber: 		"Suffering.rfl", 0x178660;
	byte isMainMenu:		"Suffering.rfl", 0x178520;
    	byte isCutsceneActive: 		"Suffering.rfl", 0x17BF30, 0x34;
	byte loading: 			"Suffering.rfl", 0x17BBFE;
	byte isPausedOrMainMenu: 	"Suffering.exe", 0x1C9C52;
	float progressCoordinate:	"Suffering.exe", 0x1CA988;
	byte isFlashbackActive: 	"wmvdecod.dll",  0x218004;
	string25 FileLevel:		"Suffering.exe", 0x1C6B1C;
}

//All the other versions (Air-Force, pirated etc.)
state("SUFFERING", "Unknown")
{
	byte missioNumber: 		"Suffering.rfl", 0x178660;
	byte isMainMenu:		"Suffering.rfl", 0x178520;
    	byte isCutsceneActive: 		"Suffering.rfl", 0x17BF30, 0x34;
	byte loading: 			"Suffering.rfl", 0x17BBFE;
	byte isPausedOrMainMenu: 	"Suffering.exe", 0x1C9C52;
	float progressCoordinate:	"Suffering.exe", 0x1CA988;
	byte isFlashbackActive: 	"wmvdecod.dll",  0x218004;
	string25 FileLevel:		"Suffering.exe", 0x1C6B1C;
}

startup
{

	//Create the setting-group when the timer will start.
	settings.Add("start_chapters", true, "Start at the beginning of chapter:");
	settings.SetToolTip("start_chapters", "Choose at which chapter the timer will start.");

	//Add chapter 0 and 1 to the group on when the timer will start.
	settings.Add("start_chapter0", false, "0. Waiting to Die", "start_chapters");
	settings.Add("start_chapter1", true, "1. The Worst Place on Earth", "start_chapters");

	//Create the setting-group on when LiveSplit will split.
	settings.Add("split_chapters", true, "Split at the end of chapter:");
	settings.SetToolTip("split_chapters", "Choose which chapters will be split.");

	//Add the chapters to the group.
	settings.Add("split_chapter0", false, "0. Waiting to Die", "split_chapters");
	settings.Add("split_chapter1", true, "1. The Worst Place on Earth", "split_chapters");
	settings.Add("split_chapter2", true, "2. Descending", "split_chapters");
	settings.Add("split_chapter3", true, "3. Slumber of the Dead", "split_chapters");
	settings.Add("split_chapter4", true, "4. Abbott Prison Blues", "split_chapters");
	settings.Add("split_chapter5", true, "5. No More Prisons", "split_chapters");
	settings.Add("split_chapter6", true, "6. I Can Sleep When I'm Dead", "split_chapters");
	settings.Add("split_chapter7", true, "7. Everything Beautiful is Gone", "split_chapters");
	settings.Add("split_chapter8", true, "8. Darkest Night, Eternal Blight", "split_chapters");
	settings.Add("split_chapter9", true, "9. Oblivion Regained", "split_chapters");
	settings.Add("split_chapter10", true, "10. You've Mistaken Me For Someone Else", "split_chapters");
	settings.Add("split_chapter11", true, "11. Hate the Sin, not the Sinner", "split_chapters");
	settings.Add("split_chapter12", true, "12. A Lonely Place to Die", "split_chapters");
	settings.Add("split_chapter13", true, "13. Dancing at the Dawn of the Apocalypse", "split_chapters");
	settings.Add("split_chapter14", true, "14. Surfacing", "split_chapters");
	settings.Add("split_chapter15", true, "15. An Eye for an Eye Makes the Whole World Blind", "split_chapters");
	settings.Add("split_chapter16", true, "16. Who Wants to Deny Forever??", "split_chapters");
	settings.Add("split_chapter17", true, "17. Death Be Not Proud", "split_chapters");
	settings.Add("split_chapter18", true, "18. Single Bullet Theory", "split_chapters");
	settings.Add("split_chapter19", true, "19. And A Child Shall Lead Them", "split_chapters");
	settings.Add("split_chapter20", true, "20. Last Breath Before Dying", "split_chapters");

}

init
{
	//Determine the game version based on the exe file size.
	switch (modules.First().ModuleMemorySize) 
	{

    	case 3117056: version = "AiO";								//1,845 KB
	break;

    	case 3109886: version = "GoG Patch 1.1.0.1";						//1,842 KB
      	break;

	case 3194880: version = "Retail Patch 1.0.0.1";						//3,091 KB
      	break;

    	default: version = "Unknown";								//Else
      	break;

  	}

}

start
{
	//Start the timer wherever the player has set it to start.
	if ( settings["start_chapter0"] && current.missioNumber == 0 && current.progressCoordinate == 935124 && old.isCutsceneActive == 1 && current.isCutsceneActive == 0)
	{
		return true; 
	}

	if ( settings["start_chapter1"] && current.missioNumber == 1 && old.isCutsceneActive == 1 && current.isCutsceneActive == 0 && current.progressCoordinate == 817717.25)
	{
		return true; 
	}

}

split
{
	
	//Prevent splitting from loading savegames from the pause- or main menu.
	if (current.isPausedOrMainMenu == 1)
	{
		return false; 
	}
	
	
	/*	Split logic: Check if the setting for the chapter is set, and then check the previous, and current map name for it.
		This way, it splits when the loading screen starts (level transition), and not like in the previous version, when the level fade-out happens.
		All if statements were shortened for better readability.
	*/
	if (settings["split_chapter0"] && old.FileLevel.Equals("0 Prelude Docks") && current.FileLevel.Equals("Death House")) { return true; }
	if (settings["split_chapter1"] && old.FileLevel.Equals("Death House") && current.FileLevel.Equals("Death House Basement")) { return true; }
	if (settings["split_chapter2"] && old.FileLevel.Equals("Death House Basement") && current.FileLevel.Equals("Death House North")) { return true; }
	if (settings["split_chapter3"] && old.FileLevel.Equals("Death House North") && current.FileLevel.Equals("2 Cellblocks")) { return true; }
	if (settings["split_chapter4"] && old.FileLevel.Equals("2 Cellblocks") && current.FileLevel.Equals("3a YardCellBlock")) { return true; }
	if (settings["split_chapter5"] && old.FileLevel.Equals("3a YardCellBlock") && current.FileLevel.Equals("3b YardCellBlock")) { return true; }
	if (settings["split_chapter6"] && old.FileLevel.Equals("3b YardCellBlock") && current.FileLevel.Equals("3a YardCellBlock")) { return true; }
	if (settings["split_chapter7"] && old.FileLevel.Equals("3a YardCellBlock") && current.FileLevel.Equals("Quarry East")) { return true; }
	if (settings["split_chapter8"] && old.FileLevel.Equals("Quarry East") && current.FileLevel.Equals("Quarry West")) { return true; }
	if (settings["split_chapter9"] && old.FileLevel.Equals("Quarry West") && current.FileLevel.Equals("5a Asylum Backyard")) { return true; }
	if (settings["split_chapter10"] && old.FileLevel.Equals("5a Asylum Backyard") && current.FileLevel.Equals("5b Asylum Interior")) { return true; }
	if (settings["split_chapter11"] && old.FileLevel.Equals("5b Asylum Interior") && current.FileLevel.Equals("The Woods")) { return true; }
	if (settings["split_chapter12"] && old.FileLevel.Equals("The Woods") && current.FileLevel.Equals("The Beach")) { return true; }
	if (settings["split_chapter13"] && old.FileLevel.Equals("The Beach") && current.FileLevel.Equals("Death House Basement")) { return true; }
	if (settings["split_chapter14"] && old.FileLevel.Equals("Death House Basement") && current.FileLevel.Equals("Death House")) { return true; }
	if (settings["split_chapter15"] && old.FileLevel.Equals("Death House") && current.FileLevel.Equals("3a YardCellBlock")) { return true; }
	if (settings["split_chapter16"] && old.FileLevel.Equals("3a YardCellBlock") && current.FileLevel.Equals("Bluff")) { return true; }
	if (settings["split_chapter17"] && old.FileLevel.Equals("Bluff") && current.FileLevel.Equals("Caves to Lighthouse")) { return true; }
	if (settings["split_chapter18"] && old.FileLevel.Equals("Caves to Lighthouse") && current.FileLevel.Equals("Lighthouse")) { return true; }
	if (settings["split_chapter19"] && old.FileLevel.Equals("Lighthouse") && current.FileLevel.Equals("10 Docks")) { return true; }

	//Final level is unique with the progress coordinate.
	if (settings["split_chapter20"] && current.missioNumber == 20 && current.isFlashbackActive == 1 && old.isFlashbackActive == 0 && current.progressCoordinate > 900000)
	{
		return true; 
	}
		
}

reset
{
	//In a run the player never goes to the main menu. If the player dies, either a checkpoint reloads by default, or the player chooses to load a savegame in the pause menu.
	return current.isMainMenu != 0;
}

isLoading
{
	//Default logic. Pause the game timer when a loading screen is currently displayed (This is for the progress bar, after it finishes, the level fade-in happens).
	return current.loading != 0;
}
