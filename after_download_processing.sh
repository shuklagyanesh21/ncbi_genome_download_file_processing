#!/bin/bash

#this script takes two arguments
#$1 contains list of old and new names of directories and $2 of files in directories

dirname_list = $1
filename_list = $2
#Rename directories

while IFS= read -r line || [ -n "$line" ]; do
    # Get old name and new name from each line
    old_name=$(echo "$line" | awk '{print $1}')
    new_name=$(echo "$line" | awk '{print $2}')

        # Check if the directory with old_name exists
        if [ -d "$old_name" ]; then
            # Rename the directory to new_name
            mv "$old_name" "$new_name"
            echo "Directory '$old_name' renamed to '$new_name'"
        else
            echo "Directory '$old_name' not found or inaccessible"
        fi
 done < dirname_list.txt
 
#Rename subdirectory files

while IFS= read -r line || [ -n "$line" ]
do
	# Get old name and new name from each line
	old_name=$(echo "$line" | awk '{print $1}')
	new_name=$(echo "$line" | awk '{print $2}')

	# Find files containing the string in the first column and replace it with the string in the second column
	files_to_rename=$(find . -type f -name "*$old_name*")
	for file in $files_to_rename
	do
		new_file_name=$(echo "$file" | sed "s/$old_name/$new_name/g")
		mv "$file" "$new_file_name"
		echo "Renamed file '$file' to '$new_file_name'"
	done
done < filename_list.txt


#####################to find and move specific files#####################################################################################################
mkdir ../select_cds_from_genomic.fna
find . -type f -name '*_cds_from_genomic.fna' -exec cp -t ../select_cds_from_genomic.fna/ {} \;
mkdir ../select_rna_from_genomic.fna
find . -type f -name '*_rna_from_genomic.fna' -exec cp -t ../select_rna_from_genomic.fna/ {} \;
mkdir ../select_translated_cds.faa
find . -type f -name '*_translated_cds.faa' -exec cp -t ../select_translated_cds.faa/ {} \;
mkdir ../select_genomic.gbff
find . -type f -name '*_genomic.gbff' -exec cp -t ../select_genomic.gbff/ {} \;
mkdir ../select_genomic.fna
##for_genomic.fna######
find . -type f -name '*_genomic.fna' ! -name '*from_genomic.fna' -exec cp -t ../select_genomic.fna/ {} \;
echo "Specific files moved to new select folders succesfully."
#########################################################################################################################################################

