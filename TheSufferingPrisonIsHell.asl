/*	The Suffering: Prison is Hell (2004) [PC] autosplitter by OwlLukas
	
	ASL written for mainly the GoG release, and the AiO patch by UCyborg (That should be used by everyone to run this.)
	If your game version does not work with this autospliter, please contact me on discord or speedrun.com

*/

//All-in-One fix by UCyborg that is build on top of the 1.1 patch. (Also called 1.0.4) (Exe version 1.1.0.1)
state("Suffering", "AiO")
{
	byte isPausedOrMainMenu: 	"Suffering.exe", 0x1C9C52;					//Game is currently either paused or inside the main menu.
	byte isFlashbackActive: 	"wmvdecod.dll",  0x218004;					//Game is currenlty displaying a flashback (Cutscenes and Visions excluded)
	byte missioNumber: 			"Suffering.rfl", 0x178660;					//Displays the current mission number. (Changes before the loading screen)
	byte isMainMenu:			"Suffering.rfl", 0x178520;					//Game is currently in the main menu.
	float progressCoordinate:	"Suffering.exe", 0x1CA988;					//Level coordinate indicating progress.
    byte isCutsceneActive: 		"Suffering.rfl", 0x17BF30, 0x34;			//Indicates if a cutscene is currently playing (Flashback and visions excluded)
}

//1.1 Version from gog (Exe version 1.1.0.1)
state("SUFFERING", "GoG Patch 1.1.0.1")
{
	byte isPausedOrMainMenu: 	"Suffering.exe", 0x1C9C52;
	byte isFlashbackActive: 	"wmvdecod.dll",  0x218004;
	byte missioNumber: 			"Suffering.rfl", 0x178660;
	byte isMainMenu:			"Suffering.rfl", 0x178520;
	float progressCoordinate:	"Suffering.exe", 0x1CA988;
    byte isCutsceneActive: 		"Suffering.rfl", 0x17BF30, 0x34;
}

//All other versions, in my knowledge this should be the retail (v. 1.0.0.1) and the Air Force version (That is unplayable afaik)
state("SUFFERING", "Unknown")
{
	byte isPausedOrMainMenu: 	"Suffering.exe", 0x1C9C52;
	byte isFlashbackActive: 	"wmvdecod.dll",  0x218004;
	byte missioNumber: 			"Suffering.rfl", 0x178660;
	byte isMainMenu:			"Suffering.rfl", 0x178520;
	float progressCoordinate:	"Suffering.exe", 0x1CA988;
    byte isCutsceneActive: 		"Suffering.rfl", 0x17BF30, 0x34;
}


init
{
	//Determine the game version based on the exe file size
	switch (modules.First().ModuleMemorySize) 
	{

    case 3117056:
      	version = "AiO"; 												//1,845 KB
		break;

    case 3109886:
      	version = "GoG Patch 1.1.0.1";									//1,842 KB
      	break;

    default:
      	version = "Unknown";											//Else
      	break;

  	}

}

start
{
	/*Starting logic. The player has to be in chapter 1 and stand on the exact location of the progress coordinate, that is a fixed value and in this case, first person only.
	The cutscene logic with current and old will prevent the timer from restarting, if stopped right away.*/
	if (current.missioNumber == 1 && old.isCutsceneActive == 1 && current.isCutsceneActive == 0 && current.progressCoordinate == 817717.25) {

		return true;
	}

}

split
{
	
	//Prevent splitting from loading savegames from the pause- or main menu.
	if (current.isPausedOrMainMenu == 1) {

		return false;
	}
	
	//Splits when the mission counter increases (Happens at the last interaction on a door or upon entering a new mission by trigger) || This happens BEFORE the loading screen.
	else if (current.missioNumber > old.missioNumber) {

		return true;
	}
	
	//Logic for the final split. A flashback needs to occur in chapter 20 while the player is located at the boss area.
	else if (current.missioNumber == 20 && current.isFlashbackActive == 1 && old.isFlashbackActive == 0 && current.progressCoordinate > 900000) {

		return true;
	}
	
	else {

		return false;
	}
		
}

reset
{
	//In a run the player never goes to the main menu. If the player dies, either a checkpoint reloads by default, or the player chooses to load a savegame in the pause menu.
	return current.isMainMenu != 0;
}