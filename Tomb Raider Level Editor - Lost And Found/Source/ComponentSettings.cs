using System;
using System.Drawing;
using System.Reflection;
using System.Windows.Forms;
using System.Xml;
using LiveSplit.UI;

namespace TRLELostAndFoundv4;

public sealed class ComponentSettings : UserControl
{
    private readonly TabControl _tabs;
    private readonly TabPage _tabMain;
    private readonly TabPage _tabLara;

    private readonly GroupBox _mainLevelsGroup;
    private readonly CheckBox _chkMainSplitLevels;
    private readonly CheckedListBox _mainLevelList;
    private readonly Button _mainSelectAllButton;
    private readonly Button _mainClearAllButton;

    private readonly GroupBox _mainItemsGroup;
    private readonly CheckBox _chkMainGameItems;
    private readonly RadioButton _mainAnyItemOnlyRadio;
    private readonly RadioButton _mainDetailedItemsRadio;
    private readonly CheckBox _chkMainGameSecretKeys;
    private readonly CheckBox _chkMainGameGoldenSecrets;
    private readonly CheckBox _chkMainGameRelics;
    private readonly CheckBox _chkMainGameDocuments;
    private readonly CheckBox _chkMainGameSecrets;
    private readonly CheckBox _chkMainGameMysterious;
    private readonly CheckBox _chkMainGameKills;

    private readonly GroupBox _laraLevelsGroup;
    private readonly CheckBox _chkLarasHomeSplitLevels;

    private readonly GroupBox _laraItemsGroup;
    private readonly CheckBox _chkMainLarasHomeSplits;
    private readonly RadioButton _laraAnyItemOnlyRadio;
    private readonly RadioButton _laraDetailedItemsRadio;
    private readonly CheckBox _chkLaraDoc;
    private readonly CheckBox _chkLaraPolaroid;
    private readonly CheckBox _chkLaraMagazine;
    private readonly CheckBox _chkLaraCrest;

    public readonly Label GameVersionLabel;
    public readonly Label AutosplitterVersionLabel;

    public bool MainSplitLevels = true;
    public bool LarasHomeSplitLevels = true;
    public bool MainGameItems = true;
    public bool MainLarasHomeSplits = true;

    // Kept for backwards compatibility with existing split logic and saved settings.
    public bool MainGameAllItemsSplit;
    public bool MainGameSecretKeysSplit = true;
    public bool MainGameGoldenSecretsSplit = true;
    public bool MainGameRelicsSplit = true;
    public bool MainGameDocumentsSplit = true;
    public bool MainGameSecretsSplit = true;
    public bool MainGameMysteriousSplit = true;
    public bool MainGameKillsSplit = true;

    public bool LarasHomeDocumentSplit = true;
    public bool LarasHomePolaroidSplit = true;
    public bool LarasHomeMagazineSplit = true;
    public bool LarasHomeFamilyCrestSplit = true;
    public bool LarasHomeAllItemsSplit;

    public bool MainGameAnyItemOnlyMode;
    public bool LarasHomeAnyItemOnlyMode;

    public ComponentSettings()
    {
        _tabs = new TabControl();
        _tabMain = new TabPage();
        _tabLara = new TabPage();

        _mainLevelsGroup = new GroupBox();
        _chkMainSplitLevels = new CheckBox();
        _mainLevelList = new CheckedListBox();
        _mainSelectAllButton = new Button();
        _mainClearAllButton = new Button();

        _mainItemsGroup = new GroupBox();
        _chkMainGameItems = new CheckBox();
        _mainAnyItemOnlyRadio = new RadioButton();
        _mainDetailedItemsRadio = new RadioButton();
        _chkMainGameSecretKeys = new CheckBox();
        _chkMainGameGoldenSecrets = new CheckBox();
        _chkMainGameRelics = new CheckBox();
        _chkMainGameDocuments = new CheckBox();
        _chkMainGameSecrets = new CheckBox();
        _chkMainGameMysterious = new CheckBox();
        _chkMainGameKills = new CheckBox();

        _laraLevelsGroup = new GroupBox();
        _chkLarasHomeSplitLevels = new CheckBox();

        _laraItemsGroup = new GroupBox();
        _chkMainLarasHomeSplits = new CheckBox();
        _laraAnyItemOnlyRadio = new RadioButton();
        _laraDetailedItemsRadio = new RadioButton();
        _chkLaraDoc = new CheckBox();
        _chkLaraPolaroid = new CheckBox();
        _chkLaraMagazine = new CheckBox();
        _chkLaraCrest = new CheckBox();

        GameVersionLabel = new Label();
        AutosplitterVersionLabel = new Label();

        InitializeComponent();
        BuildLevelLists();
        SyncItemCheckboxesFromModel();
        ApplyGroupAvailability();
    }

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        SuspendLayout();

