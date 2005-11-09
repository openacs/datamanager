
<master>
<property name="title">Delete selected objects</property>
<property name="context">@context;noquote@</property>
<br>

<p>Do you really want to move to Trash <b>@object_name@</b>?</p>

<form action="@object_url@" name="faq">
  <input type="hidden" name="action" value="@action@">
  <input type="hidden" name="object_id" value="@object_id@">
  
  <blockquote>

        <input type="submit" value="Yes">

  </blockquote>
</form>
