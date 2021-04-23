

# R101 - Learning R together (Lunch and Learn)

[ Home](https://IVI-M.github.io/R-Ottawa/) --  [ Resources](resources.md) -- [ R101](101.md)


This page provides information related the First 2020 season of "Lunch and Learn R" seminars organized by Dmitry Gorodnichy with his colleagues in Gov't of Canada. In interactive hands-on way, they show how to learn and master R - one of the most popular tools used for data analysis and visualization -  using open source resources. 
The sessions are 45 mins long and run every Friday, with the objective to develop something useful for community by the end of 8-10 sessions, e.g., a Web App that can  visualize some complex and  valuable data, the plenty of which is available at 
[open.canada.ca](https://open.canada.ca/en/open-data).

For Second 2021 season, please see [this page](learn2021.md)
<!-- build from scratch AI and Data Science tools  R. 
<!-- Data Science Apps, such as [iTrack Covid](https://itrack.shinyapps.io/covid), using  R. 
These 40-min sessions are done via MS Teams each Friday, are open to public and are recorded. 
If you missed a session, you can catch up by watch it on 
-->
No programming experience or data science background required. No installation of software is needed either. All coding is done in [https://rstudio.cloud](https://rstudio.cloud). It's  free, no subscription required, and is greatly supported by community.

- **Dial-in instructions**: [will be posted here]().  
- **GCCollab page** (restricted access): [here](https://gccollab.ca/discussion/view/4482867/enlunches-with-data-challenges-on-wednesdays-on-rfr)
- **YouTube Channel**: ["Lunch and Learn R - together](https://www.youtube.com/playlist?list=PLUogPW3t8g0RFvDGyKo1murnQUaSJxEPl) 
- Codes that we write: in [/r101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101) folder.   
- Ideas for self-learning: in [Resources](resources.md)
- Other:  [Data-sets and R projects about Ottawa and Canada](https://github.com/IVI-M/R-Ottawa/blob/master/r-on-github-for-Canada.md)


---


<!-- 
- Other great packages: `tidyverse`  - `dplyr` and `dtplyr`, `stingr`,  `tidymodels` 
- Debugging  .R and .Rmd:   https://adv-r.hadley.nz/debugging.html
- https://github.com/ropenscilabs/testrmd  
- Options for hosting (deploying)  generated reports and Apps (hmtl, Rmd) -  with and without interaction
  - github.io (e.g.: https://ramikrispin.github.io/coronavirus_dashboard/#about)
  - rpubs.com, https://bookdown.org/, shinyapps.io 
-->


# Season 1 (Summer 2020)

Topic:  "Building COVID Web App from scratch"      
Sub-topic: "Doing Data Science with R: Computer Science way"

Dates: April - June 2020

Summary: 

In this first season of R101 training, we showed how to build from scratch AI and Data Science tools using R in [RStudio](https://rstudio.cloud).
You can see the final result [here](https://itrack.shinyapps.io/covid/us.Rmd)!   

<!-- Data Science Apps, such as [iTrack Covid](https://itrack.shinyapps.io/covid), using  R.

## Session 9, Fri  2020/06/05 (Final session) - [video](https://youtu.be/6NxeBdQf0Eg)

- Wrapping up our US covid App. Comparing it to other [Covid Apps](https://ramikrispin.github.io/coronavirus_dashboard)
- Wrapping up our course: CMPUT 101 approach to Data Science and R programming - modular, naming conventions, ToC, think algorithm/strategy first
- Intro to GitHub and Git: new project from Git Repo, tracking your own changes, contributing to other community codes
- Making your Rmd modular using `{r covidApp_base.Rmd, child = 'covidApp_base.Rmd'}`

## Session 8, Wed  2020/06/03 - [video](https://youtu.be/r57OZB5s-B8), [code](https://github.com/IVI-M/R-Ottawa/blob/master/r101/01-board-App-session008.Rmd),  [live App](https://itrack.shinyapps.io/covid/session008.Rmd) 

- Making our App *reactive* with `shiny`
- Adding: `plotly`

## Session 7: Wed 2020/05/27 - [video](https://youtu.be/dWDGBznjRO4)

- Our first complete runnable Dashboard using `flexdashboard`
  - Dashboard layouts: pages and windows and subwindows using `#...`
- `leaflet` for geo-maps

## Session 6: Fri 020/05/22 - [video](https://youtu.be/7113G4sRMDI), 

Our first fully-automated Report: printing  graphs for all states in a `for` loop

New Files: 
- 01-read-session6.R: https://github.com/IVI-M/R-Ottawa/blob/master/r101/01-read-session6.R
- 01-report-session6.Rmd: https://github.com/IVI-M/R-Ottawa/blob/master/r101/01-read-session6.Rmd

## Session 5: Wed 2020/05/20 - [video](https://youtu.be/F8wORhNFhG0) 

We'll continue where we left: merging it all, running it all, and plotting, and then `knit`ing  our first Automated Report in R Markdown.

Topics :
- General:
  - how to organize our code: we'll work only in one Project called `R101`, using two files only: `01-read.R` and one `01-report.Rmd` file . All new versions of these two files will be saved in r101 named as `*-session.*`
  - How to do tutorials: 
  
- R:
  - bulding our first real useful function with parameters: `covid.reduceToTopNCitiesToday <- function(dtCovid, N=5) {....} ` to  reduce the huge Covid data table `dtCovid` to contain data for only the N most infected today cities
  - more on data.table: doing some operations on multiple columns at once (e.g. `sum()` to compute Totals for each state) using `.SD`: `cols <- c("confirmed", "deaths");  dtAll[, lapply(.SD, sum), .SDcols=cols];  dtAll[, lapply(.SD, sum), by=city, .SDcols=cols] `

- More about plotting graphs -  You Third biggest friend: `library(ggplot2)`
  - reordering values/plots in graphs:     `facet_wrap( reorder(city, lng) ~ .) +`
  - saving graphs: `ggsave()`
  - adding titles to images

- Rmd:
  - calling our R codes and functions from Rmd.
  - generating automated report  for *all* states in the US, using `for ()`, plotting graphs for 5 worst cities in each state
  - including ot including R codes and outputs in your report using `{r include=F}`and `{r echo=F]`
  - resizing images in Rmd
  - automated generation of text using `{r results='asis'}`
  
- General tricks:
  - commenting out unneeded lines 
  - auto-indenting of code lines with CTRL+I
  
New Files: 
- 01-read-session5.R: https://github.com/IVI-M/R-Ottawa/blob/master/r101/01-read-session5.R
- 01-report-session5.Rmd: ...
<!-- 
- Discussing "homework" (RStudio and Datacamp tutorials) - the best ways to do it:
- Finishing our R Script and Starting RMarkdown: from Automated Report to Automated App.
-->

## Session 4: Fri 2020/05/15 (Catch-up session) - [video](https://youtu.be/5bQ9QcGKSk0) 
  
Special sessions to catch up for those who missed first two sessions. Topics :
- Recap of Learning resources (rstudio.com & datacamp.com) 
  - Assignment of homework
- What these R101 sessions are about 
  - they are not to replace your main Learning resouces, but to help you to get started
  - to provide `Computer Science` (aka `Computing Science`) perspective and tricks to `Data Science` projects. Think - Google as an example of Computer Science approach to Data Science problem.
  - to socialize, build connections, contribute to further development of community projects: e.g. [iTrack Covid](https://itrack.shinyapps.io/covid/)
  
- From Zero to Runnable code (automated report) - in one sprint of 30 min
  - Assuming I know nothing... and starting from this [R Ottawa - R101](https://ivi-m.github.io/R-Ottawa/101.html) page
  - Just three tabs need to be opened:  [https://rstudio.cloud](https://rstudio.cloud), [/r101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101)  and [www.google.com](www.google.com])
 


## Session 3: Wed 2020/05/13  - [video](https://youtu.be/ZLHgv4hyUNo) 

Third session talks about the difference Computing Science  (aka Computer Science) vs. Data Science, and what we are learning here:  We learn how to program in R the way Computer Scietists program, and how to building *tools* (or algorithms) that find  answers to  our Data-related questions (such as "Where Covid is the worst tomorrow?" - which is Computer Science, as opposed to Data Science, where Data is visualized or processed, but no tools are developed and it is still a human who needs to find the answer.  


A better name for this course should be [CMPUT 101 - Introduction to Computing](https://www.ualberta.ca/computing-science/undergraduate-studies/course-directory/courses/introduction-to-computing.html),  which is the name of the course that Dmitry taught at the  University of Alberta (back in 1999 it was Matlab that we used,rather than R), instead of **R101**.

Topics covered:  

1- Refresher on how to start: from knowing nothing (see also first session)     
2- Analysing situation in Quebec (recap of last session findings), and  in US /New York (this session focus)    
3- More about `data.table`   
4- Functions    
5- Simple but complete Covid App tool example (`01-report.Rmd`) - no-interactivity

R: (`01-read.R`)  
- Working with `data.table`: `dt[ i, j, by]` :  
-  conditional viewing, value assignment
  - show for state New York, city New York, for last date
  - show all with more than 100,000 confirmed 
- merging data-sets - using `merge` and `dtGeo[dtUS]`

R Markdown: (`01-report.Rmd`)  
- report the results from `01-read.R`
- Showing how to run https://rmarkdown.rstudio.com/lesson-12.html in rstudio.cloud 


## Session 2: Wed 2020/05/06  - [video](https://youtu.be/QSMc-or5DcA) 

In our second session, we continue from where we left: we will open the .csv file from JHU and analyze it in a number of ways. The R script that we have started creating last time in rstudio.cloud is copied to [/r101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101) folder:  `01-read.R`

Topics covered: 

- Overview of the new purpose and functionality of [iTrack Covid App](https://itrack.shinyapps.io/covid) (v0.0.5 Canadian Edition - "Should I go or should I stay"). We'll now be adding the same functionality to US data - together with you.
- General coding process & mental framework: Running our first line - Trouble-shooting - Organizing code  
- Getting help: all knowledge you need is with you  already! : Build-in Help and www.Stackoverflow.com
- General process of getting to know your "stranger" (data) and making something nice out of it: 
  - ways to view it,  and print it, to manipulate so it is easier to work with
  - removing unneeded columns, `melt`ing data, renaming columns
- Your next best friend: `library(magrittr)`
  

## Session 1: Wed 2020/04/29 - [video](https://youtu.be/d_EC39tIWMQ) / [transcript](r101-transcript-01.md)

This is our first Live recorded session...

Topics covered: 

1. your first steps to start learning R:  go to www.rstudio.com,  and follow to Resources- Education-For Learners-Tutorials-   ending up in [https://rstudio.cloud](https://rstudio.cloud) and finding tutorials there: Learn - Primers - The Basics - Visualization Basics
2. your  first steps to start programming in R: New Project, New File - R Script, first executed one line (to read .csv file using `fread() )`, first error (`could not find function`), first installed package (`library(data.table)`)
3. your first R-powered document and App: New File - R Markdown
4. your first tricks and take-aways

Take-aways:

- Keep all useful libraries and functions in one place: `source("000-common.R')`
- `library(data.table)` is your best new friend
- Run line by line with (CTRL+ENTER)
- Make use of the `Table of contents` to build the  structure for your code that is easy to navigate: `#  1.1 Merging data   ----`
- Comment out unneeded code in R Script with `#` (CTRL+SHIFT+C)
- Comment out in chunks using `if (F) { # 0. General libraries and functions ----`
- Think and code in chunks
- Use R Markdown to organize your ideas and results (iTrack Covid App is just an R Markdown)
- Comment out  unneeded text in R Markdown with `<!--` - `-->` (CTRL+SHIFT+C)
- Two ways of educating yourself: 1) follow many tutorials (some bult in rstudio.cloud), 2) start building own own data science tool and seek answers as you go!


  
