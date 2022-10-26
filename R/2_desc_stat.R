# source(file = "./1_data_import.R")

dta <- readRDS(file = "./data/mopex_data.rds")

dta[dta == -99,] <- NA

dta_m <- melt(data = dta,
              id.vars = c("ID", "date"))

mode_stat <- function(x, na.rm = TRUE) {
  
  if (na.rm) {
    
    x <- x[!is.na(x = x)]
  }
  
  prob <- density(x = x)
  # plot(x = prob)
  
  out <- prob$x[which.max(x = prob$y)]
  
  out
}

temp_1 <- dta_m[variable != "P", 
                .(mean = mean(x = value, 
                              na.rm = TRUE),
                  sd = sd(x = value, 
                          na.rm = TRUE),
                  min = min(x = value, 
                            na.rm = TRUE),
                  max = max(x = value, 
                            na.rm = TRUE),
                  iqr = IQR(x = value, 
                            na.rm = TRUE),
                  median = median(x = value, 
                                  na.rm = TRUE), 
                  mode = mode_stat(x = value, 
                                   na.rm = TRUE)),
                by = variable]

temp_2 <- dta_m[(variable == "P") & (value > 0), 
                .(mean = mean(x = value, 
                              na.rm = TRUE),
                  sd = sd(x = value, 
                          na.rm = TRUE),
                  min = min(x = value, 
                            na.rm = TRUE),
                  max = max(x = value, 
                            na.rm = TRUE),
                  iqr = IQR(x = value, 
                            na.rm = TRUE),
                  median = median(x = value, 
                                  na.rm = TRUE), 
                  mode = mode_stat(x = value, 
                                   na.rm = TRUE)),
                by = variable]

desc_stat <- rbind(temp_1, temp_2)

desc_stat

ggplot(data = dta_m) +
  geom_line(mapping = aes(x = date,
                          y = value, 
                          colour = variable), 
            na.rm = TRUE, 
            show.legend = FALSE) +
  facet_wrap(facets = ~variable, 
             ncol = 1, 
             scales = "free_y")

# ggplot(data = dta_m) +
#   geom_histogram(mapping = aes(x = value,
#                                fill = variable), 
#                  na.rm = TRUE, 
#                  show.legend = FALSE) +
#   facet_wrap(facets = ~variable, 
#              ncol = 5, 
#              scales = "free")
# 
# ggplot(data = dta_m) +
#   geom_density(mapping = aes(x = value,
#                                fill = variable), 
#                  na.rm = TRUE, 
#                  show.legend = FALSE) +
#   facet_wrap(facets = ~variable, 
#              ncol = 5, 
#              scales = "free")

