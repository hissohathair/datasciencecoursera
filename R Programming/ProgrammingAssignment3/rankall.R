# Assignment 3 - part 3
#

#setwd("~/Dropbox/Study/R Programming/ProgrammingAssignment3")
source("rprog-scripts-submitscript3.R")
source("rankhospital.R")

my_rankall <- function(proc, num = "best") {
    # Given a procedure name and ranking number, find the hospitals
    # that ranks at that position in all the states.
    #
    # Example: rankall("heart failure", 4)
    # 
    # Arguments:
    #   proc        Procedure name
    #   num         Ranking number (1 is "best")
    #
    
    ## Check that state and outcome are valid
    #
    procedures <- c('heart attack'='Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                    'heart failure'='Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure', 
                    'pneumonia'='Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    desc <- FALSE
    if ( !(proc %in% names(procedures)) ) {
        stop("invalid outcome")
    }

    if ( num == "best" ) {
        num <- 1
    }
    else if ( num == "worst" ) {
        num <- 1
        desc <- TRUE
    }
    else if ( !is.numeric(num) ) {
        stop("invalid rank")
    }

    ## For each state, find the hospital of the given rank
    #
    outcomes <- read.csv("outcome-of-care-measures.csv", colClasses="character")
    data <- data.frame()
    for ( state in sort(unique(outcomes$State)) ) {
        hospital <- rankhospital(state, proc, num)
        data <- rbind(data, data.frame(state = state, hospital = hospital))
    }
    return(data)
}

rankall <- function(outcome, num = "best") {
  outcomes <- c('heart attack', 'heart failure', 'pneumonia')
  indices <- c(11, 17, 23)
  
  if (!outcome %in% outcomes) stop("invalid outcome")
  
  data <- read.csv("outcome-of-care-measures.csv")
  
  i <- indices[match(outcome, outcomes)]
  hospitals <- data[, c(2, 7, i)]
  hospitals[, 3] <- as.numeric(as.character(hospitals[, 3]))
  hospitals <- na.omit(hospitals)
  names(hospitals) <- c("hospital", "state", "rate")
  
  if (num == "best") {
    num <- 1
  } else if (num == "worst") {
  } else {
    num <- as.numeric(num)
    if (is.na(num)) {
      stop("invalid num")
    } else if (num > nrow(hospitals)) {
      return(NA)
    }
  }
  
  results <- NULL
  
  for(state in levels(hospitals$state)) {
    hospitals_for_state <- hospitals[hospitals$state == state, ]
    
    if (num == "worst") {
      n <- nrow(hospitals_for_state)
    } else {
      n <- num
    }
    result <- hospitals_for_state[order(hospitals_for_state$rate, hospitals_for_state$hospital), c(1, 2)][n, ]
    result$state <- rep(state, nrow(result))
    results <- rbind(results, result)  
  }
  
  rownames(results) <- NULL
  
  return(results)
}