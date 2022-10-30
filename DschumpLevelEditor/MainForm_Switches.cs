using DschumpLevelEditor.Definitions;
using DschumpLevelEditor.LevelParts;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
	public class MyTag
	{
		public MyTag(int val, bool exitOnly)
		{
			this.val = val;
			this.exitOnly = exitOnly;
		}
		public int val { get; set; }
		public bool exitOnly { get; set; }
	}

	public class SwitchComparer : IComparer
	{
		// Calls CaseInsensitiveComparer.Compare with the parameters reversed.
		int IComparer.Compare(Object x, Object y)
		{
			return ((DschumpSwitch)x).Position - ((DschumpSwitch)y).Position;
		}
	}
	public partial class MainForm
	{
		public int EditingSwitchPosition { get; set; }

		private void RescanSwitches()
		{
			var isSwitch = new Dictionary<int, bool>();
			// Fill the dictionary with all the tile numbers of the tiles that are marked to be switches
			for (var i = 0; i < 64; ++i)
			{
				if (tilesInfo.IsSwitch[i])
					isSwitch.Add(i, true);
			}

			// Scan through the level from top to bottom and find all the tiles that are switches
			var levelMap = levelInfo.Map;

			// Mark all switch's data stores as invalid (those currently in the level storage)
			foreach (var item in levelInfo.Switches.Values)
			{
				item.MarkAndSweep = false;
			}

			// Run over all the switches in the level and allocate a DschumpSwitch info to it
			// NB: There can only be one switch on a location
			for (var y = 0; y < levelMap.ScreenSize.Height; ++y)
			{
				for (var x = 0; x < levelMap.Stride; ++x)
				{
					var pos = x + y * levelMap.Stride;
					var tileNr = levelMap.Data[pos];

					if (isSwitch.TryGetValue(tileNr, out var _))
					{
						// This is a switch
						// Find its data in the .Switches store
						if (!levelInfo.Switches.TryGetValue(pos, out var theSwitch))
						{
							// Not found, so add it
							levelInfo.Switches.Add(pos, new DschumpSwitch()
							{
								Position = pos,
								MarkAndSweep = true,
							});
						}
						else
						{
							theSwitch.MarkAndSweep = true;
						}
					}
				}
			}

			var toAdd = new List<DschumpSwitch>();

			// Check if a switch target is a switch
			foreach (var item in levelInfo.Switches.Values)
			{
				if (isSwitch.TryGetValue(item.What, out var _))
				{
					// This is a switch
					// Find its data in the .Switches store
					if (!levelInfo.Switches.TryGetValue(item.Target, out var theSwitch))
					{
						// Not found, so add it
						toAdd.Add(new DschumpSwitch()
						{
							Position = item.Target,
							MarkAndSweep = true,
						});
					}
					else
					{
						theSwitch.MarkAndSweep = true;
					}
				}
			}

			foreach (var item in toAdd)
			{
				levelInfo.Switches.Add(item.Position, item);
			}

			// Delete those that are still marked as invalid
			foreach (var item in levelInfo.Switches.Values)
			{
				if (item.MarkAndSweep == false)
					levelInfo.Switches.Remove(item.Position);
			}

			// Now add the switches to the display
			var theSwitches = levelInfo.Switches.Values.ToArray();
			// 1. Sort them
			Array.Sort(theSwitches, new SwitchComparer());
			// 2. Add to list
			listView_Switches.Clear();
			listView_Switches.Columns.Add("Position");
			listView_Switches.Columns.Add("Target");
			listView_Switches.Columns.Add("Tile");

			for (var i = 0; i < theSwitches.Length; ++i)
			{
				var one = theSwitches[i];
				var lvi = new ListViewItem();
				lvi.Text = $"{one.Position}";
				lvi.Name = "Position";
				lvi.Tag = new MyTag(one.Position, false);
				if (i >= AppConsts.NumSwitches)
				{
					lvi.ForeColor = Color.Red;
				}

				var sub = lvi.SubItems.Add($"{one.Target}");
				sub.Name = "Target";

				sub = lvi.SubItems.Add($"{tilesInfo.Names[one.What]}");
				sub.Name = "Tile";

				listView_Switches.Items.Add(lvi);
			}
			listView_Switches.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_Switches.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
			listView_Switches.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
		}

		public void PopulateTilesCombo()
		{
			comboTiles.Items.Clear();
			comboTiles.Items.AddRange(tilesInfo.Names);
		}

		/// <summary>
		/// Prevent the column from being resized
		/// </summary>
		private void listView_Switches_ColumnWidthChanging(object sender, ColumnWidthChangingEventArgs e)
		{
			e.Cancel = true;
			e.NewWidth = listView_Switches.Columns[e.ColumnIndex].Width;
		}

		/// <summary>
		/// A new switch has been selected.
		/// Highlight the switch position in the level
		/// </summary>
		private void listView_Switches_SelectedIndexChanged(object sender, EventArgs e)
		{
			levelPictureTools.Redraw();
			// Find out which item was selected
			if (listView_Switches.SelectedItems.Count == 0)
			{
				EditThisSwitch = null;
				ShowSwitchPosition(EditThisSwitch);         // Clear the selection

				picLevel.Invalidate();
				return;
			}
			var it = listView_Switches.SelectedItems[0];

			var thisSwitch = ((MyTag)it.Tag).val;

			EditThisSwitch = levelInfo.Switches[thisSwitch];
			ShowSwitchPosition(EditThisSwitch);

			picLevel.Invalidate();
		}

		#region Allow for data in the switch list view to be edited
		private void HideSwitchTextEditor()
		{
			// Combo box or text box?
			comboTiles.Visible = false;

			if (SelectedLSI != null)
			{
				int pos = ((MyTag)SelectedItem.Tag).val;

				switch (SelectedLSI.Name)
				{
					case "Tile":
						{
							levelInfo.Switches[pos].What = (byte)comboTiles.SelectedIndex;
							SelectedLSI.Text = $"{tilesInfo.Names[comboTiles.SelectedIndex]}";
							break;
						}
				}
			}

			SelectedLSI = null;
			SelectedItem = null;
		}

		private void listView_Switches_MouseDown(object sender, MouseEventArgs e)
		{
			HideSwitchTextEditor();
		}

		private void listView_Switches_MouseUp(object sender, MouseEventArgs e)
		{
			var i = listView_Switches.HitTest(e.X, e.Y);

			if (i == null || i.Item == null) return;

			if (i.SubItem.Name == "Position")
			{
				// We hit the first column, don't want to edit that
				return;
			}

			EditingSwitchPosition = -1;

			// The Tile column
			SelectedItem = i.Item;
			SelectedLSI = i.SubItem;
			if (SelectedLSI == null)
			{
				SelectedItem = null;
				return;
			}

			// Switch position or switch tile being edited
			EditingSwitchPosition = ((MyTag)SelectedItem.Tag).val;

			if (i.SubItem.Name == "Target")
			{
				// Place the switch action point and optionally the action tile
				if (levelEditorMode == LevelEditorMode.Normal)
				{
					// Switch into spot selection mode
					levelEditorMode = LevelEditorMode.SelectSpot;
					EditThisSwitch = levelInfo.Switches[EditingSwitchPosition];

					// Select the tile
					currentTile = EditThisSwitch.What;
					UpdateTileSelectionBox();

					//SelectedLSI.Text = "Select";

					SwitchUIState(UIState.SelectSwitchPosition);
				}
				return;
			}

			int border = 0;
			switch (listView_Switches.BorderStyle)
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
			int CellLeft = border + listView_Switches.Left + i.SubItem.Bounds.Left;
			int CellTop = listView_Switches.Top + i.SubItem.Bounds.Top;

			// Show the combo box with the tile options
			comboTiles.Location = new Point(CellLeft, CellTop);
			comboTiles.Size = new Size(CellWidth, CellHeight);
			comboTiles.Visible = true;
			comboTiles.DroppedDown = true;
			comboTiles.BringToFront();
			comboTiles.SelectedIndex = levelInfo.Switches[EditingSwitchPosition].What;
		}

		private void listView_Switches_MouseWheel(object sender, MouseEventArgs e)
		{
			HideSwitchTextEditor();
		}

		private void comboTiles_DropDownClosed(object sender, EventArgs e)
		{
			HideSwitchTextEditor();
		}

		/// <summary>
		/// Cancel the edit mode and make no changes to the data in the switch
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnCancelSwitchEdit_Click(object sender, EventArgs e)
		{
			levelEditorMode = LevelEditorMode.Normal;
			SwitchUIState(UIState.Normal);
		}

		private void FinishSwitchTargetSelection(int target)
		{
			if (EditingSwitchPosition >= 0)
			{
				// Store the target position
				levelInfo.Switches[EditingSwitchPosition].Target = target;

				if (SelectedLSI != null)
				{
					SelectedLSI.Text = $"{target}";
				}

				// Check if the action tile was changed?
				if (levelInfo.Switches[EditingSwitchPosition].What != currentTile)
				{
					levelInfo.Switches[EditingSwitchPosition].What = (byte)currentTile;

					SelectedItem.SubItems[2].Text = $"{tilesInfo.Names[currentTile]}";
				}
			}
			SelectedLSI = null;

			levelEditorMode = LevelEditorMode.Normal;
			SwitchUIState(UIState.Normal);
		}
		#endregion
	}
}
