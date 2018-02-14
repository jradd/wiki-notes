# Command—line and Script Snippets
Worth saving


# awk  

`awk 'NF{i++} END { print "," i }' foo.txt`

# sed


## files

files with fewest count of lines (100cnt)
`find ./ -type f -name '*.md' -print0 -exec awk 'NF{i++} END { print "," i }' {} \; |sort -t, -nk2
|head -n100`


### Rename files with numerical prefix

A neat way of renaming files with a numerical prefix.
```bash
i=1; for j in *; do mv $j $i.$j; ((i++)); done

i=1; for f in *; do mv $f $(echo $i| awk '{ printf("%03d", $0)}').$f;
         ((i++)); done

integer i=0; for f in *; do mv $f $[i+=1].$f; done
```  


### curl
Use curl to update local copy of a file if the remote copy is newer than our local copy

We accomplish this with the `curl -z <time-cond>` argument. Neat!

```bash
for f in $(curl -fk -L https://live.sysinternals.com/tools/ |egrep -o '>[aA0-zZ9]*.(exe|chm)<'); do f="$(echo "${f}" |cut -c 2- |sed -e 's|<||g')"; curl -fksSR -z "./${f}" -O "https://live.sysinternals.com/tools/${f}"; done
```   





