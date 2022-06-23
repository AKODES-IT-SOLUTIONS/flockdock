import 'dart:async';
import 'package:flocdock/View/base/custom_snackbar.dart';
import 'package:flocdock/View/base/loading_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
const _timer = 120;

class OtpVerificationPage extends StatefulWidget {
  final String phone;

  OtpVerificationPage(this.phone);

  @override
  OtpVerificationPageState createState() => OtpVerificationPageState();
}

class _OtpField extends Container {
  _OtpField(String text)
      : super(
    width: 30,
    height: 45,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    ),
  );
}

class OtpVerificationPageState extends State<OtpVerificationPage> {
  String? _verificationId;

  final _node = FocusNode();
  final _controller = TextEditingController();
  final _codes = List.filled(6, '', growable: false);

  final _auth = FirebaseAuth.instance;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future verifyNumber(String phoneNumber, BuildContext context) async {
    print("hello i a here");
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      codeSent: (String verificationId, [int? forceCodeResend])  {
        print("hey code sent");
        _verificationId = verificationId;
        print(_verificationId);
         print("hey code sent");
      },
      timeout: const Duration(seconds: _timer),
      verificationCompleted: (AuthCredential credential) async {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.of(context).pop(true);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print("shahzaib");
        print('${exception.message}');
        print("shahzaib");

      },
    );
  }

  Future<bool> signInWithOTP(smsCode, verId) async {
    // showDialog(
    //   context: context,
    //   builder: (context) => WaitingDialog(message: 'Verifying Phone Number'),
    // );
    openLoadingDialog(context, "Verifying");
    if(verId==null) return false;
    final credentials =
    PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);

    try {
      final result = await _auth.signInWithCredential(credentials);

      if (result.user != null) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.of(context).pop();
        showCustomSnackBar("Verified");
        return true;
      }
    } catch (e) {
      Navigator.of(context).pop();
      showCustomSnackBar(e.toString());
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    verifyNumber(widget.phone, context);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.phone);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("OTP Verification"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           Text('Enter the 6-digit code sent to you at',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 17,
                    color: const Color(0xff7f7f7f),
                    height: 1.1176470588235294,
                  ),
                  textAlign: TextAlign.left,
                ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                text: widget.phone,
                children: [
                  // TextSpan(
                  //   text: '  Change',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.normal,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  //   recognizer: TapGestureRecognizer()
                  //     ..onTap = () {
                  //       Navigator.of(context).pop(false);
                  //     },
                  // )
                ],
              ),
            ),
            Center(
              child: Container(
                width: 220,
                padding: const EdgeInsets.only(top: 40),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0,
                      child: TextFormField(
                        maxLength: 6,
                        maxLengthEnforced: true,
                        keyboardType: TextInputType.number,
                        focusNode: _node,
                        controller: _controller,
                        onChanged: (val) {
                          final codes = val.split('');

                          for (var i = 0; i < _codes.length; ++i) {
                            if (i < codes.length) {
                              _codes[i] = codes[i];
                            } else {
                              _codes[i] = '';
                            }
                          }

                          setState(() {});
                          if (codes.length == 6) {
                            matchOtp();
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_node.hasFocus) {
                          SystemChannels.textInput.invokeMethod('TextInput.show');
                        } else {
                          _node.requestFocus();
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        child: Row(children: [
                          _OtpField(_codes[0]),
                          _OtpField(_codes[1]),
                          _OtpField(_codes[2]),
                          _OtpField(_codes[3]),
                          _OtpField(_codes[4]),
                          _OtpField(_codes[5]),
                        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _ResendTimer(onResend: () {
                verifyNumber(widget.phone, context);
              }),
            )
          ]),
      ),
    );
  }

  void matchOtp() async {
    print("matching");
    if (await signInWithOTP(_controller.text, _verificationId)) {
      /// Restore State of Guest User;
      /// ----------------------------
      ///
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop(true);
    }
  }
}

class _ResendTimer extends StatefulWidget {
  final List<int>? gaps;
  final Function? onResend;

  _ResendTimer({this.gaps, this.onResend});

  @override
  __ResendTimerState createState() => __ResendTimerState();
}

