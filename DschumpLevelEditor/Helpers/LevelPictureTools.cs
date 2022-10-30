using DschumpLevelEditor.LevelParts;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace DschumpLevelEditor.Helpers
{
	class LevelPictureTools
	{
		private DschumpLevel Level { get; set; }
		
		//AtariMap levelMap;								// Where is the data coming from?
		Graphics gr;                                    // Drawing surface
		Rectangle mouseSelection = new Rectangle();
		private Bitmap destImage;						// The bitmap to draw to and to be displayed
		private Bitmap tilesImage;						// The bitmap with all the tiles (source of info)

		private Bitmap levelImage;						// Image with the current tiles drawn to it
		private Graphics grLevelImg;					// Draw to the level image

		Point prevMouseLoc;
		private static readonly Pen selectionPen = new Pen(Color.Lime);
		private static readonly Pen switchPen = new Pen(Color.White);
		private static readonly Pen startPen = new Pen(Color.Red);
		private static readonly Pen targetPen = new Pen(Color.Lime);
		private static readonly Color gridColor = Color.White;

		private static readonly Font drawFont = new Font("Arial", 6, FontStyle.Bold);
		private static readonly Font drawFont2 = new Font("Arial", 10, FontStyle.Italic);
		private static readonly SolidBrush drawBrush = new SolidBrush(Color.White);
		private static readonly SolidBrush drawBrush2 = new SolidBrush(Color.Yellow);
		private static readonly StringFormat drawFormat = new StringFormat();

		private const int tileWidth = 32;
		private const int tileHeight = 24;
		bool drawGrid = true;

		public LevelPictureTools(Bitmap destImage, Bitmap tilesImage, DschumpLevel level)
		{
			Level = level;
			//this.levelMap = levelMap;
			this.destImage = destImage;
			this.tilesImage = tilesImage;

			levelImage = new Bitmap(destImage.Width, destImage.Height);
			grLevelImg = Graphics.FromImage(levelImage);
			grLevelImg.InterpolationMode = InterpolationMode.NearestNeighbor;

			// Prepare the graphic for drawing
			gr = Graphics.FromImage(destImage);
			gr.InterpolationMode = InterpolationMode.NearestNeighbor;
		}

		public void SetLevelInfo(DschumpLevel level)
		{
			Level = level;
		}

		public Rectangle GetSelection()
		{
			return mouseSelection;
		}

		public void SetGridVisibility(bool drawGrid)
		{
			this.drawGrid = drawGrid;
		}

		public void SelectionStart(Point firstCorner, bool withDraw = true)
		{
			mouseSelection.X = firstCorner.X - (firstCorner.X % tileWidth);
			mouseSelection.Y = firstCorner.Y - (firstCorner.Y % tileHeight);
			mouseSelection.Width = tileWidth;
			mouseSelection.Height = tileHeight;
			if (withDraw) DrawSelection();
		}

		public void SelectionChange(Point newCorner)
		{
			SelectionChange(newCorner.X, newCorner.Y);
		}

		public void SelectionChange(int x, int y)
		{
			var mx = x - (x % tileWidth);
			var my = y - (y % tileHeight);

			if (mx - mouseSelection.X < 0)
			{
				mouseSelection.Width = mx - mouseSelection.X;
			}
			else
			{
				mouseSelection.Width = tileWidth + mx - mouseSelection.X;
			}

			if (my - mouseSelection.Y < 0)
			{
				mouseSelection.Height = my - mouseSelection.Y;

			}
			else
			{
				mouseSelection.Height = tileHeight + my - mouseSelection.Y;
			}

			if (mouseSelection.Width + mouseSelection.X > destImage.Width ||
				mouseSelection.Height + mouseSelection.Y > destImage.Height)
			{
				//selection out of bounds - do not copy, do not draw selection
				mouseSelection.Width = 0;
				mouseSelection.Height = 0;
			}

			Redraw();

			DrawSelection();
		}

		public bool SelectionEnd(AtariClipboard clipBoard, Bitmap dataImage)
		{
			return true;
		}

		public Point PreviousMouseLocation
		{
			get => prevMouseLoc;
			set => prevMouseLoc = value;
		}

		private void DrawSelection()
		{
			gr.DrawLine(selectionPen, mouseSelection.X, mouseSelection.Y, mouseSelection.X + mouseSelection.Width, mouseSelection.Y);
			gr.DrawLine(selectionPen, mouseSelection.X + mouseSelection.Width, mouseSelection.Y, mouseSelection.X + mouseSelection.Width, mouseSelection.Y + mouseSelection.Height);
			gr.DrawLine(selectionPen, mouseSelection.X, mouseSelection.Y + mouseSelection.Height, mouseSelection.X + mouseSelection.Width, mouseSelection.Y + mouseSelection.Height);
			gr.DrawLine(selectionPen, mouseSelection.X, mouseSelection.Y, mouseSelection.X, mouseSelection.Y + mouseSelection.Height);
		}

		public void ApplyLevelData()
		{
			byte[] data = Level.Map.Data;

			int LevelMapWidth = Level.Map.ScreenSize.Width;
			int LevelMapHeight = Level.Map.ScreenSize.Height;

			var srcR = new Rectangle(0, 0, 8 * 4, 8 * 3);
			var destR = new Rectangle(0, 0, 8 * 4, 8 * 3);

			for (var y = 0; y < LevelMapHeight; ++y)
			{
				destR.Y = y * 24;
				for (var x = 0; x < LevelMapWidth - 1; ++x)
				{
					destR.X = x * 32;

					int tileNr = data[x + y * LevelMapWidth];

					// Copy from tilesImage (8x8) tiles
					srcR.X = (tileNr % 8) * 32;
					srcR.Y = (tileNr / 8) * 24;

					grLevelImg.DrawImage(tilesImage, destR, srcR, GraphicsUnit.Pixel);
				}
			}
		}

		public void Redraw()
		{
			Redraw(levelImage, true, drawGrid);
		}

		public void Redraw(Bitmap dataImage, bool drawData, bool drawGrid)
		{
			if (drawData)
				gr.DrawImage(dataImage, 0, 0, dataImage.Width, dataImage.Height);

			// grid
			if (drawGrid)
			{
				for (var x = 0; x < (destImage.Size.Width / tileWidth); x++)
				{
					for (var y = 0; y < (destImage.Size.Height / tileHeight); y++)
					{
						if (x < Level.Map.Stride && y < Level.Map.ScreenSize.Height)
						{
							destImage.SetPixel(x * tileWidth, y * tileHeight, gridColor);
						}
					}
				}
			}
		}

		public void DrawCursor(Point location, Bitmap cursorImage)
		{
			Redraw();

			var srcR = new Rectangle(0, 0, 8 * 4*2, 8 * 3*2);
			var destR = new Rectangle(location.X, location.Y, 8 * 4, 8 * 3);

			gr.DrawImage(cursorImage, destR, srcR, GraphicsUnit.Pixel);
		}

		public void DrawHighlight(Point location)
        {
			Redraw();

			var rect = new Rectangle(location.X, location.Y, 8 * 4, 8 * 3);
			gr.DrawLine(selectionPen, rect.X, rect.Y, rect.X + rect.Width, rect.Y);
			gr.DrawLine(selectionPen, rect.X + rect.Width, rect.Y, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(selectionPen, rect.X, rect.Y + rect.Height, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(selectionPen, rect.X, rect.Y, rect.X, rect.Y + rect.Height);
		}

		public void DrawSwitchPosition(Point location)
        {
			var rect = new Rectangle(location.X, location.Y, 8 * 4, 8 * 3);
			gr.DrawLine(switchPen, rect.X, rect.Y, rect.X + rect.Width, rect.Y);
			gr.DrawLine(switchPen, rect.X + rect.Width, rect.Y, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(switchPen, rect.X, rect.Y + rect.Height, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(switchPen, rect.X, rect.Y, rect.X, rect.Y + rect.Height);
		}

		public void DrawSwitchTargetLocation(Point location, Bitmap cursorImage = null)
		{
			var srcR = new Rectangle(0, 0, 8 * 4 * 2, 8 * 3 * 2);
			var rect = new Rectangle(location.X, location.Y, 8 * 4, 8 * 3);
			if (cursorImage != null) 
				gr.DrawImage(cursorImage, rect, srcR, GraphicsUnit.Pixel);

			gr.DrawLine(targetPen, rect.X, rect.Y, rect.X + rect.Width, rect.Y);
			gr.DrawLine(targetPen, rect.X + rect.Width, rect.Y, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(targetPen, rect.X, rect.Y + rect.Height, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(targetPen, rect.X, rect.Y, rect.X, rect.Y + rect.Height);
		}

		public void LinkSwitchPositionWithTarget(DschumpSwitch theSwitch)
		{
			var posXf = theSwitch.Position % 8;
			var posYf = theSwitch.Position / 8;

			var posXt = theSwitch.Target % 8;
			var posYt = theSwitch.Target / 8;

			gr.DrawLine(targetPen, posXf * 32 + 16, posYf * 24 + 12, posXt * 32 + 16, posYt * 24 + 12);

		}

		/// <summary>
		/// Draw a worm hole. In -> Out
		/// </summary>
		/// <param name="wormhole"></param>
		public void DrawWormhole(DschumpWormhole wormhole, bool withDetails)
		{
			if (wormhole == null) return;

			var srcX = (wormhole.In % 8) * 32 + 16;
			var srcY = (wormhole.In / 8) * 24 + 12;

			var destX = (wormhole.Out % 8) * 32 + 16;
			var destY = (wormhole.Out / 8) * 24 + 12;

			gr.DrawEllipse(switchPen, srcX-8, srcY-6, 16, 12);
			DrawText("IN", srcX-16, srcY-12);

			gr.DrawLine(switchPen, srcX, srcY, destX, destY);
			DrawText("OUT", destX-8, destY);

			if (withDetails)
			{
				DrawText2($"{wormhole.In}", srcX - 16, srcY - 2);
				DrawText2($"{wormhole.Out}", destX - 16, destY - 12);
			}
		}

		public void DrawStart(int start)
        {
			return;
			int position = 41 * 8 + start;
			
			var posX = position % 8;
			var posY = position / 8;
			Point location = new Point(posX * 32, posY * 24);

			var rect = new Rectangle(location.X, location.Y, 8 * 4, 8 * 3);
			gr.DrawLine(startPen, rect.X, rect.Y, rect.X + rect.Width, rect.Y);
			gr.DrawLine(startPen, rect.X + rect.Width, rect.Y, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(startPen, rect.X, rect.Y + rect.Height, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(startPen, rect.X, rect.Y, rect.X, rect.Y + rect.Height);
			gr.DrawLine(startPen, rect.X, rect.Y, rect.X + rect.Width, rect.Y + rect.Height);
			gr.DrawLine(startPen, rect.X, rect.Y + rect.Height, rect.X + rect.Width, rect.Y);
		}

		public void DrawStartScreen(int top, int direction, int startX, int startY)
		{
			// Screen is 7 tiles high
			// Draw the screen position plus the start direction arrow
			var rect = new Rectangle(0, top * 8 * 3, 7 * 8 * 4 - 1, 7 * 8 * 3 - 1);

			gr.DrawLine(startPen, rect.X, rect.Y, rect.X + rect.Width, rect.Y); // top
			gr.DrawLine(startPen, rect.X + rect.Width, rect.Y, rect.X + rect.Width, rect.Y + rect.Height); // right
			gr.DrawLine(startPen, rect.X, rect.Y + rect.Height, rect.X + rect.Width, rect.Y + rect.Height); // bottom
			gr.DrawLine(startPen, rect.X, rect.Y, rect.X, rect.Y + rect.Height); // left

			if (direction == 1)
			{
				gr.DrawLine(startPen, rect.X, rect.Y, rect.X + rect.Width / 2, rect.Y + rect.Height / 2);
				gr.DrawLine(startPen, rect.X + rect.Width, rect.Y, rect.X + rect.Width / 2, rect.Y + rect.Height / 2);
			}
			else if (direction == 0)
			{
				gr.DrawLine(startPen, rect.X, rect.Y + rect.Height, rect.X + rect.Width / 2, rect.Y + rect.Height / 2);
				gr.DrawLine(startPen, rect.X + rect.Width, rect.Y + rect.Height, rect.X + rect.Width / 2, rect.Y + rect.Height / 2);
			}

			// Draw the ball start position within the start screen
			// x & y are in screen co-ordinates
			int position = (top + startY) * 8 + startX;

			var posX = position % 8;
			var posY = position / 8;
			Point location = new Point(posX * 32, posY * 24);

			var rect2 = new Rectangle(location.X, location.Y, 8 * 4 - 1, 8 * 3 - 1);

			gr.DrawLine(startPen, rect2.X, rect2.Y, rect2.X + rect2.Width, rect2.Y);
			gr.DrawLine(startPen, rect2.X + rect2.Width, rect2.Y, rect2.X + rect2.Width, rect2.Y + rect2.Height);
			gr.DrawLine(startPen, rect2.X, rect2.Y + rect2.Height, rect2.X + rect2.Width, rect2.Y + rect2.Height);
			gr.DrawLine(startPen, rect2.X, rect2.Y, rect2.X, rect2.Y + rect2.Height);
			gr.DrawLine(startPen, rect2.X, rect2.Y, rect2.X + rect2.Width, rect2.Y + rect2.Height);
			gr.DrawLine(startPen, rect2.X, rect2.Y + rect2.Height, rect2.X + rect2.Width, rect2.Y);
		}

		public void ShowPossibleWarp(DschumpWormhole wormhole)
		{
			if (wormhole == null) return;
			var srcX = (wormhole.In % 8) * 32 + 16;
			var srcY = (wormhole.In / 8) * 24 + 12;

			
			DrawText2($"{wormhole.In}", srcX - 16, srcY - 2);
		}

		public void DrawText(string txt, int x, int y)
		{
			gr.DrawString(txt, drawFont, drawBrush, x, y, drawFormat);
		}

		public void DrawText2(string txt, int x, int y)
		{
			gr.DrawString(txt, drawFont2, drawBrush2, x, y, drawFormat);
		}

	}
}
