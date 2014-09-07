A python (2.7) based Lua script generator for Myo
Tested on Windows

**Commands**
* -i Specifies Template File to use, if not specified the default is used (luaTemplateSimple.lua)
* -o Specifies the filename of the generated script
* -title Specifies the Window name to activate the script on
* -waveIn Command to map to waveIn
* -waveOut Command to map to waveOut
* -fingersSpread Command to map to fingersSpread
* -fist Command to map to fist
* -h displays help
example: python generateScript.py -o Chrome.lua -title "Google Chrome" -waveOut a -waveIn b -fist c -fingersSpread d 
The above will generate a script based on the default template mapping the a,b,c,d keyboard keys to gestures when Google Chrome is active

**Notes**
* Currently only accepts lowercase keyboard keys
* special characters are not handled, must use the descriptor name found in Myo SDK docs
* The default template is a toggle to unlock method