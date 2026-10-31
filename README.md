# Laptop Motherboard Power Sequence & SIO Tracker

An open-source interactive terminal tool and logic mapping framework designed to track standby boot cycles, cross-reference Super I/O (SIO/EC) pin conditions, and diagnose signal state drop-offs on unpowered computer architectures.

## 🧠 Core Engineering Objective
This repository houses an offline signal-tracking console built for board repair workflows. It models the precise timing steps a laptop motherboard requires to transition from a plugged-in standby state to a full CPU Core power configuration, helping technicians catch broken logic lines without hunting through online forums.

## 🛠️ Diagnostics Architecture
* **Intel Boot Sequencer:** Outlines step-by-step logic requirements (such as matching `3V_5V_EN` states to `PCH_RSMRST#` assertions) to track power drops.
* **Super I/O Pinout Matrix:** Catalogs critical diagnostic paths on common programmable keyboard controllers (such as ITE IT8586E and ENE KB9012) to trace power switches.
* **Standby Fault Solver:** Breaks down common short-circuit behavior, including input current shunt oscillations and missing PWM chip activation signals.

## 💻 Execution Parameters
1. Clone or download this project.
2. Run `power_sequence.bat` in a native command interpreter environment.
3. No administrative system modification overrides or web connections are required.
