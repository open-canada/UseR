# File: caCovid.R
# Author: Dmitry Gorodnichy
#
# Functions for reading and displaying  COVID-19 data
# Used in https://rcanada.shinyapps.io/covid/ and https://itrack.shinyapps.io/covid
#
# Tested and ready for integration into package rCanada (or two packages: rCanada and IVI)
#



### For IVI package -----

library(magrittr)
library(data.table); options(datatable.print.class=TRUE) # NB: library(data.table) MUST BE BEFORE library(lubridate)!
library(dplyr)
library(dtplyr)
library(lubridate);  options(lubridate.week.start =  1)
library(stringr)

library(IVIM) # Calling IVIM does not call other required packages !
IVIM::iviPackages()
# source("R/utils.R")

# For rCanada package ----

# or caCovid package ?


# Better to use OOP: R6 or S4
# https://adv-r.hadley.nz/oo.html


# Set GLOBALS for the package ----

# To enable using the functions from this package  directrly from Shiny App!
input <- list()
input$metric <- "confirmedSpeed"
input$topN <- 12
input$daysback <- 31
input$dateToday <- "2021-03-31"
input$dateStart <- "2020-12-31"
input$fixscale = T
input$trend = T
input$log10 = T


# for using conventional variable names across different countries and datasets

COLS_GEO <- c("country",   "state",   "city")
COLS_CASES <- c("confirmed", "deaths")
STR_TOTAL <- "COMBINED"

#' Title
#'
#' @param offline
#' @param abbreviate
#'
#' @import data.table
#' @import lubridate
#' @import IVIM
#' @return
#' @rdname caCovid
#' @export
#'
#' @examples
readCovidUofT.csv <- function (offline=T, abbreviate=T) {

  if (offline) { # to run in GC networks that do not allow access to external sites
    load("data/dtCases.rda")
    load("data/dtMortality.rda")

    if (F) {
      dtCases <- fread("MY_DATASETS/cases_2021.csv", stringsAsFactors = F )
      dtMortality <- fread("MY_DATASETS/mortality_2021.csv", stringsAsFactors = F )
      dtCases [ , date := lubridate::dmy(date_report)];
      dtCases <- dtCases[date<ymd("2021/01/31")][, date:=NULL]
      dtMortality [ , date := lubridate::dmy(date_death_report)]
      dtMortality <- dtMortality[date<ymd("2021/01/31")][, date:=NULL]
      usethis::use_data(dtCases, dtMortality)
    }
  } else {

    # dtMortality  <- fread("https://github.com/ishaberry/Covid19Canada/raw/master/mortality.csv", stringsAsFactors = F ) <- This is where they used to be originally
    dtCases <- fread("https://github.com/ccodwg/Covid19Canada/raw/master/individual_level/cases_2021.csv", stringsAsFactors = F )
    dtMortality <- fread("https://github.com/ccodwg/Covid19Canada/raw/master/individual_level/mortality_2021.csv", stringsAsFactors = F )
  }

  if (F) { # quickly see what they are
    dt.setOptions(topn = 2)
    dtCases;dtMortality
  }
  # Worst:
  # dtCases <- dtCases %>% select(5:8) %T>% print(2)
  # Better:
  # dtCases <- dtCases[, 5:8] %T>% print(2)
  # Much better:
  dtCases[, (1:ncol(dtCases) %wo% 5:8) := NULL] []
  # Which can be written as a function:   dtCases %>% dt.keepCols(5:8) %>% print(2)

  dtMortality <- dtMortality[, c(6:9)] %T>% print(2)


  # setDT(dtCases)
  # setDT(dtMortality)


  # dt.keepCols(dtCases, 5:8)     %>% setnames(c("city", "state", "country", "date")) %>%  .[date := dmy(date)]
  # dt.keepCols(dtMortality, 6:9) %>% setnames(c("city", "state", "country", "date")) %>%  .[date := dmy(date)]

  setnames(dtCases, c("city", "state", "country", "date"));
  setnames(dtMortality, c("city", "state", "country", "date"));

  dtCases [ , date := lubridate::dmy(date)];
  dtMortality [ , date := lubridate::dmy(date)]

  if (T) { # quick check on how geo names are spelled
    dtCases %>% unique (by=c("state","city") ) # 102
    dtCases[city != "Not Reported", .(state,city) ] %>% unique(by=c("state","city") )
    # %>% saveRDS("../dtCaHealthRegions.Rds") # 92
  }

  # . get at state level ----

  dt0 <- rbind(
    dtCases[ , .(cases=.N, type="confirmed" ), keyby = c("date", "state", "country")],
    dtMortality[ , .(cases=.N, type="deaths"), keyby = c("date", "state", "country")]
  ) [, city:=STR_TOTAL] %>%
    dcast(date+country+state+city ~ type, value.var="cases")

  # . get at city level ----

  dt00 <- rbind (
    dtCases[ , .(cases=.N, type="confirmed" ), keyby = c("date", "country", "state", "city")],
    dtMortality[ , .(cases=.N, type="deaths"), keyby = c("date", "country", "state", "city")]
  ) %>%
    dcast(date+country+state+city ~ type, value.var="cases")

  dtAll <- dt0 %>% rbind(dt00)
  rm(dt0); rm(dt00)

  dtAll [, (COLS_CASES):= lapply(.SD, tidyr::replace_na, 0), .SDcol = COLS_CASES]
  dtAll [, (COLS_GEO):= lapply(.SD, base::iconv,"ASCII//TRANSLIT", from="UTF-8", to="ASCII//TRANSLIT"), .SDcol = COLS_GEO]

  if (abbreviate) { # perhaps, better to use official LOOKUP TABLE from Canada.ca?
    dtAll %>%
      dt.replaceAwithB("state", "New Brunswick", "NB"  ) %>%
      dt.replaceAwithB("state",  "Nova Scotia", "NS" ) %>%
      dt.replaceAwithB("state",  "Saskatchewan", "SK" ) %>%
      dt.replaceAwithB("state",  "Manitoba", "MB" ) %>%
      dt.replaceAwithB("state",  "Ontario", "ON" ) %>%
      dt.replaceAwithB("state",  "Quebec", "QC" ) %>%
      dt.replaceAwithB("state", "Alberta", "AB"  )
  } else {
    dtAll %>%
      dt.replaceAwithB("state", "PEI", "Prince Edward Island"  ) %>%
      dt.replaceAwithB("state", "BC", "British Columbia"  ) %>%
      dt.replaceAwithB("state",  "NWT", "Northwest Territories" ) %>%
      dt.replaceAwithB("state",  "NL", "Newfoundland and Labrador" )
  }

  dtAll[, region:=paste0(str_trunc(state, 3, ellipsis = ""), ": ", city)] # used in reduceToTopN()
  # This can be done outside of function:
  # dtAll <- dtAll[ state != "Repatriated"]
  # dtAll [, (COLS_GEO):=lapply(.SD, as.ordered), .SDcols=COLS_GEO]

  setkey(dtAll, date)
  return(dtAll)
}


