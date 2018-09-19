#' Fetch Intrinio Data
#' 
#' This function takes an Intrinio API endpoint URL, API username, and API password as inputs and return a dataframe with the requested data.
#' Remember to enter your own API username and password from https://intrinio.com/account:
#' 
#' @param url The Intrinio API Endpoint URL to call i.e. api.intrinio.com/prices?ticker=AAPL
#' @param api_username Your API username, available at https://intrinio.com/account
#' @param api_password Your API password, available at https://intrinio.com/account
#' @return A data frame
#' @examples
#' api_username <- "[YOUR API USERNAME]"
#' api_password <- "[YOUR API PASSWORD]"
#' aapl_prices <- intrinio_fetch("api.intrinio.com/prices?ticker=AAPL", api_username, api_password)
#' @export

intrinio_fetch <- function(url, api_username, api_password) {

  get_data <- GET(url, authenticate(api_username, api_password, type = "basic"))
  
  # The content function parses the API response to text.
  get_data_text <- content(get_data, "text", encoding = "UTF-8")
  
  get_data_json <- fromJSON(get_data_text, flatten = TRUE)
  
  # Converting the data to a dataframe
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
      
      # Now we add the data to the existing dataframe and repeat
      get_data_df <- smartbind(get_data_df, get_data_df_page)
      
    }
  }

  intrinio_fetch <- get_data_df
  
}