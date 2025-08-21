# 1-D Time-Domain Convolution on FPGA

This project implements a **1-D time-domain convolution engine** on an FPGA platform (Xilinx Zedboard).  
The design exploits **parallelism and pipelining** to accelerate convolution compared to a software-based CPU.  

The work was developed as part of **EEL 4720/5721 – Reconfigurable Computing** coursework.

---

## Project Overview

Convolution is a fundamental operation in digital signal processing (DSP).  
This project builds a custom FPGA circuit that:

- Stores the **input signal** in DRAM (emulated using block RAM for this project).  
- Loads a **kernel (filter)** of up to 128 elements via a memory-mapped interface.  
- Uses a **fully unrolled and pipelined datapath** with 128 multipliers and an adder tree.  
- Implements **signal buffering** and **kernel buffering** to maximize data reuse and avoid stalls.  
- Produces output signals with **16-bit saturation arithmetic**.
- Uses dual-clocked FIFO to handle **Clock Domain Crossing** between convolution module and DRAM.

The design integrates multiple modules:

- **DMA Interface** – Handles DRAM read/write with clock-domain synchronization.  
- **Convolution Pipeline** – Parallel multiplier-adder tree with pipelining.  
- **Signal Buffer** – Shift-register style buffer for overlapping windows.  
- **Kernel Buffer** – Registers for kernel storage.  
- **Controller + Memory Map** – Interfaces for software communication.  

---

## Testbench Simulation

A VHDL testbench is provided:

- **`wrapper_tb.vhd`** can be used to simulate and verify the design.  
- By default, the testbench runs with **maximum kernel size (128)**.  
- Users should extend it to check correctness for different kernel sizes and signal patterns.  
 

---

## Tools & Requirements

- **Vivado Design Suite** (for synthesis, simulation, and bitstream generation)  
- **Zedboard (Zynq-7000 FPGA)** hardware (for deployment)  
- **C++ host application** for testing against the FPGA  

---

## Running the Project

### Simulation

- Open the Vivado project  
- Add `wrapper_tb.vhd` as a simulation source  
- Run behavioral simulation  

### FPGA Deployment

- Generate the FPGA bitstream  
- Transfer the bitstream and provided C++ app to the board  


## Results Summary

- Passed all software-provided test cases with **100% correctness**  
- Achieved significant **speedup** with medium and large signals  
- Verified functionality in both simulation and on-board execution  

---

