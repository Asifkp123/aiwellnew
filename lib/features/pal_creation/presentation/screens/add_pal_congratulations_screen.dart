// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../../components/buttons/label_button.dart';
// import '../../../../components/constants.dart';
// import '../../../../components/text_widgets/text_widgets.dart';
// import '../../../../components/small_widgets.dart';
// import '../../../home/home_screen.dart';

// class AddPalCongratulationsScreen extends StatelessWidget {
//   static const String routeName = '/addPalCongratulationsScreen';

//   const AddPalCongratulationsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           // height: 500,
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height,

//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: const LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFFE4D6FA),
//                 Color(0xFFF1EAFE),
//                 Color(0xFFFFFFFF),
//                 Color(0xFFF1EAFE),
//                 Color(0xFFE4D6FA),
//               ],
//               stops: [0.0, 0.2, 0.5, 0.8, 1.0],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header with close button
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: SizedBox(), // Empty space for centering
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.black,
//                         size: 24,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Congratulations content
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 340),

//                     // Congratulations title
//                     LargePurpleText(
//                       "Congratulations",
//                       fontSize: 28,
//                       align: TextAlign.center,
//                     ),

//                     const SizedBox(height: 12),

//                     // Subtitle
//                     NormalGreyText(
//                       "Thank you for caring for your Pal",
//                       fontSize: 16,
//                       align: TextAlign.center,
//                     ),
//                     const SizedBox(height: 130),

//                     // Care Points Card
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               // Heart icon with points
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color(0xFF543474).withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SvgPicture.asset(
//                                       '$svgPath/purple_love.svg',
//                                       width: 20,
//                                       height: 20,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     MediumPurpleText(
//                                       "120",
//                                       fontSize: 18,
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               const SizedBox(width: 15),

//                               // Text content
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     MediumPurpleText(
//                                       "You Earned Care Points",
//                                       fontSize: 16,
//                                     ),
//                                     const SizedBox(height: 4),
//                                     GestureDetector(
//                                       onTap: () {
//                                         // TODO: Navigate to care points usage guide
//                                       },
//                                       child: NormalGreyText(
//                                         "Check how to use it",
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),

//               // Continue button
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 30,
//                   right: 30,
//                   bottom: 30,
//                 ),
//                 child: LabelButton(
//                   label: 'Continue',
//                   onTap: () {
//                     Navigator.pushReplacementNamed(
//                       context,
//                       HomeScreen.routeName,
//                     );
//                   },
//                   gradient: splashGradient(),
//                   fontColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacementNamed(
//             context,
//             HomeScreen.routeName,
//           );
//         },
//         child: LabelButton(
//           label: 'Continue',
//           onTap: () {
//             Navigator.pushReplacementNamed(
//               context,
//               HomeScreen.routeName,
//             );
//           },
//           gradient: splashGradient(),
//           fontColor: Colors.white,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
