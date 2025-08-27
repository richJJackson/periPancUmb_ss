
install.packages("shinystan")
library(rstan)
library(shinystan)

setwd("~/Documents/GitHub/periPancUmb_ss/Analysis")
dir()

### laoding data

load("exData.R")


#### Compiling model
model <- stan_model("logisitc.stan")
model
###

### Setting dataa
tr1 <- data[which(data$trial==1),]
out <- tr1$out
arm <- tr1$alloc
dt <- list(N,out,arm)

dt <- list("N"=N,"out"=out,"arm"=arm,"alpha_prior_mu"=0,"alpha_prior_sd"=10)

### Basic Model
options(mc.cores=4)
basic_fit <- sampling(model,dt,iter=10000,chains=4,warmup=2000,thin=2)
print(basic_fit)


#### Getting information on 'alpha' parameter
table(tr23$out[tr23$alloc==0]). ### 48/54 'successes'
glm.mod <- glm(out~alloc,data=tr23,family="binomial")
mu_alp <- summary(glm.mod)$coefficients[1,1]
sd_alp <- summary(glm.mod)$coefficients[1,2] ## NB inflated variance
sd_alp <- sqrt((sd_alp^2)*2)

dt_borrow <- dt
dt_borrow$alpha_prior_mu <- mu_alp
dt_borrow$alpha_prior_sd <- sd_alp

borrow_fit <- sampling(model,dt_borrow,iter=10000,chains=4,warmup=2000,thin=2)
print(borrow_fit)

### dist of intercept and efficacy parameters from basic and borrowed models

basic_param <- extract(basic_fit)
borrow_param <- extract(borrow_fit)

par(mfrow=c(1,2))
plot(density(basic_param$alpha),main="Alpha (Intercept)",lwd=2,col=2,ylim=c(0,1))
lines(density(borrow_param$alpha),lwd=2,col=4)

plot(density(basic_param$beta),main="Beta (Treatment Effect)",lwd=2,col=2,ylim=c(0,0.7))
lines(density(borrow_param$beta),lwd=2,col=4)




