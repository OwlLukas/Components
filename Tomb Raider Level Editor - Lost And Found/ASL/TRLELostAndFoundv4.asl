/*TODO: 

- Do we need to include gameState == 1 in the Load Remover for the menu transitions? Does that count? Do we even need the IGT if its displayed at the stat screen every level and at the end? Check Inventory, Statistic Screen, what goes in the final time?
- I need to decide whether to  keep the final split as a setting or not, currently both the general main game transition fulfills this condition, and the setting condition as well. Need to decide on one.
- Man kann immernoch splitten indem man vorwärts lädt, können wir das mit einem tuple lösen, bzw... sollen wir das überhaupt lösen? Nimmt sicher auch Einfluss auf die doneRooms variable beim splitten da man hiermit eigentlich seinen Run kaputt macht.


- Mysterious Item Counter hat noch kein Setting, Hinzufügen!

*/

state("tomb4")
{
    //General Control Variables
	int       gameTimer       : "tomb4.exe",                  0x3FD138;            // Does not track the Main Menu, actual IGT timer, (int4)
    string18    chapterName     : "Tomb_NextGeneration.dll",    0x1BD90A;           // Contains the current chapter name.
    byte        gameState       : "tomb4.exe",                  0x7B694;            // 2 during regular gameplay and loading screens, 1 for level statistics
    byte        LarasHomeEnd    : "tomb4.exe",                  0x3F5846;           // 1 if statistics screen is reached in laras home
    byte        isLoadingScreenActive : "Tomb_NextGeneration.dll", 0x3D869B;       // 1 if Loading Screen is active, 0 when not. Currently we use that to prevent double splits in Laras Home when a savegame with more items is loaded.
    byte        TotalItem_Counter: "Plugin_ClassicInventory.dll", 0x9C888;          // Total Item Pickup, individual for Full Game and Laras Home.

    //Items Laras Home (These items also correspond to other items in the main game (Local Level counters, not global counters)
    byte        Laras_Home_Document_Counter : "Tomb_NextGeneration.dll", 0x54D345;  // Counter for Laras Home: Document Items, Laras Home Document Counter EQUALS = SECRET KEYS
    byte        Laras_Home_Polaroid_Counter : "Tomb_NextGeneration.dll", 0x54D344;  // Counter for Laras Home: Polaroid Items, Laras Home Polaroid Counter EQUALS = GOLDEN SECRETS
    byte        Laras_Home_Magazine_Counter : "Tomb_NextGeneration.dll", 0x54D347;   // Counter for Laras Home: Magazine Items, Laras Home Magazine Counter EQUALS = DOCUMENTS
    byte        Laras_Home_FamilyCrest_Counter: "Tomb_NextGeneration.dll", 0x54D346; // Counter for Laras Home: Family Crest Items, Laras Home Family Crests EQUALS  = RELICS

     byte       MysteriousItem_Counter : "Tomb_NextGeneration.dll", 0x54D343;       // Mysterious Item Counter in Sunken Ruins
     byte       TotalSecrets_Counter    : "tomb4.exe", 0x3F7744;                    // Total Secrets for the main game (21)
     byte       TotalKills_Counter      : "Plugin_ClassicInventory.dll", 0x9C320;       // Total Kills for the main game


    //Items Main Game
}

