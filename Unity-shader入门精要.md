# Unity-shader入门精要

记录我阅读**Unity shader入门精要**的笔记, 并且本个项目下面应该也会记录我跟随全书的代码

官方源代码地址: <https://github.com/candycat1992/Unity_Shaders_Book>

先介绍环境(如果疏漏会逐渐补充):

* OS: Windows10
* IDE: vscode
  * extension: markdown all in one

## 欢迎来到Shader的世界

大体的介绍了一下全书结构, 鼓励了一下菜鸟们继续学习

## 渲染流水线

Dx11的渲染管线大致了解了一下, 可以借此机会深入理解

### 综述

shader只是渲染流水线中的一个部分

#### 什么是流水线

性能瓶颈出现在流水线中最慢工序
