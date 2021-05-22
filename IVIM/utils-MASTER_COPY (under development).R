# MASTER COPY for functions used in utils.R in other packages

# utils.R
#
# Author: Dmitry Gorodnichy
# Tested, Can be run as source("utils.R")


### For IVIM package. ----

# Needed (for THIS package) functions/codes below are extracted from master copy:
# my_packages/IVIM/CODES/*
# also, https://gccode.ssc-spc.gc.ca/gorodnichy/IVIM/CODES
# also ??, https://gccode.ssc-spc.gc.ca/gorodnichy/rCanada/R/utils.R

# These are placed  in utils.R in all packages that  I'm developing until IVIM package is on CRAN.
# Once it's on CRAN, I'll be able to import it as data.table or any other package.

# imported libraries ----

setPackages <- function() {

  library(magrittr)
  library(data.table);
  options(datatable.print.class=TRUE) # NB: library(data.table) MUST BE BEFORE lubridate !!
  # library(dplyr) # can I avoid using dplyr altogether,if I use data.table?
  library(lubridate);
  options(lubridate.week.start =  1)
  library(stringr)
}

"%+%" <- function (x,y) paste0(x,y)
"%wo%" <- function(x, y) x[!x %in% y]  # names(iris) %wo% "Species"
`%ni%` = Negate(`%in%`) # x not in y # names(iris) %in% "Species";  names(iris) %ni% "Species"
'%notin%' = Negate(`%in%`) #names(iris) %notin% "Species"


# IVIM/iviBase.R ----
# (maybe aso iviPlot.R)

setMyOptions <- function() {
  options() # shows all options available
  # options(defaultPackages = c("datasets",  "utils" ,    "grDevices", "graphics",  "stats",     "methods") )
  options(digits = 3)  # 7
  # options(max.print = 100) # 1000
  options(scipen = 999)  # remove scientific notation
  # options(na.action = na.omit) #, na.fail, also for na.exclude, na.pass, na.omit
  # getOption("na.action")

  options(lubridate.week.start = 1) # 7

  dt.setOptions()
}

# . GLOBALS ----

iviGLOBALS <- list(
  VERBOSE = TRUE,
  COMMENT_OUT = F,
  USE_PNG = F,
  COLOURS = c("black", "green", "red", "blue", "brown", "cyan", "violet", "orange"),
  # COLOURS=rainbow(14),  # COLOURS=colours()[round(seq(1,length(colours()),length.out=11))],
  COUNT = 1,
  resetCOUNT = function() iviGLOBALS$resetCOUNT <- 1
) #

# Function to specify a series of numbers that loop around
loop <- function(...) {
  numbersToLoopAround <- c(...)
  i <- 0
  function() {
    if (i < length(numbersToLoopAround)) i <<- i + 1  else    i <<- 1
    return(numbersToLoopAround[i])
  }
}
if (F) {
  setNewColour <- loop(iviGLOBALS$COLOURS)
  for (i in 1:10) print(setNewColour())
}



# Asked and answered at Stackoverflow
exit <- function() {
  .Internal(.invokeRestart(list(NULL, NULL), NULL))
  # All below don't work:
  # q()
  # stop("Stopping");  # This generated "Error in " and goes to Debug mode, which we dont want.
  # return (invisible());
}

dd.getKey <- function(prompt = "-", lastkey = "y") {
  if (tolower(lastkey) == "a") {
    return("a")
  }
  strKey <- readline(paste(prompt))
  nKeys <- as.integer(charToRaw(strKey)) - as.integer(charToRaw("0"))
  if (length(nKeys) == 0) {
    return("y")
  } else if (nKeys[1] >= 0 & nKeys[1] <= 9) {
    return(nKeys)
  } else if (strKey == "q") {
    exit()
  } else {
    return(strKey)
  }
}

