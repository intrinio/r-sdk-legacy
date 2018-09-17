#This function will take an Intrinio API URL, API password, and API username as inputs and return a dataframe with the requested data.

#Here is an example of how to use it- remember to enter your own API username and password from intrinio.com/login:

#apple_prices <- get_intrinio_data("api.intrinio.com/prices?ticker=AAPL", "a543b029ec930ab0c7add95bfa1ea3ac", "ad905ac37ffc277c8184d90c6e2f36c4")

get_intrinio <- function(URL, API_USERNAME, API_PASSWORD){
  
  #Require the package so you can use it make sure to install the httr package if you haven't
  require("httr")
  
  #Require the package so you can use it- install the package if you haven't
  require("jsonlite")
  
  
  #Create variables for the username and password you undered into the function above
  username <- API_USERNAME
  password <- API_PASSWORD
  
  #Creating a variable that is the API URL you entered into the function above
  call1 <- URL
  
  #This line of code uses the httr package's GET function to query Intrinio's API, passing your username and password as variables
  get_data <- GET(call1, authenticate(username,password, type = "basic"))
  
  #The content function parses the API response to text. You can parse to other formats, but this format is the easiest to work with. Text is equivalent to JSON
  get_data_text <- content(get_data, "text", encoding = "UTF-8")
  
  #This line of code uses the JSONlite function fromJSON to parse the JSON into a flat form. Flat means rows and coloumns instead of nested JSON
  get_data_json <- fromJSON(get_data_text, flatten = TRUE)
  
  #Converting the data to a dataframe
  get_data_df <- as.data.frame(get_data_json)
  
  #The original JSON is actually a list. One item in the list, total_pages, tells us how many pages of data there are in total. 
  #The API limits each page to 100 results, so if there is lots of data, you need to call multiple pages. 
  
  pages <- get_data_json$total_pages
  
  #Since we already have the first 100 results in a data frame, this for loop starts with the second page of data and continues
  #until all pages have been returned. Each time a new page comes back, we add it to the first data frame we made. It will only run 
  #If there is more than 1 page
  
  pages <- ifelse(is.null(pages), 0, pages)
  
  if(pages > 1){
  
  for(i in 2:pages){
    
    #Making an API call that has page_number= at the end. This will incrememnt by 1 in each loop until we have all pages
    call_2 <- paste(call1,"&","page_number=", i, sep="")
    
    #Making the API call
    get_data_2 <- GET(call_2, authenticate(username,password, type = "basic"))
    
    #Parsing it to JSON
    get_data_text_2 <- content(get_data_2, "text", encoding = "UTF-8")
    
    #Converting it from JSON to a a list we can use. This actually gives us a list, one item of which is the data, the rest is information about the API call
    get_data_json_2 <- fromJSON(get_data_text_2, flatten = TRUE)
    
    #This grabs just the data we want and makes it a data frame
    get_data_df_2 <- as.data.frame(get_data_json_2)
    
    #Now we add the data to the existing dataframe and repeat
    get_data_df <- rbind(get_data_df, get_data_df_2)
    
  }
  
  }
  
  #Now we have the function return the full dataframe
  get_intrinio_data <- get_data_df
  
}
