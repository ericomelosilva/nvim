// Document setup
#set document(
  title: "Title",
  author: ("Me", "You"),
)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 3cm),
  numbering: "1",
  number-align: center,
)

#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "en",
)

#set par(
  justify: true,
  leading: 0.65em,
)

#set heading(numbering: "1.")

// Title and author information
#align(center)[
  #text(size: 17pt, weight: "bold")[
    Your Article Title Here
  ]
  
  #v(1em)
  
  #text(size: 12pt)[
    First Author#super[1], Second Author#super[2]
  ]
  
  #v(0.5em)
  
  #text(size: 10pt, style: "italic")[
    #super[1]DeCODE Genetics \
    #super[2]Somewhere Else
  ]
  
  #v(0.5em)
  
  #text(size: 10pt)[
    #link("mailto:erics@decode.is")[erics\@decode.is],
    #link("mailto:author2@email.com")[author2\@email.com]
  ]
]

#v(2em)

// Abstract
#align(center)[
  #text(weight: "bold", size: 12pt)[Abstract]
]

#pad(x: 2em)[
  #text(size: 10pt)[
    This is the abstract. 
  ]
]

#v(2em)

// Main content here
= Introduction

This is the introduction section.

= Mathematical Content

== Inline and Display Math

Inline math $alpha + beta = gamma$ and display equations:

$ 
  f(x) = integral_0^x e^(-t^2) dif t 
$

Can also create numbered equations:

#set math.equation(numbering: "(1)")

$ 
  nabla dot bold(E) = rho / epsilon_0 
$ <eq:gauss>

And reference them: As shown in @eq:gauss, the divergence of the electric field is proportional to the charge density.

== Mathematical Theorems

#let theorem(title, content) = {
  block(
    fill: rgb("f0f0f0"),
    inset: 10pt,
    radius: 4pt,
    [
      *Theorem #title.* #content
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

Concluding the template

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
  "Smith, J. and Doe, A.",
  "An Important Paper on Something",
  "Journal of Examples",
  "2023"
)

#ref(
  "2", 
  "Johnson, B. et al.",
  "Another Significant Contribution",
  "Nature Reviews",
  "2024"
)

// Note: For actual use, one would typically use Typst's bibliography 
// management with a .bib file:
// #bibliography("references.bib")
