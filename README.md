# cheatsheet

This is a tool to create a own cheatsheet for shell commands.<br>
It acts a bit like aliases and shell history -> a list of commands you stored with execution.<br>
<br>
Take a quick look at my dotfiles to see how my acutal public .cheatsheet file looks like.<br>
source: [.cheatsheet](https://github.com/m1well/dotfiles/blob/master/.cheatsheet)<br>


## Problem
I am now at the point where i often use commands like<br>
`$ docker system prune -a` or `$ git reset --soft HEAD^`<br>
and i don't want to google them if i need them ad hoc and don't memorize them in this moment.<br><br>
Aliases are cool, but if i start working only with aliases and someone asks me "how can i reset my commit?" - of course i can't tell him my alias. ;)<br>
The shell history is also cool, but a bit to long (even if you grep).<br>
So therefore i was thinking about to combine these functions into one tool.<br>


## Solution
<pre>
A tool where i can store all my recently used shell commands, list them,
execute them, add new commands (append a comment if i want) and of course also delete them.
</pre>
So if i am looking e.g. for a command to enter a running docker container - i search in my stored commands:
`$ script_cheatsheet.sh -l docker exec`
and i get an answer of my stored output:<br>
<pre>
//-----------------------------//
//-------- cheatsheet  --------//
list of greped commands (with line number)
01: docker exec -it {1} /bin/bash # enter running docker container
//-----------------------------//</pre>

## Usage
#### script_cheatsheet.sh [-a|-l|-e|-r|-b|-i|-h|-v]
lets say we actually have following cheatsheet (the commands are simple just to understand the principles):
<pre>
//-----------------------------//
//-------- cheatsheet  --------//
list of all commands (with line number)
01:  git add . # add all untracked files
02:  git commit -m "{1}" # commit with a given message
03:  git push origin --force-with-lease # push origin force-with-lease
//-----------------------------//</pre>

#### You can just run the script and...<br>

##### ...add a command to your cheatsheet:<br>
`$ script_cheatsheet.sh -a 'git status'`<br>
the result would be the same list as above with an additional line for `git status`:<br>
<pre>
01:  git add . # add all untracked files
02:  git commit -m "{1}" # commit with a given message
03:  git push origin --force-with-lease # push origin force-with-lease
04:  git status
</pre>

##### ...list all commands in your cheatsheet:<br>
`$ script_cheatsheet.sh -l all`<br>
this would be the same result as the starting list plus the new `git status` command<br>

##### ...show/grep a specific command in your cheatsheet:<br>
`$ script_cheatsheet.sh -l 'commit'`<br>
result would be:<br>
<pre>
//-----------------------------//
//-------- cheatsheet  --------//
list of greped commands (with line number)
02:  git commit -m "{1}" # commit with a given message
//-----------------------------//
</pre>

##### ...execute a command by linenumber:<br>
`$ script_cheatsheet.sh -e 4`<br>
The fourth command `git status` is going to be executed (and shows the status of your current git repo).<br>

##### ...execute a command by linenumber with one additional parameter:<br>
`$ script_cheatsheet.sh -e 2,'this is a message for my commit'`<br>
Then the third command `git commit -m "{1}"` is going to be executed.<br>
Here the additional parameter enables you to put an individual message to the commit.<br>
The result would be the following lines (with the possible output of the execution)<br>
<pre>
//-----------------------------//
//-------- cheatsheet  --------//
now executing following command (possible output below cheatsheet endline)
$ git commit -m "{1}" # commit with a given message
//-----------------------------//
[execution-function 31abc5b] this is a message for my commit
 2 files changed, 15 insertions(+), 15 deletions(-)
</pre>

##### ...remove a command by linenumber from your cheatsheet:<br>
`$ script_cheatsheet.sh -r 1`<br>
the result would be following:<br>
<pre>
//-----------------------------//
//-------- cheatsheet  --------//
successfully removed following command from the cheatsheet
git add . # add all untracked files
//-----------------------------//
</pre>

##### ...remove all commands from your cheatsheet:<br>
`$ script_cheatsheet.sh -r all`<br>
This deletes the whole cheatsheet file.<br>

#### Furthermore you can...<br>

##### ...backup the cheatsheet:
`$ script_cheatsheet.sh -b '[path-for-backup]'`

##### ...import commands from a cheatsheet backup:<br>
`$ script_cheatsheet.sh -i '[path-to-backup]'`<br>

##### ...check the usage/help:<br>
`$ script_cheatsheet.sh -h`<br>

##### ...check the version:<br>
`$ script_cheatsheet.sh -v`<br>


## Environment Info
##### unix
I am not so familiar with all different unix shells, but i think u can use it with all standard shells<br>
##### windows
For windows i take the gitBash shell to use the cheatsheet<br>


## Hint
Actually backslashes in commands are not allowed!! (due to bad display of them)<br>
Don't use a '-' at first character to search a command! (becaus grep think it is a new option) and to add a command.<br>
For a better usage it would be most suitable to create an alias like<br>
`alias cheat="[path-to-script]/script_cheatsheet.sh"`<br>
so that you can run the tool like this:<br>
`$ cheat -l all`<br>


## Contribution
You are welcome to contribute this project! Please follow the standard rules.<br>
If you find a bug or have an idea for improvement, then please firstly open an issue.<br>
If you are creating a Pull Request, please update the version & date of last change in the script - and use [SemVer](http://semver.org).<br>
Also please take care to indent with 3 spaces.<br>
Thank you.<br>


## TODO
* [x] add release branch<br>
* [x] add posibility to execute commands<br>
* [x] add a backup function for the cheatsheet<br>
* [x] add a import function to import an existing cheatsheet (rows from an existing cheatsheet)<br>
* [x] add posibility to make comments (and test it) and also search for them (e.g: 'git commit --amend # changes the last commit')<br>
* [ ] improve the export/import to work with different lists<br>
* [ ] add another script for "automated tests"<br>

## P.S.
The main reason for this project for me is just to learn more about the git/github behaviour, the versioning (like semver) and also to get some more scripting skills.<br>
So if you have some interesting points, then let me know. :)<br>


## Copyright and License
Copyright :copyright: 2017 Michael Wellner ([@m1well](http://www.twitter.m1well.de))<br>
Code released under the [MIT License](/LICENSE).<br>
