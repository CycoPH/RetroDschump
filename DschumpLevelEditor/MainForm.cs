using System;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Windows.Forms;

using System.Text.Json;
using DschumpLevelEditor.LevelParts;
using DschumpLevelEditor.Definitions;
using DschumpLevelEditor.Helpers;

namespace DschumpLevelEditor
{
	public partial class MainForm : Form
	{
		public bool useZX5 = true;				// True = zx5, False = zopfli
		public UIState uiState;					// What state is the UI in?
		public EditorMode editorMode;			// Level or Tile editor
		public LevelEditorMode levelEditorMode;	// Normal, Switch, Wormhole

		private AtariPalette myPalette;
		private AtariColorPicker colorPicker;
		private AtariFontRenderer fontRenderer;

		public DschumpSwitch EditThisSwitch { get; set; }
		public DschumpWormhole EditThisWormhole { get; set; }

		static Timer messageTimer = new Timer();			// Timer to clear the message box after x seconds

		static Timer enableLevelTimer = new Timer();		// Timer to enable the picLevel after a load



		// Tiles info
		private DschumpTiles tilesInfo;

		//private AtariMap tilesMap;              // The characters that make up the individual tiles
		private AtariPictureTools tilePickerPictureTools;
		private Bitmap tilesImage;

		// Level info
		private DschumpLevel levelInfo;
		private LevelPictureTools levelPictureTools;

		// Font image info
		private AtariMap fontMap;           // 16x16 chars
		private AtariPictureTools fontPickerPictureTools;
		private Bitmap fontImage;

		// Currently selected tile info


		private int currentTile = -1;				// Which tile is currently selected

		private AtariClipboard clipboard = new AtariClipboard();

		public MainForm()
		{
			InitializeComponent();
		}

		private void MainForm_Load(object sender, EventArgs e)
		{
			string version = Assembly.GetExecutingAssembly().GetName().Version.ToString();
			this.Text = $"Dschump Level Editor v{version}";

			myPalette = new AtariPalette();
			var res = myPalette.Load("Assets/AtariColors.act");
			if (res != 0)
			{
				MessageBox.Show($"Error loading palette 'AtariColors.act' ErrorCode={res}");
				Application.Exit();
			}
			colorPicker = new AtariColorPicker(myPalette);

			// Create the object to render font data into bitmaps
			try
			{
				fontRenderer = new AtariFontRenderer("Assets/DschumpTileFont.fnt");
				fontRenderer.SetPalette(myPalette);
			}
			catch (Exception ex)
			{
				MessageBox.Show("Error loading Dschump font file (DschumpTileFont.fnt):" + ex.Message);
				Application.Exit();
			}

			FillFontColorList();

			// Create the map that will contain the bytes for all 64 (4x3) tiles
			// Put some real tile map data down
			tilesInfo = new DschumpTiles();
			PopulateTilesCombo();
			//tilesMap = new AtariMap(new Size(AppConsts.TilesMapWidth, AppConsts.TilesMapHeight));

			// Create the bitmap (for the picture box) where we show all the tiles
			// This will be used to show the actual 4x3 tiles, each tile made up of 12 characters
			picTiles.Image = new Bitmap(AppConsts.TilesBitmapWidth, AppConsts.TilesBitmapHeight)
			{
				Palette = myPalette.GetPalette()
			};

			tilesImage = new Bitmap(picTiles.Width, picTiles.Height);
			fontRenderer.RenderData(tilesInfo.Map, tilesImage);		// Draw the tile characters to the tilesImage

			tilePickerPictureTools = new AtariPictureTools((Bitmap)picTiles.Image, fontRenderer, tilesInfo.Map, AppConsts.TileZoomLevel);
			tilePickerPictureTools.SetGridVisibility(false, false);
			tilePickerPictureTools.Redraw(tilesImage);

			LoadTiles("Assets/DschumpTiles.dtiles");

			// Setup the font selector
			// 16x16 characters (2x zoom)
			picFont.Image = new Bitmap(AppConsts.FontBitmapWidth, AppConsts.FontBitmapHeight)
			{
				Palette = myPalette.GetPalette()
			};
			fontMap = new AtariMap(new Size(AppConsts.FontMapHeight, AppConsts.FontMapHeight));
			for (var a = 0; a < AppConsts.FontMapHeight * AppConsts.FontMapHeight; a++)
				fontMap.Data[a] = (byte)a;

			fontImage = new Bitmap(AppConsts.FontBitmapWidth, AppConsts.FontBitmapHeight);
			fontRenderer.RenderData(fontMap, fontImage);

			fontPickerPictureTools = new AtariPictureTools((Bitmap)picFont.Image, fontRenderer, fontMap, AppConsts.TileZoomLevel);
			fontPickerPictureTools.Redraw(fontImage);

			editorMode = EditorMode.Level;
			ShowEditorMode();

			// Create the default empty level
			levelInfo = new DschumpLevel(0);

			// Build the bitmap for the level view
			//levelMap = new AtariMap(new Size(LevelMapWidth, LevelMapHeight));

			// Create the bitmap (for the picture box) where we show all the tiles
			// This will be used to show the actual 4x3 tiles, each tile made up of 12 characters
			picLevel.Image = new Bitmap(AppConsts.LevelBitmapWidth, AppConsts.LevelBitmapHeight)
			{
				Palette = myPalette.GetPalette()
			};

			levelPictureTools = new LevelPictureTools((Bitmap)picLevel.Image, tilesImage, levelInfo);
			levelPictureTools.ApplyLevelData();					// Draw the tiles to internal bitmap
			levelPictureTools.Redraw();

			picCurrentTile.Image = new Bitmap(AppConsts.CurrentTileWidth, AppConsts.CurrentTileHeight)
			{
				Palette = myPalette.GetPalette()
			};
			picCurrentTile.Invalidate();

			ClearLevelAction();
			picLevel_MouseUp(null, new MouseEventArgs(MouseButtons.Right, 1, 0,0,0));

			messageTimer.Tick += new EventHandler(TimerEventProcessor);
			enableLevelTimer.Tick += new EventHandler(EnableLevelProcessor);

			ShowMessage("Ready");
		}


