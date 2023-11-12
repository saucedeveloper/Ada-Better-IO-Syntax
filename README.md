# Ada-Better-IO-Syntax

A package meant to help with the type specific nature of IO interactions in Ada.
With `Bio`, you do not worry about what function you have to call, or if your type has the `'Image` attribute. You just add an `&` and the expression.
`Bio` is designed to be extensible to any type, as long as you or the package define the behaviour.
It currently supports output with `Character`, `String`, `Integer`, `Float`, `Boolean`.
