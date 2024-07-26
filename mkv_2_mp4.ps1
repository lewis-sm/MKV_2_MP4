# Script to Convert multiple files with handbrake, for individual movie files and series  
 # Will recurse through a folder and convert the files to mp4 with handbrake  
 # Will place them into a new location maintaining folder structure  
 # Move the original converted files to a new location  
 # Delete empty folders once files moved  
   
 # Edit paths, file types and handbrake location as required.  
   
 #Where we are looking for Files in folders  
 $search="C:\Users\HP Z600\Documents\MKV_Rips"  
   
 #Root Folder for newly created mp4 files  
 $newfolder="D:\Encoded\Video"  
   
 # Path to move completed original files to  
 $donefiles="C:\Users\HP Z600\Documents\MKV_Done"  
   
 #handbrake exe file  
 $handbrake="D:\HandbrakeCLI\handbrakecli.exe"  
   
 #file type we are working on  
 $ext="mkv"  
   
 #handbrake preset  
 $HBPreset="Normal"  
   
 #End of Edit section  
   
 #Search Paths  
 $path=$search -replace "\\","\\"  
 $donepath=$newfolder -replace "\\","\\"  
   
 #todays date  
 $date=get-date -format ddMMyy-HHmm  
 #operations log  
 $Logfile="$newfolder\$date-log.txt"  
   
 # Get directory contents
 Write-Output "Looking under - $search"
 $directorys=Get-Item -Path $search 
 
 # execute the following on each file in folder  
       foreach ($vid in $directories)  
         {  
         "Found File $vid" | out-file $logfile -append  
         #get file name and path  
         $b=$vid.Fullname  
         #create a new filename with new path and rename file with .mp4  
         $newFileName = $b -replace $path,$newfolder  
         $newFileName = $newFileName -replace "\.$ext$",".mp4"  
         "New File Name $newfilename" | out-file $logfile -append  
         get-date -format ddMMyy-HHmm | out-file $logfile -append  
         # create a log for this file  
         $HBLogfile="$newfolder\$date-$vid.name-log.txt"  
         write-host "$vid Converting to $newfilename"  
         # do the magic and convert using the present from old file to new one, write out a log of what handbrake does  

         & $handbrake --input $vid.FullName -output $newFileName --format mp4  --preset "Fast 1080p30" --all-subtitles --verbose 0 --decomb="Bob" -9 -r 29.97 --cfr 2>&1 | add-content -path $hblogfile  

         get-date -format ddMMyy-HHmm | out-file $logfile -append  
   
         #create new directory variable for file in new location path  
         $newdirectorymove=$newdirectory -replace $donepath,$donefiles  
         "Create $newdirectorymove" | out-file $logfile -append  
         #check if folder exits, if not make it  
         if ((test-path $newdirectorymove) -ne $true)  
         {  
         new-item $newdirectorymove -itemtype directory  
         }  
         #move the original file here  
         write-host "$vid - Done Movingto $newdirectorymove"  
         # move the item  
         move-item -path $vid.fullname -destination $newdirectorymove  
         $oldfile=$vid.fullname  
         if ((get-childitem $vid.directory | measure ).count -eq 0)  
           {  
           remove-item $vid.directory  
           }  
         "Moved $oldfile to $newdirectorymove"| out-file $logfile -append  
         }  
 get-date -format ddMMyy-HHmm | out-file $logfile -append  
 "----------------------" | out-file $logfile -append  
