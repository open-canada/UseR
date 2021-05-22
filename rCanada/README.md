###  Submission to https://www.statcan.gc.ca/eng/conferences/symposium2021

Development of R libraries for common tasks with open Canada data 

Abstract: Many Government of Canada groups are developing codes to load,  clean/transform,  analyze and visualize various open Canada data, often duplicating each other’s efforts and with limited level of code quality  peer-reviewing. This project aims at developing a unified set of R packages for the use by anyone to perform those tasks. To achieve the objective, data professionals from across the government have been invited to share the related experiences and contribute related codes at weekly “Lunch and Learn R” meet-ups. A dedicated GCCollab team (r4gc) and GC Collab group (Use R!) have been also created to facilitate code and knowledgebase exchange and development. By the time of this submission, codes for working six open Canada datasets (Postal, Covid, ATIP, PSES, Census, Elections) have been contributed from various groups and individuals and are in the process of their integration to a common repository for their further improvement, testing and re-use. This presentation will overview the applied package development methodologies and the  results obtained to date.


### Ways to contribute


Way #1 (Easiest). Send your codes/corrections/feedback to Dmitry Gorodnichy at dmitry.gorodnichy@cbsa-asfc.gc.ca

Way #2  (With Full access): 
 Have your name added to the list members of GCcode r4gc group  - ask any group member to add you. After that you can clone and have a live copy ofthe  entire rCanada repo in three  steps:

1. in PowerShell in Windows go where you want to have a live copy of this repo and run this line: 

 git clone --progress https://oauth2:aYrMinydz1xK6ZtoBRrg@gccode.ssc-spc
.gc.ca/r4gc/gc-packages/rCanada gc_packages-rCanada

2. Open RStudio and open rCanada.Rproj from gc_packages-rCanada

3. Do whatever you want and then run Commit and Push from within RStudio

in one of our Friday's meetup we'll show you how to do that!


Way #3 (By forking):
Fork this repo in your personal account, then do the three steps indicate above with your own access token (from project's Settings menu). Submit merge request, once ready.



