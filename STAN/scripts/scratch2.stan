data{
  
  int n; // my number of observations
  
  vector[n] x; // My independent variable with length n
  
  vector[n] y; // My dependent variable with length n
  
}

parameters{
  
  real beta; // Declare parameter beta as any real number
  
  real<lower = 0> sigma; // Declare sigma as a real number > 0
}


model{
  // We assume y comes from a normal distribution with mean = beta * x and SD sigma
  y ~ normal(beta * x, sigma);
  
}
