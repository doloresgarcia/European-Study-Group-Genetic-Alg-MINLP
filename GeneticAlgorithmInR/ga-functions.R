##this contains the functions used for the Genetic algorithm for ESGI

fnFitness1 = function(vec){
  #calculate fitness 1 (money cost)
  cat("\nfnFitness1\n")
  count = rep(NA, 3)
  count[1] = sum(vec == 1)
  count[2] = sum(vec == 2)
  count[3] = sum(vec == 3)

  price = lsUtil$installation_cost

  total_cost = sum(count*price)

  return(total_cost)
}

fnFitness2 = function(vec){
  #calculate fitness 2 (time)
  cat("\nfnFitness2\n")

  cat("fnFitness2: not implemented yet")
  r = runif(n=1, min=0.5, max=100)
  return(r)
}

fnScaleFitness = function(dfFitnessValues){
  #takes the df with fitness values from a generation, normalises them to [0,1] and returns the normalised dataframe
  cat("\nfnScaleFitness\n")

  dfFitnessValuesNormalised = data.frame(matrix(NA, nrow=2, ncol=lsUtil$num_population))

  max_fit1 = max(dfFitnessValues[1, ])
  dfFitnessValuesNormalised[1, ] = dfFitnessValues[1, ]/max_fit1
  
  max_fit2 = max(dfFitnessValues[2, ])
  dfFitnessValuesNormalised[2, ] = dfFitnessValues[2, ]/max_fit2

  return(dfFitnessValuesNormalised)
}

fnSelectionAndCrossover = function(dfSolutions){
  #input: m  solution vectors (as a dataframe)
  #output: m new solutions (as a dataframe)
  cat("\nfnSelectionAndCrossover\n")
  
  #get fitness values for the m solutions
  dfFitnessValues = data.frame(matrix(NA, nrow=2, ncol=lsUtil$num_population))
  for(ii in 1:lsUtil$num_population){
    vec_curr = dfSolutions[, ii] ##ii-th column of the dataframe with solutions
    dfFitnessValues[1, ii] = fnFitness1(vec_curr)
    dfFitnessValues[2, ii] = fnFitness2(vec_curr)
  }

  dfFitnessValuesNormalised = fnScaleFitness(dfFitnessValues)

  #now select the "best" solutions to keep.
  #calculate the 2-norm of the fitness values for all solutions
  norm_val = dfFitnessValuesNormalised[1, ]^2 + dfFitnessValuesNormalised[2, ]^2
  norm_order = order(norm_val)

  #in the beginning we made sure num_population divisible by four, so we that we have clean pairs.
  #now: use the better half to create kids to replace the worse half
  #start with the best pair, replace the worst pair etc
  for(ii in seq(from=1, to=lsUtil$num_population/2, by=2)){
    idx_parent1 = which(norm_order == ii)
    idx_parent2 = which(norm_order == ii+1)
    idx_replace1 = which(norm_order == (lsUtil$num_population - ii + 1))
    idx_replace2 = which(norm_order == (lsUtil$num_population - ii))

    lsKids = fnCrossover(parent1=dfSolutions[, idx_parent1], parent2=dfSolutions[, idx_parent2])

    dfSolutions[, idx_replace1] = lsKids$kid1
    dfSolutions[, idx_replace2] = lsKids$kid2
  } #end for
}