#' Title
#'
#' @param dt0
#' @param N
#' @param metric
#'
#' @return
#' @export
#' @rdname caCovid
#' @examples
extractMostInfectedToday <- function(dt0, N=5, metric="confirmed") {
  dt0[, .SD[.N],by=region] [order(-get(metric)), .SD[1:N]]
}


#' Title
#'
#' @param dt0
#' @param colsCases
#' @param colsGeo
#' @param convolution_window
#' @param difference_window
#'
#' @return
#' @export
#' @rdname caCovid
#'
#' @examples
addDerivatives <- function (dt0, colsCases=COLS_CASES, colsGeo=COLS_GEO, convolution_window=3, difference_window=1) {
  # NB: assumes this was done: setkey(dt0, date)
  colTotal <- paste0(colsCases, "Total")
  colSpeed <- paste0(colsCases, "Speed") # DailyAve"
  colAccel <- paste0(colsCases, "Accel") # "WeeklyDynamics" # change since last week in DailyAve
  colAccel. <- paste0(colsCases, "Accel.")  # AccelAve
  colGrowth <- paste0(colsCases, "Growth")  # dN(T+1) / dN(T)
  colGrowth. <- paste0(colsCases, "Growth.")  # GrowthAve
  colGrowth.Accel <- paste0(colsCases, "Growth.Accel")  #
  # We can also compute  dN(T)/ N(T)

  dt0[ ,  (colTotal) := cumsum(.SD),  by=c(colsGeo), .SDcols = COLS_CASES]
  dt0[ ,  (colSpeed) := frollmean(.SD, convolution_window, align = "right", fill=0),  by=c(colsGeo), .SDcols = COLS_CASES][, (colSpeed) := lapply(.SD, round, 1), .SDcols = colSpeed]
  dt0[ ,  (colSpeed) := lapply(.SD, function(x) ifelse (x<0,0,x) ), .SDcols = colSpeed]
  dt0[ ,  (colAccel) := .SD - shift(.SD,difference_window),  by=c(colsGeo), .SDcols = colSpeed]
  dt0[ ,  (colAccel.) := frollmean(.SD, convolution_window, align = "right", fill=0),  by=c(colsGeo), .SDcols = colAccel][, (colAccel.) := lapply(.SD, round, 1), .SDcols = colAccel.]
  dt0[ ,  (colGrowth) := .SD / shift(.SD, difference_window<-1),  by=c(colsGeo), .SDcols = colSpeed]
  dt0[ ,  (colGrowth.) := frollmean(.SD, 2, align = "right", fill=0),  by=c(colsGeo), .SDcols = colGrowth][, (colGrowth.) := lapply(.SD, round, 3), .SDcols = colGrowth.]

  dt0[ ,  (colGrowth.Accel) := .SD - shift(.SD,difference_window),  by=c(colsGeo), .SDcols = colGrowth.][, (colGrowth.Accel) := lapply(.SD, round, 3), .SDcols = colGrowth.Accel]
  dt0[, (colAccel):= NULL];   dt0[, (colGrowth) := NULL]
}


