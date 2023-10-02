# install.packages("devtools")
# install.packages("curl")

library(usethis)

use_git()
use_github()
gh_token_help()
create_github_token()
gitcreds::gitcreds_set()

curl::curl_download(url = "https://github.com/strnda/env_hydrology/archive/refs/heads/main.zip", 
                    destfile = "test.zip")

unzip(zipfile = "test.zip")


setwd(dir = "C://Users/strnadf/Desktop/")
dir.exists(paths = "C://Users/strnadf/Desktop/")

system(command = "git clone https://github.com/RodriMV89/env_hydrology.git")