class __ResendTimerState extends State<_ResendTimer> {
  var _allow = false;
  final _controller = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _startCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Text("Didn't receive a code?", style: TextStyle(color: Colors.grey.shade600)),
      SizedBox(height: 5),
      if (_allow)
        GestureDetector(
          onTap: () {
            widget.onResend!();

            setState(() => _allow = false);

            _startCounter();
          },
          child: Text('Resend Code', style: TextStyle(color: Theme.of(context).primaryColor)))
      else
        StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Wait for ' + _buildTime(snapshot.data as int),
                style: TextStyle(color: Theme.of(context).primaryColor),
              );
            } else {
              return Text('...');
            }
          },
        )
    ], direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center);
  }

  static _buildTime(int seconds) {
    final _seconds = seconds % 60;
    final _minutes = seconds ~/ 60;

    return _minutes.toString().padLeft(2, '0') +
        ':' +
        _seconds.toString().padLeft(2, '0');
  }

  void _startCounter() async {
    var len = _timer;

    while (len >= 0) {
      if (_controller.isClosed) return;
      await Future.delayed(Duration(seconds: 1), () {
        if (_controller.isClosed) return;
        _controller.add(len--);
      });
    }

    setState(() {
      _allow = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }
}

// import 'dart:async';
// import 'package:bisbooster/widgets/appbar.dart';
// import 'package:bisbooster/widgets/booster-button.dart';
// import 'package:bisbooster/widgets/custom-navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'base-page.dart';
//
// class OtpVerification extends StatefulWidget {
//   @override
//   _OtpVerificationState createState() => _OtpVerificationState();
// }
//
// class _OtpVerificationState extends State<OtpVerification> {
//
//   final _node = FocusNode();
//   final _controller = TextEditingController();
//   final _codes = List.filled(6, '', growable: false);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BisBoosterAppBar(
//         context: context,
//         title: "OTP Verification",
//         backgroundColor: Colors.grey.shade50,
//       ),
//       body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Enter the 4-digit code sent to you at',
//                 style: TextStyle(
//                   fontFamily: 'Nunito Sans',
//                   fontSize: 17,
//                   color: const Color(0xff7f7f7f),
//                   height: 1.1176470588235294,
//                 ),
//                 textAlign: TextAlign.left,
//               ),
//               SizedBox(height: 10,),
//               Row(
//                 children: [
//                   Text(
//                     '+91 111 11231',
//                     style: TextStyle(
//                       fontFamily: 'Nunito Sans',
//                       fontSize: 17,
//                       color: const Color(0xff282f39),
//                       height: 1.1176470588235294,
//                     ),
//                     textAlign: TextAlign.left,
//                   ),
//                   SizedBox(width: 30,),
//                   Text(
//                     'Edit',
//                     style: TextStyle(
//                       fontFamily: 'Nunito Sans',
//                       fontSize: 18,
//                       color: const Color(0xff3369ff),
//                       height: 1.1111111111111112,
//                     ),
//                     textAlign: TextAlign.left,
//                   ),
//                 ],
//               ),
//               Center(
//                 child: Container(
//                   width: 220,
//                   padding: const EdgeInsets.only(top: 40),
//                   child: Stack(
//                     children: [
//                       Opacity(
//                         opacity: 0,
//                         child: TextFormField(
//                           maxLength: 6,
//                           maxLengthEnforced: true,
//                           keyboardType: TextInputType.number,
//                           focusNode: _node,
//                           controller: _controller,
//                           onChanged: (val) {
//                             final codes = val.split('');
//
//                             for (var i = 0; i < _codes.length; ++i) {
//                               if (i < codes.length) {
//                                 _codes[i] = codes[i];
//                               } else {
//                                 _codes[i] = '';
//                               }
//                             }
//
//                             setState(() {});
//                             if (codes.length == 6) {
//                               // matchOtp();
//                             }
//                           },
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (_node.hasFocus) {
//                             SystemChannels.textInput.invokeMethod('TextInput.show');
//                           } else {
//                             _node.requestFocus();
//                           }
//                         },
//                         child: Container(
//                           color: Colors.white,
//                           child: Row(children: [
//                             _OtpField(_codes[0]),
//                             _OtpField(_codes[1]),
//                             _OtpField(_codes[2]),
//                             _OtpField(_codes[3]),
//                             _OtpField(_codes[4]),
//                             _OtpField(_codes[5]),
//                           ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//
//               Padding(
//                 padding: const EdgeInsets.only(top:20.0),
//                 child: BoosterButton(
//                   name: 'Continue',
//                   onTap: (){
//                     CustomNavigator.pushReplacement(context, BasePage());
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20.0),
//                 child: Center(
//                   child: _ResendTimer(onResend: () {
//
//                   }),
//                 ),
//               )
//             ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class _ResendTimer extends StatefulWidget {
//   final List<int> gaps;
//   final Function onResend;
//
//   _ResendTimer({this.gaps, this.onResend});
//
//   @override
//   __ResendTimerState createState() => __ResendTimerState();
// }
//
// class __ResendTimerState extends State<_ResendTimer> {
//   var _allow = false;
//   final _controller = StreamController.broadcast();
//
//   @override
//   void initState() {
//     super.initState();
//     _startCounter();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(children: [
//       Text(
//         "Didn't receive a code?",
//         style: TextStyle(color: Colors.grey.shade600),
//       ),
//       SizedBox(height: 5),
//       if (_allow)
//         GestureDetector(
//           onTap: () {
//             widget.onResend();
//
//             setState(() => _allow = false);
//
//             _startCounter();
//           },
//           child: Text(
//             'Resend Code',
//             style: TextStyle(color: Theme.of(context).primaryColor),
//           ),
//         )
//       else
//         StreamBuilder(
//           stream: _controller.stream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Text(
//                 'Wait for ' + _buildTime(snapshot.data),
//                 style: TextStyle(color: Theme.of(context).primaryColor),
//               );
//             } else {
//               return Text('...');
//             }
//           },
//         )
//     ], direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center);
//   }
//
//   static _buildTime(int seconds) {
//     final _seconds = seconds % 60;
//     final _minutes = seconds ~/ 60;
//
//     return _minutes.toString().padLeft(2, '0') +
//         ':' +
//         _seconds.toString().padLeft(2, '0');
//   }
//
//   void _startCounter() async {
//     var len = 10;
//
//     while (len >= 0) {
//       if (_controller.isClosed) return;
//       await Future.delayed(Duration(seconds: 1), () {
//         if (_controller.isClosed) return;
//         _controller.add(len--);
//       });
//     }
//
//     setState(() {
//       _allow = true;
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.close();
//   }
// }
//
// class _OtpField extends Container {
//   _OtpField(String text)
//       : super(
//     width: 30,
//     height: 45,
//     decoration: BoxDecoration(
//       color: Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(4),
//     ),
//     child: Center(
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.grey.shade600,
//         ),
//       ),
//     ),
//   );
// }