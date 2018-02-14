# git

## Branches  
Create a new branch named "test_branch":  
`git checkout -b test_branch`

Switch back into master branch:  
`git checkout master`

Delete a branch:  
`git branch -d test_branch`

Push local branch to remote:  
`git push origin <branch>`

Update local repo:  
`git pull`

Merge another branch with current branch:  
`git merge <branch>`

## Logging  
Show logs by filter:  
`git log --graph --oneline --decorate --author=jradd`

Show changes only:  
`git log --name-status`

Preview changes before merging:  
`git diff <source> <target>`  

Restore/replace local changes with HEAD:  
`git checkout -- <file>`

Or to restore all:  
`git fetch origin`  
`git reset --hard origin/master`  

### Create Repo  
```sh
git init
git add ./
# git add -A
git commit -am "committing all"
```

#### Remote Create With cURL
To create a repo remotely from the command-line:  
```sh
curl -u 'USER' https://api.github.com/user/repos -d '{"name":"REPO"}'
git remote add origin git@github.com:USER/REPO.git
git push origin master
```

If planning to alias the above curl command, remember that curl will prompt
for your password. To script this, one could use access tokens:  

[Learn More](https://github.com/settings/applications)  

`https://api.github.com/user/repos?access_token=myAccessToken -d '{"name":"REPO"}'`

~~~~~~~~~~~~~~~~~~~
Troubleshooting
~~~~~~~~~~~~~~~~~~~
```sh
ssh -vT git@github.com
# if fails:  
ssh-add ~/.ssh/id_rsa
# if fails:  
ssh-keygen -t rsa -f ~/.ssh/id_rsa "name email@domain"
ssh-add ~/.ssh/id_rsa
ssh -vT git@github.com
```
