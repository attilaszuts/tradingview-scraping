library(httr)
library(data.table)
library(jsonlite)
library(janitor)
library(knitr)
library(tidyverse)

rm(list = ls())

# read in credentials
creds <- read.delim('D:/Projects/BA-20-21/coding-2/tradingview-scraping/data/creds.txt', sep = ',')
key <- creds[creds$key == 'key', 2]
webhookurl <- creds[creds$key == 'webhookurl', 2]
ati <- creds[creds$key == 'ati', 2]
robi <- creds[creds$key == 'robi', 2]

# define scraper function, that takes request body as parameter
scraper <- function(data) {
  headers = c(
    `authority` = 'scanner.tradingview.com',
    `accept` = 'text/plain, */*; q=0.01',
    `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
    `content-type` = 'application/x-www-form-urlencoded; charset=UTF-8',
    `origin` = 'https://www.tradingview.com',
    `sec-fetch-site` = 'same-site',
    `sec-fetch-mode` = 'cors',
    `sec-fetch-dest` = 'empty',
    `referer` = 'https://www.tradingview.com/',
    `accept-language` = 'en-US,en;q=0.9,hu;q=0.8,de;q=0.7',
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607873161.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  res <- httr::POST(url = paste0('https://scanner.tradingview.com/', data[1], '/scan'), httr::add_headers(.headers=headers), body = data[2])
  # extract data from request
  df <- fromJSON(content(res, 'text'))
  
  # get column names from request parameters 
  t <- fromJSON(data[2])
  t_colnames <- t$columns
  
  # create dataframe from request
  findf <- 
    rbindlist(
      lapply(df$data$d, function(x){
        tdf <- data.frame(t(data.frame(x)))
        names(tdf) <- t_colnames
        return(tdf)
      })
    )
  findf <- clean_names(findf)
  return(findf)
}

# create empty list and then add request body parameters to it
params <- list()

params$forex_overall = c("forex", '{"filter":[{"left":"name","operation":"nempty"},{"left":"sector","operation":"in_range","right":["Major","Minor"]}],"options":{"lang":"en"},"symbols":{"query":{"types":["forex"]},"tickers":[]},"columns":["name","close","change","change_abs","bid","ask","high","low","Recommend.All","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","Perf.W","Perf.1M","Perf.3M","Perf.6M","Perf.YTD","Perf.Y","Volatility.D", "Recommend.MA","SMA20","SMA50","SMA200","BB.upper","BB.lower"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,10000]}')
params$forex_overbought = c("forex", '{"filter":[{"left":"name","operation":"nempty"},{"left":"sector","operation":"in_range","right":["Major","Minor"]},{"left":"RSI","operation":"greater","right":70}],"options":{"active_symbols_only":true,"lang":"en"},"symbols":{"query":{"types":["forex"]},"tickers":[]},"columns":["name","Recommend.MA","bid","ask","high","low","close","SMA20","SMA50","SMA200","BB.upper","BB.lower","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"], "sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,5000]}')
params$forex_oversold = c("forex", '{"filter":[{"left":"name","operation":"nempty"},{"left":"sector","operation":"in_range","right":["Major","Minor"]},{"left":"RSI","operation":"less","right":30}],"options":{"active_symbols_only":true,"lang":"en"},"symbols":{"query":{"types":["forex"]},"tickers":[]},"columns":["name","Recommend.MA","bid","ask","high","low","close","SMA20","SMA50","SMA200","BB.upper","BB.lower","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}')

params$stock_overall = c("america", '{"filter":[{"left":"market_cap_basic","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","","etf","unit","mutual","money","reit","trust"]},{"left":"exchange","operation":"in_range","right":["NYSE","NASDAQ","AMEX"]}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["name","close","change","change_abs","Recommend.All","volume","price_earnings_ttm","earnings_per_share_basic_ttm","number_of_employees","sector","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2", "change|1","change|5","change|15","change|60","change|240","Perf.W","Perf.1M","Perf.3M","Perf.6M","Perf.YTD","Perf.Y","beta_1_year","Volatility.D", "Recommend.MA","SMA5", "SMA10","SMA20", "SMA30","SMA50", "SMA100", "SMA200", "BB.upper","BB.lower"],"sort":{"sortBy":"market_cap_basic","sortOrder":"desc"},"range":[0,10000]}')
params$stock_overbought = c("america", '{"filter":[{"left":"name","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","","etf","unit","mutual","money","reit","trust"]},{"left":"exchange","operation":"in_range","right":["NYSE","NASDAQ","AMEX"]},{"left":"RSI","operation":"greater","right":70}],"options":{"active_symbols_only":true,"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["name","Recommend.MA","close","SMA20","SMA50","SMA200","BB.upper","BB.lower","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}')
params$stock_oversold = c("america", '{"filter":[{"left":"name","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","","etf","unit","mutual","money","reit","trust"]},{"left":"exchange","operation":"in_range","right":["NYSE","NASDAQ","AMEX"]},{"left":"RSI","operation":"less","right":30}],"options":{"active_symbols_only":true,"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["name","Recommend.MA","close","SMA20","SMA50","SMA200","BB.upper","BB.lower","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}')

params$crypto_overall = c("crypto", '{"filter":[{"left":"name","operation":"nempty"}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["name","close","change","change_abs","bid","ask","high","low","volume","Recommend.All","exchange","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2", "Perf.W","Perf.1M","Perf.3M","Perf.6M","Perf.YTD","Perf.Y","Volatility.D", "Recommend.MA", "SMA5", "SMA10", "SMA20", "SMA30", "SMA50", "SMA100", "SMA200","BB.upper","BB.lower"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,10000]}')
params$crypto_overbought = c("crypto", '{"filter":[{"left":"name","operation":"nempty"},{"left":"RSI","operation":"greater","right":70}],"options":{"active_symbols_only":true,"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["name","close","change","change_abs","bid","ask","high","low","volume","Recommend.All","exchange","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}')
params$crypto_oversold = c("crypto", '{"filter":[{"left":"name","operation":"nempty"},{"left":"RSI","operation":"less","right":30}],"options":{"active_symbols_only":true,"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["name","close","change","change_abs","bid","ask","high","low","volume","Recommend.All","exchange","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}')


# lapply scraper function to get a list of dataframes of stocks, forex and crypto data
outlist <- lapply(params, scraper)

# write out data
for (e in 1:length(outlist)) {
  if (length(outlist[e]) > 0) {
    write_csv(outlist[[e]], paste0('D:/Projects/BA-20-21/coding-2/tradingview-scraping/data/out/', format(Sys.time(), "%Y-%m-%e_%H-%M"), '-',  names(outlist)[e], '.csv'))
  }
}

# merge together overbought and oversold data on different instruments
overbought <- rbindlist(list(outlist$forex_overbought, outlist$stock_overbought, outlist$crypto_overbought), fill = T)
oversold <- rbindlist(list(outlist$forex_oversold, outlist$stock_oversold, outlist$crypto_oversold), fill = T)
overbought$buysell <- rep('overbought', length(overbought$name))
oversold$buysell <- rep('oversold', length(oversold$name))

bargain <- rbind(overbought, oversold)

# columns that need to be converted
cols.num <- c("recommend_ma", "close", "sma20", "sma50", "sma200", "bb_upper", "bb_lower", "bid","ask","high","low")

# convert data.table to data.frame
bargain <- as.data.frame(bargain)

# convert cols to numeric
bargain[cols.num] <- sapply(bargain[cols.num],as.numeric)

# convert type to factor
bargain$type <- as.factor(bargain$type)
bargain$buysell <- as.factor(bargain$buysell)

overbought.plot <- bargain %>%
  filter(buysell == 'overbought') %>% 
  mutate(close = round(close, 2)) %>% 
  group_by(type) %>% 
  arrange(desc(recommend_ma)) %>% 
  slice_head(n = 5) %>% 
  ggplot(aes(reorder(name,recommend_ma), recommend_ma)) + 
  geom_bar(aes(fill = buysell), stat = "identity", show.legend = F) + 
  geom_label(aes(label = close, hjust = -0.1)) + 
  facet_grid(type ~ ., scales = "free", space = "free") +
  theme_bw() + 
  labs(title = 'Recommendation based on Moving Averages for overbought instruments',
       y = 'Moving Average Recommendation value', 
       x = '',
       subtitle = 'label : close price') + 
  scale_fill_manual(values = c('darkred')) + 
  scale_y_continuous(breaks = seq(from = -1, to = 1, by = 0.25), limits = c(0, 1)) +
  coord_flip()

oversold.plot <- bargain %>% 
  filter(buysell == 'oversold') %>% 
  mutate(close = round(close, 2)) %>% 
  group_by(type) %>% 
  arrange(desc(recommend_ma)) %>% 
  slice_head(n = 5) %>% 
  ggplot(aes(reorder(name,recommend_ma), recommend_ma)) + 
  geom_bar(aes(fill = buysell), stat = "identity", show.legend = F) + 
  geom_label(aes(label = close, hjust = 1.2)) + 
  facet_grid(type ~ ., scales = "free", space = "free") +
  theme_bw() + 
  labs(title = 'Recommendation based on Moving Averages for oversold instruments',
       y = 'Moving Average Recommendation value', 
       x = '',
       subtitle = 'label : close price') + 
  scale_fill_manual(values = c('darkgreen')) + 
  scale_y_continuous(breaks = seq(from = -1, to = 1, by = 0.25), limits = c(-1, 0)) +
  coord_flip()

# save plots
overbought.filename <- paste0('D:/Projects/BA-20-21/coding-2/tradingview-scraping/out/', format(Sys.time(), "%Y-%m-%e"), '-', 'overbought.png')
oversold.filename <- paste0('D:/Projects/BA-20-21/coding-2/tradingview-scraping/out/', format(Sys.time(), "%Y-%m-%e"), '-', 'oversold.png')
ggsave(overbought.filename, overbought.plot, width = 20, height = 11.25)
ggsave(oversold.filename, oversold.plot, width = 20, height = 11.25)

# upload images to imgur
sold <- knitr::imgur_upload(oversold.filename, key = key)
soldurl <- sold[1]

bought <- knitr::imgur_upload(overbought.filename, key = key)
boughturl <- bought[1]

# send message to discord  ------------------------------------------------

# define webhook function
send_message <- function(webhookurl, my_text) {
  
  headers = c(
    `Content-type` = 'application/json'
  )
  data= toJSON(list("content"= my_text), auto_unbox = T)
  res <- httr::POST(url = webhookurl, httr::add_headers(.headers=headers), body = data)
}

my_text <- paste0('hello ', ati, ' ', robi, ' here are the fresh news: ', soldurl, ' ', boughturl)
send_message(webhookurl, my_text)




