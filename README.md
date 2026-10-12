# Orbital Mechanics

A collection of MATLAB implementations and written reports for the **Orbital Mechanics** course at [Politecnico di Milano](https://www.polimi.it), A.Y. 2023/24[cite: 2].

> **Instructors:** Prof. Camilla Colombo,
> **Teaching Assistants:** Giacomo Borelli, Lorenzo Giudici, Mathilda Bolis, Juan Luis Gonzalo Gomez[cite: 2]

---

## Overview

This repository gathers the two project assignments for the Orbital Mechanics laboratory, focusing respectively on interplanetary mission analysis and planetary exploration[cite: 2]:

| Assignment | Main Theme | Key Topics |
|---|---|---|
| **Assignment 1** | Interplanetary Explorer Mission | Interplanetary transfers, patched conics method, powered gravity assist (flyby), optimization of total cost ($\Delta v_{tot}$). |
| **Assignment 2** | Planetary Explorer Mission | Earth observation orbit analysis, perturbations, propagation in Cartesian coordinates and Gauss's planetary equations, ground track and repeating orbits. |

Both projects include the developed MATLAB code and the corresponding technical report.

---

## Repository Structure

```
Orbital-Mechanics/
├── Code/
│   ├── Assignment1/
│   │   ├── functions/                            # General functions
│   │   └── InterplanetaryMission_group_2345.m    # Interplanetary mission transfer achieved using patched conics
│   └── Assignment2/
│       ├── functions/                            # General functions
│       └── PlanetaryMission_group_2345.m         # Planetary mission
|
├── Slide_group_2345.pdf                          # Written report      
└── README.md
```

---

## Academic Context

These codes were developed as part of the coursework for the **Spacecraft Guidance & Navigation** course at Politecnico di Milano. Benchmark problems include classical astrodynamics test cases covering Halo orbit continuation in the CR3BP, multi-impulse transfer optimisation, and statistical orbit determination with realistic ground-station geometries.

---

## License

This repository is shared for educational purposes. If you use or adapt this code, please acknowledge the source.
