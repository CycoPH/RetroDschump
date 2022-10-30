using DschumpLevelEditor.Definitions;
using DschumpLevelEditor.LevelParts;
using System;
using System.Collections;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
	class MainForm_Wormholes { }

	public class WormholeComparer : IComparer
	{
		// Calls CaseInsensitiveComparer.Compare with the parameters reversed.
		int IComparer.Compare(Object x, Object y)
		{
			return ((DschumpWormhole)x).In - ((DschumpWormhole)y).In;
		}
	}

	public partial class MainForm
	{
		public int EditingWormholePosition { get; set; }

		public int[] CurrentWormholes;

		private void RescanWormholes()
		{
			// Scan through the level from top to bottom and find all the tiles that are wormholes
			var levelMap = levelInfo.Map;

			// Mark all wormholes data stores as invalid
			foreach (var item in levelInfo.Wormholes.Values)
			{
				item.MarkAndSweep = false;
				item.FromSwitch = false;
			}

			for (var y = 0; y < levelMap.ScreenSize.Height; ++y)
			{
				for (var x = 0; x < levelMap.Stride; ++x)
				{
					var pos = x + y * levelMap.Stride;
					var tileNr = levelMap.Data[pos];

					if (tileNr == AppConsts.WormholeTileNr)
					{
						// This is a wormhole
						// Find its data in the .Wormholes store
						if (!levelInfo.Wormholes.TryGetValue(pos, out var theWormhole))
						{
							// Not found, so add it
							levelInfo.Wormholes.Add(pos, new LevelParts.DschumpWormhole()
							{
								In = pos,
								MarkAndSweep = true,
							});
						}
						else
						{
							theWormhole.MarkAndSweep = true;
						}
					}
					else if (tilesInfo.IsExit[tileNr])
					{
						// This is an exit only hole
						// Find its data in the .Wormholes store
						if (!levelInfo.Wormholes.TryGetValue(pos, out var theWormhole))
						{
							// Not found, so add it
							levelInfo.Wormholes.Add(pos, new LevelParts.DschumpWormhole()
							{
								In = pos,
								MarkAndSweep = true,
								ExitOnly = true,
							});
						}
						else
						{
							theWormhole.MarkAndSweep = true;
							theWormhole.ExitOnly = true;
						}
					}
				}
			}
			// Not quite done yet.
			// Wormholes can also be switched in via a switch.
			// Scan the .What entries of all the switches and add them
			var theSwitches = levelInfo.Switches.Values.ToArray();
			foreach (var oneSwitch in theSwitches)
			{
				if (oneSwitch.What == AppConsts.WormholeTileNr)
				{
					var pos = oneSwitch.Target;

					if (!levelInfo.Wormholes.TryGetValue(pos, out var theWormhole))
					{
						// Not found, so add it
						levelInfo.Wormholes.Add(pos, new LevelParts.DschumpWormhole()
						{
							In = pos,
							MarkAndSweep = true,
							FromSwitch = true,
						});
					}
					else
					{
						theWormhole.MarkAndSweep = true;
						theWormhole.FromSwitch = true;
					}
				}
				else if (tilesInfo.IsExit[oneSwitch.What])
				{
					var pos = oneSwitch.Target;
					// This is an exit only hole
					// Find its data in the .Wormholes store
					if (!levelInfo.Wormholes.TryGetValue(pos, out var theWormhole))
					{
						// Not found, so add it
						levelInfo.Wormholes.Add(pos, new LevelParts.DschumpWormhole()
						{
							In = pos,
							MarkAndSweep = true,
							FromSwitch = true,
							ExitOnly = true,
						});
					}
					else
					{
						theWormhole.MarkAndSweep = true;
						theWormhole.FromSwitch = true;
						theWormhole.ExitOnly = true;
					}
				}
			}

			// Delete those that are still marked as invalid
			foreach (var item in levelInfo.Wormholes.Values)
			{
				if (item.MarkAndSweep == false)
					levelInfo.Wormholes.Remove(item.In);
			}

			// Now add the wormholes to the display
			var theWormholes = levelInfo.Wormholes.Values.ToArray();
			// 1. Sort them
			Array.Sort(theWormholes, new WormholeComparer());
			// 2. Add to list
			listView_Wormholes.Clear();
			listView_Wormholes.Columns.Add("Entry");
			listView_Wormholes.Columns.Add("Exit");
			listView_Wormholes.Columns.Add("Source");
			// 3. And tile combobox
			comboWormholes.Items.Clear();
			// 4. The entry positions for the drop-down list
			CurrentWormholes = new int[theWormholes.Length];

			for (var i = 0; i < theWormholes.Length; ++i)
			{
				var one = theWormholes[i];
				CurrentWormholes[i] = one.In;
				// Add it to the drop down list
				if (one.ExitOnly)
				{
					comboWormholes.Items.Add($"{one.In} - Exit only - {(one.FromSwitch ? "Switch" : "Level")}");
				}
				else
				{
					comboWormholes.Items.Add($"{one.In} - {(one.FromSwitch ? "Switch" : "Level")}");

					// Add it to the list view
					var lvi = new ListViewItem();
					if (one.ExitOnly)
					{
						lvi.Text = $"-";
						lvi.Name = "Entry";
						lvi.Tag = new MyTag(0, true);
					}
					else
					{
						lvi.Text = $"{one.In}";
						lvi.Name = "Entry";
						lvi.Tag = new MyTag(one.In, false);
					}

					if (i >= AppConsts.NumWormholes)
					{
						lvi.ForeColor = Color.Red;
					}

					var sub = lvi.SubItems.Add(one.ExitOnly ? "Exit Only" : $"{one.Out}");
					sub.Name = "Exit";
					sub = lvi.SubItems.Add(one.FromSwitch ? "Switch" : "Level");
					sub.Name = "Source";

					listView_Wormholes.Items.Add(lvi);
				}
			}

			listView_Wormholes.Columns[0].Width = 100;// (ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_Wormholes.Columns[1].Width = 200; //(ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_Wormholes.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
		}

		/// <summary>
		/// Prevent the column width from being changed
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listView_Wormholes_ColumnWidthChanging(object sender, ColumnWidthChangingEventArgs e)
		{
			e.Cancel = true;
			e.NewWidth = listView_Wormholes.Columns[e.ColumnIndex].Width;
		}

		private void listView_Wormholes_SelectedIndexChanged(object sender, EventArgs e)
		{
			levelPictureTools.Redraw();

			var keys = levelInfo.Wormholes.Keys;
			foreach (var key in keys)
			{
				ShowPossibleWarp(levelInfo.Wormholes[key]);
			}

			if (listView_Wormholes.SelectedItems.Count == 0)
			{
				EditThisWormhole = null;
				ShowWormholePosition(EditThisWormhole);
				picLevel.Invalidate();
				return;
			}

			var it = listView_Wormholes.SelectedItems[0];

			var thisWormhole = ((MyTag)it.Tag).val;

			EditThisWormhole = levelInfo.Wormholes[thisWormhole];
			ShowWormholePosition(EditThisWormhole);

			picLevel.Invalidate();
		}

		private void listView_Wormholes_MouseDown(object sender, MouseEventArgs e)
		{
			HideWormholeEditor();
		}

		private void comboWormholes_DropDownClosed(object sender, EventArgs e)
		{
			HideWormholeEditor();
		}

		/// <summary>
		/// Opening the work hole combo box
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void comboWormholes_DropDown(object sender, EventArgs e)
		{
			// Highlight all the worm holes

		}

		private void listView_Wormholes_MouseUp(object sender, MouseEventArgs e)
		{
			var i = listView_Wormholes.HitTest(e.X, e.Y);

			if (i == null || i.Item == null) return;

			if (i.SubItem.Name == "Entry")
			{
				// We hit the in/Entry column, don't want to edit that
				return;
			}

			SelectedItem = i.Item;
			SelectedLSI = i.SubItem;
			if (SelectedLSI == null)
			{
				SelectedItem = null;
				return;
			}

			EditingWormholePosition = ((MyTag)SelectedItem.Tag).val;

			if (i.SubItem.Name == "Exit")
			{
				int border = 0;
				switch (listView_Wormholes.BorderStyle)
				{
					case BorderStyle.FixedSingle:
						border = 1;
						break;
					case BorderStyle.Fixed3D:
						border = 2;
						break;
				}

				int CellWidth = SelectedLSI.Bounds.Width;
				int CellHeight = SelectedLSI.Bounds.Height;
				int CellLeft = border + listView_Wormholes.Left + i.SubItem.Bounds.Left;
				int CellTop = listView_Wormholes.Top + i.SubItem.Bounds.Top;

				// Show the combo box with the tile options
				comboWormholes.Location = new Point(CellLeft, CellTop);
				comboWormholes.Size = new Size(CellWidth, CellHeight);
				comboWormholes.Visible = true;
				comboWormholes.DroppedDown = true;
				comboWormholes.BringToFront();
				//comboWormholes.SelectedIndex = levelInfo.Wormholes[EditingWormholePosition].Out;

				return;
			}
			SelectedItem = null;
			SelectedLSI = null;

		}

		private void listView_Wormholes_MouseWheel(object sender, MouseEventArgs e)
		{
			HideWormholeEditor();
		}

		private void HideWormholeEditor()
		{
			comboWormholes.Visible = false;
			if (SelectedItem == null) return;
			if (SelectedLSI != null)
			{
				int pos = ((MyTag)SelectedItem.Tag).val;

				switch (SelectedLSI.Name)
				{
					case "Exit":
						{
							if (comboWormholes.SelectedIndex == -1) 
								return;

							var outPosition = CurrentWormholes[comboWormholes.SelectedIndex];
							levelInfo.Wormholes[pos].Out = outPosition;
							SelectedLSI.Text = $"{outPosition}";

							SelectedItem = null;
							SelectedLSI = null;

							levelPictureTools.Redraw();

							EditThisWormhole = levelInfo.Wormholes[pos];
							ShowWormholePosition(EditThisWormhole);

							picLevel.Invalidate();
							break;
						}
				}
			}
		}
	}
}
