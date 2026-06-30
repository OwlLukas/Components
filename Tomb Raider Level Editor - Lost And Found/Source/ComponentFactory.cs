using System;
using System.IO;
using System.Reflection;
using LiveSplit.Model;
using LiveSplit.UI.Components;
using UpdateManager;

[assembly: ComponentFactory(typeof(TRLELostAndFoundv4.ComponentFactory))]

namespace TRLELostAndFoundv4;

public sealed class ComponentFactory : IComponentFactory
{
    public ComponentFactory()
    {
    }

    public ComponentCategory Category => ComponentCategory.Timer;

    public string ComponentName => "Tomb Raider Level Editor - Lost And Found";

    public string Description =>
        "Autosplitter for Tomb Raider Level Editor - Lost And Found v4 (tomb4.exe 0x517000).";

    public IComponent Create(LiveSplitState state) => new Component(new Autosplitter(), state);

    public Version Version => Assembly.GetExecutingAssembly().GetName().Version;

    public string UpdateName => ComponentName;

    public string UpdateURL => "https://raw.githubusercontent.com/OwlLukas/Components/main/";

    public string XMLURL => Path.Combine(UpdateURL, "Tomb%20Raider%20Level%20Editor%20-%20Lost%20And%20Found/Components/update.xml");
}
