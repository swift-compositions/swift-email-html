//
//  exports.swift
//  swift-email-html — Email HTML Rendering
//
//  Re-exports so `import Email_HTML_Rendering` is a self-contained surface:
//  the `Email` namespace (which this target extends with the email document
//  shell and its components) plus the HTML umbrella the components are
//  expressed in — callers write `Email.Document { tr { td { … } } }` and need
//  both halves in scope.
//

@_exported public import Email_Standard
@_exported public import HTML
