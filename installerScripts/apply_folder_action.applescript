
-- which user's dropbox should we monitor
set button_returned to null
repeat while button_returned is null or button returned of button_returned is not "Accept"
	set working_folder to choose folder with prompt "Please select the USER folder whose Public dropbox you would like to monitor for incoming audio uploads" default location path to users folder as alias
	set button_returned to display dialog "Dropbox to monitor is:" & return & return & (working_folder as string) buttons {"No! choose another folder", "Accept"}
end repeat

