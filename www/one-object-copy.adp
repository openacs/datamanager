
<master>
<property name="title">Copy selected objects</property>
<property name="context">@context;noquote@</property>
<br>
<p>Copy objects</p><p><b>@object_name@</b></p><p>#datamanager.to#</p>

<include src="/packages/datamanager/www/available-comm-template" object_type="@object_type@" action_type="@action@" communities_classes="communities" mode_list="@mode_list@" object_id="@object_id@" mode="@mode@">
</include>

<formtemplate id="department_form"></formtemplate>

<include src="/packages/datamanager/www/available-comm-template" object_type="@object_type@" action_type="@action@" communities_classes="classes" mode_list="@mode_list@" object_id="@object_id@" mode="@mode@" department_key=@department_key@>
</include>

