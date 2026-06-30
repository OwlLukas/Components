using System;
using System.Diagnostics;
using LiveSplit.ComponentUtil;

namespace TRLELostAndFoundv4;

internal enum TrleVersionState
{
    None,
    Unknown,
    LafCh1V4,
}

internal static class GameData
{
    private static readonly GameMemory Memory = new();

    private static Process _gameProcess;

    internal static TrleVersionState VersionState { get; private set; } = TrleVersionState.None;

    internal static int LastUnknownModuleSize { get; private set; }

    internal static event Action VersionInfoChanged;

    internal static MemoryWatcher<int> GameTimer => Memory.GameTimer;
    internal static StringWatcher ChapterName => Memory.ChapterName;
    internal static MemoryWatcher<byte> GameState => Memory.GameState;
    internal static MemoryWatcher<byte> LarasHomeEnd => Memory.LarasHomeEnd;
    internal static MemoryWatcher<byte> IsLoadingScreenActive => Memory.IsLoadingScreenActive;
    internal static MemoryWatcher<byte> TotalItemCounter => Memory.TotalItemCounter;
    internal static MemoryWatcher<byte> LarasHomeDocumentCounter => Memory.LarasHomeDocumentCounter;
    internal static MemoryWatcher<byte> LarasHomePolaroidCounter => Memory.LarasHomePolaroidCounter;
    internal static MemoryWatcher<byte> LarasHomeMagazineCounter => Memory.LarasHomeMagazineCounter;
    internal static MemoryWatcher<byte> LarasHomeFamilyCrestCounter => Memory.LarasHomeFamilyCrestCounter;
    internal static MemoryWatcher<byte> MysteriousItemCounter => Memory.MysteriousItemCounter;
    internal static MemoryWatcher<byte> TotalSecretsCounter => Memory.TotalSecretsCounter;
    internal static MemoryWatcher<byte> TotalKillsCounter => Memory.TotalKillsCounter;

    internal static bool Update()
    {
        try
        {
            if (_gameProcess != null)
            {
                if (_gameProcess.HasExited)
                {
                    _gameProcess.Dispose();
                    _gameProcess = null;
                    Memory.Watchers.Clear();
                    SetVersion(TrleVersionState.None);
                    return false;
                }

                Memory.Watchers.UpdateAll(_gameProcess);
                return VersionState == TrleVersionState.LafCh1V4;
            }

            Process[] found = Process.GetProcessesByName("tomb4");
            if (found.Length == 0)
            {
                SetVersion(TrleVersionState.None);
                return false;
            }

            Process candidate = found[0];
            for (int i = 1; i < found.Length; i++)
                found[i].Dispose();

            if (!GameMemory.TryGetTomb4ExeModuleSize(candidate, out int size))
            {
                candidate.Dispose();
                SetVersion(TrleVersionState.Unknown, 0);
                return false;
            }

            if (size != GameMemory.LafCh1V4MainModuleSize)
            {
                candidate.Dispose();
                SetVersion(TrleVersionState.Unknown, size);
                return false;
            }

            _gameProcess = candidate;
            Memory.InitializeWatchers();
            Memory.Watchers.UpdateAll(_gameProcess);
            SetVersion(TrleVersionState.LafCh1V4);
            return true;
        }
        catch
        {
            return false;
        }
    }

    private static void SetVersion(TrleVersionState state, int unknownSize = 0)
    {
        if (VersionState == state && (state != TrleVersionState.Unknown || LastUnknownModuleSize == unknownSize))
            return;

        VersionState = state;
        LastUnknownModuleSize = unknownSize;
        VersionInfoChanged?.Invoke();
    }
}
