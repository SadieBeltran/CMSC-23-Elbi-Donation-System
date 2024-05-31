import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrgInfoPage extends StatefulWidget {
  final Organization org;
  const AdminOrgInfoPage({required this.org, super.key});

  @override
  State<AdminOrgInfoPage> createState() => _AdminOrgInfoPageState();
}

class _AdminOrgInfoPageState extends State<AdminOrgInfoPage> {
  bool _isPending = false;

  @override
  void initState() {
    super.initState();
    _isPending = !widget.org.accepted;
  }

  void _acceptApproval() async {
    try {
      await Provider.of<OrgListProvider>(context, listen: false)
          .acceptOrganization(widget.org.uid!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Organization approved'),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to approve organization: $e'),
      ));
    }
  }

  void _declineApproval() async {
    try {
      await Provider.of<OrgListProvider>(context, listen: false)
          .deleteOrganization(widget.org.uid!);
      // await Provider.of<UserAuthProvider>(context, listen: false).deleteCurrentUserAccount();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Organization and account deleted successfully'),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete organization and account: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.org.organizationName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.org.organizationName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Addresses:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        for (var address in widget.org.addresses)
                          Padding(
                            padding: const EdgeInsets.only(left: 32, top: 4),
                            child: Text(
                              address,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.description, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.org.description ?? '',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.contact_phone, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.org.contactNumber,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          widget.org.accepted
                              ? Icons.check_circle
                              : Icons.pending,
                          color: widget.org.accepted
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.org.accepted ? 'Approved' : 'Pending Approval',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_isPending)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _acceptApproval,
                            child: Text('Accept'),
                          ),
                          ElevatedButton(
                            onPressed: _declineApproval,
                            child: Text('Decline'),
                          ),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Proof of Legitimacy:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Image.network(
                          widget.org.proofOfLegitimacy,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
