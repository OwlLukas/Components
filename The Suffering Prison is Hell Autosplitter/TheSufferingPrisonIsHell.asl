/*
 * The Suffering: Prison is Hell (2004) [PC] AutoSplitter by OwlLukas.
 * If your game version does not work with this autospliter, or you get the "unknown" version, please contact me on discord or speedrun.com.
 *
 * Updated V1.1:
 *
 * - Added the Retail Patch 1.0.0.1 version.
 * - Added a load remover.
 * - Splitting will now occur at the loading screen, and not in the chapter fade-out.
 * - Added settings for starting, and splitting.
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

	// Create the setting-group on when LiveSplit will split.
	settings.Add("split_chapters", true, "Split at the end of chapter:");
	settings.SetToolTip("split_chapters", "Choose which chapters will be split.");

	string[,] chapters =
	{
		{ "0 Prelude Docks",      "0. Waiting to Die" },
		{ "Death House",          "1. The Worst Place on Earth" },
		{ "Death House Basement", "2. Descending" },
		{ "Death House North",    "3. Slumber of the Dead" },
		{ "2 Cellblocks",         "4. Abbott Prison Blues" },
		{ "3a YardCellBlock",     "5. No More Prisons" },
		{ "3b YardCellBlock",     "6. I Can Sleep When I'm Dead" },
		{ "3a YardCellBlock",     "7. Everything Beautiful is Gone" },
		{ "Quarry East",          "8. Darkest Night, Eternal Blight" },
		{ "Quarry West",          "9. Oblivion Regained" },
		{ "5a Asylum Backyard",   "10. You've Mistaken Me For Someone Else" },
		{ "5b Asylum Interior",   "11. Hate the Sin, not the Sinner" },
		{ "The Woods",            "12. A Lonely Place to Die" },
		{ "The Beach",            "13. Dancing at the Dawn of the Apocalypse" },
		{ "Death House Basement", "14. Surfacing" },
		{ "Death House",          "15. An Eye for an Eye Makes the Whole World Blind" },
		{ "3a YardCellBlock",     "16. Who Wants to Deny Forever??" },
		{ "Bluff",                "17. Death Be Not Proud" },
		{ "Caves to Lighthouse",  "18. Single Bullet Theory" },
		{ "Lighthouse",           "19. And A Child Shall Lead Them" },
		{ "10 Docks",             "" }
	};

	for (int i = 0; i < chapters.GetLength(0) - 1; ++i)
	{
		string from = chapters[i, 0];
		string to   = chapters[i + 1, 0];
		string desc = chapters[i, 1];

		settings.Add(from + " -> " + to, i > 0, desc, "split_chapters");
	}

	settings.Add("split_chapter20", true, "20. Last Breath Before Dying", "split_chapters");
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
	if (old.isCutsceneActive != 1 || current.isCutsceneActive != 0 || !settings["start_chapter" + current.missionNumber])
		return;

	// Then start depending on the progressCoordinate.
	switch ((byte)(current.missionNumber))
	{
		case 0: return current.progressCoordinate == 935124;
		case 1: return current.progressCoordinate == 817717.25;
	}
}

split
{
	// Prevent splitting from loading savegames from the pause- or main menu.
	if (current.isPausedOrMainMenu == 1)
		return;

	/*
	 * Split logic: Check if the setting for the chapter is set, and then check the previous, and current map name for it.
	 * This way, it splits when the loading screen starts (level transition), and not like in the previous version, when the level fade-out happens.
	 * All if statements were shortened for better readability.
	 */
	if (settings[old.fileLevel + " -> " + current.fileLevel])
		return true;

	// Final level is unique with the progress coordinate.
	if (settings["split_chapter20"] && old.isFlashbackActive == 0 && current.isFlashbackActive == 1 && current.missionNumber == 20 && current.progressCoordinate > 900000)
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
