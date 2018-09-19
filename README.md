# Intrinio Stock API #

## Introduction

[Intrinio](https://intrinio.com/) offers a free API to access near real time and historical stock market prices and data. 

This package wraps the Intrinio API for R so that the response data is easy to use.

## Installation

This package can be installed via CRAN `install.packages("IntrinioStockAPI")`.

To install the Github version, use `devtools::install_github("intrinio/r-sdk")`.

## Usage

### Get Your Intrinio API Credentials

First, create an account for the [Intrinio Stock API](https://intrinio.com/)

### Load the Library

```{r}
library(IntrinioStockAPI)
```

### Fetch Stock Price Data

For example, let's grab daily prices for the Apple Security...

```{r}
api_username <- "[YOUR API USERNAME]"
api_password <- "[YOUR API PASSWORD]"
intrinio_api_endpoint_url <- "api.intrinio.com/prices?ticker=AAPL"

apple_prices <- intrinio_fetch(intrinio_api_endpoint_url, api_username, api_password)
```

The intrinio_fetch function returns a data frame which can then be easily plotted as follows:

```{r}
plot(apple_prices$data.close)
```

The intrinio_fetch function works for all Intrinio API endpoints. For example, the Executive Compensation API endpoint can be used as follows:

```{r}
api_username <- "[YOUR API USERNAME]"
api_password <- "[YOUR API PASSWORD]"
intrinio_api_endpoint_url <- "api.intrinio.com/executives/compensations?identifier=@COOK_49578&company=AAPL"

tim_cook_comp <- intrinio_fetch(intrinio_api_endpoint_url, api_username, api_password)
plot(tim_cook_comp$data.total_summary/1000)
```

### Take Your Analysis Further

Full documentation for the Intrinio Financial Data API is available at https://intrinio.com/documentation/api
