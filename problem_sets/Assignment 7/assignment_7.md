# Assignment 7
Hannah Pryor

<br>

Load packages

``` r
library(tidyverse)
library(knitr)
library(dslabs) #install.packages("dslabs")
```

<br>

## Excercise: 2016 election result and polling

For this exercise, we will explore the result of the 2016 US
presidential election as well as the polling data. We will use the
following three datasets in the `dslabs` package, and use `join`
function to connect them together. As a reminder, you can use `?` to
learn more about these datasets.

- `results_us_election_2016`: Election results (popular vote) and
  electoral college votes from the 2016 presidential election.

- `polls_us_election_2016`: Poll results from the 2016 presidential
  elections.

- `murders`: Gun murder data from FBI reports. It also contains the
  population of each state.

We will also use [this
dataset](https://raw.githubusercontent.com/kshaffer/election2016/master/2016ElectionResultsByState.csv)
to get the exact numbers of votes for question 3.

<br>

### Question 1. What is the relationship between the population size and the number of electoral votes each state has?

**1a.** Use a `join` function to combine the `murders` dataset, which
contains information on population size, and
the `results_us_election_2016` dataset, which contains information on
the number of electoral votes. Name this new dataset `q_1a`, and show
its first 6 rows.

``` r
# join two datasets into one with state
q_1a <- left_join(murders, results_us_election_2016)
```

    Joining with `by = join_by(state)`

``` r
q_1a |> 
  head(6) |> 
  kable()
```

| state | abb | region | population | total | electoral_votes | clinton | trump | johnson | stein | mcmullin | others |
|:---|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Alabama | AL | South | 4779736 | 135 | 9 | 34.35795 | 62.08309 | 2.094169 | 0.4422682 | 0.0000000 | 1.0225246 |
| Alaska | AK | West | 710231 | 19 | 3 | 36.55087 | 51.28151 | 5.877128 | 1.8000176 | 0.0000000 | 4.4904710 |
| Arizona | AZ | West | 6392017 | 232 | 11 | 44.58042 | 48.08314 | 4.082188 | 1.3185997 | 0.6699155 | 1.2657329 |
| Arkansas | AR | South | 2915918 | 93 | 6 | 33.65190 | 60.57191 | 2.648769 | 0.8378174 | 1.1653206 | 1.1242832 |
| California | CA | West | 37253956 | 1257 | 55 | 61.72640 | 31.61711 | 3.374092 | 1.9649200 | 0.2792070 | 1.0382753 |
| Colorado | CO | West | 5029196 | 65 | 9 | 48.15651 | 43.25098 | 5.183748 | 1.3825031 | 1.0400874 | 0.9861714 |

<br>

**1b.** Add a new variable in the `q_1a` dataset to indicate which
candidate won in each state, and remove the columns `abb`, `region`,
and `total`. Name this new dataset `q_1b`, and show its first 6 rows.

``` r
q_1b <- q_1a |> 
  mutate(winner=ifelse(trump > clinton, "trump", "clinton")) |> 
  select(-abb, -region, -total)

q_1b |> 
  head(6) |> 
  kable()
```

| state | population | electoral_votes | clinton | trump | johnson | stein | mcmullin | others | winner |
|:---|---:|---:|---:|---:|---:|---:|---:|---:|:---|
| Alabama | 4779736 | 9 | 34.35795 | 62.08309 | 2.094169 | 0.4422682 | 0.0000000 | 1.0225246 | trump |
| Alaska | 710231 | 3 | 36.55087 | 51.28151 | 5.877128 | 1.8000176 | 0.0000000 | 4.4904710 | trump |
| Arizona | 6392017 | 11 | 44.58042 | 48.08314 | 4.082188 | 1.3185997 | 0.6699155 | 1.2657329 | trump |
| Arkansas | 2915918 | 6 | 33.65190 | 60.57191 | 2.648769 | 0.8378174 | 1.1653206 | 1.1242832 | trump |
| California | 37253956 | 55 | 61.72640 | 31.61711 | 3.374092 | 1.9649200 | 0.2792070 | 1.0382753 | clinton |
| Colorado | 5029196 | 9 | 48.15651 | 43.25098 | 5.183748 | 1.3825031 | 1.0400874 | 0.9861714 | clinton |

<br>

**1c.** Using the `q_1b` dataset, plot the relationship between
population size and number of electoral votes. Use color to indicate who
won the state. Fit a straight line to the data, set its color to black,
size to 0.1, and turn off its confidence interval.

``` r
q_1b |> 
  ggplot(aes(x=population, y=electoral_votes, color=winner)) +
  geom_point()+
  geom_smooth(color="black", lwd=0.1, se=FALSE)
```

![](assignment_7_files/figure-commonmark/unnamed-chunk-4-1.png)

<br>

<br>

### Question 2. Would the election result be any different if the number of electoral votes is exactly proportional to a state’s population size?

**2a.** First, convert the `q_1b` dataset to longer format such that the
`population` and `electoral_votes` columns are turned into rows as shown
below. Name this new dataset `q_2a`, and show its first 6 rows.

``` r
q_2a <- q_1b |> 
  pivot_longer(c(population, electoral_votes)) |> 
  rename(metric=name)

q_2a |> 
  head(6) |> 
  kable()
```

| state | clinton | trump | johnson | stein | mcmullin | others | winner | metric | value |
|:---|---:|---:|---:|---:|---:|---:|:---|:---|---:|
| Alabama | 34.35795 | 62.08309 | 2.094169 | 0.4422682 | 0.0000000 | 1.022525 | trump | population | 4779736 |
| Alabama | 34.35795 | 62.08309 | 2.094169 | 0.4422682 | 0.0000000 | 1.022525 | trump | electoral_votes | 9 |
| Alaska | 36.55087 | 51.28151 | 5.877128 | 1.8000176 | 0.0000000 | 4.490471 | trump | population | 710231 |
| Alaska | 36.55087 | 51.28151 | 5.877128 | 1.8000176 | 0.0000000 | 4.490471 | trump | electoral_votes | 3 |
| Arizona | 44.58042 | 48.08314 | 4.082188 | 1.3185997 | 0.6699155 | 1.265733 | trump | population | 6392017 |
| Arizona | 44.58042 | 48.08314 | 4.082188 | 1.3185997 | 0.6699155 | 1.265733 | trump | electoral_votes | 11 |

<br>

**2b.** Then, sum up the number of electoral votes and population size
across all states for each candidate. Name this new dataset `q_2b`, and
print it as shown below.

``` r
q_2b <- q_2a |> 
  select(metric, winner, value) |> 
  group_by(metric, winner) |> 
  summarise(value=sum(value))

q_2b |> 
  head(6) |> 
  kable()
```

| metric          | winner  |     value |
|:----------------|:--------|----------:|
| electoral_votes | clinton |       231 |
| electoral_votes | trump   |       302 |
| population      | clinton | 134982448 |
| population      | trump   | 174881780 |

<br>

**2c.** Use the `q_2b` dataset to contruct a bar plot to show the final
electoral vote share under the scenarios of **1)** each state has the
number of electoral votes that it currently has, and **2)** each state
has the number of electoral votes that is exactly proportional to its
population size. Here, assume that for each state, the winner will take
all its electoral votes.

