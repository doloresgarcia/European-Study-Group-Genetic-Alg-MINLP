##this contains the main part of the genetic algorithm

#general
source("ga-functions.R")

#variables about the problem
ratio_EV = 0.1
station_closeness = 7
dfBounds_orig = fnFixedVariables() #fixed variable data

#parameters from "BCAM RETO IBD.XLSX"
power_per_type = c(50, 150, 350)
vehicles_simul = c(2, 3, 6)
charging_time = c(30, 10, 5)
installation_cost = c(28900, 289000, 578000)

#parameters of the genetic algorithm
mutate_cutoff = 0.1
num_iterations = 10
num_population = 8
#we want num_population to be divisible by four (for the selection/reproducing process)
while(num_population %% 4 !=0){ num_population = num_population +1 }

#reading IMD data
file = paste(getwd(), "/data/IMD_orig.txt", sep="")
dfIMD_orig = read.table(file=file, header=T, sep=",")
dfIMD_orig = dfIMD_orig[c("ID", "IMD", "Road")] #keep only important columns
dfIMD_orig[, "IMD"] = dfIMD_orig[, "IMD"] * ratio_EV #scale IMD for number of electric vehicles

#list of roads
list_roads=unique(dfIMD_orig[, "Road"])

#loop over roads
for(ii in 1:length(list_roads)){
  road_current = as.character(list_roads[ii])
  cat(paste("\nStarting with road ", road_current, " (", ii, "/", length(list_roads), ")\n", sep=""))

  #road specific variables
  dfIMD = subset(dfIMD_orig, Road == road_current)
  num_vars = nrow(dfIMD)

  dfBounds = subset(dfBounds_orig, Road == road_current)
  num_fixed_stations = nrow(dfBounds)

#have a global list with utility variables
lsUtil = list(
  num_vars=num_vars,
  num_population=num_population,   
  ratio_EV=ratio_EV, 
  num_fixed_stations=num_fixed_stations, 
  station_closeness=station_closeness,
  power_per_type=power_per_type,
  vehicles_simul=vehicles_simul,
  charging_time=charging_time,
  installation_cost=installation_cost,
  mutate_cutoff=mutate_cutoff,
  num_iterations=num_iterations)

#initial point - randomly generate versus reading in
file = paste(getwd(), "/data/initialpoint.txt", sep="")
if(file.exists(file)){
  #if exists, read in initial point
  dfSolutions = read.table(file=file, header=F)
} else{
  #else generate it randomly
  dfSolutions = data.frame(matrix(sample(x=0:3, size=lsUtil$num_vars * lsUtil$num_population, replace=T), nrow=lsUtil$num_vars, ncol=lsUtil$num_population))
}

#main loop
for(iter in 1:lsUtil$num_iterations){
  cat(paste("\nStarting iteration ", iter, " out of ", lsUtil$num_iterations, "\n", sep=""))

  fnSelectionAndCrossover(dfSolutions)

  cat(paste("\nFinished iteration ", iter, " out of ", lsUtil$num_iterations, "\n", sep=""))
}
  
  cat(paste("\nFinished with road ", road_current, " (", ii, "/", length(list_roads), ")\n", sep=""))
} #end for loop roads