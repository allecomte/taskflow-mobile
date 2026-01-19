import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/user/user.dart';

class DeleteUserBottomSheet extends StatelessWidget {
  final User user;

  const DeleteUserBottomSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  FontAwesomeIcons.trash,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                'Retirer le membre du projet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Voulez-vous retirer définitivement ${user.firstname} ${user.lastname} du projet ?',
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 4),child: Icon(
                FontAwesomeIcons.triangleExclamation,
                size: 14,
                color: Theme.of(context).colorScheme.error,
              ),)
              ,
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Un membre étant associé à une tâche ne peut être supprimé.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Supprimer',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
