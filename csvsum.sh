#!/usr/bin/env bash
# csvsum.sh: print the sum of every numeric column of a CSV file.
# First version: splits lines on the delimiter, so it does not understand quoted fields yet.
set -euo pipefail

delim=","
while getopts "d:" opt; do
  case $opt in
    d) delim="$OPTARG" ;;
    *) echo "usage: $0 [-d DELIM] FILE" >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))
file="${1:?usage: $0 [-d DELIM] FILE}"

awk -F"$delim" '
NR == 1 { n = NF; for (i = 1; i <= NF; i++) { name[i] = $i; sum[i] = 0; numeric[i] = 1 }; next }
{
  for (i = 1; i <= n; i++) {
    v = $i
    if (v == "") continue
    if (v ~ /^-?[0-9]+(\.[0-9]+)?$/) sum[i] += v; else numeric[i] = 0
  }
}
END { for (i = 1; i <= n; i++) if (numeric[i]) printf "%s\t%s\n", name[i], sum[i] }
' "$file"
