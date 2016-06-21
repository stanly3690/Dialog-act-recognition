# Extracting the tokens

		form Get Tokens
		
			sentence Directory F:\Politecnico University\Semester 3 (March - July 2015)\NLP\Assignment\Dataset-test
			comment If you want to analyse all the files, leave this blank
			word Base_file_name 
			comment The name of result file 
			text textfile TEXT.txt
			
		endform
			

			#Read all files in a folder
			
				clearinfo
				
				Create Strings as file list... gridlist 'directory$'/'base_file_name$'*.TextGrid
				number_of_files = Get number of strings

			for x to number_of_files
			
					select Strings gridlist
					current_file$ = Get string... x
					printline 'current_file$'
					fileappend "'textfile$'" 'current_file$''tab$'
					fileappend "'textfile$'" 'newline$'
					Read from file... 'directory$'/'current_file$'
					
					textgridID = selected ("TextGrid")
					select textgridID
					numintervals = Get number of intervals... 1
		
						for curint to numintervals
						
							select textgridID		
							label$ = Get label of interval... 1 'curint'
							
								if (label$ <> "") and (label$ <> "#")and (label$ <> "# ")and (label$ <> "#  ")and (label$ <> "<now> ")and (label$ <> "<now>")
								
									resultline$ = "'label$''tab$'"
									fileappend "'textfile$'" 'resultline$'
							
								endif
							
						endfor
		
					fileappend "'textfile$'" 'newline$'
					fileappend "'textfile$'" 'newline$'
				
			endfor
			

		# clean up
		select Strings gridlist
		Remove