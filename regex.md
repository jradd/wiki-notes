# Regular Expressions
Bash, Zsh, Python mostly.


### Anchoring  
`^` and `$` are meta-characters that respectively match empty string
at beginning and end of line.

### Char Classes  
`[a-b]` in range 
`^[a-b]` *not* in range

### Expressions  

`[:alnum:]` `[:alpha:]` `[:cntrl:]` `[:digit:]` `[:graph:]`
`[:lower:]` `[:print:]` `[:punct:]` `[:space:]` `[:upper:]`
`[:xdigit:]`

`[[:alnum:]]` ==> `[0-9A-Za-z]`


### Repitition  


| Expression  | Representation       |     misc   |
| ----------- |:--------------------:|:----------:|
| `?`         | [?p <= 1]            | `{lte 1}`  |
| `*`         | [p <= 0]             | `{lte 0}`  |
| `+`         | [p >= 1]             | `{gte 1}`  |
| `{n}`       | [p = n]              | `{e}`      |
| `{n,}`      | [p >= n]             | `{gte,}`   |
| `{n,m}`     | [(p >= n), (p <= m)] | `{gte,lte}`|

### Concatenation  
Two RE may be concatenated; resulting RE matches any string formed by
concatenating two substrings that respectively match the concatenated 
expression.

### Alternation  
Join two REGEX by joining with the infix operator `|;`

##### Precedence  
`Repitition` takes precedence over `concatenation` which in turn takes
precedence over `alternation`.


## Perl Grep (pcre)
Enable Perl regex with flag `-P`


```
(?(DEFINE) (?<byte> 2[0-4]\d | 25[0-5] | 1\d\d | [1-9]?\d) )
         \b (?&byte) (\.(?&byte)){3} \b

       The first part of the pattern is a DEFINE group inside which a another group named "byte" is defined. This matches an individual component of an IPv4 address (a number less than 256). When matching takes place, this  part  of  the  pattern  is
       skipped because DEFINE acts like a false condition. The rest of the pattern uses references to the named group to match the four dot-separated components of an IPv4 address, insisting on a word boundary at each end.
```

### Positive Lookahead
`grep -Po "(?=<a>)[[:digit:]]{3}"`  

#### Positive Lookahead Assertion with subroutine

```
  (?(?=[^a-z]*[a-z])
  \d{2}-[a-z]{3}-\d{2}  |  \d{2}-\d{2}-\d{2} )

The condition is a positive lookahead assertion that matches an optional sequence of non-letters followed by a letter. In other words, it tests for the presence of at least one letter in the subject. If  a  letter  is  found,  the  subject  is
matched against the first alternative; otherwise it is matched against the second. This pattern matches strings in one of the two forms dd-aaa-dd or dd-dd-dd, where aaa are letters and dd are digits.
```

### Negative Lookahead  

I suppose a negative lookahead is something like the following:  
`grep -Po "$IP_PATTERN(?=</a>)"`  


## Reference

|Char| Function       |
|:-:|:----------------|
|^|	Start of a string.|
|$|	End of a string.|
|.|	Any character (except \n newline)|
|	Alternation.|
|{...}|	Explicit quantifier notation.|
|[...]|	Explicit set of characters to match.|
|(...)|	Logical grouping of part of an expression.|
|*|	0 or more of previous expression.|
|+|	1 or more of previous expression.|
|?|	0 or 1 of previous expression; also forces minimal matching when an expression might match several strings within a search string.|
|\|	Preceding one of the above, it makes it a literal instead of a special character. Preceding a special matching character, see below.|

| Value | Action |
|:-:|:-------------------------------------------------------------------------------------------------------|
|\a|	Matches a bell (alarm) \u0007.|
|\b|	Matches a backspace \u0008 if in a []; otherwise matches a word boundary (between \w and \W characters).|
|\t|	Matches a tab \u0009.|
|\r|	Matches a carriage return \u000D.|
|\v|	Matches a vertical tab \u000B.|
|\f|	Matches a form feed \u000C.|
|\n|	Matches a new line \u000A.|
|\e|	Matches an escape \u001B.|
|\040|	Matches an ASCII character as octal (up to three digits); numbers with no leading zero are backreferences if they have only one digit or if they correspond to a capturing group number. (For more information, see Backreferences.) For example, the character \040 represents a space.|
|\x20|	Matches an ASCII character using hexadecimal representation (exactly two digits).|
|\cC|	Matches an ASCII control character; for example \cC is control-C.|
|\u0020|	Matches a Unicode character using a hexadecimal representation (exactly four digits).|
|\*|	When followed by a character that is not recognized as an escaped character, matches that character. For example, \* is the same as \x2A.|
|.|	Matches any character except \n. If modified by the Singleline option, a period character matches any character. For more information, see Regular Expression Options.|
|[aeiou]|	Matches any single character included in the specified set of characters.|
|[^aeiou]|	Matches any single character not in the specified set of characters.|
|[0-9a-fA-F]|	Use of a hyphen (–) allows specification of contiguous character ranges.|
|\p{name}|	Matches any character in the named character class specified by {name}. Supported names are Unicode groups and block ranges. For example, Ll, Nd, Z, IsGreek, IsBoxDrawing.|
|\P{name}|	Matches text not included in groups and block ranges specified in {name}.|
|\w|	Matches any word character. Equivalent to the Unicode character categories [\p{Ll}\p{Lu}\p{Lt}\p{Lo}\p{Nd}\p{Pc}]. If ECMAScript-compliant behavior is specified with the ECMAScript option, \w is equivalent to [a-zA-Z_0-9].|
|\W|	Matches any nonword character. Equivalent to the Unicode categories [^\p{Ll}\p{Lu}\p{Lt}\p{Lo}\p{Nd}\p{Pc}]. If ECMAScript-compliant behavior is specified with the ECMAScript option, \W is equivalent to [^a-zA-Z_0-9].|
|\s|	Matches any white-space character. Equivalent to the Unicode character categories [\f\n\r\t\v\x85\p{Z}]. If ECMAScript-compliant behavior is specified with the ECMAScript option, \s is equivalent to [ \f\n\r\t\v].|
|\S|	Matches any non-white-space character. Equivalent to the Unicode character categories [^\f\n\r\t\v\x85\p{Z}]. If ECMAScript-compliant behavior is specified with the ECMAScript option, \S is equivalent to [^ \f\n\r\t\v].|
|\d|	Matches any decimal digit. Equivalent to \p{Nd} for Unicode and [0-9] for non-Unicode, ECMAScript behavior.|
|\D|	Matches any nondigit. Equivalent to \P{Nd} for Unicode and [^0-9] for non-Unicode, ECMAScript behavior.|

