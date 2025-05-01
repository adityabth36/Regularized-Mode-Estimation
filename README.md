# Efficient Estimation of Mode from Sample

This repository contains MATLAB implementations for efficient estimation of the mode of a distribution based on sampled data. The project includes classical, recent, and proposed iterative methods, with comparisons across different distributions.  
The codes can reproduce figures and tables as discussed in the associated research.

## Repository Contents

| File Name                | Description |
| :----------------------- | :----------- |
| **Bivariate_Normal_Graph.m** | Plots the mode of a bivariate normal distribution using the proposed algorithm (PIM). |
| **CIM.m**                  | Classical Iterative Method (CIM) as proposed by J. Fritz. |
| **Code_for_Table_2.m**      | Generates Table 2: Results for bivariate distributions comparing PIM, RIM, and CIM. |
| **Code_for_Table_3.m**      | Generates Table 3: Results for different univariate distributions for PIM, RIM, and CCIM. |
| **drachrnd.m**              | Code to generate samples from the Dirichlet distribution. |
| **PIM.m**                  | Proposed Iterative Method (PIM) for mode estimation for univariate distributions. |
| **RIM.m**                  | Recent Iterative Method (RIM) for univariate distributions. |
| **Size_Graph.m**            | Plots the size of the distribution. |
| **Normalize_Graph.m**      | Code for figure 1-b for PIM.|

## About the Methods

- **CIM (Classical Iterative Method)**: Classical approach for mode estimation given by J. Fritz in 1973 as discussed in the manuscript.
- **RIM (Recent Iterative Method)**: A regularized iterative method for mode estimation proposed by Chandramouli Kamanchi et al. in 2019.  
  GitHub link: [https://github.com/raghudiddigi/Mode-Estimation](https://github.com/raghudiddigi/Mode-Estimation)
- **PIM (Proposed Iterative Method)**: A new efficient algorithm for mode estimation, exhibiting better performance compared to RIM and CIM as discussed in the manuscript.


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

