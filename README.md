This is my personal Godot 4 template to make quick prototype, game jams and quickstart my new projects. You're free to use it as is or take parts that you may find intersting! See [LICENSE.md]() fore more details

# Features

### Common scenes

**UI**
- Titlescreen ✅
- Pause ✅
- Settings ✅
- Credits ✅
- Animated button ⌛
- Auto resize text label ⌛

**3D**
- FPS controller
- Camera takeover
- Interaction system

**2D**

### **Utils**

**Game**
- `exit_game()` → function to exit the game, where you can show a message if needed
- `has_autoload`
- `has_autoload_signal`

**Transforms, points, area**
- `get_random_rotation` → you provide the deviation and if you want + - sign ✅
- `get_random_rotation_deg` → same as `get_random_rotation`, in degrees
- `get_random_point` → random point in a circle (non uniform distribution)
- Get a random position inside constraints⌛ 
- Spawn evenly inside area ⌛
- Time related stuff (global time, slow down, etc) ⌛

**Polygons**
- `is_point_inside_polygon` ✅ 
- `get_closest_safe_point_in_polygon` ✅
- `compute_bounding_box` ✅
- `compute_polygon` ✅
- `set_uv_from_polygon` ✅
- `compute_polygon_center` ✅
- `compute_polygon_area` ⌛
- `get_random_points_inside_polygon` ⌛
- `get_distributed_points_inside_polygon` ⌛

**Calling functions**
- `call_function_in_frames` ⌛
- `call_function_later` ✅

**Editor**
- `add_child_editor` ✅

**Array manipulation**
- `shuffle_copy` ✅

**String formatting**
- `seconds_to_text` ✅
- `milliseconds_to_text` ✅
- `format_number_with_spaces` ✅

**Files**
- `load_files_from_path` ✅
- `read_lines_from_file` ✅

### Autoload

- **Globals** → Holds global variables, references, and things needed across the game ✅
- **SettingsManager** → Manages settings, save and load ✅
- **Utils** → Functions and utilities that can be used by many objects (computing area, getting a random value, etc..) ⌛
- **AudioManager** → manages music playing, effects on bus and playing shared sound effects ✅
- **SceneSwitcher** → Allows to transition between scenes that are often used (titlescreen, options, level select, etc) ✅
- **Transition** → A transition screen to hide loading ✅
- **Achievements** → a layer to keep track of achievements. Allows to more easily plug other achievement system and also show achievements on platforms where there's no system like itch ⌛

### **Components**

- Health ⌛
- Hitbox/hurtbox ⌛
- Hitstop ⌛
- Bullet time ⌛
- Interactable ✅
- Spawner ✅
- Tween that sets default value automatically for UI ⌛ 