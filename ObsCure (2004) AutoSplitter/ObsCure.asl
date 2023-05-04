/*
    ObsCure (2004) AutoSplitter by OwlLukas.
    If your game version does not work with this autospliter, or you get the "unknown" version, please contact me on discord or speedrun.com.

    Updated V1.0
        - Added Split options by room
        - Added Split options by FMV
        - Added Doorsplitter
        - Added Loadremover
        - Added Room and FMV list.

*/


state("Obscure", "Steam 1.0.1.0")
{
    //Menu values
    byte isNotMainMenu      :   "Obscure.exe" , 0x2A6868;                           // 0 when in main menu, 1 when ingame.
    byte isPaused           :   "Obscure.exe" , 0x2A9540;                           // 1 when paused, 0 everywhere else.
    byte inDifficultyMenu   :   "Obscure.exe" , 0x2BC48D;                           // 0 in Main Menu, 1 when in Difficulty menu, 186 when a game was started.

    //Video values
    byte isCutsceneActive   :   "binkw32.dll" , 0x06061C;                           // 1 when in cutscene, 0 everywhere else.
    string5 fmv             :   "Obscure.exe" , 0x2AB8E4, 0x20, 0x610, 0x14, 0x10;  // Displays the currently playing fmv

    //Room values
    string4 room            :   "Obscure.exe" , 0x2ABD59;                           // Displays the current room

    //Loading values
    float load              :   "Obscure.exe" , 0x2AB8AC;                           // 0 when not loading, 1 when in loading screen.
}