startup
{
    //Set the refresh rate to 30. Do not change this or the game timer will slow down tremendously and break.
    refreshRate = 30;

     //Define the list of of splits that already occured.
    vars.doneRooms = new List<string>(); 

    //MAIN GAME
    settings.Add("Main_SplitLevels", true, "Main Game Level Splits:");
    settings.SetToolTip("Main_SplitLevels", "Split when reaching these levels.");

    settings.Add("1INTRO.TR4",true, "0. Intro Cutscene", "Main_SplitLevels");
    settings.Add("2CITADEL.TR4",true, "1. Desert Ruins - The Citadel", "Main_SplitLevels");
    settings.Add("3CITADEL_CUT.TR4",true, "2. Canyon", "Main_SplitLevels");
    settings.Add("4MINES.TR4",true, "3. Abandoned Mines", "Main_SplitLevels");
    settings.Add("5LOST_IRAM.TR4",true, "4. Lost City of Iram", "Main_SplitLevels");
    settings.Add("6LOST_IRAM_CUT.TR4",true, "5. Lost City of Iram - Final Cutscene", "Main_SplitLevels");
    settings.Add("7SUNKEN.TR4",true, "6. Sunken Ruins [End Split]", "Main_SplitLevels"); // Not necessary or we will split twice.



    // MAIN GAME ITEMS
    settings.Add("MainGame_Items", false, "Main Game Items Splits:");
    settings.SetToolTip("MainGame_Items", "Split when reaching these levels.");
    settings.Add("MainGame_AllItems_Split",false, "Split when picking up: Any Item", "MainGame_Items");
    settings.Add("MainGame_SecretKeys_Split",false, "Split when picking up: Secret Keys", "MainGame_Items");
    settings.Add("MainGame_GoldenSecrets_Split",false, "Split when picking up: Golden Secrets", "MainGame_Items");
    settings.Add("MainGame_Relics_Split",false, "Split when picking up: Relics", "MainGame_Items");
    settings.Add("MainGame_Documents_Split",false, "Split when picking up: Documents", "MainGame_Items");
    settings.Add("MainGame_Secrets_split", false, "Split when picking up: Main Global Secrets", "MainGame_Items");
    settings.Add("MainGame_Mysterious_Split", false, "Split when picking up: Mysterious Items (Sunken Ruins Only)", "MainGame_Items");
    settings.Add("MainGame_Kills_Split", false, "Split when increasing: Total Kills", "MainGame_Items");


    //LARAS HOME
    settings.Add("LarasHome_SplitLevels", true, "Laras Home Level Splits:");
    settings.SetToolTip("LarasHome_SplitLevels", "Split when reaching these levels.");
    settings.Add("8HOME1.TR4",true, "1. Lara's Home [End Split]", "LarasHome_SplitLevels");


    //LARAS HOME ITEMS
    settings.Add("Main_LarasHome_Splits", false, "Lara's Home Items Splits:");
    settings.SetToolTip("Main_LarasHome_Splits", "Split when picking up these items in Lara's Home.");
    settings.Add("Laras_Home_Document_Split",false, "Split when picking up: Documents", "Main_LarasHome_Splits");
    settings.Add("Laras_Home_Polaroid_Split",false, "Split when picking up: Polaroids", "Main_LarasHome_Splits");
    settings.Add("Laras_Home_Magazine_Split",false, "Split when picking up: Magazines", "Main_LarasHome_Splits");
    settings.Add("Laras_Home_FamilyCrest_Split",false, "Split when picking up: Family Crests", "Main_LarasHome_Splits");
    settings.Add("Laras_Home_AllItems_Split",false, "Split when picking up: Any Item", "Main_LarasHome_Splits");

}


update
{
    print(current.gameState.ToString());
    print("doneRooms: [" + string.Join(", ", vars.doneRooms.ToArray()) + "]");
}


init
{
    //Determine the game version.
	if (modules.First().ModuleMemorySize == 0x517000)
	{
        version = "LaF CH1 v4";     //Apparently the normal string is too long to be displayed..
	}
    else
    {
        version = "Unsupported Version";
    }
}


//Start the timer from the main menu when a new game is launched.
start
{

    //Main Game
    if (current.chapterName.Contains("1INTRO.TR4") && old.chapterName.Contains("TITLE.TR4"))
    {
        return true;

    }

    //Laras Home
    if (current.chapterName.Contains("8HOME1.TR4") && old.chapterName.Contains("TITLE.TR4"))
    {
        return true;

    }
}


//Add the room for a check sequence to prevent double splitting by loading a previous level.
onSplit
{

if (!vars.doneRooms.Contains(old.chapterName.Trim()))
{
    vars.doneRooms.Add(old.chapterName.Trim());
}

if (!vars.doneRooms.Contains(current.chapterName.Trim()))
{
    vars.doneRooms.Add(current.chapterName.Trim());
}
   
}

