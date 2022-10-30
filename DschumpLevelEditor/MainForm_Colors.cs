using DschumpLevelEditor.Definitions;
using DschumpLevelEditor.Helpers;
using System;
using System.Drawing;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
	// Dummy definition to fool the editor into thinking that this is not a dialog.
	// Otherwise we get a resource conflict
	public class MainForm_Colors{ }
	public partial class MainForm
	{

		private void FillFontColorList()
		{
			listView_Colors.Clear();
			listView_Colors.LargeImageList = GetFontColorImageList(fontRenderer.Color5);
			listView_Colors.Columns.Add("Color");
			listView_Colors.Columns.Add("Shadow");
			listView_Colors.Columns.Add("Address");
			listView_Colors.SmallImageList = listView_Colors.LargeImageList;
			for (var i = 0; i < 5; i++)
			{
				ListViewItem lvi = new ListViewItem();
				lvi.Text = "COLPF" + i.ToString();
				if (i == 4)
					lvi.Text = "COLBAK";
				lvi.SubItems.Add($"${(708 + i):X4}");
				lvi.SubItems.Add($"${(0xd016 + i):X4}");
				lvi.ImageIndex = i;
				listView_Colors.Items.Add(lvi);
			}
			listView_Colors.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
			listView_Colors.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_Colors.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
		}

		private ImageList GetFontColorImageList(byte[] color5)
		{
			var il = new ImageList();
			var size = new Size(30, 20);
			il.ImageSize = size;
			for (var i = 0; i < 5; i++)
			{
				var bmp = new Bitmap(size.Width, size.Height);
				var gr = Graphics.FromImage(bmp);
				gr.Clear(myPalette.GetColor(color5[i]));
				il.Images.Add(bmp);

			}
			return il;
		}
		/// <summary>
		/// Change a color value
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listView_Colors_MouseDoubleClick(object sender, MouseEventArgs e)
		{
			if (listView_Colors.SelectedItems.Count == 1)
			{
				var colorIndex = listView_Colors.SelectedItems[0].Index;

				var index = fontRenderer.Color5[colorIndex];
				colorPicker.TopMost = true;
				colorPicker.Pick(index);                // Select a new color

				// Assign the new color value
				fontRenderer.Color5[colorIndex] = (byte)colorPicker.PickedColorIndex();         // Update the color in the font renderer

				FillFontColorList();                    // Update the gui
				fontRenderer.RedrawFont();

				picLevel.Invalidate();

				fontImage = new Bitmap(picFont.Width, picFont.Height);
				fontRenderer.RenderData(fontMap, fontImage);       // Draw the characters to the fontImage

				fontPickerPictureTools = new AtariPictureTools((Bitmap)picFont.Image, fontRenderer, fontMap, AppConsts.TileZoomLevel);
				fontPickerPictureTools.Redraw(fontImage);
				//myCharPicker.GetRenderer().RedrawFont();
				//myCharPicker.RedrawFontWindow();
				//RedrawTilesWindow();

			}
		}

		private void listView_Colors_MouseLeave(object sender, EventArgs e)
		{
			for (int a = 0; a < listView_Colors.Items.Count; a++)
			{
				listView_Colors.Items[a].Selected = false;
			}
		}
	}
}
