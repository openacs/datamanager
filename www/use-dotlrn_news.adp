
<master>
<property name="title">#datamanager.pretty_name#</property>

<H2>#datamanager.optional_sufix#:</h2><BR>

<FORM ACTION="use-dotlrn_news2" METHOD="post">
#datamanager.sufix# 
<INPUT TYPE="text"   NAME="sufix"             VALUE="">
<INPUT TYPE="hidden" NAME="object_id"         VALUE="@object_id@">
<INPUT TYPE="hidden" NAME="action"            VALUE="@action@">
<INPUT TYPE="hidden" NAME="dest_community_id" VALUE="@dest_community_id@">
<INPUT TYPE="submit" VALUE="#datamanager.set#">
</FORM> 

<CENTER><A HREF="index.tcl">#datamanager.return_to_index#</A></CENTER>
