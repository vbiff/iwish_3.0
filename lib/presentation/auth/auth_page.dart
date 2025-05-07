import 'package:flutter/material.dart';
import 'package:i_wish/presentation/auth/widgets/login_tab_page.dart';
import 'package:i_wish/presentation/auth/widgets/sign_up_tab_page.dart';
import '../../../../core/ui/styles.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  //for Form validation
  final _formKey = GlobalKey<FormState>();
  var passw = '';
  final emailController = TextEditingController();
  final passwController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppStyles.primaryColor,
      appBar: AppBar(
        title: const Text(
          'I wish...',
          style: AppStyles.textStyleSoFoSans,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(child: Container()),
                  Center(child: Container()),
                ],
              ),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.transparent,
              controller: _tabController,
              dividerColor: Colors.transparent,
              labelColor: AppStyles.blackColor,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              tabs: const [
                Tab(
                  child: Text(
                    'Log in',
                    style: AppStyles.textStyleAbhaya,
                  ),
                ),
                Tab(
                  child: Text(
                    'Sign up',
                    style: AppStyles.textStyleAbhaya,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                ),
                width: double.infinity,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 32,
                        bottom: AppStyles.paddingMain,
                      ),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: LogInTabPage(
                                    emailController: emailController,
                                    passwController: passwController,
                                    formKey: _formKey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 32,
                          bottom: AppStyles.paddingMain),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: SignUpTabPage(
                                    emailController: emailController,
                                    passwController: passwController,
                                    formKey: _formKey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