		// --------------------------------------------------------------------------


		/// <summary>
		/// Editor mode has changed
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void chkEditTilesOrLevel_CheckedChanged(object sender, EventArgs e)
		{
			editorMode = chkEditTilesOrLevel.Checked ? EditorMode.Level : EditorMode.Tile;
			ShowEditorMode();
		}

		private void ShowEditorMode()
		{
			if (editorMode == EditorMode.Tile)
			{
				chkEditTilesOrLevel.Text = "Switch 2 Level Editor";
				tilePickerPictureTools.SetGridVisibility(false, true);
				fontPickerPictureTools.SetGridVisibility(false, true);
				ShowMessage("Switched into Tile Editor mode");
			}

			if (editorMode == EditorMode.Level)
			{
				chkEditTilesOrLevel.Text = "Switch 2 Tile Editor";
				tilePickerPictureTools.SetGridVisibility(false, false);
				fontPickerPictureTools.SetGridVisibility(false, false);
				ShowMessage("Switched into Level Editor mode");
			}
			tilePickerPictureTools.Redraw(tilesImage);
			picTiles.Invalidate();

			fontPickerPictureTools.Redraw(fontImage);
			picFont.Invalidate();
		}

		private void UpdateTileSelectionBox()
		{
			// Draw the tile into the selection box
			using (Graphics grDest = Graphics.FromImage((Bitmap)picCurrentTile.Image))
			{
				grDest.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.NearestNeighbor;
				var srcR = new Rectangle(0, 0, 8 * 4, 8 * 3);
				var destR = new Rectangle(0, 0, AppConsts.CurrentTileWidth, AppConsts.CurrentTileHeight);
				srcR.X = (currentTile % 8) * AppConsts.CurrentTileWidth / 2;
				srcR.Y = (currentTile / 8) * AppConsts.CurrentTileHeight / 2;

				grDest.DrawImage(tilesImage, destR, srcR, GraphicsUnit.Pixel);
			}
			picCurrentTile.Invalidate();

		}

		private void RedrawTilesWindow()
		{
			fontRenderer.RenderData(tilesInfo.Map, tilesImage);				// Draw the tilesMap information into the 'tilesImage'
			tilePickerPictureTools.Redraw(tilesImage);					// redraw grids
			picTiles.Invalidate();
		}



		private void btnLoadTiles_Click(object sender, EventArgs e)
		{
			var fileDialog = new OpenFileDialog()
			{
				Filter = "Dschump Tiles (*.dtiles)|*.dtiles",
				FileName = "DschumpTiles.dtiles",
				DereferenceLinks = false,
			};
			if (fileDialog.ShowDialog() == DialogResult.OK)
			{
				LoadTiles(fileDialog.FileName);
			}

			ShowMessage("Tiles loaded");
		}

		private void btnSaveTiles_Click(object sender, EventArgs e)
		{
			var fileDialog = new SaveFileDialog()
			{
				Filter = "Dschump Tiles (*.dtiles)|*.dtiles",
				FileName = "DschumpTiles.dtiles",
				DereferenceLinks = false,
			};
			if (fileDialog.ShowDialog() == DialogResult.OK)
			{
				SaveTiles(fileDialog.FileName);
			}
			ShowMessage("Tiles saved");
		}

