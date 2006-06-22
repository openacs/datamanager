ad_page_contract {
    Show the list of communities where an object can be copied
    @author Jose Agustin Lopez Bueno (Agustin.Lopez@uv.es)
    @creation_date 2005-07-05
} -query {
    fn:notnull
    mtype:notnull
    msubtype:notnull
} -properties {
}

regsub -all {[\.\.]} $fn {} fn
set pos [string first "/tmp/" $fn]

if {$pos == -1} {
  set text "Invalid filename"
} else {
  if {[file exists $fn] == 0} {
    set text "Invalid filename"
  } else {
    set fd [open $fn "r"] ; set text [read $fd] ; close $fd
  }
}

ReturnHeaders "$mtype/$msubtype"
ns_write $text



