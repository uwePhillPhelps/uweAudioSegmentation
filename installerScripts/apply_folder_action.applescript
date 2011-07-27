
-- which user's dropbox should we monitor
set button_returned to null
repeat while button_returned is null or button returned of button_returned is not "Accept"
	set working_folder to choose folder with prompt "Please select the USER folder whose public dropbox should " & return & " be monitored for incoming audio uploads" default location path to users folder as alias
	
	set working_folder to working_folder as string
	set working_folder to working_folder & "Public:Drop Box:"
	
	if exists alias working_folder of application "Finder" then
		set button_returned to display dialog "The path to monitor is:" & return & (working_folder as string) & return & return & "Is this correct?" buttons {"No, I want to choose another folder", "Accept"}
	else
		display dialog "The USER folder you selected does not contain a public drop box" buttons {"Oops, I'll select another folder"}
	end if
end repeat


