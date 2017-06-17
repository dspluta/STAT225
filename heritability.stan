data {
  int<lower=1> N;
  real<lower=0> alpha;
  real<lower=0> beta;
  real<lower=0> theta;
  matrix[N, N] K;
  cov_matrix[N] Sigma_eps;
  vector[N] y;
}
transformed data {
  vector[N] mu;
  for (i in 1:N)
    mu[i] = 0;
}
parameters {
  real<lower=0> sigma_sq_g;
  real<lower=0> sigma_sq_eps;
}
transformed parameters {
  cov_matrix[N] Sigma;
  real<lower=0> h2;
  Sigma = sigma_sq_g * K + sigma_sq_eps * Sigma_eps;
  h2 = sigma_sq_g/(sigma_sq_g + sigma_sq_eps);
}
model {
  sigma_sq_g ~ gamma(alpha, theta);
  sigma_sq_eps ~ gamma(beta, theta);
  y ~ multi_normal(mu, Sigma);
}
generated quantities{
  vector[N] y_pred;
  y_pred = multi_normal_rng(mu, Sigma);
}
