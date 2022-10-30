echo Convert the boot-message.asm into a compressed binary data
atasm -r boot-message.asm
..\..\tools\CompressToAsm.exe boot-message.bin boot-message-compressed BootMessage