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
    "edsqass4avgts1011",	
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

# I'm now goint to separate ds_1 into two smaller datasets
# one in which the year is the last two digits
# the other in which the year is the last four digits

var_4 <- c(
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
  "crsimdcrime_totno2011",  
  "crsimdcrime_totno2008",
  "crsimdcrime_totno2004",
  "simd2004",  
  "simd2006"  
  )

ds_1_var_4 <- subset(
  ds_1, 
  subset=variable %in% var_4
  )

# Take numbers and replace them with ""

ds_1_var_4$variable <- str_replace(ds_1_var_4$variable,
                                   "[0123456789]{1,4}", ""
                                   )

###
> unique(ds_1_var_4$variable)
[1] "crsimdcrime_totrat" "edsldf_other_p_"    "edsldf_positive_p_" "crsimdcrime_totno" 
[5] "simd" 




var_2 <- c(
  "simd12",  
  "simd09",	
  "edsqass4avgts1011",	
  "dec_simd12",	
  "q_simd12"
  )

# 
# DS 1
# datazone
# crsimdcrime_totrat2004  
# crsimdcrime_totrat2008	
# crsimdcrime_totrat2011	
# edsldf_other_p_2008	
# edsldf_other_p_2009	
# edsldf_other_p_2011	
# edsldf_other_p_2012	
# edsldf_other_p_2013	
# edsldf_positive_p_2008	
# edsldf_positive_p_2009	
# edsldf_positive_p_2010	
# edsldf_positive_p_2011	
# edsldf_positive_p_2012	
# edsldf_positive_p_2013	
# simd12  
# simd09	
# simd09v2	
# edsqass4avgts1011	
# dec_simd12	
# q_simd12
# crsimdcrime_totno2011  
# crsimdcrime_totno2008	
# crsimdcrime_totno2004
# simd2004  
# simd2006


# D2
# no_total_jsa_august99  
# no_total_jsa_november99	
# no_total_jsa_february00	
# no_total_jsa_may00	
# no_total_jsa_august00	
# no_total_jsa_november00	
# no_total_jsa_february01	
# no_total_jsa_may01	
# no_total_jsa_august01	
# no_total_jsa_november01	
# no_total_jsa_february02	
# no_total_jsa_may02	
# no_total_jsa_august02	
# no_total_jsa_november02	
# no_total_jsa_february03	
# no_total_jsa_may03	
# no_total_jsa_august03	
# no_total_jsa_november03	
# no_total_jsa_february04	
# no_total_jsa_may04	
# no_total_jsa_august04	
# no_total_jsa_november04	
# no_total_jsa_february05	
# no_total_jsa_may05	
# no_total_jsa_august05	
# no_total_jsa_november05	
# no_total_jsa_february06	
# no_total_jsa_may06	
# no_total_jsa_august06	
# no_total_jsa_november06	
# no_total_jsa_february07	
# no_total_jsa_may07	
# no_total_jsa_august07	
# no_total_jsa_november07	
# no_total_jsa_february08	
# no_total_jsa_may08	
# no_total_jsa_august08	
# no_total_jsa_november08	
# no_total_jsa_february09	
# no_total_jsa_may09	
# no_total_jsa_august09	
# no_total_jsa_november09	
# no_total_jsa_february10	
# no_total_jsa_may10	
# no_total_jsa_august10	
# no_total_jsa_november10	
# no_total_jsa_february11	
# no_total_jsa_may11	
# no_total_jsa_august11	
# no_total_jsa_november11	
# no_total_jsa_february12	
# no_total_jsa_may12	
# no_total_jsa_august12	
# no_total_jsa_november12	
# no_total_jsa_february13	
# no_total_jsa_may13	
# no_total_jsa_august13	
# no_total_jsa_november13	
# no_total_jsa_1624_august1999	
# no_total_jsa_1624_november1999	
# no_total_jsa_1624_february2000	
# no_total_jsa_1624_may2000	
# no_total_jsa_1624_august2000	
# no_total_jsa_1624_november2000
# no_total_jsa_1624_february2001	
# no_total_jsa_1624_may2001	
# no_total_jsa_1624_august2001	
# no_total_jsa_1624_november2001	
# no_total_jsa_1624_february2002	
# no_total_jsa_1624_may2002	
# no_total_jsa_1624_august2002	
# no_total_jsa_1624_november2002	
# no_total_jsa_1624_february2003	
# no_total_jsa_1624_may2003	
# no_total_jsa_1624_august2003	
# no_total_jsa_1624_november2003	
# no_total_jsa_1624_february2004	
# no_total_jsa_1624_may2004	
# no_total_jsa_1624_august2004	
# no_total_jsa_1624_november2004	
# no_total_jsa_1624_february2005	
# no_total_jsa_1624_may2005	
# no_total_jsa_1624_august2005	
# no_total_jsa_1624_november2005	
# no_total_jsa_1624_february2006	
# no_total_jsa_1624_may2006	
# no_total_jsa_1624_august2006	
# no_total_jsa_1624_november2006	
# no_total_jsa_1624_february2007	
# no_total_jsa_1624_may2007	
# no_total_jsa_1624_august2007	
# no_total_jsa_1624_november2007	
# no_total_jsa_1624_february2008	
# no_total_jsa_1624_may2008	
# no_total_jsa_1624_august2008	
# no_total_jsa_1624_november2008	
# no_total_jsa_1624_february2009	
# no_total_jsa_1624_may2009	
# no_total_jsa_1624_august2009	
# no_total_jsa_1624_november2009	
# no_total_jsa_1624_february2010	
# no_total_jsa_1624_may2010	
# no_total_jsa_1624_august2010	
# no_total_jsa_1624_november2010	
# no_total_jsa_1624_february2011	
# no_total_jsa_1624_may2011	
# no_total_jsa_1624_august2011	
# no_total_jsa_1624_november2011	
# no_total_jsa_1624_february2012	
# no_total_jsa_1624_may2012	
# no_total_jsa_1624_august2012	
# no_total_jsa_1624_november2012	
# no_total_jsa_1624_february2013	
# no_total_jsa_1624_may2013	
# no_total_jsa_1624_august2013	
# no_total_jsa_1624_november2013	
# cs_jsa_pertotal_2001q01	
# cs_jsa_pertotal_2001q02	
# cs_jsa_pertotal_2001q03	
# cs_jsa_pertotal_2001q04	
# cs_jsa_pertotal_2002q01	
# cs_jsa_pertotal_2002q02	
# cs_jsa_pertotal_2002q03	
# cs_jsa_pertotal_2002q04	
# cs_jsa_pertotal_2003q01	
# cs_jsa_pertotal_2003q02	
# cs_jsa_pertotal_2003q03	
# cs_jsa_pertotal_2003q04	
# cs_jsa_pertotal_2004q01	
# cs_jsa_pertotal_2004q02	
# cs_jsa_pertotal_2004q03	
# cs_jsa_pertotal_2004q04	
# cs_jsa_pertotal_2005q01	
# cs_jsa_pertotal_2005q02	
# cs_jsa_pertotal_2005q03	
# cs_jsa_pertotal_2005q04



