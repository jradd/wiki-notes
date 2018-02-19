# gollum




### Performance

This should improve performance:
```
gem install gollum-rugged_adapter
#gem install --pre gollum-rugged_adapter #  --pre required for beta-releases
gollum --adapter rugged
``` 
1. fork `gollum-lib`
2. fork ADAPTER
3. modify `gollum-lib`'s Gemfile to point to your new adapter:
    `gem ADAPTER, :path => PATH`
    `bundle install`
ADAPTER_REPO='https://github.com/jradd/rugged_adapter'
