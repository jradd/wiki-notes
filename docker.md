# Docker

- docker-completion for Zsh   

```sh
mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version
--short)/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose
# compinit should be loaded already
# fpath=(~/.zsh/completion $fpath)

```

- reload shell
`exec $SHELL -l`
