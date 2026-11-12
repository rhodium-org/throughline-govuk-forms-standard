#!/usr/bin/env bash
# Checks each conformance example against the standard: the conforming one must
# pass tl check, and each broken one must fail for the reason README.md gives.
set -u
cd "$(dirname "$0")"
fail=0

expect_pass() {  # example
  if out=$(tl -C "$1" check 2>&1); then
    echo "ok    $1 passes"
  else
    echo "FAIL  $1 should pass"; echo "$out"; fail=1
  fi
}

expect_fail() {  # example, text the failure must contain
  if out=$(tl -C "$1" check 2>&1); then
    echo "FAIL  $1 should fail with: $2"; echo "$out"; fail=1
  elif grep -qF -- "$2" <<<"$out"; then
    echo "ok    $1 fails: $2"
  else
    echo "FAIL  $1 failed, but not with: $2"; echo "$out"; fail=1
  fi
}

expect_pass full-form
expect_fail missing-if-empty  "if_empty is required when QN.answer == mandatory"
expect_fail full-stop-message "if_empty: 'Enter your full name.' is not text matching"
expect_fail no-max-length     "max_length is required when QN.component == character-count"
expect_fail unreachable-page  "needs incoming 'goes_to' link"
expect_fail dead-end          "needs incoming 'leaves' link"
expect_fail radios-no-options "needs incoming 'of' link"
expect_fail undeclared-attr   "attribute hnit is declared for QN by no attribute declaration — did you mean hint"
exit $fail