		/// <summary>
		/// Export the tile information as assembler
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnExportTiles_Click(object sender, EventArgs e)
		{
			var fileDialog = new SaveFileDialog()
			{
				Filter = "Dschump Tiles ASM (*.asm)|tiles.asm",
				FileName = "tiles.asm",
				DereferenceLinks = false,
			};
			if (fileDialog.ShowDialog() == DialogResult.OK)
			{
				var asm = tilesInfo.ExportToAsm();
				File.WriteAllText(fileDialog.FileName, asm);
			}
			ShowMessage("Tiles exported");
		}

		private void LoadTiles(string filename)
		{
			var data = File.ReadAllText(filename);

			var tilesMap = JsonSerializer.Deserialize<DschumpTiles>(data);
			// Copy the data into the current tilesInfo data container
			tilesInfo.Copy(tilesMap);

			RedrawTilesWindow();
			FillTilesNameList();
			PopulateTilesCombo();
		}

		private void SaveTiles(string filename)
		{
			var jsonString = JsonSerializer.Serialize(tilesInfo);

			File.WriteAllText(filename, jsonString);
		}
		

		private void btnSaveLevel_Click(object sender, EventArgs e)
		{
			var fileDialog = new SaveFileDialog()
			{
				Filter = "Dschump Level (*.dlvl)|*.dlvl",
				FileName = $"{levelInfo.LevelNr}.dlvl",
				DereferenceLinks = false,
			};
			if (fileDialog.ShowDialog() == DialogResult.OK)
			{
				SaveLevel(fileDialog.FileName);
			}

			ShowMessage("Level saved");
		}

		private void SaveLevel(string filename)
		{
			var jsonString = JsonSerializer.Serialize(levelInfo);

			File.WriteAllText(filename, jsonString);

			lblLevelNr.Text = $"Saved as {levelInfo.LevelNr}";
			grpLevel.Text = $"Level: {levelInfo.LevelNr}";
		}

		private void LoadLevel(string filename)
		{
			Application.UseWaitCursor = true;
			
			var data = File.ReadAllText(filename);

			levelInfo = JsonSerializer.Deserialize<DschumpLevel>(data);
			levelPictureTools.SetLevelInfo(levelInfo);

			levelPictureTools.ApplyLevelData();                 // Draw the tiles to internal bitmap
			levelPictureTools.Redraw();
			picLevel.Invalidate();

			lblLevelNr.Text = $"Loaded as {levelInfo.LevelNr}";
			grpLevel.Text = $"Level: {levelInfo.LevelNr}";
			numLevelNumber.Value = levelInfo.LevelNr;
            cmbStartX.SelectedIndex = levelInfo.StartX;
			cmbStartY.SelectedIndex = levelInfo.StartY;
			cmbScreenTop.SelectedIndex = levelInfo.ScreenTop;
			cmbUpDown.SelectedIndex = levelInfo.Direction;
			tbLevelHint1.Text = levelInfo.LevelHint1;
			tbLevelHint2.Text = levelInfo.LevelHint2;

			Application.UseWaitCursor = false;
		}

		private void numLevelNumber_ValueChanged(object sender, EventArgs e)
		{
			levelInfo.LevelNr = (int)numLevelNumber.Value;
			grpLevel.Text = $"Level: {levelInfo.LevelNr}";
		}

		private void btnLoadLevel_Click(object sender, EventArgs e)
		{
			var fileDialog = new OpenFileDialog()
			{
				Filter = "Dschump Level (*.dlvl)|*.dlvl",
				DefaultExt = ".dlvl",
				DereferenceLinks = false,
				//AutoUpgradeEnabled = false,
			};
			if (fileDialog.ShowDialog() == DialogResult.OK)
			{
				LoadLevel(fileDialog.FileName);
				DisableLevelEditor();
			}
			ShowMessage("Level loaded");
		}

