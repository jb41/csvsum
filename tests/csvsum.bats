#!/usr/bin/env bats
# Run: bats tests/   (CSVSUM can point at another implementation)

setup() {
  CSVSUM="${CSVSUM:-$BATS_TEST_DIRNAME/../csvsum.sh}"
  f="$BATS_TEST_TMPDIR/in.csv"
}

@test "sums integer columns" {
  printf 'a,b\n1,2\n3,4\n' > "$f"
  run $CSVSUM "$f"
  [ "$status" -eq 0 ]
  [ "$output" = "$(printf 'a\t4\nb\t6')" ]
}

@test "sums decimals" {
  printf 'x\n1.5\n2.25\n' > "$f"
  run $CSVSUM "$f"
  [ "$output" = "$(printf 'x\t3.75')" ]
}

@test "handles negative numbers" {
  printf 'n\n-5\n3\n' > "$f"
  run $CSVSUM "$f"
  [ "$output" = "$(printf 'n\t-2')" ]
}

@test "skips non-numeric columns" {
  printf 'name,qty\nfoo,2\nbar,3\n' > "$f"
  run $CSVSUM "$f"
  [ "$output" = "$(printf 'qty\t5')" ]
}

@test "prints zero for every column when there are no data rows" {
  printf 'a,b\n' > "$f"
  run $CSVSUM "$f"
  [ "$output" = "$(printf 'a\t0\nb\t0')" ]
}

@test "understands quoted fields with commas" {
  printf 'name,qty\n"Smith, John",2\n"Doe, Jane",3\n' > "$f"
  run $CSVSUM "$f"
  [ "$output" = "$(printf 'qty\t5')" ]
}
