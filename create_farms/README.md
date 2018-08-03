#Example Script used to create BASE FARMs in Scalr based off a .csv

# CSV format
``` CSV
FarmName, Otherdata1, Otherdata2, Otherdata3
Devapp1, xxx, xxx, xxx
Prodapp1, xxx, xxx, xxx
QAapp1, xxx, xxx, xxx

```

## Execute the script
You will need to provide the path to the .CSV file with your farm names in it, and the scalr_projectid.

To get the Scalr Project ID use:
-  'scalr-ctl project list'


./create_farms.sh example.csv scalr_projectid
