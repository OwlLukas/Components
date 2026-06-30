using System;
using System.Windows.Forms;
using System.Xml;
using LiveSplit.Model;
using LiveSplit.UI;
using LiveSplit.UI.Components;
using LiveSplit.UI.Components.AutoSplit;

namespace TRLELostAndFoundv4;

public sealed class Component : AutoSplitComponent
{
    private readonly Autosplitter _splitter;
    private readonly LiveSplitState _state;

    public Component(Autosplitter autosplitter, LiveSplitState state) : base(autosplitter, state)
    {
        _splitter = autosplitter;
        _state = state;
        _state.OnStart += StateOnStart;
        _state.OnSplit += StateOnSplit;
        _state.OnReset += StateOnReset;
        _state.OnUndoSplit += StateOnUndoSplit;
    }

    public override string ComponentName => "Tomb Raider Level Editor - Lost And Found";

    private void StateOnStart(object _, EventArgs __) => _splitter.OnStartRun();

    private void StateOnSplit(object _, EventArgs __) => _splitter.OnSplit();

    private void StateOnReset(object _, TimerPhase __) => _splitter.OnResetRun();

    private void StateOnUndoSplit(object _, EventArgs __) => _splitter.OnUndoSplit();

    public override Control GetSettingsControl(LayoutMode mode) => _splitter.Settings;

    public override XmlNode GetSettings(XmlDocument document)
    {
        XmlElement settingsNode = document.CreateElement("Settings");
        _splitter.Settings.AppendSettingsTo(document, settingsNode);
        return settingsNode;
    }

    public override void SetSettings(XmlNode settings)
    {
        if (settings == null)
            return;

        _splitter.Settings.ReadSettingsFrom(settings);
    }

    public override void Update(IInvalidator invalidator, LiveSplitState state, float width, float height, LayoutMode mode)
    {
        if (GameData.Update())
            base.Update(invalidator, state, width, height, mode);
    }

    public override void Dispose()
    {
        _state.OnStart -= StateOnStart;
        _state.OnSplit -= StateOnSplit;
        _state.OnReset -= StateOnReset;
        _state.OnUndoSplit -= StateOnUndoSplit;
        _splitter.Dispose();
    }
}
