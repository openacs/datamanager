Read this before editing:

You are welcome to edit this specification, but please do it following the next steps:

1. This specification has been written in DocBook format, so edit the specification 
   using any xml editor you want (we use xmlmind)

2. Edit the specification version number in the imsld-spex.xml file

3. Generate the html. Note that the document has not been chunked into several files.
   Please keep this organization. We use xsltproc like this:

	xsltproc -o out_dir/ --xinclude stylesheets_dir/docbook.xsl datamanager_spec.xml (you can download the stylesheets from http://sourceforge.net/project/showfiles.php?group_id=21935&package_id=16608
	
	
4. Commit it

5. Notify the autors and the corresponding package mantainer about the changes

Thanks!!!