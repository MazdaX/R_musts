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

#Installing packages with multiple cores (R v > 3.5) ==> making compilation of gcc compiler much faster e.g. iCore7 8nct
install.packages("MASS",Ncpus = 8)

#Issues with decimal limits (digits could be 1..22 the default is 7 for printing and return)
options(verbose = TRUE, digits=22)

##+++++++++++++++++++++++++++++++++PERCISION limits of R engine (Machine dependent)+++++++++++++++++++++++++++++++##
#The defualt floating print limit of the R is 7 and could be pushed by options to 22 max but it deosn't change the eps limit e-16
noquote(unlist(format(.Machine)))
             double.eps          double.neg.eps             double.xmin             double.xmax             double.base 
 2.2204460492503131e-16  1.1102230246251565e-16 2.2250738585072014e-308 1.7976931348623157e+308                       2 
          double.digits         double.rounding            double.guard       double.ulp.digits   double.neg.ulp.digits 
                     53                       5                       0                     -52                     -53 
        double.exponent          double.min.exp          double.max.exp             integer.max             sizeof.long 
                     11                   -1022                    1024              2147483647                       4 
        sizeof.longlong       sizeof.longdouble          sizeof.pointer 
                      8                      16                       8
#Another way of printing the same thing (cleaner)
str(.Machine)
List of 18
 $ double.eps           : num 2.22e-16
 $ double.neg.eps       : num 1.11e-16
 $ double.xmin          : num 2.23e-308
 $ double.xmax          : num 1.8e+308
 $ double.base          : int 2
 $ double.digits        : int 53
 $ double.rounding      : int 5
 $ double.guard         : int 0
 $ double.ulp.digits    : int -52
 $ double.neg.ulp.digits: int -53
 $ double.exponent      : int 11
 $ double.min.exp       : int -1022
 $ double.max.exp       : int 1024
 $ integer.max          : int 2147483647
 $ sizeof.long          : int 4
 $ sizeof.longlong      : int 8
 $ sizeof.longdouble    : int 16
 $ sizeof.pointer       : int 8

#qnorm for polishing the p value distribution before coverting to Z distribution.
function(p, eps = 1e-16){
  if(p[which(p > (1-eps))]){
        z=qnorm(eps,lower.tail=FALSE) #correct approach not 1-eps
        } else if (p[which(p < eps)]){
                z=qnorm(eps)}
  return(z)
}

##==================================================================================================================##

#Converter of choice for many ocasions that numbers are parsed as factor by mistake.
factor2numeric<- function (f) {
  as.numeric(as.character(f))
}

###===================================================================================================================##
#73 unique colours
pals<-brewer.pal.info[brewer.pal.info$category == 'qual',]
pals_vector<-unlist(mapply(brewer.pal, pals$maxcolors, rownames(pals)))
