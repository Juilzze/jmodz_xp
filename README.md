# jmodz_xp
Fivem XP system working with ESX. This is my first publicly released FiveM resource, enjoy :)

<h2>Setup:</h2>

  ```
  1. Drag files to your server folder
  2. Insert xp.sql to your mysql server
  3. Start resource with "ensure jmodz_xp" command
  ```
  
<h2>Useful information:</h2>

To get player's xp use: 
```lua
local value = exports.jmodz_xp:getxp()
```
To get player's rank use: 
```lua
local value = exports.jmodz_xp:getrank()
```
To give a player some xp use: 
```lua
exports.jmodz_xp:givexp(50)
```
To remove xp from a player use: 
```lua
exports.jmodz_xp:removexp(50)
```
