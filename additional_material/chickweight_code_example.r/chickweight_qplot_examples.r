#to start with, it can be useful to clear R's workspace, so that only the 
# R objects you want to be there are available, and you're not accidentally 
# using a version of an object from a previous section. A good command for cleaning
# the workspace is 
rm(list=ls())

# If you are using R within an R studio project, the working directory will be managed
# for you. The working directory is where files you want to access and create on the 
# computer's file system will be read or written if you don't give more specific 
# instructions (i.e. if you just specify the file name, but not the directory). 
# To find out the current working directory, use 
getwd()

# To set the working directory to something sensible, use:
setwd("C:/something_sensible")
#Change the string above to a sensible location for you

#Many R packages contain associated datasets. This includes the packages that are 
# loaded up by R by default, and includes a packages called 'datasets' that, unsurprisingly,
# contains lots of datasets. 
# The datasets are not loaded into the workspace at the outset. You can see this
# by looking at the contents of the environment, either by looking at the pane on the 
# top right when the tab selected is 'environment', or by typing
ls()

# To see what datasets are currently available, type
data()
# In RStudio, a new tab, 'R data sets', will appear on the top left pane.
# It shows which datasets are available from which package, the name of the dataset
# and a brief description of the dataset

# Not all datasets are stored as dataframes, which are the form ggplot2 works with, 
# and which are conceptually most similar to the tables most social scientists are used
# to from Excel, SPSS, and Stata. 

#One dataset which is in the right format is the ChickWeight dataset, which shows how
# the weight of chicks varies over time. To (almost) load this dataframe into the 
# workspace, use the command
data(ChickWeight)

#A new item has appeared in the environment tab on the top right. This lists the object
#ChickWeight as a 'promise' object. This means it's not yet been loaded, but as soon as the 
# data is needed by another function, it will be. By running (for example)
head(ChickWeight)
# we are requesting the data and completing the load, as well as displaying the first
# few rows of the dataset that has been loaded.
# The description of the data, on the environment pane, has now changed. It now says 
# 578 obs of 4 variables. It can also be viewed directly now by clicking on the small table
# icon to the right of the line describing the data in the environment pane. THis will 
# open up a new tab in the top left pane where you can view the data. 

# Another way of looking at the data is to use
summary(ChickWeight)
# Which shows some class appropriate summary statistics for each of the variables
# If we want to learn about the class of the data, we can type
class(ChickWeight)
# This shows that the data have multiple classes, the last of which is data.frame
# Classes are attributes attached to R objects. By telling R what class each object is
# R will know how to interpret calls to functions that need to treat different 
# types of objects differently. For example, the summary function earlier knew to 
# summarise the variables weight and Time in a different way to Chick and Diet, and 
# could only do this because each of the variables had a different class. We can see this
# by asking for the class of each of the variables in the ChickWeight dataframe one at a
# time, which we can do using $ symbol as follows:


class(ChickWeight$weight)
class(ChickWeight$Time)
class(ChickWeight$Chick)
class(ChickWeight$Diet)

# The classes of objects usually are set implicitly, though they can be set manually. 
# It is important to know the classes of objects, in particular the classes of different
# variables in datasets, when working with ggplot2 in R more generally, as if the 
# variable does not have the class you expect it to have then R will not interpret it,
# and ggplot2 will not draw it, the way you want it to be drawn. 
# This is an example of one of the many reasons it's important to know quite a lot about 
# how R works as a programming language in order to use it effectively as a statistical
# software and data visaualisation platform. 

# To write the dataframe as a csv file, use:
write.csv(ChickWeight, file="chick_weight.csv")
# Note the csv file will not contain the additional class information that the 
# R object itself contained. If you were to load from the csv file into a new data.frame
# the variables 'Chick' and 'Diet', for example, might be interpreted as numeric
# rather than factor variables, which will have consequences for how the data are 
# then presented in ggplot2, summarised in the summary function, and so on.

# The first time you are using a package on a particular computer, you need to install it
install.packages("ggplot2")

# All subsequent times you just need to load it using the library or require functions
require(ggplot2)

# We can now use ggplot to visualise the data. To start with let's have 
# weight on the y axis, and time on the x-axis, and use the simpler quickplot (qplot)
# qplot function which makes some educated guesses about the best way to present
# the data

# Fig 01
qplot(x=Time, y=weight, data=ChickWeight)
#qplot has chosen points as the geometric form to present the relationship with
# This is often a reasonable choice when presenting two dimensional relationships

# Let's look at just one dimension at a time, and see what qplot suggests
# Fig 02
qplot(x=weight, data=ChickWeight)
# In this case, qplot has chosen a histogram, which again is a reasonable way of 
# representing a lot of one dimensional data.

# Histograms require some kind of statistical aggregation to be performed on the data.
# I.e. the data are filted through some kind of statistic. The default statistic,
# the histogram, can be overridden as follows
#fig 03
qplot(x=weight, data=ChickWeight, stat="density")

# What if we want to explore how the weight varies by diet? Here are some approaches

qplot(y=weight, group=Diet, colour=Diet, data=ChickWeight) # fig 04
qplot(y=weight, x=Diet,  data=ChickWeight) # fig 05
qplot(y=weight, x=Diet,  data=ChickWeight, position="jitter") # fig 06
qplot(x=weight, facets = . ~ Diet,  data=ChickWeight, stat="density") # fig 07
qplot(x=weight, facets = . ~ Time, data=ChickWeight, stat = "density") # fig 08
qplot(x=weight, facets = Time ~ Diet,  data=ChickWeight, stat="density") # fig 09
qplot(y=weight, x=Diet, data=ChickWeight, geom="boxplot") # fig 10
qplot(y=weight, x=Diet, data=ChickWeight, geom="violin") #fig 11

#fig 12
qplot(
    y= weight, x=Time, 
    group=Chick, colour=Diet,
    data=ChickWeight, 
    geom="line"
    )

# fig 13
qplot(
    y= weight, x=Time, 
    group=Chick, facets =  ~ Diet,
    data=ChickWeight, 
    geom="line"
)




g1 <- qplot(
    y= weight, x=Time, 
    facets =  ~ Diet,
    data=ChickWeight, 
    geom="point"
)

#fig 14
print(g1)

#fig 15
g1 + stat_smooth()


g1 <- qplot(x=Time, y=weight, data=ChickWeight)
g1 + geom_line(aes(group=Chick)) # fig 16
g1 + geom_line(aes(group=Chick, colour=Chick)) #fig 17

g1 + geom_line() + facet_wrap( ~ Chick) # fig 18

g1 + stat_smooth() # fig 19
g1 + stat_smooth(method=loess) # fig 20
g1 + stat_smooth(method=lm) # fig 21
g1 + stat_smooth(method=glm) # Fig 22
