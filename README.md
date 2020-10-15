# ✨ ASMChat

- **Projects**: Server, Client and Util
- **Target**: Windows on x86
- **IDE**: [Visual Studio 2019 Community](https://visualstudio.microsoft.com/vs/older-downloads/)


### Preparation
After clone this repo, please run `script/add_masm32_to_env.cmd` first, which add masm32 folder to your user enviroment variables. Our building rely on `%MASM32%/(include|lib)`.


### How to build

Right click *Solution 'ASMChat'* and choose *Properties → Build Solution* will build Util project first, then build Server and Client projects together. Server and Client projects are rely on Util project to generate a shared `.lib` file.

To build just one project, right click any of them and select `Build` or `Rebuild` from menu.

Make sure the building configuration is set to x86 target instead of x64.

The executable files will be generated under `build.(Debug|Release)` depending on your configure. If release mode is broken, try debug mode first.

> The release build is unsafe for SAFESEH image, which will cause anti-virus softwares report it as a virus. to skip this error, go *project properties → Linker → Advanced → Image Has Safe Exception Handlers* and choose `No(/SAFESEH:No)`. Though compilation is successful in this way, the executable files is still rejected by most of anti-virus softwares. Debug build won't encounter this problem.


### How to debug

The two projects (Server and Client) were set as startup projects together, so both of them will start in debug mode when press `F5`.

- To start just one project when press F5, right click a project and choose *Properties → Set as Startup Project*.
- To start both of these projects, right click solution and choose *Properties → Common Properties → Startup Project* and select `Multiple startup projects` with action `Start`.

Alternatively, you can just right click a project and choose *Debug → Start New Instance* without changing Startup Project.

<br/>

------

<br/>

*If debugging is the process of removing software bugs, then programming must be the process of putting them in. -- Edsger Dijkstra*

*如果调试是消除软件bug的过程，那么编程就是产出bug的过程。 -- 艾兹格·迪科斯彻*
