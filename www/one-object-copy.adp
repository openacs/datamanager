
<master>
<property name="title"><# Copy#></property>
<property name="context">@context;noquote@</property>
<br>

<p>Copy <b>@object_name@</b> to</p>

<form name="input" action="@object_url@" method="get">
<input type="hidden" name="action" value="@action@">
<input type="hidden" name="object_id" value="@object_id@">
<if @communities:rowcount@ eq 0>
    <p>#datamanager.Sorry#
</if>
<else>
<listtemplate name="available_communities"></listtemplate>
<p></p>
<input type="submit" value="Copy">
</else>

</form>
