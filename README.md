WARN: This project was modified.  
README.md was modified by heiqiu_loading in 2026-02-01 
(heiqiu_loading: my English skill is so bad...)
  
  
  
no title  
  
  
  
## description
---

"dashboard-nvim" is pretty cool, but configuration is really hard for me,  
so i made this project to make it more configurable.  
also make it need more time in configuring for just start  
a little side effect huh, that it, enjoy!  
  
  
  
## link
---
- dashboard-nvim: [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim)


### change log
---
- Forking
	- git fetch org
	- git reset --hard org/master  
- Destroy entire structure (#0)
	- rm -r doc/
	- rm -r .github/
	- rm -r plugin/
	- rm -r lua/dashboard/
	- rm .stylua.toml
	- rm README.md
- Setup (#1)
	- mkdir -p lua/value/object/
		- touch lua/value/object/stack.lua
	- mkdir -p lua/value/unit/
		- touch lua/value/unit/keymap.lua
	- mkdir plugin/
		- touch plugin/value.lua
	- mov ~/dev/item/config/nvim/lua/user/plugin/dashboard/* lua/value/
	- touch README.md
	- nvim lua/value
- Looking for standard plugin structure (#2)
	- mov lua/value/init.lua lua/value.lua
	- cat lua/plugin/value.lua >> lua/value.lua
	- rm -r plugin/
	- nvim lua/value.lua
- Is my project (#2)
	- echo '#define Lua_PROJECT' > project.c

### TO-DO
---
- What can i do?