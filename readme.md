# cnnmmd

[eng (English)](#Overview) | [jpn (日本語)](#概要)

## Overview

This is a tool that connects various characters with various AI engines.

![img](https://cnnmmd.xoxxox.net/img/dscmov_cmf.jpg)

For more details, see: [https://cnnmmd.xoxxox.net/doc/eng/](https://cnnmmd.xoxxox.net/doc/eng/public.htm)

## Installation

Follow the steps below to install — first, retrieve and set up the plugin management tool:

```
$ cd ${dirtop} # any directory  
$ git clone https://github.com/cnnmmd/cnnmmd
$ cd ${dirtop}/cnnmmd/manage/bin
$ ./manage.sh create manage
```

From the management tool, you can then add, remove, start, or stop all plugins (including the core of this tool):

```
$ cd ${dirtop}/cnnmmd/manage/bin
$ ./manage.sh create ${plugin} # add/update
$ ./manage.sh delete ${plugin} # remove

$ ./manage.sh launch ${plugin} # start
$ ./manage.sh finish ${plugin} # stop
```

For more details, see: [https://cnnmmd.xoxxox.net/doc/eng/howist.htm](https://cnnmmd.xoxxox.net/doc/eng/howist.htm)

## 概要

各種キャラクタと各種 AI エンジンをつなげるツールです。

![img](https://cnnmmd.xoxxox.net/img/dscmov_cmf.jpg)

詳細は、こちらを参照：[https://cnnmmd.xoxxox.net/doc/jpn/](https://cnnmmd.xoxxox.net/doc/jpn/public.xht)

## 設置

次の手順でインストールしますーー最初に、プラグインの管理ツールを取得〜設置します：

```
$ cd ${dirtop} # 任意のフォルダ
$ git clone https://github.com/cnnmmd/cnnmmd

$ cd ${dirtop}/cnnmmd/manage/bin
$ ./manage.sh create manage
```

あとは管理ツールから、すべてのプラグイン群（このツールのコアふくむ）を、追加／削除／起動／停止できます:

```
$ cd ${dirtop}/cnnmmd/manage/bin

$ ./manage.sh create ${plugin} # 追加／更新
$ ./manage.sh delete ${plugin} # 削除

$ ./manage.sh launch ${plugin} # 起動
$ ./manage.sh finish ${plugin} # 停止
```

詳細は、こちらを参照：[https://cnnmmd.xoxxox.net/doc/jpn/howist.xht](https://cnnmmd.xoxxox.net/doc/jpn/howist.xht)