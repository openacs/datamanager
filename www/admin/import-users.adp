
<master>
<property name="title">#datamanager.import_selected_users#</property>

<CENTER><H2>#datamanager.results#</H2></CENTER>

<HR>
<%
foreach linea $results {
  adp_puts "$linea<BR>"
}
%>

<HR>
<CENTER><A HREF="index.tcl">#datamanager.return_to_index#</A></CENTER>



