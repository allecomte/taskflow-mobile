import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemMember extends StatelessWidget{
  final String firstName;
  final String lastName;
  const ItemMember({super.key, required this.firstName, required this.lastName});

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return (f + l).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return 
    // SizedBox(
    //   width: 90,
    //   child: 
      Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            child: Text(
              initials,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$firstName $lastName',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    // );
  }

}