		/// <summary>
		/// Export the level data as assembler data
		/// </summary>
		private void btnExportLevel_Click(object sender, EventArgs e)
		{
			if (!ValidateLevel()) return;
			var fileDialog = new SaveFileDialog()
			{
				Filter = chkCompress.Checked ? $"Dschump Level ASM(*.asm) | level{levelInfo.LevelNr}.asm" : "Dschump Level ASM (*.asm)|level.asm",
				FileName = chkCompress.Checked ? $"level{levelInfo.LevelNr}.asm" : "level.asm",
				DereferenceLinks = false,
			};
			if (fileDialog.ShowDialog() == DialogResult.OK)
			{
				try
				{
					File.Delete(fileDialog.FileName);
				}
				catch(Exception ex)
				{
					ShowMessage($"Unable to delete {fileDialog.FileName} ex:{ex.Message}");
					return;
				}
				var (asm, binLength) = levelInfo.ExportToAsm(chkCompress.Checked, useZX5);
				if (asm != null)
				{
					try
					{
						File.WriteAllText(fileDialog.FileName, asm);
					}
					catch(Exception ex)
					{
						ShowMessage($"Unable to export to {fileDialog.FileName} ex:{ex.Message}");
						return;
					}
				}
				ShowMessage($"Level is {binLength} bytes long {448-binLength} bytes saved!");
			}
			else
			{
				ShowMessage("Level save cancelled");
			}
		}

		private void btnNewLevel_Click(object sender, EventArgs e)
		{
			if (MessageBox.Show("Clear current level?", "New level?", MessageBoxButtons.YesNo) == DialogResult.No)
				return;
			ClearLevelAction();
		}

		private void ClearLevelAction()
        {
			numLevelNumber.Value = 0;

			levelInfo = new DschumpLevel(0);
			levelPictureTools.SetLevelInfo(levelInfo);
			cmbStartX.SelectedIndex = levelInfo.StartX;
			cmbStartY.SelectedIndex = levelInfo.StartY;
			cmbScreenTop.SelectedIndex = levelInfo.ScreenTop;
			cmbUpDown.SelectedIndex = levelInfo.Direction;
			tbLevelHint1.Text = levelInfo.LevelHint1;
			tbLevelHint2.Text = levelInfo.LevelHint2;

			grpLevel.Text = $"Level: {levelInfo.LevelNr}";
			lblLevelNr.Text = "New ...";

			btnRedrawLevel_Click(null, null);

			ShowMessage("Level cleared");
		}

		private void btnRedrawLevel_Click(object sender, EventArgs e)
		{
			levelPictureTools.ApplyLevelData();                 // Draw the tiles to internal bitmap
			levelPictureTools.Redraw();
			picLevel.Invalidate();

			ShowMessage("Redraw done");
		}

		/// <summary>
		/// A new tab has been selected.
		/// Fire an update if required
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
		{
			switch (tabControl1.SelectedIndex)
			{
				case 1: // Level Details
					{
						RescanSwitches();
						RescanWormholes();
						break;
					}
			}
		}

		/// <summary>
		/// Switch the UI into the required state
		/// </summary>
		/// <param name="next"></param>
		public void SwitchUIState(UIState next)
		{
			switch(next)
			{
				case UIState.Normal:
					{
						// Turn on
						tabPage1.Enabled = true;
						tabPage3.Enabled = true;

						listView_Wormholes.Enabled = true;
						listView_Switches.Enabled = true;

						// Turn off
						btnCancelSwitchEdit.Visible = false;
						break;
					}

				case UIState.SelectSwitchPosition:
					{
						// Turn off
						tabPage1.Enabled = false;
						tabPage3.Enabled = false;

						listView_Wormholes.Enabled = false;
						listView_Switches.Enabled = false;

						// Turn on
						btnCancelSwitchEdit.Visible = true;
						break;
					}
			}

			uiState = next;
		}

		/// <summary>
		/// Show switches and their target tiles
		/// </summary>
		private void btnShowSwitches_Click(object sender, EventArgs e)
		{
			RescanSwitches();

			levelPictureTools.Redraw();

			foreach (var item in levelInfo.Switches.Keys)
			{
				EditThisSwitch = levelInfo.Switches[item];
				ShowSwitchPosition(EditThisSwitch);
			}
			
			picLevel.Invalidate();

			ShowMessage("Showing switches");
		}

		/// <summary>
		/// Display worm holes linked to their exit positions
		/// </summary>
		private void btnShowWormholes_Click(object sender, EventArgs e)
		{
			RescanWormholes();

			levelPictureTools.Redraw();

			foreach (var item in levelInfo.Wormholes.Keys)
			{
				EditThisWormhole = levelInfo.Wormholes[item];
				if (EditThisWormhole.ExitOnly == false)
					ShowWormholePosition(EditThisWormhole, false);
			}

			picLevel.Invalidate();

			ShowMessage("Showing wormholes");
		}

