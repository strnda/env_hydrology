a <- 1:100
a[58]; a[5]

a[c(5, 8, 18:30)]

b <- c(1, 8, 6, "d")

class(x = a)
class(x = b)

is.character(x = a)
is.character(x = b)

class(x = is.character(x = a))
class(x = as.character(x = a))

methods(generic.function = "plot")
methods(class = "data.frame")

d <- sample(x = letters, 
            size = 10E7, 
            replace = TRUE)
class(x = d)
object.size(x = d)

d
unique(x = d)

f <- as.factor(x = d)

f

date <- as.Date(x = "01-12-1988",
                format = "%d-%m-%Y")
s <- seq(from = date,
         to = Sys.Date(),
         by = "day")
length(x = s)

format(x = median(x = s),
       format = "%Y")

df <- data.frame(date = s,
                 id = sample(x = LETTERS,
                             size = length(x = s),
                             replace = TRUE),
                 val = rnorm(n = length(x = s)))

df

head(x = df)
tail(x = df, 
     n = 8)

summary(object = df)

## df - datum: median az dnes bez 14 dni; id = x; val = mensi nez 1

df_subset <- df[(df$date >= median(x = df$date) & df$date <= Sys.Date() - 14) &
                  (df$id == "X") &
                  (df$val < 1), ]

head(x = df_subset)

summary(object = df_subset)
