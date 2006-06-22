
<master>
<property name="title">#datamanager.Copy_checked_items#</property>
<property name="context">@context;noquote@</property>
<br>
<!-- <P>El object type es: @object_type@ -->

<p>#datamanager.Copy_Objects#</p><p><b>@object_name@</b></p><p>#datamanager.to#</p>

<include src="/packages/datamanager/www/available-comm-template" object_type="@object_type@" action_type="@action@" communities_classes="communities" mode_list="@mode_list;noquote@" object_id="@object_id@" mode="@mode@">
</include>
<BR><BR>
<formtemplate id="department_form"></formtemplate>

<include src="/packages/datamanager/www/available-comm-template" object_type="@object_type@" action_type="@action@" communities_classes="classes" mode_list="@mode_list;noquote@" object_id="@object_id@" mode="@mode@" department_key="@department_key@">
</include>

<CENTER><A HREF="index.tcl">#datamanager.return_to_index#</A></CENTER>

