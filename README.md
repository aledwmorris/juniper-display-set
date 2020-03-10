# juniper-display-set

Convert saved Juniper JunOS configuration into "display set" format, attempts to be as faithful to the Juniper CLI as possible so you can diff the output with a captured "display set" output.

Written in AWK

Usage:

./display-set.awk < show-config > show-config-pipe-display-set

Limitations:

 * doesn't support "protected" sections (yet)
