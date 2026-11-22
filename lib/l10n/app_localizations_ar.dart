// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Scaffold';

  @override
  String get appTagline =>
      'العب ألعابًا صغيرة وجرّب تطبيقات مصغّرة، ثم ابنِ نسختك فوقها';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get menu => 'القائمة';

  @override
  String get navFeed => 'الرئيسية';

  @override
  String get navExplore => 'استكشاف';

  @override
  String get navCreate => 'إنشاء';

  @override
  String get navInbox => 'الإشعارات';

  @override
  String get navProfile => 'ملفي';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navLeaderboard => 'المتصدرون';

  @override
  String get featureEditor => 'محرر الشيفرة';

  @override
  String get featureTree => 'شجرة التطور';

  @override
  String get featurePremium => 'الاشتراك المميز';

  @override
  String get comingSoonMessage => 'مخطط له في الجزء الثاني من المشروع';

  @override
  String get routeNotFound => 'الصفحة غير موجودة';

  @override
  String get loginTitle => 'تسجيل الدخول إلى Scaffold';

  @override
  String get loginSubtitle => 'بالبريد الإلكتروني أو بحساب Google';

  @override
  String get registerTitle => 'أنشئ حسابك';

  @override
  String get registerSubtitle => 'كل إبداع تنشره يبدأ شجرة جديدة';

  @override
  String get registerSuccess => 'تم إنشاء الحساب';

  @override
  String get forgotTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotSubtitle => 'سنرسل إلى بريدك رابطًا لاختيار كلمة مرور جديدة';

  @override
  String forgotSent(String email) {
    return 'تم إرسال رابط إلى $email. تحقّق من بريدك الوارد.';
  }

  @override
  String get forgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get fieldEmail => 'البريد الإلكتروني';

  @override
  String get fieldPassword => 'كلمة المرور';

  @override
  String get fieldConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fieldDisplayName => 'الاسم المعروض';

  @override
  String passwordHelper(int min) {
    return '$min أحرف على الأقل، تتضمن حروفًا وأرقامًا';
  }

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get acceptTerms => 'أوافق على شروط الاستخدام وقواعد المجتمع';

  @override
  String get actionSignIn => 'تسجيل الدخول';

  @override
  String get actionSignUp => 'سجّل الآن';

  @override
  String get actionCreateAccount => 'إنشاء الحساب';

  @override
  String get actionGoogle => 'المتابعة باستخدام Google';

  @override
  String get actionSendResetLink => 'إرسال الرابط';

  @override
  String get actionBackToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get actionSignOut => 'تسجيل الخروج';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionLike => 'إعجاب';

  @override
  String get actionEvolve => 'طوّر';

  @override
  String get actionOpen => 'فتح';

  @override
  String get actionCopyCode => 'نسخ الشيفرة';

  @override
  String get actionViewTree => 'عرض الشجرة كاملة';

  @override
  String get actionEditProfile => 'تعديل الملف الشخصي';

  @override
  String get orDivider => 'أو';

  @override
  String get noAccountPrompt => 'ليس لديك حساب؟';

  @override
  String get haveAccountPrompt => 'لديك حساب بالفعل؟';

  @override
  String get validationEmailRequired => 'يرجى إدخال بريدك الإلكتروني.';

  @override
  String get validationEmailInvalid => 'عنوان البريد الإلكتروني غير صالح.';

  @override
  String get validationPasswordRequired => 'يرجى إدخال كلمة المرور.';

  @override
  String validationPasswordTooShort(int min) {
    return 'يجب أن تتكون كلمة المرور من $min أحرف على الأقل.';
  }

  @override
  String get validationPasswordWeak =>
      'استخدم حرفًا واحدًا ورقمًا واحدًا على الأقل.';

  @override
  String get validationConfirmRequired => 'يرجى تأكيد كلمة المرور.';

  @override
  String get validationPasswordsMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get validationNameRequired => 'يرجى إدخال اسم معروض.';

  @override
  String validationNameTooShort(int min) {
    return 'يجب أن يتكون الاسم من $min أحرف على الأقل.';
  }

  @override
  String validationNameTooLong(int max) {
    return 'يجب ألا يتجاوز الاسم $max حرفًا.';
  }

  @override
  String get validationAcceptTerms => 'يجب الموافقة على الشروط للمتابعة.';

  @override
  String get authErrorInvalidEmail => 'صيغة البريد الإلكتروني غير صحيحة.';

  @override
  String get authErrorUserDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get authErrorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authErrorEmailInUse => 'يوجد حساب بالفعل بهذا البريد الإلكتروني.';

  @override
  String get authErrorWeakPassword => 'كلمة المرور هذه ضعيفة جدًا.';

  @override
  String get authErrorTooManyRequests =>
      'محاولات كثيرة جدًا. حاول مرة أخرى لاحقًا.';

  @override
  String get authErrorDifferentCredential =>
      'هذا البريد مرتبط بالفعل بطريقة تسجيل دخول أخرى.';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get errorGeneric => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get errorNetwork => 'لا يوجد اتصال. تحقّق من الإنترنت وحاول مجددًا.';

  @override
  String get errorPermissionDenied => 'ليست لديك صلاحية للقيام بذلك.';

  @override
  String get errorNotFound => 'هذا المحتوى لم يعد موجودًا.';

  @override
  String get signOutTitle => 'تسجيل الخروج؟';

  @override
  String get signOutMessage =>
      'ستحتاج إلى تسجيل الدخول مرة أخرى لاستخدام التطبيق.';

  @override
  String get feedTrending => 'الرائج';

  @override
  String get feedLatest => 'الأحدث';

  @override
  String get feedEmptyTitle => 'لا توجد إبداعات بعد';

  @override
  String get feedEmptyMessage =>
      'حمّل العرض التجريبي لترى ستة إبداعات في ثلاث أشجار.';

  @override
  String get drawerSeedDemo => 'تحميل الإبداعات التجريبية';

  @override
  String get seedInProgress => 'جارٍ نشر الإبداعات التجريبية…';

  @override
  String get seedDone => 'تم نشر الإبداعات التجريبية. اسحب للأسفل للتحديث.';

  @override
  String get categoryGame => 'لعبة';

  @override
  String get categoryWebsite => 'موقع ويب';

  @override
  String get categoryTool => 'أداة';

  @override
  String get categorySimulation => 'محاكاة';

  @override
  String get categoryApp => 'تطبيق';

  @override
  String get categoryArt => 'فن';

  @override
  String lineageOriginal(int generation) {
    return 'أصلي · الجيل $generation';
  }

  @override
  String lineageBranchOf(String parent, String author, int generation) {
    return 'فرع من $parent بواسطة $author · الجيل $generation';
  }

  @override
  String get lineageAncestorsTitle => 'المسار من الجذر';

  @override
  String get lineageIsOriginal => 'إبداع أصلي، وهو جذر شجرته';

  @override
  String get lineageYouAreHere => 'أنت هنا';

  @override
  String lineageEvolutionsTitle(int count) {
    return 'التطويرات المباشرة ($count)';
  }

  @override
  String get lineageNoEvolutions =>
      'لا توجد تطويرات بعد. اضغط «طوّر» لبدء أول فرع.';

  @override
  String generationLabel(int generation) {
    return 'الجيل $generation';
  }

  @override
  String byAuthor(String name) {
    return 'بواسطة $name';
  }

  @override
  String get creationNotFound => 'الإبداع غير موجود';

  @override
  String creationStats(int views, int evolutions, int descendants) {
    return '$views مشاهدة · $evolutions تطوير · $descendants في شجرته';
  }

  @override
  String get tabPreview => 'معاينة';

  @override
  String get tabCode => 'الشيفرة';

  @override
  String get tabLineage => 'السلالة';

  @override
  String get codeCopied => 'تم نسخ الشيفرة إلى الحافظة';

  @override
  String get previewError => 'تعذّر تحميل هذا الإبداع.';

  @override
  String get userNotFound => 'المستخدم غير موجود';

  @override
  String profileOriginals(int count) {
    return 'الأصلية ($count)';
  }

  @override
  String profileEvolutions(int count) {
    return 'الفروع ($count)';
  }

  @override
  String get profileNoOriginals => 'لا توجد إبداعات أصلية بعد';

  @override
  String get profileNoEvolutions => 'لا توجد تطويرات بعد';

  @override
  String get statGenerations => 'الأجيال';

  @override
  String get statDescendants => 'الأحفاد';

  @override
  String get statLikes => 'الإعجابات';

  @override
  String get statEvolutions => 'التطويرات';

  @override
  String pointsValue(int points) {
    return '$points نقطة';
  }

  @override
  String pointsToNextLevel(int points, String level) {
    return 'تبقّى $points نقطة للوصول إلى $level';
  }

  @override
  String get pointsHowTitle => 'كيف تُكسب النقاط';

  @override
  String pointsRulePublish(int points) {
    return '+$points لكل إبداع تنشره';
  }

  @override
  String pointsRuleLike(int points) {
    return '+$points عندما يُعجب أحدهم بإبداعك';
  }

  @override
  String pointsRuleEvolution(int points) {
    return '+$points عندما يطوّر أحدهم إبداعك';
  }

  @override
  String pointsRuleDescendant(int points) {
    return '+$points لكل تطوير أبعد في شجرتك';
  }

  @override
  String get levelSeed => 'بذرة';

  @override
  String get levelSprout => 'برعم';

  @override
  String get levelSapling => 'شتلة';

  @override
  String get levelTree => 'شجرة';

  @override
  String get levelForest => 'غابة';

  @override
  String get levelMax => 'وصلت إلى أعلى مستوى';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsAccount => 'الحساب';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeToggle => 'تبديل المظهر';

  @override
  String get languageSystem => 'لغة الجهاز';

  @override
  String get firebaseSetupTitle => 'يلزم إعداد Firebase';

  @override
  String get firebaseSetupMessage =>
      'لم يتم إعداد Firebase لهذا الإصدار بعد. من مجلد المشروع، نفّذ الأوامر أدناه ثم أعد تشغيل التطبيق.';
}
