# Automatically Generate Wallace Tree VerilogHDL Code
这个工具用于自动生成一个Wallace Tree算法VerilogHDL代码实例，并附带了一些配套的工具和一个完整的VerilogHDL描述的乘法器。
## multer.v
此文件是一个使用VerilogHDL描述的纯组合逻辑乘法器。其中它包含4-2压缩器，3-2压缩器，半加器，支持有符号/无符号数的booth编码器，与booth编码器输出接口匹配的8/16/32bit Wallace Tree算法压缩器（完全由本工具生成）。这些模块组合成一个同时支持有符号/无符号数乘法器。
### half_adder
半加器，它完成压缩算法中2bit位加法功能。
### compressor_3_2
3-2压缩器，它实质是一个3bit全加器，完成将2bit位和1bit进位加法功能。
### compressor_4_2
4-2压缩器，它实质是一个5bit全加器，完成将4bit和1bit进位加法任务。这里4-2压缩的原理是，将5-3全加器的进位输出接到下一个5-3全加器的进位输入，这样级联下去，每一个模块的4bit输入延迟是相同的（这样级联不会增加5-3全加器的总延迟），等效为一个4-2压缩器。
### \_8\_wallace\_tree/\_16\_wallace\_tree/\_32\_wallace\_tree
8/16/32bit Wallace Tree算法压缩器，他是由上面三种简单压缩器复合而成。完全由本工具生成，输入接口与本实例的booth编码器匹配。
### booth_coder
有符号/无符号数的booth编码器，这是一个VerilogHDL描述的可参数化位宽的booth算法编码器。本实例具有一个特色是使用1bit`sign`输入信号指定有无符号数编码，并且在原有的有符号booth算法基础上只增加了一个与设计位宽相同的全加器（设计为8bit乘法器，相比于只支持有符号编码的booth算法，这里会增加一个8ibt加法运算）。
### multer
乘法器的顶层模块，将上面的模块组合起来，只需要将最终压缩器输出的两个结果进行加法运算即可得到最终输出。
## generate\_wallacetree\_verilogcode.c
此文件是本工具的主要源代码。它需要一组数据输入，这组数据是要压缩的bit阵列中每一列的数量。它得到这组输入后，会在终端打印出一些信息包含生成的目标代码。
(**Note:** 此源代码使用了`typeof`关键字，详见[GUN C Extensions](https://gcc.gnu.org/onlinedocs/gcc-4.6.2/gcc/C-Extensions.html#C-Extensions),所以对于某些不支持此特性的C编译器可能会报错)
