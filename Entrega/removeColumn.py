import csv

for i in range(1987, 2009):
    with open(str(i) + ".csv","r") as source:
        rdr= csv.reader( source )
        with open(str(i) + "m.csv","w") as result:
            wtr= csv.writer( result )
            for r in rdr:
                wtr.writerow( (r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[11], r[12], r[13], r[14], r[15], r[16], r[17], r[18], r[19], r[20], r[21], r[22], r[23], r[24], r[25], r[26], r[27], r[28] ) )

            #remove col 11
