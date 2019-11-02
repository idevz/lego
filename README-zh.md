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

## 快速开始

只需要简单几条命令就可以快速开始 Lego。

### 安装

只需运行如下命令即可安装 Lego。

```bash
sh -c "$(curl -sSL https://raw.githubusercontent.com/idevz/lego/master/get.sh)"
# sh -c "$(curl -H 'Cache-Control: no-cache' \
#     -sSL 'https://raw.githubusercontent.com/idevz/lego/master/get.sh')"
```

### 其他命令示例

```bash
# 添加第三方模块 "idevz"
o lego add idevz
# 运行模块 "idevz" 的相关命令
o idevz your_function
```

### 自动补全

在相应的 shell .rc 文件后追加如下命令来开启命令自动补全

```bash
source $YOUR_LEGO_ROOT/lego/ac/auto-complete
```

以 zsh 为例，只需在 `~/.zshrc` 文件末尾追加上面的命令，然后执行 `source ~/.zshrc` 令追加生效，
即可完成自动补全。

```bash
# 注意，把这里的 $YOUR_LEGO_ROOT 换成你自己的 Lego 安装根目录
# 运行 `o l_status` 命令可获取当前 LEGO_ROOT 路径
echo 'source $YOUR_LEGO_ROOT/lego/ac/auto-complete' >> ~/.zshrc
```

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

## 规范及约定

* 所有功能的帮助信息都写在对应功能函数定义的前一行，Lego 会解析 shell 文件
  获取所有可用的功能及其对应的帮助信息（帮助信息不宜过长，简单说明要点即可）

## TODO

* 优化[自动补全][auto_completion]功能（比如首先对 模块进行补全，然后再补全模块后面的相关命令）
* 更新、删除模块
* `-h` 命令支持按模块名称显式相关帮助信息

[lego]:https://github.com/idevz/lego/blob/master/README.md
[auto_completion]:https://www.infoq.cn/article/bash-programmable-completion-tutorial
[runX]:https://github.com/idevz/runx
[k8s-start]:https://github.com/idevz/k8s-start
