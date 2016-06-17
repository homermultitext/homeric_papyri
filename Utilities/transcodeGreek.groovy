/*
To transcode Greek from one character representation to another, put the
Epidoc transcoding transformer on your classpath and use its
getString() method


Usage: to run the script while adding transcoder.jar to your classpath
on the command line:
groovy -classpath ./lib/transcoder.jar:$CLASSPATH transcodeGreek.groovy 

*/


// Import transcoder :
import edu.unc.epidoc.transcoder.TransCoder


//After creating transcoder object, set its parser (the 'from'
// encoding) and converter (the 'to' encoding):
TransCoder tc = new TransCoder()
tc.setParser("BetaCode")
tc.setConverter("UnicodeC")

TransCoder reverseCoder = new TransCoder()
// NOTICE THE DIFFERENT NAME USED FOR Unicode PARSER
// BUT UnicodeC CONVERTER!
reverseCoder.setParser("Unicode")
reverseCoder.setConverter("BetaCode")

// let's convert a string
def betaString = "*mh=nin a)/eide, qea/"
def utf8String = tc.getString(betaString)

// And display the results:
def message = """
Convert beta to UnicodeC:
${betaString}  -> ${utf8String}

And reversed:
${utf8String} -> ${reverseCoder.getString(utf8String)}

Reversed wtih beta code lower cased:
${utf8String} -> ${reverseCoder.getString(utf8String).toLowerCase()}
"""

OutputStreamWriter osw = new OutputStreamWriter(System.out, "UTF-8")
osw.write message
osw.close()
