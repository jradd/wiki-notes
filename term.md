# Terminal
Notes for terminal related things


## tmux

### BYOBu

#### byobu colors

`/usr/lib/byobu/include/shutil`  
copy the entire `color_map()` function and paste into user's `~/.byobu/color.tmux` config file.



```zsh
color_map() {
        case "$1" in
                "k") _RET="black" ;;
                "r") _RET="red" ;;
                "g") _RET="green" ;;
                "y") _RET="yellow" ;;
                "b") _RET="blue" ;;
                "m") _RET="magenta" ;;
                "c") _RET="cyan" ;;
                "w") _RET="white" ;;
                "d") _RET="black" ;;
                "K") _RET="brightblack" ;;
                "R") _RET="brightred" ;;
                "G") _RET="brightgreen" ;;
                "Y") _RET="brightyellow" ;;
                "B") _RET="brightblue" ;;
                "M") _RET="brightmagenta" ;;
                "C") _RET="brightcyan" ;;
                "W") _RET="brightwhite" ;;
                *) _RET= ;;
        esac
}
```
>> color_map() function from `/usr/lib/bybu/include/shutil`



