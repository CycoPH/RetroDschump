using DschumpLevelEditor.Definitions;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
	// Dummy definition to fool the editor into thinking that this is not a dialog.
	// Otherwise we get a resource conflict
	public class MainForm_Font { }
	public partial class MainForm
    {
		// --------------------------------------------------------------------------
		// Character set selection
		private void picFont_MouseLeave(object sender, EventArgs e)
		{
			lblUnderCursor.Text = "";
		}

		private void picFont_MouseMove(object sender, MouseEventArgs e)
		{
			if (editorMode != EditorMode.Tile) return;
			var x = Math.Clamp(e.X, 0, picFont.Width - 1);
			var y = Math.Clamp(e.Y, 0, picFont.Height - 1);

			if (e.Button == MouseButtons.Left)
			{
				fontPickerPictureTools.SelectionChange(fontImage, x, y);
				picFont.Invalidate();
			}

			int xx = (fontRenderer.OffsetX + x / (AppConsts.TileZoomLevel * 8));
			int yy = (fontRenderer.OffsetY + y / (AppConsts.TileZoomLevel * 8));
			if (xx < fontMap.Stride && yy < fontMap.ScreenSize.Height)
			{
				byte charVal = fontMap.Data[xx + yy * fontMap.Stride];
				lblUnderCursor.Text = $"Cursor: ${charVal:X2} ({charVal})";
			}
		}

		private void picFont_MouseDown(object sender, MouseEventArgs e)
		{
			if (editorMode != EditorMode.Tile) return;

			fontPickerPictureTools.PreviousMouseLocation = e.Location;
			fontPickerPictureTools.SelectionStart(e.Location);
			picFont.Invalidate();
		}

		private void picFont_MouseUp(object sender, MouseEventArgs e)
		{
			if (editorMode != EditorMode.Tile) return;

			clipboard.isValid = fontPickerPictureTools.SelectionEnd(clipboard, fontImage);
			pictureBoxClipboard.Image = clipboard.GetImage();

			var charVal = 0;
			if (clipboard.isValid)
			{
				charVal = clipboard.GetChar();
			}
			lblPickedChar.Text = $"Picked: ${charVal:X2} ({charVal}) {clipboard.Width}x{clipboard.Height}";
			//picFont.Invalidate();
		}

		/// <summary>
		/// The mouse wheel was moved.
		/// Move the font selection one unit up or down
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void picFont_MouseWheel(object sender, MouseEventArgs e)
		{
			if (editorMode != EditorMode.Tile || !clipboard.isValid) return;

			MoveFontSelection(e.Delta > 0 ? -1 : 1);
		}

		private void MoveFontSelection(int dir)
		{
			var topLeftChar = clipboard.GetChar();
			var x = topLeftChar % AppConsts.FontMapWidth;
			var y = topLeftChar / AppConsts.FontMapHeight;
			var w = clipboard.Width;
			var h = clipboard.Height;

			var nextX = x + dir;
			var nextY = y;
			if (nextX < 0)
			{
				nextX = AppConsts.FontMapWidth - w;
				--nextY;
			}
			if (nextY < 0)
			{
				nextY = AppConsts.FontMapHeight - h;
			}

			if (nextX + w > AppConsts.FontMapWidth)
			{
				nextX = 0;
				++nextY;
			}

			if (nextY + h > AppConsts.FontMapHeight)
			{
				nextY = 0;
			}

			// Calc the top-left of the new character in the map
			// Simulating a mouse click @ that position
			var tl = new Point(nextX * AppConsts.CharWidth, nextY * AppConsts.CharHeight);

			fontPickerPictureTools.SelectionStart(tl, false);       // Don't draw selection
			fontPickerPictureTools.SelectionChange(fontImage, (nextX + w) * AppConsts.CharWidth - 1, (nextY + h) * AppConsts.CharHeight - 1);
			//picFont.Invalidate();
			clipboard.isValid = fontPickerPictureTools.SelectionEnd(clipboard, fontImage);
			pictureBoxClipboard.Image = clipboard.GetImage();

			fontPickerPictureTools.SelectionStart(tl, false);       // Don't draw selection
			fontPickerPictureTools.SelectionChange(fontImage, (nextX + w) * AppConsts.CharWidth - 1, (nextY + h) * AppConsts.CharHeight - 1);

			picFont.Invalidate();

			var charVal = 0;
			if (clipboard.isValid)
			{
				charVal = clipboard.GetChar();
			}
			lblPickedChar.Text = $"Picked: ${charVal:X2} ({charVal}) {clipboard.Width}x{clipboard.Height}";
		}

	}
}
