using System;
using System.Text.Json.Serialization;

namespace DschumpLevelEditor.LevelParts
{
    /// <summary>
    /// The worm hole has an entry point and an exit point
    /// We need 9 bits each to specify the location of the entry and exit holes.
    /// Various implementation options are available.
    /// When a worm hole action is fired, we know the tile position of the hit point
    /// Searching through the In position will tell us the index for the action
    /// The index in the Out array will tell us the position where the ball will pop out.
    /// It does not have to be a worm hole tile!
    /// </summary>
    [Serializable]
   public class DschumpWormhole
    {
        /// <summary>
        /// Entry point of the work hole (0-335)
        /// </summary>
        public int In { get; set; }

        /// <summary>
        /// Exit point of the worm hole (0-335)
        /// </summary>
        public int Out { get; set; }

        /// <summary>
        /// Mark the items as not found and sweep them away when they are not used anymore
        /// </summary>
        [JsonIgnore]
        public bool MarkAndSweep { get; set; }

        /// <summary>
        /// Indicate if the wormhole is from a switch
        /// </summary>
        [JsonIgnore]
		public bool FromSwitch { get; set; }

        /// <summary>
        /// Those tiles that can only be targets on the output of a warp.  Can't start a warp from this tile
        /// </summary>
        public bool ExitOnly { get; set; }
	}
}
