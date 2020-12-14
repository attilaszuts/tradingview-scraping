library(taskscheduleR)
taskscheduler_create(taskname = "daily_scrape", rscript = "D:/Projects/BA-20-21/coding-2/tradingview-scraping/code/main.R", 
                     schedule = "DAILY", starttime = format(Sys.time(), "%H:%M"))

# list active tasks
tasks <- taskscheduler_ls()

View(tasks[tasks$TaskName == 'daily_scrape',])

taskscheduler_delete('daily_scrape')

