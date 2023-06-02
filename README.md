# Extracting_Matrices_from_WIOD_for_MRIO
This is a code in RStudio which takes deflated WIOTs in a long format, and converts them into a wide table (similar to the original WIOT format). It further extracts matrices Z (transaction matrix), Y (final demand) and V (value-added) for each year (2000-2014) and saves them as excel files.



To obtain deflated WIOTs in long format, refer: https://github.com/GICN/Deflating_WIOD_Tables/blob/master/code/Deflate_tables.R

The output of this code can be used to perform an SDA analysis. Refer: 

