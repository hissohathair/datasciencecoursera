# Assignment 3 - part 1
#

setwd("~/Dropbox/Study/R Programming/ProgrammingAssignment3")
source("rprog-scripts-submitscript3.R")

# Part 1
#   > outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
#
# Explore the data:
#   > head(outcome)
#   > ncol(outcome); nrow(outcome)
#   > outcome[, 11] <- as.numeric(outcome[, 11]) ## You may get a warning about NAs being introduced; that is okay
#   > hist(outcome[, 11])


best <- function(state, proc) {
    # Given a two-letter abbreviation for a US state, and a procedure name, 
    # return the "best" hospital in that state.
    # 
    # Example: best("TX", "heart attack")
    #           [1] "CYPRESS FAIRBANKS MEDICAL CENTER"
    # 
    # Arguments:
    #   state       Two-letter US state abbreviation
    #   proc        Procedure name.
    #
    
    ## Read outcome data
    #
    outcomes <- read.csv("outcome-of-care-measures.csv", colClasses="character")
    procedures <- c('heart attack'='Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                    'heart failure'='Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure', 
                    'pneumonia'='Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    
    ## Check that state and outcome are valid
    if ( !(state %in% outcomes$State) )
        stop("invalid state")
    
    if ( !(proc %in% names(procedures)) )
        stop("invalid outcome")
    
    ## Return hospital name in that state with lowest 30-day death rate
    state_data <- outcomes[outcomes$State==state,]
    suppressWarnings(state_data[, procedures[proc]] <- sapply(state_data[, procedures[proc]], as.numeric))
    as.character(head(state_data[order(state_data[[procedures[proc]]], state_data$Hospital.Name, na.last = TRUE), "Hospital.Name"], n=1))
}

