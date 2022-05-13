import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../change_user_name_view/change_user_name_view.dart';
import 'cubit/usersettings_cubit.dart';

class UserSettingsView extends StatelessWidget {
  const UserSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserSettingsCubit(auth: FirebaseAuth.instance, user: FirebaseAuth.instance.currentUser),
      child: BlocConsumer<UserSettingsCubit, UserSettingsState>(
        listener: (context, state) {},
        builder: (context, state) {
          final shortUserModel = context.read<UserSettingsCubit>().user;
          return Scaffold(
            appBar: appBar(context),
            body: Column(
              children: [
                profileWidget(context, shortUserModel),
                userNameBTN(context),
                passwordBTN(context),
                mailBTN(context),
                deleteBTN(context),
                helpBTN(context),
                logOutBTN(context)
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Settings", style: Theme.of(context).textTheme.headline5),
      elevation: 0,
    );
  }

  ListTile profileWidget(BuildContext context, User? tempUser) {
    return ListTile(
      contentPadding: context.paddingLow,
      leading: GestureDetector(
        onTap: () {
          context.read<UserSettingsCubit>().changeImage(context);
        },
        child: CircleAvatar(
          backgroundImage: tempUser?.photoURL != null ? NetworkImage("${tempUser?.photoURL}") : null,
          radius: context.dynamicHeight(0.05),
          child: tempUser?.photoURL == null ? Image.asset("assets/icon/dummy_per.png") : null,
        ),
      ),
      title: Text(tempUser?.displayName ?? "Null user name"),
      subtitle: Text(tempUser?.email ?? "null mail"),
    );
  }

  GestureDetector userNameBTN(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<UserSettingsCubit>().changePage(context, const ChangeUserName());
      },
      child: const ListTile(
        leading: Icon(Icons.account_box),
        title: Text("Change user name"),
      ),
    );
  }

  ListTile passwordBTN(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.lock),
      title: Text("Change password"),
    );
  }

  ListTile mailBTN(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.mail),
      title: Text("Change e-mail"),
    );
  }

  ListTile deleteBTN(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.sd_card),
      title: Text("Delete account"),
    );
  }

  ListTile helpBTN(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.help),
      title: Text("Help"),
    );
  }

  GestureDetector logOutBTN(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<UserSettingsCubit>().logOut(context);
      },
      child: const ListTile(
        leading: Icon(Icons.logout),
        title: Text("Log out"),
      ),
    );
  }
}
