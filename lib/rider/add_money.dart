import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({Key? key}) : super(key: key);

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  String? firstName,
      lastName,
      cardNumber,
      expiryDateMonth,
      expiryDateYear,
      expiryDateStr,
      cvc,
      amount;

  var formkey = GlobalKey<FormState>();

  MaskTextInputFormatter cardNumberMask =
      MaskTextInputFormatter(mask: '#### - #### - #### - ####');
  MaskTextInputFormatter expiryDateMask =
      MaskTextInputFormatter(mask: '## / ####');
  MaskTextInputFormatter cvcMask = MaskTextInputFormatter(mask: '###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เติมเงิน'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 180,
                        child: TextFormField(
                          onChanged: (value) {
                            firstName = value.trim();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาป้อนชื่อ';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'FirstName',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 180,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาป้อนนามสกุล';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            lastName = value.trim();
                          },
                          decoration: InputDecoration(
                            hintText: 'LastName',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณาป้อนหมายเลขบัตรเครดิต';
                        } else {
                          if (cardNumber!.length != 16) {
                            return 'กรุณาป้อนหมายเลขบัตรเครดิตให้ครบจำนวน';
                          } else {
                            return null;
                          }
                        }
                      },
                      inputFormatters: [cardNumberMask],
                      onChanged: (value) {
                        cardNumber = cardNumberMask.getUnmaskedText();
                      },
                      decoration: InputDecoration(
                        hintText: 'Card Number',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 180,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาป้อนวันหมดอายุ';
                            } else {
                              if (expiryDateStr!.length != 6) {
                                return 'กรุณาป้อนให้ครบจำนวน';
                              } else {
                                expiryDateMonth =
                                    expiryDateStr!.substring(0, 2);
                                expiryDateYear = expiryDateStr!.substring(2, 6);

                                int expiryDateMonthInt =
                                    int.parse(expiryDateMonth!);

                                expiryDateMonth = expiryDateMonthInt.toString();

                                if (expiryDateMonthInt > 12) {
                                  return 'กรุณาป้อนวันหมดอายุให้ถูกต้อง';
                                } else {
                                  return null;
                                }
                              }
                            }
                          },
                          onChanged: (value) {
                            expiryDateStr = expiryDateMask.getUnmaskedText();
                          },
                          inputFormatters: [expiryDateMask],
                          decoration: InputDecoration(
                            hintText: 'Date',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 180,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาป้อน CVC';
                            } else {
                              if (cvc != '3') {
                                return 'กรุณาป้อน cvc ให้ครบ';
                              } else {
                                return null;
                              }
                            }
                          },
                          onChanged: (value) {
                            cvc = cvcMask.getUnmaskedText();
                          },
                          inputFormatters: [cvcMask],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'CVC',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: TextFormField(
                      onChanged: (value) {
                        amount = value.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณาป้อนจำนวนเงิน';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'THB.',
                        hintText: 'จำนวนเงินที่ฝาก',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 400),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('ฝากเงิน'),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                        } else {
                          print(
                              '$firstName,$lastName,$cardNumber,$expiryDateMonth,$expiryDateYear,$cvc,$amount');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
