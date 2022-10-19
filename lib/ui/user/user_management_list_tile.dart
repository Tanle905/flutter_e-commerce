import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';

class UserManagementListTile extends StatefulWidget {
  final User user;
  const UserManagementListTile({Key? key, required this.user})
      : super(key: key);

  @override
  State<UserManagementListTile> createState() => _UserManagementListTileState();
}

class _UserManagementListTileState extends State<UserManagementListTile> {
  bool isDeactivated = false;
  bool isLoading = false;

  @override
  void initState() {
    isDeactivated = widget.user.isDeactivated ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.username,
            style: themeData.textTheme.titleMedium,
            textAlign: TextAlign.start,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          Text(
            widget.user.email,
            style: themeData.textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
          widget.user.phoneNumber != null
              ? Text(
                  widget.user.phoneNumber.toString(),
                  style: themeData.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                )
              : const SizedBox.shrink(),
        ],
      ),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Status',
              style: themeData.textTheme.titleMedium,
            ),
            Expanded(
                child: Switch(
              onChanged: isLoading
                  ? null
                  : (bool value) async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final response =
                            await setUserStatus(widget.user.userId, !value);
                        if (response != null) {
                          showSnackbar(
                              context: context, message: response['message']);
                        }
                      } catch (error) {
                        rethrow;
                      }
                      setState(() {
                        isDeactivated = !value;
                        isLoading = false;
                      });
                    },
              value: !isDeactivated,
            ))
          ]),
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            width: 50,
            height: 50,
            child: widget.user.imageUrl != null
                ? Image.network(
                    widget.user.imageUrl as String,
                    fit: BoxFit.cover,
                  )
                : const Image(
                    image: IMAGE_PLACEHOLDER,
                  ),
          )),
    );
  }
}
