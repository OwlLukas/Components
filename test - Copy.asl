/*
        - Add isLoading
        - Add init game version
        - add logic for final split (Have to enter boss fight to activate final cutscene split)
        - Order settings and both vars to make sense to someone who reads it
*/


state("Obscure")
{
    //Menu Values
    byte isMainMenu         : "Obscure.exe" ,  0x2A7A58, 0xC;                       // 1 in the main menu, 0 everywhere else
    byte isPaused           : "Obscure.exe" ,  0x2A9540;                            // 1 when paused, 0 everywhere else

    //Video values
    byte isCutsceneActive   : "binkw32.dll" ,  0x06061C;                            // 1 when in cutscene, 0 everywhere else
    string5 video           : "Obscure.exe" ,  0x2AB8E4, 0x20, 0x610, 0x14, 0x10;   // Displays the currently playing cutscene

    //Level / Room values
    string4 room            : "Obscure.exe" ,  0x2ABD59;                            // Displays the current room
}

startup
{
    //Create settings group on when to split
    settings.Add("RoomSplitter", true, "Split the following rooms once:");
    settings.Add("CutSplitter", false, "Split the following cutscenes once:");

    //Define the Rooms
    settings.Add("B008", true, "Cafeteria (After Prologue)", "RoomSplitter");
    settings.Add("m000", true, "Courtyard (After Administration)", "RoomSplitter");
    settings.Add("c000", true, "Lower Classrooms", "RoomSplitter");
    settings.Add("c100", true, "Upper Classrooms", "RoomSplitter");
    settings.Add("d000", true, "Lower Library", "RoomSplitter");
    settings.Add("e000", true, "Lower Refectory", "RoomSplitter");
    settings.Add("e103", true, "Ms. Wickson (Infirmary)", "RoomSplitter");
    settings.Add("f000", true, "Amphitheater Entrance", "RoomSplitter");
    settings.Add("g010", true, "Entering the Basement (Amphitheater)", "RoomSplitter");
    settings.Add("M002", true, "Fresh Air (Escaping The Basement)", "RoomSplitter");
    settings.Add("i000", true, "Lower Dormitory Entrance", "RoomSplitter");
    settings.Add("d002", true, "Friedman's Secret Office", "RoomSplitter");
    settings.Add("d100", true, "Upper Library Entrance", "RoomSplitter");
    settings.Add("A000", true, "Entering The Gardens", "RoomSplitter");
    settings.Add("g005", true, "Laboratory Administration Room", "RoomSplitter");
    settings.Add("g105", true, "The Last Queen Room", "RoomSplitter");
    settings.Add("g008", true, "Room With The Big Door", "RoomSplitter");

    //Define the Cutscenes
    settings.Add("CIN04", true, "", "CutSplitter");
   


    //Define all cutscenes. For documentation only. These are not in the right order.
    vars.cutscenes = new List<string>()
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
        "CIN63",                                                                    // Breaking the chain in the classroom staircase with the cup of acid.

    };

    //Contains the room ID you get when you first enter a room in a normal run. Depending on save/load or from where you enter the first letter can be lower or uppercase.
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
        "M002",                                                                     // garden entrance exterior
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

        //Basement
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
        "A000",                                                                     // Garden Entrance from exterior
        "a001",                                                                     // bridge room
        "A002",                                                                     // statue room

        //Basement advanced
        "g005",                                                                     // Laboratory admin room
        "g003",                                                                     // Cage room with laser gun
        "g007",                                                                     // Botanic room with treeman
        "g008",                                                                     // Room with the big door
        "g104",                                                                     // lower storage room before queen
        "g105",                                                                     // queen room
        "g100",                                                                     // long corridor with 3 treeman and light grenade
        "g107",                                                                     // cage hallway
        "g103",                                                                     // cage with the lever
        "G009"                                                                     // Lower Leonard arena
    };
}

init
{
    //Create the list of entries which can not be split more than once.
    vars.doneRooms = new List<string>();
}

update
{
    print("Current room = " + current.room.ToString());
    print("Current video = " + current.video.ToString());
    print("Is a cutscene active? = " + current.video.ToString());
    print("Is the game paused? = " + current.video.ToString());
    print("Is main cutscene menu? = " + current.video.ToString());
}


start
{
    //Could need a rework as there is a loading screen when leaving the difficulty menu that is currently not included
    return (current.isMainMenu == 0 && old.isMainMenu == 1 && current.video.Equals("CIN01"));
}

onSplit
{
    //Before the split occurs, add the room to the list. The split is already triggered at this point.
    vars.doneRooms.Add(current.room);
    vars.doneRooms.Add(current.video);
}

split
{
    //We split rooms or cutscenes, but only once.
    return ((settings[current.room] && old.room != current.room && (!vars.doneRooms.Contains(current.room)) || (settings[current.video] && old.video != current.video && !vars.doneRooms.Contains(current.video))));
}

onReset
{
    //Clear the list once the run is reset
    vars.doneRooms.Clear();
}

reset
{
    //We never go to the main menu. So define as reset.
    return current.isMainMenu == 1;
}