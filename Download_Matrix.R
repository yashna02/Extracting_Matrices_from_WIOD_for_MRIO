# Load nice packages
library(tidyr)
library(dplyr)
library(tidyverse)
library(writexl)

#set working directory
setwd('C:/Users/DELL/Desktop/IGIDR MSc/Sem 4/Thesis/R Codes/WIOTS_in_R')

# Create a vector of years from 2000 to 2014
years <- 2000:2014

# Iterate over each year
for (year in years) {
  print(paste0("Calculating Matrices for ", year))
  
  # Read the WIOT data for the current year
  wiot <- read_rds(paste0("wiot_", year, "_deflated.rds"))
  
  # Change to tidyr data frame type
  wiot <- data.frame(wiot) 
  
  # Filter out rows where Country is not "NLD" and use_country is not "NLD" as dont have co2em on NLD
  wiot <- wiot[wiot$Country != "NLD" & wiot$use_country != "NLD", ]
  
  # Re-index the row names in the same way as columns
  wiot <- wiot %>% mutate(Code = paste(Country, RNr, sep=""))
  
  #Get a wide table
  wide_table <- wiot %>% pivot_wider(names_from = c(use_country, use_sector), values_from = value)
  
  #Reordering columns as they are in the original WIOD tables (sectors for all countries first, followed by variables like household consumption, capital formation etc)
  df1 <- wide_table %>%
    select(-matches("_(57|58|59|60|61)$"))
  df2 <- wide_table %>%
    select(matches("_(57|58|59|60|61)$"))
  wide_table_reordered <- bind_cols(df1, df2)
  
  unwanted_cols <- c("IndustryCode", "IndustryDescription", "Country", "RNr", "Year", "TOT")
  
  #Extracting Z (global inter industries flows), V (value added)
  Z_year <- wide_table_reordered %>% slice(1:2408) %>% select(Code, 5:2412)
  V_year <- wide_table_reordered %>% slice(2413) %>% select(Code, 5:2412)
  
  #Extracting Y (final demand which is a sum of cons_h, 
  Y_expanded_year <- wide_table_reordered %>% slice(1:2408) %>% select(2413:2627)
  num_cols <- ncol(Y_expanded_year)
  Y_year <- data.frame(matrix(nrow = nrow(Y_expanded_year)))
  for (i in seq(1, num_cols, 5)) {
    start_col <- i
    end_col <- min(i + 4, num_cols)
    sum_col <- rowSums(Y_expanded_year[, start_col:end_col])
    col_name <- paste0("Sum", i, "-", end_col)
    Y_year[col_name] <- sum_col
  }
  colnames(Y_year) <- c("Code", "AUS","AUT","BEL","BGR","BRA","CAN","CHE","CHN","CYP","CZE","DEU","DNK","ESP","EST","FIN","FRA","GBR","GRC","HRV","HUN","IDN","IND","IRL","ITA","JPN","KOR","LTU","LUX","LVA","MEX","MLT", "NOR","POL","PRT","ROU","ROW","RUS","SVK","SVN","SWE","TUR","TWN","USA")
  Y_year$Code <- Z_year$Code
  
  # Save the data frames as Excel files
  write_xlsx(Z_year, paste0("Z_", year, ".xlsx"))
  write_xlsx(V_year, paste0("V_", year, ".xlsx"))
  write_xlsx(Y_year, paste0("Y_", year, ".xlsx"))
  
}

print("All files processed and saved successfully.")
