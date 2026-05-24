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
⚡ Key FeaturesMulti-Tier Privilege Enforcements: Evaluates structural modes mapping across explicit operational states (User, Supervisor, and Kernel).Execute-Never (XN) Isolation: Blocks code execution routines originating from designated data storage regions, preventing runtime exploit injections regardless of write flags.Deterministic Fault Capturing: Synchronously locks down target addresses associated with unauthorized operations via a dedicated sequential Fault Logger unit.Latch-Free Synthesis: Utilizes strict, production-standard synthesizable coding disciplines including default assignments to prevent hazardous combinational latches.📦 Functional Modules1. Privilege Decoder (Combinational)Translates execution run-modes from the external requester master into an internal, multi-bit normalized privilege matrix utilized for quick logical comparisons.2. Region Decoder (Combinational)Decodes the active memory addresses to extract specific destination scopes, verifying required clearance baselines and explicit read/write/execute permission attributes.3. Access Control Unit (Combinational)The functional security core of the system. Evaluates the incoming privilege profile against target spatial limits and asserts a single-cycle mem_enable flag or activates access_fault flags.4. Fault Logger (Sequential - 100MHz)A clocked registrar system handling synchronous capture frames. Captures and flags violation metrics (last_fault_addr, fault_valid) to trigger processor interrupts for auditing.⚙️ Access Control LogicThe evaluation vector uses the following protection logic:Delphiif privilege < required_mode then
    raise_fault();
else if execution_requested and (not allow_execute) then
    raise_fault();
else
    grant_memory_access();
🧪 Simulation & VerificationValidation matrices were executed via testbench scenarios within ModelSim, targeting explicit execution permission bounds:Test CasePrivilege LevelRequested AddressIntended AccessObserved ResultTC1USER (00)0x1000ExecuteAllow (Valid Code Region)TC2USER (00)0x3000ExecuteFault (Blocked Data Space)TC3SUPERVISOR (01)0x5000ExecuteFault (No OS Execution Allowed)TC4KERNEL (10)0x7000ExecuteAllow (Full System Range Clearance)Functional Waveform BehaviorCombinational Flow: Verification confirms that permission assessments clear or trip instantly upon transaction setups.Sequential Integrity: Fault metrics lock strictly on the following positive edge of the system clock (clk), guaranteeing data trace reliability for subsequent host interrupt routines.🚀 Future EnhancementsDynamic Range Registers: Integrate runtime software-programmable registers enabling modern operating systems to redefine allocation protections dynamically.IOMMU Peripheral Tracking: Expand device-ID metadata decoding vectors to enforce isolated device tracking profiles across multiple hardware peripherals.Page-Level Sub-granular Granularity: Scale current region-level protection layouts down to fine-grained virtual memory paging structures.Developed for academic research and validation in advanced Computer Architecture principles.
