namespace DschumpLevelEditor.Helpers
{
	public static class CPU6502
	{
		public static byte LSB(int val)
		{
			return (byte)(val & 0xFF);
		}

		public static byte MSB(int val)
		{
			return (byte)((val >> 8) & 0xFF);
		}

		// .word = LSB / MSB
		public static void Word(byte[] mem, int idx, int val)
		{
			mem[idx] = LSB(val);
			mem[idx + 1] = MSB(val);
		}

		public static void Byte(byte[] mem, int idx, int val)
		{
			mem[idx] = LSB(val);
		}
	}
}
