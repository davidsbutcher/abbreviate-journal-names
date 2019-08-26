# Abbreviate Journal Names

Subtitute abbreviated journal names for full-length journal names in .bib or .bibtex files.

Place .bib or.bibtex files in the "input" subdirectory. All files will be loaded, checked for the presence of all full journal names in journal_abbrevs.csv, and all matches replaced with corresponding abbreviated names. Output files are saved to "output" subdirectory with "_abbreviated" appended to the file name.

Full length journal titles must be an EXACT match and will NOT be found if they are misspelled or have punctuation errors. Encoding and special characters may also be an issue but that remains to be seen.