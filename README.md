# Intrinio Stock API #

## Introduction

[Intrinio](https://intrinio.com/) offers an API to access real time and historical stock market prices and data. This package wraps the Intrinio API for R so that the response data is easy to use.

## Installation

This package can be installed via CRAN `install.packages("IntrinioStockAPI")`.


To install the Github version, use `devtools::install_github("/intrinio/r-sdk")`.

## Usage

### Step One: Set API Key

First, set your API key (Note: this is a 100% fake API key. Get key [here](https://www.alphavantage.co/support/#api-key) if you don't already have one):

```{r}
setAPIKey("ABCD")
```

### Step Two: Download data.

Here is how to get daily time series loaded directly into an `xts` object:

```{r}
amzn <- fetchSeries(function_nm = "time_series_daily", symbol = "amzn", outputsize = "full", datatype = "json")
```

The function returns a list with two elements - the `xts` object that is interpreted from the response, and the response from the `httr` package request. Now the data can be plotted, analyzed, manipulated into returns, etc.:

```{r}
head(amzn$xts_object)
plot(amzn$xts_object[ ,1])
amzn_returns <- diff(log(amzn$xts_object[ ,1]))
```

Similarly, the other Alpha Vantage data offerings are available using the same function:

```{r}
amzn_sma <- fetchSeries(function_nm = "sma", symbol = "amzn", interval = "daily", time_period = 60, series_type = "close")
amzn_bbands <- fetchSeries(function_nm = "bbands", symbol = "amzn", interval = "daily", time_period = 60, series_type = "close")
```
