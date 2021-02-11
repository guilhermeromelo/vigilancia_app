import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppMasks {
  AppMasks._();

  //Data Mask
  static  final MaskTextInputFormatter dataMask = MaskTextInputFormatter(
      mask: '##/##/##', filter: {"#": RegExp(r'[0-9]')}, initialText: "");

  //Hour Mask
  static  final MaskTextInputFormatter hourMask = MaskTextInputFormatter(
      mask: '##:##', filter: {"#": RegExp(r'[0-9]')}, initialText: "");

  //CPF Mask
  static final MaskTextInputFormatter cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

}