fnCrossover = function(parent1, parent2){
  #take two solutions ("parents") and crossover them to get two new solutions ("kids")
  #returns a list
  cat("\nfnCrossover\n")

  #empty vectors
  kid1 = kid2 = rep(NA, lsUtil$num_vars)

  #choose a random cutoff point
  r = sample(1:(lsUtil$num_vars-1), 1)
  idx_keep = 1:r
  idx_swap = (r+1):(lsUtil$num_vars)

  #swap the first r entries of parent1 and parent2
  kid1[idx_keep] = parent1[idx_keep]
  kid1[idx_swap] = parent2[idx_swap]
  kid2[idx_keep] = parent2[idx_keep]
  kid2[idx_swap] = parent1[idx_swap]

  #maybe mutate
  r1 = runif(n=1, min=0, max=1)
  if(r1 <= lsUtil$mutate_cutoff){ kid1 = fnMutate(kid1) }
  r2 = runif(n=1, min=0, max=1)
  if(r2 <= lsUtil$mutate_cutoff){ kid2 = fnMutate(kid2) }

  #repair the vectors so they obey the constraints
  kid1 = fnRepairConstraints(kid1)
  kid2 = fnRepairConstraints(kid2)

  lsReturn = list(kid1=kid1, kid2=kid2)
  return(lsReturn)
}

##CONSTRAINTS ##
fnRepairConstraints = function(vec){
  cat("\nfnRepairConstraints\n")

  vec = fnRepairFixedVariables(vec)
  vec = fnRepairConstraint1(vec)

  return(vec)
}

fnRepairConstraint1 = function(vec){
  #takes a possible to solution and checks if it is feasible
  #constraint: at least every X stations there has to be a charging station
  cat("\nfnRepairConstraint1\n")

  idx = fnFindStringOfNumber(vec=vec, number=0, threshold=lsUtil$station_closeness)
  while(idx != 0){
    #repair vector
    idx_middle = idx + floor(lsUtil$station_closeness/2)
    vec[idx_middle] = sample(x=1:3,size=1)

    idx = fnFindStringOfNumber(vec=vec, number=0, threshold=lsUtil$station_closeness)
  }

  return(vec)
}


fnFindStringOfNumber = function(vec, number, threshold){
  cat("\nfnFindStringOfNumber\n")

  count = 0
  max_count = 0
  idx = 0

  cat("vec=", vec, "length(vec)=", length(vec), "threshold=", threshold, "\n")

  for(ii in 1:length(vec)){
    cat("ii=", ii, " vec[ii]=", vec[ii], " number=", number, "\n")
    if(vec[ii] == number){
      count = count+1
      if(count > max_count){
        max_count = count
        idx = ii
      }
    } else {
      count = 0
    }

    if(max_count >= threshold){
      #return index where this chain started
      idx_to_return = idx - (threshold - 1)
      return(idx_to_return)
    }
  } #for end

  return(0) #if nothing was found

}

fnFixedVariables = function(){
  #read in the list-estaciones and return a dataframe with lower=upper bounds for a list of variables
  cat("\nfnFixedVariables\n")

  file = paste(getwd(), "/data/list-estaciones-fixed.txt", sep="")
  dfFile = read.table(file, header=T, sep=",")

  dfBounds = data.frame(matrix(NA, nrow=nrow(dfFile), ncol=4))
  names(dfBounds) = c("ID", "Road", "lower", "upper")
  dfBounds[, "ID"] = dfFile[, "ID_IMD"]
  dfBounds[, "Road"] = dfFile[, "Road"]
  dfBounds[, "lower"] = dfFile[, "TypeOfEstacion"]
  dfBounds[, "upper"] = dfBounds[, "lower"]

  return(dfBounds)
}

fnRepairFixedVariables = function(vec){
  #take a solution and set the fixed variables to their set levels
  cat("\nfnRepairFixedVariables\n")

  for(ii in 1:lsUtil$num_fixed_stations){
    #1. find the variable for this ID
    id = as.character(dfBounds[ii, "ID"])
    idx = which(dfIMD[, "ID"] == id)
    #2. set this variable to its bound
    vec[idx] = dfBounds[ii, "lower"]
  }

  return(vec)

}

fnMutate = function(vec){
  #take a solution and mutate a random bit in it
  cat("\nfnMutate\n")

  #choose a location randomly which to mutate
  r = sample(x=1:lsUtil$num_population, size=1)
  #choose a value to set randomly
  val = sample(x=0:3, size=1)
  #mutatation time!
  vec[r] = val

  return(vec)
}
