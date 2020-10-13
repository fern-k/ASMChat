# ✨ ASMChat

- **IDE**: [Visual Studio 2019 Community](https://visualstudio.microsoft.com/vs/older-downloads/)
- **Projects**: `Server` and `Client`


### Preparation
After clone this repo, please run `Batch/add_masm32_to_env.cmd` first, which add masm32 folder to your user enviroment variables. Our building rely on `%MASM32%/(include|lib)`.


### How to build

Right click *Solution 'ASMChat'* and choose *Properties → Build Solution* to build two projects together.

The executable files will be generated under `Build.(Debug|Release)` depending on your configure. If release mode is broken, try debug mode first.


### How to debug

The two projects were set as startup projects together, so both of them will start in debug mode when press `F5`.

- To start just one project when press F5, right click a project and choose *Properties → Set as Startup Project*.
- To start both of these projects, right click solution and choose *Properties → Common Properties → Startup Project* and select `Multiple startup projects` with Action `Start`.

Alternatively, you can just right click a project and choose *Debug → Start New Instance* without changing Startup Project.