//Split when the levels end.
split
{

    //Final Split Main Game
    if ((settings["Main_SplitLevels"] && settings[old.chapterName.Trim()] && current.chapterName.Trim() == "7SUNKEN.TR4" && current.gameState == 1 ))
    {
        return true;
    }

    //Final Split Laras Home
    if ((settings["LarasHome_SplitLevels"] && settings[old.chapterName.Trim()] && current.chapterName.Trim() == "8HOME1.TR4" && current.LarasHomeEnd == 1 && old.LarasHomeEnd == 0))
    {
        return true;
    }

    //General Splits for Levels, we do not allow Laras Home here, as this split is defined seperately!
    if ((settings["Main_SplitLevels"] && settings[old.chapterName.Trim()] && current.chapterName != old.chapterName) && !vars.doneRooms.Contains(current.chapterName.Trim()) && current.chapterName.Trim() != "8HOME1.TR4" && old.chapterName.Trim() != "8HOME1.TR4" && !current.chapterName.Contains("TITLE.TR4"))
    {
        return true;
    }


    //Item Split Main Game
    if ((settings["MainGame_Items"] && settings["MainGame_AllItems_Split"] && current.TotalItem_Counter > old.TotalItem_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() != "8HOME1.TR4"))
    {
        return true;
    }

    if ((settings["MainGame_Items"] && settings["MainGame_SecretKeys_Split"] && current.Laras_Home_Document_Counter > old.Laras_Home_Document_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() != "8HOME1.TR4"))
    {
        return true;
    }

    if ((settings["MainGame_Items"] && settings["MainGame_GoldenSecrets_Split"] && current.Laras_Home_Polaroid_Counter > old.Laras_Home_Polaroid_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() != "8HOME1.TR4"))
    {
        return true;
    }

    if ((settings["MainGame_Items"] && settings["MainGame_Relics_Split"] && current.Laras_Home_FamilyCrest_Counter > old.Laras_Home_FamilyCrest_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() != "8HOME1.TR4"))
    {
        return true;
    }

    if (settings["MainGame_Items"] && settings["MainGame_Documents_Split"] && current.Laras_Home_Magazine_Counter > old.Laras_Home_Magazine_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() != "8HOME1.TR4")
    {
        return true;
    }
    
    if (settings["MainGame_Items"] && settings["MainGame_Secrets_split"] && current.TotalSecrets_Counter > old.TotalSecrets_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() != "8HOME1.TR4")
    {
        return true;
    }

    if (settings["MainGame_Items"] && settings["MainGame_Mysterious_Split"] && current.MysteriousItem_Counter > old.MysteriousItem_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() == "7SUNKEN.TR4" && !current.chapterName.Trim() != "8HOME1.TR4")
    {
        return true;
    }

    if (settings["MainGame_Items"] && settings["MainGame_Kills_Split"] && current.TotalKills_Counter > old.TotalKills_Counter && old.isLoadingScreenActive == 0 && current.chapterName.Trim() != "8HOME1.TR4")
    {
        return true;
    }

    //Item Splits Laras Home
    if ((settings["Main_LarasHome_Splits"] && settings["Laras_Home_Document_Split"] && current.chapterName.Trim() == "8HOME1.TR4" && current.Laras_Home_Document_Counter > old.Laras_Home_Document_Counter && old.isLoadingScreenActive == 0))
    {
        return true;
    }
    if ((settings["Main_LarasHome_Splits"] && settings["Laras_Home_Polaroid_Split"] && current.chapterName.Trim() == "8HOME1.TR4" && current.Laras_Home_Polaroid_Counter > old.Laras_Home_Polaroid_Counter && old.isLoadingScreenActive == 0))
    {
        return true;
    }
    if ((settings["Main_LarasHome_Splits"] && settings["Laras_Home_Magazine_Split"] && current.chapterName.Trim() == "8HOME1.TR4" && current.Laras_Home_Magazine_Counter > old.Laras_Home_Magazine_Counter && old.isLoadingScreenActive == 0))
    {
        return true;
    }
    if ((settings["Main_LarasHome_Splits"] && settings["Laras_Home_FamilyCrest_Split"] && current.chapterName.Trim() == "8HOME1.TR4" && current.Laras_Home_FamilyCrest_Counter > old.Laras_Home_FamilyCrest_Counter && old.isLoadingScreenActive == 0))
    {
        return true;
    }

    if ((settings["Main_LarasHome_Splits"] && settings["Laras_Home_AllItems_Split"] && current.chapterName.Trim() == "8HOME1.TR4" && current.TotalItem_Counter > old.TotalItem_Counter && old.isLoadingScreenActive == 0))
    {
        return true;
    }

}

//Clear the doneRooms variable, otherwise splits might not work at all.
onReset
{
    vars.doneRooms.Clear();
}