# return data from request
extractor <- function(res, data) {
  # extract data from request
  df <- fromJSON(content(res, 'text'))
  
  # get column names from request parameters 
  t <- fromJSON(data)
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


# forex -------------------------------------------------------------------

# return stats overall (returns a df) -- Major, Minor pairs
forex_overall <- function() {
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
  
  data = '{"filter":[{"left":"name","operation":"nempty"},{"left":"sector","operation":"in_range","right":["Major","Minor"]}],"options":{"lang":"en"},"symbols":{"query":{"types":["forex"]},"tickers":[]},"columns":["base_currency_logoid","currency_logoid","name","close","change","change_abs","bid","ask","high","low","Recommend.All","description","name","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/forex/scan', httr::add_headers(.headers=headers), body = data)
  
  forexdf <- extractor(res, data)
  
  return(forexdf)
}

# return stats on performance (returns a df) -- Major, Minor pairs
forex_performance <- function() {

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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607873398.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '{"filter":[{"left":"name","operation":"nempty"},{"left":"sector","operation":"in_range","right":["Major","Minor"]}],"options":{"lang":"en"},"symbols":{"query":{"types":["forex"]},"tickers":[]},"columns":["base_currency_logoid","currency_logoid","name","change","Perf.W","Perf.1M","Perf.3M","Perf.6M","Perf.YTD","Perf.Y","Volatility.D","description","name","type","subtype","update_mode"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/forex/scan', httr::add_headers(.headers=headers), body = data)
  
  forexdf <- extractor(res, data)
  
  return(forexdf)
}

# return stats on trend-following (returns a df) -- Major, Minor pairs
forex_trend <- function() {
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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607873484.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '{"filter":[{"left":"name","operation":"nempty"},{"left":"sector","operation":"in_range","right":["Major","Minor"]}],"options":{"lang":"en"},"symbols":{"query":{"types":["forex"]},"tickers":[]},"columns":["base_currency_logoid","currency_logoid","name","Recommend.MA","close","SMA20","SMA50","SMA200","BB.upper","BB.lower","description","name","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","SMA20","close","SMA50","SMA200","BB.upper","BB.lower"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/forex/scan', httr::add_headers(.headers=headers), body = data)
  
  forexdf <- extractor(res, data)
  
  return(forexdf)
}


# stocks ------------------------------------------------------------------

# return stats overall (returns a df)
stock_overall <- function() {
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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607874249.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '{"filter":[{"left":"market_cap_basic","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","","etf","unit","mutual","money","reit","trust"]},{"left":"exchange","operation":"in_range","right":["NYSE","NASDAQ","AMEX"]}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["logoid","name","close","change","change_abs","Recommend.All","volume","market_cap_basic","price_earnings_ttm","earnings_per_share_basic_ttm","number_of_employees","sector","description","name","type","subtype","update_mode","pricescale","minmov","fractional","minmove2"],"sort":{"sortBy":"market_cap_basic","sortOrder":"desc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/america/scan', httr::add_headers(.headers=headers), body = data)
  
  stockdf <- extractor(res, data)
  
  return(stockdf)
}

# return stats on performance (returns a df)
stock_performance <- function() {
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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607874295.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '{"filter":[{"left":"market_cap_basic","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","","etf","unit","mutual","money","reit","trust"]},{"left":"exchange","operation":"in_range","right":["NYSE","NASDAQ","AMEX"]}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["logoid","name","change|1","change|5","change|15","change|60","change|240","change","Perf.W","Perf.1M","Perf.3M","Perf.6M","Perf.YTD","Perf.Y","beta_1_year","Volatility.D","description","name","type","subtype","update_mode"],"sort":{"sortBy":"market_cap_basic","sortOrder":"desc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/america/scan', httr::add_headers(.headers=headers), body = data)
  
  stockdf <- extractor(res, data)
  
  return(stockdf)
}

# return stats on trend-following (returns a df)
stock_trend <- function() {
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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607874351.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '{"filter":[{"left":"market_cap_basic","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","","etf","unit","mutual","money","reit","trust"]},{"left":"exchange","operation":"in_range","right":["NYSE","NASDAQ","AMEX"]}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["logoid","name","Recommend.MA","close","SMA20","SMA50","SMA200","BB.upper","BB.lower","description","name","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","SMA20","close","SMA50","SMA200","BB.upper","BB.lower"],"sort":{"sortBy":"market_cap_basic","sortOrder":"desc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/america/scan', httr::add_headers(.headers=headers), body = data)
  
  stockdf <- extractor(res, data)
  
  return(stockdf)
}



# crypto ------------------------------------------------------------------

# return stats overall (returns a df)
crypto_overall <- function() {
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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607874477.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '^{^\\^filter^\\^:^[^{^\\^left^\\^:^\\^name^\\^,^\\^operation^\\^:^\\^nempty^\\^^}^],^\\^options^\\^:^{^\\^lang^\\^:^\\^en^\\^^},^\\^symbols^\\^:^{^\\^query^\\^:^{^\\^types^\\^:^[^]^},^\\^tickers^\\^:^[^]^},^\\^columns^\\^:^[^\\^base_currency_logoid^\\^,^\\^currency_logoid^\\^,^\\^name^\\^,^\\^close^\\^,^\\^change^\\^,^\\^change_abs^\\^,^\\^high^\\^,^\\^low^\\^,^\\^volume^\\^,^\\^Recommend.All^\\^,^\\^exchange^\\^,^\\^description^\\^,^\\^name^\\^,^\\^type^\\^,^\\^subtype^\\^,^\\^update_mode^\\^,^\\^pricescale^\\^,^\\^minmov^\\^,^\\^fractional^\\^,^\\^minmove2^\\^^],^\\^sort^\\^:^{^\\^sortBy^\\^:^\\^name^\\^,^\\^sortOrder^\\^:^\\^asc^\\^^},^\\^range^\\^:^[0,150^]^}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/crypto/scan', httr::add_headers(.headers=headers), body = data)
  
  cryptodf <- extractor(res, data)
  
  return(cryptodf)
}

# return stats on performance (returns a df)
crypto_performance <- function() {
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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607874551.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '{"filter":[{"left":"name","operation":"nempty"}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["base_currency_logoid","currency_logoid","name","change","Perf.W","Perf.1M","Perf.3M","Perf.6M","Perf.YTD","Perf.Y","Volatility.D","description","name","type","subtype","update_mode"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/crypto/scan', httr::add_headers(.headers=headers), body = data)
  
  cryptodf <- extractor(res, data)
  
  return(cryptodf)
}

# return stats on trend-following (returns a df)
crypto_trend <- function() {
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
    `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607874583.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
    `dnt` = '1',
    `sec-gpc` = '1'
  )
  
  data = '{"filter":[{"left":"name","operation":"nempty"}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["base_currency_logoid","currency_logoid","name","Recommend.MA","close","SMA20","SMA50","SMA200","BB.upper","BB.lower","description","name","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","SMA20","close","SMA50","SMA200","BB.upper","BB.lower"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/crypto/scan', httr::add_headers(.headers=headers), body = data)
  
  cryptodf <- extractor(res, data)
  
  return(cryptodf)
}



