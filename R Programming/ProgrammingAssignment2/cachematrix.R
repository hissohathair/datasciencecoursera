# 
# Programming Assignmen 2 for "R Programming"
#

makeCacheMatrix <- function(x = matrix()) {
    # Creates a matrix that is able to cache its own inverse, and
    # return it if the matrix has not changed since the inverse was
    # calculated.
    #
    # Arguments:
    #   x   The initial matrix
    #
    # Returns:
    #   A list containing:
    #       - 2 functions to get and set the matrix respectively; and
    #       - 2 functions to get and set the cached inverse respectively.
	#

    # inverseCache -- var belongs in lexical scope of this function. Its
    # value will persist after the function has been called.
    inverseCache <- NULL
    
    # Define a "setter" function to overwrite previous "x" value and
    # invalidate the cache.
    set <- function(newX) {
        x <<- newX             # using "<<-" because we want lexical parent's scope
        inverseCache <<- NULL  # ditto
    }
    
    # Define a function to return matrix last set with "set"
    get <- function() { 
        x
    }
    
    # Define a function to calculate the inverse of the matrix
    setInverse <- function(newInverse) {
        inverseCache <<- newInverse
    }
    
    # Define a function to return the cached inverse
    getInverse <- function() {
        inverseCache
    }
    
    #
    list(set = set, get = get, setInverse = setInverse, getInverse = getInverse)
}


cacheSolve <- function(x, ...) {
    # The following function calculates the inverse of a matrix 
    # created with the above function. A previously calculated cache
    # will be used, if it exists.
    #
    # Arguments:
    #   x   Matrix to solve
    #
    # Returns:
    #   Solved matrix, possibly using a cached value if the matrix has
    #   not been modified since it was last calculated.
    
    # Check for previously calculated value
    inverse <- x$getInverse()
    if (!is.null(inverse)) {
        message("Info: Using cached data")
        return(inverse)
    }
    
    # No cached value. So calculate from scratch, cache the result, then
    # return the new value.
    data <- x$get()
    inverse <- solve(data, ...)
    x$setInverse(inverse)
    inverse
}


# Compares 2 matrixes. Source: https://stat.ethz.ch/pipermail/r-help/2012-June/315408.html
matequal <- function(x, y) {
    is.matrix(x) && is.matrix(y) && dim(x) == dim(y) && all(x == y)
}


testAssignment <- function() {
    # Really simple "smoke-test".
    testData <- matrix(rnorm(9, 100), ncol=3, nrow=3)
    expectedData <- solve(testData)
    
    x <- makeCacheMatrix(testData)
    gotData <- cacheSolve(x)
    if ( matequal(gotData, expectedData) ) {
        message("Ok")
    }
    else {
        message("FAIL")
    }
}