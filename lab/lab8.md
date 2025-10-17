# Lab 8
Hannah Pryor

<br>

Load tidyverse

``` r
library(tidyverse)
```

<br>

There are two general approaches when generating outputs from for loops.
The first approach is to define the output as a NULL object before the
loop, and in each iteration, append an element to the output using
functions such as `c()` and `bind_rows()`. The second approach is to
pre-specify the type and length of the output before the loop, and fill
in the output in each iteration. Design an experiment to systematically
compare the computational efficiency between the two approaches:

<br>

Approach one:

``` r
x <- 1:10
y <- 11:20
z <- NULL
for (i in 1:length(x)){
  z <- c(z, x[i] + y[i])
}
z
```

     [1] 12 14 16 18 20 22 24 26 28 30

<br>

Approach two:

``` r
x <- 1:10
y <- 11:20
z <- vector(mode = "double", length=10)
for (i in 1:length(x)){
  z[i] <- x[i] + y[i]
}
z
```

     [1] 12 14 16 18 20 22 24 26 28 30

<br>

How can we compare this?

**Given:** the `system.time()` function may be helpful

How does the `system.time()` function work?

``` r
?system.time()
```

Okay, looks like you can just copy-paste the code in here:

``` r
# for approach one:
system.time(for (i in 1:length(x)){
  z <- c(z, x[i] + y[i])
})
```

       user  system elapsed 
       0.00    0.00    0.02 

``` r
# for approach two:
system.time(for (i in 1:length(x)){
  z[i] <- x[i] + y[i]
})
```

       user  system elapsed 
       0.06    0.02    0.11 

Okay, I am seeing a more efficient user time for approach one, but lets
add bigger numbers to test if this holds up…

Wait, no, now it is giving me different answers every time! I think I’ll
still try the bigger numbers and see how that goes.

<br>

``` r
# for approach one:
x <- 1:1000
y <- 1001:2000
z <- NULL
system.time(for (i in 1:length(x)){
  z <- c(z, x[i] + y[i])
})
```

       user  system elapsed 
       0.01    0.00    0.03 

``` r
# for approach two:
x <- 1:1000
y <- 1001:2000
z <- vector(mode = "double", length=10)
system.time(for (i in 1:length(x)){
  z[i] <- x[i] + y[i]
})
```

       user  system elapsed 
       0.01    0.00    0.00 

Still getting very similar numbers…

<br>
