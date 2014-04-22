pro write_class_fits_dump, list_file $
                           , class_file = class_file $
                           , skip_day = skip_day

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; SET DEFAULTS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if n_elements(class_file) eq 0 then class_file = 'write_to_fits.class'

  if n_elements(skip_day) eq 0 then skip_day = ''
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&% 
; WE ARE JUST WRITING FROM COLUMN 1 + COLUMN 2 TO COLUMN 3
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; READ THE DATA FILE. FORMAT IN THIS CASE: DIRECTORY INPUT OUTPUT
  readcol, list_file, format='A,A,A' $
           , directory, input_file, output_file

; PROCESS STRINGS ASSUMING OUR STANDARD DIRECTORY STRUCTURE
  directory = '../'+strcompress(directory, /remove_all)+'/raw/'
  input_file = strcompress(input_file, /remove_all)
  output_file = strcompress(output_file, /remove_all)+'.fits'
  
; OPEN A TEXT FILE
  get_lun, u
  openw, u, class_file

; GET THE TIME
  spawn, 'date', date

; SHORT HEADER FOR THE CLASS FILE
  printf,u, '! generated by write_class_fits_dump (IDL) on ' + date
  printf,u, '! script to convert reduced .30m data to binary .fits tables'

; LOOP OVER FILES AND WRITE A COMMAND FOR EACH
  for i = 0, n_elements(input_file)-1 do begin
     line = '@ ../../class/write_fits_spec '
     line += directory[i]+input_file[i]
     line += ' '
     line += directory[i]+output_file[i]
     printf,u,line        
  endfor

  printf,u,'exit'

; CLOSE THE TEXT FILE
  close,u
  free_lun, u
  
  return

end                             ; of write_class_fits_dump