# Example on how to use GLOBAL input variable

#
# plotToday <- function(dtToday, input) {
#
# }
#
# plotMap <- function(dtToday, input) {
#
#   #
#   # dtToday <- r.dt()[date==dateMax]
#   dtToday[, ratingcol:= ifelse(confirmedGrowth<1, "yellow", "red")]
#
#   dtToday[, strMessage:= paste0(state, " - ", city,
#                                 ":<br><b>Confirmed</b>",
#                                 "<br>  Total: ", confirmedTotal, "(", confirmedTotalPercentage, "%)",
#                                 "<br>  Daily: ", confirmed, "(", confirmedPercentage, "% population)",
#                                 "<br> <b>Deaths</b>",
#                                 "<br>  Total: ", deathsTotal, "(", deathsTotalPercentage, "%)",
#                                 "<br>  Daily: ", deaths, "(", deathsPercentage, "% population)",
#                                 "<br><b>Death rate </b>",
#                                 "<br>  Today: ", deathRate, ". Average: ", deathRateAverage,
#                                 "<br>  Rt = ", confirmedGrowth
#   )  ]
#
#   leaflet::leaflet(dtToday) %>%
#     addTiles() %>%
#     addCircleMarkers(~lng, ~lat,
#                      color = ~ratingcol,
#                      popup = ~strMessage,
#                      label = ~paste0(region, ": ", confirmed, "(", confirmedPercentage, "%) / day. R0=", confirmedGrowth)
#     ) %>%
#     addPopups(~lng,  ~lat,
#               popup = ~paste0(city, ": ", confirmed, " / day. Rt=", confirmedGrowth)
#     )  %>%
#     addLegend("bottomleft",
#               colors = c("yellow","red"),
#               labels = c(
#                 "Growth (Rt) < 1",
#                 "Growth (Rt) > 1"),
#               opacity = 0.7)
#
#
# }
#
#
# plotTrends <- function(dt00, input) {
#   # cols <- c("confirmed", "recovered", "deaths")
#   cols <- COLS_CASES
#   cols3 <- paste0(cols, input$fRadio)
#
#   # dtToday <- dt00[, .SD[.N], by =region]
#   dt <- dt00[date >= input$StartDate]
#
#
#
#   g <- ggplot( dt  ) +
#
#     facet_wrap(.~
#                  region,
#                # reorder(region, -get(input$sortby))    ,
#                scales=ifelse(input$scale, "fixed", "free_y")
#     ) +
#     #scale_y_continuous(limits = c(0, NA)) +
#     # scale_y_continuous(limits = c(min(dt00[[ cols3[1] ]]), max(dt00[[ cols3[1] ]]) )) +
#     scale_y_continuous(limits = c(min(dt[[ cols3[1] ]]), NA )) +
#
#     geom_vline(xintercept=input$dateToday, col = "orange", size=2) +
#     geom_vline(xintercept=ymd(input$dateToday)-14, col = "orange", size=1) +
#     # geom_vline(xintercept=input$dateToday-14, col = "orange", size=1) +
#     geom_point(aes_string("date", cols3[1]), alpha=0.5, col="purple", size=2) +
#     geom_line(aes_string("date", cols3[1]), alpha=0.5, col="purple", size=1) +
#
#     theme_bw() +
#     scale_x_date(date_breaks = "1 week",
#                  date_minor_breaks = "1 day", date_labels = "%b %d") +
#     labs(
#       title= paste0("Dynamics over time: from ",
#                     input$date , " to " ,  input$dateToday
#       ),
#       y=paste("Confirmed Cases ", input$metric),
#       # y=paste("Cases"),
#       # y=NULL,
#       x=NULL,
#
#       caption=caption.covid
#     )
#
#   if (input$log10 ) {
#     g <- g + scale_y_log10()
#   }
#
#   if (input$trend ) {
#
#     # if (input$trend_SE ) {
#     g <- g + geom_smooth(aes_string("date", cols3[1]), size = 1, level=0.99,
#                          method= "gam", # method= "gam",  formula = y ~ s(x,k=3),
#                          # method = "lm", formula = y ~ poly(x, 4),
#                          col = "black", linetype = 2, alpha=0.3)
#   }
#   g
# }
#


# . TEST ME ----
if (F) {
  # moved to MY_CODES/test-rCanada-package-covid

}



