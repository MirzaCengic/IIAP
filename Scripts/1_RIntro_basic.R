##%######################################################%##
#                                                          #
####                 Our first R script                 ####
####          Mirza Cengic | mirzaceng@gmail.com        ####
#                                                          #
##%######################################################%##

# Add # to write a comment (notes about code, code description).
# It is important to write comments, your future self will be thankful!

# This is a function. 
# Use keyboard shortcut Ctrl + Enter to run a line of code (or code selection)
data()

# Get function help. In R Studio you can also press F1 button when cursor is in the function.
# Function data() lists data sets that already come with R or with one of the loaded packages.
?data()
# There can be multiple ways to do something in R
# Use help function to get help
help(data)

# This is an object - in R everything is an object.
# Iris is a dataset that comes with R 
iris
?iris



# Inspecting data ---------------------------------------------------------

# Show first six rows
head(iris)
head(iris, 3)
# Show last six rows
tail(iris)
# Show object's dimension
dim(iris)
# Show number of rows
nrow(iris)
# Object class
class(iris)
# Object structure
str(iris)

View(iris)
# Subsetting 

# NOTE:
# In R you can use 3 types of brackets - (), [] and {}
# Function use ()
# Use [] to subset objects
# Use {} to control flow (write loops) and write functions

# Other useful symbols - () [] {} $ @ %>% <- ? > <

# When subsetting object with rows and columns, rows are before the comma -- [x, ], and columns after comma -- [, x]

iris[1, 1]

# Use <- or = to assign value to an object
# If you use R Studio, use keyboard shortcut alt + - to insert assignment operator
iris[1, 1] <- 2

# Data types --------------------------------------------------------------

## Numeric
# Printing one number or sequence of numbers
1
1:10
# Combining values
c(1, 5)
# Create number sequence and store into variable
numbers <- seq(0, 10, 2.5)
numbers
# Mathematical operations
numbers + 1
numbers * 1
# Statistical operations
mean(numbers)
sum(numbers)
sd(numbers)
# Check object class
class(numbers)
# In R float and integer are both numeric
class(1)
class(1.0)

## String
string <- "numbers"

class(strings)

strings <- c("These", "are", "strings")
str(strings)
levels(strings)

## Factors
factors <- factor(c("These", "are", "factors"))
str(factors)
levels(factors)


## Boolean
# Less than
3 < 5
# Equals
3 == 3
# Not equals
3 != 3

## Logical with boolean
3 & 5 < 8
3 & 10 < 8

"a" < "b"
"c" < "b"

# Special
# Doesn't exist
?NULL
# Missing value
?NA
# Not a number
?NaN

#
iris
# See data structure
str(iris)
# See basic statistical summary for the data
summary(iris)


# You can use dollar sign $ to access a column in a dataframe
# Get table - frequency of values
table(iris$Species)
# See unique values
unique(iris$Species)
# See length of an object
length(iris$Species)
