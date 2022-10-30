using DschumpLevelEditor.Definitions;
using DschumpLevelEditor.Helpers;
using System;
using System.Drawing;
using System.Text;

namespace DschumpLevelEditor.LevelParts
{
	[Serializable]
	public class DschumpTiles
	{
		public DschumpTiles()
		{
			Names = new string[64];
			Names[0] = "Blank";
			for (var i = 1; i < 64; ++i)
			{
				Names[i] = "Free";
			}

			Valid = new bool[64];
			IsSwitch = new bool[64];
			IsExit = new bool[64];

			Map = new AtariMap(new Size(AppConsts.TilesMapWidth, AppConsts.TilesMapHeight));
		}

		public void Copy(DschumpTiles from)
		{
			for (var i = 0; i < 64; ++i)
			{
				Names[i] = from.Names[i];
				Valid[i] = from.Valid[i];
				IsSwitch[i] = from.IsSwitch[i];
				IsExit[i] = from.IsExit[i];
			}

			for (var i = 0; i < Map.Data.Length; ++i)
				Map.Data[i] = from.Map.Data[i];
		}

		/// <summary>
		/// Export the tile information in the Dschump tiles.asm format
		/// </summary>
		/// <returns></returns>
		public string ExportToAsm()
		{
			var sb = new StringBuilder("; Dschump 4x3 tiles", 32768);
			sb.AppendLine("; Action tiles");
			// Export the reference table for 32 action tiles
			sb.Append("tiles:"); 
			
			for (var tileNr = 0; tileNr < 32; ++tileNr)
			{
				if (tileNr % 4 == 0)
				{
					sb.AppendLine();
					sb.Append("\t\t\t.word ");
				}
				if (Valid[tileNr])
				{
					sb.Append($"tile{tileNr},");
				}
				else
					sb.Append("0,");
				
			}
			sb.AppendLine();
			// Export the build tiles (until we hit the first invalid tile)
			sb.Append("; Build tiles: 32 ...");
			for (var tileNr = 32; tileNr < 64; ++tileNr)
			{
				if (Valid[tileNr])
				{
					if (tileNr % 4 == 0)
					{
						sb.AppendLine();
						sb.Append("\t\t\t.word ");
					}
					sb.Append($"build{tileNr},");
				}
				else
					break;
			}
			sb.AppendLine();
			sb.AppendLine(";");
			sb.AppendLine("; What chars make up the individual tiles ?");
			sb.AppendLine("; Two types of tiles:");
			sb.AppendLine("; 1.Action tiles - these do something when you land on them");
			sb.AppendLine("; 2.Build tiles - just decoration");
			sb.AppendLine(";");
			sb.AppendLine("; Action tiles");
			// Export the tile definitions
			for (var tileNr = 0; tileNr < 32; ++tileNr)
			{
				if (Valid[tileNr])
				{
					sb.Append($"tile{tileNr}\t.byte\t");
					sb.AppendLine(GetTileDesc(tileNr));
				}
			}
			sb.AppendLine("; Build tiles: 32 ...");
			for (var tileNr = 32; tileNr < 64; ++tileNr)
			{
				if (Valid[tileNr])
				{
					sb.Append($"build{tileNr}\t.byte\t");
					sb.AppendLine(GetTileDesc(tileNr));
				}
				else
					break;
			}
			return sb.ToString();
		}

		/// <summary>
		/// 12 bytes (x,y,...,z) ; tile description
		/// Copy the tile data from the (8*4) x (8*3) grid
		/// 64 tiles in a 8 x 8 grid (offset by *4,*3)
		/// </summary>
		/// <param name="tileNr"></param>
		/// <returns></returns>
		private string GetTileDesc(int tileNr)
		{
			var posX = (tileNr % 8) * 4;
			var posY = (tileNr / 8);
			var offset = (posX + posY * 3 * 8 * 4);
			var data = Map.Data;

			var tile = new byte[12]
			{
				data[offset], data[offset+1], data[offset+2], data[offset+3],
				data[offset+8*4], data[offset+8*4+1], data[offset+8*4+2], data[offset+8*4+3],
				data[offset+8*4*2], data[offset+8*4*2+1], data[offset+8*4*2+2], data[offset+8*4*2+3],
			};

			var leftPart = $"{tile[0]},{tile[1]},{tile[2]},{tile[3]}, {tile[4]},{tile[5]},{tile[6]},{tile[7]}, {tile[8]},{tile[9]},{tile[10]},{tile[11]}";
			var repeatCnt = (60 - leftPart.Length) / 4 - 1*(((60 - leftPart.Length) % 4) == 0?1:0);
			var padding = new String('\t', repeatCnt);
			return $"{leftPart}{padding}; #{tileNr} {Names[tileNr]}";
		}

		public string[] Names { get; set; }

		public bool[] Valid { get; set; }
		public bool[] IsSwitch { get; set; }

		public bool[] IsExit { get; set; }
		public AtariMap Map { get; set; }
	}
}
