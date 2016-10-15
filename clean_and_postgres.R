# Load CSV file data, clean it and send it to postgres


require(dplyr)
require(tidyr)
require(tibble)
require(magrittr)
require(stringr)
require(RPostgreSQL)

change_marker <- function(x) {
  x <-   sapply(x,function(y) {
    if(grepl('[Mm]arker',y)) {
    y
  } else {
    paste0("New Hand ",y)
  }
  })
}

load_data <- data.table::fread("S12 Walkthrough Report with Actions - Sample #1 - Markers.csv") %>% as_tibble %>% select(-V3)
names(load_data) <- c('marker_name','position','session','hand','round','seat','player_id','name','hole_cards',
                      'sklansky','action','amount','board','player_hand','dealer')
load_data %<>% mutate(marker_name=change_marker(marker_name)) %>% 
  mutate(position=paste0('2014-10-14 ',position) %>% as.POSIXct,amount=str_extract(amount,'[0-9]+\\.[0-9]+') %>% as.numeric,
         player_id=coalesce(as.integer(player_id),9999L),modtime=Sys.time(),action=if_else(action=='','New Hand',action))

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, dbname = "video_data",
                 host='beyondtells.clnfxpv1oeaq.us-west-2.rds.amazonaws.com',
                 user='beyond_admin',
                 password='Bluf7MeN%T')

dbWriteTable(con,'timed_hands',value=as.data.frame(load_data),append=TRUE,row.names=FALSE)
