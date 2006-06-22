
<master>
<property name="title">#datamanager.pretty_name#: #datamanager.Select_Objects#</property>


<if @object_type@ eq "album">
<H4>#datamanager.folders_list#</H4>
<listtemplate name="usable_objects2"></listtemplate>
<H4>#datamanager.albums_list#</H4>
<listtemplate name="usable_objects"></listtemplate>
</if>
<else>
<listtemplate name="usable_objects"></listtemplate>
</else>
<CENTER><A HREF="index.tcl">#datamanager.return_to_index#</A></CENTER>


