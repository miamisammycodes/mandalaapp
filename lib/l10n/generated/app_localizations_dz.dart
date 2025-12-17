// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dzongkha (`dz`).
class AppLocalizationsDz extends AppLocalizations {
  AppLocalizationsDz([String locale = 'dz']) : super(locale);

  @override
  String get appName => '[DZ] Child Mandala';

  @override
  String get languageSelection => '[DZ] Select Language';

  @override
  String get english => 'English';

  @override
  String get dzongkha => 'རྫོང་ཁ';

  @override
  String get continueButton => '[DZ] Continue';

  @override
  String get cancel => '[DZ] Cancel';

  @override
  String get save => '[DZ] Save';

  @override
  String get delete => '[DZ] Delete';

  @override
  String get edit => '[DZ] Edit';

  @override
  String get back => '[DZ] Back';

  @override
  String get next => '[DZ] Next';

  @override
  String get done => '[DZ] Done';

  @override
  String get ok => '[DZ] OK';

  @override
  String get yes => '[DZ] Yes';

  @override
  String get no => '[DZ] No';

  @override
  String get loading => '[DZ] Loading...';

  @override
  String get error => '[DZ] Error';

  @override
  String get success => '[DZ] Success';

  @override
  String get retry => '[DZ] Retry';

  @override
  String get close => '[DZ] Close';

  @override
  String get welcome => '[DZ] Welcome';

  @override
  String get welcomeMessage => '[DZ] Welcome to Child Mandala';

  @override
  String get welcomeSubtitle =>
      '[DZ] Supporting parents and children in Bhutan';

  @override
  String get login => '[DZ] Login';

  @override
  String get logout => '[DZ] Logout';

  @override
  String get register => '[DZ] Register';

  @override
  String get phoneNumber => '[DZ] Phone Number';

  @override
  String get enterPhoneNumber => '[DZ] Enter your phone number';

  @override
  String get phoneNumberHint => '+975 17 123 456';

  @override
  String get sendOtp => '[DZ] Send OTP';

  @override
  String get verifyOtp => '[DZ] Verify OTP';

  @override
  String get enterOtp => '[DZ] Enter the 6-digit code sent to your phone';

  @override
  String otpSent(String phoneNumber) {
    return '[DZ] OTP sent to $phoneNumber';
  }

  @override
  String get resendOtp => '[DZ] Resend OTP';

  @override
  String resendOtpIn(int seconds) {
    return '[DZ] Resend in ${seconds}s';
  }

  @override
  String get invalidOtp => '[DZ] Invalid OTP. Please try again.';

  @override
  String get otpExpired => '[DZ] OTP expired. Please request a new one.';

  @override
  String get parentMode => '[DZ] Parent Mode';

  @override
  String get childMode => '[DZ] Child Mode';

  @override
  String get switchToParent => '[DZ] Switch to Parent';

  @override
  String get switchToChild => '[DZ] Switch to Child';

  @override
  String get selectChild => '[DZ] Select Child';

  @override
  String get enterPin => '[DZ] Enter PIN';

  @override
  String get enterPinSubtitle => '[DZ] Enter your 4-digit PIN';

  @override
  String get forgotPin => '[DZ] Forgot PIN?';

  @override
  String get incorrectPin => '[DZ] Incorrect PIN. Please try again.';

  @override
  String get addChild => '[DZ] Add Child';

  @override
  String get editChild => '[DZ] Edit Child';

  @override
  String get childName => '[DZ] Child\'s Name';

  @override
  String get dateOfBirth => '[DZ] Date of Birth';

  @override
  String get expectedDueDate => '[DZ] Expected Due Date';

  @override
  String get setPin => '[DZ] Set PIN';

  @override
  String get confirmPin => '[DZ] Confirm PIN';

  @override
  String get pinMismatch => '[DZ] PINs do not match';

  @override
  String get childAdded => '[DZ] Child added successfully';

  @override
  String get childUpdated => '[DZ] Child updated successfully';

  @override
  String get childDeleted => '[DZ] Child removed';

  @override
  String get deleteChildConfirm =>
      '[DZ] Are you sure you want to remove this child profile?';

  @override
  String get noChildren => '[DZ] No children added yet';

  @override
  String get addFirstChild => '[DZ] Add your first child';

  @override
  String get ageGroup => '[DZ] Age Group';

  @override
  String get pregnancy => '[DZ] Expecting';

  @override
  String get infant => '[DZ] 0-3 Years';

  @override
  String get toddler => '[DZ] 3-5 Years';

  @override
  String get child => '[DZ] 6-12 Years';

  @override
  String get teen => '[DZ] 13-17 Years';

  @override
  String get years => '[DZ] years';

