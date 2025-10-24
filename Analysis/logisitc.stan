//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int <lower=0> N; // Defining the number of Patients in the test dataset
  int<lower=0,upper=1> out[N]; // outcome
  vector[N] arm; // Treatment arm
  real alpha_prior_mu;
  real alpha_prior_sd;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real alpha;
  real beta;
}


// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  // Prior for the unobserved parameters
  alpha ~ normal(alpha_prior_mu, alpha_prior_sd);
  beta ~ normal(0,1000);
  
  // A logistic regression model
  out ~ bernoulli_logit(alpha+ beta*arm);
}

