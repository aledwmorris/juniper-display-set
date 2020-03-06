#!/usr/bin/awk -f
function prdepth(cmd,end) {printf("%s",cmd);for (i=0;i<end;i++) printf(" %s",str[i])}
function cmd(verb,line) {
#comment out the following line if you don't want annotations in your "display set" (juniper cli omits them)
    if (comment!="") {prdepth("edit",depth-1);print "";print "annotate",str[depth-1],comment;print "top";comment=""};
    prdepth(verb,depth);print " "line}
{sub("^ *","")}
/^$|^#/ {next}
/^\/\* / {sub("^/\\* ","\"");sub(" \\*/$","\"");comment=$0;next}
/; ## SECRET-DATA/ {sub("; ## SECRET-DATA.*$","")}
/{$/ {i=1;if ($1=="inactive:") {inactive=depth+1;i=2}s="";for (;i<NF;i++) s=s" "$i;str[depth++]=substr(s,2);next}
/}$/ {if (inactive==depth) {prdepth("deactivate",inactive);print "";inactive=-1}depth--;next}
/];$/ {s=$1;b=2;if ($1=="inactive:") {s=$2;b=3}for (;$b!="[";b++)s=s" "$b;for(t=b+1;t<NF;t++){cmd("set",s" "$t)};
       if ($1=="inactive:") cmd("deactivate",s);next}
{sub(";$","");if ($1=="inactive:") {cmd("set",substr($0,11));cmd("deactivate",substr($0,11))} else cmd("set",$0)}
