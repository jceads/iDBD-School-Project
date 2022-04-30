import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import '../about_view/about_view.dart';
import '../profile_view/profile_view.dart';
import '../../product/book_categories/categories.dart';

import '../../product/drawer_item_custom/custom_drawer_item.dart';
import '../../product/home_book_card/home_book_card.dart';
import 'cubit/home_view_cubit.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key, required this.goToProfilePageFunc}) : super(key: key);
  VoidCallback goToProfilePageFunc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeViewCubit>(
      create: (context) => HomeViewCubit(),
      child: BlocConsumer<HomeViewCubit, HomeViewState>(
        listener: (context, state) {},
        builder: (context, state) {
          return DefaultTabController(
            length: Categories.instance.getLength ?? 0,
            child: Scaffold(
              appBar: appBar(context),
              drawer: drawer(context),
              body: body(context),
            ),
          );
        },
      ),
    );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: SizedBox(
                width: context.dynamicWidth(0.3),
                child: CircleAvatar(
                  backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                      ? NetworkImage("${FirebaseAuth.instance.currentUser?.photoURL}")
                      : null,
                  child: FirebaseAuth.instance.currentUser?.photoURL == null
                      ? Image.asset("assets/icon/dummy_per.png")
                      : null,
                ),
              )),
              Text("${FirebaseAuth.instance.currentUser?.displayName?.toUpperCase()}")
            ],
          ),
          CustomDrawerItem(
              leadingIcon: Icons.person,
              text: "Profile",
              onTapFunc: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileView(),
                ));
              }),
          const Divider(),
          CustomDrawerItem(
              leadingIcon: Icons.sd_card,
              text: "About",
              onTapFunc: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutView()));
              }),
          const Divider(),
          CustomDrawerItem(leadingIcon: Icons.help, text: "Help", onTapFunc: () async {}),
          const Divider(),
          CustomDrawerItem(
            leadingIcon: Icons.logout,
            text: "Log out",
            onTapFunc: () async {
              await context.read<HomeViewCubit>().logOut(context);
            },
          )
        ],
      ),
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: context.paddingNormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back, ${FirebaseAuth.instance.currentUser?.displayName}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
            ),
            Text("What do yo want to read to today? ",
                style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(
              height: context.dynamicHeight(0.02),
            ),
            TabBar(
              tabs: Categories.instance.toTab() ?? [],
              isScrollable: true,
              indicatorColor: Colors.red,
              indicatorWeight: 3,
              onTap: (categorieName) {
                context
                    .read<HomeViewCubit>()
                    .getBooksFromCategories(Categories.instance.getCategorieList?[categorieName] ?? "");
              },
            ),
            SizedBox(
              height: context.dynamicHeight(0.4),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: context.read<HomeViewCubit>().categorieBooks?.items?.length,
                itemBuilder: (BuildContext context, int index) {
                  if (context.read<HomeViewCubit>().loadState == IsLoading.yes) {
                    return SizedBox(
                        width: context.dynamicWidth(0.4),
                        child: const Center(child: CircularProgressIndicator()));
                  }
                  return HomeBookCard(
                    model: context.read<HomeViewCubit>().categorieBooks?.items?[index].volumeInfo,
                    context: context,
                  );
                },
              ),
            ),
            Text("New Arrivals", style: Theme.of(context).textTheme.headline5),
            bookShelf(context),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              child: CircleAvatar(
                backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                    ? NetworkImage("${FirebaseAuth.instance.currentUser?.photoURL}")
                    : null,
                child: FirebaseAuth.instance.currentUser?.photoURL == null
                    ? Image.asset("assets/icon/dummy_per.png")
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(width: context.dynamicWidth(0.05))
      ],
    );
  }

  SizedBox bookShelf(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.4),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return SizedBox(
            height: context.dynamicHeight(0.3),
            child: Padding(
              padding: context.paddingLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.dynamicHeight(0.015)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "https://picsum.photos/150/200",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: context.dynamicHeight(0.015)),
                  Text("Kitap Adı"),
                  Text(
                    "Yazar",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          );
        },
        itemCount: 5,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
