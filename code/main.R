library(httr)
library(data.table)
library(jsonlite)
library(janitor)

rm(list = ls())

source('code/trade_funs.R')

coverall <- crypto_overall()
cperf <- crypto_performance()
ctrend <- crypto_trend()
cbought <- crypto_ovebought()
csold <- crypto_oversold()

foverall <- forex_overall()
fperf <- forex_performance()
ftrend <- forex_trend()
fbought <- forex_overbought()
fsold <- forex_oversold()

soverall <- stock_overall()
sperf <- stock_performance()
strend <- stock_trend()
sbought <- stock_overbought()
ssold <- stock_oversold()
