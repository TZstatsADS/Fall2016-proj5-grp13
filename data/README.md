# Project: 
### Data folder

The data directory contains data used in the analysis. This is treated as read only; in paricular the R/python files are never allowed to write to the files in here. Depending on the project, these might be csv files, a database, and the directory itself may have subdirectories.

    1. RedditNews.csv: two columns The first column is the "date", and second column is the "news headlines". All news are ranked from top to bottom based on how hot they are. Hence, there are 25 lines for each date.
    

    2. DJIA_table.csv: Downloaded directly from Yahoo Finance: check out the web page for more info.


    3. Combined_News_DJIA.csv: To make things easier for my students, I provide this combined dataset with 27 columns. The first column is "Date", the second is "Label", and the following ones are news headlines ranging from "Top1" to "Top25".
    
    
    4. dat_prediction.rds: feature-extracted data
    
    
    

