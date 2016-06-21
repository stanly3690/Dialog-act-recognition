# saving the DialogAct associated to each token

		form Get Dialogue Acts
			sentence Directory F:\Politecnico University\Semester 3 (March - July 2015)\NLP\Assignment\Dataset-test
			comment If you want to analyze all the files, leave this blank
			word Base_file_name 
			comment The name of result file 
			text textfile DIALOGUE-ACTS.txt
		endform

		#Print one set of headers

		fileappend "'textfile$'" File name'tab$'Interval name'tab$'DialogueAct'tab$'
		fileappend "'textfile$'" 'newline$'

		#Read all files in a folder
		
		Create Strings as file list... wavlist 'directory$'/'base_file_name$'*.wav
		Create Strings as file list... gridlist 'directory$'/'base_file_name$'*.TextGrid
		n = Get number of strings


			for i to n
			
				clearinfo


	
				# Extract all the DialogueActs by reading the grid files

					select Strings gridlist
					gridname$ = Get string... i
					Read from file... 'directory$'/'gridname$'
					int2=Get number of intervals... 2
					
					
				# Extract all the intervals by reading the grid files

					int=Get number of intervals... 1
					textgrid_name$ = selected$ ("TextGrid")

					
				# Getting the initial and finishing time of each Dialogue Act label

						for m from 1 to 'int2'
						select TextGrid 'textgrid_name$'
							dialAct_label$ = Get label of interval... 2 'm'
								
								# calculates the Tmin and Tmax
								t_min[m] = Get starting point... 2 'm'
								t_max[m] = Get end point... 2 'm'
						
						endfor

				# Checking the Dialogue Act for all labeled intervals

					dial_Act_prev$="kkk"
					
					for k from 1 to 'int'
						select TextGrid 'textgrid_name$'
						label$ = Get label of interval... 1 'k'

						# If the label is composed by 8 or more characters the Dialogue Act will be shifted in the document
	
							if (label$ <> "") and (label$ <> "#")and (label$ <> "# ")and (label$ <> "#  ")and (label$ <> "<now> ")and (label$ <> "<now>")

								# calculates the onset and offset
						
									onset = Get starting point... 1 'k'
									offset = Get end point... 1 'k'
						
						
								# 20% of tolerance
						
									tolerance= (offset-onset)/5 
		
								for p from 1 to 'int2'
								
									a= t_min[p]
									b= t_max[p]
			
									# Checks if it is inside the labeled Dialogue Act

										if (onset >= a-tolerance) and (offset <= b+tolerance)
								
											select TextGrid 'textgrid_name$'
											dial_Act$ = Get label of interval... 2 'p'
								
											if (dial_Act_prev$<>dial_Act$) and (dial_Act_prev$<>"kkk")

												fileappend "'textfile$'" 'newline$'
												fileappend "'textfile$'" 'newline$'

											endif
				
											resultline$ = "'textgrid_name$''tab$''label$''tab$''dial_Act$'"
											fileappend "'textfile$'" 'resultline$'
											fileappend "'textfile$'" 'newline$'
						
										endif

								endfor
						
						
								dial_Act_prev$=dial_Act$

		
							endif
					endfor

				fileappend "'textfile$'" 'newline$'
				fileappend "'textfile$'" 'newline$'
				
			endfor

		# clean up

		select all
		Remove