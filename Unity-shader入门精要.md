# Unity-shader入门精要

## 目录

* [目录](#目录)
* [欢迎来到Shader的世界](#欢迎来到shader的世界)
* [渲染流水线](#渲染流水线)
  * [综述](#综述)
    * [什么是流水线](#什么是流水线)
    * [什么是渲染流水线](#什么是渲染流水线)
  * [CPU与GPU之间的通信](#cpu与gpu之间的通信)
    * [把数据加载进显存](#把数据加载进显存)
    * [设置渲染状态](#设置渲染状态)
    * [调用Draw Call](#调用draw-call)
  * [GPU流水线](#gpu流水线)
    * [概述](#概述)
    * [顶点着色器(Vertex Shader)](#顶点着色器vertex-shader)
    * [裁剪(Clipping)](#裁剪clipping)
    * [屏幕映射(Screen Mapping)](#屏幕映射screen-mapping)
    * [三角形设置(Triangle Setup)](#三角形设置triangle-setup)
    * [三角形遍历(Triangle Traversal)](#三角形遍历triangle-traversal)
    * [片元着色器(Fragment Shader)](#片元着色器fragment-shader)
    * [逐片元操作(Per-Fragment Operation)](#逐片元操作per-fragment-operation)
    * [总结](#总结)
  * [一些容易困惑的地方](#一些容易困惑的地方)
    * [关于Draw Call](#关于draw-call)
    * [关于固定管线渲染(Fixed Pipeline)](#关于固定管线渲染fixed-pipeline)
* [Unity Shader基础](#unity-shader基础)
  * [Unity Shader概述](#unity-shader概述)
    * [材质(Material)和Unity Shader](#材质material和unity-shader)
    * [Unity中的材质](#unity中的材质)
    * [Unity中的Shader](#unity中的shader)
  * [Unity Shader的基础: ShaderLab](#unity-shader的基础-shaderlab)
  * [Unity Shader的结构](#unity-shader的结构)
  * [Unity Shader的形式](#unity-shader的形式)
    * [表面着色器(Surface Shader)](#表面着色器surface-shader)
    * [顶点/片元着色器(本书重点使用部分)](#顶点片元着色器本书重点使用部分)
    * [固定函数着色器(别用了)](#固定函数着色器别用了)
  * [一些容易困惑的地方](#一些容易困惑的地方-1)
    * [Unity Shader != Shader](#unity-shader--shader)
    * [Unity Shader与CG/HLSL之间的关系](#unity-shader与cghlsl之间的关系)
* [学习Shader所需的数学基础](#学习shader所需的数学基础)
  * [笛卡尔坐标系](#笛卡尔坐标系)
  * [点和向量](#点和向量)
  * [矩阵](#矩阵)
    * [矩阵的几何意义: 变换](#矩阵的几何意义-变换)
  * [坐标空间](#坐标空间)
    * [模型空间(Model Space)](#模型空间model-space)
    * [世界空间(World Space)](#世界空间world-space)
    * [观察空间(View Space)](#观察空间view-space)
    * [裁剪空间(Clip Space)](#裁剪空间clip-space)
    * [屏幕空间(Screen Space)](#屏幕空间screen-space)
    * [总结](#总结-1)
  * [法线变换](#法线变换)
  * [Unity Shader的内置变量](#unity-shader的内置变量)
  * [一些容易困惑的地方](#一些容易困惑的地方-2)
    * [使用3\*3矩阵还是4\*4矩阵](#使用33矩阵还是44矩阵)
    * [CG中的矢量与矩阵类型](#cg中的矢量与矩阵类型)
    * [Unity中的屏幕坐标: ComputeScreenPos/VPOS/WPOS](#unity中的屏幕坐标-computescreenposvposwpos)
* [开始Unity Shader学习之旅](#开始unity-shader学习之旅)
  * [环境介绍](#环境介绍)
  * [一个最简单的顶点/片元着色器](#一个最简单的顶点片元着色器)
    * [顶点/片元着色器的基本结构](#顶点片元着色器的基本结构)
    * [模型数据从哪来](#模型数据从哪来)
    * [顶点着色器和片元着色器之间如何通信](#顶点着色器和片元着色器之间如何通信)
    * [如何使用属性](#如何使用属性)
  * [Unity提供的内置文件和变量](#unity提供的内置文件和变量)
  * [Unity提供的CG/HLSL语义](#unity提供的cghlsl语义)
    * [Unity支持的语义](#unity支持的语义)
  * [Shader的debug](#shader的debug)
    * [使用假彩色图像](#使用假彩色图像)
    * [通过VS](#通过vs)
    * [通过Unity的帧调试器(Frame Debugger)](#通过unity的帧调试器frame-debugger)
  * [小心渲染平台的差异](#小心渲染平台的差异)
    * [渲染纹理坐标的差异](#渲染纹理坐标的差异)
    * [Shader语法差异](#shader语法差异)
    * [Shader语义差异](#shader语义差异)
  * [Shader整洁之道](#shader整洁之道)
    * [float half fixed](#float-half-fixed)
    * [避免不必要的计算](#避免不必要的计算)
    * [慎用分支与循环](#慎用分支与循环)
    * [不要除以0](#不要除以0)
* [Unity中的基础光照](#unity中的基础光照)
  * [我们是如何看到这个世界的](#我们是如何看到这个世界的)
    * [光源](#光源)
    * [吸收与散射](#吸收与散射)
    * [着色(shading)](#着色shading)
    * [BRDF光照模型](#brdf光照模型)
  * [标准光照模型](#标准光照模型)
    * [逐像素还是逐顶点计算](#逐像素还是逐顶点计算)
  * [Unity中的环境光与自发光](#unity中的环境光与自发光)
  * [在Unity Shader中实现漫发射光照模型](#在unity-shader中实现漫发射光照模型)
    * [逐顶点光照的实现](#逐顶点光照的实现)
    * [逐像素光照的实现](#逐像素光照的实现)
    * [半兰伯特(Half Lambert)模型](#半兰伯特half-lambert模型)
  * [在Unity Shader中实现高光反射光照模型](#在unity-shader中实现高光反射光照模型)
    * [实践: 逐顶点光照](#实践-逐顶点光照)
    * [实践: 逐像素光照](#实践-逐像素光照)
    * [Blinn-Phong光照模型](#blinn-phong光照模型)
  * [使用Unity内置的函数](#使用unity内置的函数)
* [基础纹理](#基础纹理)
  * [单张纹理](#单张纹理)
  * [凹凸映射(bump maping)](#凹凸映射bump-maping)
    * [实现](#实现)
    * [Unity中的法线纹理类型](#unity中的法线纹理类型)
  * [渐变纹理](#渐变纹理)
  * [遮罩纹理(Mask Texture)](#遮罩纹理mask-texture)
* [透明效果](#透明效果)
  * [为什么渲染顺序很重要](#为什么渲染顺序很重要)
  * [Unity Shader的渲染顺序](#unity-shader的渲染顺序)
  * [透明度测试](#透明度测试)
  * [透明度混合](#透明度混合)
  * [开启深度写入的半透明效果](#开启深度写入的半透明效果)
  * [ShaderLab的混合命令](#shaderlab的混合命令)
    * [混合等式和参数](#混合等式和参数)
    * [混合操作](#混合操作)
    * [常见的混合类型](#常见的混合类型)
    * [双面渲染的透明效果](#双面渲染的透明效果)
* [更复杂的光照](#更复杂的光照)
  * [Unity的渲染路径](#unity的渲染路径)
    * [前向渲染路径](#前向渲染路径)
    * [顶点照明渲染路径](#顶点照明渲染路径)
    * [延迟渲染路径](#延迟渲染路径)
  * [Unity的光源类型](#unity的光源类型)
    * [光源类型有什么影响](#光源类型有什么影响)
    * [在前向渲染中处理不同的光源类型](#在前向渲染中处理不同的光源类型)
  * [Unity的光照衰减](#unity的光照衰减)
    * [用于光照衰减的纹理](#用于光照衰减的纹理)
  * [Unity的阴影](#unity的阴影)
    * [阴影是如何实现的](#阴影是如何实现的)
    * [不透明物体的阴影](#不透明物体的阴影)
    * [统一管理光照衰减和阴影](#统一管理光照衰减和阴影)
    * [透明度物体的阴影](#透明度物体的阴影)
* [高级纹理](#高级纹理)
  * [立方体纹理](#立方体纹理)
    * [天空盒子(Skybox)](#天空盒子skybox)
    * [用于环境映射的立方体纹理](#用于环境映射的立方体纹理)
    * [反射](#反射)
    * [折射](#折射)
    * [菲涅尔反射](#菲涅尔反射)
  * [渲染纹理](#渲染纹理)
    * [镜子效果](#镜子效果)
    * [玻璃效果](#玻璃效果)
    * [渲染纹理 vs. GrabPass](#渲染纹理-vs-grabpass)
  * [程序纹理(Procedural Texture)](#程序纹理procedural-texture)
    * [实现简单的程序纹理](#实现简单的程序纹理)
    * [Unity的程序材质](#unity的程序材质)

## 欢迎来到Shader的世界

大体的介绍了一下全书结构, 鼓励了一下菜鸟们继续学习

## 渲染流水线

Dx11的渲染管线大致了解了一下, 可以借此机会深入理解

### 综述

shader只是渲染流水线中的一个部分

#### 什么是流水线

性能瓶颈出现在流水线中最慢工序, 理想状态下一个非流水系统分为 n 个时长相同的流水线阶段, 整个系统得到 n 倍速度提升

#### 什么是渲染流水线

*Real-Time Rendering, Third Edition* 提到的三个概念性阶段:
应用阶段(Application Stage) 几何阶段(Geometry Stage) 光栅化阶段(Rasterizer Stage)

##### 应用阶段

由应用主导, 通过CPU负责, 主要任务有三个

* 准备场景数据: 摄像机位置, FOV, 模型, 光源等
* 粗粒度剔除(Culling): 不可见的片面剔除(原来culling的翻译是这个)
* 设置渲染状态: 设置渲染材质, 纹理, shader, 输出渲染图元(Rendering primitives), 将点线面这样的渲染图元传递给几何阶段

本书非重点部分

##### 几何阶段

GPU负责, 与图元进行交互, 决定绘制什么, 如何绘制, 在哪绘制

也就是将顶点坐标变换到屏幕空间, 然后给光栅阶段, 包含坐标, 深度值, 着色等信息

##### 光栅化阶段

通过GPU产生显示在屏幕上的像素, 并渲染出最终图像

决定哪些像素会被绘制到屏幕上

### CPU与GPU之间的通信

渲染流水线起点在CPU, 也就是应用阶段, 分为以下三步

* 数据加载进显存
* 设置渲染状态
* 调用Draw Call

#### 把数据加载进显存

HDD -> RAM -> 显存, CPU将数据从硬盘放入内存, 然后被加载到GPU能够直接访问的显存上, 之后移除内存内容, 最后通过CPU设置渲染状态来控制GPU

#### 设置渲染状态

定义网格如何被渲染: 包括材质, 光源属性, 各种着色器等等

#### 调用Draw Call

由CPU发起, 交给GPU, 对象是一个需要被渲染的图元列表

调用后, 根据之前的渲染状态和数据进行计算渲染, 最终呈现到屏幕像素上

### GPU流水线

针对的是GPU得到CPU的渲染命令进行的流水线流程, 将图元渲染到屏幕上

#### 概述

简单的介绍, 光栅化阶段可以详细看看

#### 顶点着色器(Vertex Shader)

* 坐标变换: 从模型空间转换到齐次裁剪空间, 之后由硬件进行透视除法,
最终得到一个归一化的设备坐标(Normalized Device Coordinates, NDC)
* 逐顶点光照

#### 裁剪(Clipping)

将部分在视野外的图元进行处理, 产生新的顶点信息, 抛弃旧的在视野外的顶点

#### 屏幕映射(Screen Mapping)

将三维坐标转换为二维坐标

OpenGL与DirectX的差异: 前者规定(0,0)为左下角, 后者规定为左上角

#### 三角形设置(Triangle Setup)

计算光栅化一个三角网格所需要的信息

#### 三角形遍历(Triangle Traversal)

检查每个像素是否被三角网格覆盖, 如果有则生成片元(fragment)(听着就牛逼的翻译), 又称扫描变换(Scan Conversion)

片元中的状态是对三个顶点的信息进行插值得到的
例如, 对图2.12中三个顶点的深度进行插值得到其重心位置对应的片元的深度值为-10.0

片元是包含了很多状态的集合(并不是一个像素点), 比如坐标, 深度信息, 以及之前输出的顶点信息, 如法线, 纹理坐标

![三角形遍历](images/2.12.png)

#### 片元着色器(Fragment Shader)

在Dx中称为**像素着色器(Pixel Shader)**

这里可以进行**纹理采样**, 通常在顶点着色器中输入纹理坐标
经过光栅化三个阶段对三角网格三个顶点进行插值就可以得到覆盖片元的纹理坐标

![片元着色器的计算](images/2.13.png)

而上述的计算只能应用于独立的每一个片元, 无法将自己的结果发给其他片元

**例外情况:** 片元着色器可以访问导数信息(gradient or derivative), 详见扩展

TODO[]: 后面补充一个链接

#### 逐片元操作(Per-Fragment Operation)

Dx中称为**输出合并阶段(Output Merger)**

* 决定每个片元可见性
* 片元颜色与颜色缓冲区的颜色合并或者说混合(Blending)

下面这张图, 就让我知道了啥是**深度模板缓冲(Depth/Stencil)**

![深度模板缓冲](images/2.14.png)

只有通过了所有的测试后, 新生成的片元才能和颜色缓冲区中已经存在的像素颜色进行混合, 最后再写入颜色缓冲区中

如果没有通过测试, 则片元舍弃

![深度模板测试流程](images/2.15.png)

* 模板测试通常用于限制渲染区域, 还可以用于渲染阴影, 轮廓渲染等等
* 深度测试用于覆盖, 即离摄像机更远的片元深度更大, 因此会被舍弃, 从而只显示更近的
* 注意:
  * 没通过深度测试, 被丢弃的片元不能更改深度缓冲的值
  * 无论是否通过模板测试, 都能对模板缓冲进行更改

之后就是合并部分, 每个像素信息都被存在了颜色缓冲中, 一个接着一个物体渲染就需要考虑是否进行覆盖之类的

* 不透明的物体可以关闭混合(Blending), 这样就可以直接覆盖
* 半透明的物体就需要混合来产生透明的效果

![混合流程](images/2.16.png)

不过测试顺序不唯一, 可能在片元着色器之前就测试, 这样降低生成片元的数量

另外片元中不包含透明度信息, 因此与测试冲突

#### 总结

不同资料在此处提及不同, 可能是不同图形接口, 也可能是GPU进行不同的底层优化

### 一些容易困惑的地方

不太困惑的地方就看一遍跳过

#### 关于Draw Call

本质: CPU调用图像编程接口, 如DX中的DrawIndexedPrimitive

* CPU和GPU是如何实现并行工作的?

使用命令缓冲区(command buffer), CPU向其中的命令队列加命令, GPU读命令, Draw Call属于其中的命令之一

* 为何Draw Call次数多会影响帧率

CPU会消耗大量资源向GPU发送内容, 而GPU进行渲染速度很快, 因此GPU会闲

* 如何减少Draw Call次数

方法很多, 这里只说了批处理(Batching), 比较适合静态的物体
将多个静态物体合并网格(相当于合并小的Draw Call形成一个大的)

![合并成一个Draw Call进行渲染](images/2.21.png)

合并也比较消耗CPU, 因此注意

* 避免使用大量的小网格并考虑能否合并
* 避免使用过多材质, 使得不同网格共用一个材质(说的就是你们那些艺术家, 创意工坊的资产片面用那么多, 游戏里又体现不出来, 老夫的1060在咆哮了)

#### 关于固定管线渲染(Fixed Pipeline)

固定函数的流水线也就是固定管线

提供了一系列接口, 这些接口包含了一个特定功能的函数入口点

是被淘汰掉的玩意儿(目前用可编程管线来模拟)

## Unity Shader基础

前面的示例代码让我想起了隔壁的项目Dx11Tutorial, 好复杂

### Unity Shader概述

#### 材质(Material)和Unity Shader

通常流程:

* 创建一个material
* 创建一个Unity Shader, 赋予之前的material
* material赋予给渲染对象
* material面板调整Shader属性

Shader中带有渲染所需的代码, 属性, 指令
我们可以通过material来调节这些属性, 并赋予给相应的模型

#### Unity中的材质

简单的介绍了一下

#### Unity中的Shader

* standard surface shader: 包含标准光照模型的表面着色器模板
* Unlit shader: 不包含光照但包含雾效的基本顶点片元着色器(本文常用)
* Image Effect Shader: 各种屏幕后处理效果的模板
* Compute Shader: 特殊的shader文件, 利用GPU并行性进行与常规渲染流水线无关的计算(与本文无关)

### Unity Shader的基础: ShaderLab

一种专门为Unity Shader服务的语言

类似DirectX的Effects语言(.FX)

### Unity Shader的结构

非常粗糙地介绍了一遍, 懂的人肯定自然就懂, 对于我这种Unity都没用过几次, 从未接触过Unity Shader的人来看
看了等于白看, 可能Unity版本太新?可能文章后面会详细介绍?

### Unity Shader的形式

shader的代码基本被包含在shaderLab语义块中

#### 表面着色器(Surface Shader)

Unity自创的, 渲染代价高, 还是将代码转换成对应的顶点/片元着色器, 是对顶点/片元着色器的一层抽象

HLSL编写的代码块嵌套在subshader中的CGPROGRAM和ENDCG中

```Unity Shader
Shader "Custom/Template"{
    SubShader{
        Tags{"RenderType"="Opaque"}
        CGPROGRAM
        #pragma surface surf Lambert
        //CG/HLSL代码块

        ENDCG
    }
    Fallback "Diffuse"
}
```

#### 顶点/片元着色器(本书重点使用部分)

和表面着色器一样, HLSL编写的代码块嵌套在CGPROGRAM和ENDCG中, 但是顶点/片元着色器写在PASS语义块中

#### 固定函数着色器(别用了)

用于支持老旧的固定管线

### 一些容易困惑的地方

#### Unity Shader != Shader

Unity Shader实际上是一个.shader后缀的ShaderLab文件, 与第二章的shander不同

两者对比:

* 传统shader只可以编写特定的着色器, Unity Shader可以在同一个文件中包含需要的顶点着色器与片元着色器
* 传统shader无法进行渲染设置, 如混合开启, 深度模板测试等等, Unity Shader可以通过一行特定的指令完成设置
* 传统shader代码冗长, Unity Shader只需要在特定语句块中声明一些属性, 且拥有许多模板自带的属性
* 传统shader比Unity Shader更加灵活, 可以提供更多种类着色器

#### Unity Shader与CG/HLSL之间的关系

可以通过CG/HLSL语言在Shaderlab内部嵌套来实现表面着色器与片元着色器

## 学习Shader所需的数学基础

### 笛卡尔坐标系

* 二维笛卡尔坐标系:
  * 包含一个原点+两条过原点互相垂直的基矢量(basis vector)
* 三维笛卡尔坐标系:
  * 一个原点+三条互相垂直的基矢量
    * 标准正交基(orthnormal basis): 长度为1互相垂直
    * 正交基(orthogonal basis): 互相垂直长度不为1
* 左手坐标系与右手坐标系使得坐标指向不同
  * 二维坐标系可以通过简单的旋转使得xy两轴指向的方向一致
  * 三维则做不到上述, 因此需要划分左右手坐标系
  * 旋向性(handedness), 相同的旋向性就能通过旋转使得他们坐标重合
* 左右手法则: 用来确定不同坐标系对正向旋转的定义
  * 为了达到同样的视觉效果, 不同坐标系经过的数学运算也不同, 因此可能需要用到坐标系的转换
* Unity使用的坐标系:
  * 模型空间与世界空间: 左手坐标系
  * 观察空间: 右手坐标系

### 点和向量

* 点积(dot): 几何意义是投影
  * 可用于比较两个向量模的大小: 不开方以降低运算量
* 叉积(cross product & outer product): 几何意义是构成平行四边形, 从而判断片面的方向
  * 获得同时垂直于两个矢量的新矢量
  * 方向判断: 左手坐标系下用左手法则, 右手坐标系下用右手法则

### 矩阵

一些简单的介绍, 属于线代最基础部分

* 方阵
* 单位阵
* 转置矩阵
* 逆矩阵
* 正交阵: 方阵的转置等于其逆

#### 矩阵的几何意义: 变换

##### 什么是变换

* 线性变换: 包括旋转, 缩放, 错切(shear), 镜像(reflection), 正交投影(orthographic projection)等等
  * 满足标量乘法和矢量加法
  * 使用一个3*3的矩阵就可以表示所有的线性变换

$$
f(x)+f(y)=f(x+y)\\
kf(x)=f(kx)
$$

* 仿射变换(affine transform): 线性变换+平移变换
  * 平移变换: 只满足标量乘法
  * 使用4*4的矩阵表示, 因此需要将矢量扩展到四维空间, 也就是齐次坐标空间(homogeneous space)

##### 齐次坐标(homogeneous coordinate)

三维坐标通过w=1转换成齐次坐标

一个方向矢量通过w=0转换

##### 分解基础变换矩阵

将纯平移 纯缩放 纯旋转称为基础变换矩阵

$$
\begin{matrix}
  M_{3*3} & t_{3*1}\\
  0_{1*3} & 1
\end{matrix}
$$

其中左上角的3*3矩阵表示旋转与缩放, 右上角的3*1矩阵用于平移, 左下角1*3矩阵是零矩阵, 右下角的元素标量为1

##### 平移矩阵

通过以下矩阵的乘法对一个点进行平移变换

$$
\left [
\begin{matrix}
  1 & 0 & 0 & t_x\\
  0 & 1 & 0 & t_y\\
  0 & 0 & 1 & t_z\\
  0 & 0 & 0 & 1
\end{matrix}
\right ]

\left [
\begin{matrix}
  x\\
  y\\
  z\\
  1
\end{matrix}
\right ]
=
\left [
\begin{matrix}
  x+t_x\\
  y+t_y\\
  z+t_z\\
  1
\end{matrix}
\right ]

$$

很显然, 平移变换不会改变方向矢量(因为矢量没有位置属性, 对位置的修改不会对其本身进行改变)

##### 缩放矩阵

$$
\left [
\begin{matrix}
  k_x & 0 & 0 & 0\\
  0 & k_y & 0 & 0\\
  0 & 0 & k_z & 0\\
  0 & 0 & 0 & 1
\end{matrix}
\right ]

\left [
\begin{matrix}
  x\\
  y\\
  z\\
  1
\end{matrix}
\right ]
=
\left [
\begin{matrix}
  k_xx\\
  k_yy\\
  k_zz\\
  1
\end{matrix}
\right ]
$$

若$k_x=k_y=k_z$则称之为**统一缩放**(uniform scale),
否则则是非统一缩放(nonuniform scale), 后者会挤压或拉伸模型, 改变一些角度与比例信息

##### 旋转矩阵

正交阵, 其逆运算表示相反方向的旋转

##### 复合变换

将上述三种矩阵合并, 使用下列公式

$$
P_{new}=M_{translation}M_{rotation}M_{scale}P_{old}
$$

其中, 旋转的复合形式需要考虑旋转的形式, 有以下两种形式, 可以通过改变旋转顺序来得到同一个结果:

* 绕着固定的坐标系对三个坐标轴进行旋转
* 每对一个坐标轴进行旋转后, 整个坐标系也随着坐标系旋转, 得到的新坐标系后再进行旋转

### 坐标空间

坐标空间具有层次结构, 即每个坐标空间都有个父空间, 对坐标空间的变换实际上就是父空间与子空间之间对点和矢量进行变换

可以通过转换矩阵来实现点或矢量从一个空间到另一个空间的转换, 反过来的转换可以使用这个转换矩阵的逆矩阵

下面举个例子来推导转换矩阵的计算过程

$$
已知子坐标空间的一个点 A_c(a,b,c), 通过四步得到在父坐标空间的位置 A_P\\

从原点开始, 向x y z三个轴方向位移, 得到:\\

A_P=\vec{O_c}+a\vec{x_c}+b\vec{y_c}+c\vec{z_c}\\

\Rightarrow
A_P=(x_{oc},y_{oc},z_{oc})+
\left [
\begin{matrix}
  | & | & |\\
  \vec{x_c} & \vec{y_c} & \vec{z_c}\\
  | & | & |
\end{matrix}
\right ]
\left [
\begin{matrix}
  a\\
  b\\
  c
\end{matrix}
\right ]\\

为了使得形式更加简单
需要使用4*4矩阵来将矩阵的平移由加法转换为乘法\\

扩展到齐次坐标空间\\

\Rightarrow
A_P=(x_{oc},y_{oc},z_{oc},1)+
\left [
\begin{matrix}
  | & | & | & 0\\
  \vec{x_c} & \vec{y_c} & \vec{z_c} & 0\\
  | & | & | & 0\\
  0 & 0 & 0 & 1
\end{matrix}
\right ]
\left [
\begin{matrix}
  a\\
  b\\
  c\\
  1
\end{matrix}
\right ]\\

\Rightarrow A_P=
\left [
\begin{matrix}
  1 & 0 & 0 & x_{oc}\\
  0 & 1 & 0 & y_{oc}\\
  0 & 0 & 1 & z_{oc}\\
  0 & 0 & 0 & 1
\end{matrix}
\right ]
\left [
\begin{matrix}
  | & | & | & 0\\
  \vec{x_c} & \vec{y_c} & \vec{z_c} & 0\\
  | & | & | & 0\\
  0 & 0 & 0 & 1
\end{matrix}
\right ]
\left [
\begin{matrix}
  a\\
  b\\
  c\\
  1
\end{matrix}
\right ]\\

\Rightarrow
A_P=
\left [
\begin{matrix}
  | & | & | & |\\
  \vec{x_c} & \vec{y_c} & \vec{z_c} & \vec{O_c}\\
  | & | & | & |\\
  0 & 0 & 0 & 1
\end{matrix}
\right ]
\left [
\begin{matrix}
  a\\
  b\\
  c\\
  1
\end{matrix}
\right ]\\
$$

在shader中, 通常使用变换矩阵的右上角3*3方阵来对法线方向与光照方向进行空间变换, 就是因为这些变换不涉及平移变换

如果变换矩阵是正交阵的话, 我们可以提取出这个矩阵的第一列, 得到坐标空间A中的x轴在另一个坐标空间中的表示

#### 模型空间(Model Space)

又称对象空间(Object Space)或局部空间(Local Space), 每个对象都有自己独立的坐标空间

在模型空间中使用上下左右前后等方向概念, 本书称为自然方向

Unity中规定, +x对应的右, +y对应的上, +z对应的前

#### 世界空间(World Space)

通过Unity中的Transform组件中的Position属性进行调整, 如果有父节点则以其父节点模型坐标空间的原点定义Position

顶点变换的第一步就是将坐标从模型空间转换至世界空间, 称之为模型变换(Model Transform)

#### 观察空间(View Space)

又称摄像机空间(Camera Space)

Unity的坐标轴选择为, +x右方, +y上方, +z摄像机后方, 也就是在观察空间中使用右手坐标系(继承于OpenGL)

顶点从世界空间转换到观察空间是称为观察转换(View Transform), 是顶点变换的第二步

* 可以通过转换矩阵, 使得顶点从世界空间变换到观察空间
* 也可以通过位移观察摄像机至世界空间原点, 使得坐标轴与世界空间的坐标轴重合

#### 裁剪空间(Clip Space)

又称齐次裁剪空间, 使用裁剪矩阵(Clip Matrix), 又称投影矩阵(Projection Matrx)

处于本空间内的图元将会被保留, 在该空间之外的将会被剔除, 与空间边界相交的将会被裁切, 是否被裁切取决于视锥体(View Frustum)

* 视锥体: dx11教程中的Note有讲
  * 正交投影(orthographic projection): 完全保留物体的距离与角度, 常用于2D游戏中
  * 透视投影(perspective projection): 模拟人眼, 近大远小, 常用于3D游戏中

如果直接使用视锥体进行物体裁切, 那么不同视锥体就需要不同的处理过程, 计算复杂, 因此通过一个投影矩阵将顶点转换到裁切空间中

投影矩阵具有以下两个作用:

* 为投影做准备: 真正的投影是后方的齐次除法(homogeneous division), 这里的准备是为顶点w分量赋予正确的含义(距离摄像机的距离)
* 对xyz分量进行缩放, 经过缩放后直接根据w分量来判断顶点是否在裁剪空间内(缩放前w分量固定为1, 方向矢量固定为0)

##### 透视投影

* 六个裁切平面构成一个锥体
* 六个裁切平面的定义通过Unity中的从camera组件中的参数与Game视图的横纵比决定
  * camera的FOV
  * clipping planes的Near与Far参数
  * 摄像机的横纵比: Game的横纵比+Viewport Rect中的W H属性

裁剪矩阵改变了空间的旋向性, 因此原来是观察空间右手坐标系转换成了裁剪空间左手坐标系

##### 正交投影

* 六个裁切平面构成一个长方体
* 平面的定义如之前的透视投影
* 进行矩阵变换后, w分量依旧为1

#### 屏幕空间(Screen Space)

将视锥体投影到屏幕空间, 得到真正的二维空间坐标

首先进行**标准齐次除法**(homogeneous division), 又称**透视除法**(perspective division),
在OpenGL中称**归一化设备坐标**(Normalized Device Coordinates, NDC)

经过透视除法后, 原本的锥型裁剪空间(视锥体)最终变成了一个立方体(正交投影原本就是一个立方体),
因此正交投影和透视投影的视锥体在透视除法之后都变换到了一个相同的立方体内

x y分量用于投影到屏幕, z分量用于深度缓冲

#### 总结

![顶点变换的过程](images/4.45.png)

其中只有观察空间是右手坐标系

### 法线变换

顶点中通常带有额外信息, 顶点法线(Normal & Normal Vector)就是其中之一, 用于后续处理中计算光照等等

变换法线使用之前的同一个变换矩阵可能无法保证法线的垂直性, 为了了解这个问题的产生我们引入切线(tangent & tangent vector)

* 切线与纹理空间对齐(平行), 与法线垂直
* 切线通过两个顶点的差值计算, 因此直接通过变换矩阵来进行切线变换
  * 这样变换后, 得到的新法线方向可能不与表面垂直, 因此增加新法线需要与表面垂直这个约束条件
    * 如果变换只有旋转, 那么变换矩阵就是正交阵, 可以直接通过变换矩阵来进行法线变换
    * 如果变换包含旋转和统一缩放(等比例缩放), 不包含非统一缩放, 可以利用统一缩放系数来得到变换矩阵的逆转置
    * 如果包含了非统一缩放, 就需要求解逆矩阵来得到法线变换矩阵

### Unity Shader的内置变量

本章节对Unity中自带的一些变量进行介绍, 需要用到的时候可以自行查阅Unity的官方文档

注意: 不同版本的Unity自带的变量也会不一样

### 一些容易困惑的地方

#### 使用3\*3矩阵还是4\*4矩阵

只有线性变换则使用3*3, 例如针对方向向量的变换(位移变换对其没有影响)

有平移变换的就使用4*4矩阵

注意: 变换前坐标需要转换成齐次坐标

#### CG中的矢量与矩阵类型

CG中矩阵类型都是类似float3\*3 float4\*4之类的, 而对于float3 float4这类变量, 即可以当成一个矢量, 也可以当成一个1\*n行矩阵或n*1列矩阵

注意: CG中对矩阵进行填充是以行优先, 而Unity脚本中矩阵类型Matrix4*4使用列优先, 与Unity Shader中不同

#### Unity中的屏幕坐标: ComputeScreenPos/VPOS/WPOS

可以通过两种方法获得片元的屏幕坐标

* 在片元着色器中的输入声明VPOS与WPOS语义
  * VPOS是HLSL中对屏幕坐标的语义, WPOS是CG中对屏幕坐标的语义, 两者在Unity Shader中等价
    * 是个float4类型
      * xy代表屏幕坐标
      * z代表摄像空间中距离近裁切面与远裁切面的距离(0~1)
      * 如果是正交投影则w恒为1, 如果是透视投影, 则w范围$[\frac{1}{Near},\frac{1}{Far}]$
    * 最后将屏幕空间除以屏幕分辨率得到视口空间坐标
      * 视口空间就是屏幕归一化, 左下角(0,0) 右上角(1,1)
* 通过Unity提供的ComputeScreenPos函数
  * 顶点着色器中保存结果
  * 片元着色器进行齐次除法后得到视口空间的坐标
    * 为啥不一步到位: 顶点着色器到片元着色器中有一个插值的过程, 插值前进行除法会使得插值结果不正确
  * zw的值就是插值过后裁剪空间中的zw值

## 开始Unity Shader学习之旅

### 环境介绍

[README](README.md)

### 一个最简单的顶点/片元着色器

[SimpleShader](/New%20Unity%20Project/Assets/Shader/Chapter5/SimpleShader.shader)

#### 顶点/片元着色器的基本结构

* 无需Properties, 非必须
* Subshader中不需要进行任何渲染设置与标签设置, 因此使用默认设置
  * 定义了一个Pass, 其中同样没有进行设置
    * 其中CGPROGRAM与ENDCG包围了CG代码片段, **本次重点**

#### 模型数据从哪来

自定义的结构体结构如下

```shaderlab
struct StructName{
    Type Name : Semantic;
};
```

其中语义的数据从Unity中的使用该材质的Mesh Render组件提供, 每帧调用Draw Call的时候, Mesh Render
将它负责的渲染模型数据发送给Unity Shader

#### 顶点着色器和片元着色器之间如何通信

* 顶点着色器的输出结构必须包含SV_POSITION结构, 否则渲染器无法得到裁剪空间中的坐标, 从而无法将顶点渲染到屏幕上
* 顶点着色器是逐顶点调用, 片元着色器逐片元调用, 片元着色器的输入实际上就是把顶点着色器的输出进行插值后得到的结果

#### 如何使用属性

写在properties中的属性, 需要在CG代码中声明一个与属性对应的类型变量才能够访问(废话 不同代码块当然要这样)

| ShaderLab属性类型 |      CG变量类型       |
| :---------------: | :-------------------: |
|   Color, Vector   | float4, half4, fixed4 |
|   Range, Float    |  float, half, fixed   |
|        2D         |       sampler2D       |
|       Cube        |      samplerCube      |
|        3D         |       sampler3D       |

### Unity提供的内置文件和变量

包含文件(includ file), 后缀.cginc, 类似c++的头文件, 使用方法如下

```shaderlab
CGPROGRAM
//...

#include "UnityCG.cginc"

//...
ENDCG
```

### Unity提供的CG/HLSL语义

语义(semantic), 可以见微软DX的文档中<https://docs.microsoft.com/zh-cn/windows/win32/direct3dhlsl/dx-graphics-hlsl-semantics>

其中Unity会对一些语义进行特殊的规定, 以方便模型数据的传输, 如TEXCOORD0, 在a2f结构体中有"第一组纹理坐标"这个特殊含义

在DirectX10后, 有新的语义类型, 系统数值语义(system-value semantic), 开头以SV开头, 在渲染流水线中有特殊意义

#### Unity支持的语义

应用阶段传递模型数据给顶点着色器的常用语义(顶点着色器输入)

|   语义    |                 描述                  |
| :-------: | :-----------------------------------: |
| POSITION  |   模型空间中的顶点位置, 通常float4    |
|  NORMAL   |         顶点法线, 通常float3          |
|  TANGENT  |         顶点切线, 通常float4          |
| TEXCOORDn | 顶点第n组纹理坐标, 通常float2或float4 |
|   COLOR   |     顶点颜色, 通常fixed4或float4      |

顶点着色器到片元着色器

|        语义         |                     描述                     |
| :-----------------: | :------------------------------------------: |
|     SV_POSITION     | 裁剪空间的顶点坐标, 顶点到片元的结构体的必须 |
|       COLOR0        |      通常用于输出第一组顶点颜色, 非必须      |
|       COLOR1        |      通常用于输出第二组顶点颜色, 非必须      |
| TEXCOORD0~TEXCOORD7 |         通常用于输出纹理坐标, 非必须         |

片元着色器输出

|   语义    |          描述          |
| :-------: | :--------------------: |
| SV_Target | 输出值存储到渲染目标中 |

### Shader的debug

调试麻烦 没有输出 无法单步 基本上之前写的代码debug经验都很难用在这里

#### 使用假彩色图像

假彩色图像(false-color image)指的是用假彩色技术生成的一种图像, 与之相对应的是真色彩图像(true-color image)

将调试的变量映射到(0,1)之间, 并将之做为颜色输出到屏幕上

注意变量的取值范围, 针对多个变量可以逐一写测试

#### 通过VS

<https://docs.unity3d.com/cn/current/Manual/SL-DebuggingD3D11ShadersWithVS.html>

#### 通过Unity的帧调试器(Frame Debugger)

通过停止渲染来查看渲染事件

### 小心渲染平台的差异

虽然Unity的优点就是跨平台, 但有的时候需要手动去处理不同平台的差异

#### 渲染纹理坐标的差异

![OpenGL与DirectX使用不同屏幕空间坐标](images/5.8.png)

我们不仅可以把渲染结果输出到屏幕上, 还可以输出到不同的渲染目标中, 这是就需要使用渲染纹理(Render Texture)来保存渲染结果

把屏幕图像渲染到纹理中, DirectX会产生纹理翻转的情况, Unity会自动翻转

而当我们开启抗锯齿(anti aliasing)并使用到了渲染纹理中, 此时Unity不会自动翻转

TODO: 留个坑, 之后项目肯定会有涉及到这个的, 加深理解

#### Shader语法差异

DirectX相对于OpenGL对shader语义更加严格

#### Shader语义差异

* 使用SV_POSITION来描述顶点着色器输出的顶点位置
* 使用SV_Target来描述片元着色器的输出颜色

### Shader整洁之道

Shader代码的规范问题

#### float half fixed

* 桌面GPU会把所有计算按照最高精度进行计算, 因此三者等价
* 移动平台的GPU会有不同的精度范围, 确保在真正的移动平台上验证shader
  * 是手机之类的移动平台, 不是便携式PC(笔记本的GPU还不是一样和PC是A N两家的)
* fixed只在较旧的移动平台上有用, 在多数现代GPU上, fixed等同于half

#### 避免不必要的计算

Shader进行大量计算就会出现, 需要的临时寄存器不够或者指令数目超过当前可支持的数目

```ShaderLab
temporary register limit of 8 exceed
Arithmetic instruction limit of 64 exceed;
65 arithmetic instruction needed to compile program
```

通过下个表格可以指定不同等级的Shader Target来消除这些错误

Unity 5.3之后对Shader Target进行了调整，该表列出的是5.2版本及以前的Shader Target

|        指令        |                         描述                          |
| :----------------: | :---------------------------------------------------: |
| #pragma target 2.0 |      默认的等级, 相当于D3D9上的Shader Model 2.0       |
| #pragma target 3.0 |            相当于D3D9上的Shader Model 3.0             |
| #pragma target 4.0 | 相当于D3D10上的Shader Model 4.0, 只在DX11平台提供支持 |
| #pragma target 5.0 | 相当于D3D11上的Shader Model 5.0, 只在DX11平台提供支持 |

所有OpenGL平台支持Model3.0

#### 慎用分支与循环

GPU使用了与CPU不同的技术来实现分支语句, 代价会很大, 因此Shader尽量不使用分支控制

#### 不要除以0

除数可能为0的时候, 强制截取到非0范围

## Unity中的基础光照

本章主要讲光照模型的原理, 可以配合着之前的DX教程里的光照部分一起食用

### 我们是如何看到这个世界的

这个小节很基础

#### 光源

* 通过辐射度(irradiance)来量化光
  * 对于平行光而言, 通过垂直于光方向的单位面积在单位时间内穿过的能量来得到
  * 通常物体表面与光源方向不垂直, 就通过余弦计算

#### 吸收与散射

* 散射(scattering): 只改变光线方向, 不改变光线密度与颜色
  * 折射(refraction)或透射(transmission): 散射到内部
  * 反射(reflection): 散射到外部
* 吸收(absorption): 只改变光线密度与颜色, 不改变光线方向
* 使用高光反射(specular)表示物体表面如何反射
* 使用漫反射(diffuse)表示光线有多少被折射吸收散射
  * 使用出射度(exitance)来描述出射光线的数量与方向

#### 着色(shading)

根据材质属性 光源信息 使用光照模型去计算沿某个观察方向的出射度情况

#### BRDF光照模型

Bidirectional Reflection Distribution Function能够反映物体表面如何与光线进行交互的

这些光照模型都是经验模型, 是实际情况的理想化与简化版本(因此才需要光线追踪?)

### 标准光照模型

一种古老的模型, 只关注直接光照(direct light), 也就是直接从光源发出照到物体表面后, 经过一次反射直接进入摄像机的光线, 将光线分为以下四种

* 自发光(emissive): 描述一个确定方向表面会向该方向发射多少辐射量, 如果没有使用全局光照, 这些自发光的表面不会照亮周围物体
  * 直接使用该材质的自发光颜色

* 高光反射: 描述光源照到模型表面, 该表面完全镜面反射

使用Phong模型来计算高光部分

![Phong模型](images/6.3.png)

$$
c_{specular}=(c_{light}\cdot m_{specular})max(0,\vec{v} \cdot \vec{r})^{m_{gloss}}\\
其中m_{gloss}是材质光泽度(gloss), 又称反光度(shininess), 控制高光区域亮点大小\\
m_{specular}是材质高光反射颜色
$$

使用Blinn模型进行修改, 避免计算反射方向

注意: 这只是修改, 而非改良, 两者适用于不同的环境

![Blinn模型](images/6.4.png)

$$
引入
\vec{h}=\frac{\vec{v}+\vec{I}}{|\vec{v}+\vec{I}|}\\
c_{specular}=(c_{light}\cdot m_{specular})max(0,\vec{n} \cdot \vec{h})^{m_{gloss}}\\
$$

* 漫反射: 表面会向每个方向散射多少辐射量
  * 符合兰伯特定律(Lambert's law): 反射光的强度与表面法线和光源方向之间的角度余弦值成正比

$$
c_{diffuse}=(c_{light}\cdot m_{diffuse})max(0,n\cdot I)\\
其中n是表面法线, I是指向光源的单位矢量,  m_{diffuse}是材质漫发射颜色, c_{light}是光源颜色\\
使用max是为了截取范围到0, 防止负数以及后方光源点亮物体
$$

* 环境光(ambient): 描述其他所有的间接光照(indirect light)
  * 通常使用一个全局变量进行模拟, 使得场景所有物体都使用这个环境光

#### 逐像素还是逐顶点计算

* 在片元着色器中计算, 就是逐像素光照
  * 使用Phong着色: 以每个像素为基础, 得到其法线, 然后进行光照模型计算, 这种在面片之间对顶点法线进行插值的技术被称为Phong着色, 又称Phong插值或法线插值着色技术
* 在顶点着色器中计算, 就是逐顶点光照
  * 又称高洛德着色(Gouraud shading): 每个顶点计算光照, 然后在渲染图元的内部进行线性插值, 最后输出成像素颜色
* 对比:
  * 顶点数小于像素数, 因此逐顶点计算量小
  * 逐顶点需要依赖于线性插值来得到像素光照, 因此光照模型中出现了非线性计算(如计算高光反射时), 逐顶点光照会出现问题

### Unity中的环境光与自发光

非常简单, 只需要调节内部变量UNITY_LIGHTMODEL_AMBIENT就可以完成

自发光则只需要在片元着色器输出最后颜色之前把材质的自发光颜色加上即可

### 在Unity Shader中实现漫发射光照模型

防止点积结果为负数, 可以使用saturate()函数

* 可将变量x截取在[0,1], 如果x是矢量, 则对每个分量都进行这样的操作

#### 逐顶点光照的实现

[DiffuseVertexLevel](New%20Unity%20Project/Assets/Shader/Chapter6/DiffuseVertexLevel.shader)

不足之处: 背光面与向光面的交界处有锯齿现象, 因为胶囊是一个细分程度较低的模型, 使用逐像素光照可以解决

#### 逐像素光照的实现

基于逐顶点光照修改后如下

[DiffusePixelLevel](New%20Unity%20Project/Assets/Shader/Chapter6/DiffusePixelLevel.shader)

不足之处: 光照无法达到的地方, 无明暗变化导致背光区像一个平面, 从而失去了模型的细节表现, 使用半兰伯特(Half Lambert)光照模型解决

#### 半兰伯特(Half Lambert)模型

修改了兰伯特光照模型的公式, 如下

$$
c_{diffuse}=(c_{light}\cdot m_{diffuse})(\alpha(\vec{n}\cdot I)+\beta)\\
$$

* 没有使用max而是进行了缩放与偏移
* 通常缩放与偏移都是0.5, 这样可以把[-1,1]的范围映射到[0,1]
  * 原兰伯特模型是将点积结果都映射到0上

基于逐像素光照修改后如下

[HalfLambert](New%20Unity%20Project/Assets/Shader/Chapter6/HalfLambert.shader)

### 在Unity Shader中实现高光反射光照模型

最基本的高光反射部分计算公式如前文:

$$
c_{specular}=(c_{light}\cdot m_{specular})max(0,\vec{v} \cdot \vec{r})^{m_{gloss}}\\
其中从左到右四个参数含义分别为:\\
入射光线的强度与颜色c_{light}, 材质的高光反射系数m_{specular}\\
视角方向\vec{v}, 反射方向\vec{r}\\
其中, 反射方向\vec{r}可以通过表面法线\vec{n}与光源方向\vec{I}计算:\\
\vec{r}=2(\vec{n}\cdot\vec{I})\vec{n}-\vec{I}\\
$$

当然CG提供了reflect(I,n)这个函数来计算反射方向

#### 实践: 逐顶点光照

[SpecularVertexLevel](New%20Unity%20Project/Assets/Shader/Chapter6/SpecularVertexLevel.shader)

顶点着色器中计算光照再插值的过程是线性的, 破坏了原高光计算的非线性关系, 需要通过逐像素方法来实现更平滑的高光反射

#### 实践: 逐像素光照

[SpecularPixelLevel](New%20Unity%20Project/Assets/Shader/Chapter6/SpecularPixelLevel.shader)

效果更加平滑的一种Phong光照模型

#### Blinn-Phong光照模型

Blinn模型的光照计算公式如下

$$
引入
\vec{h}=\frac{\vec{v}+\vec{I}}{|\vec{v}+\vec{I}|}\\
c_{specular}=(c_{light}\cdot m_{specular})max(0,\vec{n} \cdot \vec{h})^{m_{gloss}}\\
$$

[BlinnPhong](New%20Unity%20Project/Assets/Shader/Chapter6/BlinnPhong.shader)

### 使用Unity内置的函数

自己去UnityCG.cginc里面看, 下面使用内置函数改写BlinnPhong

[BlinnPhong](New%20Unity%20Project/Assets/Shader/Chapter6/BlinnPhong.shader)

## 基础纹理

纹理映射坐标: 又称uv坐标, 定义了每个顶点在纹理中对应的2D坐标

Unity的2D纹理坐标符合OpenGL, 原点在纹理的左下角

使用官方源代码的纹理贴图

### 单张纹理

使用Blinn-Phong模型计算光照

[SingleTexture](New%20Unity%20Project/Assets/Shader/Chapter7/SingleTexture.shader)

* 为了在纹理平铺(Tiling)中实现两种不同的Wrap Mode效果, 代码中需要通过纹理属性对纹理坐标进行变化

```ShaderLab
//实现方法output.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
output.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
```

* Filter Mode: 图片的滤波效果, 影响放大缩小后得到的图片质量
  * Point: 使用最近邻(nearest neighbor)滤波, 放大缩小的采样点只有一个, 实现了像素风格
  * Bilinear: 每个目标像素找到4个邻近像素, 进行线性插值混合后得到结果, 因此图像模糊
  * Trilinear: 在Bilinear的基础上在多级渐远纹理之间进行混合, 如果没有使用这个技术则两者一样
* mipmapping: 多级渐远纹理, 根据不同缩放层级使用不同大小的纹理, 用空间换时间
* Max Size: 导入的纹理大小超过了这个值, 则Unity会将纹理缩放至最大分辨率
  * 通常纹理的长宽都是2的幂, 使用了非2的幂(Non Power of Tow, NPOT)的纹理, 则占据更多内存空间消耗更多GPU资源,
  部分平台不支持, 会内部缩放至相近似的2的幂
* Format: 决定了Unity内部使用哪种格式存储纹理

### 凹凸映射(bump maping)

目的是使用一张纹理修改模型表面的法线, 使得模型具有更多细节, 使得模型**看起来**凹凸不平(不改变模型顶点位置), 使用以下两种方法

* 高度纹理(height map): 又称高度映射(height mapping), 模拟表面位移得到一个修改后的法线值
  * 高度图其中存储的是强度值, 表示模型表面模拟的局部的海拔高度, 颜色越浅表示表面越向外凸, 颜色越深则越向内凹
  * 可以直观反映模型表面凹凸情况, 但是计算复杂, 无法实时计算得到表面法线, 需要通过**像素灰度值**计算得到
* 法线纹理(normal map): 又称法线映射(normal mapping), 直接储存表面法线, 由于法线方向的分量与像素分量范围不同, 因此需要进行映射对应
  * 我们需要在纹理采样之后进行反映射从而得到之前的法线方向, 但是方向是相对于坐标空间来说的, 对于模型顶点自带的法线, 是被定义到模型空间中的
    * 将修改后的模型空间中的表面法线存储到纹理中, 被称为模型空间的法线纹理(Object Space normal map)
      * 实现简单更加直观, 无需初始法线和切线信息, 计算少
      * 在纹理坐标缝合处和尖锐部分, 突变少, 能够提供平滑的边界, 由于纹理储存在同一空间下, 因此边界可以通过插值来平滑
    * 实际使用另一种坐标空间即模型顶点的切线空间(tangent space)来存储法线, 被称为切线空间的法线纹理
      (tangent space normal map)
      * 每个顶点都有属于自己的切线空间, 原点为顶点本身, z轴是顶点法线方向, x轴是顶点切线方向, y轴可由zx叉积得到
      * 自由度高, 模型空间下记录的是绝对法线信息, 仅用于创建它时的模型, 应用到其他模型就错误, 切线空间下则时相对信息, 纹理应用到不同网格上也可以得到合理的效果
      * 可进行UV动画, 通过移动纹理的UV坐标来实现一个凹凸移动的效果(常用于水或火山熔岩这种物体上), 而模型空间下则无法实现
      * 可重用法线纹理, 例如一个砖块可以只通过一张法线纹理作用于所有六个面
      * 可压缩, Z方向总是正方向, 因此只需要存储两个方向, 通过计算得到另一个方向, 模型空间下每个方向都可能, 因此不可压缩

![模型顶点的切线空间](images/7.12.png)

#### 实现

需要在计算光照模型中统一各个方向矢量所在的坐标空间

* 切线空间: 光照方向与视角方向转换至切线空间
  * 效率更高: 顶点着色器就完成光照与视角方向的转换
* 世界空间: 采样的法线方向转换至世界空间
  * 通用性更高: 需要先采样, 因此在片元着色器中转换, 需要在片元着色器中进行一次矩阵操作, 而有些情况就需要先采样

[NormalMapTangentSpace](New%20Unity%20Project/Assets/Shader/Chapter7/NormalMapTangentSpace.shader)

基于切线空间的世界空间变换的shader:
[NormalMapWorldSpace](New%20Unity%20Project/Assets/Shader/Chapter7/NormalMapWorldSpace.shader)

#### Unity中的法线纹理类型

针对不同的压缩格式, Unity给出了不同的解压方法, UnityCG.cginc中的内置函数, 通常是根据两个通道推导出第三个通道, 以时间换空间

### 渐变纹理

[RampTexture](New%20Unity%20Project/Assets/Shader/Chapter7/RampTexture.shader)

采样时halfLambert值理论上在[0,1], 可能会存在1.0001的情况

* 当WrapMode = Repeat时会舍弃整数部分, 导致变成0.0001, 因此高光部分会有黑点
* 当WrapMode = Clamp时即可解决上述问题

### 遮罩纹理(Mask Texture)

遮罩: 用于保护某些区域使其免于一些修改, 通常用于下面两个方面

* 控制光照: 全局高光反射, 通过遮罩纹理控制一部分反射更强, 一部分反射更弱
* 混合纹理: 制作材质时, 需要混合多个纹理, 如表现地面的草, 石头, 裸露的土地的混合

使用的一般流程:

* 采样得到遮罩纹理的纹理值
* 使用其中几个通道与表面某种属性相乘, 这样就可以通过控制该通道为0来保证表面不受该属性的影响

[MaskTexture](New%20Unity%20Project/Assets/Shader/Chapter7/MaskTexture.shader)

## 透明效果

实时渲染中通过控制透明通道(Alpha Channel)来实现透明, 透明度为1时完全不透明, 为0时不会显示

通常使用以下两种方法来实现透明效果:

* 透明度测试(Alpha Test): 无法得到真正的半透明效果
  * 只要一个片元不满足透明度的阈值, 则整个片元被舍弃, 如果达到了透明度阈值则按照不透明物体处理
  * 只有透明和不透明两种效果
* 透明度混合(Alpha Blending): 可实现真正的半透明效果
  * 使用当前片元的透明度做为混合因子与存储在颜色缓冲中的颜色进行混合
  * 只关闭深度写入, 未关闭深度测试, 因此进行透明度混合前, 还是会进行深度测试, 如果深度值更大, 则不会混合

### 为什么渲染顺序很重要

对于不透明(opaque)的物体, 由于[深度缓冲](#逐片元操作per-fragment-operation),
因此不需要考虑物体渲染的先后顺序, 它决定了哪个部分先渲染, 哪个部分被遮挡

为了使得透明物体背后的表面能被看见, 需要关闭深度写入来破环深度缓冲的工作机制

常用的渲染排序方法有以下两个步骤:

* 先渲染所有不透明物体, 并启动它们的深度测试与深度写入
* 根据不透明物体与摄像机的距离, 从远往近渲染, 开启深度测试关闭深度写入
  * 排序判断是个非常麻烦的事情, 而且有许多状况无法顾及, 下面举出两个例子
  * 因此只能"尽力而为"

![循环重叠的半透明物体](images/8.3.png)

![选择不同深度值代表整个物体的深度值](images/8.4.png)

### Unity Shader的渲染顺序

Unity提供了渲染队列(render queue)的解决方案用于解决渲染顺序的问题, 使用SubShader的Queue标签来决定模型归于哪个渲染队列

| 名称以及队列索引号 |                               描述                               |
| :----------------: | :--------------------------------------------------------------: |
| Background = 1000  |       这个渲染队列最高优先级通常用于渲染绘制在背景上的物体       |
|  Geometry = 2000   |                    默认的队列, 不透明物体使用                    |
|  AlphaTest = 2450  | 需要透明度测试的物体的渲染队列, 不透明物体渲染完后再渲染更加高效 |
| Transparent = 3000 |  以从前往后的顺序进行渲染, 所有使用了透明度的物体都使用这个队列  |
|   Overlay = 4000   |                用于实现叠加效果, 时最后的渲染队列                |

### 透明度测试

在片元着色器中使用clip函数进行透明度测试

```shaderlab
void clip(float4 x)
{
    if(any(x<0))
      discard;
}
```

[AlphaTest](New%20Unity%20Project/Assets/Shader/Chapter8/AlphaTest.shader)

### 透明度混合

* Blend Off: 关闭混合
* Blend SrcFactor DstFactor: 开启混合, 设置混合因子, 源颜色(该片元产生的颜色)乘SrcFactor, 目标颜色(已存在颜色缓冲的颜色)乘DstFactor, 两者相加存入颜色缓冲
* Blend SrcFactor DstFactor, SrcFactorA DstFactorA: 使用不同的因子来混合透明通道
* BlendOp BlendOperation: 不再使用源颜色与目标颜色相加后混合, 而是使用BlendOperation对它们进行其他操作

以AlphaTest为基础进行修改: [AlphaBlend](New%20Unity%20Project/Assets/Shader/Chapter8/AlphaBlend.shader)

### 开启深度写入的半透明效果

之前说了关闭深度写入会产生很多问题, 如重叠产生的因排序错误导致的错误透明效果的产生, 解决方案又很复杂, 因此重新启用深度写入来实现半透明效果

使用两个Pass来渲染模型: 其中一个开启深度写入但不输出颜色, 仅仅用于将模型的深度值写入深度缓冲中, 另一个Pass进行正常的透明混合, 但是多使用的一个Pass可能会造成性能降低

在AlphaBlend的基础上新增一个Pass: [AlphaBlendZWrite](New%20Unity%20Project/Assets/Shader/Chapter8/AlphaBlendZWrite.shader)

### ShaderLab的混合命令

如何实现混合的:

* 片元着色器产生一个颜色(即源颜色), 可以选择与颜色缓冲中的颜色(即目标颜色)进行混合
* 混合后的输出颜色将会重写写入颜色缓冲中

#### 混合等式和参数

混合是一个逐片元的操作, 且不可编程, 但高度可配置, 通过改变混合等式(blend equation)来进行配置,
我们通过设置混合等式中的操作和因子来配置等式

* 一个等式用于混合RGB通道, 另一个等式用于混合A通道
* 每个等式都有两个因子, 分别与源颜色和目标颜色相乘
* 通常操作默认是加法操作

根据之前的两个操作我们可以得出对应的混合等式

* Blend SrcFactor DstFactor: RGB A通道使用同样的混合因子
* Blend SrcFactor DstFactor, SrcFactorA DstFactorA: 使用不同的因子来混合透明通道

$$
O_{rgb} = SrcFactor \times S_{rgb} + DstFactor \times D_{rgb}\\
O_{a} = SrcFactorA \times S_{a} + DstFactorA \times D_{a}
$$

下表给出ShaderLab中的混合因子

|       参数       |                         描述                         |
| :--------------: | :--------------------------------------------------: |
|       One        |                       因子为1                        |
|       Zero       |                       因子为0                        |
|     SrcColor     | 因子为源颜色, 混合RGB时使用RGB分量, 混合A时使用A分量 |
|     SrcAlpha     |                  因子为源颜色透明值                  |
|     DstColor     |      因子为目标颜色值, RGB与A分量分配同SrcColor      |
|     DstAlpha     |                 因子为目标颜色透明值                 |
| OneMinusSrcColor |      因子为(1-源颜色), RGB与A分量分配同SrcColor      |
| OneMinusSrcAlpha |                因子为(1-源颜色透明度)                |
| OneMinusDstColor |     因子为(1-目标颜色), RGB与A分量分配同SrcColor     |
| OneMinusDstAlpha |               因子为(1-目标颜色透明度)               |

#### 混合操作

可以使用BlendOp Operation进行混合操作指令

下面给出ShaderLab中的操作

* Add
* Sub: 源颜色-目标颜色
* RevSub: 目标颜色-源颜色
* Min: 每个RGBA分量逐个比较, 选更小的
* Max: 选更大的
* 以及Dx11.1中支持的一些类型

#### 常见的混合类型

```ShaderLab
//正常混合
Blend SrcAlpha OneMinusSrcAlpha
//柔和相加(Soft Addictive)
Blend OneMinusDstColor One
//正片叠底(Multiply), 即相乘
Blend DstColor SrcColor
//变暗(Darken), 其实可以不设置因子, 反正不用
BlendOp Min
Blend One One
//变亮(Lighten), 其实可以不设置因子, 反正不用
BlendOp Max
Blend One One
//滤色(Screen)
Blend OneMinusDstColor One
//等同于
Blend One OneMinusSrcColor
//线性减淡(Linear Dodge)
Blend One One
```

![不同混合状态设置的效果](images/8.12.png)

#### 双面渲染的透明效果

默认情况下剔除了物体背面的图元, 因此之前的透明渲染无法看到正方体内部和背面, 可以使用以下命令来控制要剔除哪个面

```Shaderlab
Cull Back/Front/Off
```

##### 透明度测试的双面渲染

在AlphaTest的基础上增加一个Cull Off就完成了

[AlphaTestBothSide](New%20Unity%20Project/Assets/Shader/Chapter8/AlphaTestBothSide.shader)

##### 透明度混合的双面渲染

按照之前AlphaBlendZWrite的方法, 使用两个Pass, 一个只渲染背面, 一个只渲染正面, 并且根据Unity会顺序执行SubShader中的Pass, 因此可以保证背面总是比正面先渲染

在AlphaBlend的基础上进行修改[AlphaBlendBothSide](New%20Unity%20Project/Assets/Shader/Chapter8/AlphaBlendBothSide.shader)

## 更复杂的光照

### Unity的渲染路径

渲染路径决定了光照如何应用到Unity Shader中, 需要为每个Pass指定所使用的渲染路径

#### 前向渲染路径

原理:

* 渲染图元
  * 进行深度测试, 判断是否可见
  * 如果可见进行光照计算, 更新帧缓冲

对于每个逐像素光源, 都需要进行上述渲染, 如果一个物体在多个逐像素光源的影响范围内, 则该物体需要执行多个Pass, 然后通过多个Pass的结果进行混合

由于多个物体受到多个光照影响会导致需要执行的Pass数量巨大, 因此需要控制每个物体逐像素光照的数量

##### Unity中的前向渲染

Unity中一共有三种处理光照的形式: 逐顶点处理, 逐像素处理, 球谐函数(Spherical Harmonics, SH)处理

光照如何处理取决于: 类型 + 渲染模式(该光源是否重要)

前向渲染中Unity会根据各个光源的设置以及其对物体的影响程度进行重要性排序, 从而通过逐像素, 逐顶点(最多四个), SH方式进行处理

Unity判断规则如下:

* 场景中最亮的平行光**总是**逐像素处理
* 渲染模式为"Not Important"的光源按照逐顶点或SH处理
* 渲染模式为"Important"的光源按照逐像素处理
* 如果以上规则下, 逐像素处理的光源数量小于Quality Setting中的Pixel Light Count, 则更多光源进行逐像素渲染

前向渲染一共有两种Pass:

* Base Pass(只计算一次): 一个逐像素的平行光以及所有逐顶点和SH光源计算, 使用#pragma multi_compile_fwdbase, 可以实现光照纹理, 环境光, 自发光, 平行光阴影
* Additional Pass(会被复用, 通常进行混合): 其他影响该物体的逐像素光源计算, 其中每一个光源执行一个Pass, 使用#pragma multi_compile_fwdadd, 默认不支持阴影, 可手动开启

#### 顶点照明渲染路径

是前向渲染路径的一个子集, 硬件要求最少, 性能最好, 效果最差, 不支持逐像素得到的效果, 可能已经被移除(?)

#### 延迟渲染路径

前向渲染的性能瓶颈在于, 大量实时光源使得执行每执行一个Pass都需要重新渲染一遍物体, 进行大量重复运算

延迟渲染使用了额外的缓冲区(G-Buffer), 其中存储了表面的其他信息, 如表面法线, 位置, 材质属性等

##### 延迟渲染的原理

第一个Pass计算哪些片元可见, 并将需要的信息存储在G-buffer中, 第二个Pass使用G-buffer的信息进行真正的光照计算

由于无论场景的复杂度如何, 使用的Pass通常是两个

##### Unity中的延迟渲染

优点: 适用于场景光源较多, 每个光源都可以逐像素的方式处理

缺点: 不支持真正的抗锯齿, 不能处理半透明物体, 需要硬件支持

总的来说, 我们会根据游戏发布的目标平台来选择渲染路径以保证显卡的支持

### Unity的光源类型

平行光, 点光源, 聚光灯, 面光源(仅在烘培时发挥作用)

#### 光源类型有什么影响

##### 平行光

几何属性只有方向, 无光源位置概念, 无光衰变概念

##### 点光源

由空间中的一个球体定义, 由光源位置与目标位置决定光线方向, 由两者距离决定衰减强度

##### 聚光灯

一个锥形区域定义, 锥形区域半径, 锥体张开角度, 由光源位置与目标位置决定光线方向, 由两者距离决定衰减强度

#### 在前向渲染中处理不同的光源类型

使用Blinn-Phong光照模型

[ForwardRendering](New%20Unity%20Project/Assets/Shader/Chapter9/ForwardRenderting.shader)

### Unity的光照衰减

9.2中, 我们使用了一张纹理做为查找表来计算逐像素光照的衰减, 以此来降低计算量, 但是会有如下缺点:

* 需要预处理得到采样纹理, 纹理的大小会影响衰减精度
* 不直观, 且无法使用其他数学公式计算衰减

#### 用于光照衰减的纹理

Unity内部使用了_LightTexture0计算光照衰减, 根据表的对角线的纹理颜色值, 我们可以得到光源空间中, 不同位置的点的衰减值

而使用数学公式进行计算, 由于Unity内置变量提供不全面, 因此效果可能不好

### Unity的阴影

#### 阴影是如何实现的

实时渲染中, 通常使用shadow map, 将摄像机位置与光源位置重合得到, 光源的阴影区域就是摄像头看不见的区域

Unity会为开启了阴影的光源计算阴影映射纹理(shadow map), 其本质也是一个深度图, 记录了从光源位置出发, 在能看到的场景中距其最近的表面位置

* 将摄像机放到光源处, 按照正常的渲染流程渲染, 调用Base Pass与Additional Pass来更新
  * 会造成性能浪费, 因为只需要深度信息, 而原本涉及到了许多光照模型计算
  * Unity使用了一个额外的Pass更新专门的阴影映射纹理, "LightMode = ShadowCaster"

有以下两种方法判定距离最近的表面位置:

* 传统方法: 正常渲染的Pass得到顶点在光源空间的信息, 使用xy分量进行采样, 从而得到阴影纹理映射中该位置的深度信息, 若小于该顶点的深度值, 则该点位于阴影中
* 屏幕空间的阴影映射技术(ScreenSpace Shadow Map): 首先调用ShadowCaster的Pass得到可投射阴影的光源的阴影映射纹理和摄像机的深度纹理, 之后通过二者得到屏幕空间的阴影图, 其包含了屏幕空间中的所有阴影区域
  * 摄像机的深度图中记录的表面深度大于转换到阴影映射纹理中的深度值, 说明表面处于阴影中且可见
  * 原本应用于延迟渲染产生阴影
  * 需要显卡支持MRT

一个物体接受别的物体的阴影, 以及它向别的物体投射阴影分为下面两个过程:

* 接受: shader中对阴影映射纹理进行采样, 采样结果与最后的光照结果相乘从而产生阴影效果
* 投影: 把该物体加入光源的阴影映射纹理的计算中, 从而使得其他物体进行阴影采样时就能够得到这个物体的相关信息

#### 不透明物体的阴影

根据ForwardRendering.shader, [Shadow.shader](New%20Unity%20Project/Assets/Shader/Chapter9/Shadow.shader)中写出接受阴影(即两面都有阴影产生)

WARNING: 某些宏会使用**上下文变量**进行相关运算, 因此为了使得这些宏能够正常工作, 我们需要注意以下几点:

* a2v中顶点坐标变量必须叫vertex
* 顶点着色器中的a2v必须叫v
* v2f中顶点位置变量必须要pos

#### 统一管理光照衰减和阴影

由于在Add Pass中, 阴影与衰减都是与光照结果相乘得到最终渲染结果, 因此两者对物体渲染的影响本质上是相同的

使用UNITY_LIGHT_ATTENUATION宏实现衰减与阴影的同时计算

[AttenuationAndShadow.shader](New%20Unity%20Project/Assets/Shader/Chapter9/AttenuationAndShadow.shader)

#### 透明度物体的阴影

大多数不透明物体, Fallback中回调"VertexLit"即可得到正���的阴影, 而透明物体涉及到透明度测试和透明度混合, 因此需要小心设置Fallback

根据/chapter8/AlphaTest.shader, [AlphaTestWithShadow.shader](New%20Unity%20Project/Assets/Shader/Chapter9/AlphaTestWithShadow.shader)

同样的Fallback "Transparent/Cutout/VertexLit"中也有_Cutoff上下文进行计算, 因此我们也需要提供同名属性

然而, 对于透明度混合的物体来说, 计算阴影就异常困难, 内置的所有透明度混合的shader都不包括阴影投射的Pass, 原因如下:

* 透明度混合需要关闭深度写入, 因此影响了阴影的生成
* 为了使得阴影正常生成, 需要严格执行从后往前渲染的顺序, 从而使得阴影渲染变得异常复杂

## 高级纹理

### 立方体纹理

* 立方体纹理(CubeMap)是环境映射(Environment Mapping)的一种实现方法
  * 环境映射可以模拟物体周围的环境, 使用了环境映射的物体可以像镀了一层金属一样反射出周围的环境
* 立方体纹理包含六个面, 对应着立方体的六个面
* 需要提供一个3D纹理坐标进行采样
  * 这个坐标表示了3D空间中的一个矢量, 它从立方体中心出发, 向外延伸会和立方体纹理之一发生相交, 采样的结果就是通过这个交点计算而来的
* 优点: 简单快速且效果好
* 缺点:
  * 场景发生变化时, 就需要重新生成立方体纹理
  * 仅能够反射环境, 但不能够反射使用了该纹理的物体本身
    * 因为立方体纹理不能模拟多次反射的效果
    * 因此最好对凸面体使用立方体纹理(凹面体会进行自反射)
* 通常应用于天空盒子和环境映射中

#### 天空盒子(Skybox)

这是一种游戏模拟背景的常用方法, 在Unity中, 它是在所有不透明物体渲染完毕之后渲染的

#### 用于环境映射的立方体纹理

可以实现金属质感, 创建方法有以下几种:

* 提供一张特殊布局的纹理, 并用它进行创建
* 手动创建cubemap资源, 并赋六张图
* 脚本生成

#### 反射

[Reflection.shader](New%20Unity%20Project/Assets/Shader/Chapter10/Reflection.shader)

#### 折射

物理上需要计算光线折射进入与折射射出的两道光线, 然而对于实时渲染, 模拟折射射出十分困难, 并且去掉了看起来变化也不大

根据Reflection.shader进行修改:

[Refraction.shader](New%20Unity%20Project/Assets/Shader/Chapter10/Refraction.shader)

#### 菲涅尔反射

描述了一种光学现象: 折射光和反射光存在一定比例关系, 然而其非常复杂, 因此使用一些近似公式进行简化计算

$$
Schlick菲涅尔近似等式:\\
F_{schlick}(\vec{v},\vec{n})=F_0+(1-F_0)(1-\vec{v}\cdot \vec{n})^5\\
其中, F_0是反射常数, 用于控制菲涅尔反射的强度, \vec{v}是视角方向, \vec{n}是表面法线\\
Empricial菲涅尔近似等式:\\
F_{Empricial}(\vec{v},\vec{n})=max(0,min(1,bias+scale\times(1-\vec{v}\cdot\vec{n})^{power}))\\
其中bias scale power都是控制项
$$

根据Reflection.shader进行修改, 是哦那个Schlick菲涅尔近似等式:

[Fesnel.shader](New%20Unity%20Project/Assets/Shader/Chapter10/Fresnel.shader)

### 渲染纹理

渲染目标纹理(Render Target Texture,RTT): 是一个中间缓冲, 用于存放即将显示到屏幕上的**整个三维场景**, 与之对应的是传统的帧缓冲和后置缓冲(back buffer)

其中还有一种技术叫多重渲染目标(Multiple Render Target,MRT): 允许把场景渲染到多个RTT中, 不再需要为每个目标单独渲染完整的场景

Unity为RTT定义了一种专门的类型, 渲染纹理(Render Texture), 使用方法有如下两种:

* 创建一个渲染纹理, 然后将摄像机的渲染目标设置为该渲染纹理
  * 摄像机的渲染结果会实时更新到渲染纹理上, 且不会显示在屏幕上
  * 可以选择渲染纹理的分辨率以及调整滤波模式等纹理属性
* 在屏幕后处理中使用函数获取当前屏幕图像, Unity会将其放在与其分辨率等同的渲染纹理中

#### 镜子效果

将渲染纹理进行水平方向向上翻转后, 直接显示到物体上

[Mirror.shader](New%20Unity%20Project/Assets/Shader/Chapter10/Mirror.shader)

#### 玻璃效果

在Unity中使用一种特殊的Pass来获取屏幕图像, GrabPass, 同时它也可以让我们对图像进行后续的复杂处理

Scene使用镜子效果的Scene

[GlassRefraction.shader](New%20Unity%20Project/Assets/Shader/Chapter10/GlassRefraction.shader)

不过我使用渲染纹理的时候, 没有用相机做为position, 我直接选的point light

#### 渲染纹理 vs. GrabPass

* GrabPass:
  * 实现简单, 几行代码直接抓取屏幕
  * 效率更低, 截图的图像分辨率与显示屏幕一致, 可能产生高带宽消耗
  * 无需重新渲染, 需要CPU读取back buffer, 破坏CPU与GPU的并行性, 耗时长
* 渲染纹理
  * 实现复杂, 创造纹理+额外相机, 设置相机render target, 最后传递渲染纹理给对应shader
  * 效率更高, 支持自定义
  * 需要重新渲染部分场景, 可通过调整相机渲染层来减少二次渲染的场景大小

Unity引入了命令缓冲(commmand buffer), 来扩展Unity的渲染流水线, 并且通过这个我们也能实现类似屏幕抓取的效果

### 程序纹理(Procedural Texture)

使用特定算法实现个性化图案以及其他真实的自然元素, 并且能够通过各种参数调节图案属性

#### 实现简单的程序纹理

生成一个波点纹理

[ProceduralTextureGeneration.cs](New%20Unity%20Project/Assets/Script/Chapter10/ProceduralTextureGeneration.cs)

#### Unity的程序材质

使用的是Substance Designer的外部软件生成的, BUG巨多, 恶心人