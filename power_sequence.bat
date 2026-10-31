@echo off
title Laptop Motherboard Power Sequence Tracker
mode con: cols=95 lines=32

:MAINMENU
cls
echo =======================================================================================
echo                    LAPTOP MOTHERBOARD POWER SEQUENCE & SIO TRACKER                     
echo =======================================================================================
echo  Select a power architecture layer to inspect standard boot rails:
echo =======================================================================================
echo  1. Standard Intel Architecture Power-On Steps (Step-by-Step Flow)
echo  2. Super I/O (SIO/KBC) Critical Pin Diagnostics (IT8586E, KB9012, NPCE)
echo  3. Missing Power Rail Fault Diagnostics (Input Symptom Solver)
echo  4. Exit Tracker
echo =======================================================================================
set /p seqopt="Enter selection (1-4): "

if "%seqopt%"=="1" goto INTEL_SEQ
if "%seqopt%"=="2" goto SIO_PINS
if "%seqopt%"=="3" goto FAULT_FIND
if "%seqopt%"=="4" exit
goto MAINMENU

:INTEL_SEQ
cls
echo =======================================================================================
echo                  STANDARD INTEL STANDBY-TO-POST POWER SEQUENCE                         
echo =======================================================================================
echo  Standard progression trace order (Verify these sequentially with an oscilloscope/DMM):
echo ---------------------------------------------------------------------------------------
echo  [Step 1]  DCIN / B+ (19V - 20V Main Input Rail Operational)
echo  [Step 2]  +3V_VREG / +5V_VREG (Always-On LDO Outputs from 3V/5V PWM Controller)
echo  [Step 3]  EC_VCC (Super I/O Chip Main Power VCC Pin High)
echo  [Step 4]  EC_RST# (Reset signal to SIO releases high to 3.3V)
echo  [Step 5]  3V_5V_EN (SIO drives enable lines high to turn on 3.3V/5V inductor rails)
echo  [Step 6]  PCH_RSMRST# (Resume Reset signal sent from SIO to PCH; unlocks standby state)
echo  [Step 7]  PM_PWRBTN# (Power Button press toggles signal low-then-high to PCH)
echo  [Step 8]  PM_SLP_S3# / PM_SLP_S4# (PCH releases sleep flags high to activate RAM/CPU rails)
echo ---------------------------------------------------------------------------------------
echo  [i] Diagnostics: If PCH_RSMRST# stays low (0V), the PCH will never accept power button triggers.
echo =======================================================================================
pause
goto MAINMENU

:SIO_PINS
cls
echo =======================================================================================
echo                     SUPER I/O (EC/KBC) CRITICAL PIN REFERENCE                          
echo =======================================================================================
echo  Common embedded controllers tracking charts (Red probe to Ground for diode reference):
echo ---------------------------------------------------------------------------------------
echo  [ITE IT8586E]
echo  - Pin 11  (VCC Main Power)    -^> Target: 3.3V Standby Block
echo  - Pin 14  (WRST# EC Reset)    -^> Target: 3.3V Stable
echo  - Pin 110 (PWRSW# Button In)  -^> Target: 3.3V Drop to 0V on physical keypress
echo.
echo  [ENE KB9012]
echo  - Pin 9   (VCC Main Power)    -^> Target: 3.3V Standby Block
echo  - Pin 37  (EC_RST# Reset)     -^> Target: 3.3V Stable
echo  - Pin 114 (ON/OFFBTN# Out)    -^> Target: 3.3V Pulse out to PCH
echo ---------------------------------------------------------------------------------------
pause
goto MAINMENU

:FAULT_FIND
cls
echo =======================================================================================
echo                       MISSING POWER RAIL FAULT DIAGNOSTICS                             
echo =======================================================================================
echo  Select the missing state symptom you are encountering on the board:
echo  1. Main 19V B+ input rail drops to 0V or ticks/pulses
echo  2. 3.3V/5V LDO always-on pins exist, but 3.3V/5V inductor switch coils stay dead (0V)
echo  3. Return to Main Menu
echo ---------------------------------------------------------------------------------------
set /p faultchoice="Select option (1-3): "

if "%faultchoice%"=="1" (
    echo.
    echo [x] ASSESSMENT: Main current sensing resistor line shorted to ground, or high-side FET leakage.
    echo [i] Testing: Measure resistance on B+ main current shunt. If below 10 Ohms, inject 1V with a DC power supply to find the heating ceramic capacitor.
)
if "%faultchoice%"=="2" (
    echo.
    echo [x] ASSESSMENT: SIO is missing its EN (Enable) command signals, or the PWM chip is damaged.
    echo [i] Testing: Check SIO Pin for 3V_5V_EN drive logic. If 0V, verify if SIO read its firmware binary code out of the SPI flash completely.
)
pause
goto MAINMENU
