library(httr)
library(data.table)
library(jsonlite)



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
  `cookie` = 'sessionid=xh32beu1f5bjcqasn7lp0oajmsr4zbpb; png=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; etg=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; cachec=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; tv_ecuid=5b79a2a6-0318-4e9a-8603-dac7edbda2e4; _sp_ses.cf1a=*; _sp_id.cf1a=0439952b-8c16-4872-aaf1-5eabfe18173c.1607445585.8.1607872130.1607861213.f5d333ec-95a0-4bcd-a3cc-4cbf66231dec',
  `dnt` = '1',
  `sec-gpc` = '1'
)

data = '{"filter":[{"left":"name","operation":"nempty"},{"left":"sector","operation":"in_range","right":["Major","Minor"]}],"options":{"lang":"en"},"symbols":{"query":{"types":["forex"]},"tickers":[]},"columns":["base_currency_logoid","currency_logoid","name","Recommend.MA", "Recommend.All", "bid","ask","high","low", "close", "SMA5", "SMA10","SMA20", "SMA30", "SMA50", "SMA100", "SMA200", "BB.upper","BB.lower","description","name","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","BB.upper","BB.lower"],"sort":{"sortBy":"name","sortOrder":"asc"},"range":[0,150]}'

res <- httr::POST(url = 'https://scanner.tradingview.com/forex/scan', httr::add_headers(.headers=headers), body = data)


forexdf <- extractor(res)
