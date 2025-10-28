
# WRITING FUNCTIONS

# multitasking in class, review this lecture on the course site after exam today

# function name <- function(inputs) {
#   output value <- do something(inputs)
#   return(output value)
# }


calc_shrub_vol <- function(length, width, height) {
  area <- length*width
  volume <- area*height
  return(volume)
}


calc_shrub_vol(0.8, 1.6, 2.0)



convert_pounds_to_grams <- function(pounds) {
  grams <- 453.6*pounds
  return(grams)
}

convert_pounds_to_grams(3.75)


# can specify default values by doing like height=1 in the function code

# can use the for loop code to make a function to do the same thing, too!
## did an example of this with the for loop country example we were working on

# review your turn section to specify file type for output in the function
## add file type argument to function, then change the argument in ggsave to 
## that file type value, have a "." between stat and file type in the ggsave

# TOOK A PHOTO OF THE CODE EXAMPLE IN CLASS - ADD TO NOTES!