args = commandArgs(trailingOnly=TRUE)
playlist = args[[2]]
source = args[[1]]
if(source == "spotify"){

library(RSelenium)

driver <- rsDriver(browser=c("chrome"))

driver$client$navigate("https://exportify.net/")

id="loginButton"

login_button <- driver$client$findElement(using = 'id', value = 'loginButton')
login_button$clickElement()

username_field <- driver$client$findElement(using = "xpath", value = "//input[@ng-model='form.username']")
username_field$sendKeysToElement(list("d_kennedy"))
password_field <- driver$client$findElement(using = "xpath", value = "//input[@ng-model='form.password']")
password_field$sendKeysToElement(list("MAbrP7KX3h5NTJy"))

login_button <- driver$client$findElement(using = 'id', value = 'login-button')
login_button$clickElement()
Sys.sleep(2)
# Download
export_button <- driver$client$findElement(using = "xpath", value = paste0(
  "//td//button[..//..//a/text()='",playlist,"']"))
export_button$clickElement()
Sys.sleep(2)

df <- file.info(list.files("~/Downloads", full.names = T))
file <- rownames(df)[which.max(df$mtime)]

library(stringr)
new_list <- read.csv(file,stringsAsFactors = FALSE)

colnames(new_list)[[1]] <- "url"
new_list$played <- FALSE
new_list$stub <- str_match(new_list$url,pattern = "^spotify:track:(.*)$")[,2]
new_list$stub[is.na(new_list$stub)] <- new_list$url
new_list$url <- paste0("https://open.spotify.com/track/",new_list$stub)
new_list <- new_list[,c("url","played")]

write.csv(new_list,row.names = FALSE,file = "song-list.csv")
cat("Scrape and import complete.\n")
}