``` r
q_2b |> 
  ggplot(aes(x=metric, color=winner, fill = winner)) +
  geom_bar(position="fill") +
  geom_col(aes(y=value), position="fill")
```

![](assignment_7_files/figure-commonmark/unnamed-chunk-7-1.png)

<br>

### Question 3. What if the election was determined by popular votes?

**3a.** First, from [this dataset on
GitHub](https://raw.githubusercontent.com/kshaffer/election2016/master/2016ElectionResultsByState.csv),
calculate the number of popular votes each candidate received as shown
below. Name this new dataset `q_3a`, and print it.

*Note: Vote counts are listed for several other candidates. Please
combine the votes for all candidates other than Clinton and Trump into a
single `others` category (as shown in the table below)*

*Hint: `pivot_longer()` may be useful in here.*

``` r
q_3a <- read_csv("https://raw.githubusercontent.com/kshaffer/election2016/master/2016ElectionResultsByState.csv")

# probably not the most efficient way to do this but I am tired
q_3a <- q_3a |> 
  mutate(others=sum(johnsonVotes, steinVotes, mcmullinVotes, othersVotes)) |>
  mutate(trump=sum(trumpVotes)) |> 
  mutate(clinton=sum(clintonVotes)) |> 
  pivot_longer(c(others, trump, clinton)) |> 
  rename(winner=name) |> 
  select(winner, value) |> 
  mutate(metric="popular_votes") |>
  group_by(metric, winner) |> 
  summarize(value=unique(value))

q_3a |> 
  kable()
```

| metric        | winner  |    value |
|:--------------|:--------|---------:|
| popular_votes | clinton | 65125640 |
| popular_votes | others  |  7054974 |
| popular_votes | trump   | 62616675 |

<br>

**3b.** Combine the `q_2b` dataset with the `q_3a` dataset. Call this
new dataset `q_3b`, and print it as shown below.

``` r
q_3b <- full_join(q_2b, q_3a)
```

    Joining with `by = join_by(metric, winner, value)`

``` r
q_3b |> 
  kable()
```

| metric          | winner  |     value |
|:----------------|:--------|----------:|
| electoral_votes | clinton |       231 |
| electoral_votes | trump   |       302 |
| population      | clinton | 134982448 |
| population      | trump   | 174881780 |
| popular_votes   | clinton |  65125640 |
| popular_votes   | others  |   7054974 |
| popular_votes   | trump   |  62616675 |

<br>

**3c.** Lastly, use the `q_3b` dataset to construct a bar plot to show
the final vote share under the scenarios of **1)** each state has the
number of electoral votes that it currently has, **2)** each state has
the number of electoral votes that is exactly proportional to its
population size, and **3)** the election result is determined by the
popular vote.

