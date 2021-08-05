# Guidelines on the TEI Header

* This document provides clarity on the content of the various TEI Header elements, with specific reference to the Multepal Project and the paragraphs and topics editions of the *Popol Wuh*.

* NOTE: Many of these items should be created in separate TEI documents that are included using XINCLUE elements with an XPOINTER attribute to the BODY element of the target text. 


<div style="text-align:center;">
	<img src="graph.png"/>
</div>

<hr />

# Header (`teiHeader`)

## File Description (`fileDesc`)

* Contains a full bibliographical description of **the computer file itself**, from which a user of the text could derive a proper bibliographic citation, or which a librarian or archivist could use in creating a catalogue entry recording its presence within a library or archive. 
* The term computer file here is to be understood as referring to **the whole entity or document described by the header**, even when this is stored in several distinct operating system files. The file description also includes information about the source or sources from which the electronic document was derived. 

### Title Statement (`titleStmnt`)

#### Title (`title`)

* Should reflect the scope of the digital text, i.e. **Popol Wuh**

#### Author (`author`)

* Not Ximenez, etc. &mdash; this is the authors of the digital text, e.g. the Multepal team.

#### Responsibility Statement (`respStmt`) +

* Each contains `resp`, `name`, and `note`, one for each person. `resp` is a coded name for the work performed, e.g. *transcription*, *modeling*, *annotation*, *cleaning*, etc.

### Source Description (`sourcDesc`)

* Describe the original manuscript
* Describe the manuscript as held at the Newberry, i.e. as divided up into three parts.

### Edition (`edition`)

* Describe Paragaraphs and Topics, the editorial thought process behind the content model.

### Publication (`publication`)

* Describe the hosting on GitHub
* Should NOT be the Newberry. That should go in the Source Description.

## Encoding Description (`encodingDesc`)

*  Describe **the relationship between an electronic text and its source or sources.** This is the actual methods chosen to represent the text digital, i.e. to encode it in TEI.

* Also how the text was normalized during transcription, how the encoders resolved ambiguities in the source, what levels of encoding or analysis were applied, and similar matters, etc. These go in `editorialDecl`.

### Project Description (`projectDesc`)

* Describe the Multepal Project here.

### Editorial Declaration (`editorialDecl`)

* Details of editorial principles and practices applied during the encoding of a tex

### References Declaration (`refsDecl`)

* Describe schema for how **canonical references** are constructed for this text.
* Crucial for annotations as well as CTS.

### Class Declaration (`classDecl`)

* Describe the taxonomies defining any classificatory codes used elsewhere in the text
* This includes the TOPICS uses in `rs@ana` values.

## Profile Description (`profileDesc`)

* Contains **classificatory and contextual information** about the digital text, such as its subject matter, the situation in which it was produced, the individuals described by or participating in producing it, and so forth. 
  * Describe the form and content of the text, including the languages (`language`) and scripts it usess.
* The text profile is useful for any form of automatic text processing.

## Revision Description (`revisionDesc`)

* A history of changes made during the development of the electronic text. 
* Important for version control and for resolving questions about the history of a file.
* Use one or more `change` elements with dates and descriptions of things done. Should go back to acquisition of OSU PDF and it's initial conversion and shaping, up to the current modifications.

<!--
2. Outline:
	1. teiHeader
		1. fileDesc
			1. title
			2. sourceDesc
			3. edition
			4. publication
		2. encodingDesc
			1. Information how the text was encoded from the source
		3. profileDesc
		4. revisionDesc
-->