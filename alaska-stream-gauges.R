library(dataRetrieval)
library(tidyverse)

stateCdLookup("AK", "id")

# all stream gauges in Alaska
AlaskaSites <- whatNWISsites(parameterCd="00060", 
                               hasDataTypeCd="dv", 
                               stateCd = "02" )

# gauges with discharge data on the fortymile
fortymile_AK_DailyQsites <- whatNWISsites(stateCd="AK", 
                                    siteName="FORTYMILE", 
                                    siteNameMatchOperator="any",
                                    parameterCd="00060",
                                    hasDataTypeCd="dv")
View(fortymile_AK_DailyQsites)

# get site numbers from the fortymile gauges
fortymile_AK_sitenumbers <- fortymile_AK_DailyQsites$site_no

# get site data from fortymile
fortymile_ID_siteinfo <- readNWISsite(fortymile_AK_sitenumbers)

View(fortymile_ID_siteinfo)

# condense the site info to useful information
fortymile_ID_siteinfo2 <- fortymile_ID_siteinfo[,c("site_no","station_nm",
                                           "dec_lat_va", "dec_long_va", "state_cd", 
                                           "county_cd", "alt_va", "huc_cd",
                                           "drain_area_va")]

# daily discharge data for fortymile
Fortymile_dailyQdata <- whatNWISdata(siteNumber=fortymile_AK_sitenumbers,
                                      parameterCd="00060", service="dv")

# condensed daily discharge data with period of record
Fortymile_AK_dailyQPOR <- Fortymile_dailyQdata[,c("site_no","station_nm","parm_cd",
                                                    "begin_date","end_date", "count_nu")]

# grab entire period of record for Fortymile near Steele Creek
Fortymile_DailyQ <- readNWISdv(siteNumber="15348000", parameterCd="00060", 
           startDate="", endDate="")

# add better names for flow and flow code
Fortymile_DailyQ <- renameNWISColumns(Fortymile_DailyQ)
Fortymile_DailyQ <- addWaterYear(Fortymile_DailyQ)

# save data to csv
write.csv(Fortymile_DailyQ, file="Fortymile_DailyQ.csv")

# let's play with data
Fortymile_DailyQ %>% 
  filter(waterYear == 1976) %>% 
  ggplot(aes(Date, Flow)) +
  geom_line()

# plot
Fortymile_DailyQ %>% 
  ggplot(aes(Date, Flow)) +
  geom_line()