		/// <summary>
		/// Display switches and their target tiles, and worm holes linked to their exit positions
		/// </summary>
		private void btnShowBoth_Click(object sender, EventArgs e)
		{
			RescanWormholes();
			RescanSwitches();

			levelPictureTools.Redraw();

			foreach (var item in levelInfo.Switches.Keys)
			{
				EditThisSwitch = levelInfo.Switches[item];
				ShowSwitchPosition(EditThisSwitch);
			}

			foreach (var item in levelInfo.Wormholes.Keys)
			{
				EditThisWormhole = levelInfo.Wormholes[item];
				if (EditThisWormhole.ExitOnly == false)
					ShowWormholePosition(EditThisWormhole, false);
			}

			ShowStartScreen();

			picLevel.Invalidate();

			ShowMessage("Showing switches and wormholes");
		}


		#region Display a message and remove after 5 seconds
		public void ShowMessage(string msg)
		{
			lblMessage.Text = msg;

			// Sets the timer interval to 5 seconds.
			messageTimer.Stop();
			messageTimer.Interval = 10000;
			messageTimer.Start();
			messageTimer.Tag = this;

		}

		private static void TimerEventProcessor(Object myObject, EventArgs myEventArgs)
		{
			messageTimer.Stop();

			var me = (MainForm)messageTimer.Tag;
			me.lblMessage.Text = "";
		}
		#endregion

		public void DisableLevelEditor()
		{
			picLevel.Enabled = false;
			enableLevelTimer.Stop();
			enableLevelTimer.Interval = 2000;
			enableLevelTimer.Start();
			enableLevelTimer.Tag = this;
		}

		private static void EnableLevelProcessor(Object myObject, EventArgs myEventArgs)
		{
			enableLevelTimer.Stop();

			var me = (MainForm)enableLevelTimer.Tag;
			me.picLevel.Enabled = true;
		}

		/// <summary>
		/// Fire off a validate request
		/// </summary>
		private void btnValidateLevel_Click(object sender, EventArgs e)
		{
			ValidateLevel();
		}

		private void btnShiftLeft_Click(object sender, EventArgs e)
		{
			levelInfo.ShiftLeft();
			levelPictureTools.ApplyLevelData();
			levelPictureTools.Redraw();
			picLevel.Invalidate();
		}

		private void btnShiftRight_Click(object sender, EventArgs e)
		{
			levelInfo.ShiftRight();
			levelPictureTools.ApplyLevelData();
			levelPictureTools.Redraw();
			picLevel.Invalidate();
		}

		private void btnShiftUp_Click(object sender, EventArgs e)
		{
			levelInfo.ShiftUp();
			levelPictureTools.ApplyLevelData();
			levelPictureTools.Redraw();
			picLevel.Invalidate();
		}

		private void btnShiftDown_Click(object sender, EventArgs e)
		{
			levelInfo.ShiftDown();
			levelPictureTools.ApplyLevelData();
			levelPictureTools.Redraw();
			picLevel.Invalidate();
		}

        private void cmbStartX_SelectedIndexChanged(object sender, EventArgs e)
        {
			levelInfo.StartX = cmbStartX.SelectedIndex;

			levelPictureTools.Redraw();
			ShowStartScreen();
			picLevel.Invalidate();
		}

		private void cmbStartY_SelectedIndexChanged(object sender, EventArgs e)
		{

			levelInfo.StartY = cmbStartY.SelectedIndex;

			if (levelInfo.Direction == 0)
			{
				// Going up, then 4, 5, 6 are valid
				if (cmbStartY.SelectedIndex <= 3)
					cmbStartY.SelectedIndex = 6;
			}
			else
			{
				// Going down, then 0, 1, 2 are valid
				if (cmbStartY.SelectedIndex >= 3)
					cmbStartY.SelectedIndex = 0;
			}

			levelPictureTools.Redraw();
			ShowStartScreen();
			picLevel.Invalidate();
		}

		private void cmbScreenTop_SelectedIndexChanged(object sender, EventArgs e)
		{
			levelInfo.ScreenTop = cmbScreenTop.SelectedIndex;

			levelPictureTools.Redraw();
			ShowStartScreen();
			picLevel.Invalidate();
		}

		private void cmbUpDown_SelectedIndexChanged(object sender, EventArgs e)
		{
			levelInfo.Direction = cmbUpDown.SelectedIndex;

			cmbStartY_SelectedIndexChanged(null, null);

			levelPictureTools.Redraw();
			ShowStartScreen();
			picLevel.Invalidate();
		}

		private void tbLevelHint1_TextChanged(object sender, EventArgs e)
		{
			levelInfo.LevelHint1 = tbLevelHint1.Text;
		}

		private void tbLevelHint2_TextChanged(object sender, EventArgs e)
		{
			levelInfo.LevelHint2 = tbLevelHint2.Text;
		}
	}
}
