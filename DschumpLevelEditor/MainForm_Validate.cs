using DschumpLevelEditor.Definitions;
using System;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
	class MainForm_Validate	{ }

	public partial class MainForm
	{
		/// <summary>
		/// Validate that the level data fits the requirements of the game.
		/// No invalid tiles
		/// 16 or less switches
		/// 8 of less worm holes
		/// </summary>
		private bool ValidateLevel()
		{
			RescanSwitches();
			RescanWormholes();

			var sb = new StringBuilder();

			// Validate that no invalid tile is used
			var levelOk = ValidateLevelTiles(sb);
			var switchesOk = ValidateSwitches(sb);
			var warpOk = ValidateWormholes(sb);

			var str = sb.ToString();
			if (str.Length > 0)
			{
				picLevel.Invalidate();
				MessageBox.Show(str);
				
				return levelOk && switchesOk && warpOk;
			}
			return true;
		}

		/// <summary>
		/// Check the level that no invalid tiles have been used!
		/// </summary>
		/// <returns>true if all is ok, false if there are tiles that should not be used</returns>
		private bool ValidateLevelTiles(StringBuilder sb)
		{
			// Scan through the level and find tiles that are NOT valid
			var levelMap = levelInfo.Map;

			var numErrors = 0;
			for (var y = 0; y < levelMap.ScreenSize.Height; ++y)
			{
				for (var x = 0; x < levelMap.Stride; ++x)
				{
					int pos = x + y * levelMap.Stride;
					var tileNr = levelMap.Data[pos];

					if (tilesInfo.Valid[tileNr] == false)
					{
						if (numErrors == 0)
						{
							sb.AppendLine("You have some invalid tiles:");
						}
						++numErrors;
						if (numErrors < 16)
						{
							sb.AppendLine($"Tile: {tileNr}:{tilesInfo.Names[tileNr]} @ {x} x {y} is invalid.");
						} else if (numErrors == 16)
						{
							sb.AppendLine($"More errors ...");
						}

						levelPictureTools.DrawSwitchPosition(new Point(x * 32, y * 24));
					}
				}
			}

			return numErrors == 0;
		}

		/// <summary>
		/// Check that switches have their target location and action tile set
		/// </summary>
		/// <param name="sb"></param>
		/// <returns>true if all is ok, false if there are switches that are not configured</returns>
		private bool ValidateSwitches(StringBuilder sb)
		{
			var allOk = true;

			var theSwitches = levelInfo.Switches.Values.ToArray();
			// 1. Sort them
			Array.Sort(theSwitches, new SwitchComparer());

			if (theSwitches.Length > AppConsts.NumSwitches)
			{
				sb.AppendLine($"Too many switches, limited to {AppConsts.NumSwitches}");
				allOk = false;
			}

			foreach (var oneSwitch in theSwitches)
			{
				if (oneSwitch.Target == 0 && oneSwitch.What == 0)
				{
					var x = oneSwitch.Position % 8;
					var y = oneSwitch.Position / 8;

					sb.AppendLine($"Switch @ position {x} x {y} is not set");

					levelPictureTools.DrawSwitchPosition(new Point(x * 32, y * 24));
					allOk = false;
				}
			}

			return allOk;
		}

		/// <summary>
		/// Check that wormholes have an exit hole specified
		/// </summary>
		/// <param name="sb"></param>
		/// <returns>true if all is ok, false if there are wormholes that are not configured</returns>
		private bool ValidateWormholes(StringBuilder sb)
		{
			var allOk = true;
			// Only look at worm holes that are true in-out
			// Skipping exit only entries
			var theWarps = levelInfo.Wormholes.Values.Where(w => w.ExitOnly == false).ToArray();

			// Sort them
			Array.Sort(theWarps, new WormholeComparer());

			if (theWarps.Length > AppConsts.NumWormholes)
			{
				sb.AppendLine($"Too many wormholes, limited to {AppConsts.NumWormholes}");
			}

			foreach (var oneWarp in theWarps)
			{
				var foundExit = levelInfo.Wormholes.TryGetValue(oneWarp.Out, out var _);
				if (oneWarp.Out == 0)
				{
					var x = oneWarp.In % 8;
					var y = oneWarp.In / 8;

					sb.AppendLine($"Warp exit position is not set @ In {(oneWarp.In % 8)}x{(oneWarp.In / 8)}");

					levelPictureTools.DrawSwitchPosition(new Point(x * 32, y * 24));
				} 
				else if (!foundExit)
				{
					var x = oneWarp.Out % 8;
					var y = oneWarp.Out / 8;

					sb.AppendLine($"Warp exit position is not on a wormhole: Position {(oneWarp.Out % 8)} x {(oneWarp.Out / 8)}");

					levelPictureTools.DrawSwitchPosition(new Point(x * 32, y * 24));
				}
			}

			return allOk;
		}
	}
}
