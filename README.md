# Wallace Tree VerilogHDL Code
  这个工具用于自动生成一个Wallace Tree算法VerilogHDL代码实例，并附带了一些配套的工具和一个完整的VerilogHDL描述的乘法器。
## multer.v
  此文件为一个使用VerilogHDL描述的纯组合逻辑乘法器。其中它包含4-2压缩器，3-2压缩器，半加器，支持有符号/无符号数的booth编码器，与booth编码器输出接口匹配的8/16/32bit Wallace Tree算法压缩器（完全由本工具生成）。这些模块组合成一个同时支持有符号/无符号数乘法器。
### half_adder
  半加器，它完成压缩算法中2bit位加法功能。
### compressor_3_2
  3-2压缩器，它实质是一个3bit全加器，完成将2bit位和1bit进位加法功能。
### compressor_4_2
  4-2压缩器，它实质是一个5bit全加器，完成将4bit和1bit进位加法任务。这里4-2压缩的原理是，将5-3全加器的进位输出接到下一个5-3全加器的进位输入，这样级联下去，每一个模块的4bit输入延迟是相同的（这样级联不会增加5-3全加器的总延迟），等效为一个4-2压缩器。
### _8_wallace_tree _16_wallace_tree _32_wallace_tree
  8bit Wallace Tree算法压缩器，他是由上面三种简单压缩器复合而成。完全由本工具生成，输入接口与本实例的booth编码器匹配。
