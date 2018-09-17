#This function will take an Intrinio API URL, API password, and API username as inputs and return a dataframe with the requested data.

#Here is an example of how to use it- remember to enter your own API username and password from intrinio.com/account:

#apple_prices <- get_intrinio_data("api.intrinio.com/prices?ticker=AAPL", "a543b029ec930ab0c7add95bfa1ea3ac", "ad905ac37ffc277c8184d90c6e2f36c4")


#' Fetch time series data
#' 
#' This is the main function that pulls data directly from Alpha Vantage into a convenient \code{xts} object. This is a general function
#' that reflects exactly the documentation listed \href{https://www.alphavantage.co/documentation/}{online}.
#' 
#' @param url The Intrinio API URL to call i.e. api.intrinio.com/prices?ticker=AAPL
#' @param api_username Your API username, available at https://intrinio.com/account
#' @param api_username Your API username, available at https://intrinio.com/account
#' @return A data frame
#' @examples
#' apple_prices <- get_intrinio_data("api.intrinio.com/prices?ticker=AAPL", "[YOUR API USERNAME]", "[YOUR API PASSWORD]")
#' @export

fetch <- function(url, api_username, api_password) {
  
  #Require the package so you can use it make sure to install the httr package if you haven't
  require("httr")
  
  #Require the package so you can use it- install the package if you haven't
  require("jsonlite")
    
  get_data <- GET(url, authenticate(api_username, api_password, type = "basic"))
  
  #The content function parses the API response to text.
  get_data_text <- content(get_data, "text", encoding = "UTF-8")
  
  get_data_json <- fromJSON(get_data_text, flatten = TRUE)
  
  #Converting the data to a dataframe
  get_data_df <- as.data.frame(get_data_json)
  
  pages <- get_data_json$total_pages
    
  pages <- ifelse(is.null(pages), 0, pages)
  
  if(pages > 1) {
    for(i in 2:pages) {
      paged_url <- paste(url, "&", "page_number=", i, sep="")
      
      get_data_page <- GET(paged_url, authenticate(api_username, api_password, type = "basic"))
      
      get_data_text_page <- content(get_data_page, "text", encoding = "UTF-8")
      
      get_data_json_page <- fromJSON(get_data_text_page, flatten = TRUE)
      
      get_data_df_page <- as.data.frame(get_data_json_page)
      
      #Now we add the data to the existing dataframe and repeat
      get_data_df <- rbind(get_data_df, get_data_df_page)
      
    }
  }

  fetch <- get_data_df
  
}
