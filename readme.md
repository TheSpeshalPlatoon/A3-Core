## 📚 Directory
Some addons are a part of [`tsp_core`](Core/src/branch/main/tsp_core) while others just depend on it. This repository contains [`tsp_core`](Core/src/branch/main/tsp_core) and any addons that are built into it such as [`tsp_ragdoll`](Core/src/branch/main/tsp_core/addons/ragdoll.sqf), [`tsp_flare`](Core/src/branch/main/tsp_core/addons/flare.sqf), etc. It also contains smaller addons that don't require their own repository.

Below you can find a directory to all of our other addon repositories:

Addon ||||
-|-|-|-
[Core]() | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
↳ Ragdoll | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
↳ Immerse | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
↳ Flares | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
↳ Tracker | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
[Animate]() | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
[Breach]() | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
Melee | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
RHS Additions | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
Gore | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()
Music | [📦]() | [📑]() | [<img style="width:17px" src="https://core.thespeshalplatoon.com/img/steam_small.png">]()

## 🗼 Structure
You may have noticed that some of the addons don't actually contain any code, why is this? Well, the addons in this particular repository are built into [`tsp_core`](Core/src/branch/main/tsp_core).

For example [`tsp_ragdoll`](Core/src/branch/main/tsp_core/addons/ragdoll.sqf) is a *dummy* addon, it has nothing in it, the code is actually in [`tsp_core\scripts\ragdoll.sqf`](Core/src/branch/main/tsp_core/addons/ragdoll.sqf), however [`tsp_ragdoll`](Core/src/branch/main/tsp_core/addons/ragdoll.sqf) must still be loaded alongside [`tsp_core`](LICore/src/branch/main/tsp_coreK) for it to function. This was done so that certain addons could serve as both a mission script and a standalone mod as [`tsp_core`](Core/src/branch/main/tsp_core) can be loaded as a mod or intergrated into a self-contained, mission file.

The addons in the other repositories are not built into [`tsp_core`](Core/src/branch/main/tsp_core) but still require it. To find the requirements for each addon, check the `requiredAddons` entry in the `config.cpp` of the addon in question.

#### Community Base Addons
Most of the addons use [Community Base Addons (CBA)](https://steamcommunity.com/workshop/filedetails/?id=450814997) for management of settings and keybinds. They can be found in the escape menu, under controls and options.

Some addons use `tsp_fnc_keybind` and `tsp_fnc_setting` instead. This is to allow the use of these addons in a mission file. If [CBA](https://steamcommunity.com/workshop/filedetails/?id=450814997) is loaded, they will show up as normal, if not, settings can be configured on the map and keybinds cannot be changed.