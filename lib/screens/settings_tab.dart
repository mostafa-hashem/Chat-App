import 'package:chat_app/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../helper/helper_functions.dart';
import '../services/auth_services.dart';
import '../shared/provider/app_provider.dart';
import '../widgets/language_bootom_sheet.dart';
import '../widgets/theme_bottom_sheet.dart';
import 'auth/login/login_screen.dart';

class SettingsTab extends StatefulWidget {

  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  AuthServices authService = AuthServices();
  String userName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSp().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getUserEmailFromSp().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyAppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: provider.language == 'en'
              ? Text("Settings", style: Theme.of(context).textTheme.bodyMedium)
              : Text("الإعدادات",
                  style: Theme.of(context).textTheme.bodyMedium),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(AppLocalizations.of(context)!.language,
                  style: provider.themeMode == ThemeMode.light
                      ? provider.language == "en"
                          ? Theme.of(context).textTheme.bodySmall
                          : GoogleFonts.cairo()
                      : provider.language == "en"
                          ? Theme.of(context).textTheme.bodySmall
                          : GoogleFonts.cairo()),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              InkWell(
                onTap: () {
                  showLanguageSheet(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  padding: provider.language == "ar"
                      ? EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.02)
                      : EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.03),
                  decoration: provider.themeMode == ThemeMode.dark
                      ? BoxDecoration(
                          color: AppColors.darkColor,
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : BoxDecoration(
                          color: AppColors.lightColor,
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          provider.language == "en"
                              ? AppLocalizations.of(context)!.english
                              : AppLocalizations.of(context)!.arabic,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(AppLocalizations.of(context)!.theme,
                  style: Theme.of(context).textTheme.bodySmall),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              InkWell(
                onTap: () {
                  showThemeSheet(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  padding: provider.language == "ar"
                      ? EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.02)
                      : EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.03),
                  decoration: provider.themeMode == ThemeMode.dark
                      ? BoxDecoration(
                          color: AppColors.darkColor,
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : BoxDecoration(
                          color: AppColors.lightColor,
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      provider.themeMode == ThemeMode.light
                          ? Text(AppLocalizations.of(context)!.lightMood,
                              style: Theme.of(context).textTheme.bodyMedium)
                              : Text(AppLocalizations.of(context)!.darkMood,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              GestureDetector(
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  authService.signOut().whenComplete(() {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (route) => false);
                                  });
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                )),
                          ],
                        );
                      });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    color: AppColors.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: provider.language == "en"
                            ? Text("Logout",
                                style: Theme.of(context).textTheme.bodyMedium)
                            : Text("تسجيل خروج",
                                style: Theme.of(context).textTheme.bodyMedium)),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Center(
                child: Text.rich(TextSpan(children: [
                  provider.language == "en"
                      ? TextSpan(
                          text: "powered by ",
                          style: Theme.of(context).textTheme.bodySmall)
                      : TextSpan(
                          text: "مشغل بواسطة ",
                          style: Theme.of(context).textTheme.bodySmall),
                  provider.language == "en"
                      ? TextSpan(
                          text: "SOLDIER",
                          style: Theme.of(context).textTheme.bodyMedium)
                      : TextSpan(
                          text: "SOLDIER",
                          style: Theme.of(context).textTheme.bodyMedium)
                ])),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: Text.rich(TextSpan(children: [
                  provider.language == "en"
                      ? TextSpan(
                          text: "designed by ",
                          style: Theme.of(context).textTheme.bodySmall)
                      : TextSpan(
                          text: "مصمم بواسطة ",
                          style: Theme.of(context).textTheme.bodySmall),
                  provider.language == "en"
                      ? TextSpan(
                          text: "ُEYO",
                          style: Theme.of(context).textTheme.bodyMedium)
                      : TextSpan(
                          text: "EYO",
                          style: Theme.of(context).textTheme.bodyMedium)
                ])),
              ),
            ],
          ),
        )
    );
  }

  void showLanguageSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LanguageBottomSheet();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }

  void showThemeSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ThemeBottomSheet();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
    );
  }
}
