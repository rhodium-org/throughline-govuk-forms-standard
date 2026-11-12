# GOV.UK forms standard

A [throughline](https://github.com/rhodium-org/throughline) graph that states the
model a GOV.UK (GDS) form is specified in: the kinds of item a form spec holds
(the form, sections, pages, questions, options, validations, routes), their
attributes and value sets, and the links that join them. A form spec that follows
it is checked against GDS rules by `tl check` before anyone builds it.

It is a standard, not a tool and not a form. It says what a form is, never how it
is rendered: a prototype, a service and its tests can all read the same spec.

## The shape of a form

| Kind | What it is | Records |
|---|---|---|
| `form` | the form itself, one per graph | `title`, `purpose` |
| `section` | a task on a task-list form | `title`, `position` |
| `page` | one screen | `kind`, `slug`; `heading` (not on question pages), `body`, `button_text` |
| `question` | one answer, asked with one component | `text`, `name`, `component`, `answer`, `why_asked`; `if_empty` when mandatory; `max_length` for a character count; `hint`, `pattern`, `autocomplete`, `width`, `summary_label` |
| `option` | one answer to a radios, checkboxes or select question | `label`, `value`, `position`; `hint`, `exclusive`, `divider_before` |
| `validation` | one check on an answer | `rule`, `message`; `value` when the rule compares |
| `route` | one way out of a page | `otherwise` |

| Link | From | To | Means |
|---|---|---|---|
| `part_of` | page, section | form, section | the breakdown |
| `answers` | form, page, question | any item of a composed graph | the requirement or clause it answers |
| `on` | question | page | the page the question is asked on |
| `of` | option | question | one of the question's answers |
| `revealed_by` | question | option | shown when that option is chosen |
| `checks` | validation | question | the answer it checks |
| `leaves` / `goes_to` | route | page | the page it leaves and the page it reaches |
| `when_chosen` | route | option | taken only when that option is chosen |

`part_of`, `on`, `of`, `checks` and `leaves` are grounding links, so every item
reaches the one form. `goes_to`, `when_chosen` and `revealed_by` are not, so a
journey may loop back without being refused as circular.

`tl check` refuses a form spec that breaks one of these rules:

- **Required attributes.** Every mandatory question has an `if_empty` message, and
  every character count has a `max_length`. A question page has no heading of its
  own: the question is the heading.
- **Error messages.** An error message starts with a capital and has no
  exclamation mark and no full stop at the end.
- **Value sets.** Components, page kinds, answer patterns, autocomplete tokens,
  widths and validation rules come from fixed value sets.
- **Reachability.** Every page but the start page can be reached.
- **No dead ends.** Every page but a confirmation or cannot-continue page has a
  way out.
- **Options.** Every radios, checkboxes or select question has options.
- **Undeclared names.** An undeclared register, attribute or link is an error,
  with a did-you-mean hint.

The rules it can't check are in [guidance/AUTHORING.md](guidance/AUTHORING.md).

## Following the standard

```toml
[[sources]]
namespace = "form"
url = "https://github.com/rhodium-org/throughline-govuk-forms-standard"
ref = "v1.0.0"
schema = true
```

or start a new form spec with:

```sh
tl init --from-schema https://github.com/rhodium-org/throughline-govuk-forms-standard --ref v1.0.0 --namespace form
```

The form spec is then checked against this standard's declarations: its
registers, attributes, links and link types, plus the statuses, transitions,
grounding and coverage rules in its `throughline.toml`. A form spec may declare its
own additions (`scope = "this-graph"`), but never redefine one declared here. This
needs throughline 5.2.0 or later. Copy [guidance/AUTHORING.md](guidance/AUTHORING.md)
into the form spec for the agent that writes it.

### Linking a form spec to the graphs it composes

A form spec may compose other graphs as ordinary sources: the graph that
specifies the service, and the requirement graphs
[throughline-govuk-components](https://github.com/rhodium-org/throughline-govuk-components)
and [throughline-wcag](https://github.com/rhodium-org/throughline-wcag). A form, a
page or a question may then link to any item of those graphs with `answers`:

```sh
tl link QN-0012 service:REQ-0006 --type answers   # the requirement that calls for it
tl link QN-0012 wcag:SR-0015 --type answers       # the criterion its autocomplete meets
```

The link is stamped, so a change to the item it points at marks the question for
review. It does not ground: every item still reaches the one form. This needs
throughline 5.2.0 or later and meta-standard v1.2.0, the first to check a link
declared to run outside the follower.

Two joins stay by value, because they are attributes and not links: a question's
`component` equals the `source_ref` of that component's `govuk:UR-*` item, and its
`autocomplete` is how it meets WCAG 2.2 SC 1.3.5.

## What is in this graph

| Register | Holds |
|---|---|
| `vision/` (INT) | why the standard exists |
| `registers/` (REG) | the registers a form spec holds: FRM (exactly one), SEC, PG, QN, OPT, VAL, RT |
| `types/` (TYPE) | line, text, flag, count, slug, answer key, error message |
| `enums/` (ENUM) | page kind, component, answer pattern, autocomplete, width, validation rule, answer needed |
| `attributes/` (ATTR) | each register's attributes, required, conditional or optional |
| `links/` (LINK), `link-types/` (LT) | which registers each link joins, and how many |
| `guidance/` (GUIDE) | the authoring guidance a form spec copies |

Each declaration carries the GDS reason for it as its `rationale`. The standard
follows the throughline meta-standard
([throughline-standard-standard](https://github.com/rhodium-org/throughline-standard-standard)
v1.2.0), which fixes what a declaration is. LINK-0010 is this graph's own
(`scope: this-graph`): it lets the GUIDE item derive from the intent, a link
meta-standard does not declare.

[conformance/](conformance/) holds one example form spec that passes and seven
that each fail for one stated reason. CI runs `tl check` and `conformance/check.sh`.

Edition 1 leaves out "add another" loops, branching on anything but a chosen
option, save and return, and Welsh content.

## Editions

The standard is released as tagged editions that a form spec pins. A change that
would make a conforming form spec fail is a new major edition, and its notes say
what a form spec must change.
