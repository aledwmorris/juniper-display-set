#!/usr/bin/awk -f
function prdepth(cmd,end) {printf("%s",cmd);for (i=0;i<end;i++) printf(" %s",str[i])}
function set(line) {
#comment out the following line if you don't want annotations in your "display set" (juniper cli omits them)
if (comment!="") {prdepth("edit",depth-1);print "";print "annotate",str[depth-1],comment;print "top";comment=""};
prdepth("set",depth);print " "line}
{sub("^ *","")}
/^$|^#/ {next}
/^\/\* / {sub("^/\\* ","\"");sub(" \\*/$","\"");comment=$0;next}
/; ## SECRET-DATA/ {sub("; ## SECRET-DATA.*$","")}
/{$/ {if ($1=="inactive:") inactive=1;s="";for (i=inactive+1;i<NF;i++) s=s" "$i;str[depth++]=substr(s,2);next}
/}$/ {if (inactive) {inactive=0;prdepth("deactivate",depth);print ""};depth--;next}
/];$/ {s=$1;for (b=2;$b!="[";b++)s=s" "$b;for(t=b+1;t<NF;t++){set(s" "$t)};next}
{sub(";$","");set($0)}
