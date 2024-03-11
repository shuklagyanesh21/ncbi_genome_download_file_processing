#!/bin/bash
#script created on 05012024
#modifies multiline fasta files to two line files and tags headers

for file in *
do
	if [ -f "$file" ]
	then
		sed -i 's/ /_/g' "$file"
		awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' "$file" | sed 's/\t/\n/g' > temp_file && mv temp_file "$file"
		echo "File '$file' modified as FASTA"
    		temp_file=$(mktemp)
		#extracting total number of lines to add leading zeros accordingly 
		total_lines=$(grep ">" "$file" | wc -l )
		digits=${#total_lines}
		count=1
		#extract part of file name before _
		tag=$(echo "$file" | awk -F'_' '{print $1_"$2"_"$3}}')
		while IFS= read -r line
		do
			if [[ "$line" == ">"* ]]
			then
				#printing serial tag number with required leading zeros
				printf -v new_count "%0${digits}d" $count
				if [[ "$file" == *rna* ]]; then
				# Define the variable a only if the file contains "rna"
					a=$(echo "$line" | sed -r "s/^>/>${tag}__rna_${new_count}\__/g" )
				else
					a=$(echo "$line" | sed -r "s/^>/>${tag}__peg_${new_count}\__/g" )
				fi
				echo "$a"	>>	"$temp_file"
				count=$((count + 1))
				else
				echo "$line"	>>	"$temp_file"
			fi
		done < "$file"
		# Append the last line
		echo "$line" >> "$temp_file"
		mv "$temp_file" "$file"
		echo "Tag added to header succesfully"
	fi
done
