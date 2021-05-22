
# IVIM/iviBase.R ----

# I put all imported package on top

#' Generic utility functions to work with IVIM package
#'
#' @param x 1st
#' @param y 2nd
#'
#' @import data.table
#' @import magrittr
# @import ggplot2
# @import lubridate


#' @return 1st2nd
#' @rdname iviBase
#' @export
`%+%` <- function (x,y) {
  paste0(x,y)
}

#' @return Return x without y
#' @rdname iviBase
#' @export
`%wo%` <- function(x, y) {
  x[!x %in% y]
}  # names(iris) %wo% "Species"



#' @return Returns TRUE  if x that are NOT in y
#' @rdname iviBase
#' @export
'%notin%' <- function (x,y) {  ! ( x %in% y)   }

'%ni%' <- '%notin%'
# `%ni%` <- Negate(`%in%`) #names(iris) %notin% "Species"



# these are added above using #' @import ... commands
# Se still have this function - for testing here and callin from outside
#' Title
#'
#' @return opens packages used by IVIM package
#' @export
#'
#' @examples
iviPackages <- function() {
  library(magrittr)
  library(data.table);
  # library(dplyr) # can I avoid using dplyr altogether,if I use data.table?
  library(lubridate);
  library(stringr)
}



#' Set options for printing and calling data
#'
#' @param rownames Boolean - show row number?
#' @param topn number of top/bottom rows to show
#' @param nrows rows to print
#' @param digits digits to print
#'
#' @return
#' @rdname iviBase
#' @export
#'
#' @examples iviOptions()
iviOptions <- function(rownames=T, topn=5, nrows = 50, digits = 3) {

  # options() # shows all options available
  # options(defaultPackages = c("datasets",  "iviDT" ,    "grDevices", "graphics",  "stats",     "methods") )
  options(digits = digits)  # 7
  # options(max.print = 100) # 1000
  options(scipen = 999)  # remove scientific notation
  # options(na.action = na.omit) #, na.fail, also for na.exclude, na.pass, na.omit
  # getOption("na.action")

  options(lubridate.week.start = 1) # 7

  options(datatable.verbose = FALSE) # TRUE)
  options(datatable.print.class = TRUE)
  options(datatable.print.keys = TRUE)
  options(datatable.print.nrows = nrows) # 100
  options(datatable.print.topn=topn) # 5
  options(datatable.print.rownames = rownames)
}

# IVIM/iviDT.R  ----

#' Convenience functions from IVIM package to work with data.table object.
#' #' In place (i.e., by memory pointer) value replacement in a data.table column
#' @param dt A datatable object
#' @param col The column of interest
#' @param a The value you wish to replace
#' @param b The replacement for value a
#'
#' @return This function modifies data.table dt by memory reference (i.e, in place, without creating new objects). Hence, it does not need to return anything. However when desired (e.g., for piping with '%>%'), it will return the data.table dt that was modified.
#
# This very incovenient to write R code example as text comment ! -
# DISCUSS IT! - It was suggested to put any such R codes in a) MY_CODE/test-*.R  and b) in tests/testthat/test-DT.R
#
#' @examples \dontrun{
#' province <- c("Alberta", "Quebec")
#' dt <- data.table(province)
#' dt %>% dt.replaceAwithB("province", "Alberta", "AB")
#' }
#' @rdname iviDT
#' @export
dt.replaceAwithB <- function(dt, col, a, b) {
  dt[get(col)==a, (col):=b];
}

# In place (i.e., by memory pointer) value replacement in a data.table column
#
# @param dt
#  @param col
# @param a
# @param b
#
#' @return This function performs the inverse operation to `dt.replaceAwithB()` function: i.e. `dt %>% replaceAwithB(col, a, b) %>% dt.replaceBwithA(col, a, b) == dt` # TRUE
#' @rdname iviDT
#' @export
dt.replaceBwithA <- function(dt, col, a, b) {
  dt[get(col)==b, (col):=a];
}

