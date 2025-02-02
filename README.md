# FPGA-Based 4-Axis Robotic Arm with VGA Interface  

## Overview  
This project implements a 4-axis robotic arm using the Spartan-3E FPGA board. The robotic arm is controlled through PWM signals, allowing precise movement in multiple directions and enabling pick-and-place operations with a gripper. A VGA interface provides real-time visual feedback by displaying servo motor speed and angle values. The system also integrates a ROM module for ASCII character rendering, ensuring clear and structured visualization on the screen.  

## Features  
- **Servo Motor Control:** 4-axis movement (forward-backward, left-right, up-down) with PWM-based precise control.  
- **VGA Display:** Real-time display of motor speed and angles.  
- **ASCII Character Rendering:** Custom ROM-based bitmap storage for text display.  
- **Debouncer Module:** Eliminates noise from button inputs, ensuring stable operation.  
- **FPGA Implementation:** Designed entirely in VHDL, leveraging the parallel processing capabilities of FPGAs.  

## System Components  
- **PWM Generator:** Controls the servo motors by generating a precise duty cycle.  
- **VGA Controller:** Handles synchronization and pixel rendering for visual output.  
- **ASCII ROM Module:** Stores 10x10 pixel character bitmaps for on-screen text display.  
- **Debouncer Module:** Filters mechanical noise from switches and buttons.  
- **Clock Divider:** Adjusts clock frequencies for different modules, ensuring proper timing.  

## VGA Display Implementation  
- A raster-based rendering approach is used for screen synchronization.  
- Character bitmaps are fetched from a ROM and displayed at designated coordinates.  
- Servo motor speed, angle, and movement direction are updated dynamically.  

## Installation and Usage  

### Requirements  
- Spartan-3E FPGA Board  
- VGA Monitor  
- Servo Motors (4x)  
- Rotary Encoders & Switches  

### Steps  
1. **Synthesize and Load the Design:**  
   - Use Xilinx ISE to compile and upload the VHDL design to the FPGA.  
2. **Connect the Components:**  
   - Attach servo motors, rotary encoders, and VGA monitor as per the circuit diagram.  
3. **Control the Arm:**  
   - Use switches to select the motor.  
   - Adjust movement using rotary encoders.  
   - Observe real-time feedback on the VGA display.  

## Future Improvements  
- Implementing UART communication for external control.  
- Enhancing VGA display with graphical representations.  
- Optimizing resource utilization to support additional features.  

## Conclusion  
This FPGA-based robotic arm project successfully integrates real-time motor control and visualization. By leveraging VHDL and FPGA capabilities, the system ensures precise movement and clear data representation, demonstrating a practical application of digital design in robotics.  
