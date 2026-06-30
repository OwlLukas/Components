namespace TRLELostAndFoundv4;

/// <summary>Chapter and defaults from <c>TRLELostAndFoundv4.asl</c>.</summary>
internal static class TrleRoute
{
    internal readonly struct LevelEntry
    {
        internal string Id { get; }
        internal string DisplayName { get; }
        internal bool DefaultEnabled { get; }

        internal LevelEntry(string id, string displayName, bool defaultEnabled)
        {
            Id = id;
            DisplayName = displayName;
            DefaultEnabled = defaultEnabled;
        }
    }

    internal static readonly LevelEntry[] MainGameLevels =
    {
        new("1INTRO.TR4", "Intro Cutscene", true),
        new("2CITADEL.TR4", "Desert Ruins - The Citadel", true),
        new("3CITADEL_CUT.TR4", "Canyon", true),
        new("4MINES.TR4", "Abandoned Mines", true),
        new("5LOST_IRAM.TR4", "Lost City of Iram", true),
        new("6LOST_IRAM_CUT.TR4", "Lost City of Iram - Final Cutscene", true),
        new("7SUNKEN.TR4", "Sunken Ruins [End Split]", true),
    };

    internal static readonly LevelEntry[] LaraHomeLevels =
    {
        new("8HOME1.TR4", "Lara's Home [End Split]", true),
    };
}
