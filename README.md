# Intrinio Stock API #

## Introduction

[Intrinio](https://intrinio.com/) offers an API to access real time and historical stock market prices and data. This package wraps the Intrinio API for R so that the response data is easy to use.

## Installation

This package can be installed via CRAN `install.packages("IntrinioStockAPI")`.


To install the Github version, use `devtools::install_github("intrinio/r-sdk")`.

## Usage

### Get Your Intrinio API Credentials

First, create an account for the [Intrinio Stock API](https://intrinio.com/)

### Fetch Stock Price Data

For example, let's grab daily prices for the Apple Security

```{r}
apple_prices <- intrinio_fetch("api.intrinio.com/prices?ticker=AAPL", "[YOUR API USERNAME]", "[YOUR API PASSWORD]")
```

The function returns a data frame which can be plotted as follows:

```{r}

```
