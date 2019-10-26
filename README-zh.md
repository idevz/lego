# 乐高 / [Lego][lego]

```bash
   ██▓    ▓█████   ▄████  ▒█████  
  ▓██▒    ▓█   ▀  ██▒ ▀█▒▒██▒  ██▒
  ▒██░    ▒███   ▒██░▄▄▄░▒██░  ██▒
  ▒██░    ▒▓█  ▄ ░▓█  ██▓▒██   ██░
  ░██████▒░▒████▒░▒▓███▀▒░ ████▓▒░
  ░ ▒░▓  ░░░ ▒░ ░ ░▒   ▒ ░ ▒░▒░▒░ 
  ░ ░ ▒  ░ ░ ░  ░  ░   ░   ░ ▒ ▒░ 
    ░ ░      ░   ░ ░   ░ ░ ░ ░ ▒  
      ░  ░   ░  ░      ░     ░ ░  
```

本项目是 runX 的乐高积木版，灵感来自对 [runX][runX]、[k8s-start][k8s-start]、wtool（微博内部工具包）
几个项目的总结，旨在像搭积木一样来组合各种系统部署、管理功能，高效的代码复用、提高工作效率、解放双手。

## 主要功能及思想

* 快速搭建实验环境，部署 pvm(Parallels Virtual Machines)，并通过 prlctl 工具来管理 pvm
* 分为内建和第三方两类模块，模块的组织方式相同，功能都由各模块下 `legoes` 目录下的脚本提供
* 默认会根据 `lego/legoes/export` 文件中的配置及顺序自动载入 lego 目录下的通用函数库及功能
* 分为命令和模块函数两种函数类型，尽管理论上它们都可以被直接调用，但它们的命名方式和功能定位都不一样
* 模块函数是每个模块中，各种零散功能的封装；命名方式为 "命令::模块名::函数名"，比如 "pvm::deploy::init_etc"
  表示的是 pvm 这个命令下，deploy 模块中的 init_etc 这个功能函数，原则上避免直接调用，
  但是如果一定需要直接调用的话，对应的命令为 `o pvm deploy::init_etc`
* 命令函数则是各种命令运行的载体，是对 ”模块函数“ 的封装和组合，乐高的思想主要体现在这个部分；
  命名方式直接是 "命令名称"，而需要特别注意的是命令函数只能在各模块的 "helpers.sh" 文件中定义，
  文件名必须是 "helpers.sh"，比如 ”pvm/legoes/helpers.sh“ 中的 "start" 函数，其对应的命令为 `o pvm start`
* 除了 lego 目录下的全局模块外，其它的函数功能都是通过命令反推加载对应的文件，同时与自动补全对接（自动补全还未实现）

## TODO

* [自动补全][auto_completion]
* 在线安装
* 添加、删除模块

[lego]:https://github.com/idevz/lego/blob/master/README.md
[auto_completion]:https://www.infoq.cn/article/bash-programmable-completion-tutorial
[runX]:https://github.com/idevz/runx
[k8s-start]:https://github.com/idevz/k8s-start
