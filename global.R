# Values that need to set for the whole package

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, dbname = "video_data",
                 host='beyondtells.clnfxpv1oeaq.us-west-2.rds.amazonaws.com',
                 user='beyond_admin',
                 password='Bluf7MeN%T')