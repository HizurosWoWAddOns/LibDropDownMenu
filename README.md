# LibDropDownMenu (WoW AddOn Library)
![Build](https://github.com/HizurosWoWAddOns/LibDropDownMenu/actions/workflows/bigwigsmods-packager.yml/badge.svg)
![Tag](https://img.shields.io/github/v/tag/HizurosWoWAddOns/LibDropDownMenu?style=flat-square)
![Downloads](https://img.shields.io/github/downloads/HizurosWoWAddOns/LibDropDownMenu/total?style=flat-square)
![Downloads](https://img.shields.io/github/downloads/HizurosWoWAddOns/LibDropDownMenu/latest/total?style=flat-square)
&nbsp; &nbsp; &nbsp; &nbsp;
[![Patreon](https://img.shields.io/badge/&zwj;-Patreon-gray?logo=patreon&color=red&style=flat-square)](https://www.patreon.com/bePatron?u=12558524)
[![Paypal](https://img.shields.io/badge/&zwj;-Paypal-gray?logo=paypal&color=blue&style=flat-square)](https://paypal.me/hizuro)
![Sponsors](https://img.shields.io/github/sponsors/HizurosWoWAddOns?logo=github&style=flat-square)

## Description
This is a converted version of Blizzards UIDropDownMenu from WoW Retail 9.0.5.37893 into a library accessable by LibStub.\
\
Since Blizzards new xml error handling it is a problem to use xml templates in libraries. I've converted the templates into lua functions.


## The XML templates are converted into lua functions
```
UIDropDownMenuButtonTemplate into <lib>.Create_DropDownMenuButton(<name>[,<parent>[,<optsTable>]]>
UIDropDownListTemplate into <lib>.Create_DropDownMenuList(<name>[,<parent>[,<optsTable>]]>
UIDropDownMenuTemplate into <lib>.Create_DropDownMenu(<name>[,<parent>[,<optsTable>]]>
```
Currently the optsTable can contain only one usable entry. { id=<number> }

## Example
```lua
local lib = LibStub("LibDropDownMenu");
local menuFrame = lib.Create_DropDownMenu("MyAddOn_DropDownMenu",UIParent); -- instead of template UIDropDownMenuTemplate
local menuList = {
	{ text="TestTitle", isTitle=true },
	{ text="TestFunction", isNotRadio=true, notCheckable=false }
};
lib.EasyMenu(menuList,menuFrame,"cursor",0,0,"MENU");
```

## In .pkgmeta file
```yaml
externals:
  libs/LibDropDownMenu:
    url: https://github.com/HizurosWoWAddOns/LibDropDownMenu
    tag: latest
```

## My other projects
* [On Curseforge](https://www.curseforge.com/members/hizuro_de/projects)
* [On Github](https://github.com/HizurosWoWAddOns?tab=repositories)

## Disclaimer
> World of Warcraft© and Blizzard Entertainment© are all trademarks or registered trademarks of Blizzard Entertainment in the United States and/or other countries. These terms and all related materials, logos, and images are copyright © Blizzard Entertainment.
