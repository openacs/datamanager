
<master>
<property name="title">#datamanager.export_selected_objects#</property>
<property name="context">@context;noquote@</property>


<CENTER><H2>#datamanager.results#</H2></CENTER>

<HR>
<A HREF="file_dump?mtype=text&msubtype=plain&fn=@fn_xml_output@">#datamanager.view#</A> /
<A HREF="file_dump?mtype=text&msubtype=dump&fn=@fn_xml_output@">#datamanager.dump#</A> 
#datamanager.exported_file#
<HR>
<%
foreach linea $results {
  adp_puts "$linea<BR>"
}
%>

<HR>
<CENTER><A HREF="index.tcl">#datamanager.return_to_index#</A></CENTER>




