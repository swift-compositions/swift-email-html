# Parked (staged absorption, 2026-07-12)

Verbatim copies from swift-email's `Parked/Email/` (parked there at the
coenttb-ectomy, commit `be59dce`): the pf-html-era rendering pipeline with no
institute home yet. Institute `HTML` is the WHATWG_HTML namespace and the
HTML-Rendering view stack — not the pf DSL protocol (`struct X: HTML`,
`some HTML`, `@HTMLBuilder`, `AnyHTML`, `HTMLPrinter`) these files build on.

- `EmailDocument.swift`, `EmailMarkdown.swift` — rendering pipeline (also
  needs a Theme home: none exists).
- `BaseStyles.swift`, `Email+HTML.swift` — email CSS + `Email(html:)` DSL init.
- `EmailHTMLTests.swift`, `ReadmeVerificationTests.swift` — tests of the above.

These files are excluded from every target and this package declares no
dependency the files would need — they do not compile here. They are the
staged content of this package's eventual HTML-email surface.

**Restore gate**: the open HTML-email story decision (principal queue; see
the repotraffic ectomy charter close report 2026-07-12 and
`Workspace/BACKLOG.md`). When that story lands, these files are rewritten
against the institute HTML stack and move into `Sources/Email HTML/`; until
then they change only by re-sync from the swift-email park.
