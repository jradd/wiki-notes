# Zsh
Notes specific to zshell





* zsh bang
previous commands:
   !!  Previous command
   !-1 Previous command
   !-2 Second previous command
Getting individual arguments:
   !$   Last arg
   !*   All args
   !$:h Last argument, strip one level
   !!:1 First arg
Modifying commandlines
   !ls:$:h             Head
   !ls:$:t             Tail
   !ls:$:r             Rm Suffix
   !ls:$:s/user/dude/  Substitute user by dude
* Filename Modifiers
  :h    head (dirname)
  :t    tail (basename)
  :e    extension
  :r    remove extension

  :l    lowercase conversion
  :u    uppercase conversion

  :p    print command but do not execute
  :q    quote substituted words

* zsh globbing
  **/*  Picks out all files and directories, recursively.
  ***/* Ditto, following symlinks
  * Any string, including the null string.
  ? Any character.
  [...] Any of the enclosed characters. Ranges of characters can be specified by
  separating two characters by a -.
  [^...]    Inverse
  [!...]    Inverse
  <x-y> Any number in the range x to y, inclusive. Either can be omitted.
  ^x    Anything except the pattern x.
  x|y   Either x or y.

  x#    Zero or more occurrences of the pattern x.
  x##   One or more occurrences of the pattern x.
globbing qualifiers
* file type
    (.)     Regular files
    (/)     Directories
    (@)     Symlinks
    (=) Sockets
    (p) Named pipes
    (%) Device
    (%b)    Block devices
    (%c)    Character devices
* permissions
    (r)     Readable by owner
    (w)     Writable by owner
    (x)     Executables by owner
    (R)     Readable by world
    (W)     Writable by world
    (X)     Executable by world
    (A) Readable by group
    (I) Writable by group
    (E) Executable bu group
alternatively a chmod style syntax is supported:
    ls **/*(.:g-w:)
* Ownership
    (U)     Your own user
    (G)     Your own group
    (u:userid:) User with userid
    (g:userid:) group with groupid
example: list files belonging to user www-data with ls -l /(u:www-data:)
Modification and access time
    (m) Modification time
    (a) Access time

    (-) Before
    (+) After

    (M) Months
    (w) Weeks
    (h) Hours
    (m) Minutes
    (s) Seconds
example: list files accessed last month with ls /(.aM-1)
file size
    (L) File size (defaults to bytes)
    (k) use kilobytes
    (m) use megabytes
    (p) use 512-byte blocks
example: list all files larger than 10 megabytes with ls /(.Lm+10)
dos2unix /~.(gif|png|jpg)(.) # ~ excludes
dos2unix (#i)/~.(gif|png|jpg)(.) # case-insensitive
ls =bob # Lists file anywhere in $PATH
ls /some_file # Lists file under current directory zargs -- /(.) -- ls -l # Ditto
* zsh Iteration
  for i (/home/**/q*) rm $i
  for i in /**/b*(u:miklophone:); do rm $i ; done
  for f in http://zsh.sunsite.dk/Guide/zshguide{,{01..08}}.html; do...
  zargs -- /**/b*(u:miklophone:) -- rm

* Renaming files with Zsh
Numerical prefix:
   $  i=1; for j in *; do mv $j $i.$j; ((i++)); done

   $  i=1; for f in *; do mv $f $(echo $i| awk '{ printf("%03d", $0)}').$f;
   ((i++)); done

   $  integer i=0; for f in *; do mv $f $[i+=1].$f; done
Rename all files from name.mp3 to Name.mp3:
   $  zmv `([a-z])(*).mp3` `${(C)1}$2.mp3`
Capitalize file
   $  zmv '([a-z])(*).pdf' '${(C)1}$2.pdf'
Replaces spaces with underlines
   $  zmv '* *' '$f:gs/ /_'
FOO to foo
   $  for i in *(.); mv $i ${i:l}
Rename pic1.jpg to pic0001.jpg ...
   $  zmv 'pic(*).jpg' 'pic${(1:4::0:)1}.jpg'
   $  zmv '(**/)pic(*).jpg' '$1/pic1:4::0:)2}.jpg'  # recursive
Remove spaces from filenames
   $  for a in ./**/*\ *(Dod); do mv $a ${a:h}/${a:t:gs/ /_}; done
Substitute r for l
   s/l/r[/]

   Unless preceded immediately by a g, with no colon between, the
   substitution is done only for the first string that matches l. For
   arrays and filename expansion, this applies to each word of the
   expanded text.

   The left-hand side of substitutions are not regular expressions,
   but character strings.

   Any character can be used as the delimiter in place of '/'. A
   backslash quotes the delimiter character.

   The character '&', in the right-hand-side r, is replaced by the
   text from the left-hand-side l. The '&' can be quoted with a
   backslash.

* zsh if # see also -z below
  if [[ $foo = '' ]]; then
  print The parameter foo is empty
  fi
# quote the term to avoid pattern matching (not regexp, btw)
  if [[ biriyana = b* ]]; then
  print Word begins with a b
  fi
# Numbers
  if [[ $number -gt 3 ]]; then
  if [[ $number -lt 3 ]]; then
  if (( $number > 3 )); then
  if (( 3 )); then
# Files
  if [[ file1 -nt file2 ]]; then        # newer than
  if [[ file1 -ot file2 ]]; then        # older than
  if [[ file1 -ef file2 ]]; then        # same file
# Variables
  if [[ -z "$var is blah; test fails" ]]; then      # zero length?
  if [[ -n "$var is blah; test passes" ]]; then     # non-zero length?
