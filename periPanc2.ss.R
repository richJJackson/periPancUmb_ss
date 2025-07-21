#### PeriPanc

setwd("/Volumes/richj23/Projects/Cancer/Translational_Studies/ESPAC/Data/ESPAC3")


dt <- read.csv("espac3.csv")

nrow(dt)

dt[1:3,]



### loading packages
setwd("/Users/richardjackson/Documents/GitHub/toolsRJJ")
devtools::load_all()



### 3 'sub trials' with a common control using Bayesain information borrowing

## Primary Outcome OS: 12 months OS - 60%
## Estiamted using an exponential distribution
lam <- log(0.5)/16;lam


### Checking survival function
tm <- seq(0,24,length=100)
s <- exp(tm*lam);s

plot(tm,s,typ="l",ylim=c(0,1),col=4,lwd=4)
abline(h=0.6,v=12)


### Simulate Data



### Study parameters
nTrial <- 3
ssc <- c(27,27,27)
sse <- c(54,54,54)
sst <- ssc+sse
rat <- ssc/sse




### Recruitment
nSite <- 25

rpm <- 0.667
openRate <- 1.5
maxTime <- 24

rec <- rec.forcast(nSite,rpm,openRate,maxTime)
rec

8/12

studTime <- 48

### startify recruitment by cohort
recp <- c(0.25,0.4,0.35)
monthlyRec <- rec$Monthly.Rec%*%t(recp)

c1 <- round(cumsum(monthlyRec[,1]));c1
c2 <- round(cumsum(monthlyRec[,2]));c2
c3 <- round(cumsum(monthlyRec[,3]));c3

c1[which(c1 > sst[1])] <- sst[1]
c2[which(c2 > sst[2])] <- sst[2]
c3[which(c3 > sst[3])] <- sst[3]

m1 <- diff(c(0,c1))
m2 <- diff(c(0,c2))
m3 <- diff(c(0,c3))



####
source("/Volumes/RICHJ23/Accademic/Projects/Unequal Allocation/Functions/jungUA.R")
singleStageII(0.7,0.9,0.15,0.85,1.2)

### Standard Binomial diesng
gsdesign.binomial(c(1),0.7,0.9,r=2,0.11,0.7,alternative="one.sided")


baseR <- 0.7
delta <- 0.175
N<-250
nsim <- 10000
simRes <-  NULL

pb = txtProgressBar(min = 0, max = nsim, initial = 0) 

for(k in 1:nsim){
  
  setTxtProgressBar(pb,k)
  
  #### Simulate dataset
  asset1 <- rbinom(N,1,0.25)
  asset2 <- rbinom(N,1,0.5)
  asset3 <- rbinom(N,1,0.95)
  
  trial <- rep(NA,N)
  trial[which(asset1==1)] <- 1
  trial[which(asset2==1&asset1!=1)] <- 2
  trial[which(asset3==1&asset1!=1&asset2!=1)] <- 3
  
  data <- data.frame("ID"=1:N,asset1,asset2,asset3,trial)

  ###
  data$alloc <- round(runif(N,0.25,1))
  data$lp <- baseR + data$alloc*delta
  data$out <- rbinom(N,1,data$lp)
  
  
  ########################################################
  #### Bayesian estimation of odds ratio
  ### Estimate dist of each treatment arm based on time and censoring

  id1 <- which(data$trial==1)
  tb1 <- table(data$out[id1],data$alloc[id1])
  #or1 <- fisher.test(tb1)$estimate
  #lor1 <- log(or1)
  #se.lor1 <- sqrt(sum(1/tb1))
  
  id2 <- which(data$trial==2)
  tb2 <- table(data$out[id2],data$alloc[id2])
  #or2 <- fisher.test(tb2)$estimate
  #lor2 <- log(or2)
  #se.lor2 <- sqrt(sum(1/tb2))
  
  id3 <- which(data$trial==3)
  tb3 <- table(data$out[id3],data$alloc[id3])
  #or3 <- fisher.test(tb3)$estimate
  #lor3 <- log(or3)
  #se.lor3 <- sqrt(sum(1/tb3))
  
  ########################################################
  #### borrowing matrix
  
  borrow.mat <- matrix(0.5,3,3);diag(borrow.mat) <- 1
  #borrow.mat <- matrix(c(0,0,0, 0.25,0,0, 0.25,0.5,0),3,3)
  
  tb.list <- list(tb1,tb2,tb3)
  pe <- postEst(tb.list,borrow.mat);pe
  
  pr0_direct <- lapply(pe$direct,postEval)
  pr0_borrow <- lapply(pe$borrowed,postEval)
  
  direct <- cbind(Reduce("rbind",pe$direct),unlist(pr0_direct))
  borrow <- cbind(Reduce("rbind",pe$borrowed),unlist(pr0_borrow))
  
  ret <- list("direct"=direct,"borrow"=borrow)
  
  simRes[[k]] <- ret
  
}




