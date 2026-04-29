#!/bin/bash

# Script to compile all .tex files in SITE/tex/ and clean up auxiliary files

TEX_DIR="tex"
# Note: PDF_DIR is relative to TEX_DIR after the 'cd' command
PDF_DIR="../pdfs" 

# From the project root, this is the actual path to the PDF output directory
# This is used for creating the directory and for cleaning up files
CLEAN_DIR="pdfs"

# Ensure the output directory for PDFs exists
mkdir -p "$CLEAN_DIR"

# Navigate into the TeX source directory
cd "$TEX_DIR"

# Loop through all .tex files in the current directory
for tex_file in *.tex; do
  # Get the base name of the file without the .tex extension
  base_name=$(basename "$tex_file" .tex)

  # Run xelatex, directing output to the relative PDF directory
  echo "Compiling $tex_file..."
  xelatex -output-directory="$PDF_DIR" "$tex_file"

  # Check if the compilation was successful
  if [ $? -eq 0 ]; then
    echo "$base_name.pdf created successfully in $CLEAN_DIR."
    
    # Clean up auxiliary files from the PDF output directory
    echo "Cleaning up auxiliary files for $base_name..."
    # Use -f to ignore errors if files don't exist
    rm -f "$PDF_DIR/$base_name.aux"
    rm -f "$PDF_DIR/$base_name.log"
    rm -f "$PDF_DIR/$base_name.out"
    rm -f "$PDF_DIR/$base_name.toc"
    
  else
    echo "Error compiling $tex_file. Auxiliary files will be kept for debugging."
  fi
done

# Return to the original directory
cd - > /dev/null

echo "All TeX files have been processed."
