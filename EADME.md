# 🎮 InputManager — Advanced Input System for Godot 4.5+

> **Author:** Saulo  
> **Version:** 1.0  
> **Compatibility:** Godot 4.5+  
> **Type:** Singleton / Autoload  

---

## 🧩 Description

**InputManager** is a complete and extensible input management system for **Godot Engine 4.5+**, designed to provide **precise, unified, and configurable** control over keyboard, mouse, and gamepads.  

Features include:
- **Configurable Deadzone** for analog sticks  
- **Toggle, Oneshot, and Release Events**  
- **Dynamic Action and Button Mapping**  
- **Support for Multiple Gamepads**  
- **Built-in Signals** for easy integration  
- **Controller Vibration (Rumble)**  
- **Script or Inspector Configuration**  

Perfect for **3D or 2D games** of any genre — platformer, shooter, racing, RPG, and more.

---

## 🚀 Key Features

| Feature | Description |
|----------|-------------|
| 🎛️ Input Mapping | Supports keyboard, mouse, and multiple gamepads |
| ⚙️ Deadzone | Defines analog stick neutral zone |
| 🔁 Toggle / Oneshot | Persistent and pulse-style events |
| 🪶 Built-in Signals | Easily connect to scripts and nodes |
| 🎮 Vibration | Configurable controller rumble |
| 🔍 Auto Detection | Detects devices and actions in real-time |
| 📦 Modular | Works as global Autoload (Singleton) |

---

## 🏗️ Installation

1. Place `InputManager.gd` inside your project, e.g.:
   ```
   res://addons/input_manager/InputManager.gd
   ```

2. Go to **Project Settings → AutoLoad**, and add:
   ```
   Name: InputManager
   Path: res://addons/input_manager/InputManager.gd
   ```

3. Click **Add** to register it as a global singleton.  
   You can now access it anywhere:
   ```gdscript
   InputManager.is_action_pressed("jump")
   ```

---

## ⚡ Basic Usage

### Check if an action is pressed
```gdscript
if InputManager.is_action_pressed("jump"):
    player.jump()
```

### One-shot action
```gdscript
if InputManager.is_action_oneshot("fire"):
    player.shoot()
```

### Released action
```gdscript
if InputManager.is_action_released("dash"):
    player.stop_dash()
```

### Toggle action
```gdscript
if InputManager.is_action_toggled("light"):
    toggle_flashlight()
```

---

## 🕹️ Analog Control

```gdscript
var move_vector = InputManager.get_vector("move_left", "move_right", "move_up", "move_down")

if move_vector.length() > 0:
    player.move(move_vector)
```

---

## 💥 Controller Vibration

```gdscript
# Controller ID 0, strength X/Y, duration (seconds)
InputManager.vibrate(0, 0.5, 0.5, 0.3)
```

---

## 🔔 Signals

| Signal | Description |
|--------|-------------|
| `action_pressed(action_name: String)` | Emitted when an action is pressed |
| `action_released(action_name: String)` | Emitted when an action is released |
| `action_toggled(action_name: String, state: bool)` | Emitted when a toggle action changes state |
| `device_connected(device_id: int)` | Emitted when a controller is connected |
| `device_disconnected(device_id: int)` | Emitted when a controller is disconnected |

---

## ⚙️ Optional Configuration

```gdscript
InputManager.deadzone = 0.15
InputManager.enable_vibration = true
InputManager.debug_mode = false
```

---

## 🧠 Internal Structure

`InputManager` operates using three layers:

1. **Input Layer:** Reads system input events (keyboard, joypad, mouse).  
2. **State Layer:** Manages transitions (pressed, released, toggled, oneshot).  
3. **Emission Layer:** Sends signals and vibrations based on current state.

This ensures **high performance and low coupling**, ready for integration with any gameplay or UI system.

---

## 📘 Example (Player.gd)

```gdscript
extends CharacterBody3D

func _physics_process(delta):
    var dir = InputManager.get_vector("move_left", "move_right", "move_forward", "move_backward")
    if dir.length() > 0:
        velocity.x = dir.x * speed
        velocity.z = dir.y * speed
        move_and_slide()

    if InputManager.is_action_oneshot("jump"):
        jump()

func jump():
    velocity.y = jump_force
```

---

## 🧩 UI / HUD Integration

You can connect InputManager signals directly to buttons, animations, or menus:
```gdscript
func _ready():
    InputManager.action_pressed.connect(_on_action_pressed)

func _on_action_pressed(action_name):
    if action_name == "pause":
        toggle_pause_menu()
```

---

## 🧱 Planned Extensions

- Real-time **Input Remapping**  
- Saved profiles (JSON)  
- **Steam Input** compatibility  
- Built-in **Control Settings Menu** support  

---

## 📜 License

This plugin is distributed under the **MIT License**.  
You may freely use it in **commercial and open-source** projects.

```
MIT License © 2025 Saulo
```

---

## 💬 Credits

Developed with ❤️ by **Saulo**  
Inspired by modern AAA input management systems.  
Fully compatible with Godot 4.5+ and modern controllers (Xbox, DualSense, Switch Pro).