  @override
  String get months => '[DZ] months';

  @override
  String get weeks => '[DZ] weeks';

  @override
  String dueIn(int weeks) {
    return '[DZ] Due in $weeks weeks';
  }

  @override
  String get home => '[DZ] Home';

  @override
  String get education => '[DZ] Education';

  @override
  String get chapters => '[DZ] Chapters';

  @override
  String get news => '[DZ] News';

  @override
  String get events => '[DZ] Events';

  @override
  String get safety => '[DZ] Online Safety';

  @override
  String get chatbot => '[DZ] Chat Assistant';

  @override
  String get feedback => '[DZ] Feedback';

  @override
  String get contact => '[DZ] Contact';

  @override
  String get settings => '[DZ] Settings';

  @override
  String get about => '[DZ] About';

  @override
  String get help => '[DZ] Help';

  @override
  String get notifications => '[DZ] Notifications';

  @override
  String get subscribe => '[DZ] Subscribe';

  @override
  String get reportEvent => '[DZ] Report Event';

  @override
  String chapterTitle(int number, String title) {
    return '[DZ] Chapter $number: $title';
  }

  @override
  String get watchVideo => '[DZ] Watch Video';

  @override
  String get readMore => '[DZ] Read More';

  @override
  String get collapse => '[DZ] Collapse';

  @override
  String get expand => '[DZ] Expand';

  @override
  String get onlineSafety => '[DZ] Online Safety';

  @override
  String get safetyContent => '[DZ] Content';

  @override
  String get safetyConduct => '[DZ] Conduct';

  @override
  String get safetyContact => '[DZ] Contact';

  @override
  String get safetyContract => '[DZ] Contract';

  @override
  String get safetyTips => '[DZ] Safety Tips';

  @override
  String get reportConcern => '[DZ] Report a Concern';

  @override
  String get safetyContentDesc =>
      '[DZ] Inappropriate or harmful content online';

  @override
  String get safetyConductDesc => '[DZ] Online behavior and cyberbullying';

  @override
  String get safetyContactDesc => '[DZ] Strangers and online predators';

  @override
  String get safetyContractDesc => '[DZ] Privacy, scams, and data protection';

  @override
  String get upcomingEvents => '[DZ] Upcoming Events';

  @override
  String get pastEvents => '[DZ] Past Events';

  @override
  String get allEvents => '[DZ] All Events';

  @override
  String get eventDetails => '[DZ] Event Details';

  @override
  String get eventDate => '[DZ] Date';

  @override
  String get eventTime => '[DZ] Time';

  @override
  String get eventLocation => '[DZ] Location';

  @override
  String get virtualEvent => '[DZ] Virtual Event';

  @override
  String get registerNow => '[DZ] Register Now';

  @override
  String get noEvents => '[DZ] No events found';

  @override
  String get chatbotTitle => '[DZ] Chat Assistant';

  @override
  String get chatbotWelcome => '[DZ] Hi! How can I help you today?';

  @override
  String get chatbotComingSoon => '[DZ] Coming Soon';

  @override
  String get chatbotComingSoonMessage =>
      '[DZ] The AI assistant is currently under development.';

  @override
  String get typeMessage => '[DZ] Type a message...';

  @override
  String get voiceInput => '[DZ] Voice Input';

  @override
  String get submitFeedback => '[DZ] Submit Feedback';

  @override
  String get feedbackSubmitted => '[DZ] Thank you for your feedback!';

  @override
  String get contactUs => '[DZ] Contact Us';

  @override
  String get messageSent => '[DZ] Message sent successfully';

  @override
  String get language => '[DZ] Language';

  @override
  String get changeLanguage => '[DZ] Change Language';

  @override
  String get theme => '[DZ] Theme';

  @override
  String get darkMode => '[DZ] Dark Mode';

  @override
  String get lightMode => '[DZ] Light Mode';

  @override
  String get profile => '[DZ] Profile';

  @override
  String get account => '[DZ] Account';

  @override
  String get privacy => '[DZ] Privacy';

  @override
  String get termsOfService => '[DZ] Terms of Service';

  @override
  String get version => '[DZ] Version';

  @override
  String get noInternet => '[DZ] No internet connection';

  @override
  String get connectionError => '[DZ] Connection error. Please try again.';

  @override
  String get somethingWentWrong => '[DZ] Something went wrong';

  @override
  String get tryAgain => '[DZ] Try Again';

  @override
  String get pageNotFound => '[DZ] Page not found';

  @override
  String get mandalaTitle => '[DZ] Child Mandala';

  @override
  String get mandalaSubtitle => '[DZ] Holistic Child Development';

  @override
  String exploreSection(String section) {
    return '[DZ] Explore $section';
  }
}
