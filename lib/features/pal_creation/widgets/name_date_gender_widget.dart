import 'package:flutter/material.dart';

import '../../../components/text_widgets/text_widgets.dart';

class UserInfoCard extends StatelessWidget {
  final String? name;
  final String? lastName;
  final String? dateOfBirth;
  final String? gender;

  const UserInfoCard({
    super.key,
    this.name,
    this.lastName,
    this.dateOfBirth,
    this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(
          label: 'Name',
          value: '${name ?? ''} ${lastName ?? ''}'.trim().isEmpty
              ? 'Not provided'
              : '${name ?? ''} ${lastName ?? ''}'.trim(),
        ),
        const SizedBox(height: 16),
        InfoRow(
          label: 'Date of Birth',
          value:
              dateOfBirth?.isNotEmpty == true ? dateOfBirth! : 'Not provided',
        ),
        const SizedBox(height: 16),
        InfoRow(
          label: 'Gender',
          value: gender?.isNotEmpty == true ? gender! : 'Not provided',
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Sixteen400GreyText(label),
        Sixteen400BlackText(value),
      ],
    );
  }
}
