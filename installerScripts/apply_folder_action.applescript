(*
installs a custom folder action, chooses a particular user's dropbox, then applies
*)

--	*****************************************************
--	find paths for source files, and paths for the installation destination

-- find the folder that this script is in
tell application "Finder" to set thisFolder to folder of (path to me)

-- find /Library/Scripts/
set libraryScripts to (path to library folder as string) & "Scripts:"
set libraryScripts to libraryScripts as alias

-- find /Library/Scripts/Folder Action Scripts/ (where we'll put our custom action)
set libraryFolderActionScripts to (systemScripts as string) & "Folder Action Scripts"
set libraryFolderActionScripts to libraryFolderActionScripts as alias

-- debug
choose folder with prompt "just checking" default location libraryFolderActionScripts


--	*****************************************************
-- 	copy script files
tell application "Finder"
	-- find the folderActionScripts source folder
	set sourceFolder to folder of thisFolder
	set sourceFolder to (path to sourceFolder as string) & "folderActionScripts:"
	set sourceFolder to sourceFolder as alias
	
	duplicate contents of folder sourceFolder to folder systemFolderActionScripts
end tell

--	*****************************************************
--	enable folder actions
tell application "System Events" to set folder actions enabled to true

--	*****************************************************
--	which user's dropbox should we monitor?
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
	
	-- working_folder should be an alias
	set working_folder to working_folder as alias
end repeat

--	*****************************************************
--	find script to apply
set scriptToApply to (path to libraryFolderActionScripts as string) & "uwe - dropbox new item alert.scpt"
set scriptToApply to scriptToApply as alias

-- debug
display dialog " " & scriptToApply

--	*****************************************************
--	prepare target folder
set TargetFolder to working_folder as text
tell application "Finder" to Â
	set FAName to name of alias TargetFolder
tell application "System Events"
	if folder action FAName exists then
		--Don't make a new one
	else
		make new folder action Â
			at end of folder actions Â
			with properties {path:TargetFolder} -- name:FAName, 
	end if
end tell

--	*****************************************************
--	apply folder action
set EachItem to scriptToApply
set ItemInfo to info for EachItem
if not folder of ItemInfo then
	set FileTypeOfItem to file type of ItemInfo
	set FileExtensionOfItem to name extension of ItemInfo
	set ItemName to name of ItemInfo
	if FileTypeOfItem is "osas" or FileExtensionOfItem is "scpt" then
		tell application "System Events"
			tell folder action FAName
				make new script Â
					at end of scripts Â
					with properties {name:ItemName}
			end tell
		end tell
	else
		display dialog ItemName & ErrorMsg with icon caution
	end if
end if
