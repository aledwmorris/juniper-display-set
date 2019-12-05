#!/usr/bin/awk -f
function set(line) {printf "set ";for (i=0;i<depth;i++) {printf str[i]} print line}
{sub("^ *","")}
/^$/ {next}
/^#/ {next}
/; ## SECRET-DATA/ {sub("; ## SECRET-DATA","")}
/{$/ {sub("{$","");str[depth++]=$0;next}
/}$/ {depth--;next}
/];$/ {for(t=3;t<NF;t++){set($1" "$t)};next}
{sub(";$","");set($0)}