``` r
q_3b |> 
  ggplot(aes(x=metric, color=winner, fill = winner)) +
  geom_bar(position="fill") +
  geom_col(aes(y=value), position="fill")
```

![](assignment_7_files/figure-commonmark/unnamed-chunk-10-1.png)

<br>

<br>

### Question 4. The election result in 2016 came as a huge surprise to many people, especially given that most polls predicted Clinton would win before the election. Where did the polls get wrong?

**4a.** The polling data is stored in the data frame
`polls_us_election_2016`. For the sake of simplicity, we will only look
at the data from a single poll for each state. Subset the polling data
to include only the results from the pollster `Ipsos`. Exclude national
polls, and for each state, select the polling result with the `enddate`
closest to the election day (i.e. those with the lastest end date). Keep
only the columns `state`, `adjpoll_clinton`, and `adjpoll_trump`. Save
this new dataset as `q_4a`, and show its first 6 rows.

*Note: You should have 47 rows in `q_4a` because only 47 states were
polled at least once by Ipsos. You don’t need to worry about the 3
missing states and DC.*

*Hint: `group_by()` and `slice_max()` can be useful for this question.
Check out the help file for `slice_max()` for more info.*

``` r
q_4a <- polls_us_election_2016 |> 
  filter(pollster=="Ipsos") |> 
  filter(!state=="U.S.") |> 
  group_by(state) |> 
  filter(enddate==max(enddate)) |> 
  select(state, adjpoll_clinton, adjpoll_trump) |> 
  arrange(state)

q_4a |> 
  head(6) |> 
  kable()
```

| state       | adjpoll_clinton | adjpoll_trump |
|:------------|----------------:|--------------:|
| Alabama     |        37.54023 |      53.69718 |
| Arizona     |        41.35774 |      46.17779 |
| Arkansas    |        37.15339 |      53.28384 |
| California  |        58.33806 |      31.00473 |
| Colorado    |        46.00764 |      40.73571 |
| Connecticut |        48.81810 |      38.87069 |

<br>

**4b.** Combine the `q_4a` dataset with the `q_1b` dataset with a `join`
function. The resulting dataset should only have 47 rows. Create the
following new variables in this joined dataset.

- `polling_margin`: difference between `adjpoll_clinton` and
  `adjpoll_trump`

- `actual_margin`: difference between `clinton` and `trump`

- `polling_error`: difference between `polling_margin` and
  `actual_margin`

- `predicted_winner`: predicted winner based on `adjpoll_clinton` and
  `adjpoll_trump`

- `result = ifelse(winner == predicted_winner, "correct prediction", str_c("unexpected ", winner, " win"))`

Keep only the columns `state`, `polling_error`, `result`,
`electoral_votes`. Name the new dataset `q_4b` and show its first 6
rows.

``` r
q_4b <- left_join(q_4a, q_1b)
```

    Joining with `by = join_by(state)`

``` r
q_4b <- q_4b |> 
  mutate(polling_margin = (adjpoll_clinton-adjpoll_trump)) |> 
  mutate(actual_margin = (clinton-trump)) |> 
  mutate(polling_error = (polling_margin-actual_margin)) |> 
  mutate(predicted_winner = ifelse(trump>clinton, "trump", "clinton")) |> 
  mutate(result = ifelse(winner == predicted_winner, "correct prediction", str_c("unexpected ", winner, " win"))) |> 
  select(state, polling_error, result, electoral_votes)

q_4b |> 
  head(6) |> 
  kable()
```

| state       | polling_error | result             | electoral_votes |
|:------------|--------------:|:-------------------|----------------:|
| Alabama     |    11.5681966 | correct prediction |               9 |
| Arizona     |    -1.3173239 | correct prediction |              11 |
| Arkansas    |    10.7895518 | correct prediction |               6 |
| California  |    -2.7759631 | correct prediction |              55 |
| Colorado    |     0.3663946 | correct prediction |               9 |
| Connecticut |    -3.6919767 | correct prediction |               7 |

<br>

**4c.** Generate the following plot with the `q_4b` dataset. Use chunk
options to adjust the dimensions of the plot to make it longer than the
default dimension. Based on this plot, where did the polls get wrong in
the 2016 election?

``` r
q_4b |> 
  ggplot(aes(x=polling_error, y=state, color=result, size=electoral_votes))+
  geom_point()
```

![](assignment_7_files/figure-commonmark/unnamed-chunk-13-1.png)

I got that all of them were correct predictions, which clearly isn’t
right??? Based on the plot in the example, the polls went wrong in
Wisconsin, Pennsylvania, Ohio, Michigan, and Florida.
