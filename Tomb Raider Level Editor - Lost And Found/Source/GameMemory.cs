using System;
using System.Diagnostics;
using LiveSplit.ComponentUtil;

namespace TRLELostAndFoundv4;

/// <summary>Watchers for TRLE Lost and Found CH1 v4 (<c>tomb4</c> / ASL offsets).</summary>
internal sealed class GameMemory
{
    internal const int LafCh1V4MainModuleSize = 0x517000;

    internal readonly MemoryWatcherList Watchers = new();

    internal void InitializeWatchers()
    {
        Watchers.Clear();

        Watchers.Add(new MemoryWatcher<int>(new DeepPointer("tomb4.exe", 0x3FD138)) { Name = nameof(GameTimer) });
        Watchers.Add(new StringWatcher(new DeepPointer("Tomb_NextGeneration.dll", 0x1BD90A), 22) { Name = nameof(ChapterName) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("tomb4.exe", 0x7B694)) { Name = nameof(GameState) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("tomb4.exe", 0x3F5846)) { Name = nameof(LarasHomeEnd) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Tomb_NextGeneration.dll", 0x3D869B)) { Name = nameof(IsLoadingScreenActive) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Plugin_ClassicInventory.dll", 0x9C888)) { Name = nameof(TotalItemCounter) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Tomb_NextGeneration.dll", 0x54D345)) { Name = nameof(LarasHomeDocumentCounter) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Tomb_NextGeneration.dll", 0x54D344)) { Name = nameof(LarasHomePolaroidCounter) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Tomb_NextGeneration.dll", 0x54D347)) { Name = nameof(LarasHomeMagazineCounter) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Tomb_NextGeneration.dll", 0x54D346)) { Name = nameof(LarasHomeFamilyCrestCounter) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Tomb_NextGeneration.dll", 0x54D343)) { Name = nameof(MysteriousItemCounter) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("tomb4.exe", 0x3F7744)) { Name = nameof(TotalSecretsCounter) });
        Watchers.Add(new MemoryWatcher<byte>(new DeepPointer("Plugin_ClassicInventory.dll", 0x9C320)) { Name = nameof(TotalKillsCounter) });
    }

    internal MemoryWatcher<int> GameTimer => (MemoryWatcher<int>)Watchers[nameof(GameTimer)];
    internal StringWatcher ChapterName => (StringWatcher)Watchers[nameof(ChapterName)];
    internal MemoryWatcher<byte> GameState => (MemoryWatcher<byte>)Watchers[nameof(GameState)];
    internal MemoryWatcher<byte> LarasHomeEnd => (MemoryWatcher<byte>)Watchers[nameof(LarasHomeEnd)];
    internal MemoryWatcher<byte> IsLoadingScreenActive => (MemoryWatcher<byte>)Watchers[nameof(IsLoadingScreenActive)];
    internal MemoryWatcher<byte> TotalItemCounter => (MemoryWatcher<byte>)Watchers[nameof(TotalItemCounter)];
    internal MemoryWatcher<byte> LarasHomeDocumentCounter => (MemoryWatcher<byte>)Watchers[nameof(LarasHomeDocumentCounter)];
    internal MemoryWatcher<byte> LarasHomePolaroidCounter => (MemoryWatcher<byte>)Watchers[nameof(LarasHomePolaroidCounter)];
    internal MemoryWatcher<byte> LarasHomeMagazineCounter => (MemoryWatcher<byte>)Watchers[nameof(LarasHomeMagazineCounter)];
    internal MemoryWatcher<byte> LarasHomeFamilyCrestCounter => (MemoryWatcher<byte>)Watchers[nameof(LarasHomeFamilyCrestCounter)];
    internal MemoryWatcher<byte> MysteriousItemCounter => (MemoryWatcher<byte>)Watchers[nameof(MysteriousItemCounter)];
    internal MemoryWatcher<byte> TotalSecretsCounter => (MemoryWatcher<byte>)Watchers[nameof(TotalSecretsCounter)];
    internal MemoryWatcher<byte> TotalKillsCounter => (MemoryWatcher<byte>)Watchers[nameof(TotalKillsCounter)];

    internal static bool TryGetTomb4ExeModuleSize(Process process, out int moduleMemorySize)
    {
        moduleMemorySize = 0;
        try
        {
            foreach (ProcessModule m in process.Modules)
            {
                if (m.ModuleName.Equals("tomb4.exe", StringComparison.OrdinalIgnoreCase))
                {
                    moduleMemorySize = (int)m.ModuleMemorySize;
                    return true;
                }
            }
        }
        catch
        {
            return false;
        }

        return false;
    }
}
