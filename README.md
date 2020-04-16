# European-Study-Group-Genetic-Alg-MINLP

## Optimal design of the Electric Vehicles's public charging network!

Special feature of the problem: different chargers disaggregated by type and considering 65 charging stations are already available.

Assumptions:
- We focus on the interurban behavior, which results in a road by road approach
- Focus on Low total cost of building the charging stations and Low maximum waiting time at all stations, functions can be checked at the summary pdf.

Available data (Number EV, Battery size of the vehicles, Coordinates of IMD) can be checked at DataCheck.ipynb and the cleaning process.



Goal:
- The optimization problem formulated falls in the class of nonlinear integer programming (INLP) problems. 
The goal is to apply the genetic algorithm to both single and multi-objective cost functions. 

The final solution for the country of Spain is as follows. Where different colours represent the different stations, which differ on charching time and price:

![Result](https://github.com/doloresgarcia/European-Study-Group-Genetic-Alg-MINLP/blob/master/Results_images/FinalMapSolution.jpg)

This represents one of the possible solutions of the Pareto front. Here we present an example of it for different roads:
![Pareto Front](https://github.com/doloresgarcia/European-Study-Group-Genetic-Alg-MINLP/blob/master/Results_images/ParetoFrontEx.jpg)



