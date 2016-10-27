
library(lubridate)
library(dplyr)
library(stringr)

setwd("C:/Metdata_Chilbolton")

filenames <- list.files(pattern = "MetSensors")

MetData_all = NULL

## Bind all data together 
for (i in 1:length(filenames)) {
  file <- read.csv(filenames[i])
  MetData_all = rbind(MetData_all, data.frame(file))
}


# make hourly averages

MetData_hour <- MetData_all %>%
   mutate(date = ymd_hms(date, tz = "UTC"),
          day = str_sub(date, start = 1, end = -10),  # read only 10 characters (the date),
          hour = hour(date)) %>%
  group_by(day,
           hour) %>%
  summarise(PRES_hourly = mean(PRES, na.rm = TRUE),
            SPED_hourly = mean(SPED, na.rm = TRUE),
            DIR_hourly = mean(DIR, na.rm = TRUE),
            T_hourly = mean(T, na.rm = TRUE),
            RH_hourly = mean(RH, na.rm = TRUE)) %>%
  ungroup()


write.csv(MetData_hour, "MetData_hour.csv")
