#####
lop <- c("data.table", "ggplot2", "curl")

to.instal <- lop[which(x = !(lop %in% installed.packages()[,"Package"]))]

if(length(to.instal) != 0) install.packages(to.instal)

temp <- lapply(X = lop, 
               FUN = library, 
               character.only = T)
rm(temp)

#####
h <- new_handle()
handle_setopt(
  handle = h,
  ssl_verifypeer = FALSE
)

url <- "https://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/"
id <- "04201500"
con <- curl(url = paste0(url, 
                         id,
                         ".dly"),
            handle = h)

dl <- as.data.table(
  x = read.fwf(file = con,
               widths = c(8, rep(x = 10,
                                 times = 5)),
               col.names = c("date", "P", "E", "Q", "Tmax", "Tmin"))
)

dl[, `:=`(date = as.IDate(x = gsub(pattern = " ",
                                   replacement = "0",
                                   x = date),
                          format = "%Y%m%d"),
          ID = as.factor(x = id))]
#####
setwd(dir = dirname(path = rstudioapi::getActiveDocumentContext()$path))

getwd()

saveRDS(object = dl,
        file = "mopex_data.rds")

dta <- readRDS(file = "mopex_data.rds")
str(object = dta)
#####
