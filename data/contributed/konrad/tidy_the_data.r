# Script to rearrange sns data contributed by Konrad.
# 20/10/2014

# First, load the data

data <- read.csv("data/contributed/konrad/dta/dzs_part.csv", na.strings=" ")
# Start to explore
head(data)

apply(data, 2, class)
# This shows that the variables are all read in as character data rather than numeric, 
# so some additional cleaning will be needed. However that's a later problem. 

# Datasets identified:

ds_1 <- subset(
  data,
  select = c(
    "datazone", 
    "crsimdcrime_totrat2004",
    "crsimdcrime_totrat2008",
    "crsimdcrime_totrat2011",
    "edsldf_other_p_2008",  
    "edsldf_other_p_2009", 
    "edsldf_other_p_2011",
    "edsldf_other_p_2012",
    "edsldf_other_p_2013",  
    "edsldf_positive_p_2008",
    "edsldf_positive_p_2009",	
    "edsldf_positive_p_2010",	
    "edsldf_positive_p_2011",	
    "edsldf_positive_p_2012",	
    "edsldf_positive_p_2013",	
    "simd12",  
    "simd09",	
    "dec_simd12",	
    "q_simd12",
    "crsimdcrime_totno2011",  
    "crsimdcrime_totno2008",
    "crsimdcrime_totno2004",
    "simd2004",  
    "simd2006"
    )
               )


# For most of these variables, the final four characters of the name include 
# the year.
# Exceptions are
# simd12 : last two digits
# edgass4avgts1011
# dec_simd12
# q_simd12

# However, for all variables it seems the final two digits 
# consistently show the years

# The aim is therefore to extract the last two digits and 
# use this to populate a separate variable, year

# First task: 'melt' the data using reshape2

require(reshape2)

ds_1 <- melt(ds_1, id="datazone")

year_part <- str_sub(ds_1$variable, str_length(ds_1$variable) - 1)
year_part <- as.numeric(year_part)
year_part <- 2000 + year_part
ds_1$year <- year_part
rm(year_part)


# Take numbers and replace them with ""
require(stringr)


ds_1$variable <- str_replace(ds_1$variable,
                                   "[0-9]{1,}", ""
                                   )

unique(ds_1$variable)

require(plyr)

ds_1$variable <- revalue(
  ds_1$variable,
  c(
    "crsimdcrime_totrat"="crime_rate",
    "edsldf_positive_p_" = "school_leaver_pos_rate",
    "edsldf_other_p_"="school_leaver_other_rate",
    "dec_simd"="simd_decile",
    "q_simd"="simd_quintile",
    "crsimdcrime_totno"="crime_count"
    )
  )


ds_1_tidy <- dcast(ds_1, id.var=c("datazone", "year"), ... ~ variable)
ds_1_tidy <- arrange(ds_1_tidy, year, datazone)

ds_1_tidy[,-1] <- apply(ds_1_tidy[,-1], 2, as.numeric)


###############################################################
# Next example

jsa_vars <- str_detect(
  names(data),
  "^no_total_jsa"
  )

names(data)[jsa_vars]

ds_jsa <- subset(
  data,
  select=c(
    "datazone",
    names(data)[jsa_vars]       
           )
  )

ds_jsa <- melt(ds_jsa, id.var=c("datazone"))
ds_jsa$value <- as.numeric(ds_jsa$value)

# In all cases, the date information is contained in the section of the name from the 
# _ character to the end of the string

ds_jsa$month_year <- str_match(
  ds_jsa$variable,
  "[^_]*?$"
  )


# year only

ds_jsa$year <- str_sub(ds_jsa$variable, str_length(ds_jsa$variable) - 1)
ds_jsa$year <- as.numeric(ds_jsa$year)

is_99 <- which(ds_jsa$year==99)
ds_jsa$year <- ds_jsa$year + 2000
ds_jsa$year[is_99] <- ds_jsa$year[is_99] - 100

ds_jsa$month <- str_sub(ds_jsa$month_year, 1, str_length(ds_jsa$month_year)-2)

unique(ds_jsa$month)

ds_jsa$month <- str_replace(ds_jsa$month, "[0-9]{1,2}", "")

ds_jsa$quarter <- revalue(
  ds_jsa$month,
    c(
      "february"=1,
      "may"=2,
      "july" =3,
      "august"=3,
      "november"=4
      )
  )

ds_jsa$quarter <- as.numeric(ds_jsa$quarter)

ds_jsa$yearpart <- revalue(
  ds_jsa$month,
   c(
     "february"=1.5/12,
     "may"=4.5/12,
     "july" =6.5/12,
     "august"=7.5/12,
     "november"=10.5/12     
     )                               
  )

ds_jsa$year <- as.numeric(ds_jsa$year)
ds_jsa$yearpart <- as.numeric(ds_jsa$yearpart)
ds_jsa$year_combined <- ds_jsa$year + ds_jsa$yearpart

ds_jsa$month_year <- NULL
ds_jsa$yearpart <- NULL
ds_jsa$variable <- "jsa_claimant_count"
ds_jsa$value <- as.numeric(ds_jsa$value)
ds_jsa$month <- NULL
ds_jsa$quarter <- NULL
ds_jsa$year <- NULL
ds_jsa_backup <- ds_jsa
ds_jsa <- dcast(
  ds_jsa,  
  formula= ... ~ variable,
  id= c("datazone",  "year_combined"),
  mean
  )

ds_jsa <- arrange(ds_jsa, year_combined, datazone)


