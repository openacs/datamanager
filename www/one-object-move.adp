
<master>
<property name="title"><# Move#></property>
<property name="context">@context;noquote@</property>
<br>

<p>Move objects</p><p><b>@object_name@</b></p><p>#datamanager.to#</p>

<form name="input" action="@object_url@" method="get">
<input type="hidden" name="object_id" value="@object_id@">
<input type="hidden" name="action" value="@action@">

<if @communities:rowcount@ eq 0>
    <p>#datamanager.Sorry#
</if>
<else>
<listtemplate name="available_communities"></listtemplate>
<p></p>
<input type="submit" value="<#Move#>">
</else>

</form>
