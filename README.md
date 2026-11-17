# csvsum

A small task for coding agents: make `csvsum.sh` correct.

```
./csvsum.sh [-d DELIM] FILE
```

Prints the sum of every numeric column of a CSV file, one line per column, in header order: `<name><TAB><sum>`.

Rules:

- The first line is the header.
- A column is numeric when every non-empty value in it is a number: an optional minus sign, digits, and an optional
  fraction (`-12`, `3.75`). Empty values count as 0. Columns with any other value are not printed.
- If the file has no data rows, every column is printed with 0.
- Fields follow RFC 4180: a field may be wrapped in double quotes; a quoted field may contain the delimiter, line breaks
  and doubled quotes (`""` stands for one `"`).
- The default delimiter is `,`; `-d` sets another single character.
- The header may start with a UTF-8 byte order mark, which is not part of the first column name. Lines may end with
  `\r\n`.
- Sums are printed the way awk prints numbers: whole numbers without a fraction, otherwise up to 6 significant digits.

The current `csvsum.sh` is a naive first version. Tests: `bats tests/` (needs [bats-core](https://github.com/bats-core/bats-core)).
The provided tests do not cover every rule above.
