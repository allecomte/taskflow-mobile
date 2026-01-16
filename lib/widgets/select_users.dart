import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/providers/users_provider.dart';

class SelectUsers extends ConsumerStatefulWidget {
  final List<String> userIdsToExclude;
  final void Function(UserDetailed user) onSelected;
  const SelectUsers({
    super.key,
    required this.userIdsToExclude,
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
          items: usersFiltered.map((user) {
            return DropdownMenuItem<UserDetailed>(
              value: user,
              child: Row(
                children: [
                  Text(user.firstname),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(user.lastname),
                  ),
                ],
              ),
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
      error: (_, _) => const Text('Erreur lors du chargement des utilisateurs'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
