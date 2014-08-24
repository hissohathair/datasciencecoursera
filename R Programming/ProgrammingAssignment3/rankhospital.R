# Assignment 3 - part 2
#

#setwd("~/Dropbox/Study/R Programming/ProgrammingAssignment3")
source("rprog-scripts-submitscript3.R")

rankhospital <- function(state, proc, num) {
    # Given a state abbreviation, procedure name and ranking number, find the hospital
    # that ranks at that position in the state.
    #
    # Example: rankhospital("TX", "heart failure", 4)
    #           [1] "DETAR HOSPITAL NAVARRO"
    # 
    # Arguments:
    #   state       Two-letter US state abbreviation
    #   proc        Procedure name
    #   num         Ranking number (1 is "best")
    #
    
    ## Read outcome data
    #
    outcomes <- read.csv("outcome-of-care-measures.csv", colClasses="character")
    procedures <- c('heart attack'='Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                    'heart failure'='Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure', 
                    'pneumonia'='Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    desc <- FALSE
    
    ## Check that state and outcome are valid
    #
    if ( !(state %in% outcomes$State) ) {
        stop("invalid state")
    }  
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
    
    # Extract data for this state, convert procedure field to numeric, and check that 
    # ranking is possible (sufficient rows)
    #
    state_data <- outcomes[outcomes$State==state,]
    suppressWarnings(state_data[, procedures[proc]] <- sapply(state_data[, procedures[proc]], as.numeric))
    if ( num > nrow(state_data) )
        return(NA)
    
    ## Return hospital name in that state with lowest 30-day death rate
    #
    as.character(tail(head(state_data[order(state_data[[procedures[proc]]], state_data$Hospital.Name, na.last=TRUE, decreasing=desc), "Hospital.Name"], n=num), n=1))
}

