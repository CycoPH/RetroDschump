# Retro Dschump
---

## Idea behind the game

It all started in 1986 when I typed in the code for Jump!, game from a german magazine.
That game turned out to be lots of fun.

In 1991 Dr. Dobbs Journal published a series of articles by Michael Abrash about Mode X for the VGA cards. That video mode promised good performance for scrolling games on the PC.

So to learn some PC assembler coding I wrote Dschump, the game was published via shareware and had a relatively good following. For many years after that, I would get emails from players asking for a more modern version or if I still had the original full version available. Alas the original code was lost in time and life moved on.

Come 2021 ,with time on my hand, a friend reintroduced me to the Atari 8-bit line of machines. I hauled my my old Atari 130XE out and started coding for this little beauty.

To relearn 6502 and Atari 8-bit coding I needed a project. Nothing better than a fun re-implementation of Dschump. Hence RetroDschump was created.

I did not want to code on the old machine, so the first point of call investigating cross-assemblers for the PC. I found the awesome Atasm assembler. It had a syntax I liked and the source was available.
I fixed some bugs, extended it with some features I wanted, and made it available here [atasm](https://github.com/CycoPH/atasm). For sounds and effects [RMT](https://github.com/VinsCool/RASTER-Music-Tracker) was used. Font design was done with the [Atari FontMaker](http://matosimi.websupport.sk/atari/atari-fontmaker/). Sprites were created in a heavily modified version of [Piskel](https://github.com/CycoPH/piskel-atariExport), also hosted here [Piskel](https://www.cerebus.co.za/piskel/). To convert an RMT song into assembler source I found a project (not sure where) and created the [rmt2atasm](https://github.com/CycoPH/rmt2atasm) tool.  This lets you create relocatable assembler source code of your music. The latest version of RMT now has this feature built in.

I started writing some code in VScode and then running Atasm as a task. That soon became a bit of an issue and I started looking for a better VScode extension to assemble and run by 6502 code. Finding nothing that worked for me, I created the [Atasm-Altirra-Bridge](https://github.com/CycoPH/atasm-altirra-bridge). A small extension to VScode that allows you to edit your 6502 code and then launch the Altirra emulator to run it. Setting of breakpoints and launching the debugger works well.

List of tools used:
- [Atasm](https://github.com/CycoPH/atasm)
- [RMT](https://github.com/VinsCool/RASTER-Music-Tracker)
- [Atari FontMaker](http://matosimi.websupport.sk/atari/atari-fontmaker/)
- [Piskel](https://www.cerebus.co.za/piskel/)
- [Atasm-Altirra-Bridge](https://github.com/CycoPH/atasm-altirra-bridge)
- [rmt2atasm](https://github.com/CycoPH/rmt2atasm)

## Aim of this repo
- First a foremost is to make the source to RetroDschump available.
  I had fun writing it and maybe someone else can learn from it.
- Second is to collect all the different versions that I intend writing for other platforms.
  - C64 is next
  - Amiga and ST will follow

## How to play

Move the ball to stay on the surface. Build up the power bar to make super jumps with the fire button.
More power means a further jump! Fire & pull or push lets you go backwards.
Hit a switch to change a level tile. Jump into a hole to warp to a different location. Maybe!
There are 30 action tiles, find out what they do by jumping on them.
Hit the tiles in the middle for action. Collect points for every tile you hit.
Find the END tile to finish the level.

16 levels are included in the game.

What actions can be performed:
 - Direction switch
	Either force the screen to move in an up or down direction or toggle the movement direction
 - Toggle switch
	Hitting a switch will change a tile somewhere in the level. Some switches can be turned off/on again.
	Note: It is not always to your advantage to toggle a switch. Switches can reveal more switches.
 - Breaking tiles
	Jump on these tiles multiple times. They break more and more until they either disappear or reveal the end tile.
 - Long jump power pills fill up your power reserves
 - Nails pop your ball
 - Add a life
 - Add lots of score
 - Fall through the holes with parallax and you go down very far.
 - Black hole warping
	Land on a black hole and it will warp you to a new location in the level.
 - Pushing tiles let you jump VERY far left and right

When a level starts there is a 3 second count down timer. Read the hint at the top of the screen to get a clue on how to finish the level. Hold FIRE to keep the message on the screen after the 3 second timer.
Pressing ESC will exit you back to the intro. At the beginning 4 levels are unlocked. Use the joystick up/down to change which level you want to start on. Every time you complete a higher level you may restart from there.

### Controls

In intro:
- Joystick Up-Down change starting level
- SELECT - Display HELP screen
- START/Fire - Play
 
In the game
- Joystick - Move the ball
- Fire - Move quicker or backwards
- ESC - Exit back to intro

Coding & graphics: Peter Hinz
Music: Miker

# What you can find here

/Atari-8bit - contains the source and tools to compile RetroDschump for the Atari XL/XE lines of machines.
/DschumpLevelEditor - contains the C# code to the level editor I created for the Atari levels
/Releases - contains the binaries and the original Dschump game for the PC