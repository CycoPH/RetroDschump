using DschumpLevelEditor.Definitions;
using DschumpLevelEditor.LevelParts;
using System;
using System.Drawing;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
	// Dummy definition to fool the editor into thinking that this is not a dialog.
	// Otherwise we get a resource conflict
	public class MainForm_Level { }

	// All code that belongs to the level editor goes here
	public partial class MainForm
	{
		private void picLevel_MouseMove(object sender, MouseEventArgs e)
		{
			if (editorMode != EditorMode.Level) return;

			var x = Math.Clamp(e.X, 0, AppConsts.LevelBitmapWidth - 1);
			var y = Math.Clamp(e.Y, 0, AppConsts.LevelBitmapHeight - 1);

			var xx = x / 32;
			var yy = y / 24;

			var position = xx + yy * levelInfo.Map.Stride;

			if (levelEditorMode == LevelEditorMode.Normal)
			{
				// Place a tile or show the cursor
				var tileNr = levelInfo.Map.Data[position];

				lblLevelCursor.Text = $"Level Tile:{tileNr} x:{xx} y:{yy} pos:{position}";

				if (e.Button == MouseButtons.None)
				{
					var tl = new Point(xx * 32, yy * 24);

					levelPictureTools.DrawCursor(tl, (Bitmap)picCurrentTile.Image);
					picLevel.Invalidate();
				}
				else if (e.Button == MouseButtons.Left)
				{
					// Draw tiles with the mouse down
					if (levelInfo.Map.Data[position] != (byte)currentTile)
					{
						// Add the tile to the level map
						levelInfo.Map.Data[position] = (byte)currentTile;
						levelPictureTools.ApplyLevelData(); // Draw the tiles to internal bitmap
						levelPictureTools.Redraw();
						picLevel.Invalidate();
					}
				}
			}
			else if (levelEditorMode == LevelEditorMode.SelectSpot)
			{
				lblLevelCursor.Text = $"Level Position x:{xx} y:{yy} pos:{position}";
				// Draw a tile highlight and select the spot
				if (e.Button == MouseButtons.None)
				{
					var tl = new Point(xx * 32, yy * 24);
					//levelPictureTools.DrawHighlight(tl);
					levelPictureTools.DrawCursor(tl, (Bitmap)picCurrentTile.Image);

					var posX = EditThisSwitch.Position % 8;
					var posY = EditThisSwitch.Position / 8;
					levelPictureTools.DrawSwitchPosition(new Point(posX * 32, posY * 24));

					posX = EditThisSwitch.Target % 8;
					posY = EditThisSwitch.Target / 8;
					levelPictureTools.DrawSwitchTargetLocation(new Point(posX * 32, posY * 24));
					
					picLevel.Invalidate();
				}
			}

		}

		private void picLevel_MouseLeave(object sender, EventArgs e)
		{
			lblLevelCursor.Text = "";
			levelPictureTools.Redraw();
			picLevel.Invalidate();
		}

		private void picLevel_MouseUp(object sender, MouseEventArgs e)
		{
			if (editorMode != EditorMode.Level) return;

			// Calculate level map location
			var x = Math.Clamp(e.X, 0, picLevel.Width - 1);
			var y = Math.Clamp(e.Y, 0, picLevel.Height - 1);
			var xx = x / 32;
			var yy = y / 24;

			var position = xx + yy * levelInfo.Map.Stride;

			if (levelEditorMode == LevelEditorMode.Normal)
			{
				// Place or pick a tile
				if (e.Button == MouseButtons.Left)
				{
					if (currentTile < 0 || currentTile >= 64) return;
					// Add the tile to the level map
					levelInfo.Map.Data[position] = (byte)currentTile;
					levelPictureTools.ApplyLevelData(); // Draw the tiles to internal bitmap
					levelPictureTools.Redraw();
				}
				else if (e.Button == MouseButtons.Right)
				{
					// Select the tile under the cursor
					currentTile = levelInfo.Map.Data[position];
					UpdateTileSelectionBox();
					HighlightSelectedTile();
				}
			}
			else if (levelEditorMode == LevelEditorMode.SelectSpot)
			{
				if (e.Button == MouseButtons.Left)
				{
					// Select the spot
					FinishSwitchTargetSelection(position);
				}
			}
		}

		/// <summary>
		/// The mouse wheel was moved in the level picture.
		/// Move the font selection one unit up or down
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void picLevel_MouseWheel(object sender, MouseEventArgs e)
		{
			if (editorMode != EditorMode.Level) return;

			currentTile += e.Delta > 0 ? -1 : 1;
			if (currentTile < 0) currentTile = 63;
			if (currentTile >= 64) currentTile = 0;
			UpdateTileSelectionBox();
			HighlightSelectedTile();

			var x = Math.Clamp(e.X, 0, picLevel.Width - 1);
			var y = Math.Clamp(e.Y, 0, picLevel.Height - 1);

			int xx = x / 32;
			int yy = y / 24;

			var tl = new Point(xx * 32, yy * 24);

			levelPictureTools.DrawCursor(tl, (Bitmap)picCurrentTile.Image);
			picLevel.Invalidate();
		}


		public void ShowSwitchPosition(DschumpSwitch theSwitch)
		{
			if (theSwitch != null)
			{
				// Highlight the switch position
				var posX = theSwitch.Position % 8;
				var posY = theSwitch.Position / 8;
				levelPictureTools.DrawSwitchPosition(new Point(posX * 32, posY * 24));
			
				// Select the tile for drawing
				currentTile = theSwitch.What;
				UpdateTileSelectionBox();
				HighlightSelectedTile();

				// Highlight the target position
				var posXt = theSwitch.Target % 8;
				var posYt = theSwitch.Target / 8;
				levelPictureTools.DrawSwitchTargetLocation(new Point(posXt * 32, posYt * 24), (Bitmap)picCurrentTile.Image);
				// Draw a line from the switch position to the target position
				levelPictureTools.LinkSwitchPositionWithTarget(theSwitch);

			}
		}

		public void ShowWormholePosition(DschumpWormhole theWormhole, bool withDetails = true)
		{
			if (theWormhole != null)
			{
				levelPictureTools.DrawWormhole(theWormhole, withDetails);
			}
		}

		public void ShowPossibleWarp(DschumpWormhole theWormhole)
		{
			if (theWormhole != null)
			{
				levelPictureTools.ShowPossibleWarp(theWormhole);
			}
		}
		
		public void ShowStartScreen()
		{
			levelPictureTools.DrawStartScreen(levelInfo.ScreenTop, levelInfo.Direction, levelInfo.StartX, levelInfo.StartY);
		}

		public void ShowStart(int start)
        {
			levelPictureTools.DrawStartScreen(levelInfo.ScreenTop, levelInfo.Direction, levelInfo.StartX, levelInfo.StartY);
			//levelPictureTools.DrawStart(start);
		}
	}
}
