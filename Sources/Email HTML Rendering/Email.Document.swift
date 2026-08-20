//
//  Email.Document.swift
//  swift-email-html — Email HTML Rendering
//

public import Email_Standard
public import HTML

extension Email {
    /// The email HTML document shell.
    ///
    /// Emails are not web pages: styles must reach the client as a hoisted
    /// `<style>` block (or inline), layout must survive table-based clients,
    /// and the first text in the body is scraped as the inbox preview.
    /// `Email.Document` provides that shell — a preheader, an email CSS reset,
    /// a dark-mode block, and a presentation-role full-width table the caller
    /// fills with `tr` / `td`.
    ///
    /// ```swift
    /// Email.Document(preheader: "Verify your email") {
    ///     tr {
    ///         td {
    ///             Email.VStack(alignment: .start) {
    ///                 Email.Header(3) { "Verify your email address" }
    ///             }
    ///         }
    ///     }
    /// }
    /// .backgroundColor(.background.primary.reverse())
    /// ```
    ///
    /// ## Style hoisting
    ///
    /// The two-phase hoist that email requires is not implemented here: it is
    /// inherited. Conforming to `HTML.Document.Protocol` means
    /// `HTML.__DocumentProtocol._renderHTMLDocument` renders the body first to
    /// collect the styles every `.css` chain registers, then writes
    /// `<!doctype>` / `<html>` / `<head>` — emitting the collected stylesheet as
    /// a `<style>` block in the head — and only then the body. The retired
    /// shell hand-rolled this with a second `HTMLPrinter` behind an
    /// `\.emailPrinter` dependency key; the current tower does it natively, so
    /// no rendering machinery is restated here.
    ///
    /// Render with `HTML.Context.Configuration.email`, which forces `!important`
    /// on the hoisted declarations so client stylesheets cannot win:
    ///
    /// ```swift
    /// let html = try String(document, configuration: .email)
    /// ```
    public struct Document<Content: HTML.View>: HTML.Document.`Protocol` {
        /// Inbox preview text — hidden in the rendered body, scraped by clients.
        public let preheader: String

        /// The table rows the shell wraps.
        public let content: Content

        /// Document background. `nil` uses the theme background.
        var _backgroundColor: DarkModeColor?

        public init(
            preheader: String = "",
            @HTML.Builder content: () -> Content
        ) {
            self.preheader = preheader
            self.content = content()
        }

        /// Sets the document background, in both colour schemes.
        ///
        /// This is a value-returning modifier on `Email.Document` rather than a
        /// `.css` chain because the result must stay an `Email.Document`: the
        /// CSS chain would wrap it in `HTML.CSS<…>`, which is an `HTML.View` but
        /// no longer an `HTML.Document.Protocol`, and could not be rendered as a
        /// document.
        public func backgroundColor(_ color: DarkModeColor) -> Self {
            var copy = self
            copy._backgroundColor = color
            return copy
        }

        /// The resolved document background.
        var background: DarkModeColor {
            _backgroundColor ?? .background.primary
        }

        public var head: some HTML.View {
            HTML.Group {
                meta(charset: .utf8)
                meta(
                    name: .viewport,
                    content: "width=device-width, initial-scale=1.0, viewport-fit=cover"
                )
                HTML.Style.Element { stylesheet }
            }
        }

        public var body: some HTML.View {
            HTML.Group {
                // Preheader: the inbox preview line. Present in the markup,
                // invisible in the rendered body — every property below is one
                // of the belt-and-braces hides email clients respect.
                span { HTML.Text(preheader) }
                    .css
                    .inlineStyle("display", "none")
                    .inlineStyle("opacity", "0")
                    .inlineStyle("visibility", "hidden")
                    .inlineStyle("width", "0")
                    .inlineStyle("height", "0")
                    .inlineStyle("max-width", "0")
                    .inlineStyle("max-height", "0")
                    .inlineStyle("overflow", "hidden")
                    .inlineStyle("mso-hide", "all")

                // Presentation-role wrapper. `role="presentation"` keeps the
                // layout table out of the accessibility tree; the cellpadding /
                // cellspacing / border attributes are the legacy-client belt to
                // the CSS braces.
                table { content }
                    .attribute("role", "presentation")
                    .attribute("width", "100%")
                    .attribute("align", "center")
                    .attribute("cellpadding", "0")
                    .attribute("cellspacing", "0")
                    .attribute("border", "0")
                    .css
                    .backgroundColor(background)
                    .inlineStyle("width", "100%")
                    .inlineStyle("max-width", "100%")
                    .inlineStyle("margin", "0 auto")
                    .inlineStyle("border-collapse", "collapse")
            }
        }

        /// The email CSS reset and dark-mode block, emitted as a literal
        /// `<style>` element in the head.
        ///
        /// This is a raw stylesheet rather than `.css` chains because it targets
        /// bare element selectors (`body, table, td, div, p, a`) rather than a
        /// view — there is no view to hang it on.
        var stylesheet: String {
            """
            body, table, td, div, p, a {
                -webkit-text-size-adjust: 100%;
                -ms-text-size-adjust: 100%;
                margin: 0;
                padding: 0;
            }

            body {
                width: 100% !important;
                background-color: \(background.light.description);
            }

            table {
                border-collapse: collapse;
            }

            @media (prefers-color-scheme: dark) {
                body, table, td, div {
                    background-color: \(background.dark.description) !important;
                }
            }
            """
        }
    }
}
