﻿using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace DschumpLevelEditor.Helpers
{
	public class AtariFontRenderer
	{
		private byte[] fontData;
		private Bitmap fontBmp;
		private AtariPalette myPalette;
		private byte[] color5 = { 0x08, 0x0C, 0x76, 0xA4, 0 };
		public int offset = 0;
		private int offsetX = 0, offsetY = 0;
		private bool graphicsMode = true;

		private Bitmap blitterBmp;

		public AtariFontRenderer()
		{
			fontData = new byte[2048];
			this.LoadFont("default.fnt");
		}

		public AtariFontRenderer(String fontName)
		{
			fontData = new byte[2048];
			this.LoadFont(fontName);
		}

		public int OffsetX => this.offsetX;

		public int OffsetY => this.offsetY;

		public byte[] Color5
		{
			get => color5;
			set => color5 = value;
		}
		
		/// <summary>
		/// Load the font data
		/// 1024 bytes (128 char @ 8 bytes each)
		/// 
		/// </summary>
		/// <param name="fontFilename"></param>
		public void LoadFont(string fontFilename)
		{
			var fs = new FileStream(fontFilename, FileMode.Open);
			fs.Read(fontData, 0, 1024);
			fs.Close();
			// Create the inverse version of the characters
			for (var a = 0; a < 1024; a++)
			{
				fontData[a + 1024] = (byte)(fontData[a] ^ 0xFF);
			}
		}

		public void SetPalette(AtariPalette yourPalette)
		{
			this.myPalette = yourPalette;
			RedrawFont();
		}

		public void RedrawFont()
		{
			CreateFontImage(this.graphicsMode);
		}
		
		// 8bpp indexed
		private void CreateFontImage(bool colorMode) // 2 or 4
		{
			// Create a bitmap 256 8x8 chars wide
			// and draw the characters to it.
			fontBmp = new Bitmap(256 * 8, 8, PixelFormat.Format8bppIndexed);
			fontBmp.Palette = myPalette.GetPalette();

			BitmapData bmd = fontBmp.LockBits(new Rectangle(0, 0, 8 * 256, 8), System.Drawing.Imaging.ImageLockMode.WriteOnly, fontBmp.PixelFormat);

			for (var y = 0; y < bmd.Height; y++)
			{
				unsafe
				{
					byte* row = (byte*)bmd.Scan0 + (y * bmd.Stride);

					if (colorMode)
					{
						//color gr.12 (dl 4)
						for (int x = 0; x < (bmd.Stride >> 3); x++)
						{
							byte value = fontData[((x << 3) + y) % 1024]; // /8 
							byte point;
							for (byte o = 3; o != 255; o--)
							{
								point = (byte)((value & 0x03) - 1);
								value >>= 2;
								if (point == 255)
									point = 4;
								if (x > 127 && point == 2)
									point = 3;

								row[(x << 3) + (o << 1)] = color5[point];
								row[(x << 3) + (o << 1) + 1] = color5[point];
							}
						}
					}
					else
					{
						//mono gr.0 (dl 2)
						for (int x = 0; x < (bmd.Stride >> 3); x++) // /8
						{
							byte value = fontData[(x << 3) + y]; // /8 
							byte point;
							for (byte o = 7; o != 255; o--)
							{
								point = (byte)(value & 0x01);
								value >>= 1;
								row[(x << 3) + o] = color5[point];
							}
						}
					}
				}

			}
			fontBmp.UnlockBits(bmd);

			// Create the fast access blitter bitmap that we will render from
			blitterBmp = new Bitmap(fontBmp.Width, fontBmp.Height);
			using (Graphics g = Graphics.FromImage(blitterBmp))
			{
				g.DrawImage(fontBmp, 0, 0);
			}
		}

		public void RenderData(AtariMap myMap, Bitmap bmp)
		{
			int adrOffset = 0;
			byte[] data = myMap.Data;

			if (adrOffset < 0)
			{
				return;
			}

			int width = bmp.Width / 8;
			int height = bmp.Height / 8;

			if (offsetX + width > myMap.Stride)
				width = myMap.Stride - offsetX;
			if (offsetY + height > myMap.ScreenSize.Height)
				height = myMap.ScreenSize.Height - offsetY;

			//Bitmap bmp = new Bitmap(bmpSize.Width, bmpSize.Height, PixelFormat.Format8bppIndexed);
			bmp.Palette = myPalette.GetPalette();
			BitmapData bmd = bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), ImageLockMode.WriteOnly, PixelFormat.Format8bppIndexed);
			BitmapData fntd = fontBmp.LockBits(new Rectangle(0, 0, fontBmp.Width, fontBmp.Height), ImageLockMode.ReadOnly, PixelFormat.Format8bppIndexed);
			int index;

			unsafe
			{
				byte* row = (byte*)bmd.Scan0;
				for (int y = 0; y < height; y++)
				{
					byte* fntRow = (byte*)fntd.Scan0;
					for (int scln = 0; scln < 8; scln++)
					{
						for (int x = 0; x < width; x++)
						{
							index = adrOffset + x; // +y * width; //index znaku co sa ma kreslit v data
							for (int c = 0; c < 8; c++)
								row[x * 8 + c] = (index < data.Length) ? (fntRow[data[index] * 8 + c]) : (byte)0;
						}
						fntRow += fntd.Stride;
						row += bmd.Stride;
					}
					adrOffset += myMap.Stride;
				}
			}
			fontBmp.UnlockBits(fntd);
			bmp.UnlockBits(bmd);
		}
	}
}
