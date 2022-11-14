dta <- readRDS(file = "./data/mopex_data.rds")

dta <- dta[Q >= 0,]

ln_simple <- function(IN, S0 = 1, k = .1) {
  
  OUT <- vector(mode = "numeric",
                length = length(x = IN))
  S <- S0
  
  for (i in seq_along(along.with = IN)) {
    
    OUT[i] <- k * S
    S <- S - OUT[i] + IN[i]
  }
  
  OUT
}

sim <- ln_simple(IN = dta$P,
                 S0 = 100, 
                 k = .4)

plot(x = dta$Q[1:500], 
     type = "l")
lines(x = sim[1:500], 
      col = "red")

NSE(sim = sim,
    obs = dta$Q)
KGE(sim = sim,
    obs = dta$Q)

ln_complex <- function(IN, 
                       a = .25,  
                       S0_1 = 100, k_1 = .1,
                       S0_2 = 15, k_2 = .2,
                       S0_3 = 50, k_3 = .05) {
  
  OUT <- S_1 <- S_2 <- S_3 <-
    Q_1 <- Q_2 <- Q_3 <- vector(mode = "numeric",
                                length = length(x = IN))
  
  S_1[1] <- S0_1
  S_2[1] <- S0_2
  S_3[1] <- S0_3
  
  for (i in seq_along(along.with = IN)) {
    
    Q_1[i] <- k_1 * S_1[i]
    S_1[i + 1] <- S_1[i] - Q_1[i] + IN[i] * a
    
    Q_2[i] <- k_2 * S_2[i]
    S_2[i + 1] <- S_2[i] - Q_2[i] + IN[i] * (1 - a)
    
    Q_3[i] <- k_3 * S_3[i]
    S_3[i + 1] <- S_3[i] - Q_3[i] + Q_1[i]
    
    OUT[i] <- Q_3[i] + Q_2[i]
  }
  
  sim <- data.frame(IN = IN,
                    S_1 = S_1[-length(x = IN)],
                    S_2 = S_2[-length(x = IN)],
                    S_3 = S_3[-length(x = IN)],
                    Q_1 = Q_1,
                    Q_2 = Q_2,
                    Q_3 = Q_3,
                    OUT = OUT)
  sim
}

opt_fun <- function(x, dta) {
  
  sim <- ln_complex(IN = dta$P,
                    a = x[1],
                    S0_1 = x[2], k_1 = x[3],
                    S0_2 = x[4], k_2 = x[5],
                    S0_3 = x[6], k_3 = x[7])
  
  obj <- NSE(sim = sim$OUT, 
             obs = dta$Q)
  obj <- obj * -1
  
  obj
}

fit <- DEoptim(fn = opt_fun,
               lower = c(a = 0,
                         S0_1 = 0, k_1 = 0,
                         S0_2 = 0, k_2 = 0,
                         S0_3 = 0, k_3 = 0),
               upper = c(a = 1,
                         S0_1 = 500, k_1 = 1,
                         S0_2 = 500, k_2 = 1,
                         S0_3 = 500, k_3 = 1), 
               dta = dta, 
               control = DEoptim.control(itermax = 50, 
                                         VTR = -1))

fit$optim$bestmem

sim <- ln_complex(IN = dta$P,
                  a = fit$optim$bestmem[1],
                  S0_1 = fit$optim$bestmem[2], k_1 = fit$optim$bestmem[3],
                  S0_2 = fit$optim$bestmem[4], k_2 = fit$optim$bestmem[5],
                  S0_3 = fit$optim$bestmem[6], k_3 = fit$optim$bestmem[7])


plot(x = dta$Q[1:750],
     type = "l")
lines(x = sim$OUT[1:750],
      col = "red")

NSE(sim = sim$OUT,
    obs = dta$Q)
KGE(sim = sim$OUT,
    obs = dta$Q)
