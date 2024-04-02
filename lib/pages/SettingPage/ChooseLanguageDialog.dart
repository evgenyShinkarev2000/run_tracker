import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/bloc/cubits/LocalizationCubit.dart';
import 'package:run_tracker/helpers/AppLanguage.dart';
import 'package:run_tracker/helpers/LanguageCode.dart';

void _setLanguage(BuildContext context, AppLanguage language) {
  final localizationCubit = context.read<LocalizationCubit>();
  switch (language.codeEnum) {
    case LanguageCode.ru:
      localizationCubit.setRus();
      break;
    case LanguageCode.en:
      localizationCubit.setEng();
      break;
    default:
      print("unknown language");
  }
}

class ChooseLanguageDialog extends StatelessWidget {
  final List<AppLanguage> supportedLanguages;
  final AppLanguage currentLanguage;

  const ChooseLanguageDialog({super.key, 
    required this.supportedLanguages,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    closeDialog() => context.pop();

    return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: supportedLanguages.length,
            itemBuilder: (context, index) {
              final language = supportedLanguages[index];
              final isSelected = language.codeEnum == currentLanguage.codeEnum;
          
              return ListTile(
                title: Text(language.nativeName),
                trailing: isSelected ? Icon(CupertinoIcons.check_mark) : null,
                selected: isSelected,
                onTap: (){
                  _setLanguage(context, language);
                  closeDialog();
                }
              );
            },
          ),
        ),
    );
  }
}
