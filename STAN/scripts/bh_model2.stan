data{
  
  int<lower = 0> n; //Define number of observations
  
  vector<lower = 0>[n] ssb; //Define vector for SSB, with length n
  
  vector[n] r; //Define vactor for r, with length n
  
  real max_r;  // max observed recruitment
  
}

transformed data{
  
  vector[n] log_r;
  
  log_r = log(r);
  
}

parameters{
  
  real<lower = 0.2, upper = 1> h; //Define steepness bounded between 0.2 and 1
  
  real<lower = 0> alpha; //Define Alpha larger than 0
  
  real<lower = 0> sigma; //Define sigma bounded at > 0
  
}

// Things in transformed parameters block are made available
// Anything here is evaluated at every step of the modeling

transformed parameters{
  
  vector[n] rhat; // Vector of predicted recruits

  vector[n] log_rhat; // Vector of log(predicted rectuits)

  rhat = (0.8 * alpha * h * ssb) ./ (0.2 * alpha * (1 - h) +(h - 0.2) * ssb); // This is how recruits are calculated

  log_rhat = log(rhat); // ANd this is how log recruits are calculated
  
}

// Anything inside the model brackets is not made available

model{
  
  log_r ~ normal(log_rhat - 0.5 * sigma^2, sigma); //Specify relationship of log_r

  sigma ~ cauchy(0, 5); //Specify sigma with a cauchy relationship

  alpha ~ normal(2 * max_r, 0.1 * 2 * max_r); //Specify the relationship for alpha

}

generated quantities{

  vector[n] pp_rhat;

  for (i in 1:n) {

   pp_rhat[i] = exp(normal_rng(log_rhat[i] - 0.5 * sigma^2, sigma));

  }

}
