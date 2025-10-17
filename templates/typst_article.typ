#set document(
  title: "Your Article Title Here",
  author: "Erico Silva",
)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 3cm),
  numbering: "1",
  number-align: center,
)

#set text(
  font: "Concrete Math",
  size: 10.5pt,
  lang: "en",
  weight: "light",
)

#set heading(
  numbering: "1.",
  supplement: [Section],
)

#show heading.where(level: 1): set text(weight: "medium", size: 14pt)
#show heading.where(level: 2): set text(weight: "medium", size: 12pt)

#show math.equation: set text(font: ("Concrete Math"))

#set par(
  justify: true,
  leading: 0.65em,
)

// Title and author information
#align(center)[
  #text(size: 17pt, weight: "medium")[
    Your Article Title Here
  ]
  
  #v(1em)
  
  #text(size: 11pt, weight: "light")[
    Erico Silva#footnote[DeCODE Genetics. Email: #link("mailto:erics@decode.is")[#text(font: "Courier New")[erics\@decode.is]]]
  ]
]

#v(2em)

// Abstract
#align(center)[
  #text(weight: "medium", size: 12pt)[Abstract]
]

#pad(x: 2em)[
  #text(size: 9.5pt)[
    This is the abstract of your article. 
  ]
]

#v(2em)

// Main content starts here
= Introduction

This is the introduction section. One can write content here with automatic paragraph formatting and justification. Citations can be added using the bibliography feature [1] or [2].

Here's a second paragraph demonstrating the spacing and formatting. The template uses justified text alignment and appropriate line spacing for readability.

= Mathematical Content

== Inline and Display Math

Typst supports both inline math like $alpha + beta = gamma$ and display equations:

$ 
  f(x) = integral_0^x e^(-t^2) dif t 
$

You can also create numbered equations:

#set math.equation(numbering: "(1)")

$ 
  nabla dot bold(E) = rho / epsilon_0 
$ <eq:gauss>

And reference them: As shown in @eq:gauss, the divergence of the electric field is proportional to the charge density.

== Mathematical Theorems

#let theorem(title, content) = {
  block(
    fill: rgb("f5f5f5"),
    inset: 10pt,
    radius: 2pt,
    stroke: (left: 3pt + rgb("4a90e2")),
    [
      #text(weight: "medium")[Theorem #title.] #content
    ]
  )
}

#theorem[
  (Pythagorean Theorem)
][
  For a right triangle with legs $a$ and $b$ and hypotenuse $c$:
  $ a^2 + b^2 = c^2 $
]

= Tables and Figures

== Tables

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    inset: 10pt,
    align: horizon,
    [*Method*], [*Accuracy*], [*Time (ms)*],
    [Baseline], [85.2%], [120],
    [Proposed], [92.1%], [95],
    [State-of-art], [91.5%], [150],
  ),
  caption: [Comparison of different methods],
) <tab:comparison>

As shown in @tab:comparison, our proposed method achieves better performance.

== Figures

#figure(
  rect(width: 80%, height: 100pt, fill: rgb("e0e0e0"))[
    #align(center + horizon)[
      _[Your figure/image here]_
    ]
  ],
  caption: [Example figure placeholder],
) <fig:example>

= Lists and Enumerations

== Bullet Points

- First item in the list
- Second item with some longer text to demonstrate how line wrapping works in lists
- Third item with sub-items:
  - Sub-item one
  - Sub-item two

== Numbered Lists

+ First step in the process
+ Second step with more detail
+ Final step

= Code Blocks

You can include code with syntax highlighting:

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

= Conclusion

This template provides a minimal yet functional starting point for academic articles in Typst. It includes all the essential components while maintaining clean, readable formatting.

= Acknowledgments

The authors would like to thank...

// Bibliography
#pagebreak()

= References

#set par(first-line-indent: 0em, hanging-indent: 2em)

#let ref(key, authors, title, journal, year) = {
  [*\[#key\]* #authors. "#title". #journal, #year.]
  v(0.5em)
}

#ref(
  "1",
  "Daubechies, I.",
  "Ten Lectures on Wavelets",
  "SIAM",
  "1992"
)

#ref(
  "2", 
  "Mallat, S.",
  "A Wavelet Tour of Signal Processing",
  "Academic Press",
  "2008"
)

// Note: For actual use, use Typst's bibliography 
// management with a .bib file:
// #bibliography("references.bib")
