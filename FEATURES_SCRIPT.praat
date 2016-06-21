# Extracting the audio features

form Get Features
	sentence Directory F:\Politecnico University\Semester 3 (March - July 2015)\NLP\Assignment\Dataset-test
	comment If you want to analyse all the files, leave this blank
	word Base_file_name 
	comment The name of result file 
	text textfile FEATURES.txt
endform

#Print the headers

fileappend "'textfile$'" File name'tab$'Interval name'tab$'Average Intensity'tab$'Delta Intensity'tab$'Average Pitch'tab$'delta Pitch'tab$'
fileappend "'textfile$'" 'newline$'

#Read all the files 

Create Strings as file list... wavlist 'directory$'/'base_file_name$'*.wav
Create Strings as file list... gridlist 'directory$'/'base_file_name$'*.TextGrid
n = Get number of strings


	for i to n
	
		clearinfo
		
			#Extracting the intensity and pitch tiers

		select Strings wavlist
		filename$ = Get string... i
		Read from file... 'directory$'/'filename$'
		soundname$ = selected$ ("Sound")
		To Intensity... 100 0 

		Read from file... 'directory$'/'filename$'
		soundname$ = selected$ ("Sound")
		To Pitch... 0.001 75 300
	
			#To extract all intervals by reading grid files

		select Strings gridlist
		gridname$ = Get string... i
		Read from file... 'directory$'/'gridname$'
		interval = Get number of intervals... 1
		textgrid_name$ = selected$ ("TextGrid")

			#Intensity calculation for all labelled intervals
			 	
		for k from 1 to interval
		
			select TextGrid 'textgrid_name$'
			label$ = Get label of interval... 1 'k'
			
			if (label$ <> "") and (label$ <> "#")and (label$ <> "# ")and (label$ <> "#  ")and (label$ <> "<now> ")and (label$ <> "<now>")

				#Calculating the onset and offset
				
				onset = Get starting point... 1 'k'
				offset = Get end point... 1 'k'

				#Calculating the pitch values

						select Pitch 'soundname$'
						
						min_pitch = Get minimum... onset offset Hertz Parabolic
						
						max_pitch = Get maximum... onset offset Hertz Parabolic
						
						meanPitch = Get mean... onset offset Hertz

								if min_pitch = undefined
									min_pitch = 0
									max_pitch = 0
									meanPitch = 0
								endif

						meanPitchCol [k] = meanPitch

						deltaPitch = (max_pitch - min_pitch)/(offset - onset)

						deltaPitchCol [k] = deltaPitch
						
				
				#Calculating the intensity values

						select Intensity 'soundname$'
						
						min_intensity = Get minimum... onset offset Parabolic
						
						max_intensity = Get maximum... onset offset Parabolic
						
						meanIntensity = Get mean... onset offset dB

						meanIntCol [k] = meanIntensity

						deltaIntensity = (max_intensity - min_intensity)/(offset - onset)

						deltaIntCol [k] = deltaIntensity

			else

				meanIntCol [k] = 0
				deltaIntCol [k] = 0

				meanPitchCol [k] = 0
				deltaPitchCol [k] = 0
				
			endif

		endfor

					max_meanInt = 0
					max_deltaInt = 0
					max_meanPitch = 0
					max_deltaPitch = 0
					
					min_meanInt = 0
					min_deltaInt = 0
					min_meanPitch = 0
					min_deltaPitch = 0
			

			for p from 1 to interval

				#Getting maximum and minimum values of the entire file
			
						if meanPitchCol [p] = undefined
							max_meanPitch = 0
							min_meanPitch = 0
							
						elsif meanPitchCol [p] >= max_meanPitch
								
							max_meanPitch = meanPitchCol [p]

						elsif meanPitchCol [p] < min_meanPitch

							min_meanPitch = meanPitchCol [p]
				
						endif
				
				
						if deltaPitchCol [p] = undefined
							max_deltaPitch = 0
							min_deltaPitch = 0
						
						elsif deltaPitchCol [p] >= max_deltaPitch

							max_deltaPitch = deltaPitchCol [p]

						elsif deltaPitchCol [p] < min_deltaPitch

							min_deltaPitch = deltaPitchCol [p]

						endif
						
						
				
						if meanIntCol [p] = undefined
							max_meanInt = 0
							min_meanInt = 0
							
						elsif meanIntCol [p] >= max_meanInt 

							max_meanInt = meanIntCol [p]

						elsif meanIntCol [p] < min_meanInt

							min_meanInt = meanIntCol [p]

						endif
				
				
						if deltaIntCol [p] = undefined
							max_deltaInt = 0
							min_deltaInt = 0
							
						elsif deltaIntCol [p] >= max_deltaInt

							max_deltaInt = deltaIntCol [p]

						elsif deltaIntCol [p] < min_deltaInt

							min_deltaInt = deltaIntCol [p]

						endif

	
			endfor
			

					a = max_meanInt - min_meanInt
			
						if abs(min_deltaInt) > max_deltaInt
							b = min_deltaInt
						else
							b = max_deltaInt
						endif
		
					c = max_meanPitch - min_meanPitch

						if abs(min_deltaPitch) > max_deltaPitch
							d = min_deltaPitch
						else
							d = max_deltaPitch
						endif
						

						
			for q from 1 to interval
		
				select TextGrid 'textgrid_name$'
				label$ = Get label of interval... 1 'q'

				if (label$ <> "") and (label$ <> "#")and (label$ <> "# ")and (label$ <> "#  ")and (label$ <> "<now> ")and (label$ <> "<now>")

		
					# For labels whose length is more than 8 characters the columns of it's discretized features will appear displaced

					
					if meanPitchCol [q] = undefined
						label_meanPitch$ = "UNDEFINED"
					
					elsif meanPitchCol [q] <= (min_meanInt + (0.2*c))
						label_meanPitch$ = "VERY-LOW"

					elsif meanPitchCol [q] <= (min_meanInt + (0.4*c))
						label_meanPitch$ = "LOW"

					elsif meanPitchCol [q] <= (min_meanInt + (0.6*c))
						label_meanPitch$ = "MID"

					elsif meanPitchCol [q] <= (min_meanInt + (0.8*c))
						label_meanPitch$ = "HIGH"

					elsif meanPitchCol [q] <= (min_meanInt + (c))
						label_meanPitch$ = "VERY-HIGH"
					
					endif
					
					
					if deltaPitchCol [q] = undefined
						label_deltaPitch$ = "UNDEFINED"
					
					elsif deltaPitchCol [q] <= -(0.6*d)
						label_deltaPitch$ = "VERY-NEGATIVE"

					elsif deltaPitchCol [q] <= -(0.2*d)
						label_deltaPitch$ = "NEGATIVE"

					elsif deltaPitchCol [q] <= (0.2*d)
						label_deltaPitch$ = "FLAT"

					elsif deltaPitchCol [q] <=  (0.4*d)
						label_deltaPitch$ = "POSITIVE"

					elsif deltaPitchCol [q] <=  d
						label_deltaPitch$ = "VERY-POSITIVE"
					
					endif

					if meanIntCol [q] = undefined 
						label_meanInt$ = "UNDEFINED"
					
					elsif meanIntCol [q] <= (min_meanInt + (0.2*a))
						label_meanInt$ = "VERY-LOW"

					elsif meanIntCol [q] <= (min_meanInt + (0.4*a))
						label_meanInt$ = "LOW"

					elsif meanIntCol [q] <= (min_meanInt + (0.6*a))
						label_meanInt$ = "MID"

					elsif meanIntCol [q] <= (min_meanInt + (0.8*a))
						label_meanInt$ = "HIGH"

					elsif meanIntCol [q] <= (min_meanInt + (a))
						label_meanInt$ = "VERY-HIGH"
					
					endif

					 
					if deltaIntCol [q] = undefined
						label_deltaInt$ = "UNDEFINED"
					
					elsif deltaIntCol [q] <= -(0.6*b)
						label_deltaInt$ = "VERY-NEGATIVE"

					elsif deltaIntCol [q] <= -(0.2*b)
						label_deltaInt$ = "NEGATIVE"

					elsif deltaIntCol [q] <= 0.2*b
						label_deltaInt$ = "FLAT"

					elsif deltaIntCol [q] <= 0.6*b
						label_deltaInt$ = "POSITIVE"

					elsif deltaIntCol [q] <= b
						label_deltaInt$ = "VERY-POSITIVE"
					
					endif
					
					resultline$ = "'soundname$' 'tab$' 'label$' 'tab$' 'label_meanInt$' 'tab$' 'label_deltaInt$' 'tab$' 'label_meanPitch$' 'tab$' 'label_deltaPitch$'"
						fileappend "'textfile$'" 'resultline$'
						fileappend "'textfile$'" 'newline$'


				endif

			endfor
			
			

		fileappend "'textfile$'" 'newline$'
		
	endfor

# clean up

select all
Remove