        Control parent = Parent;
        Control parentParent = parent?.Parent;
        Control componentSettingsDialog = parentParent?.Parent;
        if (componentSettingsDialog is not null)
        {
            componentSettingsDialog.SuspendLayout();
            componentSettingsDialog.Size = new Size(Width + 20, Height + 100);
            parentParent!.Size = new Size(Width + 10, Height + 50);
            parent!.Size = new Size(Width + 10, Height + 50);
            componentSettingsDialog.ResumeLayout(false);
            componentSettingsDialog.PerformLayout();
        }

        ResumeLayout(false);
        PerformLayout();
    }

    internal void RefreshGameVersionLabel()
    {
        if (IsDisposed)
            return;

        const string ok = "Game Version: Tomb Raider: Lost and Found (v4) (tomb4.exe ModuleMemorySize: 0x517000)";
        switch (GameData.VersionState)
        {
            case TrleVersionState.LafCh1V4:
                GameVersionLabel.Text = ok;
                GameVersionLabel.ForeColor = Color.ForestGreen;
                break;
            case TrleVersionState.Unknown:
                GameVersionLabel.Text =
                    $"Game Version: Unknown / unsupported build (tomb4.exe size: 0x{GameData.LastUnknownModuleSize:X})";
                GameVersionLabel.ForeColor = SystemColors.GrayText;
                break;
            default:
                GameVersionLabel.Text = "Game Version: None / Undetected";
                GameVersionLabel.ForeColor = SystemColors.GrayText;
                break;
        }
    }

    internal bool IsMainGameLevelSplitEnabled(string chapterId)
    {
        if (!MainSplitLevels)
            return false;

        chapterId = Autosplitter.NormChapter(chapterId);
        for (int i = 0; i < TrleRoute.MainGameLevels.Length; i++)
        {
            if (string.Equals(TrleRoute.MainGameLevels[i].Id, chapterId, StringComparison.OrdinalIgnoreCase))
                return _mainLevelList.GetItemChecked(i);
        }

        return false;
    }

    internal bool IsLaraHomeLevelSplitEnabled(string chapterId)
    {
        if (!LarasHomeSplitLevels)
            return false;

        chapterId = Autosplitter.NormChapter(chapterId);
        for (int i = 0; i < TrleRoute.LaraHomeLevels.Length; i++)
        {
            if (string.Equals(TrleRoute.LaraHomeLevels[i].Id, chapterId, StringComparison.OrdinalIgnoreCase))
                return true;
        }

        return false;
    }

    private void BuildLevelLists()
    {
        _mainLevelList.Items.Clear();
        for (int i = 0; i < TrleRoute.MainGameLevels.Length; i++)
        {
            TrleRoute.LevelEntry e = TrleRoute.MainGameLevels[i];
            _ = _mainLevelList.Items.Add(e.DisplayName, true);
        }
    }

    private void SetAllChecked(CheckedListBox list, bool value)
    {
        for (int i = 0; i < list.Items.Count; i++)
            list.SetItemChecked(i, value);
    }

    private void ClearMainLevelScopeChecks()
    {
        _chkMainGameSecretKeys.Checked = false;
        _chkMainGameGoldenSecrets.Checked = false;
        _chkMainGameRelics.Checked = false;
        _chkMainGameDocuments.Checked = false;
        _chkMainGameMysterious.Checked = false;
    }

    private void ClearLarasHomeItemTypeChecks()
    {
        _chkLaraDoc.Checked = false;
        _chkLaraPolaroid.Checked = false;
        _chkLaraMagazine.Checked = false;
        _chkLaraCrest.Checked = false;
    }

    private void ApplyGroupAvailability()
    {
        _mainLevelList.Enabled = MainSplitLevels;
        _mainSelectAllButton.Enabled = MainSplitLevels;
        _mainClearAllButton.Enabled = MainSplitLevels;

        bool mainItemsEnabled = MainGameItems;
        _mainAnyItemOnlyRadio.Enabled = mainItemsEnabled;
        _mainDetailedItemsRadio.Enabled = mainItemsEnabled;

        bool mainDetailedEnabled = mainItemsEnabled && !MainGameAnyItemOnlyMode;
        _chkMainGameSecretKeys.Enabled = mainDetailedEnabled;
        _chkMainGameGoldenSecrets.Enabled = mainDetailedEnabled;
        _chkMainGameRelics.Enabled = mainDetailedEnabled;
        _chkMainGameDocuments.Enabled = mainDetailedEnabled;
        _chkMainGameSecrets.Enabled = mainItemsEnabled;
        _chkMainGameMysterious.Enabled = mainDetailedEnabled;
        _chkMainGameKills.Enabled = mainItemsEnabled;

        _chkMainLarasHomeSplits.Enabled = true;

        bool laraItemsEnabled = MainLarasHomeSplits;
        _laraAnyItemOnlyRadio.Enabled = laraItemsEnabled;
        _laraDetailedItemsRadio.Enabled = laraItemsEnabled;

        bool laraDetailedEnabled = laraItemsEnabled && !LarasHomeAnyItemOnlyMode;
        _chkLaraDoc.Enabled = laraDetailedEnabled;
        _chkLaraPolaroid.Enabled = laraDetailedEnabled;
        _chkLaraMagazine.Enabled = laraDetailedEnabled;
        _chkLaraCrest.Enabled = laraDetailedEnabled;
    }

    private void SyncItemCheckboxesFromModel()
    {
        _chkMainSplitLevels.Checked = MainSplitLevels;
        _chkLarasHomeSplitLevels.Checked = LarasHomeSplitLevels;

        _chkMainGameItems.Checked = MainGameItems;
        _mainAnyItemOnlyRadio.Checked = MainGameAnyItemOnlyMode;
        _mainDetailedItemsRadio.Checked = !MainGameAnyItemOnlyMode;
        _chkMainGameSecretKeys.Checked = MainGameSecretKeysSplit;
        _chkMainGameGoldenSecrets.Checked = MainGameGoldenSecretsSplit;
        _chkMainGameRelics.Checked = MainGameRelicsSplit;
        _chkMainGameDocuments.Checked = MainGameDocumentsSplit;
        _chkMainGameSecrets.Checked = MainGameSecretsSplit;
        _chkMainGameMysterious.Checked = MainGameMysteriousSplit;
        _chkMainGameKills.Checked = MainGameKillsSplit;
        if (MainGameAnyItemOnlyMode)
            ClearMainLevelScopeChecks();

        _chkMainLarasHomeSplits.Checked = MainLarasHomeSplits;
        _laraAnyItemOnlyRadio.Checked = LarasHomeAnyItemOnlyMode;
        _laraDetailedItemsRadio.Checked = !LarasHomeAnyItemOnlyMode;
        _chkLaraDoc.Checked = LarasHomeDocumentSplit;
        _chkLaraPolaroid.Checked = LarasHomePolaroidSplit;
        _chkLaraMagazine.Checked = LarasHomeMagazineSplit;
        _chkLaraCrest.Checked = LarasHomeFamilyCrestSplit;
        if (LarasHomeAnyItemOnlyMode)
            ClearLarasHomeItemTypeChecks();

        ApplyGroupAvailability();
    }

    private void PullModelFromUiCheckboxes()
    {
        MainSplitLevels = _chkMainSplitLevels.Checked;
        LarasHomeSplitLevels = _chkLarasHomeSplitLevels.Checked;

        MainGameItems = _chkMainGameItems.Checked;
        MainGameAnyItemOnlyMode = _mainAnyItemOnlyRadio.Checked;
        MainGameAllItemsSplit = MainGameAnyItemOnlyMode;
        MainGameSecretKeysSplit = !MainGameAnyItemOnlyMode && _chkMainGameSecretKeys.Checked;
        MainGameGoldenSecretsSplit = !MainGameAnyItemOnlyMode && _chkMainGameGoldenSecrets.Checked;
        MainGameRelicsSplit = !MainGameAnyItemOnlyMode && _chkMainGameRelics.Checked;
        MainGameDocumentsSplit = !MainGameAnyItemOnlyMode && _chkMainGameDocuments.Checked;
        MainGameSecretsSplit = _chkMainGameSecrets.Checked;
        MainGameMysteriousSplit = !MainGameAnyItemOnlyMode && _chkMainGameMysterious.Checked;
        MainGameKillsSplit = _chkMainGameKills.Checked;

        MainLarasHomeSplits = _chkMainLarasHomeSplits.Checked;
        LarasHomeAnyItemOnlyMode = _laraAnyItemOnlyRadio.Checked;
        LarasHomeAllItemsSplit = LarasHomeAnyItemOnlyMode;
        LarasHomeDocumentSplit = !LarasHomeAnyItemOnlyMode && _chkLaraDoc.Checked;
        LarasHomePolaroidSplit = !LarasHomeAnyItemOnlyMode && _chkLaraPolaroid.Checked;
        LarasHomeMagazineSplit = !LarasHomeAnyItemOnlyMode && _chkLaraMagazine.Checked;
        LarasHomeFamilyCrestSplit = !LarasHomeAnyItemOnlyMode && _chkLaraCrest.Checked;

    }

    private void WireItemCheck(CheckBox cb, string text, int x, int rowY)
    {
        cb.AutoSize = true;
        cb.Location = new Point(x, rowY);
        cb.Text = text;
        cb.UseVisualStyleBackColor = true;
        cb.CheckedChanged += (_, _) => PullModelFromUiCheckboxes();
        _mainItemsGroup.Controls.Add(cb);
    }

    private void WireLaraCheck(CheckBox cb, string text, int x, int rowY)
    {
        cb.AutoSize = true;
        cb.Location = new Point(x, rowY);
        cb.Text = text;
        cb.UseVisualStyleBackColor = true;
        cb.CheckedChanged += (_, _) => PullModelFromUiCheckboxes();
        _laraItemsGroup.Controls.Add(cb);
    }

    private void InitializeComponent()
    {
        SuspendLayout();
        _mainLevelsGroup.SuspendLayout();
        _mainItemsGroup.SuspendLayout();
        _laraLevelsGroup.SuspendLayout();
        _laraItemsGroup.SuspendLayout();
        _tabMain.SuspendLayout();
        _tabLara.SuspendLayout();

        AutoScaleDimensions = new SizeF(6f, 13f);
        AutoScaleMode = AutoScaleMode.Font;
        AutoScroll = false;
        Name = "ComponentSettings";
        Size = new Size(476, 492);

        _tabs.Location = new Point(10, 8);
        _tabs.Size = new Size(456, 426);

        _tabMain.Text = "Main Game";
        _tabMain.Padding = new Padding(3);
        _tabMain.UseVisualStyleBackColor = true;

        _tabLara.Text = "Lara's Home";
        _tabLara.Padding = new Padding(3);
        _tabLara.UseVisualStyleBackColor = true;

        _tabs.TabPages.Add(_tabMain);
        _tabs.TabPages.Add(_tabLara);

        _mainLevelsGroup.Location = new Point(6, 6);
        _mainLevelsGroup.Size = new Size(430, 186);
        _mainLevelsGroup.TabStop = false;
        _mainLevelsGroup.Text = "Main Game Level Splits";

        _chkMainSplitLevels.AutoSize = true;
        _chkMainSplitLevels.Location = new Point(6, 20);
        _chkMainSplitLevels.Text = "Enable Main Game Level Splits:";
        _chkMainSplitLevels.UseVisualStyleBackColor = true;
        _chkMainSplitLevels.CheckedChanged += (_, _) =>
        {
            MainSplitLevels = _chkMainSplitLevels.Checked;
            ApplyGroupAvailability();
        };

        _mainLevelList.CheckOnClick = true;
        _mainLevelList.FormattingEnabled = true;
        _mainLevelList.Location = new Point(6, 42);
        _mainLevelList.Size = new Size(414, 114);
        _mainLevelList.BorderStyle = BorderStyle.FixedSingle;
        _mainLevelList.IntegralHeight = false;

        _mainSelectAllButton.Location = new Point(6, 158);
        _mainSelectAllButton.Size = new Size(88, 22);
        _mainSelectAllButton.Text = "Select all";
        _mainSelectAllButton.UseVisualStyleBackColor = true;
        _mainSelectAllButton.Click += (_, _) => SetAllChecked(_mainLevelList, true);

        _mainClearAllButton.Location = new Point(100, 158);
        _mainClearAllButton.Size = new Size(88, 22);
        _mainClearAllButton.Text = "Clear all";
        _mainClearAllButton.UseVisualStyleBackColor = true;
        _mainClearAllButton.Click += (_, _) => SetAllChecked(_mainLevelList, false);

        _mainLevelsGroup.Controls.Add(_chkMainSplitLevels);
        _mainLevelsGroup.Controls.Add(_mainLevelList);
        _mainLevelsGroup.Controls.Add(_mainSelectAllButton);
        _mainLevelsGroup.Controls.Add(_mainClearAllButton);

        _mainItemsGroup.Location = new Point(6, 196);
        _mainItemsGroup.Size = new Size(430, 190);
        _mainItemsGroup.TabStop = false;
        _mainItemsGroup.Text = "Main Game Item Splits";

        _chkMainGameItems.AutoSize = true;
        _chkMainGameItems.Location = new Point(6, 20);
        _chkMainGameItems.Text = "Enable Item / Kill Splits:";
        _chkMainGameItems.UseVisualStyleBackColor = true;
        _chkMainGameItems.CheckedChanged += (_, _) =>
        {
            MainGameItems = _chkMainGameItems.Checked;
            ApplyGroupAvailability();
        };

        _mainAnyItemOnlyRadio.AutoSize = true;
        _mainAnyItemOnlyRadio.Location = new Point(222, 68);
        _mainAnyItemOnlyRadio.Text = "Any Item";
        _mainAnyItemOnlyRadio.UseVisualStyleBackColor = true;
        _mainAnyItemOnlyRadio.CheckedChanged += (_, _) =>
        {
            if (!_mainAnyItemOnlyRadio.Checked)
                return;

            MainGameAnyItemOnlyMode = true;
            ClearMainLevelScopeChecks();
            ApplyGroupAvailability();
            PullModelFromUiCheckboxes();
        };

        _mainDetailedItemsRadio.AutoSize = true;
        _mainDetailedItemsRadio.Location = new Point(6, 44);
        _mainDetailedItemsRadio.Text = "Level Scope:";
        _mainDetailedItemsRadio.UseVisualStyleBackColor = true;
        _mainDetailedItemsRadio.CheckedChanged += (_, _) =>
        {
            if (!_mainDetailedItemsRadio.Checked)
                return;

            MainGameAnyItemOnlyMode = false;
            ApplyGroupAvailability();
            PullModelFromUiCheckboxes();
        };

        const int colL = 6;
        const int colR = 222;
        int row = 68;
        const int rowStep = 22;

        Label mainTotalScopeLabel = new()
        {
            AutoSize = true,
            Location = new Point(colR, 46),
            Text = "Total Scope:"
        };

        WireItemCheck(_chkMainGameDocuments, "Documents", colL, row);
        WireItemCheck(_chkMainGameSecrets, "Global Secrets", colR, row + rowStep);
        row += rowStep;
        WireItemCheck(_chkMainGameGoldenSecrets, "Golden Secrets", colL, row);
        WireItemCheck(_chkMainGameKills, "Total Kills", colR, row + rowStep);
        row += rowStep;
        WireItemCheck(_chkMainGameSecretKeys, "Secret Keys", colL, row);
        row += rowStep;
        WireItemCheck(_chkMainGameRelics, "Relics", colL, row);
        row += rowStep;
        WireItemCheck(_chkMainGameMysterious, "Mysterious Items (Sunken Ruins)", colL, row);

        _mainItemsGroup.Controls.Add(_chkMainGameItems);
        _mainItemsGroup.Controls.Add(_mainAnyItemOnlyRadio);
        _mainItemsGroup.Controls.Add(_mainDetailedItemsRadio);
        _mainItemsGroup.Controls.Add(mainTotalScopeLabel);

        _tabMain.Controls.Add(_mainLevelsGroup);
        _tabMain.Controls.Add(_mainItemsGroup);

        _laraLevelsGroup.Location = new Point(6, 6);
        _laraLevelsGroup.Size = new Size(430, 58);
        _laraLevelsGroup.TabStop = false;
        _laraLevelsGroup.Text = "Lara's Home Level Splits:";

        _chkLarasHomeSplitLevels.AutoSize = true;
        _chkLarasHomeSplitLevels.Location = new Point(6, 24);
        _chkLarasHomeSplitLevels.Text = "Enable Lara's Home Split";
        _chkLarasHomeSplitLevels.UseVisualStyleBackColor = true;
        _chkLarasHomeSplitLevels.CheckedChanged += (_, _) =>
        {
            LarasHomeSplitLevels = _chkLarasHomeSplitLevels.Checked;
            ApplyGroupAvailability();
        };

        _laraLevelsGroup.Controls.Add(_chkLarasHomeSplitLevels);

        _laraItemsGroup.Location = new Point(6, 70);
        _laraItemsGroup.Size = new Size(430, 172);
        _laraItemsGroup.TabStop = false;
        _laraItemsGroup.Text = "Lara's Home Item Splits:";

        _chkMainLarasHomeSplits.AutoSize = true;
        _chkMainLarasHomeSplits.Location = new Point(6, 20);
        _chkMainLarasHomeSplits.Text = "Enable Lara's Home Item Splits:";
        _chkMainLarasHomeSplits.UseVisualStyleBackColor = true;
        _chkMainLarasHomeSplits.CheckedChanged += (_, _) =>
        {
            MainLarasHomeSplits = _chkMainLarasHomeSplits.Checked;
            ApplyGroupAvailability();
        };

        _laraAnyItemOnlyRadio.AutoSize = true;
        _laraAnyItemOnlyRadio.Location = new Point(222, 44);
        _laraAnyItemOnlyRadio.Text = "Any Item";
        _laraAnyItemOnlyRadio.UseVisualStyleBackColor = true;
        _laraAnyItemOnlyRadio.CheckedChanged += (_, _) =>
        {
            if (!_laraAnyItemOnlyRadio.Checked)
                return;

            LarasHomeAnyItemOnlyMode = true;
            ClearLarasHomeItemTypeChecks();
            ApplyGroupAvailability();
            PullModelFromUiCheckboxes();
        };

        _laraDetailedItemsRadio.AutoSize = true;
        _laraDetailedItemsRadio.Location = new Point(6, 44);
        _laraDetailedItemsRadio.Text = "Item Types:";
        _laraDetailedItemsRadio.UseVisualStyleBackColor = true;
        _laraDetailedItemsRadio.CheckedChanged += (_, _) =>
        {
            if (!_laraDetailedItemsRadio.Checked)
                return;

            LarasHomeAnyItemOnlyMode = false;
            ApplyGroupAvailability();
            PullModelFromUiCheckboxes();
        };

        row = 68;
        WireLaraCheck(_chkLaraDoc, "Documents", colL, row);
        row += rowStep;
        WireLaraCheck(_chkLaraMagazine, "Magazines", colL, row);
        row += rowStep;
        WireLaraCheck(_chkLaraPolaroid, "Polaroids", colL, row);
        row += rowStep;
        WireLaraCheck(_chkLaraCrest, "Family Crests", colL, row);

        _laraItemsGroup.Controls.Add(_chkMainLarasHomeSplits);
        _laraItemsGroup.Controls.Add(_laraAnyItemOnlyRadio);
        _laraItemsGroup.Controls.Add(_laraDetailedItemsRadio);

        _tabLara.Controls.Add(_laraLevelsGroup);
        _tabLara.Controls.Add(_laraItemsGroup);

        GameVersionLabel.AutoSize = true;
        GameVersionLabel.Location = new Point(10, 440);
        GameVersionLabel.Text = "Game Version: None / Undetected";

        AutosplitterVersionLabel.AutoSize = true;
        AutosplitterVersionLabel.ForeColor = SystemColors.GrayText;
        AutosplitterVersionLabel.Location = new Point(10, 460);
        AutosplitterVersionLabel.Text = "Autosplitter Version: " + Assembly.GetExecutingAssembly().GetName().Version;

        Controls.Add(_tabs);
        Controls.Add(GameVersionLabel);
        Controls.Add(AutosplitterVersionLabel);

        _laraItemsGroup.ResumeLayout(false);
        _laraItemsGroup.PerformLayout();
        _laraLevelsGroup.ResumeLayout(false);
        _laraLevelsGroup.PerformLayout();
        _mainItemsGroup.ResumeLayout(false);
        _mainItemsGroup.PerformLayout();
        _mainLevelsGroup.ResumeLayout(false);
        _mainLevelsGroup.PerformLayout();
        _tabLara.ResumeLayout(false);
        _tabMain.ResumeLayout(false);
        ResumeLayout(false);
        PerformLayout();
    }

    private static string LevelXmlKey(string chapterId) => "MG_" + chapterId.Replace(".", "_");

    internal void AppendSettingsTo(XmlDocument document, XmlElement settingsNode)
    {
        PullModelFromUiCheckboxes();

        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainSplitLevels), MainSplitLevels));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(LarasHomeSplitLevels), LarasHomeSplitLevels));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameItems), MainGameItems));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainLarasHomeSplits), MainLarasHomeSplits));

        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameAnyItemOnlyMode), MainGameAnyItemOnlyMode));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameAllItemsSplit), MainGameAllItemsSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameSecretKeysSplit), MainGameSecretKeysSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameGoldenSecretsSplit), MainGameGoldenSecretsSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameRelicsSplit), MainGameRelicsSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameDocumentsSplit), MainGameDocumentsSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameSecretsSplit), MainGameSecretsSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameMysteriousSplit), MainGameMysteriousSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(MainGameKillsSplit), MainGameKillsSplit));

        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(LarasHomeAnyItemOnlyMode), LarasHomeAnyItemOnlyMode));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(LarasHomeDocumentSplit), LarasHomeDocumentSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(LarasHomePolaroidSplit), LarasHomePolaroidSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(LarasHomeMagazineSplit), LarasHomeMagazineSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(LarasHomeFamilyCrestSplit), LarasHomeFamilyCrestSplit));
        _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, nameof(LarasHomeAllItemsSplit), LarasHomeAllItemsSplit));

        for (int i = 0; i < TrleRoute.MainGameLevels.Length; i++)
            _ = settingsNode.AppendChild(SettingsHelper.ToElement(document, LevelXmlKey(TrleRoute.MainGameLevels[i].Id), _mainLevelList.GetItemChecked(i)));
    }

    internal void ReadSettingsFrom(XmlNode settings)
    {
        MainSplitLevels = SettingsHelper.ParseBool(settings[nameof(MainSplitLevels)] as XmlElement, MainSplitLevels);
        LarasHomeSplitLevels = SettingsHelper.ParseBool(settings[nameof(LarasHomeSplitLevels)] as XmlElement, LarasHomeSplitLevels);
        MainGameItems = SettingsHelper.ParseBool(settings[nameof(MainGameItems)] as XmlElement, MainGameItems);
        MainLarasHomeSplits = SettingsHelper.ParseBool(settings[nameof(MainLarasHomeSplits)] as XmlElement, MainLarasHomeSplits);

        MainGameAnyItemOnlyMode = SettingsHelper.ParseBool(settings[nameof(MainGameAnyItemOnlyMode)] as XmlElement, MainGameAnyItemOnlyMode);
        MainGameAllItemsSplit = SettingsHelper.ParseBool(settings[nameof(MainGameAllItemsSplit)] as XmlElement, MainGameAllItemsSplit);
        MainGameSecretKeysSplit = SettingsHelper.ParseBool(settings[nameof(MainGameSecretKeysSplit)] as XmlElement, MainGameSecretKeysSplit);
        MainGameGoldenSecretsSplit = SettingsHelper.ParseBool(settings[nameof(MainGameGoldenSecretsSplit)] as XmlElement, MainGameGoldenSecretsSplit);
        MainGameRelicsSplit = SettingsHelper.ParseBool(settings[nameof(MainGameRelicsSplit)] as XmlElement, MainGameRelicsSplit);
        MainGameDocumentsSplit = SettingsHelper.ParseBool(settings[nameof(MainGameDocumentsSplit)] as XmlElement, MainGameDocumentsSplit);
        MainGameSecretsSplit = SettingsHelper.ParseBool(settings[nameof(MainGameSecretsSplit)] as XmlElement, MainGameSecretsSplit);
        MainGameMysteriousSplit = SettingsHelper.ParseBool(settings[nameof(MainGameMysteriousSplit)] as XmlElement, MainGameMysteriousSplit);
        MainGameKillsSplit = SettingsHelper.ParseBool(settings[nameof(MainGameKillsSplit)] as XmlElement, MainGameKillsSplit);

        LarasHomeAnyItemOnlyMode = SettingsHelper.ParseBool(settings[nameof(LarasHomeAnyItemOnlyMode)] as XmlElement, LarasHomeAnyItemOnlyMode);
        LarasHomeDocumentSplit = SettingsHelper.ParseBool(settings[nameof(LarasHomeDocumentSplit)] as XmlElement, LarasHomeDocumentSplit);
        LarasHomePolaroidSplit = SettingsHelper.ParseBool(settings[nameof(LarasHomePolaroidSplit)] as XmlElement, LarasHomePolaroidSplit);
        LarasHomeMagazineSplit = SettingsHelper.ParseBool(settings[nameof(LarasHomeMagazineSplit)] as XmlElement, LarasHomeMagazineSplit);
        LarasHomeFamilyCrestSplit = SettingsHelper.ParseBool(settings[nameof(LarasHomeFamilyCrestSplit)] as XmlElement, LarasHomeFamilyCrestSplit);
        LarasHomeAllItemsSplit = SettingsHelper.ParseBool(settings[nameof(LarasHomeAllItemsSplit)] as XmlElement, LarasHomeAllItemsSplit);

        for (int i = 0; i < TrleRoute.MainGameLevels.Length; i++)
        {
            bool v = SettingsHelper.ParseBool(settings[LevelXmlKey(TrleRoute.MainGameLevels[i].Id)] as XmlElement, true);
            _mainLevelList.SetItemChecked(i, v);
        }

        if (settings[nameof(MainGameAnyItemOnlyMode)] is null)
            MainGameAnyItemOnlyMode = MainGameAllItemsSplit;

        if (settings[nameof(LarasHomeAnyItemOnlyMode)] is null)
            LarasHomeAnyItemOnlyMode = LarasHomeAllItemsSplit;

        // Keep compat flags aligned with new radio modes.
        MainGameAllItemsSplit = MainGameAnyItemOnlyMode;
        LarasHomeAllItemsSplit = LarasHomeAnyItemOnlyMode;

        SyncItemCheckboxesFromModel();
        ApplyGroupAvailability();
    }
}
