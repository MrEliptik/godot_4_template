This is my personal Godot 4 template to make quick prototype, game jams and quickstart my new projects. You're free to use it as is or take parts that you may find intersting! See [LICENSE.md]() fore more details

# Features

### Common scenes

- Titlescreen ⌛
- Pause ⌛
- Settings ⌛
- Animated button ⌛
- Auto resize text label ⌛

### **Utils**

- Random rotation → you provide the deviation and if you want + - sign ⌛ 
- Get a random position inside constraints⌛ 
- Spawn evenly inside area ⌛
- Time related stuff (global time, slow down, etc) ⌛
- Call function later ✅
- Call function in X frames⌛

### Autoload

- **Globals** → Holds global variables, references, and things needed across the game ✅
- **Utils** → Functions and utilities that can be used by many objects (computing area, getting a random value, etc..) ⌛
- **AudioManager** → manages music playing, effects on bus and playing shared sound effects ⌛
- **SceneSwitcher** → Allows to transition between scenes that are often used (titlescreen, options, level select, etc) ⌛
- **Transition** → A transition screen to hide loading ✅
- **Achievements** → a layer to keep track of achievements. Allows to more easily plug other achievement system and also show achievements on platforms where there's no system like itch ⌛

### **Components**

- Health ⌛
- Hitbox/hurtbox ⌛
- Hitstop ⌛
- Bullet time ⌛
- Spawner ⌛
- Tween that sets default value automatically for UI ⌛ 