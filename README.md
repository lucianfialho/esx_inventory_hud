# esx_inventory_hud
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=JP7ZWZG5D4U2E&currency_code=BRL)

## For more informations or doubt ...
[![Discord](https://discordapp.com/api/guilds/775510557825695804/widget.png?style=banner2)](https://discord.gg/Q2gRNUmMqQ)


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
cd inventory_hud
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

You can buy me a coffee and encourage me to share more codes with the community :)
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=JP7ZWZG5D4U2E&currency_code=BRL)

## Thanks

Thanks for vuejs the boilerplate ;) [@calumari](https://github.com/calumari)

# Legal
### License
esx_inventory_hud - Inventory Hud for players

Copyright (C) 2020-2020 Lucian Fialho

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
