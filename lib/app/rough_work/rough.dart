// // appBar: AppBar(
// //   backgroundColor: Colors.blue,
// //   title: const Padding(
// //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
// //     child: Row(
// //       mainAxisSize: MainAxisSize.min,
// //       crossAxisAlignment: CrossAxisAlignment.center,
// //       children: [
// //         Text(
// //           'Hello,',
// //           style:
// //               TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
// //         ),
// //         SizedBox(width: 4.0),
// //         Text(
// //           ' Abhiram!',
// //           style:
// //               TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
// //         ),
// //       ],
// //     ),
// //   ),
// //   actions: const [
// //     Padding(
// //       padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
// //       child: CircleAvatar(
// //         backgroundImage: AssetImage('assets/man.png'),
// //       ),
// //     ),
// //   ],
// // ),

// //complete code

// Widget _buildRecentlyAddedList(double heightFactor, double widthFactor) {
//   return Obx(() {
//     return ListView.builder(
//       itemCount: controller.recentlyAdded.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         final item = controller.recentlyAdded[index];

//         Color categoryColor;
//         IconData categoryIcon;
//         switch (item['subCategory']) {
//           case 'Income':
//             categoryColor = AppColors.incomeColor;
//             categoryIcon = Icons.arrow_circle_up;
//             break;
//           case 'Expense':
//             categoryColor = AppColors.expenseColor;
//             categoryIcon = Icons.arrow_circle_down;
//             break;
//           default:
//             categoryColor = Colors.grey;
//             categoryIcon = Icons.help_outline;
//         }

//         return GestureDetector(
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             margin: EdgeInsets.symmetric(
//               horizontal: 16 * widthFactor,
//               vertical: 8 * heightFactor,
//             ),
//             child: GlassmorphicContainer(
//               width: double.infinity,
//               height: 160 * heightFactor,
//               borderRadius: 16,
//               blur: 20,
//               alignment: Alignment.bottomCenter,
//               border: 1,
//               linearGradient: LinearGradient(
//                 colors: [Colors.grey.shade300, Colors.white.withOpacity(0.2)],
//               ),
//               borderGradient: LinearGradient(
//                 colors: [Colors.white.withOpacity(0.5), Colors.grey.shade200],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(16 * widthFactor),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 24 * widthFactor,
//                               backgroundColor: categoryColor.withOpacity(0.2),
//                               child: Icon(
//                                 categoryIcon,
//                                 size: 20 * heightFactor,
//                                 color: categoryColor,
//                               ),
//                             ),
//                             SizedBox(width: 12 * widthFactor),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item['subCategory'],
//                                   style: TextStyle(
//                                     fontSize: 16 * heightFactor,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                                 Text(
//                                   item['source'],
//                                   style: TextStyle(
//                                     fontSize: 14 * heightFactor,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "\₹${item['amount'].toStringAsFixed(2)}",
//                           style: TextStyle(
//                             fontSize: 16 * heightFactor,
//                             fontWeight: FontWeight.bold,
//                             color: categoryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8 * heightFactor),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           item['date'],
//                           style: TextStyle(
//                             fontSize: 14 * heightFactor,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             item['description'],
//                             textAlign: TextAlign.end,
//                             style: TextStyle(
//                               fontSize: 14 * heightFactor,
//                               color: Colors.black54,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   });
// }
