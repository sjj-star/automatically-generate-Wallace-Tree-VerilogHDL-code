# Automatically Generate Wallace Tree VerilogHDL Code
本工具用于自动生成一个Wallace Tree算法VerilogHDL代码实例，并附带了一些配套的工具和一个完整的VerilogHDL描述的乘法器。
## multer.v
此文件是一个使用VerilogHDL描述的纯组合逻辑乘法器。其中它包含4-2压缩器，3-2压缩器，半加器，支持有符号/无符号数的booth编码器，与booth编码器输出接口匹配的8/16/32bit Wallace Tree算法压缩器（完全由本工具生成）。这些模块组合成一个同时支持有符号/无符号数乘法器。
### half_adder
半加器，它完成压缩算法中2bit位加法功能。
### compressor_3_2
3-2压缩器，它实质是一个3bit全加器，完成将2bit位和1bit进位加法功能。
### compressor_4_2
4-2压缩器，它实质是一个5bit全加器，完成将4bit和1bit进位加法任务。这里4-2压缩的原理是，将5-3全加器的进位输出接到下一个5-3全加器的进位输入，这样级联下去，每一个模块的4bit输入延迟是相同的（这样级联不会增加5-3全加器链的总延迟），等效为一个4-2压缩器。
在FPGA中综合结果显示5bit全加器的ASIC门级描述比直接级联两个全加器的最终逻辑延迟要长，故使用verilog的宏`FPGA_VERSION`来选择级联型;ASIC综合中使用标准单元库中的HAX1(半加器)、FAX1(全加器)延迟均优于门级描述，并且使用FAX1级联得到的4-2压缩器延迟同样优于门级描述，故使用verilog的宏`GSCL45NM`来选择标准单元。
### \_8\_wallace\_tree/\_16\_wallace\_tree/\_32\_wallace\_tree
8/16/32bit Wallace Tree算法压缩器，他是由上面三种简单压缩器复合而成。完全由本工具生成，输入接口与本实例的booth编码器匹配。
### booth_coder
有符号/无符号数的booth编码器，这是一个VerilogHDL描述的可参数化位宽的booth算法编码器。本实例具有一个特色是使用1bit`sign`输入信号指定有无符号数编码，并且在原有的有符号booth算法基础上只增加了一个与设计位宽相同的全加器（设计为8bit乘法器，相比于只支持有符号编码的booth算法，这里会增加一个8ibt加法运算）。
### multer
乘法器的顶层模块，将上面的模块组合起来，只需要将最终压缩器输出的两个结果进行加法运算即可得到最终输出。
## generate\_wallacetree\_verilogcode.c
此文件是本工具的主要源代码。它需要一组数据输入，这组数据是将被压缩的bit阵列中每一列的数量，最左边对应阵列中最低位。它得到这组输入后，会在终端打印出一些信息包含生成的目标代码。
(**Note:** 此源代码使用了`typeof`关键字，详见[GUN C Extensions](https://gcc.gnu.org/onlinedocs/gcc-4.6.2/gcc/C-Extensions.html#C-Extensions)，所以对于某些不支持此特性的C编译器可能会报错)
假设有一个待压缩bit阵列如下：
```
            * * * * * * * * * *
        * * * * * * * * * *   *
    * * * * * * * * * *   *
* * * * * * * * * *   *
* * * * * * * *   *
2 2 3 3 4 4 5 5 4 5 3 4 2 3 1 2
```
那么工具使用如下：
`./generate_wallacetree_verilogcode 2 1 3 2 4 3 5 4 5 5 4 4 3 3 2 2`
它将输出如下信息：
```
this is input nets list :
 0:    s_0_0    s_0_1
 1:    s_1_0
 2:    s_2_0    s_2_1    s_2_2
 3:    s_3_0    s_3_1
 4:    s_4_0    s_4_1    s_4_2    s_4_3
 5:    s_5_0    s_5_1    s_5_2
 6:    s_6_0    s_6_1    s_6_2    s_6_3    s_6_4
 7:    s_7_0    s_7_1    s_7_2    s_7_3
 8:    s_8_0    s_8_1    s_8_2    s_8_3    s_8_4
 9:    s_9_0    s_9_1    s_9_2    s_9_3    s_9_4
10:   s_10_0   s_10_1   s_10_2   s_10_3
11:   s_11_0   s_11_1   s_11_2   s_11_3
12:   s_12_0   s_12_1   s_12_2
13:   s_13_0   s_13_1   s_13_2
14:   s_14_0   s_14_1
15:   s_15_0   s_15_1
the number of all nets: 52

compress stage 0:    2    2    3    3    4    4    5    5    4    5    3    4    2    3    1    2
compress stage 1:    2    2    2    3    2    2    3    3    2    2    3    1    2    1    2    1
compress stage 2:    2    2    2    2    2    2    2    2    2    2    1    2    1    2    1    1
the numbers of components: 28

          module instance group              input delay
             TOP   Inputs     0
      half_adder     u0_1     1    0.0    0.0
  compressor_3_2     u1_2     1    0.0    0.0    0.0
      half_adder     u0_3     1    0.0    0.0
  compressor_4_2     u2_4     1    0.0    0.0    0.0    0.0   41.0
  compressor_3_2     u1_5     1    0.0    0.0   70.0
  compressor_4_2     u2_6     1    0.0    0.0    0.0    0.0    0.0
  compressor_4_2     u2_7     1    0.0    0.0    0.0    0.0   70.0
  compressor_4_2     u2_8     1    0.0    0.0    0.0    0.0   70.0
  compressor_4_2     u2_9     1    0.0    0.0    0.0    0.0   70.0
  compressor_4_2    u2_10     1    0.0    0.0    0.0    0.0   70.0
  compressor_4_2    u2_11     1    0.0    0.0    0.0    0.0   70.0
  compressor_3_2    u1_12     1    0.0    0.0   70.0
  compressor_3_2    u1_13     1    0.0    0.0    0.0
      half_adder    u0_14     1    0.0    0.0
      half_adder    u0_15     1    0.0    0.0
      half_adder    u0_16     2   41.0    0.0
      half_adder    u0_17     2   70.0   54.0
  compressor_3_2    u1_18     2  157.0  147.0    0.0
      half_adder    u0_19     2  138.0  173.0
      half_adder    u0_20     2  157.0  173.0
  compressor_3_2    u1_21     2  157.0  173.0    0.0
  compressor_3_2    u1_22     2  157.0  173.0    0.0
      half_adder    u0_23     2  157.0  173.0
      half_adder    u0_24     2  157.0  173.0
  compressor_3_2    u1_25     2  157.0  147.0    0.0
      half_adder    u0_26     2  138.0   77.0
      half_adder    u0_27     2   70.0   54.0

/* Input nets */
wire    s_0_0,    s_0_1,    s_1_0,    s_2_0,    s_2_1,    s_2_2;
wire    s_3_0,    s_3_1,    s_4_0,    s_4_1,    s_4_2,    s_4_3;
......
```
它打印的信息意义如下：
1. 第一部分是一个线网列表，展示了要压缩的bit阵列以及他们在Verilog代码中的`wire`名，从左向右排布。
2. 第二部分展示了Wallace Tree算法压缩的每个阶段（在同一阶段的待压缩bit的输出延迟是均衡的），bit阵列每一列还有多少个bit，压缩算法总共实例化了多少个器件。
3. 第三部分是一张列表，展示了算法实例化模块列表。`module`表示模块名，`instance`表示实例化的名字，`group`表示这个器件在哪一组，对应压缩的每个阶段，在同一阶段实例化的器件分在同一组，`input delay`表示单元的每个输入端口的理想输入延迟。这样生成的代码便于人工分析。(模块`TOP`仅仅是一个虚拟模块存在工具中以便组织算法)
4. 第四部分从注释`/* Input nets */`开始全部为生成的目标代码内容，可以直接将他复制到您的设计代码中。这里并没有生成模块的输入接口，您需要自己建立一个模块并定义接口，然后将模块的输入接口与`/* Input nets */`下方定义的输入net相连接，比如使用`assign`语句，插入地点有注释提示。这一部分需要您自己完成，因为每个人设计的booth编码器接口可能不一样，但是压缩器的输出是可以预见的,两个位宽相同的压缩结果，所以您也许可以直接将生成的代码中最后两个没有声明的wire:`compress_a`,`compress_b`作为模块输出。本套工具还带有与作者编写的booth编码器相匹配的自动生成net连接工具，见**generate_assign.c** 。
## generate_assign.c
此源码是用于匹配**multer.v**中`booth_coder`模块的输出，对**generate\_wallacetree\_verilogcode.c**缺失的部分——模块接口与压缩阵列线网相连的代码。其输入参数与**generate\_wallacetree\_verilogcode.c**相同。
## generate_parameter.c
此源码用于生成的上述两个工具的参数，与**multer.v**中`booth_coder`模块输出的压缩bit阵列相匹配。运行后输入booth编码位宽，如下所示：
```
./generate_parameter

Input Multer Width:8
2 1 3 2 4 3 5 4 5 5 4 4 3 3 2 2
```
## list.h
本头文件包含一个链表数据结构以及相关算法。
# 算法思路
本算法优化目标是最佳性能，实现这一点的方法是按压缩器延迟分阶段构建wallace tree。算法将构建过程看作是一个二维迭代：从低位到高位的所有bit进行迭代生成所需的压缩器阵列，压缩器阵列的所有输出形成新的bit阵列，这是一次迭代压缩过程，反复迭代这个过程至所有列的bit数量小于2则压缩完成。

为了简化算法又尽可能保证近似最佳性能，假设每次迭代的bit阵列的所有bit输入延迟是平衡的，则对算法的要求是新的bit阵列输出延迟也是平衡的且是延迟最优的，这样可保证算法不偏离目标。下面对不同压缩器输入到输出延迟进行分析：
## 半加器：
|latency(ps)| o |cout|
|:-----:|:-:|:--:|
|**a**|50|39|
|**b**|54|41|
## 3-2压缩器：
|latency(ps)| o |cout|
|:-----:|:-:|:--:|
|**a**|71|62|
|**b**|75|70|
|**cin**|77|68|
## 4-2压缩器：
|latency(ps)| o |co |cout|
|:-----:|:-:|:-:|:--:|
|**a**|173|156|70|
|**b**|167|157|68|
|**c**|164|152|62|
|**d**|75|70|/|
|**cin**|77|68|/|

(**Note:** 综合工具：Genus 15，工艺库：GSCL45NM，FPGA综合布局布线情况较为复杂仅当作近似参考)

根据上述分析，在一次迭代压缩中前一列的进位会成为当前列的压缩输入，其中4-2压缩器的特点是d/cin到cout无延迟传播，而其他压缩器的cin到cout间延迟会传播；为了保证延迟平衡的目标，总结出如下固定的压缩器互连结构：
1. 半加器的任意输入可以接上一列4-2压缩器的cout，级联后此压缩器的cout不能作为下一列任意压缩器的输入
2. 3-2压缩器的任意输入可以接上一列4-2压缩器的cout，级联后此压缩器的cout不能作为下一列任意压缩器的输入
3. 4-2压缩器的d/cin可以接上一列任何压缩器可使用的cout，co则不能当作下一列任何压缩器的输入

为了使每一列的迭代压缩满足上述的约束条件，算法使用三个队列分别保存当前迭代中当前列可参与下一列运算的半加器的cout、3-2/4-2压缩器的cout、不能参与下一列运算的cout及4-2压缩器的co，前两个队列按照约束参与本列的迭代压缩，本列的迭代压缩结束时将所有队列中剩余的进位补进bit阵列中。本算法着重于性能，但并不是最优性能，在尝试不同组合策略中可明显观察到性能面积互换规律，且已发现了一种策略的性能略优，面积略大（丢失）。
# 在Vivado平台下与乘法器IP对比
这里使用Xilinx Vivado提供的乘法器IP核，分别由LUT和DSP实现的32bit有符号乘法器以及本工具生成的乘法器。
+ 设计：32bit有/无符号乘法器(sign=1'b1)
+ 器件平台：xc7a200tfbg676-2
+ 宏：FPGA_VERSION
+ 时钟周期：7.0ns
+ 综合策略：AlternateRoutability
+ 实现策略：Performance_NetDelay_low

|method|WNS(ns)|logic delay(ns)|net delay(ns)|LUTs|DSPs|FFs|
|:----:|:-----:|:-------------:|:-----------:|:--:|:--:|:-:|
|DSP|-1.890|7.923|**0.873**|0|4|128|
|LUT|-2.050|5.813|3.211|1089|0|128|
|old|**-0.288**|2.72|4.534|1394|0|128|
|this|-0.364|**2.397**|4.939|1287|0|128|

(**Note:** Vivado策略选取参考了[这个实验](https://miscircuitos.com/vivado-synthesis-and-implementation-strategies/#:~:text=Vivado%20Synthesis%20vs%20Implementation%20Synthesis%20is%20the%20process,route%20the%20netlist%20onto%20the%20FPGA%20device%20resources.))
# Genus 15 & GSCL45NM
这里使用的是NCSU提供的开源工艺库——FreePDK45，进行综合评估的结果。
+ 设计：128bit wallace tree
+ 标准单元：HAX1,FAX1
+ 宏：GSCL45NM
+ 约束裕量：1.5ns

|Algorithm|Slack WNS(ps)|Instance Count|Area(um^2)|
|:-------:|:----------:|:------------:|:---------:|
|this|300.7|8916|74682.056|
|lost|317.3|8089|76088.078|

仓库中`genus_synth/`下提供了相应的tcl脚本以及SDC
(**Note:**需要提供`OSU_LIB`,`PROJ_HOME`两个环境变量，分别表示工艺库路径及本仓库路径)