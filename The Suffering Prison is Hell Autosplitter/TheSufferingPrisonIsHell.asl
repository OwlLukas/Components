/*
 * The Suffering: Prison is Hell (2004) [PC] AutoSplitter by OwlLukas.
 * If your game version does not work with this autospliter, or you get the "unknown" version, please contact me on discord or speedrun.com.
 *
 * Updated V1.2:
 *
 * - Added the Retail Patch 1.0.0.1 version.
 * - Added a load remover.
 * - Splitting will now occur at the loading screen, and not in the chapter fade-out.
 * - Added settings for starting.


 */

 

state("Suffering")
{
	byte     missionNumber      : "Suffering.rfl", 0x178660;       // Displays the current mission number. (Changes before the loading screen).
	byte     isMainMenu         : "Suffering.rfl", 0x178520;       // Game is currently in the main menu.
	byte     isCutsceneActive   : "Suffering.rfl", 0x17BF30, 0x34; // Indicates if a cutscene is currently playing (Flashback and visions excluded).
	byte     loading            : "Suffering.rfl", 0x17BBFE;       // During loads of any kind this seems to switch between 3 values that seem to be chapter-unique.
	byte     isPausedOrMainMenu : "Suffering.exe", 0x1C9C52;       // Game is currently either paused or inside the main menu.
	float    progressCoordinate : "Suffering.exe", 0x1CA988;       // Level coordinate indicating progress.
	byte     isFlashbackActive  : "wmvdecod.dll",  0x218004;       // Game is currenlty displaying a flashback (Cutscenes and Visions excluded).
	string25 fileLevel          : "Suffering.exe", 0x1C6B1C;       // Contains the current level name. Not a perfectly cropped string, but works fine.
}

startup
{
	// Create the setting-group when the timer will start.
	settings.Add("start_chapters", true, "Start at the beginning of chapter:");
	settings.SetToolTip("start_chapters", "Choose at which chapter the timer will start.");

	// Add chapter 0 and 1 to the group on when the timer will start.
	settings.Add("start_chapter0", false, "0. Waiting to Die", "start_chapters");
	settings.Add("start_chapter1", true, "1. The Worst Place on Earth", "start_chapters");

	byte levelFinished = 0;

}

init
{
	// Determine the game version based on the exe memory size.
	switch (modules.First().ModuleMemorySize)
	{
		case 0x2F9000: // All-in-One fix by UCyborg that is build on top of the 1.1 patch. (AiO 1.0.4) (Exe version 1.1.0.1)
			version = "AiO";
			break;
		case 0x2F73FE: // 1.1 Version from gog (Exe version 1.1.0.1)
			version = "GoG Patch 1.1.0.1";
			break;
		case 0x30C000: // Retail version (Exe version 1.0.0.1)
			version = "Retail Patch 1.0.0.1";
			break;
		default: // All the other versions (Air-Force, pirated etc.)
			version = "Unknown";
			break;
	}
}

start
{
	// Check whether isCutsceneActive changed from 0 to 1 and the chapter's setting is enabled.
	if (old.isCutsceneActive == 1 || current.isCutsceneActive == 0 && current.progressCoordinate != old.progressCoordinate)

	{
		switch ((byte)(current.missionNumber))
		{
			case 0: return current.progressCoordinate == 935124 && settings["start_chapter0"];
			case 1: return current.progressCoordinate == 817717.25 && settings["start_chapter1"];
		}
	}

}

split
{
	// Prevent splitting from loading savegames from the pause- or main menu.
	if (current.isPausedOrMainMenu == 1)
	{
		return false;
	}
	//Number changes when the fadeout occurs.
	if (current.missionNumber > old.missionNumber)
	{
		vars.levelFinished = 1;
	}
	//After the fadeout occurs, we wait for the loading screen to split and reset our variable.
	if (vars.levelFinished == 1 && current.loading != 0)
	{
		vars.levelFinished = 0;
		return true;
	}


	// Final level is unique with the progress coordinate.
	if (current.missionNumber == 20  && old.isFlashbackActive == 0 && current.isFlashbackActive == 1 && current.missionNumber == 20 && current.progressCoordinate > 900000)
		return true;
}

reset
{
	// In a run the player never goes to the main menu. If the player dies, either a checkpoint reloads by default, or the player chooses to load a savegame in the pause menu.
	// Should probably check old here?
	return current.isMainMenu != 0;
}

isLoading
{
	// Default logic. Pause the game timer when a loading screen is currently displayed (This is for the progress bar, after it finishes, the level fade-in happens).
	return current.loading != 0;
}
