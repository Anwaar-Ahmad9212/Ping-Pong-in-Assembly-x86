# 🏓 Ping Pong Game in Assembly

## 📌 Overview
This project is a **classic Ping Pong game** built using **Assembly (NASM)**. It demonstrates **low-level programming** concepts like **interrupts, subroutines, stack usage, and direct hardware interaction** to create a smooth and engaging gameplay experience.

🔹 **Technologies Used:**
- **Assembly (NASM)**
- **BIOS & DOS Interrupts (INT 16h, INT 10h, etc.)**
- **Stacks & Subroutines**
- **Direct Video Memory Manipulation**

## 🚀 Features
### 🎨 Background Graphics (Optional)
- Dynamic **moving patterns** to enhance visual appeal (stripes, dots, waves).
- **Layered scrolling** for a pseudo-3D effect.
- Players can **toggle background effects** before starting.

### 🏓 Paddle Mechanics
- **Player 1 Paddle** (Right Side): Controlled using **W** (up) and **S** (down).
- **Player 2 Paddle** (Left Side): Controlled using **Up Arrow** (up) and **Down Arrow** (down).
- **Paddle Representation:** Each paddle is **3 characters tall** (`|` symbol used for display).
- **Screen Boundary Handling:** Paddles stay within the game screen limits.

### 🎱 Ball Physics
- Ball starts at the **center of the screen**.
- Moves in **diagonal directions** with real-time **collision detection**.
- Bounces off **walls and paddles** using reflection logic.
- Ball represented by **'O'** on the screen.

### 🔄 Reflection & Collision Detection
- **Wall Collision:** Ball bounces when hitting top/bottom walls.
- **Paddle Collision:** Changes direction when hitting a paddle.
- **Miss Detection:** If a player misses, the opponent scores a point.

### 📊 Score System
- **Left Player Scores** when ball crosses the **right boundary**.
- **Right Player Scores** when ball crosses the **left boundary**.
- Scores displayed at the **top of the screen**.
- **Winning Condition:** First player to reach a set number of points (default: 5).

### ⏸️ Pause/Resume
- Press **'ESC'** to pause or unpause the game.
- Game freezes during pause, including ball and paddle movement.

### Sound 🔊🔊
- Also sound is addes when any player scores

  
### 🎮 Game Loop & Board Rendering
- Screen is **cleared and redrawn** each iteration.
- **Walls, paddles, and ball** are re-rendered for a smooth experience.

## 🛠️ Installation & Usage
### 🔧 Prerequisites
- **NASM (Netwide Assembler)** installed.
- **DOSBox or any x86 emulator** for execution.

### 📂 Compilation & Execution
```bash
# Assemble the code
nasm -f bin pingpong.asm -o pingpong.com

# Run the game (in DOSBox or real mode)
dosbox pingpong.com
```
## 📂 Installation & Usage
```bash
# Clone the repository
git clone https://github.com/Anwaar-Ahmad9212/Ping-Pong-in-Assembly-x86
```
---
## 📜 License
This project is licensed under the **MIT License**. Feel free to use and modify it.

## 🤝 Contributing
Contributions are welcome! Follow these steps:
1. **Fork** the repository.
2. Create a **new branch** (`git checkout -b feature-branch`).
3. **Commit changes** (`git commit -m 'Added new feature'`).
4. **Push to the branch** (`git push origin feature-branch`).
5. Open a **Pull Request**.

## 📞 Contact
For any inquiries or issues, reach out via **GitHub Issues**.


