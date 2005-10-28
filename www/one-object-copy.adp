
<master>
<property name="title"><# Copy#></property>
<property name="context">@context;noquote@</property>
<br>
<p>Copy objects</p><p><b>@object_name@</b></p><p>#datamanager.to#</p>


<if @communities:rowcount@ eq 0>
    <p>#datamanager.Sorry#
</if>
<else>

<if @mode@ not nil>
    Current copy mode is <b>@mode@</b>
</if>

<listtemplate name="available_communities"></listtemplate>
</else>


