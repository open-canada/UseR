--- 
title: "Making your codes re-usable using R packages "
subtitle: "GC Lunch and Learn: R packages 101"
author: Dmitry Gorodnichy and Joseph Stinziano
gitlab: https://gccode.ssc-spc.gc.ca/r4gc/gc-packages/packages101
date: "March -June 2021"
URL: https://gccode.ssc-spc.gc.ca/r4gc/gc-packages/packages101 
---

# Abstract

Notes from [Lunch and Learn R: Building Packages](https://gccollab.ca/discussion/view/8277081/en15-may-2021-building-r-packages-session-4-video-recording-notesfr): [packages101.Rmd].
Potentially, these notes can be converted to an R Bookdown or github article.


NB: These notes were originally at  
<https://gccode.ssc-spc.gc.ca/r4gc/gc-packages/IVIM/-/blob/master/MY_CODES/packages101.Rmd>, where they are no longer updated.



# Resources

## GC groups and repos

- Discussions: 
  - https://gccollab.ca/groups/profile/7391537/enuse-rfruse-r
  - https://gccollab.ca/groups/profile/7855030/enfriday-lunch-and-learn-r-meet-upsfr
- Codes:
  - Packages101 repo: https://gccode.ssc-spc.gc.ca/r4gc/gc-packages/packages101
  - Related codes and resources: https://gccode.ssc-spc.gc.ca/r4gc

## Related tutorials


### On how to build packages:

- https://r-pkgs.org/ (a bit compicated for beginners, but some sections are ok)
  - https://r-pkgs.org/vignettes.html
  
- Pdf: https://fanwangecon.github.io/R4Econ/support/development/fs_packaging.pdf
- Bookdown: https://rstudio4edu.github.io/rstudio4edu-book/data-pkg.html - https://github.com/rstudio4edu/rstudio4edu-book 
- R Slides: http://www.danieldsjoberg.com/writing-R-packages - github.com/ddsjoberg/writing-R-packages


### On how to build books and other manuals

For any documentation, report or belle-lettre hobbie, there are multiple options on how to publish it using R and RStudio. The links above show these: pdf (epub), multi-page bookdown and slides. It many cases however, you want something  as simple as and easy to browse as a single-page html, as in https://gorodnichy.github.io/noel

This repo shows how you can generate all of the above using the same single main source Rmd file (packages101.Rmd in our case):

https://github.com/gorodnichy/noel


