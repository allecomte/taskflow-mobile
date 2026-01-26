import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/providers/users_provider.dart';
import 'package:taskflow_mobile/widgets/skeleton/line_skeleton.dart';

class SelectUsers extends ConsumerStatefulWidget {
  final List<String> userIdsToExclude;
  final String? initialValue;
  final void Function(UserDetailed user) onSelected;
  const SelectUsers({
    super.key,
    required this.userIdsToExclude,
    this.initialValue,
    required this.onSelected, 
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SelectUsersState();
}

class SelectUsersState extends ConsumerState<SelectUsers> {
  UserDetailed? userSelected;
  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return usersAsync.when(
      data: (users) {
        final usersFiltered = users
            .where((u) => !widget.userIdsToExclude.contains(u.id))
            .toList();

        if (usersFiltered.isEmpty) {
          return const Text('Aucun utilisateur disponible');
        }

        return DropdownButtonFormField<UserDetailed>(
          decoration: const InputDecoration(labelText: 'Utilisateur'),
          initialValue: userSelected ??
              (widget.initialValue != null
                  ? usersFiltered.firstWhere(
                      (user) => user.id == widget.initialValue,
                    )
                  : null),
          items: usersFiltered.map((user) {
            return DropdownMenuItem<UserDetailed>(
              value: user,
              child: Text('${user.firstname} ${user.lastname}'),
            );
          }).toList(),
          onChanged: (user) {
            if (user != null) {
              setState(() => userSelected = user);
              widget.onSelected(user);
            }
          },
        );
      },
      error: (_, _) => Text('Erreur lors du chargement des utilisateurs',style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          )),
      loading: () => LineSkeleton(context: context),
    );
  }
}
