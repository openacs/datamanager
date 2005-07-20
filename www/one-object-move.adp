
<master>
<property name="title"><# Move#></property>
<property name="context">@context;noquote@</property>
<br>

<p> #datamanager.Move_1# <b>@object_name@</b> #datamanager.to#</p>

<form name="input" action="@move_object_url@" method="get">
<input type="hidden" name="object_id" value="@object_id@">
<if @communities:rowcount@ eq 0>
    <p>#datamanager.Sorry#
</if>
<else>
<listtemplate name="available_communities"></listtemplate>
<p></p>
<input type="submit" value="<#Move#>">
</else>

</form>
