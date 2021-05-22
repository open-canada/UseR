library(devtools)

devtools::create("rCanada") # if you are  in /my_package
devtools::create("../../rCanada") # will it erase it,if I lready have it?
> #or usethis::create_package("../r4gc/packages/rCanada2")

library(roxygen2)
# library(testthis). What's the difference from library(testthat) ??
library(testthat) # do we need it?
# Attaching package: ‘testthat’
#
# The following object is masked from ‘package:devtools’:
#
#   test_file
#
# The following objects are masked from ‘package:magrittr’:
#
#   equals, is_less_than, not


usethis::use_testthat() # from usethis, which is callsed from devtools


use_vignette(name="my_vignettes") #
use_vignette(name="data_linking")


use_package("data.table")
use_package("magrittr")
use_package("data.table")
use_package("lubridate", type="Imports")  # how about order ?! lubridate must be after data.table !
use_package("stringr")

