using DschumpLevelEditor.Definitions;
using System;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
	// Dummy definition to fool the editor into thinking that this is not a dialog.
	// Otherwise we get a resource conflict
	public class MainForm_Tiles { }

	public partial class MainForm
	{
		private void ShowTileInfo(int tileNr, string extra = "")
		{
			var tileType = tileNr < 32 ? "Action Tile" : "Build Tile";
			var str = $"{tileType}: {tileNr} - {tilesInfo.Names[tileNr]} {extra}";
			lblTileChar.Text = str;
			lblLvlPickedTile.Text = str;
		}

		private void HighlightSelectedTile()
		{
			var tileX = currentTile % 8;
			var tileY = currentTile / 8;

			var tl = new Point(tileX * (8 * 4 * AppConsts.TileZoomLevel), tileY * (8 * 3 * AppConsts.TileZoomLevel));
			var br = new Point(tl.X + (8 * 3 * AppConsts.TileZoomLevel), tl.Y + (8 * 2 * AppConsts.TileZoomLevel));

			tilePickerPictureTools.PreviousMouseLocation = tl;
			tilePickerPictureTools.SelectionStart(tl);
			tilePickerPictureTools.SelectionChange(tilesImage, br);
			picTiles.Invalidate();

			ShowTileInfo(currentTile);
		}

		#region Interactions with the tiles editor
		private void picTiles_MouseDown(object sender, MouseEventArgs e)
		{
			if (editorMode == EditorMode.Tile)
			{
				tilePickerPictureTools.PreviousMouseLocation = e.Location;
				if (e.Button == MouseButtons.Left)
				{
					if (clipboard.isValid)
					{
						clipboard.SetDataSource(tilesInfo.Map);
						var charSize = AppConsts.TileZoomLevel * 8;
						var addOffset = (e.X / charSize) + tilesInfo.Map.Stride * (e.Y / charSize);
						clipboard.Paste(fontRenderer.offset + addOffset);
						RedrawTilesWindow();
					}
				}
				else if (e.Button == MouseButtons.Right)
				{
					// Select the character under the cursor
					var x = Math.Clamp(e.Location.X, 0, AppConsts.TilesBitmapWidth - 1);
					var y = Math.Clamp(e.Location.Y, 0, AppConsts.TilesBitmapHeight - 1);

					var xx = (fontRenderer.OffsetX + x / (AppConsts.TileZoomLevel * 8));
					var yy = (fontRenderer.OffsetY + y / (AppConsts.TileZoomLevel * 8));
					var charVal = tilesInfo.Map.Data[xx + yy * tilesInfo.Map.Stride];
					// Translate from the charVal to the location in the font picker where the character would be
					int charX = (charVal % AppConsts.FontMapWidth) * AppConsts.CharWidth;
					int charY = (charVal / AppConsts.FontMapWidth) * AppConsts.CharWidth;

					picFont_MouseDown(null, new MouseEventArgs(MouseButtons.Left, 1, charX, charY, 0));
					picFont_MouseUp(null, new MouseEventArgs(MouseButtons.Left, 1, charX, charY, 0));
				}
			}

			if (editorMode == EditorMode.Level)
			{
				// Select the tile under the cursor
				var x = Math.Clamp(e.X, 0, AppConsts.TilesBitmapWidth - 1);
				var y = Math.Clamp(e.Y, 0, AppConsts.TilesBitmapHeight - 1);

				int xx = (fontRenderer.OffsetX + x / (AppConsts.TileZoomLevel * 8));
				int yy = (fontRenderer.OffsetY + y / (AppConsts.TileZoomLevel * 8));
				int tileNr = xx / 4 + (yy / 3) * (tilesInfo.Map.Stride / 4);

				currentTile = tileNr;
				UpdateTileSelectionBox();
				HighlightSelectedTile();
			}
		}

		private void picTiles_MouseMove(object sender, MouseEventArgs e)
		{
			var x = Math.Clamp(e.X, 0, AppConsts.TilesBitmapWidth - 1);
			var y = Math.Clamp(e.Y, 0, AppConsts.TilesBitmapHeight - 1);

			var xx = (fontRenderer.OffsetX + x / (AppConsts.TileZoomLevel * 8));
			var yy = (fontRenderer.OffsetY + y / (AppConsts.TileZoomLevel * 8));
			var charVal = tilesInfo.Map.Data[xx + yy * tilesInfo.Map.Stride];

			var tileNr = xx / 4 + (yy / 3) * (tilesInfo.Map.Stride / 4);


			if (editorMode == EditorMode.Tile)
			{
				//lblTileChar.Text = $"Tile:{tileNr} Char:${charVal:X2} ({charVal}) {(xx % 4)} {(yy % 3)}";
				ShowTileInfo(tileNr, $"-- Char:${charVal:X2} ({charVal}) {(xx % 4)}x{(yy % 3)}");

				if (e.Button == MouseButtons.None)
				{
					// No button is pressed
					// Just draw the tile without copy
					if (clipboard.isValid)  //copy mode (shows alpha blended clipBoard)
					{
						var pt = new Point(x, y);
						tilePickerPictureTools.DrawClipBoard(clipboard, pt);
						picTiles.Refresh();
						tilePickerPictureTools.DrawUnderClipBoard(clipboard, pt);
					}
				}
			}
			else if (editorMode == EditorMode.Level)
			{
				ShowTileInfo(tileNr);
				/*
				var tileX = tileNr % 8;
				var tileY = tileNr / 8;

				var tl = new Point(tileX * (8 * 4 * TileZoomLevel), tileY * (8 * 3 * TileZoomLevel));
				var br = new Point(tl.X + (8 * 3 * TileZoomLevel), tl.Y + (8 * 2 * TileZoomLevel));
				tilePickerPictureTools.PreviousMouseLocation = tl;
				tilePickerPictureTools.SelectionStart(tl);
				tilePickerPictureTools.SelectionChange(tilesImage, br);
				picTiles.Invalidate();
				*/
			}
		}

		/// <summary>
		/// The mouse wheel was moved in the tile picture.
		/// Move the font selection one unit up or down
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void picTiles_MouseWheel(object sender, MouseEventArgs e)
		{
			if (editorMode == EditorMode.Level)
			{
				currentTile += e.Delta > 0 ? -1 : 1;
				if (currentTile < 0) currentTile = 63;
				if (currentTile >= 64) currentTile = 0;
				UpdateTileSelectionBox();
				HighlightSelectedTile();
			}
			else if (editorMode == EditorMode.Tile)
			{
				if (!clipboard.isValid) return;

				MoveFontSelection(e.Delta > 0 ? -1 : 1);
				if (clipboard.isValid) //copy mode (shows alpha blended clipBoard)
				{
					tilePickerPictureTools.DrawClipBoard(clipboard, e.Location);
					picTiles.Refresh();
					tilePickerPictureTools.DrawUnderClipBoard(clipboard, e.Location);
				}
			}
		}

		#endregion


		#region Manage the Names and Valid state of the 64 tiles
		/// <summary>
		/// Allow us to edit the text in the listview
		/// </summary>
		private ListViewItem SelectedItem;
		private ListViewItem.ListViewSubItem SelectedLSI;
		private void FillTilesNameList()
		{
			listView_TileNames.Clear();
			listView_TileNames.LargeImageList = GetFontColorImageList(fontRenderer.Color5);
			listView_TileNames.Columns.Add("Tile Nr");
			listView_TileNames.Columns.Add("Switch");
			listView_TileNames.Columns.Add("Exit");			// Is the tile a worm hole exit
			listView_TileNames.Columns.Add("Tile Description");

			for (var i = 0; i < 64; i++)
			{
				var lvi = new ListViewItem();
				lvi.Checked = tilesInfo.Valid[i];
				lvi.Text = $"{i}";
				lvi.Name = "TileNr";

				var isSwitchItem = lvi.SubItems.Add($"{(tilesInfo.IsSwitch[i] ? "Yes" : "No")}");
				isSwitchItem.Name = "IsSwitch";

				var isExitItem = lvi.SubItems.Add($"{(tilesInfo.IsExit[i] ? "Yes" : "No")}");
				isExitItem.Name = "IsExit";

				var descItem = lvi.SubItems.Add($"{tilesInfo.Names[i]}");
				descItem.Name = "Desc";

				lvi.ImageIndex = i;
				listView_TileNames.Items.Add(lvi);
			}
			listView_TileNames.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_TileNames.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_TileNames.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_TileNames.Columns[3].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
		}

		/// <summary>
		/// Prevent the column from being resized
		/// </summary>
		private void listView_TileNames_ColumnWidthChanging(object sender, ColumnWidthChangingEventArgs e)
		{
			e.Cancel = true;
			e.NewWidth = listView_TileNames.Columns[e.ColumnIndex].Width;
		}

		private void listView_TileNames_ItemChecked(object sender, ItemCheckedEventArgs e)
		{
			tilesInfo.Valid[e.Item.Index] = e.Item.Checked;
		}

		private void listView_MouseWheel(object sender, MouseEventArgs e)
		{
			HideTextEditor();
		}

		private void listView_TileNames_MouseDown(object sender, MouseEventArgs e)
		{
			HideTextEditor();
		}

		private void listView_TileNames_MouseUp(object sender, MouseEventArgs e)
		{
			ListViewHitTestInfo i = listView_TileNames.HitTest(e.X, e.Y);

			if (i.SubItem.Name == "TileNr")
			{
				// We hit the first column, don't want to edit that
				return;
			}

			if (i.SubItem.Name == "IsSwitch")
			{
				var idx = i.Item.Index;
				// Hit the switch column, toggle the state and update the text on it
				tilesInfo.IsSwitch[idx] = !tilesInfo.IsSwitch[i.Item.Index];

				i.SubItem.Text = tilesInfo.IsSwitch[idx] ? "Yes" : "No";
				return;
			}

			if (i.SubItem.Name == "IsExit")
			{
				var idx = i.Item.Index;
				// Hit the exit column, toggle the state and update the text on it
				tilesInfo.IsExit[idx] = !tilesInfo.IsExit[i.Item.Index];

				i.SubItem.Text = tilesInfo.IsExit[idx] ? "Yes" : "No";
				return;
			}

			SelectedItem = i.Item;
			SelectedLSI = i.SubItem;
			if (SelectedLSI == null)
				return;

			int border = 0;
			switch (listView_TileNames.BorderStyle)
			{
				case BorderStyle.FixedSingle:
					border = 1;
					break;
				case BorderStyle.Fixed3D:
					border = 2;
					break;
			}

			int CellWidth = SelectedLSI.Bounds.Width;
			int CellHeight = SelectedLSI.Bounds.Height;
			int CellLeft = border + listView_TileNames.Left + i.SubItem.Bounds.Left;
			int CellTop = listView_TileNames.Top + i.SubItem.Bounds.Top;
			// First Column
			if (i.SubItem == i.Item.SubItems[0])
				CellWidth = listView_TileNames.Columns[0].Width;

			txtEdit.Location = new Point(CellLeft, CellTop);
			txtEdit.Size = new Size(CellWidth, CellHeight);
			txtEdit.Visible = true;
			txtEdit.BringToFront();
			txtEdit.Text = i.SubItem.Text;
			txtEdit.Select();
			txtEdit.SelectAll();
		}

		private void txtEdit_Leave(object sender, EventArgs e)
		{
			HideTextEditor();
		}
		private void txtEdit_KeyUp(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Escape)
			{
				SelectedLSI = null;
				HideTextEditor();
			}
			if (e.KeyCode == Keys.Enter || e.KeyCode == Keys.Return)
				HideTextEditor();
		}

		private void HideTextEditor()
		{
			txtEdit.Visible = false;
			if (SelectedLSI != null)
			{
				SelectedLSI.Text = txtEdit.Text;
				tilesInfo.Names[SelectedItem.Index] = txtEdit.Text;
			}

			SelectedLSI = null;
			SelectedItem = null;
			txtEdit.Text = "";
		}
		#endregion

		
	}
}