lap_direct <- lapply(simRes,function(x) as.numeric(x$direct[,4]>0.9))
lap_borrow <- lapply(simRes,function(x) as.numeric(x$borrow[,4]>0.9))

direct_res <- Reduce("rbind",lap_direct);direct_res
borrow_res <- Reduce("rbind",lap_borrow)

colSums(direct_res)/nsim
colSums(borrow_res)/nsim



borrow.mat
table(data$trial,data$alloc)

  
or_est <- function(tb,cc=T){
  or <-(tb[1,1]*tb[2,2])/(tb[1,2]*tb[2,1])
  lor <- log(or)
  se.lor <- sqrt(sum(1/tb))
  ret <- c(or,lor,se.lor)
  ret
}


postEst <- function(tb.list,borrow.mat){

    direct_est <-   lapply(tb.list,or_est)

    #####
    br.list <- tb.list 
    br.list[[1]][,1] <- br.list[[1]][,1] + br.list[[2]][,1]*borrow.mat[2,1] + br.list[[3]][,1]*borrow.mat[3,1]   
    br.list[[2]][,1] <- br.list[[2]][,1] + br.list[[1]][,1]*borrow.mat[1,2] + br.list[[3]][,1]*borrow.mat[3,2]   
    br.list[[3]][,1] <- br.list[[3]][,1] + br.list[[1]][,1]*borrow.mat[1,3] + br.list[[2]][,1]*borrow.mat[2,3]   

    direct_est <-   lapply(tb.list,or_est)
    borrow_est <- lapply(br.list,or_est)

    list("direct"=direct_est,"borrowed"=borrow_est)
    
}


postEval <- function(trRes,b=0){
  prb <- 1-pnorm(0,trRes[2],trRes[3])
}





trRes <- direct_est[[1]]

lapply(direct_est,postEval)
lapply(borrow_est,postEval)






plot(density(hr_post_direct))
lines(density(hr_post_baye),col=2)




###

###

###
plot(density(rnorm(nsamp,pr.mu1,sqrt(pr.var1))),col=5,lwd=2,ylim=c(0,55))
lines(density(rnorm(nsamp,lam_est[2,1],sqrt(var_est[2,1]))),lwd=2)
lines(density(rnorm(nsamp,lam_est[3,1],sqrt(var_est[3,1]))),col=2,lwd=2)

plot(density(rnorm(nsamp,pr.mu1,sqrt(pr.var1))),col=5,lwd=2,ylim=c(0,55))
lines(density(rnorm(nsamp,lam_est[2,1],sqrt(var_est[2,1]))),lwd=2)
lines(density(rnorm(nsamp,lam_est[3,1],sqrt(var_est[3,1]))),col=2,lwd=2)


plot(density(rnorm(nsamp,pr.mu1,sqrt(pr.var1))),col=5,lwd=2,ylim=c(0,55))
lines(density(rnorm(nsamp,lam_est[1,1],sqrt(var_est[1,1]))),lwd=2)
lines(density(rnorm(nsamp,po.mu,sqrt(po.var))),col=2,lwd=2)


plot(density(h2),col=6)
lines(density(h1),col=5)
lines(density(h1b),col=4)

table(hr_post_baye>1)
table(hr_post_direct>1)


### Analyse Data




