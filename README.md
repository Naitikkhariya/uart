# UART (Universal Asynchronous Receiver Transmitter)

A complete UART communication system designed in Verilog HDL. This project implements UART Transmitter (TX), UART Receiver (RX), Baud Rate Generator, Top Module integration, and a comprehensive Testbench for functional verification.

---

## 📌 Project Overview

UART is one of the most widely used asynchronous serial communication protocols in digital systems. This project demonstrates the complete transmit and receive flow without requiring a shared clock between devices.

The design includes:

- UART Transmitter
- UART Receiver
- Baud Rate Generator
- Top-Level UART Module
- Self-written Testbench

---

## 📂 Project Structure

```
UART/
│
├── baud.v          # Baud Rate Generator
├── tx.v            # UART Transmitter
├── rx.v            # UART Receiver
├── uart_top.v      # Top-level Integration
├── tb.v            # Testbench
└── README.md
```

---

## ⚙️ Modules Description

### 1. Baud Rate Generator (`baud.v`)

Responsible for generating baud tick pulses from the system clock.

**Features**

- Clock divider
- Generates baudTick
- Configurable baud rate through divider value

---

### 2. UART Transmitter (`tx.v`)

Converts parallel data into serial data.

Transmission sequence:

```
Idle
   ↓
Start Bit (0)
   ↓
8 Data Bits (LSB First)
   ↓
Stop Bit (1)
   ↓
Idle
```

Features:

- FSM Based
- Busy signal
- Transmission Complete (txDone)
- LSB First transmission

---

### 3. UART Receiver (`rx.v`)

Receives serial data and reconstructs the original byte.

Reception sequence:

```
Wait for Start Bit
        ↓
Receive 8 Data Bits
        ↓
Stop Bit Check
        ↓
Data Ready
```

Features:

- FSM Based
- Start bit detection
- Stop bit validation
- Received data output

---

### 4. UART Top Module (`uart_top.v`)

Integrates all UART blocks together.

Contains:

- Baud Generator
- TX Module
- RX Module

Acts as the complete UART communication block.

---

### 5. Testbench (`tb.v`)

Verifies UART functionality through simulation.

Includes:

- Clock generation
- Reset generation
- Input stimulus
- Data transmission testing
- Output observation

---

## 🛠 Design Methodology

The UART transmitter and receiver are both implemented using Finite State Machines (FSM).

General workflow:

```
System Clock
      │
      ▼
Baud Generator
      │
      ▼
 Baud Tick
   │      │
   ▼      ▼
 TX FSM  RX FSM
```

---

## 📡 UART Frame Format

```
| Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop |
|   0   |            8-bit Data                 |   1  |
```

- 1 Start Bit
- 8 Data Bits
- No Parity
- 1 Stop Bit

(8N1 Configuration)

---

## ▶ Simulation Flow

1. Reset the design.
2. Apply input data.
3. Assert transmission start.
4. Baud generator produces baud ticks.
5. TX serializes the data.
6. RX receives the serial stream.
7. Parallel data is reconstructed.
8. Verify received data.

---

## 🎯 Learning Outcomes

This project helps understand:

- UART Protocol
- FSM Design
- Serial Communication
- Baud Rate Generation
- Shift Register Operation
- Verilog RTL Design
- Testbench Development
- Digital Communication Basics

---

## 📚 Concepts Used

- Verilog HDL
- Finite State Machine (FSM)
- Sequential Logic
- Combinational Logic
- Counters
- Shift Registers
- Clock Divider
- UART Communication Protocol

---

## 🚀 Future Improvements

Possible enhancements include:

- Configurable Baud Rate
- Configurable Data Width
- Parity Bit Support
- Multiple Stop Bits
- FIFO Buffer
- Interrupt Generation
- Error Detection
- AXI/UART Interface
- SystemVerilog Verification
- UVM Testbench

---

## 🧪 Simulation

The design is intended for simulation using:

- Xilinx Vivado Simulator (XSim)

Other simulators such as ModelSim or QuestaSim can also be used with minor modifications if required.

---

## 👨‍💻 Author

**Naitik Khariya**

Electronics and Communication Engineering

RTL Design | Digital Design | Verification Engineering