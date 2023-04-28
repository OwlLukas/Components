/*  Script written by OwlLukas */

/*
    ToDo:
    - Loadless timer makes problems when tabbing out and clicking in vs code or when you pause a lot ingame. WRONG VALUE.
    - Init does not show the version in the ASL Window at all.
*/


state("Obscure","Steam - Europe 1.0.1.0")
{
    //Menu Values
    byte isMainMenu         : "Obscure.exe" ,  0x2A7A58, 0xC;                       // 1 in the main menu, 0 everywhere else
    byte isPaused           : "Obscure.exe" ,  0x2A9540;                            // 1 when paused, 0 everywhere else

    //Video values
    byte isCutsceneActive   : "binkw32.dll" ,  0x06061C;                            // 1 when in cutscene, 0 everywhere else

    //In-Game values
    int room_value          : "Obscure.exe" ,  0x2ABD59;                            // room-id

    //Test
    string5 video           : "Obscure.exe" ,  0x2AB8E4, 0x20, 0x610, 0x14, 0x10;

}

//Prepare values to be used throughout the speedrun.
startup
{

    //This will prevent mass splitting when starting a New Game. Will turn true when a split has occured.
    bool NGstarted = false;

    //Contains all room ID's and the corresponding room name that comes from the save file.
    //To keep it easier to tell which one is which I added them as a comment

    /*ID's can be multiple per room depending on:
    - Entering it for the first time
    - Entering it by a different entrance
    - Saving and loading in the room

    */

    vars.roomValues = new Tuple<string, int, int>[]              // Savegame-title , Room-ID1, Room-ID2,
    {
        //All Rooms ordered by the typical playthrough

        //Prologue
        Tuple.Create("Sports room Main",    808464458,                  // Gymnasium starting position (Only when you spawn in) and when you S/L.
                                            808464490),                 // Gymnasium when you return from the Cloakrooms, the gym courtyard and for the final boss room.

        Tuple.Create("Cloakrooms",          825241706,                  // Changing room when you normally enter it. One-Way-Door.
                                            825241674),                 // Value when you S/L.

        Tuple.Create("Gym courtyard",       858796141,                  // Gym Courtyard outside the Sports room Main or courtyard.
                                            858796109),                 // Value when you S/L.

        Tuple.Create("The gardens",         858796129,                  // Garden Entrance from the gym courtyard,the garden statue room or from the basement entrance.
                                            858796097),                 // Value when you S/L.

        Tuple.Create("The basement",        875573345,                  // Basement Entrance when you enter through the gardens or come back from the long corridor.
                                            875573313),                 // Value when you S/L.

        Tuple.Create("Corridor",            909127783,                  // Long Corridor after climbing down the ladder or returning from the cage room.
                                            909127751),                 // Value qhen you S/L.

        Tuple.Create("Experimentation room",875638887,                  // Cage room when you enter from the long corridor or the weapon shelf room.
                                            875638855),                 // Value when you S/L.

        Tuple.Create("Corridor",            909193319,                  // Weaopon Shelf room when you enter from the cage room, Laboratory or Dans cell.
                                            909193287),                 // Value when you S/L.

        Tuple.Create("Cell",                892416103,                  // Dans Cell when you enter it from the weapon shelf room. One-Way-Door.
                                            892416071),                 // Value when you S/L.

        //Administration
        Tuple.Create("Cafeteria",           942682178,                  // Room after the prologue when you first load in. Also when you S/L inside the room.
                                            942682210),                 // Value when you return from the Boxroom or the Cafeteria and when you S/L.

        Tuple.Create("Boxroom",             808530018,                  // Small room containing the reel of wire when you come from the Cafeteria. One-Way-Door.
                                            808529986),                 // Value when you S/L.

        Tuple.Create("Hall",                808464482,                  // Main Lobby when you enter it from all rooms around it.
                                            808464450),                 // Value when you S/L or enter it from the small loft room.

        Tuple.Create("Meeting room",        842018914,                  // Meeting room which contains a sticky tape.
                                            842018882),                 // Value when you S/L.

        Tuple.Create("Girls' toilet",       892350562,                  // Girls Toilet when you enter it from the hall.
                                            892350530),                 // Value when you S/L.

        Tuple.Create("Boys' toilet",        909127778,                  // Boys Toilet when you enter it from the hall.
                                            909127746),                 // Value when you S/L.

        Tuple.Create("Spanish classroom",   842019170,                  // Spanish classroom when you enter it from the hall.
                                            842019138),                 // Value when you S/L.

        Tuple.Create("Toilets in the teachers' room",   925904962,      // Teacher toilets when you enter it from the girls room vent and S/L.
                                                      925904994),      // Value when you enter the room from the teachers lounge.

        Tuple.Create("Teachers' room (ground floor)",   875573346,      // Teachers lounge when you enter from the girls room, or both hall entries.
                                                      875573314),      // Value when you S/L or enter from the upper area to the lower.

        Tuple.Create("Teachers' room (1st floor)",      909128002,      // Teachers lounge (upper) when you enter it from the lower area or when you S/L.
                                                     909128034),       // Value when you enter the room from the filing room or the hall.

        Tuple.Create("The filing room",                 858796386,      // Filing room when you enter from the upper teachers lounge.
                                                      858796354),      // Value when you S/L.

        Tuple.Create("Loft",                959459394,                  // Small Loft room when you enter it from the hall and when you S/L.
                                            959459426),                 // When you enter the room from the big loft attic.

        Tuple.Create("Loft",                808464738,                  // Big Loft room when you enter it from the small one.
                                            808464706),                 // Value when you S/L.

        Tuple.Create("Boxroom in the filing room",  875573602,                  // Boxroom when you enter from the filing room.
                                                    875573570),                 // Value when you S/L.

        //Courtyard
        Tuple.Create("Central courtyard (ground floor)",    808464493,  // When you enter it through any other area.
                                                            808464461), // When you S/L and return to gathering point and when you go to the gathering point from surveillance room.

        Tuple.Create("Central courtyard (1st floor)",       808464749,  // When you enter it from the stairs.
                                                            808464717), // When you S/L.

        Tuple.Create("Janitor's room",                      825241701,  // When you enter it from the courtyard.
                                                            825241669), // When you S/L.

        Tuple.Create("Video surveillance room",             858796133,  // When you enter from the janitors room.
                                                            858796101), // When you S/L.

        Tuple.Create("Parking",                             825241709,  // When you enter from the courtyard.
                                                            825241677), // When you S/L.

        Tuple.Create("Exterior",                            842018925,  // Outside area where the garden gate is.
                                                            842018893), // Value when you S/L or return from the gardens.

        //Lower Classrooms
        Tuple.Create("Corridor (ground floor)",     808464483,                  // Classrooms big Lobby when you enter it through the courtyard.
                                                    808464451),                 // Value when you S/L.

        Tuple.Create("Administrative office",       808530019,                  // The room you meet stan in when you enter it from the Corridor.
                                                    808529987),                 // Value when you S/L.

        Tuple.Create("Boxroom",                     875573347,                  // Room with the Iron door where the first pistol can be found entered from the corridor.
                                                    875573315),                 // Value when you S/L.

        Tuple.Create("Toilet",                      858796131,                  // Toilet when you enter it from the Corridor.
                                                    858796099),                 // Value when you S/L.

        Tuple.Create("Biology classroom.",          892350787,                  // Room with the broken wall the crab comes out of.
                                                    892350787),                 // Value when you S/L. (So far the only unique id room.)

        Tuple.Create("Physics/Chemistry lab",       909127779,                  // Room with the acid machine.
                                                    909127747),                 // Value when you S/L.

        Tuple.Create("Staircase",                   825307235,                  // Staircase when you enter it through the lower or upper corridor.
                                                    825307203),                 // Value when you S/L.

        //Upper Classrooms
        Tuple.Create("Corridor (1st floor)",        808464739,                  // 1st floor corridor when you enter from the staircase.
                                                    808464707),                 // Value when you S/L.

        Tuple.Create("Maths/physics classroom",     959459427,                  // Room where you find the compass needle.
                                                    959459395),                 // Value when you S/L.

        Tuple.Create("Living languages classroom",  875573603,                  // Classroom with a vent with pistol ammo.
                                                    875573571),                 // Value when you S/L.

        Tuple.Create("Office of Mr. Friedman",      959459683,                  // Headmaster Office.
                                                    959459651),                 // Value when you S/L.

        Tuple.Create("Administrative office.",      825241955,                  // Room with the compass map.
                                                    825241923),                 // Value when you S/L.

        //Lower Library
        Tuple.Create("Corridor (ground floor)",     808464484,                  // Libray main Corridor when you enter it from courtyard.
                                                    808464452),                 // Value when you S/L or return to gathering after being in friedmans hideaway.

        Tuple.Create("Secretary's Office",          808530020,                  // Safe Room when you enter from the corridor.
                                                    808529988),                 // Value when you S/L.

        Tuple.Create("Living languages classroom",  959459428,                  // Room with the living dark aura
                                                    959459396),                 // Value when you S/L.

        Tuple.Create("Meeting room",                825241700,                  // Projector Room
                                                    825241668),                 // Value when you S/L.

        Tuple.Create("Maths/physics classroom",     875573348,                  // Room where the student falls through the window.
                                                    875573316),                 // Value when you S/L.

        Tuple.Create("Boys' toilet",                892350564,                  // Room where the student falls through the window.
                                                    892350532),                 // Value when you S/L.

        Tuple.Create("Girls' toilet",               909127780,                  // Room where the student falls through the window.
                                                    909127748),                 // Value when you S/L.

        Tuple.Create("Library (ground floor)",      858796132,                  // Library main room.
                                                    858796100),                 // Value when you S/L and when it turns to night.

        Tuple.Create("Friedman's Hideaway",         842018916,                  // Library Friedmans Hideout room
                                                    842018884),                 // Value when you S/L.

        //Upper Library
        Tuple.Create("Staircase",                   892350820,                  // Library Staircase.
                                                    892350788),                 // Value when you S/L.

        Tuple.Create("Mezzanine (library)",         909128036,                  // Library main room upper with the statue.
                                                    909128004),                 // Value when you S/L.

        Tuple.Create("Corridor (1st floor)",        808464740,                  // Library Lobby 1st floor.
                                                    808464708),                 // Value when you S/L.

        Tuple.Create("Living languages classroom",  875573604,                  // Classroom with the bugs. Has movable shelf (only in US version)
                                                    875573572),                 // Value when you S/L.

        Tuple.Create("History classroom",           858796388,                  // Normal Classroom. (Front room)
                                                    858796356),                 // Value when you S/L.

        Tuple.Create("Abandoned Classroom",         842019172,                  // Abandoned Classroom with Treeman and Revolver in it.
                                                    842019140),                 // Value when you S/L.

        Tuple.Create("Biology room 2",              825241956,                  // Classroom with many windows (Left in the middle of the main corridor).
                                                    825241924),                 // Value when you S/L.

        //Dining Hall / Sick Bay
        Tuple.Create("Dining hall (ground floor)",  808464485,                  // Dining room when you enter from courtyard
                                                    808464453),                 // Value when you S/L.

        Tuple.Create("Kitchen(ground floor)",       842018917,                  // Kitchen lower floor when you enter it from the dining room.
                                                    842018885),                 // Value when you S/L.

        Tuple.Create("Dining hall (1st floor)",     808464741,                  // 1st floor when you come from lower area.
                                                    808464709),                 // Value when you S/L.

        Tuple.Create("Kitchen (1st floor)",         825241957,                  // 1st floor kitchen when you come from the dining hall 1st floor.
                                                    825241925),                 // Value when you S/L.

        Tuple.Create("Teachers' dining hall",       842019173,                  // 1st floor fuse room.
                                                    842019141),                 // Value when you S/L.

        Tuple.Create("Sick bay",                    858796389,                  // Sick bay.
                                                    858796357),                 // Value when you S/L.

        //Amphitheater
        Tuple.Create("Amphitheater hall",           808464486,                  // Main Lobby when you enter from all rooms.
                                                    808464454),                 // Value when you S/L.

        Tuple.Create("Projection room",             842019174,                  // Projector room.
                                                    842019142),                 // Value when you S/L.

        Tuple.Create("Amphitheater",                858796134,                  // Main Cinema room.
                                                    858796102),                 // Value when you S/L.

        Tuple.Create("Actors' room (ground floor)", 825241702,                  // Makeup room.
                                                    825241670),                 // Value when you S/L.

        Tuple.Create("Artists' entrance",           842018918,                  // Elevator room.
                                                    842018886),                 // Value when you S/L.

        Tuple.Create("Props room",                  825241958,                  // Queen room.
                                                    825241926),                 // Value when you S/L.

        //First Basement
        Tuple.Create("Boiler room",                 808530023,                 // Elevator room lower basement
                                                    808529991),                // Value when you S/L.

        Tuple.Create("Corridor",                    808464487,                 // Long Corridor after the elevator room.
                                                    808464455),                // Value when you S/L.

        Tuple.Create("Corridor",                    842084455,                 // Long Room with the 2 treeman before and after you collect the lever
                                                    842084423),                // Value when you S/L.

        Tuple.Create("Corridor",                    858861671,                 // Long Reddish Corridor with standing student.
                                                    858861639),                // Value when you S/L.

        Tuple.Create("Guinea pig room",             842018919,                 // Guinea Pig room.
                                                    842018887),                // Value when you S/L.

        Tuple.Create("Laboratory 1",                825241703,                 // Lever / Operating room.
                                                    825241671),                // Value when you S/L.

        Tuple.Create("Corridor",                    909128039,                 // Long Lower Corridor next to the cage room.
                                                    909128007),                // Value when you S/L.

        Tuple.Create("Prison",                      875573351,                 // Long Lower Corridor next to the cage room.
                                                    875573319),                // Value when you S/L.

        //Dormitory
        Tuple.Create("Corridor",                    808464489,                 // Dormitory Entrance Lobby.
                                                    808464457),                // Value when you S/L.

        Tuple.Create("Study room",                  842018921,                 // Room with the satanic symbols close to the dorm entrance.
                                                    842018889),                // Value when you S/L.

        Tuple.Create("Waiting room",                825241705,                 // Queen Room.
                                                    825241673),                // Value when you S/L.

        Tuple.Create("Boys' toilet",                875573353,                 // Toilets (both)
                                                    875573321),                // Value when you S/L.

        Tuple.Create("Dormitory",                   925905001,                 // Door at the end of the dormitory with the beds and light grenade.
                                                    925904969),                // Value when you S/L.

        Tuple.Create("Corridor",                    808464745,                 // Upper Corridor with the wooden boards.
                                                    808464713),                // Value when you S/L.

        Tuple.Create("Dormitory",                   925905257,                 // Upper Corridor with the wooden boards.
                                                    925905225),                // Value when you S/L.

        Tuple.Create("Dormitory",                   825241961,                 // Big Room with 2 students at the end of the woodden corridor.
                                                    825241929),                // Value when you S/L or when you come back from the boxroom.

        Tuple.Create("Supervisor's room 2",         858796393,                 // 1st floor box room.
                                                    858796361),                // Value when you S/L.

        Tuple.Create("Supervisor's room 1",         842019177,                 // 1st floor box dropping room.
                                                    842019145),                // Value when you S/L.

        //Gardens
        Tuple.Create("The garden",                  808464449,                 // Gardens big room with the shotgun or when you S/L.
                                                    808464481),                // Value when you enter it from the garden bridge room. 

        Tuple.Create("The wood",                    825241697,                 // Gardens Bridge room
                                                    825241665),                // Value when you S/L or when you enter from the statue room.

        Tuple.Create("The wood",                    842018881,                 // Statue room. When you come from Gardens Bridge room or when you S/L.                                                                                                                          
                                                    842018913),                // When you enter from the garden house area.

        //Basement Revisited
        Tuple.Create("Laboratory 1",                892350567,                 // Lab with fancy chair.                                                                                                                          
                                                    892350535),                // Value when you S/L.

        Tuple.Create("Guinea Pig room 2",           858796135,                 // Guinea Pig room 2 with the laser gun.                                                                                                                         
                                                    858796103),                // Value when you S/L.

        Tuple.Create("Greenhouse 1",                925904999,                 // Greenhouse with treeman.                                                                                                                   
                                                    925904967),                // Value when you S/L.

        Tuple.Create("Room with the door",          942682215,                 // Room with the big door.                                                                                                                  
                                                    942682183),                // Value when you S/L. and return to gathering after opening the big door and when you return from leonard arena.

        Tuple.Create("Greenhouse 2",                875573607,                 // Greenhouse lower with the dog.                                                                                                                 
                                                    875573575),                // Value when you S/L.

        Tuple.Create("Machine room",                892350823,                 // Queen room.                                                                                                           
                                                    892350791),                // Value when you S/L.

        Tuple.Create("Main corridor",               808464743,                 // Corridor with 3 treeman and light grenade.                                                                                                          
                                                    808464711),                // Value when you S/L.

        Tuple.Create("Store",                       925905255,                 // Corridor for the machine room lever.                                                                                                          
                                                    925905223),                // Value when you S/L.

        Tuple.Create("Cell",                        858796391,                 // Room with the machine room lever.                                                                                                        
                                                    858796359),                // Value when you S/L.

        Tuple.Create("Unnamed - Leonard I",         959459399,                 // Leonard Lower Bossfight, no save possible here.                                                                                                      
                                                    959459399)                 // Value when you S/L.
    };   
}


init
{
        switch (modules.First().ModuleMemorySize)
        {
            case 3662336:
                version = "Steam - Europe 1.0.1.0";
                break;
        }
}


//Must be a unique starting condition that does not the start the timer when you watch a video in the extras section.
start {

    if (current.isMainMenu == 0 && old.isMainMenu == 1 && current.room_value == 808464458 && current.video == "CIN01")
    {
        return true;
    }


}

split
{
    //Final split
    if (current.room_value == 808464458 && current.isCutsceneActive == 1 && (vars.NGstarted))
    {
        vars.NGstarted = false;
        return true;
    }

    //Normal split logic. Set NGStarted to true here so it does not split endlessly.
    if (current.room_value != old.room_value)
    {
        vars.NGstarted = true;
        return true;
    }
}

reset
{

    if (current.isMainMenu == 1)
    {
        vars.NGstarted = false;
        return true;
    }
}