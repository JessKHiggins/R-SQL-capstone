# looping over a series of years

for year in 1997 1998 1999 2000
do
    echo Year: $year
    Rscript plot_weight_by_species.R $year
done

