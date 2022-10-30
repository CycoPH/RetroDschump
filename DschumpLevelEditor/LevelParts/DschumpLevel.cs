using DschumpLevelEditor.Definitions;
using DschumpLevelEditor.Helpers;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace DschumpLevelEditor.LevelParts
{
	[Serializable]
	public class DschumpLevel
	{
		const int LevelHeight = 42;             // How many lines in a level: 42 tiles @ 3 lines each = 126 lines
		const int ScreenHeight = 7;				// How many line fit onto the screen
		public DschumpLevel(int levelNr)
		{
			LevelNr = levelNr;
			Map = new AtariMap(new Size(AppConsts.LevelMapWidth, AppConsts.LevelMapHeight));

			Wormholes = new Dictionary<int, DschumpWormhole>(AppConsts.NumWormholes);

			Switches = new Dictionary<int, DschumpSwitch>(AppConsts.NumSwitches);

			StartX = 3;			// 0=left, 3=middle, 6=right
			StartY = 6;			// 0=top, 6=bottom
			ScreenTop = LevelHeight - ScreenHeight;
			Direction = 0;		// 0 = up, 1 = down

			LevelHint1 = "";
			LevelHint2 = "";
		}

		public int LevelNr { get; set; }
		public AtariMap Map { get; set; }

		public Dictionary<int, DschumpSwitch> Switches { get; set; }

		public Dictionary<int, DschumpWormhole> Wormholes { get; set; }

		/// <summary>
		/// On which tile in the x-position is the ball starting
		/// </summary>
		public int StartX { get; set; }
		public int StartY { get; set; }

		public int ScreenTop { get; set; }
		public int Direction { get; set; }

		/// <summary>
		/// Level hint is split over two lines first is 21 chars, second is 32 chars (53 chars in total)
		/// </summary>
		public string LevelHint1 { get; set; }
		public string LevelHint2 { get; set; }

		/// <summary>
		/// Export the tile information in the Dschump level.asm format
		/// </summary>
		/// <returns>(string with asm, length of the binary data)</returns>
		public (string, int) ExportToAsm(bool compress, bool useZX5)
		{
			if (compress) return ExportCompressed(useZX5);
			//
			// Export uncompressed assembler
			//
			var sb = new StringBuilder("*=$7000", 32768);
			sb.AppendLine();
			sb.AppendLine("; Each level takes:");
			sb.AppendLine("; 336 bytes - level data(8 * 42)");
			sb.AppendLine("; 32 bytes - switch position table(16 * 2 bytes per position)");
			sb.AppendLine("; 32 bytes - switch target position table(16 * 2 bytes per position)");
			sb.AppendLine("; 16 bytes - switch action table(which tile is being switched in)");
			sb.AppendLine("; 16 bytes - wormhole in position(8 * 2 byte per position)");
			sb.AppendLine("; 16 bytes - wormhole out position(8 * 2 byte per position)");
			sb.AppendLine("; 1 byte - start position (0-6) @ byte 7 of the level");
			sb.AppendLine("; 64 bytes - level hint");
			sb.AppendLine("; 512 bytes in total");
			sb.AppendLine("Level:");

			var data = Map.Data;
			for (var line = 0; line < AppConsts.LevelMapHeight; ++line)
			{
				sb.Append("\t\t.byte ");
				var from = line * AppConsts.LevelMapWidth;

				for (var x = 0; x < AppConsts.LevelMapWidth; ++x, ++from)
				{
					if (line == 0 && x == 7)
					{
						sb.Append($"{StartX},");
					}
					else if (line == 1 && x == 7)
					{
						sb.Append($"{StartY},");
					}
					else if (line == 2 && x == 7)
					{
						sb.Append($"{ScreenTop*3},");
					}
					else if (line == 3 && x == 7)
					{
						sb.Append($"{ ( (Direction == 0) ? -1 : 1)},");
					}
					else
					{
						sb.Append($"{data[from],2},");
					}
				}
				if (line % 4 == 0)
				{
					sb.Append($"\t\t; {line}");
				}
				sb.AppendLine();
			}

			var (theSwitches, theWormholes) = GetActions();

			// Export the switches
			// 1. The switch position list
			sb.AppendLine();
			sb.AppendLine("; 16 switch positions (32 bytes)");
			sb.AppendLine("SwitchPositions:");
			sb.Append("\t\t.word ");
			int swIndex = 0;
			foreach (var oneSwitch in theSwitches)
			{
				sb.Append($"{oneSwitch.Position,3},");
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				sb.Append("-1,");
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				while (swIndex < AppConsts.NumSwitches)
				{
					sb.Append("0,");
					++swIndex;
				}
			}
			sb.AppendLine();
			// 2. The switch target location list
			sb.AppendLine();
			sb.AppendLine("; 16 switch target positions(32 bytes)");
			sb.AppendLine("SwitchTarget:\t\t; x,y - 1 to terminate list");
			sb.Append("\t\t.word ");
			swIndex = 0;
			foreach (var oneSwitch in theSwitches)
			{
				sb.Append($"{oneSwitch.Target,3},");
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				while (swIndex < AppConsts.NumSwitches)
				{
					sb.Append("0,");
					++swIndex;
				}
			}
			sb.AppendLine();

			// 3. The switch WhatTile list
			sb.AppendLine();
			sb.AppendLine(";16 switch tile nr(these are the items that will be inserted into the map)");
			sb.AppendLine("SwitchWhat:\t\t; 16 bytes");
			swIndex = 0;
			sb.Append("\t\t.byte ");
			foreach (var oneSwitch in theSwitches)
			{
				sb.Append($"{oneSwitch.What},");
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				while (swIndex < AppConsts.NumSwitches)
				{
					sb.Append("0,");
					++swIndex;
				}
			}
			sb.AppendLine();

			// Export the wormholes
			// Now add the wormholes to the level
			sb.AppendLine();
			sb.AppendLine("; 8 wormhole in positions (16 bytes)");
			sb.AppendLine("WormholeIn:");
			sb.Append("\t\t.word ");
			int whIndex = 0;
			foreach (var oneWarp in theWormholes)
			{
				sb.Append($"{oneWarp.In},");
				++whIndex;
			}
			if (whIndex < AppConsts.NumWormholes)
			{
				sb.Append("-1,");
				++whIndex;
			}
			if (whIndex < AppConsts.NumWormholes)
			{
				while (whIndex < AppConsts.NumWormholes)
				{
					sb.Append("0,");
					++whIndex;
				}
			}
			sb.AppendLine();

			sb.AppendLine();
			sb.AppendLine("; 8 wormhole out positions (16 bytes)");
			sb.AppendLine("WormholeOut:");
			sb.Append("\t\t.word ");
			whIndex = 0;
			foreach (var oneWarp in theWormholes)
			{
				sb.Append($"{oneWarp.Out},");
				++whIndex;
			}
			if (whIndex < AppConsts.NumWormholes)
			{
				while (whIndex < AppConsts.NumWormholes)
				{
					sb.Append("0,");
					++whIndex;
				}
				sb.AppendLine();
			}
			sb.AppendLine();
			//sb.AppendLine("StartPosition:");
			//sb.AppendLine($"\t\t.byte {Start}");
			sb.AppendLine("LevelHint:");
			var hint = GetLevelHintBytes();
			sb.Append("\t\t.byte ");
			for (var i = 0; i < hint.Length; i++)
			{
				sb.Append($"{hint[i]},");
			}
			sb.AppendLine();

			return (sb.ToString(), 502);
		}

		/// <summary>
		/// Compress the level data and return the asm code and the final binary length
		/// </summary>
		/// <param name="useZX5">True if ZX5 should be used for the data compression</param>
		/// <returns>(string with compressed assembler bytes, length of compressed level)</returns>
		private (string, int) ExportCompressed(bool useZX5)
		{
			var lvlOrig = BuildLevelBytes();
			var lvl = WriteCompressReload(lvlOrig, useZX5);

			if (lvl == null)
				return (null, 0);

			var sb = new StringBuilder($"; Level {LevelNr} is {lvl.Length}/{lvlOrig.Length} bytes long via {(useZX5 ? "zx5": "zopfli")}", 32768);
			sb.AppendLine();
			sb.AppendLine($"Level{LevelNr}");

			// Write the compressed data to the string
			for (var i = 0; i < lvl.Length; ++i)
			{
				if (i % 8 == 0)
				{
					if (i > 0)
					{
						sb.AppendLine();
					}
					sb.Append("\t\t.byte ");
				}
				sb.Append($"{lvl[i]},");
			}
			sb.AppendLine();
			return (sb.ToString(), lvl.Length);
		}

		private byte[] BuildLevelBytes()
		{
			int levelIndex = 0;
			int levelLength =
				AppConsts.LevelMapHeight * AppConsts.LevelMapWidth
			   + 2 * AppConsts.NumSwitches          // Switch positions
			   + 2 * AppConsts.NumSwitches          // Switch targets
			   + AppConsts.NumSwitches              // Switch action tile #
			   + 2 * AppConsts.NumWormholes         // Wormhole in
			   + 2 * AppConsts.NumWormholes         // Wormhole out
			   //+ 1									// Start position (values 0-6)
			   + 64									// Level hint
			   ;

			var lvl = new byte[levelLength];

			var (theSwitches, theWormholes) = GetActions();

			// Copy the level bytes
			Map.Data.CopyTo(lvl, levelIndex);
			levelIndex += Map.Data.Length;      // 336

			// Copy the switch config
			// SwitchPositions: 16x2 bytes
			var swIndex = 0;
			foreach (var oneSwitch in theSwitches)
			{
				CPU6502.Word(lvl, levelIndex, oneSwitch.Position);
				levelIndex += 2;
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				CPU6502.Word(lvl, levelIndex, -1);
				levelIndex += 2;
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				levelIndex += (AppConsts.NumSwitches - swIndex) * 2;
			}

			// SwitchPositions: 16x2 bytes
			swIndex = 0;
			foreach (var oneSwitch in theSwitches)
			{
				CPU6502.Word(lvl, levelIndex, oneSwitch.Target);
				levelIndex += 2;
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				CPU6502.Word(lvl, levelIndex, -1);
				levelIndex += 2;
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				levelIndex += (AppConsts.NumSwitches - swIndex) * 2;
			}

			// The switch WhatTile list
			swIndex = 0;
			foreach (var oneSwitch in theSwitches)
			{
				CPU6502.Byte(lvl, levelIndex, oneSwitch.What);
				++levelIndex;
				++swIndex;
			}
			if (swIndex < AppConsts.NumSwitches)
			{
				levelIndex += (AppConsts.NumSwitches - swIndex);
			}

			// Export the wormholes
			var whIndex = 0;
			// List of In positions
			foreach (var oneWarp in theWormholes)
			{
				CPU6502.Word(lvl, levelIndex, oneWarp.In);
				levelIndex += 2;
				++whIndex;
			}
			if (whIndex < AppConsts.NumWormholes)
			{
				CPU6502.Word(lvl, levelIndex, -1);
				levelIndex += 2;
				++whIndex;
			}
			if (whIndex < AppConsts.NumWormholes)
			{
				levelIndex += (AppConsts.NumWormholes - whIndex) * 2;
			}
			// List of out positions
			whIndex = 0;
			foreach (var oneWarp in theWormholes)
			{
				CPU6502.Word(lvl, levelIndex, oneWarp.Out);
				levelIndex += 2;
				++whIndex;
			}
			if (whIndex < AppConsts.NumWormholes)
			{
				levelIndex += (AppConsts.NumWormholes - whIndex) * 2;
			}
			// Start position of the ball
			CPU6502.Byte(lvl, 0 * 8 + 7, StartX);
			CPU6502.Byte(lvl, 1 * 8 + 7, StartY);
			CPU6502.Byte(lvl, 2 * 8 + 7, ScreenTop*3);
			CPU6502.Byte(lvl, 3 * 8 + 7, Direction == 0 ? -1 : 1);

			// Level hint (64 bytes)
			var hint = GetLevelHintBytes();
			for (var i = 0; i < hint.Length; ++i)
			{
				CPU6502.Byte(lvl, levelIndex, hint[i]);
				++levelIndex;
			}

			if (levelIndex != levelLength)
			{
				MessageBox.Show("Warning: Incorrect binary level data");
			}

			return lvl;
		}

		/// <summary>
		/// Get the switches and warp information.
		/// </summary>
		/// <returns></returns>
		private (DschumpSwitch[], DschumpWormhole[]) GetActions()
		{
			var theSwitches = Switches.Values.ToArray();
			// Sort them
			Array.Sort(theSwitches, new SwitchComparer());

			// Only get the wormholes that are "real", skip the exit only holes
			var theWormholes = Wormholes.Values
				.Where(w => w.ExitOnly == false)
				.Where(w =>
				{
					var foundExit = Wormholes.TryGetValue(w.Out, out var _);
					if (w.Out == 0)
					{
						return false;
					}
					else if (!foundExit)
					{
						return false;
					}
					return true;
				})
				.ToArray();
			// 1. Sort them
			Array.Sort(theWormholes, new WormholeComparer());

			return (theSwitches, theWormholes);
		}

		private byte[] GetLevelHintBytes()
		{
			// 64 bytes of level hint
			var hint = new byte[64];
			for (var i = 0; i < 64; ++i)
			{
				hint[i] = (byte)' ';
			}
			// Copy the 1st line
			for (var i = 0; i < 32 && i < LevelHint1.Length; ++i)
				hint[i] = (byte)LevelHint1[i];
			// Copy the 2nd line
			for (var i = 0; i < 32 && i < LevelHint2.Length; ++i)
				hint[32+i] = (byte)LevelHint2[i];

			for (var i = 0; i < 64; ++i)
				hint[i] = MapToAtari[hint[i]];

			return hint;
		}

		private byte[] MapToAtari = new byte[256]
		{
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,

			0,1,2,3,4,5,6,7,					// SP ! " # $ % & '
			8,9,10,11,12,13,14,15,				// (  ) * + , - . /
			16,17,18,19,20,21,22,23,			// 0 1 2 3 4 5 6 7
			24,25,26,27,28,29,30,31,			// 8 9 : ; < = > ?

			32,33,34,35,36,37,38,39,			// @ A B C D E F G
			40,41,42,43,44,45,46,47,			// H I J K L M N O
			48,49,50,51,52,53,54,55,			// P Q R S T U V W
			56,57,58,59,60,61,62,63,			// X Y Z [ \ ] ^ _

			96,97,98,99,100,101,102,103,		// ` a b c d e f g
			104,105,106,107,108,109,110,111,	// h i j k l m n o
			112,113,114,115,116,117,118,119,	// p q r s t u v w
			120,121,122,126,124,127,126,127,	// x y z { | } ~ 

			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,
		};

		/// <summary>
		/// Write the level data to the /temp folder into file 'level#.bin'
		/// </summary>
		/// <param name="lvl">Byte array with level data</param>
		/// <param name="useZX5">True if ZX5 compression is to be used</param>
		/// <returns></returns>
		private byte[] WriteCompressReload(byte[] lvl, bool useZX5)
		{
			var compressorExe = Path.Combine(Directory.GetCurrentDirectory(), "assets", useZX5 ? "zx5.exe" :"zopfli.exe");
			var tempDir = Path.Combine(Directory.GetCurrentDirectory(), "temp");
			try
			{
				Directory.CreateDirectory(tempDir);
			}
			catch(Exception ex)
			{
				MessageBox.Show($"Unable to create working folder:\r\nException:{ex.ToString()}");
				return null;
			}

			var fnOut = Path.Combine(tempDir, $"level{LevelNr}.bin");
			var fnIn = fnOut + (useZX5 ? ".zx5" : ".deflate");
			try
			{
				File.Delete(fnOut);
				File.Delete(fnIn);
			}
			catch(Exception)
			{
				MessageBox.Show($"Unable to delete:{fnIn} or {fnOut}");
				return null;
			}
			try
			{
				// Write the data to disc
				File.WriteAllBytes(fnOut, lvl);

				// Execute zopfli.exe
				var startInfo = new ProcessStartInfo();
				startInfo.FileName = compressorExe;
				startInfo.Arguments = useZX5 ? fnOut : $"{fnOut} --i1000 --deflate";
				var process = Process.Start(startInfo);
				process.WaitForExit();
			}
			catch(Exception ex)
			{
				MessageBox.Show($"Unable to compress data: {ex.ToString()}");
				return null;
			}
			// Load the file into a byte array
			
			return File.ReadAllBytes(fnIn);
		}

		#region Move the level data in any direction
		public void ShiftLeft()
		{
			// Note the visible level is only 7 wide
			var width = Map.ScreenSize.Width;
			var height = Map.ScreenSize.Height;

			var target = new AtariMap(Map.ScreenSize);
			for (var y = 0; y < height; ++y)
			{
				var pos = y * width;
				for (var x = 0; x < width - 2; ++x)
				{
					target.Data[pos] = Map.Data[pos + 1];
					++pos;
				}

				target.Data[pos] = Map.Data[pos - width+2];
			}

			Map = target;
		}
		public void ShiftRight()
		{
			// Note the visible level is only 7 wide
			var width = Map.ScreenSize.Width;
			var height = Map.ScreenSize.Height;

			var target = new AtariMap(Map.ScreenSize);
			for (var y = 0; y < height; ++y)
			{
				var pos = y * width;
				for (var x = 0; x < width - 2; ++x)
				{
					target.Data[pos+1] = Map.Data[pos];
					++pos;
				}

				target.Data[pos - width+2] = Map.Data[pos];
			}

			Map = target;
		}
		public void ShiftUp()
		{
			var width = Map.ScreenSize.Width;
			var height = Map.ScreenSize.Height;

			var target = new AtariMap(Map.ScreenSize);
			var from = width;
			var size = width * height;
			for (var i = 0; i < size; ++i)
			{
				target.Data[i] = Map.Data[from++ % size];
			}
			Map = target;
		}
		public void ShiftDown()
		{
			var width = Map.ScreenSize.Width;
			var height = Map.ScreenSize.Height;

			var target = new AtariMap(Map.ScreenSize);

			var to = width;
			var size = width * height;
			for (var i = 0; i < size; ++i)
			{
				target.Data[to++ % size] = Map.Data[i];
			}
			Map = target;
		}
		#endregion
	}
}
