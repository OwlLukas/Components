using System;
using System.Collections.Generic;
using LiveSplit.Model;
using LiveSplit.UI.Components.AutoSplit;

namespace TRLELostAndFoundv4;

public sealed class Autosplitter : IAutoSplitter, IDisposable
{
    internal readonly ComponentSettings Settings = new();

    private readonly HashSet<string> _doneRooms = new(StringComparer.Ordinal);

    public Autosplitter()
    {
        GameData.VersionInfoChanged += Settings.RefreshGameVersionLabel;
    }

    public TimeSpan? GetGameTime(LiveSplitState state)
    {
        return null;
    }

    public bool IsGameTimePaused(LiveSplitState state)
    {
        return false;
    }

    public bool ShouldStart(LiveSplitState state)
    {
        if (GameData.VersionState != TrleVersionState.LafCh1V4)
            return false;

        string cur = NormChapter(GameData.ChapterName.Current);
        string old = NormChapter(GameData.ChapterName.Old);

        if (ChapterContains(cur, "1INTRO.TR4") && ChapterContains(old, "TITLE.TR4"))
            return true;

        return ChapterContains(cur, "8HOME1.TR4") && ChapterContains(old, "TITLE.TR4");
    }

    public bool ShouldReset(LiveSplitState state)
    {
        return false;
    }

    public bool ShouldSplit(LiveSplitState state)
    {
        if (GameData.VersionState != TrleVersionState.LafCh1V4)
            return false;

        string cur = NormChapter(GameData.ChapterName.Current);
        string old = NormChapter(GameData.ChapterName.Old);

        byte gs = GameData.GameState.Current;
        byte load = GameData.IsLoadingScreenActive.Old;

        if (Settings.MainSplitLevels
            && Settings.IsMainGameLevelSplitEnabled(old)
            && cur == "7SUNKEN.TR4"
            && gs == 1)
            return true;

        if (Settings.LarasHomeSplitLevels
            && Settings.IsLaraHomeLevelSplitEnabled(old)
            && cur == "8HOME1.TR4"
            && GameData.LarasHomeEnd.Current == 1
            && GameData.LarasHomeEnd.Old == 0)
            return true;

        if (Settings.MainSplitLevels
            && Settings.IsMainGameLevelSplitEnabled(old)
            && GameData.ChapterName.Current != GameData.ChapterName.Old
            && !_doneRooms.Contains(cur)
            && cur != "8HOME1.TR4"
            && old != "8HOME1.TR4"
            && !ChapterContains(cur, "TITLE.TR4"))
            return true;

        if (Settings.MainGameItems && cur != "8HOME1.TR4" && load == 0)
        {
            if (Settings.MainGameAllItemsSplit && GameData.TotalItemCounter.Current > GameData.TotalItemCounter.Old)
                return true;

            if (Settings.MainGameSecretKeysSplit && GameData.LarasHomeDocumentCounter.Current > GameData.LarasHomeDocumentCounter.Old)
                return true;

            if (Settings.MainGameGoldenSecretsSplit && GameData.LarasHomePolaroidCounter.Current > GameData.LarasHomePolaroidCounter.Old)
                return true;

            if (Settings.MainGameRelicsSplit && GameData.LarasHomeFamilyCrestCounter.Current > GameData.LarasHomeFamilyCrestCounter.Old)
                return true;

            if (Settings.MainGameDocumentsSplit && GameData.LarasHomeMagazineCounter.Current > GameData.LarasHomeMagazineCounter.Old)
                return true;

            if (Settings.MainGameSecretsSplit && GameData.TotalSecretsCounter.Current > GameData.TotalSecretsCounter.Old)
                return true;

            if (Settings.MainGameMysteriousSplit
                && cur == "7SUNKEN.TR4"
                && GameData.MysteriousItemCounter.Current > GameData.MysteriousItemCounter.Old)
                return true;

            if (Settings.MainGameKillsSplit && GameData.TotalKillsCounter.Current > GameData.TotalKillsCounter.Old)
                return true;
        }

        if (Settings.MainLarasHomeSplits && cur == "8HOME1.TR4" && load == 0)
        {
            if (Settings.LarasHomeDocumentSplit && GameData.LarasHomeDocumentCounter.Current > GameData.LarasHomeDocumentCounter.Old)
                return true;

            if (Settings.LarasHomePolaroidSplit && GameData.LarasHomePolaroidCounter.Current > GameData.LarasHomePolaroidCounter.Old)
                return true;

            if (Settings.LarasHomeMagazineSplit && GameData.LarasHomeMagazineCounter.Current > GameData.LarasHomeMagazineCounter.Old)
                return true;

            if (Settings.LarasHomeFamilyCrestSplit && GameData.LarasHomeFamilyCrestCounter.Current > GameData.LarasHomeFamilyCrestCounter.Old)
                return true;

            if (Settings.LarasHomeAllItemsSplit && GameData.TotalItemCounter.Current > GameData.TotalItemCounter.Old)
                return true;
        }

        return false;
    }

    internal void OnSplit()
    {
        string o = NormChapter(GameData.ChapterName.Old);
        string c = NormChapter(GameData.ChapterName.Current);

        if (!_doneRooms.Contains(o))
            _doneRooms.Add(o);

        if (!_doneRooms.Contains(c))
            _doneRooms.Add(c);
    }

    internal void OnStartRun()
    {
        _doneRooms.Clear();
    }

    internal void OnResetRun()
    {
        _doneRooms.Clear();
    }

    internal void OnUndoSplit()
    {
        _doneRooms.Clear();
    }

    private static bool ChapterContains(string chapter, string token)
    {
        if (string.IsNullOrEmpty(chapter))
            return false;

        return chapter.IndexOf(token, StringComparison.OrdinalIgnoreCase) >= 0;
    }

    internal static string NormChapter(string raw)
    {
        if (string.IsNullOrEmpty(raw))
            return string.Empty;

        int len = raw.Length;
        while (len > 0 && raw[len - 1] == '\0')
            len--;

        return len == 0 ? string.Empty : raw.Substring(0, len).Trim();
    }

    public void Dispose()
    {
        GameData.VersionInfoChanged -= Settings.RefreshGameVersionLabel;
        Settings.Dispose();
    }
}
