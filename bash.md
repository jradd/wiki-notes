# Bash
I will try to keep this limited to bash-only notes


## Arrays

Indice Expansion: Must not be sparse example:

```bash
$ arr=(a b c q w x y z)
$ for ((i=0; i<${#a[@]}; i+=2)); do
> echo "${a[i]} and ${a[i+1]}"
> done
```
```bash
~ » arr=(a b c q w x y z)
~ » for ((i=0; i<${#arr[@]}; i+=2)); do
    echo "${arr[i]} and ${arr[i+1]}"
    done
 and a
b and c
q and w
x and y
```

### Associative Arrays

```bash

```



## IO


- `<<<` (shovel) compared to `< <()` (process substitution)  

```bash
~ » fmt -t -w 20  < <(echo 'Wrap this silly sentence.')
Wrap this silly
   sentence.
~ » fmt -t -w 20 <<< 'Wrap this silly sentence.'
Wrap this silly
   sentence.
```


```bash
~ » cat <<EOF > some_file
my home dir is $HOME
EOF
~ » cat some_file
my home dir is /home/radd
```



## Bash Faux Pas
Common mistakes we should not make in Bash:


1. Don't use `cat` to feed a single file's contents to a filter:  
`cat /var/log/messages | grep pattern`  

`cat` is a utility used to concatenate the contents of multiple files together.

Instead, pass the filename to the program's arguments:  
`grep pattern /var/log/messages`  

2. Don't use a `for` loop to read the lines of a file. Use a `while read` loop instead:
`for line in $(<file); do`  

3. Don't ever test or filter filenames with `grep` Use the shell's `globbing` instead.
`if echo "$file" |fgrep .txt; then ls *.txt |grep story`

4. Don't ever parse the output of `ls` use `globbing` instead!

4. Don't ever parse the output of `ls` use `globbing` instead!

4. Don't ever parse the output of `ls` use `globbing` instead!

4. Don't ever parse the output of `ls` use `globbing` instead!


