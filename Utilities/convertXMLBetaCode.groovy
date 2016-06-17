/*
	convertXMLBetaCode.groovy:  a groovy script to copy an XML document
	while converting beta code Greek to Unicode-C Greek.

	usage: transcoder jar must be on your classpath; near the beginning of
	the script, set the value of fName to point to the file you want to convert.
	Then just run 	
	     groovy convertXMLBetaCode.groovy


	Algorithm: walks the DOM of a TEI document or other XML document keeping 
	track of language values on a @lang attribute. 
	When @lang = 'grc', converts  text nodes from beta code to 
	Unicode-C Greek.
	
	Be careful to write output to an appropriately configured output stream so
	you really get UTF8.

	NB:  this script works recursively from the root element on down. It does
	NOT replicate any XML declaration, declaration of DTD, Relax NG schema, aut sim.
*/

// Remember to put the transcoder jar on your classpath!
import edu.unc.epidoc.transcoder.*

import org.w3c.dom.Node
import org.w3c.dom.Element
import org.w3c.dom.Attr
import org.w3c.dom.NamedNodeMap


if (args.length != 1) {
   println "Usage:  groovy convertXMLBetaCode.groovy <FILENAME>\n"
   System.exit(0)
}


def fName = args[0]


// BEGINNING OF SCRIPT ACTIONS:
// create XML document and BetaConverter objects
def doc = groovy.xml.DOMBuilder.parse(new FileReader(fName))
def root = doc.getDocumentElement()
def converter = new BetaConverter()

// Wrap system.out in utf8-ified outputstreamwriter, and include this in
// call to checkNode:
OutputStreamWriter outputStreamWriter = new OutputStreamWriter(System.out, "UTF-8")
checkNode(root, converter, outputStreamWriter, "")
outputStreamWriter.close();
// END OF SCRIPT



/**
* Creates String of name='value' patterns from the
* attributes of an Element.
* param e The Element with attributes.
* returns A String to include within the opening tag of an element.
*/
String collectAttrs(Element e) {
    NamedNodeMap attrs = e.getAttributes();
    String concatenated = ""
    // Get number of attributes in the element
    int numAttrs = attrs.getLength();
    
    // Process each attribute
      int i = 0
      while (i < numAttrs) {
        Attr attr = (Attr)attrs.item(i);
	concatenated = concatenated + " " +  attr.getNodeName() + "='" +attr.getNodeValue() + "'";
	i++
    }
    return(concatenated)
}



/**
*/
def checkNode(Node n, BetaConverter conv, OutputStreamWriter osw, String lang) {
        boolean closeMe = false

       switch (n.nodeType) {
       case Node.ELEMENT_NODE:
       	    osw.write( "<" + n.nodeName + " " + collectAttrs(n) )
	    if  (n.hasAttribute("lang")) {
	    //	    conv.setLang(n.getAttribute("lang"))
	    lang = n.getAttribute("lang")
	    }
	    if (n.childNodes.getLength() > 0) {
	    osw.write(">")
	    closeMe = true
	    } else {
	    osw.write("/>")
	    }
	    break

       case Node.TEXT_NODE:
//           if (conv.currentLang == "grc") {
           if (lang == "grc") {
	   osw.write(conv.tc.getString(n.nodeValue))
	   } else {
	   if (n.nodeValue) {       	    osw.write( n.nodeValue) }
	   }
	   break

	otherwise
		// do nothing
       }

     n.getChildNodes().each { kid -> checkNode(kid,conv,osw,lang)  }
     if (closeMe) { osw.write("</" + n.nodeName + ">") }
}


/**
*	Object for converting beta code Greek to Unicode-C.
*/
class BetaConverter {
      /**
      * The transcoder object
      */
      TransCoder tc 
      /**
      * Value of currently applicable @lang attribute.
      */
      String currentLang = "none"

      /** Constructor initializes transcoder object.
      */
      BetaConverter() {
       tc = new TransCoder()
       tc.setParser("BetaCode");
       tc.setConverter("UnicodeC");
      }

      /** Transcodes a string or not, depending on
      * value of the currentLang setting.
      * param s The String to convert.
      * returns A transcoded String if our lang setting is "grc"
      */
      String convert(String s) {
      if (currentLang == "grc") {
      	 return(tc.getString(s))
	} else {
	return(s)
	}
      }

      /** Sets value of currentLang.
      * param lang New value to use for currentLang.
      */
      void setLang(String lang) {
      currentLang = lang
      }
}// BetaConverter


