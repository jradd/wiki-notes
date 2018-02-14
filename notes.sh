notes() {
  	local fpath=$HOME/notes.md
  	if [[ "$1" == "vim" ]]; then
  		vim + $fpath
  	elif [[ "$1" == "vim" ]]; then
  		vim + $fpath
  	elif [[ "$1" == "date" ]]; then
  		echo '' >> $fpath
  		echo '# '`date +"%m-%d-%Y-%T"` >> $fpath
  		echo '---------------------' >> $fpath
  	elif [[ "$1" == "" ]]; then
  		less +G $fpath
  	else
  		echo '' >> $fpath
  	    echo $@ >> $fpath
  	fi
  }
