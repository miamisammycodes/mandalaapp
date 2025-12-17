// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Child Mandala';

  @override
  String get languageSelection => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get dzongkha => 'Dzongkha';

  @override
  String get continueButton => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeMessage => 'Welcome to Child Mandala';

  @override
  String get welcomeSubtitle => 'Supporting parents and children in Bhutan';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get phoneNumberHint => '+975 17 123 456';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get enterOtp => 'Enter the 6-digit code sent to your phone';

  @override
  String otpSent(String phoneNumber) {
    return 'OTP sent to $phoneNumber';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get otpExpired => 'OTP expired. Please request a new one.';

  @override
  String get parentMode => 'Parent Mode';

  @override
  String get childMode => 'Child Mode';

  @override
  String get switchToParent => 'Switch to Parent';

  @override
  String get switchToChild => 'Switch to Child';

  @override
  String get selectChild => 'Select Child';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get enterPinSubtitle => 'Enter your 4-digit PIN';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get incorrectPin => 'Incorrect PIN. Please try again.';

  @override
  String get addChild => 'Add Child';

  @override
  String get editChild => 'Edit Child';

  @override
  String get childName => 'Child\'s Name';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get expectedDueDate => 'Expected Due Date';

  @override
  String get setPin => 'Set PIN';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get pinMismatch => 'PINs do not match';

  @override
  String get childAdded => 'Child added successfully';

  @override
  String get childUpdated => 'Child updated successfully';

  @override
  String get childDeleted => 'Child removed';

  @override
  String get deleteChildConfirm =>
      'Are you sure you want to remove this child profile?';

  @override
  String get noChildren => 'No children added yet';

  @override
  String get addFirstChild => 'Add your first child';

  @override
  String get ageGroup => 'Age Group';

  @override
  String get pregnancy => 'Expecting';

  @override
  String get infant => '0-3 Years';

  @override
  String get toddler => '3-5 Years';

  @override
  String get child => '6-12 Years';

  @override
  String get teen => '13-17 Years';

  @override
  String get years => 'years';

  @override
  String get months => 'months';

  @override
  String get weeks => 'weeks';

  @override
  String dueIn(int weeks) {
    return 'Due in $weeks weeks';
  }

  @override
  String get home => 'Home';

  @override
  String get education => 'Education';

  @override
  String get chapters => 'Chapters';

  @override
  String get news => 'News';

  @override
  String get events => 'Events';

  @override
  String get safety => 'Online Safety';

  @override
  String get chatbot => 'Chat Assistant';

  @override
  String get feedback => 'Feedback';

  @override
  String get contact => 'Contact';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get help => 'Help';

  @override
  String get notifications => 'Notifications';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get reportEvent => 'Report Event';

  @override
  String chapterTitle(int number, String title) {
    return 'Chapter $number: $title';
  }

  @override
  String get watchVideo => 'Watch Video';

  @override
  String get readMore => 'Read More';

  @override
  String get collapse => 'Collapse';

  @override
  String get expand => 'Expand';

  @override
  String get onlineSafety => 'Online Safety';

  @override
  String get safetyContent => 'Content';

  @override
  String get safetyConduct => 'Conduct';

  @override
  String get safetyContact => 'Contact';

  @override
  String get safetyContract => 'Contract';

  @override
  String get safetyTips => 'Safety Tips';

  @override
  String get reportConcern => 'Report a Concern';

  @override
  String get safetyContentDesc => 'Inappropriate or harmful content online';

  @override
  String get safetyConductDesc => 'Online behavior and cyberbullying';

  @override
  String get safetyContactDesc => 'Strangers and online predators';

  @override
  String get safetyContractDesc => 'Privacy, scams, and data protection';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get pastEvents => 'Past Events';

  @override
  String get allEvents => 'All Events';

  @override
  String get eventDetails => 'Event Details';

  @override
  String get eventDate => 'Date';

  @override
  String get eventTime => 'Time';

  @override
  String get eventLocation => 'Location';

  @override
  String get virtualEvent => 'Virtual Event';

  @override
  String get registerNow => 'Register Now';

  @override
  String get noEvents => 'No events found';

  @override
  String get chatbotTitle => 'Chat Assistant';

  @override
  String get chatbotWelcome => 'Hi! How can I help you today?';

  @override
  String get chatbotComingSoon => 'Coming Soon';

  @override
  String get chatbotComingSoonMessage =>
      'The AI assistant is currently under development.';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get voiceInput => 'Voice Input';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get feedbackSubmitted => 'Thank you for your feedback!';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get messageSent => 'Message sent successfully';

  @override
  String get language => 'Language';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get profile => 'Profile';

  @override
  String get account => 'Account';

  @override
  String get privacy => 'Privacy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get version => 'Version';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get connectionError => 'Connection error. Please try again.';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get mandalaTitle => 'Child Mandala';

  @override
  String get mandalaSubtitle => 'Holistic Child Development';

  @override
  String exploreSection(String section) {
    return 'Explore $section';
  }
}
