<div align="center">

# 🛡️ Secure Memory Access Controller (SMAC)

### Hardware-Enforced Memory Isolation & Privilege Validation in Verilog

<br/>

![Verilog](https://img.shields.io/badge/HDL-Verilog-3F91A4?style=for-the-badge)
![ModelSim](https://img.shields.io/badge/Simulation-ModelSim-002D62?style=for-the-badge)
![Processor Architecture](https://img.shields.io/badge/Architecture-RISC--V%20%2F%20ARM-Orange?style=for-the-badge)

<br/>

> A synthesizable, hardware-level memory protection unit designed in Verilog HDL. SMAC validates memory transactions in real time based on CPU/DMA privilege levels and defined region policies, mitigating hardware-based security exploits like DMA injection attacks.

</div>

---

## 📋 Table of Contents
1. [Project Overview](#-project-overview)
2. [System Architecture](#%EF%B8%8F-system-architecture)
3. [Key Features](#-key-features)
4. [Functional Modules](#-functional-modules)
5. [Access Control Logic](#-access-control-logic)
6. [Simulation & Verification](#-simulation--verification)
7. [Future Enhancements](#-future-enhancements)

---

## 🎯 Project Overview

Software-only isolation structures are fundamentally vulnerable to kernel bugs and malicious bypasses. This project implements a **hardware-enforced Secure Memory Access Controller (SMAC)** that intercepts requests from execution engines (CPU/DMA) before they can interface with the main memory subsystem. 

By executing validation in parallel combinational hardware paths, SMAC offers real-time isolation boundaries with sub-cycle assessment latencies, mirroring protection models utilized in modern **ARM** and **RISC-V** enterprise architectures.

---

## 🏗️ System Architecture

The layout below defines the interconnected sub-modules of the top-level SMAC entity checking transactional flows:

```mermaid
graph TD
    Src[["🔌 CPU / DMA Engine Request"]] --->|current_mode| PD["Privilege Decoder"]
    Src --->|address| RD["Region Decoder"]
    Src --->|mem_req R/W/X| ACU["Access Control Unit"]

    PD --->|privilege_level| ACU
    RD --->|required_mode & allow flags| ACU

    ACU --->|Assert Pass| Mem[("💾 Main Memory Target")]
    ACU --->|Assert Fault| FL["Fault Logger (Clocked)"]
    FL --->|raise_irq / fault_address| Src
