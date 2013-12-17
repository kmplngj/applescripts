tell application "Things"
	set _projectlist to every project's name
	set _workproject to my choosefromList(_projectlist, "Choose which Things project you want to export to Reminders")
	my exportThingsProjets(_workproject)
end tell


on exportThingsProjets(_project)
	tell application "Things"
		
		set _projectlist to _project
		
		set _items to every to do of project _projectlist
		
		repeat with _todo in _items
			
			set _name to name of _todo
			set _note to notes of _todo
			set _duedate to due date of _todo
			set _status to status of _todo as string
			tag names of _todo as string
			_status
			
			tell application "Reminders"
				#set or create list
				try
					set mylist to list _projectlist
				on error
					set mylist to make new list with properties {name:_projectlist}
				end try
				
				tell mylist
					#delete old reminders in list 
					#delete (every reminder whose name is name of _todo)
					
					if _status is "open" then
						
						if _duedate is not missing value then
							make new reminder with properties {name:name of _todo, body:_note, due date:_duedate, remind me date:_duedate}
						else
							make new reminder with properties {name:name of _todo, body:_note}
						end if
						
					end if #_status is "open"
					
				end tell #tell list
			end tell
			
		end repeat
		
	end tell
end exportThingsProjets

on convertTags(_tags)
	set _returntext to ""
	
	repeat with i from 1 to count of _tags by 1
		set _item to item _counter of _tags
		set _returntext to "#" & name of item i of _tags & _returntext
		set _counter to _counter + 1
	end repeat
	
	return _returntext
	
end convertTags

on stringToList(theString, myDelimiters)
	tell AppleScript
		if theString contains myDelimiters then
			set theSavedDelimiters to AppleScript's text item delimiters
			set text item delimiters to myDelimiters
			set outList to text items of theString
			set text item delimiters to theSavedDelimiters
			return outList
		else
			return {theString}
		end if
	end tell
end stringToList

on choosefromList(mylist, myPrompttext)
	choose from list mylist with title myPrompttext
	set myResult to result as string
	return myResult
end choosefromList