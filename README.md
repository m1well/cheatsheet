# cheatsheet

This is a tool to create a own cheatsheet for shell commands.
It acts a bit like aliases but only as a list of the commands you stored without an execution.

## Problem
I am now at the point where i often use commands like<br>
`$ docker system prune -a` or `$ git reset --soft HEAD^`<br>
and i don't want to google them if i need them ad hoc and don't memorize them in this moment.<br><br>
Aliases are cool, but if i start working only with aliases and someone asks me "how can i reset my commit?" - of course i can't tell him my alias ;)

## Solution
A tool where i can store all my used shell commands, list them, add new commands and of course also delete commands.<br><br>
So if i search e.g. for a command to stop all docker container i search in my stored commands:<br>
`$ sh script_cheatsheet.sh -f .cheatsheet -l 'docker stop'`<br>
and i get an answer of my stored output:<br>
`//-----------------------------//`<br>
`//-------- cheatsheet  --------//`<br>
`list of greped commands:`<br>
`docker stop $(docker ps -a -q)`<br>
`//-----------------------------//`<br>

## Usage
You can just run the script and...<br>
##### ...add a command to your cheatsheet
`$ sh script_cheatsheet.sh -f .cheatsheet -a 'git commit --amend'`<br>
##### ...show all commands in your cheatsheet
`$ sh script_cheatsheet.sh -f .cheatsheet -l all`<br>
##### ...show a specific command in your cheatsheet
`$ sh script_cheatsheet.sh -f .cheatsheet -l 'commit'`<br>
##### ...remove a command from your cheatsheet
`$ sh script_cheatsheet.sh -f .cheatsheet -r 'git commit --amend'`<br>
##### ...remove all commands from your cheatsheet
`$ sh script_cheatsheet.sh -f .cheatsheet -r all`<br>
Furthermore you can...
##### ...check the usage/help
`$ sh script_cheatsheet.sh -f .cheatsheet -h`<br>
##### ...check the version
`$ sh script_cheatsheet.sh -f .cheatsheet -v`<br>

## Hint
For a better usage it would be most suitable to create an alias like<br>
`alias cheat="sh [path-to-script] -f [path-to-cheatsheet]"`<br>
so that you can run the tool like this:<br>
`$ cheat -l all`

## Copyright and License
Copyright 2017 Michael Wellner ([@m1well](http://www.twitter.m1well.de))<br>
Code released under the [MIT License](/LICENSE).<br>
