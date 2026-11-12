# Writing a GOV.UK form spec

This is for the person or agent writing a form spec that follows the GOV.UK forms
standard. `tl check` already enforces the declared shape: registers, attributes,
conditional attributes, link counts, reachable pages, no dead ends and options on
choice questions. This page covers what it cannot check.

Run `tl context` first. Make every change with `tl` (`tl new`, `tl link`,
`tl amend`), never by editing the YAML. An agent proposes; a person ratifies.

## The order to write a spec in

1. **The form** (`FRM`, exactly one): `title` is the service name, and `purpose`
   says what the form is for and who it is for.
2. **Sections** (`SEC`), only for a task-list form: each is `part_of` the form.
3. **Pages** (`PG`): each is `part_of` the form or a section. Write the start page
   first and the confirmation page last.
4. **Questions** (`QN`): each is `on` one page. Write `why_asked` before anything
   else. If you can't say why the service needs the answer, don't ask the question.
5. **Options** (`OPT`): each is `of` one radios, checkboxes or select question. A
   conditionally revealed question is `revealed_by` its option.
6. **Validations** (`VAL`): each `checks` one question.
7. **Routes** (`RT`): each `leaves` one page and `goes_to` one page. A branching
   route is also taken `when_chosen` for its options. Write the `otherwise` route
   last.

## Rules the check cannot enforce

- **Exactly one start page.** A form has one way in.
- **One `otherwise` route per page.** A page that branches still needs one way on
  for every answer. A page with a single route out marks that route `otherwise`.
- **Answer keys are unique.** No two questions share a `name`, and no two options
  of one question share a `value`.
- **`exclusive` only on checkbox options.** "None of these" clears the other
  checkboxes; on radios every option is already exclusive. Put `divider_before` on
  the same option so the "or" divider separates it.
- **One thing per page.** Start with one question per page. Put several questions
  on a page only when they are always answered together, such as the parts of an
  address.
- **The question is the heading.** A question page has no `heading` of its own (the
  check refuses one). Write `text` as a question, in the user's words.
- **Plain English error messages.** Use the GOV.UK wording:
  - empty: "Enter your full name", "Select if you have a passport";
  - wrong format: "Enter an email address in the correct format, like
    name@example.com";
  - out of range: "Date of birth must be in the past".

  Say what to do, not what went wrong. Don't write "invalid", "error" or "please".
  The check enforces the capital letter, no exclamation mark and no full stop.
- **Mark optional questions sparingly.** `answer: optional` shows "(optional)" in
  the label. GDS: if most users can skip it, ask whether the service needs it.
- **Name the pattern.** If a question asks for a name, address, date, email, phone
  number, National Insurance number or bank details, set `pattern` and follow that
  pattern's guidance. Set `autocomplete` on every question about the user.

## Linking to the graphs the form spec composes

Declare each graph the form answers to as a source in `throughline.toml`: the
graph that specifies the service, and the GOV.UK and WCAG requirement graphs.
Then link with `answers`:

- every question to the requirement that calls for the answer. If you cannot
  find one, the question should not be asked, or the requirement is missing;
- every page that asks nothing (start, check answers, confirmation) to the
  requirement that calls for it;
- the form to the intent it serves.

Two joins stay by value: `component` equals the `source_ref` of the component's
`govuk:UR-*` item, and `autocomplete` is how a question meets WCAG 1.3.5
(`wcag:SR-0015`).

## GDS guidance

- Question pages: https://design-system.service.gov.uk/patterns/question-pages/
- Check answers: https://design-system.service.gov.uk/patterns/check-answers/
- Error message: https://design-system.service.gov.uk/components/error-message/
- Recover from validation errors:
  https://design-system.service.gov.uk/patterns/validation/
- Complete multiple tasks:
  https://design-system.service.gov.uk/patterns/complete-multiple-tasks/
- Start using a service:
  https://design-system.service.gov.uk/patterns/start-using-a-service/
- Confirmation pages:
  https://design-system.service.gov.uk/patterns/confirmation-pages/
