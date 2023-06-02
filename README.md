# Extracting_Matrices_from_WIOD_for_MRIO
This is a code in RStudio which takes deflated WIOTs in a long format, and converts them into a wide table (similar to the original WIOT format). It further extracts matrices Z (transaction matrix), Y (final demand) and V (value-added) for each year (2000-2014) and saves them as excel files.

Steps to use this code:
1. Download input files: WIOTs in a long format will be needed as input for years 2000-2014. To obtain deflated WIOTs in long format, refer: https://github.com/GICN/Deflating_WIOD_Tables/blob/master/code/Deflate_tables.R
2. Set the working directory as the path to the folder where input files are saved.

The output of this code can be used to perform an SDA analysis in an MRIO framework. Refer: https://github.com/yashna02/MRIO-SDA-using-PyMRIO/tree/main

