
<master>
<property name="title"><# Copy#></property>
<property name="context">@context;noquote@</property>
<br>

<p>Copy <b>@object_name@</b> to</p>

<if @communities:rowcount@ eq 0>
    <p>#datamanager.Sorry#
</if>
<else>
<listtemplate name="available_communities"></listtemplate>
</else>


