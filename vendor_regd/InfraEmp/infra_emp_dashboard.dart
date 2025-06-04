import 'package:flutter/material.dart';

import '../../../Utils/constants.dart';
import '../vendors_listing.dart';

class InfraEmpDashboard extends StatelessWidget {
  const InfraEmpDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const VendorsListing(isInfraEmp: true);
  }
}
