#Setting the scene for anything reproducable
set.seed(1234)

#For reproducable environments
save.image("ETL.RData")

#Always
require() #instead of library()

#Mass installations (reusable)
apps <-
  c("tidyverse",
    "FactoMineR",
    "factoextra",
    "devtools",
    "caret",
    "survminer",
    "qqman",
    "ggrepel",
    "getopt", 
    "binom", 
    "VGAM")

for (a in apps) {
  if ((a %in% rownames(installed.packages())) == FALSE) {
    install.packages(a, dependencies = TRUE,
                     lib = "/home/$USER/Rlibrary", #reusable after R engine upgrade by simply pointing to this location
                     repos = 'http://cran.ma.imperial.ac.uk/', # ONLY if in  UK
                     destdir = "/home/$USER/RlibraryDownloads", #Not really necessary but sometimes useful to keep the install copy
                     quiet = TRUE ) 
  }
}


#Issues with decimal limits (digits could be 1..22 the default is 7 for printing and return)
options(verbose = TRUE, digits=22)

#Installing packages with multiple cores (R v > 3.5) ==> making compilation of gcc compiler much faster e.g. iCore7 8nct
install.packages("MASS",Ncpus = 8)

#qnorm for polishing the p value distribution before coverting to Z distribution.
function(p, eps = 1e-16){
  if(p[which(p > (1-eps))]){
        z=qnorm(eps,lower.tail=FALSE) #correct approach not 1-eps
        } else if (p[which(p < eps)]){
                z=qnorm(eps)}
  return(z)
}

#Converter of choice for many ocasions that numbers are parsed as factor by mistake.
factor2numeric<- function (f) {
  as.numeric(as.character(f))
}

