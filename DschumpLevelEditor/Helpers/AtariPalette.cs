using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace DschumpLevelEditor.Helpers
{
	[Serializable]
	public class AtariPalette
	{
		[NonSerialized]
		private ColorPalette myPalette;

		public AtariPalette()
		{
			Bitmap bmp = new Bitmap(1, 1, PixelFormat.Format8bppIndexed);
			myPalette = bmp.Palette;
			bmp.Dispose();
		}
		public ColorPalette GetPalette()
		{
			return this.myPalette;
		}

		public Color GetColor(int index)
		{
			return myPalette.Entries[index];
		}

		public int Load(String filename)
		{
			byte[] rawdata = new byte[768];
			FileStream fs;
			try
			{
				fs = new FileStream(filename, FileMode.Open);
			}
			catch (FileNotFoundException ex)
			{
				Console.Write(ex.Message);
				return 12;
			}
			try
			{
				fs.Read(rawdata, 0, 768);
			}
			catch (FileLoadException ex)
			{
				Console.Write(ex.Message);
				return 8;
			}
			fs.Close();

			for (var a = 0; a < 256; a++)
			{
				myPalette.Entries[a] = Color.FromArgb(255, rawdata[a * 3], rawdata[a * 3 + 1], rawdata[a * 3 + 2]);
			}
			return 0; //ok
		}
    }
}
