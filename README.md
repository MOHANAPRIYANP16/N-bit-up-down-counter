# N-bit-up-down-counter ![ASIC Flow](https://img.shields.io/badge/ASIC-RTL--to--GDS-blue) ![Cadence](https://img.shields.io/badge/Cadence-Flow-green) ![Technology](https://img.shields.io/badge/GPDK-90nm-orange)




# Introduction

This project presents the design and implementation of an **N-bit up/down counter with enable, reset, and overflow flag** using a **semi-custom digital design methodology**. The counter is described at the **Register Transfer Level (RTL)** with an emphasis on clean, synthesizable modeling of sequential logic and control behavior.

The complete design flow is executed using **Cadence EDA tools**, starting from RTL development and functional verification, followed by logic synthesis and implementation using **standard-cell libraries based on 90 nm technology (GPDK 90 nm)**. The use of the **Cadence Generic Process Design Kit (GPDK)** enables technology-aware synthesis and analysis while remaining suitable for academic and prototyping purposes.

## Table of Contents


- [N-bit Up/Down Counter](#n-bit-updown-counter)
- [Cadence Design Flow](#n-bit-updown-counter--cadence-design-flow)
  - [RTL Design](#1-rtl-design)
  - [RTL Simulation and Verification](#2-rtl-simulation-and-verification)
  - [Logic Synthesis](#3-logic-synthesis)
  - [Physical Design (Place and Route)](#4-physical-design-place-and-route)
  - [GDSII Generation](#5-gdsii-generation)
- [Conclusion](#conclusion)



# N-bit Up/Down Counter

## What is an N-bit Up/Down Counter?

An **N-bit up/down counter** is a sequential digital circuit that stores an N-bit binary value and updates it on each active clock edge. Depending on the **up/down control signal**, the counter either increments or decrements its current count. The **enable** signal controls whether the counter performs a counting operation, while the **reset** signal initializes the counter to a known state. An **overflow or underflow flag** is used to indicate when the counter reaches its maximum or minimum count value, which is essential for system-level control, monitoring, and synchronization.


# N-bit Up/Down Counter – Cadence Design Flow

![alt text](https://github.com/MOHANAPRIYANP16/N-bit-up-down-counter/blob/main/IMAGES/design%20flow.png)

## 1. RTL Design

The design process begins at the **Register Transfer Level (RTL)**, where the functional behavior of the N-bit up/down counter is described using a synthesizable hardware description language (Verilog/SystemVerilog).

At this stage:
- The counter register stores the Parameterized N-bit count value.
- Up/Down control logic determines increment or decrement operation.
- Enable logic controls whether counting occurs.
- Reset logic initializes the counter to a known state.
- Overflow/underflow conditions are detected and flagged.

**Tools Used**
- Cadence **nclaunch** (environment setup and design entry)

```verilog
`timescale 1ns/1ps

module updown_counter #(
    parameter N = 8
)(
    input  wire             clk,
    input  wire             rst,      // synchronous reset
    input  wire             enable,
    input  wire             up_down,  // 1 = up, 0 = down
    output reg  [N-1:0]     count,
    output reg              overflow
);

    localparam [N-1:0] MAX_VAL = {N{1'b1}};

    always @(posedge clk) begin
        if (rst) begin
            count    <= {N{1'b0}};
            overflow <= 1'b0;
        end
        else if (enable) begin
            overflow <= 1'b0;  // default

            if (up_down) begin
                // UP counting
                if (count == MAX_VAL) begin
                    count    <= {N{1'b0}};
                    overflow <= 1'b1;
                end
                else begin
                    count <= count + 1'b1;
                end
            end
            else begin
                // DOWN counting
                if (count == {N{1'b0}}) begin
                    count    <= MAX_VAL;
                    overflow <= 1'b1;
                end
                else begin
                    count <= count - 1'b1;
                end
            end
        end
        else begin
            overflow <= 1'b0; // no spurious flag when disabled
        end
    end

endmodule
```


---

## 2. RTL Simulation and Verification

RTL simulation is performed to verify the functional correctness of the design before synthesis.

At this stage:
- Correct counting behavior is verified for both up and down modes.
- Reset functionality is validated.
- Overflow and underflow flag generation is checked.
- Waveforms are analyzed to ensure cycle-accurate behavior.

This step ensures the RTL design is logically correct and free of functional bugs.

**Tools Used**
- Cadence **nclaunch**
- Cadence **Xcelium** (RTL simulation)

**Files required**
- design file (.v)
- Testbench file (.v)

verilog code for Testbench :

```verilog
`timescale 1ns/1ps

module tb_updown_counter;

    parameter N = 4;

    reg clk;
    reg rst;
    reg enable;
    reg up_down;
    wire [N-1:0] count;
    wire overflow;

    // DUT instantiation
    updown_counter #(
        .N(N)
    ) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .up_down(up_down),
        .count(count),
        .overflow(overflow)
    );

    // Clock generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk     = 0;
        rst     = 1;
        enable  = 0;
        up_down = 1;

        // Reset
        #20;
        rst = 0;

        // Enable UP counting
        enable  = 1;
        up_down = 1;

        // Run long enough to overflow
        #200;

        // Switch to DOWN counting
        up_down = 0;

        // Run long enough to underflow
        #200;

        // Disable counter
        enable = 0;
        #50;

        // Re-enable UP counting
        enable  = 1;
        up_down = 1;
        #100;

        $finish;
    end

endmodule
```

Simluation waveform :

![alt text](https://github.com/MOHANAPRIYANP16/N-bit-up-down-counter/blob/main/IMAGES/simulation.png)


---

## 3. Logic Synthesis

After successful RTL verification, the design is synthesized using **Cadence Genus** (or equivalent) with **90 nm GPDK standard-cell libraries**.

At this stage:
- RTL is translated into a gate-level netlist.
- Standard cells such as flip-flops, multiplexers, and logic gates are mapped.
- Timing, area, and power constraints are applied.
- Reports for area, timing, and cell utilization are generated.

The synthesized netlist represents the logical hardware implementation of the counter.


**Required files :**

- constraints file (.sdc)
- design file (.v)
- script file (.tcl)

---

## 4. Physical Design (Place and Route)

The synthesized netlist is then taken into the **physical design stage** using **Cadence Innovus**.

At this stage:
- Floorplanning is performed to define the core and I/O layout.
- Standard cells are placed within the core region.
- Clock Tree Synthesis (CTS) is carried out to ensure balanced clock distribution.
- Routing is performed to connect all signal and power nets.
- Design Rule Check (DRC) and Layout Versus Schematic (LVS) checks are completed.

This step converts the logical netlist into a manufacturable physical layout.

**Required files :**

- Output constraints file (.sdc)
- Netlist file (.v)




![alt text](https://github.com/MOHANAPRIYANP16/N-bit-up-down-counter/blob/main/IMAGES/physical_design.png)

![alt text](https://github.com/MOHANAPRIYANP16/N-bit-up-down-counter/blob/main/IMAGES/block_of_counter.png)

---

## 5. GDSII Generation

After completing physical verification, the final **GDSII layout** is generated. The GDS file represents the complete physical implementation of the N-bit up/down counter **for educational and prototyping purposes** and demonstrates the end of the RTL-to-GDS flow; however, it is **not intended for silicon fabrication or tapeout**, as Cadence GPDK is a non–foundry-qualified technology.


The generated GDS contains:
- Standard-cell geometries
- Metal routing layers
- Power and ground structures
- Final layout data compliant with foundry rules

This marks the completion of the RTL-to-GDS semi-custom ASIC design flow.

![alt text](https://github.com/MOHANAPRIYANP16/N-bit-up-down-counter/blob/main/IMAGES/GDS%20file.png)
---

## Conclusion

This project successfully demonstrates the complete **RTL-to-GDSII semi-custom ASIC design flow** for an **N-bit up/down counter with enable, reset, and overflow flag** using **Cadence EDA tools**. The design was developed at the **Register Transfer Level (RTL)**, functionally verified through simulation, synthesized into a gate-level netlist, and physically implemented through placement and routing.

The use of **Cadence nclaunch, Xcelium, Genus, and Innovus** provides practical exposure to industry-standard VLSI design methodologies, while the **90 nm Cadence GPDK** enables safe learning and prototyping without proprietary foundry data. Although the generated GDSII is not intended for silicon fabrication, it effectively validates the end-to-end design process and tool flow.

Overall, this project reinforces key concepts in digital design, RTL modeling, verification, synthesis, and physical design, and serves as a solid academic and professional reference for understanding modern **semi-custom ASIC design workflows**.


