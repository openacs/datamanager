
<master>
<property name="title">Move selected objects</property>
<property name="context">@context;noquote@</property>
<br>

<p>Move objects</p><p><b>@object_name@</b></p><p>#datamanager.to#</p>

<form name="input" action="@object_url@" method="get">
<input type="hidden" name="object_id" value="@object_id@">
<input type="hidden" name="action" value="@action@">
<include src="/packages/datamanager/www/available-comm-template" object_type="@object_type@" action_type="@action@" communities_classes="communities">
</include>


<input type="submit" value="Move">
</form>



<formtemplate id="department_form"></formtemplate>

<form name="input" action="@object_url@" method="get">
<input type="hidden" name="object_id" value="@object_id@">
<input type="hidden" name="action" value="@action@">
<include src="/packages/datamanager/www/available-comm-template" object_type="@object_type@" action_type="@action@" communities_classes="classes" department_key="@department_key@">
</include>
<input type="submit" value="Move">
</form>
