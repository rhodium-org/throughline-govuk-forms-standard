# Conformance examples

Each directory here is a small form spec that names this standard as its schema
source (`path = "../.."`, `schema = true`). The service, registering a boat on the
Avonmere Canal, is fictional.

The conforming example must pass `tl check`. Each broken one must fail it with
exactly one error, for the reason below.

| Example | Expected result | Why |
|---|---|---|
| `full-form` | passes | start page; text-input, date-input, radios with a conditional reveal, checkboxes with an exclusive "None of these", an optional character-count; a branch on a radio option to a cannot-continue page; check answers; confirmation |
| `missing-if-empty` | fails | a mandatory question with no `if_empty` (ATTR-0016, `required_when QN.answer == mandatory`) |
| `full-stop-message` | fails | an error message ending in a full stop (TYPE-0007's pattern) |
| `no-max-length` | fails | a character-count question with no `max_length` (ATTR-0021) |
| `unreachable-page` | fails | a page that no route goes to (coverage: `incoming:goes_to`) |
| `dead-end` | fails | a question page with no route out (coverage: `incoming:leaves`) |
| `radios-no-options` | fails | a radios question with no options (coverage: `incoming:of`) |
| `undeclared-attr` | fails | a question attribute misspelled `hnit`, which gets a did-you-mean `hint` hint |

`check.sh` runs every example and is a step of CI.

`undeclared-attr` cannot be written through `tl`, which refuses an undeclared
attribute on write. Its question was given a valid `hint` through `tl`, and the
key was then renamed on disk. It is the only file here not written by `tl`.

`full-stop-message` was written through `tl`. tl 5.1.1 checks a value's base type
on write but not a type's `pattern`, so `tl amend` accepts the full stop and only
`tl check` reports it.

The examples' items are `origin: ai` and `proposed`, so `tl check` warns that each
one is unratified. Those warnings don't affect the result: `check.sh` runs the
check without `--strict`.
