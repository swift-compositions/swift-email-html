# Parked (staged absorption, 2026-07-12 · pruned 2026-07-14)

Verbatim copies from swift-email's `Parked/Email/` (parked there at the
coenttb-ectomy, commit `be59dce`): the pf-html-era rendering pipeline with no
institute home yet. Institute `HTML` is the WHATWG_HTML namespace and the
HTML-Rendering view stack — not the pf DSL protocol (`struct X: HTML`,
`some HTML`, `@HTMLBuilder`, `AnyHTML`, `HTMLPrinter`) these files build on.

## Still staged

- `Email+HTML.swift` — `Email(to:from:subject:html:)` and `Email.Body.html`
  convenience inits, bridging an HTML view into the RFC 5322 compose model.
- `EmailMarkdown.swift` — markdown → email HTML (also needs a Theme home;
  builds on the retired `HTMLMarkdown` / `HTMLTheme` modules).
- `EmailHTMLTests.swift`, `ReadmeVerificationTests.swift` — tests of the two
  files above.

These files are excluded from every target and this package declares no
dependency the files would need — they do not compile here.

## No longer staged (superseded 2026-07-14)

- `EmailDocument.swift` (the `TableEmailDocument` shell) and `BaseStyles.swift`
  (the email CSS reset) were **superseded by the `Email HTML Rendering` target**
  (`Sources/Email HTML Rendering/`) and deleted in the same commit.
  `Email.Document` is their replacement: it carries the preheader, the reset,
  the dark-mode block and the presentation-role table wrapper, and it gets the
  two-phase style hoist for free by conforming to `HTML.Document.Protocol`
  rather than hand-rolling a second `HTMLPrinter` behind an `\.emailPrinter`
  dependency key.

**Restore gate** (for what remains): the open HTML-email story decision
(principal queue; see the repotraffic ectomy charter close report 2026-07-12
and `Workspace/BACKLOG.md`). When that story lands, these files are rewritten
against the institute HTML stack and move into `Sources/`; until then they
change only by re-sync from the swift-email park.
