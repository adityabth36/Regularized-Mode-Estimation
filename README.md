# Efficient Estimation of Mode from Sample

This repository contains MATLAB implementations for efficient estimation of the mode of a distribution based on sampled data. The project includes classical, recent, and proposed iterative methods, with comparisons across different distributions.  
The codes can reproduce figures and tables as discussed in the associated research.

## Repository Contents

| File Name                | Description |
| :----------------------- | :----------- |
| **Bivariate_Normal_Graph.m** | Plots the mode of a bivariate normal distribution using the proposed algorithm (PIM). |
| **CIM.m**                  | Classical Iterative Method (CIM) implementation as proposed by J. Fritz. |
| **Code_for_Table_2.m**      | Generates Table 2: Results for bivariate distributions comparing PIM, RIM, and CIM. |
| **Code_for_Table_3.m**      | Generates Table 3: Results for different univariate distributions for PIM, RIM, and CIM. |
| **drachrnd.m**              | Code to generate samples from the Dirichlet distribution. |
| **PIM.m**                  | Proposed Iterative Method (PIM) for mode estimation for univariate distributions. |
| **RIM.m**                  | Recent Iterative Method (RIM) for univariate distributions. |
| **Size_Graph.m**            | Plots the size of the distribution. |

## About the Methods

- **CIM (Classical Iterative Method)**: Traditional approach to iterative mode estimation.
- **RIM (Recent Iterative Method)**: A modified and improved version of CIM.
- **PIM (Proposed Iterative Method)**: A new efficient algorithm for mode estimation, exhibiting better performance across various distributions.

## How to Run

1. Clone this repository.
2. Ensure you have MATLAB installed.
3. Run the `.m` files as needed:
   - To generate graphs, execute `Bivariate_Normal_Graph.m` or `Size_Graph.m`.
   - To generate tables, run `Code_for_Table_2.m` and `Code_for_Table_3.m`.

Example:
```matlab
% Run this in MATLAB
Bivariate_Normal_Graph

