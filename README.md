# cheatsheet

This is a tool to create a own cheatsheet for shell commands.
It acts a bit like aliases and shell history but only as a list of the commands you stored (actually) without an execution.
> latest release version: 1.4.0<br>
> actual develop version: 1.5.0<br>

## Problem
I am now at the point where i often use commands like<br>
`$ docker system prune -a` or `$ git reset --soft HEAD^`<br>
and i don't want to google them if i need them ad hoc and don't memorize them in this moment.<br><br>
Aliases are cool, but if i start working only with aliases and someone asks me "how can i reset my commit?" - of course i can't tell him my alias. ;)<br>
The shell history is also cool, but a bit to long (even if you grep).<br>

## Solution
A tool where i can store all my used shell commands, list them, add new commands and of course also delete commands.<br><br>
So if i search e.g. for a command to stop all docker container i search in my stored commands:<br>
`$ script_cheatsheet.sh -l 'docker stop'`<br>
and i get an answer of my stored output:<br>
`//-----------------------------//`<br>
`//-------- cheatsheet  --------//`<br>
`list of greped commands:`<br>
`docker stop $(docker ps -a -q)`<br>
`//-----------------------------//`<br>

## Usage
##### script_cheatsheet.sh [-a|-l|-r|-b|-h|-v]
##### You can just run the script and...<br>
...add a command to your cheatsheet:<br>
`$ script_cheatsheet.sh -a 'git commit --amend'`<br>
...list all commands in your cheatsheet:<br>
`$ script_cheatsheet.sh -l all`<br>
...show a specific command in your cheatsheet:<br>
`$ script_cheatsheet.sh -l 'commit'`<br>
...remove a command from your cheatsheet:<br>
`$ script_cheatsheet.sh -r 'git commit --amend'`<br>
...remove all commands from your cheatsheet:<br>
`$ script_cheatsheet.sh -r all`<br>
##### Furthermore you can...<br>
...backup the cheatsheet:<br>
`$ script_cheatsheet.sh -b '[path-for-backup]'`<br>
...check the usage/help:<br>
`$ script_cheatsheet.sh -h`<br>
...check the version:<br>
`$ script_cheatsheet.sh -v`<br>

## Hint
For a better usage it would be most suitable to create an alias like<br>
`alias cheat="[path-to-script]/script_cheatsheet.sh"`<br>
so that you can run the tool like this:<br>
`$ cheat -l all`<br>

## TODO
* add release branch :heavy_check_mark:
* add "logging" to show more output of the script (to learn more about scripting) :heavy_check_mark:
* fix add/remove function (only grep of existing commands is here not the right solution)
* add posibility to make comments and also search for them (e.g: 'git commit --amend // changes the last commit')
* add posibility to execute commands or copy them from the list to the command line
* add a backup function for the cheatsheet :heavy_check_mark:
* add a import function to import an existing cheatsheet (rows from an existing cheatsheet)
* add another script for "automated tests"<br>

## P.S.
The main reason for this project for me is just to learn more about the git/github behaviour, the versioning (like semver) and also to get some more scripting skills.<br>
So if you have some interesting points, then let me know. :)<br>

## Copyright and License
Copyright :copyright: 2017 Michael Wellner ([@m1well](http://www.twitter.m1well.de))<br>
Code released under the [MIT License](/LICENSE).<br>
