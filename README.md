# VGA Controller

A Verilog RTL implementation of a VGA (Video Graphics Array) controller designed to generate standard 640×480 @ 60 Hz video timing signals. The design produces horizontal and vertical synchronization signals, controls the active video region, and drives RGB outputs through user-selectable switch inputs.

The project demonstrates digital video timing generation using counters, finite-state timing logic, and FPGA-based display interfacing.

## Features

* VGA timing generation for 640×480 resolution
* Horizontal and vertical synchronization signal generation
* Active video region detection
* RGB color control through FPGA switches
* Modular RTL architecture
* ModelSim simulation support
* FPGA implementation using Vivado

## Architecture

The design consists of two primary modules:

### VGA Timing Generator

* Generates horizontal and vertical counters
* Produces VGA synchronization signals
* Detects visible display area
* Controls video enable signal

### RGB Controller

* Drives RGB outputs during active video periods
* Selects displayed color through external switches
* Blanks outputs outside the visible region

## Display Parameters

| Parameter             | Value     |
| --------------------- | --------- |
| Resolution            | 640 × 480 |
| Horizontal Pixels     | 800       |
| Vertical Lines        | 525       |
| Horizontal Sync Pulse | 96        |
| Vertical Sync Pulse   | 2         |
| Visible Area          | 640 × 480 |

## Verification

The design was simulated using ModelSim to verify:

* Horizontal timing generation
* Vertical timing generation
* Sync pulse generation
* Active video region control
* RGB output functionality

## Technologies

* Verilog HDL
* ModelSim
* Vivado
* FPGA Design
* VGA Interface
