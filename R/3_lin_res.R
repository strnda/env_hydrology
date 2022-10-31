dta <- readRDS(file = "./data/mopex_data.rds")

ln <- function(IN, S0 = 1, k = .1) {

  OUT <- vector(mode = "numeric",
                length = length(x = IN))
  S <- S0
  
  for (i in seq_along(along.with = IN)) {
    
    OUT[i] <- k * S
    S <- S - OUT[i] + IN[i]
  }
  
  OUT
}

test <- ln(IN = dta$P,
           S0 = 100, 
           k = .4)

plot(x = dta$Q[1:500], 
     type = "l")
lines(x = test[1:500], 
      col = "red")
