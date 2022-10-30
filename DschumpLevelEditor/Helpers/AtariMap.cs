using System;
using System.Drawing;

namespace DschumpLevelEditor.Helpers
{
	[Serializable]
	public class AtariMap
	{
		private byte[] data;
		private Size screenSize;
		private Size dataSize;

		public AtariMap(Size screenSize)
		{
			dataSize = new Size(screenSize.Width, screenSize.Height);
			data = new byte[dataSize.Width * dataSize.Height];
			this.screenSize = screenSize;
		}

		public int Stride => screenSize.Width;

		public Size ScreenSize => screenSize;

		public byte[] Data
		{
			get => data;
			set => data = value;
		}
	}
}
