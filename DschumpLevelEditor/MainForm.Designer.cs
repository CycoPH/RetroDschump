
namespace DschumpLevelEditor
{
	partial class MainForm
	{
		/// <summary>
		///  Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		///  Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		///  Required method for Designer support - do not modify
		///  the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
			this.splitContainer1 = new System.Windows.Forms.SplitContainer();
			this.picLevel = new System.Windows.Forms.PictureBox();
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.btnShiftDown = new System.Windows.Forms.Button();
			this.picFont = new System.Windows.Forms.PictureBox();
			this.btnShiftUp = new System.Windows.Forms.Button();
			this.lblMessage = new System.Windows.Forms.Label();
			this.btnShiftRight = new System.Windows.Forms.Button();
			this.btnShiftLeft = new System.Windows.Forms.Button();
			this.grpLevel = new System.Windows.Forms.GroupBox();
			this.cmbUpDown = new System.Windows.Forms.ComboBox();
			this.cmbScreenTop = new System.Windows.Forms.ComboBox();
			this.label4 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.cmbStartY = new System.Windows.Forms.ComboBox();
			this.tbLevelHint2 = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.tbLevelHint1 = new System.Windows.Forms.TextBox();
			this.cmbStartX = new System.Windows.Forms.ComboBox();
			this.chkCompress = new System.Windows.Forms.CheckBox();
			this.btnShowBoth = new System.Windows.Forms.Button();
			this.btnShowSwitches = new System.Windows.Forms.Button();
			this.btnShowWormholes = new System.Windows.Forms.Button();
			this.btnValidateLevel = new System.Windows.Forms.Button();
			this.btnRedrawLevel = new System.Windows.Forms.Button();
			this.btnNewLevel = new System.Windows.Forms.Button();
			this.lblLevelNr = new System.Windows.Forms.Label();
			this.numLevelNumber = new System.Windows.Forms.NumericUpDown();
			this.btnExportLevel = new System.Windows.Forms.Button();
			this.btnSaveLevel = new System.Windows.Forms.Button();
			this.btnLoadLevel = new System.Windows.Forms.Button();
			this.lblLevelCursor = new System.Windows.Forms.Label();
			this.lblUnderCursor = new System.Windows.Forms.Label();
			this.lblClipboard = new System.Windows.Forms.Label();
			this.lblPickedChar = new System.Windows.Forms.Label();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.btnExportTiles = new System.Windows.Forms.Button();
			this.btnSaveTiles = new System.Windows.Forms.Button();
			this.btnLoadTiles = new System.Windows.Forms.Button();
			this.picCurrentTile = new System.Windows.Forms.PictureBox();
			this.lblTileChar = new System.Windows.Forms.Label();
			this.chkEditTilesOrLevel = new System.Windows.Forms.CheckBox();
			this.pictureBoxClipboard = new System.Windows.Forms.PictureBox();
			this.picTiles = new System.Windows.Forms.PictureBox();
			this.tabPage2 = new System.Windows.Forms.TabPage();
			this.comboWormholes = new System.Windows.Forms.ComboBox();
			this.label1 = new System.Windows.Forms.Label();
			this.listView_Wormholes = new System.Windows.Forms.ListView();
			this.btnCancelSwitchEdit = new System.Windows.Forms.Button();
			this.lblLvlPickedTile = new System.Windows.Forms.Label();
			this.comboTiles = new System.Windows.Forms.ComboBox();
			this.lblSwitchInfo = new System.Windows.Forms.Label();
			this.listView_Switches = new System.Windows.Forms.ListView();
			this.tabPage3 = new System.Windows.Forms.TabPage();
			this.txtEdit = new System.Windows.Forms.TextBox();
			this.listView_TileNames = new System.Windows.Forms.ListView();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.listView_Colors = new System.Windows.Forms.ListView();
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
			this.splitContainer1.Panel1.SuspendLayout();
			this.splitContainer1.Panel2.SuspendLayout();
			this.splitContainer1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.picLevel)).BeginInit();
			this.tabControl1.SuspendLayout();
			this.tabPage1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.picFont)).BeginInit();
			this.grpLevel.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.numLevelNumber)).BeginInit();
			this.groupBox2.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.picCurrentTile)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxClipboard)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.picTiles)).BeginInit();
			this.tabPage2.SuspendLayout();
			this.tabPage3.SuspendLayout();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// splitContainer1
			// 
			this.splitContainer1.Cursor = System.Windows.Forms.Cursors.Default;
			this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.splitContainer1.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
			this.splitContainer1.IsSplitterFixed = true;
			this.splitContainer1.Location = new System.Drawing.Point(0, 0);
			this.splitContainer1.Name = "splitContainer1";
			// 
			// splitContainer1.Panel1
			// 
			this.splitContainer1.Panel1.Controls.Add(this.picLevel);
			this.splitContainer1.Panel1MinSize = 256;
			// 
			// splitContainer1.Panel2
			// 
			this.splitContainer1.Panel2.Controls.Add(this.tabControl1);
			this.splitContainer1.Panel2MinSize = 100;
			this.splitContainer1.Size = new System.Drawing.Size(816, 1011);
			this.splitContainer1.SplitterDistance = 275;
			this.splitContainer1.TabIndex = 0;
			// 
			// picLevel
			// 
			this.picLevel.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
			this.picLevel.Dock = System.Windows.Forms.DockStyle.Left;
			this.picLevel.Location = new System.Drawing.Point(0, 0);
			this.picLevel.MaximumSize = new System.Drawing.Size(224, 1008);
			this.picLevel.MinimumSize = new System.Drawing.Size(224, 1008);
			this.picLevel.Name = "picLevel";
			this.picLevel.Size = new System.Drawing.Size(224, 1008);
			this.picLevel.TabIndex = 0;
			this.picLevel.TabStop = false;
			this.picLevel.MouseLeave += new System.EventHandler(this.picLevel_MouseLeave);
			this.picLevel.MouseMove += new System.Windows.Forms.MouseEventHandler(this.picLevel_MouseMove);
			this.picLevel.MouseUp += new System.Windows.Forms.MouseEventHandler(this.picLevel_MouseUp);
			this.picLevel.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.picLevel_MouseWheel);
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.Add(this.tabPage1);
			this.tabControl1.Controls.Add(this.tabPage2);
			this.tabControl1.Controls.Add(this.tabPage3);
			this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.tabControl1.Location = new System.Drawing.Point(0, 0);
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(537, 1011);
			this.tabControl1.TabIndex = 0;
			this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.Add(this.btnShiftDown);
			this.tabPage1.Controls.Add(this.picFont);
			this.tabPage1.Controls.Add(this.btnShiftUp);
			this.tabPage1.Controls.Add(this.lblMessage);
			this.tabPage1.Controls.Add(this.btnShiftRight);
			this.tabPage1.Controls.Add(this.btnShiftLeft);
			this.tabPage1.Controls.Add(this.grpLevel);
			this.tabPage1.Controls.Add(this.lblLevelCursor);
			this.tabPage1.Controls.Add(this.lblUnderCursor);
			this.tabPage1.Controls.Add(this.lblClipboard);
			this.tabPage1.Controls.Add(this.lblPickedChar);
			this.tabPage1.Controls.Add(this.groupBox2);
			this.tabPage1.Controls.Add(this.picCurrentTile);
			this.tabPage1.Controls.Add(this.lblTileChar);
			this.tabPage1.Controls.Add(this.chkEditTilesOrLevel);
			this.tabPage1.Controls.Add(this.pictureBoxClipboard);
			this.tabPage1.Controls.Add(this.picTiles);
			this.tabPage1.Cursor = System.Windows.Forms.Cursors.Default;
			this.tabPage1.Location = new System.Drawing.Point(4, 24);
			this.tabPage1.Name = "tabPage1";
			this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage1.Size = new System.Drawing.Size(529, 983);
			this.tabPage1.TabIndex = 0;
			this.tabPage1.Text = "Tiles";
			this.tabPage1.UseVisualStyleBackColor = true;
			// 
			// btnShiftDown
			// 
			this.btnShiftDown.Location = new System.Drawing.Point(414, 592);
			this.btnShiftDown.Name = "btnShiftDown";
			this.btnShiftDown.Size = new System.Drawing.Size(34, 25);
			this.btnShiftDown.TabIndex = 17;
			this.btnShiftDown.Text = "▼";
			this.btnShiftDown.UseVisualStyleBackColor = true;
			this.btnShiftDown.Click += new System.EventHandler(this.btnShiftDown_Click);
			// 
			// picFont
			// 
			this.picFont.BackColor = System.Drawing.Color.DimGray;
			this.picFont.Location = new System.Drawing.Point(4, 655);
			this.picFont.Name = "picFont";
			this.picFont.Size = new System.Drawing.Size(257, 256);
			this.picFont.TabIndex = 1;
			this.picFont.TabStop = false;
			this.picFont.MouseDown += new System.Windows.Forms.MouseEventHandler(this.picFont_MouseDown);
			this.picFont.MouseLeave += new System.EventHandler(this.picFont_MouseLeave);
			this.picFont.MouseMove += new System.Windows.Forms.MouseEventHandler(this.picFont_MouseMove);
			this.picFont.MouseUp += new System.Windows.Forms.MouseEventHandler(this.picFont_MouseUp);
			this.picFont.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.picFont_MouseWheel);
			// 
			// btnShiftUp
			// 
			this.btnShiftUp.Location = new System.Drawing.Point(414, 569);
			this.btnShiftUp.Name = "btnShiftUp";
			this.btnShiftUp.Size = new System.Drawing.Size(34, 25);
			this.btnShiftUp.TabIndex = 16;
			this.btnShiftUp.Text = "▲";
			this.btnShiftUp.UseVisualStyleBackColor = true;
			this.btnShiftUp.Click += new System.EventHandler(this.btnShiftUp_Click);
			// 
			// lblMessage
			// 
			this.lblMessage.Location = new System.Drawing.Point(73, 422);
			this.lblMessage.Name = "lblMessage";
			this.lblMessage.Size = new System.Drawing.Size(437, 15);
			this.lblMessage.TabIndex = 18;
			this.lblMessage.Text = "Msg:";
			this.lblMessage.UseMnemonic = false;
			// 
			// btnShiftRight
			// 
			this.btnShiftRight.Location = new System.Drawing.Point(448, 571);
			this.btnShiftRight.Name = "btnShiftRight";
			this.btnShiftRight.Size = new System.Drawing.Size(25, 45);
			this.btnShiftRight.TabIndex = 15;
			this.btnShiftRight.Text = "▶";
			this.btnShiftRight.UseVisualStyleBackColor = true;
			this.btnShiftRight.Click += new System.EventHandler(this.btnShiftRight_Click);
			// 
			// btnShiftLeft
			// 
			this.btnShiftLeft.Location = new System.Drawing.Point(389, 571);
			this.btnShiftLeft.Name = "btnShiftLeft";
			this.btnShiftLeft.Size = new System.Drawing.Size(25, 45);
			this.btnShiftLeft.TabIndex = 14;
			this.btnShiftLeft.Text = "◀";
			this.btnShiftLeft.UseVisualStyleBackColor = true;
			this.btnShiftLeft.Click += new System.EventHandler(this.btnShiftLeft_Click);
			// 
			// grpLevel
			// 
			this.grpLevel.Controls.Add(this.cmbUpDown);
			this.grpLevel.Controls.Add(this.cmbScreenTop);
			this.grpLevel.Controls.Add(this.label4);
			this.grpLevel.Controls.Add(this.label3);
			this.grpLevel.Controls.Add(this.cmbStartY);
			this.grpLevel.Controls.Add(this.tbLevelHint2);
			this.grpLevel.Controls.Add(this.label2);
			this.grpLevel.Controls.Add(this.tbLevelHint1);
			this.grpLevel.Controls.Add(this.cmbStartX);
			this.grpLevel.Controls.Add(this.chkCompress);
			this.grpLevel.Controls.Add(this.btnShowBoth);
			this.grpLevel.Controls.Add(this.btnShowSwitches);
			this.grpLevel.Controls.Add(this.btnShowWormholes);
			this.grpLevel.Controls.Add(this.btnValidateLevel);
			this.grpLevel.Controls.Add(this.btnRedrawLevel);
			this.grpLevel.Controls.Add(this.btnNewLevel);
			this.grpLevel.Controls.Add(this.lblLevelNr);
			this.grpLevel.Controls.Add(this.numLevelNumber);
			this.grpLevel.Controls.Add(this.btnExportLevel);
			this.grpLevel.Controls.Add(this.btnSaveLevel);
			this.grpLevel.Controls.Add(this.btnLoadLevel);
			this.grpLevel.Location = new System.Drawing.Point(7, 442);
			this.grpLevel.Name = "grpLevel";
			this.grpLevel.Size = new System.Drawing.Size(335, 195);
			this.grpLevel.TabIndex = 17;
			this.grpLevel.TabStop = false;
			this.grpLevel.Text = "Level:";
			// 
			// cmbUpDown
			// 
			this.cmbUpDown.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbUpDown.FormattingEnabled = true;
			this.cmbUpDown.Items.AddRange(new object[] {
            "Up",
            "Down"});
			this.cmbUpDown.Location = new System.Drawing.Point(123, 101);
			this.cmbUpDown.MaxDropDownItems = 7;
			this.cmbUpDown.MaxLength = 1;
			this.cmbUpDown.Name = "cmbUpDown";
			this.cmbUpDown.Size = new System.Drawing.Size(69, 23);
			this.cmbUpDown.TabIndex = 25;
			this.cmbUpDown.SelectedIndexChanged += new System.EventHandler(this.cmbUpDown_SelectedIndexChanged);
			// 
			// cmbScreenTop
			// 
			this.cmbScreenTop.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbScreenTop.FormattingEnabled = true;
			this.cmbScreenTop.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20",
            "21",
            "22",
            "23",
            "24",
            "25",
            "26",
            "27",
            "28",
            "29",
            "30",
            "31",
            "32",
            "33",
            "34",
            "35"});
			this.cmbScreenTop.Location = new System.Drawing.Point(47, 101);
			this.cmbScreenTop.MaxDropDownItems = 7;
			this.cmbScreenTop.MaxLength = 1;
			this.cmbScreenTop.Name = "cmbScreenTop";
			this.cmbScreenTop.Size = new System.Drawing.Size(69, 23);
			this.cmbScreenTop.TabIndex = 24;
			this.cmbScreenTop.SelectedIndexChanged += new System.EventHandler(this.cmbScreenTop_SelectedIndexChanged);
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(7, 101);
			this.label4.Margin = new System.Windows.Forms.Padding(3, 0, 0, 0);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(37, 23);
			this.label4.TabIndex = 23;
			this.label4.Text = "Start";
			this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.label4.UseMnemonic = false;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(63, 129);
			this.label3.Margin = new System.Windows.Forms.Padding(0);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(18, 23);
			this.label3.TabIndex = 22;
			this.label3.Text = "Y:";
			this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.label3.UseMnemonic = false;
			// 
			// cmbStartY
			// 
			this.cmbStartY.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbStartY.FormattingEnabled = true;
			this.cmbStartY.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "-3-",
            "4",
            "5",
            "6"});
			this.cmbStartY.Location = new System.Drawing.Point(83, 129);
			this.cmbStartY.MaxDropDownItems = 7;
			this.cmbStartY.MaxLength = 1;
			this.cmbStartY.Name = "cmbStartY";
			this.cmbStartY.Size = new System.Drawing.Size(33, 23);
			this.cmbStartY.TabIndex = 21;
			this.cmbStartY.SelectedIndexChanged += new System.EventHandler(this.cmbStartY_SelectedIndexChanged);
			// 
			// tbLevelHint2
			// 
			this.tbLevelHint2.BackColor = System.Drawing.Color.Khaki;
			this.tbLevelHint2.BorderStyle = System.Windows.Forms.BorderStyle.None;
			this.tbLevelHint2.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
			this.tbLevelHint2.Location = new System.Drawing.Point(6, 174);
			this.tbLevelHint2.Margin = new System.Windows.Forms.Padding(0);
			this.tbLevelHint2.MaxLength = 32;
			this.tbLevelHint2.Name = "tbLevelHint2";
			this.tbLevelHint2.Size = new System.Drawing.Size(230, 15);
			this.tbLevelHint2.TabIndex = 20;
			this.tbLevelHint2.WordWrap = false;
			this.tbLevelHint2.TextChanged += new System.EventHandler(this.tbLevelHint2_TextChanged);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(7, 129);
			this.label2.Margin = new System.Windows.Forms.Padding(3, 0, 0, 0);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(19, 23);
			this.label2.TabIndex = 19;
			this.label2.Text = "X:";
			this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.label2.UseMnemonic = false;
			// 
			// tbLevelHint1
			// 
			this.tbLevelHint1.BackColor = System.Drawing.Color.Khaki;
			this.tbLevelHint1.BorderStyle = System.Windows.Forms.BorderStyle.None;
			this.tbLevelHint1.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
			this.tbLevelHint1.Location = new System.Drawing.Point(6, 157);
			this.tbLevelHint1.Margin = new System.Windows.Forms.Padding(0);
			this.tbLevelHint1.MaxLength = 32;
			this.tbLevelHint1.Name = "tbLevelHint1";
			this.tbLevelHint1.Size = new System.Drawing.Size(230, 15);
			this.tbLevelHint1.TabIndex = 19;
			this.tbLevelHint1.WordWrap = false;
			this.tbLevelHint1.TextChanged += new System.EventHandler(this.tbLevelHint1_TextChanged);
			// 
			// cmbStartX
			// 
			this.cmbStartX.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbStartX.FormattingEnabled = true;
			this.cmbStartX.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6"});
			this.cmbStartX.Location = new System.Drawing.Point(27, 129);
			this.cmbStartX.MaxDropDownItems = 7;
			this.cmbStartX.MaxLength = 1;
			this.cmbStartX.Name = "cmbStartX";
			this.cmbStartX.Size = new System.Drawing.Size(33, 23);
			this.cmbStartX.Sorted = true;
			this.cmbStartX.TabIndex = 18;
			this.cmbStartX.SelectedIndexChanged += new System.EventHandler(this.cmbStartX_SelectedIndexChanged);
			// 
			// chkCompress
			// 
			this.chkCompress.AutoSize = true;
			this.chkCompress.Checked = true;
			this.chkCompress.CheckState = System.Windows.Forms.CheckState.Checked;
			this.chkCompress.Location = new System.Drawing.Point(87, 77);
			this.chkCompress.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
			this.chkCompress.Name = "chkCompress";
			this.chkCompress.Size = new System.Drawing.Size(79, 19);
			this.chkCompress.TabIndex = 13;
			this.chkCompress.Text = "Compress";
			this.chkCompress.UseVisualStyleBackColor = true;
			// 
			// btnShowBoth
			// 
			this.btnShowBoth.Location = new System.Drawing.Point(204, 103);
			this.btnShowBoth.Name = "btnShowBoth";
			this.btnShowBoth.Size = new System.Drawing.Size(126, 23);
			this.btnShowBoth.TabIndex = 12;
			this.btnShowBoth.Text = "Show All";
			this.btnShowBoth.UseVisualStyleBackColor = true;
			this.btnShowBoth.Click += new System.EventHandler(this.btnShowBoth_Click);
			// 
			// btnShowSwitches
			// 
			this.btnShowSwitches.Location = new System.Drawing.Point(204, 74);
			this.btnShowSwitches.Name = "btnShowSwitches";
			this.btnShowSwitches.Size = new System.Drawing.Size(64, 23);
			this.btnShowSwitches.TabIndex = 11;
			this.btnShowSwitches.Text = "Switches";
			this.btnShowSwitches.UseVisualStyleBackColor = true;
			this.btnShowSwitches.Click += new System.EventHandler(this.btnShowSwitches_Click);
			// 
			// btnShowWormholes
			// 
			this.btnShowWormholes.Location = new System.Drawing.Point(269, 74);
			this.btnShowWormholes.Name = "btnShowWormholes";
			this.btnShowWormholes.Size = new System.Drawing.Size(61, 23);
			this.btnShowWormholes.TabIndex = 10;
			this.btnShowWormholes.Text = "Warps";
			this.btnShowWormholes.UseVisualStyleBackColor = true;
			this.btnShowWormholes.Click += new System.EventHandler(this.btnShowWormholes_Click);
			// 
			// btnValidateLevel
			// 
			this.btnValidateLevel.Location = new System.Drawing.Point(204, 45);
			this.btnValidateLevel.Name = "btnValidateLevel";
			this.btnValidateLevel.Size = new System.Drawing.Size(126, 23);
			this.btnValidateLevel.TabIndex = 7;
			this.btnValidateLevel.Text = "Validate";
			this.btnValidateLevel.UseVisualStyleBackColor = true;
			this.btnValidateLevel.Click += new System.EventHandler(this.btnValidateLevel_Click);
			// 
			// btnRedrawLevel
			// 
			this.btnRedrawLevel.Location = new System.Drawing.Point(204, 16);
			this.btnRedrawLevel.Name = "btnRedrawLevel";
			this.btnRedrawLevel.Size = new System.Drawing.Size(126, 23);
			this.btnRedrawLevel.TabIndex = 6;
			this.btnRedrawLevel.Text = "Refresh/Redraw";
			this.btnRedrawLevel.UseVisualStyleBackColor = true;
			this.btnRedrawLevel.Click += new System.EventHandler(this.btnRedrawLevel_Click);
			// 
			// btnNewLevel
			// 
			this.btnNewLevel.Location = new System.Drawing.Point(254, 136);
			this.btnNewLevel.Name = "btnNewLevel";
			this.btnNewLevel.Size = new System.Drawing.Size(75, 23);
			this.btnNewLevel.TabIndex = 5;
			this.btnNewLevel.Text = "New";
			this.btnNewLevel.UseVisualStyleBackColor = true;
			this.btnNewLevel.Click += new System.EventHandler(this.btnNewLevel_Click);
			// 
			// lblLevelNr
			// 
			this.lblLevelNr.Location = new System.Drawing.Point(88, 16);
			this.lblLevelNr.Name = "lblLevelNr";
			this.lblLevelNr.Size = new System.Drawing.Size(104, 23);
			this.lblLevelNr.TabIndex = 4;
			this.lblLevelNr.Text = "Loaded ...";
			this.lblLevelNr.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.lblLevelNr.UseMnemonic = false;
			// 
			// numLevelNumber
			// 
			this.numLevelNumber.Location = new System.Drawing.Point(87, 45);
			this.numLevelNumber.Name = "numLevelNumber";
			this.numLevelNumber.Size = new System.Drawing.Size(75, 23);
			this.numLevelNumber.TabIndex = 3;
			this.numLevelNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			this.numLevelNumber.ValueChanged += new System.EventHandler(this.numLevelNumber_ValueChanged);
			// 
			// btnExportLevel
			// 
			this.btnExportLevel.Location = new System.Drawing.Point(6, 74);
			this.btnExportLevel.Name = "btnExportLevel";
			this.btnExportLevel.Size = new System.Drawing.Size(75, 23);
			this.btnExportLevel.TabIndex = 2;
			this.btnExportLevel.Text = "Export";
			this.btnExportLevel.UseVisualStyleBackColor = true;
			this.btnExportLevel.Click += new System.EventHandler(this.btnExportLevel_Click);
			// 
			// btnSaveLevel
			// 
			this.btnSaveLevel.Location = new System.Drawing.Point(6, 45);
			this.btnSaveLevel.Name = "btnSaveLevel";
			this.btnSaveLevel.Size = new System.Drawing.Size(75, 23);
			this.btnSaveLevel.TabIndex = 1;
			this.btnSaveLevel.Text = "Save";
			this.btnSaveLevel.UseVisualStyleBackColor = true;
			this.btnSaveLevel.Click += new System.EventHandler(this.btnSaveLevel_Click);
			// 
			// btnLoadLevel
			// 
			this.btnLoadLevel.Location = new System.Drawing.Point(6, 16);
			this.btnLoadLevel.Name = "btnLoadLevel";
			this.btnLoadLevel.Size = new System.Drawing.Size(75, 23);
			this.btnLoadLevel.TabIndex = 0;
			this.btnLoadLevel.Text = "Load";
			this.btnLoadLevel.UseVisualStyleBackColor = true;
			this.btnLoadLevel.Click += new System.EventHandler(this.btnLoadLevel_Click);
			// 
			// lblLevelCursor
			// 
			this.lblLevelCursor.Location = new System.Drawing.Point(73, 406);
			this.lblLevelCursor.Name = "lblLevelCursor";
			this.lblLevelCursor.Size = new System.Drawing.Size(437, 15);
			this.lblLevelCursor.TabIndex = 16;
			this.lblLevelCursor.Text = "Cursor:";
			this.lblLevelCursor.UseMnemonic = false;
			// 
			// lblUnderCursor
			// 
			this.lblUnderCursor.Location = new System.Drawing.Point(135, 640);
			this.lblUnderCursor.Name = "lblUnderCursor";
			this.lblUnderCursor.Size = new System.Drawing.Size(125, 15);
			this.lblUnderCursor.TabIndex = 15;
			this.lblUnderCursor.Text = "Cursor:";
			this.lblUnderCursor.UseMnemonic = false;
			// 
			// lblClipboard
			// 
			this.lblClipboard.Location = new System.Drawing.Point(268, 640);
			this.lblClipboard.Name = "lblClipboard";
			this.lblClipboard.Size = new System.Drawing.Size(256, 15);
			this.lblClipboard.TabIndex = 14;
			this.lblClipboard.Text = "Clipboard";
			this.lblClipboard.UseMnemonic = false;
			// 
			// lblPickedChar
			// 
			this.lblPickedChar.Location = new System.Drawing.Point(4, 640);
			this.lblPickedChar.Name = "lblPickedChar";
			this.lblPickedChar.Size = new System.Drawing.Size(125, 15);
			this.lblPickedChar.TabIndex = 13;
			this.lblPickedChar.Text = "Picked:";
			this.lblPickedChar.UseMnemonic = false;
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.btnExportTiles);
			this.groupBox2.Controls.Add(this.btnSaveTiles);
			this.groupBox2.Controls.Add(this.btnLoadTiles);
			this.groupBox2.Location = new System.Drawing.Point(348, 442);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(167, 79);
			this.groupBox2.TabIndex = 12;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Tiles";
			// 
			// btnExportTiles
			// 
			this.btnExportTiles.Location = new System.Drawing.Point(6, 47);
			this.btnExportTiles.Name = "btnExportTiles";
			this.btnExportTiles.Size = new System.Drawing.Size(155, 23);
			this.btnExportTiles.TabIndex = 14;
			this.btnExportTiles.Text = "Export";
			this.btnExportTiles.UseVisualStyleBackColor = true;
			this.btnExportTiles.Click += new System.EventHandler(this.btnExportTiles_Click);
			// 
			// btnSaveTiles
			// 
			this.btnSaveTiles.Location = new System.Drawing.Point(87, 18);
			this.btnSaveTiles.Name = "btnSaveTiles";
			this.btnSaveTiles.Size = new System.Drawing.Size(75, 23);
			this.btnSaveTiles.TabIndex = 13;
			this.btnSaveTiles.Text = "Save";
			this.btnSaveTiles.UseVisualStyleBackColor = true;
			this.btnSaveTiles.Click += new System.EventHandler(this.btnSaveTiles_Click);
			// 
			// btnLoadTiles
			// 
			this.btnLoadTiles.Location = new System.Drawing.Point(6, 18);
			this.btnLoadTiles.Name = "btnLoadTiles";
			this.btnLoadTiles.Size = new System.Drawing.Size(75, 23);
			this.btnLoadTiles.TabIndex = 12;
			this.btnLoadTiles.Text = "Load";
			this.btnLoadTiles.UseVisualStyleBackColor = true;
			this.btnLoadTiles.Click += new System.EventHandler(this.btnLoadTiles_Click);
			// 
			// picCurrentTile
			// 
			this.picCurrentTile.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.picCurrentTile.Location = new System.Drawing.Point(3, 390);
			this.picCurrentTile.Name = "picCurrentTile";
			this.picCurrentTile.Size = new System.Drawing.Size(64, 48);
			this.picCurrentTile.TabIndex = 9;
			this.picCurrentTile.TabStop = false;
			// 
			// lblTileChar
			// 
			this.lblTileChar.Location = new System.Drawing.Point(73, 390);
			this.lblTileChar.Name = "lblTileChar";
			this.lblTileChar.Size = new System.Drawing.Size(437, 15);
			this.lblTileChar.TabIndex = 6;
			this.lblTileChar.Text = "Picked Char -";
			this.lblTileChar.UseMnemonic = false;
			// 
			// chkEditTilesOrLevel
			// 
			this.chkEditTilesOrLevel.Appearance = System.Windows.Forms.Appearance.Button;
			this.chkEditTilesOrLevel.Checked = true;
			this.chkEditTilesOrLevel.CheckState = System.Windows.Forms.CheckState.Checked;
			this.chkEditTilesOrLevel.Location = new System.Drawing.Point(354, 527);
			this.chkEditTilesOrLevel.Name = "chkEditTilesOrLevel";
			this.chkEditTilesOrLevel.Size = new System.Drawing.Size(161, 25);
			this.chkEditTilesOrLevel.TabIndex = 5;
			this.chkEditTilesOrLevel.Text = "Edit ...";
			this.chkEditTilesOrLevel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.chkEditTilesOrLevel.UseMnemonic = false;
			this.chkEditTilesOrLevel.UseVisualStyleBackColor = true;
			this.chkEditTilesOrLevel.CheckedChanged += new System.EventHandler(this.chkEditTilesOrLevel_CheckedChanged);
			// 
			// pictureBoxClipboard
			// 
			this.pictureBoxClipboard.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.pictureBoxClipboard.Location = new System.Drawing.Point(267, 655);
			this.pictureBoxClipboard.Name = "pictureBoxClipboard";
			this.pictureBoxClipboard.Size = new System.Drawing.Size(256, 256);
			this.pictureBoxClipboard.TabIndex = 2;
			this.pictureBoxClipboard.TabStop = false;
			// 
			// picTiles
			// 
			this.picTiles.BackColor = System.Drawing.Color.DimGray;
			this.picTiles.Cursor = System.Windows.Forms.Cursors.Default;
			this.picTiles.Location = new System.Drawing.Point(3, 3);
			this.picTiles.Name = "picTiles";
			this.picTiles.Size = new System.Drawing.Size(512, 384);
			this.picTiles.TabIndex = 0;
			this.picTiles.TabStop = false;
			this.picTiles.MouseDown += new System.Windows.Forms.MouseEventHandler(this.picTiles_MouseDown);
			this.picTiles.MouseMove += new System.Windows.Forms.MouseEventHandler(this.picTiles_MouseMove);
			this.picTiles.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.picTiles_MouseWheel);
			// 
			// tabPage2
			// 
			this.tabPage2.Controls.Add(this.comboWormholes);
			this.tabPage2.Controls.Add(this.label1);
			this.tabPage2.Controls.Add(this.listView_Wormholes);
			this.tabPage2.Controls.Add(this.btnCancelSwitchEdit);
			this.tabPage2.Controls.Add(this.lblLvlPickedTile);
			this.tabPage2.Controls.Add(this.comboTiles);
			this.tabPage2.Controls.Add(this.lblSwitchInfo);
			this.tabPage2.Controls.Add(this.listView_Switches);
			this.tabPage2.Location = new System.Drawing.Point(4, 24);
			this.tabPage2.Name = "tabPage2";
			this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage2.Size = new System.Drawing.Size(529, 983);
			this.tabPage2.TabIndex = 1;
			this.tabPage2.Text = "Switches/Wormholes";
			this.tabPage2.UseVisualStyleBackColor = true;
			// 
			// comboWormholes
			// 
			this.comboWormholes.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.comboWormholes.Location = new System.Drawing.Point(274, 349);
			this.comboWormholes.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
			this.comboWormholes.MaxDropDownItems = 16;
			this.comboWormholes.Name = "comboWormholes";
			this.comboWormholes.Size = new System.Drawing.Size(133, 23);
			this.comboWormholes.TabIndex = 24;
			this.comboWormholes.Visible = false;
			this.comboWormholes.DropDown += new System.EventHandler(this.comboWormholes_DropDown);
			this.comboWormholes.DropDownClosed += new System.EventHandler(this.comboWormholes_DropDownClosed);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(0, 355);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(94, 15);
			this.label1.TabIndex = 23;
			this.label1.Text = "Worm holes:";
			this.label1.UseMnemonic = false;
			// 
			// listView_Wormholes
			// 
			this.listView_Wormholes.AutoArrange = false;
			this.listView_Wormholes.FullRowSelect = true;
			this.listView_Wormholes.GridLines = true;
			this.listView_Wormholes.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
			this.listView_Wormholes.Location = new System.Drawing.Point(0, 373);
			this.listView_Wormholes.MultiSelect = false;
			this.listView_Wormholes.Name = "listView_Wormholes";
			this.listView_Wormholes.Size = new System.Drawing.Size(530, 189);
			this.listView_Wormholes.TabIndex = 22;
			this.listView_Wormholes.UseCompatibleStateImageBehavior = false;
			this.listView_Wormholes.View = System.Windows.Forms.View.Details;
			this.listView_Wormholes.ColumnWidthChanging += new System.Windows.Forms.ColumnWidthChangingEventHandler(this.listView_Wormholes_ColumnWidthChanging);
			this.listView_Wormholes.SelectedIndexChanged += new System.EventHandler(this.listView_Wormholes_SelectedIndexChanged);
			this.listView_Wormholes.MouseDown += new System.Windows.Forms.MouseEventHandler(this.listView_Wormholes_MouseDown);
			this.listView_Wormholes.MouseUp += new System.Windows.Forms.MouseEventHandler(this.listView_Wormholes_MouseUp);
			this.listView_Wormholes.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.listView_Wormholes_MouseWheel);
			// 
			// btnCancelSwitchEdit
			// 
			this.btnCancelSwitchEdit.Location = new System.Drawing.Point(193, 603);
			this.btnCancelSwitchEdit.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
			this.btnCancelSwitchEdit.Name = "btnCancelSwitchEdit";
			this.btnCancelSwitchEdit.Size = new System.Drawing.Size(125, 22);
			this.btnCancelSwitchEdit.TabIndex = 21;
			this.btnCancelSwitchEdit.Text = "Cancel Switch Edit";
			this.btnCancelSwitchEdit.UseVisualStyleBackColor = true;
			this.btnCancelSwitchEdit.Visible = false;
			this.btnCancelSwitchEdit.Click += new System.EventHandler(this.btnCancelSwitchEdit_Click);
			// 
			// lblLvlPickedTile
			// 
			this.lblLvlPickedTile.Location = new System.Drawing.Point(3, 333);
			this.lblLvlPickedTile.Name = "lblLvlPickedTile";
			this.lblLvlPickedTile.Size = new System.Drawing.Size(387, 15);
			this.lblLvlPickedTile.TabIndex = 20;
			this.lblLvlPickedTile.Text = "Picked Tile -";
			this.lblLvlPickedTile.UseMnemonic = false;
			// 
			// comboTiles
			// 
			this.comboTiles.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.comboTiles.Location = new System.Drawing.Point(425, -2);
			this.comboTiles.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
			this.comboTiles.MaxDropDownItems = 16;
			this.comboTiles.Name = "comboTiles";
			this.comboTiles.Size = new System.Drawing.Size(133, 23);
			this.comboTiles.TabIndex = 19;
			this.comboTiles.Visible = false;
			this.comboTiles.DropDownClosed += new System.EventHandler(this.comboTiles_DropDownClosed);
			// 
			// lblSwitchInfo
			// 
			this.lblSwitchInfo.Location = new System.Drawing.Point(0, 0);
			this.lblSwitchInfo.Name = "lblSwitchInfo";
			this.lblSwitchInfo.Size = new System.Drawing.Size(94, 15);
			this.lblSwitchInfo.TabIndex = 17;
			this.lblSwitchInfo.Text = "Switches:";
			this.lblSwitchInfo.UseMnemonic = false;
			// 
			// listView_Switches
			// 
			this.listView_Switches.AutoArrange = false;
			this.listView_Switches.FullRowSelect = true;
			this.listView_Switches.GridLines = true;
			this.listView_Switches.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
			this.listView_Switches.Location = new System.Drawing.Point(0, 18);
			this.listView_Switches.MultiSelect = false;
			this.listView_Switches.Name = "listView_Switches";
			this.listView_Switches.Size = new System.Drawing.Size(533, 313);
			this.listView_Switches.TabIndex = 2;
			this.listView_Switches.UseCompatibleStateImageBehavior = false;
			this.listView_Switches.View = System.Windows.Forms.View.Details;
			this.listView_Switches.ColumnWidthChanging += new System.Windows.Forms.ColumnWidthChangingEventHandler(this.listView_Switches_ColumnWidthChanging);
			this.listView_Switches.SelectedIndexChanged += new System.EventHandler(this.listView_Switches_SelectedIndexChanged);
			this.listView_Switches.MouseDown += new System.Windows.Forms.MouseEventHandler(this.listView_Switches_MouseDown);
			this.listView_Switches.MouseUp += new System.Windows.Forms.MouseEventHandler(this.listView_Switches_MouseUp);
			this.listView_Switches.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.listView_Switches_MouseWheel);
			// 
			// tabPage3
			// 
			this.tabPage3.Controls.Add(this.txtEdit);
			this.tabPage3.Controls.Add(this.listView_TileNames);
			this.tabPage3.Controls.Add(this.groupBox1);
			this.tabPage3.Location = new System.Drawing.Point(4, 24);
			this.tabPage3.Name = "tabPage3";
			this.tabPage3.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage3.Size = new System.Drawing.Size(529, 983);
			this.tabPage3.TabIndex = 2;
			this.tabPage3.Text = "Settings";
			this.tabPage3.UseVisualStyleBackColor = true;
			// 
			// txtEdit
			// 
			this.txtEdit.Location = new System.Drawing.Point(283, 46);
			this.txtEdit.Name = "txtEdit";
			this.txtEdit.Size = new System.Drawing.Size(100, 23);
			this.txtEdit.TabIndex = 2;
			this.txtEdit.TabStop = false;
			this.txtEdit.Visible = false;
			this.txtEdit.WordWrap = false;
			this.txtEdit.KeyUp += new System.Windows.Forms.KeyEventHandler(this.txtEdit_KeyUp);
			this.txtEdit.Leave += new System.EventHandler(this.txtEdit_Leave);
			// 
			// listView_TileNames
			// 
			this.listView_TileNames.AutoArrange = false;
			this.listView_TileNames.CheckBoxes = true;
			this.listView_TileNames.FullRowSelect = true;
			this.listView_TileNames.GridLines = true;
			this.listView_TileNames.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
			this.listView_TileNames.Location = new System.Drawing.Point(10, 178);
			this.listView_TileNames.MultiSelect = false;
			this.listView_TileNames.Name = "listView_TileNames";
			this.listView_TileNames.Size = new System.Drawing.Size(511, 755);
			this.listView_TileNames.TabIndex = 1;
			this.listView_TileNames.UseCompatibleStateImageBehavior = false;
			this.listView_TileNames.View = System.Windows.Forms.View.Details;
			this.listView_TileNames.ColumnWidthChanging += new System.Windows.Forms.ColumnWidthChangingEventHandler(this.listView_TileNames_ColumnWidthChanging);
			this.listView_TileNames.ItemChecked += new System.Windows.Forms.ItemCheckedEventHandler(this.listView_TileNames_ItemChecked);
			this.listView_TileNames.MouseDown += new System.Windows.Forms.MouseEventHandler(this.listView_TileNames_MouseDown);
			this.listView_TileNames.MouseUp += new System.Windows.Forms.MouseEventHandler(this.listView_TileNames_MouseUp);
			this.listView_TileNames.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.listView_MouseWheel);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.listView_Colors);
			this.groupBox1.Location = new System.Drawing.Point(3, 3);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(210, 169);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Colors";
			// 
			// listView_Colors
			// 
			this.listView_Colors.AutoArrange = false;
			this.listView_Colors.FullRowSelect = true;
			this.listView_Colors.GridLines = true;
			this.listView_Colors.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
			this.listView_Colors.Location = new System.Drawing.Point(7, 23);
			this.listView_Colors.MultiSelect = false;
			this.listView_Colors.Name = "listView_Colors";
			this.listView_Colors.Scrollable = false;
			this.listView_Colors.Size = new System.Drawing.Size(195, 137);
			this.listView_Colors.TabIndex = 0;
			this.listView_Colors.UseCompatibleStateImageBehavior = false;
			this.listView_Colors.View = System.Windows.Forms.View.Details;
			this.listView_Colors.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.listView_Colors_MouseDoubleClick);
			this.listView_Colors.MouseLeave += new System.EventHandler(this.listView_Colors_MouseLeave);
			// 
			// MainForm
			// 
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
			this.ClientSize = new System.Drawing.Size(816, 1011);
			this.Controls.Add(this.splitContainer1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MaximizeBox = false;
			this.MaximumSize = new System.Drawing.Size(832, 1050);
			this.MinimumSize = new System.Drawing.Size(832, 1050);
			this.Name = "MainForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
			this.Text = "Dschump Level Editor";
			this.Load += new System.EventHandler(this.MainForm_Load);
			this.splitContainer1.Panel1.ResumeLayout(false);
			this.splitContainer1.Panel2.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
			this.splitContainer1.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.picLevel)).EndInit();
			this.tabControl1.ResumeLayout(false);
			this.tabPage1.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.picFont)).EndInit();
			this.grpLevel.ResumeLayout(false);
			this.grpLevel.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.numLevelNumber)).EndInit();
			this.groupBox2.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.picCurrentTile)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxClipboard)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.picTiles)).EndInit();
			this.tabPage2.ResumeLayout(false);
			this.tabPage3.ResumeLayout(false);
			this.tabPage3.PerformLayout();
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.SplitContainer splitContainer1;
		private System.Windows.Forms.PictureBox picLevel;
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.TabPage tabPage2;
		private System.Windows.Forms.TabPage tabPage3;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.ListView listView_Colors;
		private System.Windows.Forms.PictureBox picTiles;
		private System.Windows.Forms.PictureBox picFont;
		private System.Windows.Forms.PictureBox pictureBoxClipboard;
		private System.Windows.Forms.CheckBox chkEditTilesOrLevel;
		private System.Windows.Forms.Label lblTileChar;
		private System.Windows.Forms.PictureBox picCurrentTile;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.Button btnSaveTiles;
		private System.Windows.Forms.Button btnLoadTiles;
		private System.Windows.Forms.Label lblUnderCursor;
		private System.Windows.Forms.Label lblClipboard;
		private System.Windows.Forms.Label lblPickedChar;
		private System.Windows.Forms.Label lblLevelCursor;
		private System.Windows.Forms.GroupBox grpLevel;
		private System.Windows.Forms.NumericUpDown numLevelNumber;
		private System.Windows.Forms.Button btnExportLevel;
		private System.Windows.Forms.Button btnSaveLevel;
		private System.Windows.Forms.Button btnLoadLevel;
		private System.Windows.Forms.Label lblLevelNr;
		private System.Windows.Forms.Button btnNewLevel;
		private System.Windows.Forms.Button btnRedrawLevel;
		private System.Windows.Forms.ListView listView_TileNames;
		private System.Windows.Forms.TextBox txtEdit;
		private System.Windows.Forms.Button btnValidateLevel;
		private System.Windows.Forms.Label lblMessage;
        private System.Windows.Forms.Label lblSwitchInfo;
        private System.Windows.Forms.ListView listView_Switches;
        private System.Windows.Forms.ComboBox comboTiles;
        private System.Windows.Forms.Label lblLvlPickedTile;
        private System.Windows.Forms.Button btnCancelSwitchEdit;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox comboWormholes;
		private System.Windows.Forms.Button btnShowWormholes;
		private System.Windows.Forms.Button btnShowBoth;
		private System.Windows.Forms.Button btnShowSwitches;
		private System.Windows.Forms.Button btnExportTiles;
		private System.Windows.Forms.CheckBox chkCompress;
		private System.Windows.Forms.Button btnShiftDown;
		private System.Windows.Forms.Button btnShiftUp;
		private System.Windows.Forms.Button btnShiftRight;
		private System.Windows.Forms.Button btnShiftLeft;
		private System.Windows.Forms.ListView listView_Wormholes;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox cmbStartX;
		private System.Windows.Forms.TextBox tbLevelHint2;
		private System.Windows.Forms.TextBox tbLevelHint1;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.ComboBox cmbStartY;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.ComboBox cmbScreenTop;
		private System.Windows.Forms.ComboBox cmbUpDown;
	}
}

