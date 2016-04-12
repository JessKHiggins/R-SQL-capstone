#Fork this repo to your own GitHub account CHECK
#Clone your copy of the repo to your local machine CHECK
#Modify the R script plot_species_by_weight.R according to the comments in the script. Push your changes to GitHub.
#Modify the bash script run_R_analyses.sh to run the R script for each year (you can change the list of years, too)
#Run the analyses using the bash script


# extracts species and weights for a given year from portal rodent 
# database; makes a fancy plot and saves the plot to a file

library(RSQLite)
library(ggplot2)

# get command-line arguments
args <- commandArgs(TRUE)
if (length(args)==0) {
  stop("Script requires a year argument", call.=FALSE)
} else if (length(args)==1) {
  year <- args[1]
}

print(paste("Getting data for year",year))

# create a connection to the database
# 
myDB <- "~/Desktop/1314459/mammals_2.sqlite"
conn <- dbConnect(drv = SQLite(), dbname= myDB)

# some database functions for listing tables and fields
dbListTables(conn)
dbListFields(conn,"surveys")

# constructing a query
query_string <- paste(
  "SELECT weight,year,species_id
  FROM surveys
  WHERE weight IS NOT NULL AND year=",year, ';', sep="")

result<-dbGetQuery(conn,query_string)
head(result)

# write a query that gets the non-null weights for 
# all species in this year
query_string <- paste(
  "SELECT weight,year,species_id
  FROM surveys
  WHERE weight IS NOT NULL AND year=",year, ';', sep="")

result<-dbGetQuery(conn,query_string)
head(result)

# plot the data and save to a png file
ggplot(data=result, aes(x=species_id, y=weight))+
  geom_boxplot()+theme_bw()+
  xlab("Species ID")+ylab("Weight (g)")+
  geom_jitter(color="darkblue", alpha=.3)
outputfilename <- paste("spp_weight",year,".png", sep="")
ggsave(outputfilename, width=5, height=5, units="in" )
