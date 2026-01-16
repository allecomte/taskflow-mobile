import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/widgets/select_users.dart';

class AddUserBottomSheet extends ConsumerStatefulWidget {
  final List<String> userIdsToExclude;
  const AddUserBottomSheet({super.key, required this.userIdsToExclude});

  @override
  ConsumerState<AddUserBottomSheet> createState() => AddUserBottomSheetState();
}

class AddUserBottomSheetState extends ConsumerState<AddUserBottomSheet> {
  UserDetailed? userSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 14,
            bottom: 14,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      FontAwesomeIcons.user,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Ajouter un membre',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SelectUsers(
                userIdsToExclude: widget.userIdsToExclude,
                onSelected: (user) => {
                  setState(() {
                    userSelected = user;
                  }),
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: userSelected == null
                    ? null
                    : () => Navigator.pop(context, userSelected),
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
