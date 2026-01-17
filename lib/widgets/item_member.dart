import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/user/user.dart';

class ItemMember extends StatelessWidget {
  final User user;
  final Future<void> Function(User user)? onDelete;
  const ItemMember({super.key, required this.user, this.onDelete});

  String get initials {
    final f = user.firstname.isNotEmpty ? user.firstname[0] : '';
    final l = user.lastname.isNotEmpty ? user.lastname[0] : '';
    return (f + l).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
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
            if (onDelete != null)
              Positioned(
                top: -4,
                right: -20,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onDelete!(user),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 32, // zone de tap élargie
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface, // fond blanc
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            FontAwesomeIcons.circleXmark,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${user.firstname} ${user.lastname}',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
    // return
    //   Column(
    //     children: [
    //       CircleAvatar(
    //         radius: 28,
    //         backgroundColor: Theme.of(context).colorScheme.primaryFixed,
    //         child: Text(
    //           initials,
    //           style: TextStyle(
    //             color: Theme.of(context).colorScheme.primary,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 8),
    //       Text(
    //         '$firstName $lastName',
    //         textAlign: TextAlign.center,
    //         maxLines: 2,
    //         overflow: TextOverflow.ellipsis,
    //         style: Theme.of(context).textTheme.bodySmall,
    //       ),
    //     ],
    //   );
  }
}
