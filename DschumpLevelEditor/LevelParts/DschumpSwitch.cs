using System;
using System.Text.Json.Serialization;

namespace DschumpLevelEditor.LevelParts
{
    [Serializable]
    public class DschumpSwitch
    {
        /// <summary>
        /// Where is the switch located (0 - 335)
        /// </summary>
        public int Position { get; set; }
        /// <summary>
        /// Where is the action going to take place (0 - 335)
        /// </summary>
        public int Target { get; set; }

        /// <summary>
        /// Which tile is going to be switched into that position
        /// </summary>
        public byte What { get; set; }

        /// <summary>
        /// Indicate if the switch is from a switch
        /// </summary>
        [JsonIgnore]
        public bool FromSwitch { get; set; }

        /// <summary>
        /// Mark the items as not found and sweep them away when they are not used anymore
        /// </summary>
        [JsonIgnore] 
        public bool MarkAndSweep { get; set; }
    }
}
