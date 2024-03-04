# server.core

## Checkout repository
```
git clone <server.repository>
git submodule update --init
```
If you want to make changes in a submodule or update to newest submodule also execute:
```
git submodule foreach "git checkout main && git pull"
```
Make sure to commit submodules first!  
Also make sure to push submodules as well.

## Create new repository
Create a new repository with name server.<repository>.
Then go to the project folder and execute
```
git submodule add -b main https://github.com/Vereine-Vereint/server.core.git core
```