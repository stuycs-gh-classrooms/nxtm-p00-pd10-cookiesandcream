[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/gbHItYk9)
## Project 00
### NeXTCS
### Period: 10
## Name0: Cindy Ye
## Name1: Tsz Hang Ko
## Name2: Brian Chen
---

This project will be completed in phases. The first phase will be to work on this document. Use github-flavoured markdown. (For more markdown help [click here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) or [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) )

All projects will require the following:
- Researching new forces to implement.
- Method for each new force, returning a `PVector`  -- similar to `getGravity` and `getSpring` (using whatever parameters are necessary).
- A distinct demonstration for each individual force (including gravity and the spring force).
- A visual menu at the top providing information about which simulation is currently active and indicating whether movement is on or off.
- The ability to toggle movement on/off
- The ability to toggle bouncing on/off
- The user should be able to switch _between_ simluations using the number keys as follows:
  - `1`: Gravity
  - `2`: Spring Force
  - `3`: Drag
  - `4`: Custom Force
  - `5`: Combination


## Phase 0: Force Selection, Analysis & Plan
---------- 

#### Custom Force: ELECTROSTATIC FORCE

### Forumla
What is the formula for your force? Including descriptions/definitions for the symbols. (You may include a picture of the formula if it is not easily typed.)

F = k * |q1 * q2| / r^2

### Custom Force
- What information that is already present in the `Orb` or `OrbNode` classes does this force use?
  - The centers of the Orbs and the distance between them

- Does this force require any new constants, if so what are they and what values will you try initially?
  - Yes, it requires Coulumb's number, which is 8.99*10^-9, but it will have to be adjusted to fit our model.

- Does this force require any new information to be added to the `Orb` class? If so, what is it and what data type will you use?
  - Yes, there will need to be a charge for each orb. This will be done using an int variable. 

- Does this force interact with other `Orbs`, or is it applied based on the environment?
  - Yes, it will be repelled or attracted depending on the sign of the electrostatic force. 

- In order to calculate this force, do you need to perform extra intermediary calculations? If so, what?
  - Yes, F = k * |q1 * q2| / r^2

--- 

### Simulation 1: Gravity
Describe how you will attempt to simulate orbital motion.

The orbs will move towards the center of mass located below the screen. 

Formula: ${\overrightarrow F} = G \dfrac{mass_A mass_B}{r^2}\hat{AB}$


--- 

### Simulation 2: Spring
Describe what your spring simulation will look like. Explain how it will be setup, and how it should behave while running.

Orbs will be connected via spring. If the spring is compressed, the orbs will experience a formula directing them away from each other, and vice versa. 

Formula: ${\overrightarrow F} = k x \hat {AB}$

--- 

### Simulation 3: Drag
Describe what your drag simulation will look like. Explain how it will be setup, and how it should behave while running.

A force that opposes motion, depending on the object's velocity and medium of surrounding. 

Formula: ${\overrightarrow F} = -\dfrac{1}{2} ||v||^2 C_d {\hat v}$

--- 

### Simulation 4: Custom force
Describe what your Custom force simulation will look like. Explain how it will be setup, and how it should behave while running.

YOUR ANSWER HERE

--- 

### Simulation 5: Combination
Describe what your combination simulation will look like. Explain how it will be setup, and how it should behave while running.

YOUR ANSWER HERE

