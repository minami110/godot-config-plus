# ConfigPlus - Minimal, Stage‑Aware Game Settings for Godot 4
## Features
* **Default / staged / committed layers** – pick *instant* or *staged* per key.
* **Signals out of the box** – refresh UI via `current_changed` or `staged_changed`.
* **Type‑safe values** – mismatched `Variant.Type` asserts in debug builds.


## Installation

### from GitHub
Download the latest .zip file from the [Releases](https://github.com/minami110/godot-config-plus/releases) page of this repository.
After extracting it, copy the addons/config_plus/ directory into the addons/ folder of your project.



## Class Overview

| Class | Layer model | Core API | Signals |
|-------|-------------|----------|---------|
| `StagedConfigValue` | **Buffered** – default ➜ saved ➜ staged | `set_staged(v)`  `apply_staged()`  `revert_staged()`  `is_staging()` | `staged_changed(v)` · `current_changed(v)` |
| `ConfigCategory` | Wraps one `[section]` | | |



## Quick Start

### Autoload

```gdscript
extends Node
# res://autoloads/config.gd

var _file := ConfigFile.new()
var accessibility : AccessibilityCategory
var audio         : AudioCategory

func _enter_tree() -> void:
    _file.load("user://user.cfg")

    accessibility = AccessibilityCategory.new(_file)
    audio         = AudioCategory.new(_file)

func save() -> void:
    _file.save("user://user.cfg")
```

### A category
```gdscript
class_name AccessibilityCategory extends BaseConfigCategory

func _init(cf: ConfigFile) -> void:
    super._init(cf, "accessibility")   # [accessibility] section

var arachnophobia: StagedConfigValue:
    get:
        return _get_staged("arachnophobia", false) # key: arachnophobia, default: false
```

### Gameplay usage
```gdscript
# current_changed.connect wrappper
# invokes it once with the current commited value
Config.accessibility.arachnophobia.subscribe_current(func(enabled: bool) -> void:
    %SpriteSpider.visible = not enabled
)
```

### UI usage
```gdscript
func _on_arachno_checkbox_toggled(enable: bool) -> void:
    # Staging value (not update current value)
    Config.accessibility.arachnophobia.set_staged(enable)

    # Live apply
    # Config.accessibility.arachnophobia.apply_staged()

func _on_arachno_reset_to_default_pressed() -> void:
    # Staging default value
    Config.accessibility.arachnophobia.reset_to_default()

    # Live apply
    # Config.accessibility.arachnophobia.apply_staged()

func _on_apply_all_pressed() -> void:
    # Commit staging value will updated current value
    Config.accessibility.apply_all_staged()
    Config.save()

func _on_revert_all_pressed() -> void:
    # Revert stating value
    Config.accessibility.revert_all_staged()
```

### File output example
```cfg
# user://user.cfg

[accessibility]
arachnophobia=true
```
When the player resets to default, the line disappears—Godot’s ConfigFile
omits keys that equal their default.

### License
MIT (See [LICENSE](https://github.com/minami110/godot-config-plus/blob/main/LICENSE) )
