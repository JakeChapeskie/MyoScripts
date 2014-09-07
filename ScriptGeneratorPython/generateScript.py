#Generates Scripts for Myo
#Jake Chapeskie
#2014
import argparse
DEBUG_MODE=False #Set to true for extra print outputs
def debugPrint(s):
	if DEBUG_MODE==True:
		print(s)
	return
def keyTwoMyo(key):
	#TODO: Add special character parsing
	str='myo.keyboard("'+key+'","press")'
	return str
	
# parse Command Line inputs
parser = argparse.ArgumentParser(description='Program to generate lua scripts for Myo')
parser.add_argument('-i','--inFile', help='Specifies Template File to use', required=False)
parser.add_argument('-o','--outFile', help='Specifies the filename of the generated script', required=True)
parser.add_argument('-title','--appTitle', help='Specifies the Window name to activate the script on', required=True)
parser.add_argument('-waveIn','--waveIn', help='Command to map to waveIn', required=False)
parser.add_argument('-waveOut','--waveOut', help='Command to map to waveOut', required=False)
parser.add_argument('-fingersSpread','--fingersSpread', help='Command to map to fingersSpread', required=False)
parser.add_argument('-fist','--fist', help='Command to map to fist', required=False)

args = vars(parser.parse_args())
debugPrint(args)

#set file names
if args['inFile'] == None:
    #use default Template
	print 'Using Default Template'
	inputFileName='luaTemplateSimple.lua'
else:
	inputFileName=args['inFile']	
	print 'Using Template from '+inputFileName
debugPrint('IN:'+inputFileName)

#redundant since required, might add check for .lua extension
if args['outFile'] == None:
	outFileName='luaTemplateSimple.lua'
else:
	outFileName=args['outFile']	
print 'Outputing Script to '+outFileName

#open template
file= open(inputFileName, 'r')
templateData= file.read()
tmp=templateData
file.close()

#add mappings
if args['waveIn'] != None:
   tmp=tmp.replace("--PLACEHOLDER:WAVEIN", keyTwoMyo(args['waveIn']));
if args['waveOut'] != None:
   tmp=tmp.replace("--PLACEHOLDER:WAVEOUT", keyTwoMyo(args['waveOut']));
if args['fingersSpread'] != None:
   tmp=tmp.replace("--PLACEHOLDER:FINGERSSPREAD", keyTwoMyo(args['fingersSpread']));
if args['fist'] != None:
   tmp=tmp.replace("--PLACEHOLDER:FIST", keyTwoMyo(args['fist']));
if args['appTitle'] != None:
   tmp=tmp.replace("PLACEHOLDER:TITLE", args['appTitle']);

#Clean up some script stuff
#change ScriptId
ScriptId=args['appTitle']
debugPrint(ScriptId)
tmp=tmp.replace("'com.thalmic.generated'", "'com.thalmic."+ScriptId+"'");
tmp=tmp.replace("--TEMPLATE FOR SCRIPT GENERATION, DO NOT MODIFY","")

#Any Changes to the file contents after the file write won't be applied
#write out to file
outfile=open(outFileName,'w')
outfile.write(tmp)
outfile.close()
print 'Complete'
