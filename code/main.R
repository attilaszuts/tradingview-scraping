library(httr)
library(data.table)
library(jsonlite)
library(janitor)

source('code/trade_funs.R')

coverall <- crypto_overall()
cperf <- crypto_performance()
ctrend <- crypto_trend()

foverall <- forex_overall()
fperf <- forex_performance()
ftrend <- forex_trend()

soverall <- stock_overall()
sperf <- stock_performance()
strend <- stock_trend()

