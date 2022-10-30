namespace DschumpLevelEditor.Definitions
{
	public class AppConsts
	{
		public const int TileZoomLevel = 2;
		public const int CharWidth = 8 * TileZoomLevel;
		public const int CharHeight = 8 * TileZoomLevel;
		public const int TilesMapWidth = 8 * 4;
		public const int TilesMapHeight = 8 * 3;
		public const int TilesBitmapWidth = TilesMapWidth * CharWidth;
		public const int TilesBitmapHeight = TilesMapHeight * CharHeight;


		public const int LevelMapWidth = 8;
		public const int LevelMapHeight = 42;
		public const int LevelBitmapWidth = (LevelMapWidth-1) * 4 * 8;
		public const int LevelBitmapHeight = LevelMapHeight * 3 * 8;

		public const int FontMapWidth = 16;
		public const int FontMapHeight = 16;
		public const int FontBitmapWidth = FontMapWidth * CharWidth;
		public const int FontBitmapHeight = FontMapHeight * CharHeight;

		public const int CurrentTileWidth = 4 * CharWidth;
		public const int CurrentTileHeight = 3 * CharWidth;

		public const int NumSwitches = 16;
		public const int NumWormholes = 8;

		public const int WormholeTileNr = 1;

	}
}