dd.ConfirmedYes <- function(...) {
  if (dd.getKey(...) %in% c("y", "a")) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# text view of data.table on screen

dt.iPrint <- function(dt, howmuch = 22) {

  cKey <- dd.getKey("Start printing all lines ?  ")
  incr <- 25
  n <- 1
  while (n < nrow(dt)) {
    print(dt[n:(n + incr - 1)])
    n <- n + incr
    print(n)
    cKey <- dd.getKey("Continue displaying data ? (y/n/1,2,3 to increase number of printed lines) ")
    if (is.integer(cKey)) {
      incr <- (cKey[1] + 1) * 25
    } else if (tolower(cKey) == "n") break
  }
}


if (F) {
  dt <- as.data.table(iris)
  dt %>% dt.iPrint()
}

# IVIM/iviDT.R (aka dt-helper.R) ----

# See also:

# - https://github.com/tidyverse/dtplyr (Version: 1.1.0, Published: 2021-02-20, From Hadley himself - I found it quite cumbersome still though...)
# https://github.com/asardaes/table.express (Version: 0.3.1 Published: 2019-09-07 - somewhat easier?)
# https://github.com/asardaes/table.express/blob/master/R/pkg.R
# - https://github.com/markfairbanks/tidytable (Version: 0.6.2 Published: 2021-05-18 - seems to be the best supported of the three?)



dt.setOptions <- function(rownames=T, topn=5, nrows = 50) {
  options(datatable.verbose = FALSE) # TRUE)
  options(datatable.print.class = TRUE)
  options(datatable.print.keys = TRUE)
  options(datatable.print.nrows = nrows) # 100
  options(datatable.print.topn=topn) # 5
  options(datatable.print.rownames = rownames)
}

# sometimes (eg RecordLinkage::names ) you can't use setDT() and have to use as.data.table()
# Error in setDT(iris) :
#   Cannot convert 'iris' to data.table by reference because binding is locked. It is very likely that 'iris' resides within a package (or an environment) that is locked to prevent modifying its variable bindings. Try copying the object to your current environment, ex: var <- copy(var) and then using setDT again.
# dt.set2 <- function(...) {
#   as.data.table(...) # or setDT(), or as.data.table(), or data.table
# }
# if (F) {
#
# }

# to be able to update data.table on the fly: from empty DT to non-empty DT
dt.set <- function(dt) {
  setDT(setDF(dt))
}
if(F) {
  library(data.table); library(ggplot2)
  dtProjectile <- data.table()
  dtProjectile$angle<- c(15, 30, 45, 60, 75)
  dtProjectile$distance <- c(5.1, 8, 10,  8.5, 4.8)

  ggplot() + geom_point( aes(dtProjectile$angle, dtProjectile$distance)  ) # always Works
  ggplot(dtProjectile) + geom_point( aes(angle,distance) ) # works only if you run dt.set(dtProjectile))!

  ggplot(dt.set(dtProjectile)) + geom_point( aes(angle,distance) )
  # So don't forget to run  it:
  # dt.set(dtProjectile)
}




# These are better (ie in-place, by pointers) alternatives to those in dplyr or dtply

# Instead of: dt <-  dt %>% dtply::select(-cols); dt <-  dt %>% dtply::select(cols);

dt.rmCols <- function (dt, cols){
  dt [, (cols):=NULL]
}
dt.keepCols <- function (dt, cols) {
  if (is.integer(cols))
    dt.rmCols(dt, 1:ncol(dt) %wo% cols)
  else
    dt.rmCols(dt, names(dtCases) %wo% cols)
}

# replace A with B in column col

dt.replaceAwithB <- function(dt, col, a, b) {
  dt[get(col)==a, (col):=b]; return(dt)
}

# . TEST ME ----
if (F) {
  df <- iris;
  dt <- lazy_dt(df)
  dt3 <- dt %>%
    filter(Species=="virginica") %>%
    mutate(Species="virgin.") %>%
    show_query()

  dt2 <- dt1 <- df %>% setDT
  dt1[Species=="virginica", Species:="virgin."]
  dt2 %>% dt.replaceAwithB(Species, "virginica", "virgin.")
}



# replace set A with set B in column col

# Very useful for merging PSES responses from various years, because they different numbering!

# Asked: https://stackoverflow.com/questions/67608799/function-to-replace-values-in-data-table-using-a-lookup-table

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





dt.apply <- function(dt, functionToApply, cols) {
  if (cols %>% is.integer() )
    cols <- names(dt)[column]
  dt[, (cols) := lapply(.SD, functionToApply),.SDcols = cols]
}
if (F) {
  dt <- iris %>% setDT; dt[1]
  column <- "Species"
  funcToDo <- as.character
  dt %>% data.table() %>% dt.apply(as.ordered,"class_id") %>% summary
}





# NOT SURE how it works, but it works!  Found in: stackoverflow:
# Extremely fast Efficient rows delition from data.table

# dt.rows_remove
dt.rmRows <- function(DT, del.idxs) {  # pls note 'del.idxs' vs. 'keep.idxs'
  if (!is.data.table(dt))
    dt <- as.data.table(dt)

  keep.idxs <- setdiff(DT[, .I], del.idxs);  # select row indexes to keep
  cols = names(DT);
  DT.subset <- data.table(DT[[1]][keep.idxs]); # this is the subsetted table
  setnames(DT.subset, cols[1]);
  for (col in cols[2:length(cols)]) {
    DT.subset[, (col) := DT[[col]][keep.idxs]];
    DT[, (col) := NULL];  # delete
  }
  return(DT.subset); # NB: Original DT is also changed  by reference !
}


# Extremely fast subset function
# dt[, .SD[1:10], by=y] # too slow
# dt %>% top_n(2, y) # even slower

dt.subset <- function (dt, by_variable, subset_size) {
  if (!is.data.table(dt))
    dt <- as.data.table(dt)
  dt <- dt[dt[, .I[1:subset_size], keyby = by_variable]$V1]
}
if (F) {
  dt <- attrition; by_variable <- "Attrition"; subset_size <- 10
  dt <- attrition %>% dt.subset("Attrition",5)
}


# --------------------------------------------------------------------- -#
# IVIM/iviReportivi.R ----
# --------------------------------------------------------------------- -#


rmd.cat <- function(...) {
  cat("\n\n");   cat (...);   cat("\n\n")
}
rmd.print <- function(...) {
  cat("<pre>\n")
  print (...)
  cat("\n</pre>")
}

set.seed(22)  #btn-block

DIV_START <- function(strText="Details", bShow=T){
  iButton <- runif(1, min=0, max=100000) %>% as.integer()
  # "btn btn-primary btn-block btn-lg active"
  rmd.cat( glue::glue(  paste0(
    '<button class="btn btn-primary btn-block active"  data-toggle="collapse" data-target="#BlockName',iButton, '"> Show/Hide ', strText, '</button>',   '\n',
    '<div id="BlockName', iButton,'" class="collapse', ifelse(bShow == F, "", " in"), '">'
  )       )       )
}
DIV_END <- function(str="") {
  rmd.cat("</div>")
}

if (F) {
  cat ( DIV_START("Details", bShow=F) )
  for (i in 1:nrow(mtcars)) cat (paste(mtcars[i,],collapse = " " ), "\n")
  cat (DIV_END())
}

d7.datatable <- function(x, rownames=T){
  DT::datatable(x,
                rownames=rownames,
                filter="top",
                extensions = 'Buttons',
                options = list(dom = 'Blfrtip',
                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                               lengthMenu = list(c(5,10,25,-1),
                                                 c(5,10,25,"All"))))
}



# IVIM/iviPlot.R ----


# dd.plotDtAllBoxplots(dt, c("BWT_traveller", "HH", "OFFICE"), scales="free")

#up to five variables can be plotted
d7.plotAllBoxplots <- function (dt, columns, scales="free_x"){
  columns = dd.names(dt, columns)

  plot = ggplot(dt) + labs( y=columns[1], x=columns[2],
                            title=sprintf("%s = f(%s) by (%s,%s,%s))",columns[1],columns[2],columns[3],columns[4],columns[5]) )

  if (length(columns) < 5) {
    plot = plot + geom_boxplot( aes(x = as.ordered(get(columns[2])), y = get(columns[1])), varwidth=T) #, notch=T )
  }
  else {
    plot = plot + geom_boxplot( aes(x = as.ordered(get(columns[2])), y = get(columns[1])), varwidth=T )
    #                                 position=as.ordered(as.name(columns[5])), varwidth=T )
    # Error in get(columns[5]) : object 'YY' not found
  }

  if (length(columns) == 2)      { plot }
  else if (length(columns) == 3) { plot + facet_wrap(~as.ordered(get(columns[3])), scales=scales) } # scales="free", "free_y"
  else if (length(columns) == 4) { plot + facet_grid(as.ordered(get(columns[4])) ~ as.ordered(get(columns[3])), scales=scales) }
  else if (length(columns) > 5)  { print (paste("Opps - incorrect number of  columns: ", length(columns))) }
}


d7.plotAllHist <- function(dt) {
  #aa.dtPlotAllHist <- function(dt) {
  parOld <- par(mfrow = c(2, 1))
  for (col in 1:ncol(dt)) {
    colName <- names(dt)[col]
    x <- dt[[colName]]

    if ( !is.numeric( x ) ) {
      dt[[colName]] <- as.ordered( x )
      cFivenum <- sprintf("   Factor with %i labels: %s, %s, ... ",
                          length( labels(summary(x))),
                          labels(summary(x))[1] ,labels(summary(x))[2])
    }
    else{
      #    a <- quantile( x ) # fivenum(x); summary(x)
      #    cFivenum <- sprintf("    Quantiles: %s, %s, %s, %s, %s", a[1],a[2],a[3],a[4],a[5])
      a <- summary(x)
      cFivenum <- sprintf("    Quantiles: %s, %s, %s, %s, %s (NA=%s)", a[[1]],a[[2]],a[[3]],a[[4]],a[[5]], a[[7]])
    }

    print( sprintf("Column: #%i. column name: `%s` ", col, colName ) )
    print( cFivenum )
    plot( x, main=sprintf("Column %i: `%s`",col, colName), xlab=cFivenum)
    hist(as.numeric(x), main="", xlab="") #, breaks = 100) #labels = TRUE, col = "gray",
  }

  par(parOld)
}



# IVIM/iviLinking.R ----

library(RecordLinkage)
# Loading required package: DBI
# Loading required package: RSQLite
# Loading required package: ff
# Loading required package: bit
#
# Attaching package: ‘bit’
#
# The following object is masked from ‘package:base’:
#
#   xor
#
# Attaching package ff
# - getOption("fftempdir")=="C:/Users/gxd006/AppData/Local/Temp/Rtmp23BN4P/ff"
#
# - getOption("ffextension")=="ff"
#
# - getOption("ffdrop")==TRUE
#
# - getOption("fffinonexit")==TRUE
#
# - getOption("ffpagesize")==65536
#
# - getOption("ffcaching")=="mmnoflush"  -- consider "ffeachflush" if your system stalls on large writes
#
# - getOption("ffbatchbytes")==184467440737095520 -- consider a different value for tuning your system
#
# - getOption("ffmaxbytes")==9223372036854775808 -- consider a different value for tuning your system
#
#
# Attaching package: ‘ff’
#
# The following objects are masked from ‘package:utils’:
#
#   write.csv, write.csv2
#
# The following objects are masked from ‘package:base’:
#
#   is.factor, is.ordered
#
# RecordLinkage library
# [c] IMBEI Mainz
#
#
# Attaching package: ‘RecordLinkage’
#
# The following object is masked from ‘package:bit’:
#
#   clone
#
# The following object is masked from ‘package:base’:
#
#   isFALSE


