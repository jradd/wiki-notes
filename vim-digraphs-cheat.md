# Vim Digraphs
To use math symbols in Vim, use digraphs.

## Using digraphs in Vim  

`:digraphs`  


To enter a digraph from _insert_ mode in Vim: 

`CTRL + k + <value>`  

### Symbols in Vim  

| Description | symbol | Unicode (decimal) Value | Vim Digraph (^k)                     |  
|:------------------:|:------:|:------------------|:---------------------------------|
| plus minus | ± | 177 | +- |
| squared (superscript 2) | ² | 178 | 2S |
| coproduct (big, tall Pi) | ∏ | 8719 | \*P |
| summation (big, tall Sigma) | ∑ | 8721 | +Z |
| bullet operator (dot product) | ∙ | 8729 | Sb |
| (square) root | √ | 8730 | RT |
| infinity | ∞ | 8734 | 00 |
| Greek Letters |
| Gamma | Γ | 915 | G\* |
| Delta | Δ | 916 | D\* |
| Theta | Θ | 920 | H\* |
| Pi | Π | 928 | P\* |
| Sigma | Σ | 931 | S\* |
| Phi | Φ | 934 | F\* |
| Psi | Ψ | 936 | Q\* |
| Omega | Ω | 937 | W\* |
| alpha | α | 945 | a\* |
| beta | β | 946 | b\* |
| gamma | γ | 947 | g\* |
| delta | δ | 948 | d\* |
| epsilon | ε | 949 | e\* |
| eta | η | 951 | y\* |
| theta | θ | 952 | h\* |
| kappa | κ | 954 | k\* |
| lambda | λ | 955 | l\* |
| mu | μ | 956 | m\* |
| pi | π | 960 | p\* |
| rho | ρ | 961 | r\* |
| sigma | σ | 963 | s\* |
| sigma (alternative) | ς | 962 | \*s |
| tau | τ | 964 | t\* |
| phi\* | φ | 966 | f\* |
| psi\* | ψ | 968 | q\* |
| omega\* | ω | 969 | w\* |
| dagger (sword) | † | 8224 | /- |
| double dagger (double sword) | ‡ | 8225 | /= |
| left arrow\* | ← | 8592 | <- |
| up arrow | ↑ | 8593 | -! |
| right arrow | → | 8594 | -> |
| down arrow | ↓ | 8595 | -v |
| Logic | | |
| for all (for any) | ∀ | 8704 | FA |
| partial differential (curled little d) | ∂ | 8706 | dP |
| there exists (backwards capital E) | ∃ | 8707 | TE |
| logical and | ∧ | 8743 | AN |
| logical or | ∨ | 8744 | OR |
| therefore (triangle of dots) | ∴ | 8756 | .: |
| because (upside-down triangle of dots) | ∵ | 8757 | :. |
| Sets |
| Null set, empty set, var nothing, capital O slash | ∅ | 8709 | /0 |
| Null set, empty set, var nothing, capital O slash | Ø | 216 | O/ |
| element of | ∈ | 8712 | (- |
| contains as member | ∋ | 8715 | -) |
| set intersect | ∩ | 8745 | (U |
| set union | ∪ | 8746 | U) |
| subset of (contained in) | ⊂ | 8834 | (C |
| superset of (contains) | ⊃ | 8835 | )C |
| subset of or equal to |  | 8838 | (_ |
| superset of or equal to | ⊇ | 8839 | )_ |
| concatenation, centered dot | ∘ | 8728 | Ob |
| Calculus |
| integral S | ∫ | 8747 | In |
| double integral S | ∬ | 8748 | DI |
| line integral S with circle | ∮ | 8750 | Io |
| Delta | ∆ | 8710 | DE |
| Nabla | ∇ | 8711 | NB |
| Equalities, inequalities, et al. |
| tilde operator (centered tilde, proportional) | ∼ | 8764 | ?1 |
| approximately equal to | ≅ | 8773 | ?= |
| almost equal to | ≈ | 8776 | ?2 |
| not equal to | ≠ | 8800 | != |
| less than or equal to | ≤ | 8804 | =< |
| greater than or equal to | ≥ | 8805 | >= |


`u[4-char-xdigit]`  

`U[8-char-xdigit]`  