startup
{
    //Create settings group on when to split.
    settings.Add("RoomSplitter", true, "Split by Room [Recommended]:");
    settings.Add("FMVSplitter", false, "Split by FMV [Optional]:");
    settings.Add("DoorSplitter", false, "Doorsplitter [Only Check This]:");

    //Define the tooltips.
    settings.SetToolTip("RoomSplitter", "Split when reaching a new area.");
    settings.SetToolTip("FMVSplitter", "Split when a certain FMV is active.:");
    settings.SetToolTip("DoorSplitter", "Split occurs when a new room is entered. Disable the other options to ensure correct behaviour.");

    //Define a set of logical splits. The route of the game was used.
    settings.Add("B008", true, "1. The Cafeteria", "RoomSplitter");
    settings.Add("m000", true, "2. The Courtyard", "RoomSplitter");
    settings.Add("c000", false, "3. Lower Classrooms", "RoomSplitter");
    settings.Add("c100", false, "4. Upper Classrooms", "RoomSplitter");
    settings.Add("d000", true, "5. Lower Library [First Visit Only]", "RoomSplitter");
    settings.Add("e000", true, "6. Lower Refectory", "RoomSplitter");
    settings.Add("e100", false, "7. Upper Refectory", "RoomSplitter");
    settings.Add("e103", true, "8. Ms. Wickson (Infirmary)", "RoomSplitter");
    settings.Add("b104", false, "9. Secret Filing Room", "RoomSplitter");
    settings.Add("f000", false, "10. Amphitheater Entrance", "RoomSplitter");
    settings.Add("g010", true, "11. Entering the Basement (Amphitheater)", "RoomSplitter");
    settings.Add("M002", true, "12. Fresh Air (Escaping The Basement)", "RoomSplitter");
    settings.Add("i000", true, "13. Lower Dormitory Entrance", "RoomSplitter");
    settings.Add("i100", false, "14. Upper Dormitory Entrance", "RoomSplitter");
    settings.Add("d002", true, "15. Friedman's Secret Office", "RoomSplitter");
    settings.Add("d100", false, "16. Upper Library Entrance", "RoomSplitter");
    settings.Add("A000", true, "17. Entering The Gardens", "RoomSplitter");
    settings.Add("g005", true, "18. Basement Laboratory Administration Room", "RoomSplitter");
    settings.Add("g105", false, "19. The Machine Room", "RoomSplitter");
    settings.Add("G009", true, "20. Entering the Leonard Bossfight", "RoomSplitter");

    //Define the FMV's. Only choose the ones that do not interfere with the rooms, as it will cause a double split.
    settings.Add("CIN02", false, "1. Kenny talks to Ashley in the Cloakrooms", "FMVSplitter");
    settings.Add("CIN39", false, "2. Kenny finds Dan", "FMVSplitter");
    settings.Add("CIN06", false, "3. Mr. Walden breaks the Attic Window [All Variations]", "FMVSplitter");
    settings.Add("CIN09", false, "4. Student transforming after entering the Library", "FMVSplitter");
    settings.Add("CIN11", false, "5. Grabbing the Key to the Refectory", "FMVSplitter");
    settings.Add("CIN43", false, "6. Meeting the First Queen", "FMVSplitter");
    settings.Add("CIN44", false, "7. Watching Movie#23 in the Amphitheater", "FMVSplitter");
    settings.Add("CIN18", false, "8. Student turns into Treeman in the Basement", "FMVSplitter");
    settings.Add("CIN23", false, "9. Alan Gardener's Diary", "FMVSplitter");
    settings.Add("CIN25", false, "10. Watching Movie#24 in the Amphitheater [Garden Code]", "FMVSplitter");
    settings.Add("CIN26", false, "11. Mr. Walden in the room with the big door", "FMVSplitter");


    //Set the refresh rate to 60
    refreshRate = 60;

    //All available FMV's in the game. These are not in the right order.
    vars.fmvs = new List<string>()
    {
        "CIN01",                                                                    // Intro cutscene that plays after the difficulty is chosen.
        "CIN02",                                                                    // Kenny talking to Ashley on the phone in the cloakrooms.
        "CIN04",                                                                    // Kenny escaping the prologue alive.
        "CIN05",                                                                    // Intro after the prologue is finished.
        "CIN06a",                                                                   // Walden breaking the window in the loft (Josh).
        "CIN06b",                                                                   // Walden breaking the window in the loft (Ashley).
        "CIN06c",                                                                   // Walden breaking the window in the loft (Shannon).
        "CIN07",                                                                    // Entering the courtyard for the first time (Day).
        "CIN09",                                                                    // Student turning after you enter the library.
        "CIN11",                                                                    // Grabbing the key for the lower Cafeteria / Infirmary.
        "CIN12",                                                                    // Watching the tape in the surveillance room.
        "CIN13",                                                                    // Turning on the light in the upper Cafeteria / Infirmary.
        "CIN18",                                                                    // Student turning into a treeman in the basement.
        "CIN23",                                                                    // Alan Gardeners Diary.
        "CIN25",                                                                    // Watching Tape24 with the garden code in the amphitheater.
        "CIN26",                                                                    // Walden in the room with the big door as it opens.
        "CIN27",                                                                    // Walden shoots Friedman.
        "CIN28",                                                                    // The ceiling breaks after finishing the lower Leonard fight.
        "CIN29",                                                                    // The Sports room doors close as Kenny returns from the cloakrooms after his bag was stolen.
        "CIN30",                                                                    // Prologue ending cutscene where Kenny dies.
        "CIN32a",                                                                   // The elevator falling and killing Ashley.
        "CIN32b",                                                                   // The elevator falling and killing Shannon.
        "CIN32c",                                                                   // The elevator falling and killing Josh.
        "CIN32d",                                                                   // The elevator falling and killing Stan.
        "CIN32e",                                                                   // The elevator falling and killing no one.
        "CIN34",                                                                    // It turns to nighttime (After you find Friedman in the library).
        "CIN35",                                                                    // Leonard dying in the Sports hall.
        "CIN36",                                                                    // Friedman telling Leonard he almost had the formula (Entering the boss arena for the first time).
        "CIN37",                                                                    // Endgame credits.
        "CIN39",                                                                    // Kenny finds Dan in the prologue.
        "CIN40",                                                                    // Watching the subject 37 tape in the surveillance room.
        "CIN43",                                                                    // Meeting the first queen above the Artists entrance.
        "CIN44",                                                                    // Watching Tape23 in the amphitheater.
        "CIN45",                                                                    // Ending Cutscene after Leonard dies where all character survive.
        "CIN46",                                                                    // Game prototype that you can watch in the extras menu.
        "CIN51",                                                                    // Making of that you can watch in the extras menu.
        "CIN52",                                                                    // Game trailer that you can watch in the extras menu.
        "CIN58",                                                                    // Kenny finding the gun before he enters the basement in the prologue.
        "CIN59",                                                                    // Outro "For the victims of leafmore".
        "CIN63",                                                                    // Breaking the chain in the classroom staircase with the cup of acid. Does not seem to play in the EU version.

    };

    //Define the Rooms. Values are first entry only. The value can change to either upper or lower case depending from where you enter it, or when you load and save. Generally every room has 2 values. E.g "B008/b008".
    vars.rooms = new List<string>()
    {
        //Prologue
        "J000",                                                                     // Sports room (NG)
        "j001",                                                                     // Washing rooms
        "a003",                                                                     // Garden - house area
        "a004",                                                                     // Garden - basement entrance shack
        "g006",                                                                     // Basement lobby - garden entrance
        "g014",                                                                     // Basement cage room
        "g016",                                                                     // Basement gun shelf room
        "g015",                                                                     // Dans cell

        //Administration
        "B008",                                                                     // Cafeteria
        "b010",                                                                     // Small boxrom with the reel of wire.
        "b000",                                                                     // Main lobby.
        "b006",                                                                     // boys toilet
        "b005",                                                                     // girls toilet
        "b002",                                                                     // meeting room with the rubber band
        "b102",                                                                     // Waldens spanish classroom. ( He speaks spanish?)
        "B007",                                                                     // teachers lounge toilet.
        "b004",                                                                     // teachers lounge lower
        "B106",                                                                     // teachers lounge upper
        "b103",                                                                     // filing room
        "b104",                                                                     // small boxroom with the movie
        "B009",                                                                     // loft entrance
        "b100",                                                                     // attic

        //Exterior and Janitor
        "m000",                                                                     // lower courtyard
        "m100",                                                                     // upper courtyard
        "e001",                                                                     // janitor room
        "e003",                                                                     // janitor surveillance room
        "m001",                                                                     // parking lot
        "M002",                                                                     // garden entrance exterior (With the code Pad)
        "m003",                                                                     // Exterior Sports hall

        //Lower classrooms
        "c000",                                                                     // lobby
        "c010",                                                                     // administrative room (stan)
        "c004",                                                                     // gun room
        "c003",                                                                     // boys toilet
        "C105",                                                                     // Lab classroom (broken wall)
        "c006",                                                                     // acid machine room
        "c011",                                                                     // staircase

        //Upper classrooms
        "c100",                                                                     // lobby
        "c009",                                                                     // classroom with the compass
        "c104",                                                                     // classroom with ammo in a vent
        "c101",                                                                     // room with the compass map

        //Library Lower
        "d000",                                                                     // lobby
        "d006",                                                                     // girls room
        "d005",                                                                     // boys room
        "d004",                                                                     // student falling through the window.
        "d001",                                                                     // meeting room
        "d009",                                                                     // dark aura room
        "d010",                                                                     // safe room
        "d003",                                                                     // big library room lower (day)
        "D003",                                                                     // big library room lower (when it turns to night)
        "d002",                                                                     // Friedmans hidden office

        //Refectory (Lower Cafeteria / Infirmary)
        "e000",                                                                     // main room lower
        "e002",                                                                     // kitchen lower
        "e100",                                                                     // upper circuit room
        "e101",                                                                     // upper kitchen
        "e102",                                                                     // fuse room
        "E100",                                                                     // upper circuit room (lit)
        "e103",                                                                     // Ms Wickson room

        //Amphitheater
        "f000",                                                                     // lobby
        "f102",                                                                     // projector room
        "f003",                                                                     // movie room
        "f001",                                                                     // make up room
        "f002",                                                                     // elevator room
        "F101",                                                                     // Queen room

        //Basement (Enter from Amphitheater)
        "g010",                                                                     // elevator room maintenance.
        "g000",                                                                     // long hallway after elevator room
        "g012",                                                                     // long corridor with 2 treeman
        "g013",                                                                     // long hallway that leads to the big door (has student standing when entering)
        "g002",                                                                     // cage room
        "g001",                                                                     // operating room
        "g106",                                                                     // lower long corridor before entering kennys cell
        "g004",                                                                     // kennys cell

        //Dormitory lower
        "i000",                                                                     // lobby
        "i002",                                                                     // satan circle room
        "i001",                                                                     // queen room
        "i004",                                                                     // toilets
        "i007",                                                                     // light grenade room

        //Dormitory upper
        "i100",                                                                     // lobby
        "i107",                                                                     // student dorm room
        "i101",                                                                     // big room with 2 students
        "i103",                                                                     // small room with the box
        "i102",                                                                     // room where we drop the box

        //Library upper
        "d105",                                                                     //staircase
        "d106",                                                                     // library upper with statue
        "d100",                                                                     // upper lobby
        "d104",                                                                     // movable shelf room (only in us version)
        "d103",                                                                     // light grenade room
        "d102",                                                                     // revolver room
        "d101",                                                                     // normal classroom (apart from the 3 rooms) has a skeleton

        //Gardens
        "A000",                                                                     // First Garden Room after you enter the code for the big gate
        "a001",                                                                     // bridge room
        "A002",                                                                     // statue room

        //Basement revisited
        "g005",                                                                     // Laboratory admin room
        "g003",                                                                     // Cage room with laser gun
        "g007",                                                                     // Botanic room with treeman
        "g008",                                                                     // Room with the big door
        "g104",                                                                     // lower storage room before queen
        "g105",                                                                     // queen room
        "g100",                                                                     // long corridor with 3 treeman and light grenade
        "g107",                                                                     // cage hallway
        "g103",                                                                     // cage with the lever
        "G009"                                                                      // Lower Leonard arena
    };

/*----------------- Define necessary variables ----------------*/

    //Define the list of of splits that already occured.
    vars.doneRooms = new List<string>();

    //Skip the first split when the doorsplitter is active. The run starts after the difficulty screen. If you load any room, return to the main menu and start a new game, the game will switch the room right after start is executed.
    bool skipFirstSplit = false;
}

