
library(rstan)
PoD_samples <- sampling(object = PoD_model, 
                        data = list(N = N, det = pod_df$det, depth = pod_df$depth,
                                    K = K, depth_pred = depth_pred), 
                        seed = 1008)


library(ggmcmc)
PoD_extracted_samples <- ggs(S = PoD_samples)
head(x = PoD_extracted_samples, n = 5)
