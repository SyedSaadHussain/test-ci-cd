// import 'package:flutter/material.dart';
//
// import '../../core/models/mosque_local.dart';
//
//
// class ViewBasicInfoTab extends StatelessWidget {
//   final MosqueLocal local;
//
//   const ViewBasicInfoTab({
//     super.key,
//     required this.local,
//   });
//
//   // Helper to safely display a value from the payload or a placeholder.
//   String _getPayloadValue(String key, {String defaultValue = 'Not specified'}) {
//     return (local.payload?[key] ?? defaultValue).toString();
//   }
//
//   // A more robust way to display the observer's name for a view-only screen.
//   // This looks for the name in the payload, which is better than assuming it's the current user.
//   String _getObserverName() {
//     final names = local.payload?['observer_names'];
//     if (names is List && names.isNotEmpty) {
//       return names.join(', '); // Handles one or more observers
//     }
//     return 'Not specified';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(12),
//       children: [
//         CustomFormField(
//           title: 'Observer',
//           value: _getObserverName(),
//           isReadonly: true, // All fields are now read-only
//         ),
//         const SizedBox(height: 10),
//
//         CustomFormField(
//           title: 'Name',
//           value: local.name ?? 'Not specified',
//           isReadonly: true,
//         ),
//         const SizedBox(height: 10),
//
//         CustomFormField(
//           title: 'Number',
//           value: _getPayloadValue('number'),
//           isReadonly: true,
//         ),
//         const SizedBox(height: 10),
//
//         CustomFormField(
//           title: 'Classification',
//           value: local.classification ?? 'Not specified',
//           isReadonly: true,
//         ),
//         const SizedBox(height: 10),
//
//         CustomFormField(
//           title: 'Stage',
//           value: _getPayloadValue('stage'),
//           isReadonly: true,
//         ),
//
//         // The GeoCaptureSection would also need a view-only version.
//         // For example:
//         // const SizedBox(height: 16),
//         // GeoCaptureViewSection(local: local),
//       ],
//     );
//   }
// }