# esx_inventory_hud

This resource for ESX add a inventory hud to fivem

![Example](https://media.discordapp.net/attachments/738128059617509526/770470074577977344/unknown.png?width=1250&height=703)


## Requirements
You need [node-js](https://nodejs.org/en/)  
You need [vue-cli](https://cli.vuejs.org/) 3.x.

## Download & Installation

### Download Using Git
```
cd resources
git clone https://github.com/lucianfialhobp/esx_inventory_hud.git [esx]/esx_inventory_hud
```

### 2. Install submodule
```
git submodule update --init --recursive
```

### 3. Install dependencies
```
cd status_hud
npm install
```

### 4. Build
```
npm run build
```

### Download Manually
- Download https://github.com/lucianfialhobp/esx_inventory_hud/archive/master.zip
- Put it in the `[esx]` directory

## Installation
- Import `esx_inventory_hud.sql` in your database
- Add this to your `server.cfg`:

```
ensure esx_inventory_hud
```

### Font Awesome support
The inventory icons were used with incredible fonts, in the installation you will add column icon to the item table. There you can set the icon when you prefer

[fontawesome](https://fontawesome.com/)

## Commands
### Run locally for development

```
npm run serve
```

## Tip

Use the vue chrome extension for debug [vue-chrome-extension](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd?hl=pt-BR)

## Thanks

Thanks for vuejs the boilerplate ;) [@calumari](https://github.com/calumari)

# Legal
### License
esx_weaponshop - Legal and illegal weapon shops

Copyright (C) 2020-2020 Lucian Fialho

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.