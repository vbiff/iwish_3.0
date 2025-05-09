import 'package:cupertino_container/cupertino_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/presentation/auth/authentication/auth_gate.dart';
import 'package:i_wish/presentation/auth/profile/profile_provider.dart';
import '../../../../core/ui/styles.dart';
import '../../../core/widgets/user_avatar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    ref.read(profileProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.read(profileProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: const Text(
            'You wish!',
            style: AppStyles.textStyleSoFoSans,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                profile.logoutUser();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AuthGate(),
                  ),
                );
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      backgroundColor: AppStyles.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(
          top: AppStyles.paddingMain,
          left: AppStyles.paddingMain,
          right: AppStyles.paddingMain,
          bottom: 48.0,
        ),
        child: CupertinoContainer(
          width: double.infinity,
          radius: BorderRadius.circular(16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 8.0,
              children: [
                const FittedBox(
                  child: Text('Hi, Kseniia!\nDREAM BIG!'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: UserAvatar(),
                ),
                Row(
                  spacing: 4.0,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Kseniia',
                          labelStyle: AppStyles.textStyleSoFoSans,
                          fillColor: AppStyles.textField,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                  AppStyles.borderRadius)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelStyle: AppStyles.textStyleSoFoSans,
                          labelText: '02.06.1994',
                          fillColor: AppStyles.textField,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                  AppStyles.borderRadius)),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: AppStyles.textStyleSoFoSans,
                      labelText: ref.watch(profileProvider).email,
                      fillColor: AppStyles.textField,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.circular(AppStyles.borderRadius)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 100,
                      width: 170,
                      decoration: BoxDecoration(
                        color: AppStyles.primaryColor,
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadius),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Wishlists',
                              style: AppStyles.textStyleSoFoSans,
                            ),
                            Text(
                              '10',
                              style: TextStyle(fontSize: 32),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 170,
                      decoration: BoxDecoration(
                        color: AppStyles.primaryColor,
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadius),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Products',
                              style: AppStyles.textStyleSoFoSans,
                            ),
                            Text(
                              '108',
                              style: TextStyle(fontSize: 32),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