if (F) {
  # This should be Moved to vignette !

  # TEST 1: ways to pipe  ----

  library(IVIM)
  iviPackages()
  # library(data.table)
  # library(magrittr)

  dt1 <- data.table(province=c("Alberta", "Quebec"))

  dt1 %>%
    dt.replaceAwithB ("province", "Quebec", "QB") %>%
    dt.replaceAwithB ("province", "Alberta", "AB") %>%
    dt.replaceAwithB ("province", "Alberta", "AB");
  dt1
  # bug here ? - it does not print dt1 ! -  you need to call dt1 again, or call dt1 %>% print
  # ask at stackoverflow !
  dt1

  # reverse the changes:
  dt1 %>%
    dt.replaceBwithA ("province", "Quebec", "QB") %>%
    dt.replaceBwithA ("province", "Alberta", "AB") %>%
    dt.replaceBwithA ("province", "Alberta", "AB") %>% print

  if (F) {
    # NOte: you can pipe the same functionality without dt.replaceAwithB function

    # Way 1: using data.table [][][] operator

    # I prefer this style (so that to have [] in final line):
    dt1[province == "Quebec", province:="QB"
        ][province == "Alberta", province:="AB"
          ][province == "Alberta", province:="AB"
            ][]
    # Alternative style:
    # dt1[province == "Quebec", province:="QB"][
    #   province == "Alberta", province:="AB"][
    #     province == "Alberta", province:="AB"][]
    dt1

    # Now the same using dt.replaceAwithB function

    # Way 2: using magrittr %>% operator
    # If you update to R 4.1.0, there is a base pipe operator now, |>, which may get rid of any need to use magrittr.

    dt1[province== "Quebec", province:="QB"] %>%
      .[province== "Alberta", province:="AB"] %>%
      .[province== "Alberta", province:="AB"] %>% .[]

  }

  # TEST 2: comparisons w. iris----

  # Standard way (least efficient - using dplyr w/o data.table)
  df <- iris[100:101,]; df

  # R base:
  df0 <- df
  df0$Species[df$Species == 'virginica'] <- 'virgin.' #bad
  df; df0

  # library(dtplyr)
  df0 <- df  %>%  dplyr::filter(Species=="virginica") %>% dplyr::mutate(Species="virgin.") #bad
  df; df0
  df0 <- df %>% dplyr::mutate(Species=ifelse(Species=="virginica", "virgin.", Species)) #bad
  df; df0
  df0 <- df %>% dplyr::mutate(Species = forcats::fct_recode(Species, "virgin." = "virginica" ))  #works
  df; df0


  # Compare to (not much better - using Wickam's dtplyr way around with data.table):
  library(dtplyr)
  dtBackEnd <- lazy_dt(df)
  dtBackEnd0 <- dtBackEnd %>%
    filter(Species=="virginica") %>%
    mutate(Species="virgin.") %T>%
    show_query();
  dtBackEnd0;
  dtBackEnd;
  dtBackEnd0 %>% as.data.table()

  #  Compare to (the best way):
  dt <- copy(df);  # dt is data.frame
  dt %>% setDT; # NB: dt is now data.table and you can use it with dt.*() functions !
  dt %>%
    dt.replaceAwithB("Species", "virginica", "virgin.") %>%
    dt.replaceAwithB("Species", "versicolor", "versic.");
  dt; df # NB: dt also changed !

}



# replace set A with set B in column col

# Very useful for merging PSES responses from various years, because they different numbering!

# Asked: https://stackoverflow.com/questions/67608799/function-to-replace-values-in-data-table-using-a-lookup-table

#' Title
#'
#' @param dt
#' @param col
#' @param dtLookup
#' @rdname iviDT
#' @export

dt.replaceValueUsingLookup <- function(dt, col, dtLookup) {
  dt[
    dtLookup,
    on = setNames("old", col),
    (col) := new
    ]
}
if (F) {
  dt <- data.table( chapter=as.character(11:15) );dt

  dtLookup <- data.table(
    old = c("11", "12", "14", "15"),
    new = c("101", "102", "105", "104")
  )
  dt %>% dt.replaceValueUsingLookup("chapter", dtLookup)
}




#' @rdname iviDT
#' @export
dt.reset <- function(dt) {
  setDT(setDF(dt))
  # can we do it w/o assignment ? (by pointers?)
  # dt <- setDT(setDF(dt))
}
if (F) { # TEST 1 ----
  dtProjectile <- data.table()
  dtProjectile$angle<- c(15, 30, 45, 60, 75)
  dtProjectile$distance <- c(5.1, 8, 10,  8.5, 4.8)
  dtProjectile <- dt.reset(dtProjectile) # setDT(setDF(dtProjectile))
  ggplot() + geom_point( aes(dtProjectile$angle, projectile$distance)  ) # Works
  ggplot(dtProjectile) + geom_point( aes(angle,distance) ) # Does not work UNLESS setDT(setDF())
}

#' Keep or remove columns in data.table by memory reference
#' @rdname iviDT
#' @examples
#' dt<-iris; dt %>%  setDT %>% dt.rmCols (1) %>% dt.rmCols("Species"); dt
#' @export
dt.rmCols <- function (dt, cols){
  dt [, (cols):=NULL]
}

#' @rdname iviDT
#' @export
dt.keepCols <- function (dt, cols) {
  if (is.integer(cols))
    dt.rmCols(dt, 1:ncol(dt) %wo% cols)
  else
    dt.rmCols(dt, names(dtCases) %wo% cols)
}