init
{
    //Determine the game version.
	if (modules.First().ModuleMemorySize == 0x413000)
	{
        version = "Steam 1.0.1.0";
	}
    else
    {
        version = "Unknown";
    }
}

onStart
{
    vars.skipFirstSplit = true;
}


start
{
    //Start the timer after the user chooses the difficulty.
    return (old.inDifficultyMenu == 1 && current.load != 0);
}

onSplit
{
    //Make sure to add either the current room or FMV to the list to prevent double splits.
    vars.doneRooms.Add(current.room);
    vars.doneRooms.Add(current.fmv);
}

split
{

    //Always split on the final cutscene
    if (current.fmv == "CIN35" && old.fmv != current.fmv)
    {
        return true;
    }

    //Split the rooms
    return ((settings[current.room] && old.room != current.room && (!vars.doneRooms.Contains(current.room))));

    //Split the FMV's
    return (settings[current.fmv] && old.fmv != current.fmv && !vars.doneRooms.Contains(current.fmv));

    //Doorsplitter
    if (settings["DoorSplitter"] && vars.skipFirstSplit == true)
    {
        vars.skipFirstSplit = false;
        return false;
    }

    else
    {
        return current.room != old.room;
    }

}

onReset
{
    vars.doneRooms.Clear();
}

reset
{
    //Very reliable.
    return current.isNotMainMenu == 0;
}

isLoading
{
    return current.load != 0;
}