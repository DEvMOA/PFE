import 'package:flutter/material.dart';

String? uValidator({
  @required var value,
  bool isRequred = false,
  bool isEmail = false,
  bool isAmount = false,
  bool isPinCode = false,
  var minLength,
  var match,
}) {
  if (isRequred) {
    if (value.isEmpty) {
      return 'Required';
    }
  }

  if (isEmail) {
    if (!value.contains('@') || !value.contains('.')) {
      return 'Invalid Email';
    }
  }
  if (isAmount) {
    if (value.contains(',') ||
        value.contains('.') ||
        value.contains('-') ||
        value.contains(' ')) {
      return 'Invalid Value';
    }
  }

  if (minLength != null) {
    if (value.length < minLength) {
      return 'Min $minLength character';
    }
  }

  if (match != null) {
    if (value != match) {
      return 'Not Match';
    }
  }

  if (isPinCode) {
    return 'Not Match';
  }

  return null;
}

// Color SwicthColor({required var userData}) {
//   if (userData == null) {
//     return Color(0xFF1C3E66);
//   } else {
//     if (userData.primaryColor == 'Color1') {
//       return Color(0xFF1C3E66);
//     } else {
//       if (userData.primaryColor == 'Color2') {
//         return Colors.deepPurple;
//       } else {
//         if (userData.primaryColor == 'Color3') {
//           return Colors.blue;
//         } else {
//           return Color(0xFF1C3E66);
//         }
//       }
//     }
//   }
// }

// Color SwicthColorSecondary({required var userData}) {
//   if (userData == null) {
//     return Color.fromARGB(116, 28, 63, 102);
//   } else {
//     if (userData.primaryColor == 'Color1') {
//       return Color.fromARGB(116, 28, 63, 102);
//     } else {
//       if (userData.primaryColor == 'Color2') {
//         return Colors.deepPurpleAccent;
//       } else {
//         if (userData.primaryColor == 'Color3') {
//           return Colors.blueAccent;
//         } else {
//           return Color.fromARGB(116, 28, 63, 102);
//         }
//       }
//     }
//   }
// }

// String SwicthLangues(
//     {required var userData, required String fr, required String en}) {
//   if (userData == null) {
//     return fr;
//   } else {
//     if (userData.langues == 'Français') {
//       return fr;
//     } else {
//       if (userData.langues == 'Anglais') {
//         return en;
//       } else {
//         return fr;
//       }
//     }
//   }
// }

// final Connectivity _connectivity = Connectivity();

// bool CheckState() {
//   bool hideUi = true;
//   _connectivity.onConnectivityChanged.listen((event) {
//     if (event == ConnectivityResult.none) {
//       hideUi == true;
//     } else {
//       hideUi == false;
//     }
//   });
//   return hideUi;
// }
