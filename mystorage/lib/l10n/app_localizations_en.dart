// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get noName => 'Unnamed';

  @override
  String get loginSubtitle => 'Your personal wardrobe';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get saveId => 'Remember email';

  @override
  String get savePassword => 'Remember password';

  @override
  String get back => '← Back';

  @override
  String get backToLogin => '← Back to login';

  @override
  String get passwordMinLength => 'At least 6 characters';

  @override
  String get passwordConfirm => 'Confirm password';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get emailVerificationSent =>
      'Verification email sent. Please check your inbox.';

  @override
  String get authErrRequired => 'Please enter your email and password.';

  @override
  String get authErrPasswordShort => 'Password must be at least 6 characters.';

  @override
  String get authErrInvalidCredentials => 'Invalid email or password.';

  @override
  String get authErrEmailInUse => 'This email is already in use.';

  @override
  String get authErrInvalidInput =>
      'Please check your input. (Password: 6+ characters)';

  @override
  String get authErrNetwork => 'Please check your network connection.';

  @override
  String get noLocation => 'No location';

  @override
  String get loadFailed => 'Failed to load';

  @override
  String get addStorageHint => 'Tap + to add a storage';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navAiOrganize => 'AI Sort';

  @override
  String get navMy => 'My';

  @override
  String get noLocationTag => 'No location';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get fromGallery => 'Choose from gallery';

  @override
  String get storageName => 'Storage name';

  @override
  String get locationOptional => 'Location (optional)';

  @override
  String get addClothHint => 'Add clothes to this storage';

  @override
  String get present => 'In';

  @override
  String get absent => 'Out';

  @override
  String get confirmPresent => 'Confirm in?';

  @override
  String loadError(String error) {
    return 'Error: $error';
  }

  @override
  String get addCloth => 'Add Clothes';

  @override
  String get aiAnalyzing => 'Analyzing with AI...';

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get memoOptional => 'Memo (optional)';

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String get tagColor => 'Color';

  @override
  String get tagType => 'Type';

  @override
  String get tagMaterial => 'Material';

  @override
  String get tagSeason => 'Season';

  @override
  String get tagStyle => 'Style';

  @override
  String get tagCondition => 'Condition';

  @override
  String get tagBrand => 'Brand';

  @override
  String get tagOther => 'Other';

  @override
  String get aiReanalyze => 'Re-analyze';

  @override
  String get aiAnalyzeDone => 'AI analysis complete';

  @override
  String analyzeError(String error) {
    return 'Analysis failed: $error';
  }

  @override
  String get clothLoadError => 'Failed to load item';

  @override
  String get searchHint => 'Search by name, tag, or memo';

  @override
  String get searchPlaceholder => 'Search by name or tag';

  @override
  String get searchNoResults => 'No results found';

  @override
  String searchError(String error) {
    return 'Search error: $error';
  }

  @override
  String get orgCriteriaSeason => 'By season';

  @override
  String get orgCriteriaMaterial => 'By material';

  @override
  String get orgCriteriaColor => 'By color';

  @override
  String get orgCriteriaLabel => 'Sort by';

  @override
  String get orgMaxPerBox => 'Max items per box';

  @override
  String get orgMaxPerBoxHint =>
      'Set a reasonable limit to avoid creating too many boxes.';

  @override
  String get orgStartAnalysis => 'Start AI Analysis';

  @override
  String get orgAnalyzing => 'AI is analyzing your clothes...';

  @override
  String orgSortingBy(String criteria) {
    return 'Sorting by $criteria';
  }

  @override
  String get orgUncategorized => 'Uncategorized';

  @override
  String get orgPlanTitle => 'AI Sort Plan';

  @override
  String orgSummary(int total, int groups) {
    return '$total items  →  $groups new storages';
  }

  @override
  String orgCriteriaDetail(String criteria, int max) {
    return 'By: $criteria  ·  Max $max per box';
  }

  @override
  String get orgReset => 'Reset';

  @override
  String orgMoveCount(int count) {
    return 'Move $count';
  }

  @override
  String get orgApplyConfirm =>
      'New storages will be created and items moved.\nExisting storages will remain.';

  @override
  String get orgNoClothes => 'No clothes registered.';

  @override
  String orgAnalyzeFailed(String error) {
    return 'AI analysis failed: $error';
  }

  @override
  String get orgApplyDone => 'Applied to new storages.';

  @override
  String orgApplyFailed(String error) {
    return 'Failed to apply: $error';
  }

  @override
  String get familyRemoveMember => 'Remove Member';

  @override
  String familyRemoveConfirm(String email) {
    return 'Remove $email from your family?';
  }

  @override
  String get familyRemove => 'Remove';

  @override
  String familyRemoveFailed(String error) {
    return 'Failed to remove: $error';
  }

  @override
  String get familyInviteInfo =>
      'Share the code with family to use the same storage.';

  @override
  String get familyCodeExpiry => 'Valid for 48 hours';

  @override
  String get familyCodeCopied => 'Code copied.';

  @override
  String get familyNewCode => 'Generate new';

  @override
  String get familyCreateCode => 'Create invite code';

  @override
  String familyCodeCreateFailed(String error) {
    return 'Failed to create code: $error';
  }

  @override
  String get familyJoinHint =>
      'Enter the code from your family to share storage.';

  @override
  String get familyJoined => 'Connected to family storage.';

  @override
  String get familyInvalidCode => 'Invalid or expired code.';

  @override
  String get familyAlreadyMember => 'Already connected to this family.';

  @override
  String familyJoinFailed(String error) {
    return 'Failed to connect: $error';
  }

  @override
  String get familyRoleMe => 'Me';

  @override
  String get familyRoleOwner => 'Admin';

  @override
  String get familyRoleMember => 'Member';

  @override
  String get locationDeleteTitle => 'Delete Location';

  @override
  String locationDeleteConfirm(String name) {
    return 'Deleting \"$name\" will reset the location of all associated storages.';
  }

  @override
  String locationSaveFailed(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get locationAddHint => 'Add a location';

  @override
  String get locationNameHint => 'Enter location name';

  @override
  String get profileStorages => 'Storages';

  @override
  String get profileClothes => 'Clothes';

  @override
  String get profileMyStorages => 'My Storages';

  @override
  String get profileLocations => 'Locations';

  @override
  String get profileFamily => 'Family';

  @override
  String get profileClothSearch => 'Search Clothes';

  @override
  String get profileQrScan => 'QR Scan';

  @override
  String get profileNicknameSet => 'Set nickname';

  @override
  String profilePhotoFailed(String error) {
    return 'Photo upload failed: $error';
  }

  @override
  String profileNicknameFailed(String error) {
    return 'Failed to save nickname: $error';
  }

  @override
  String get profileNicknameHint => 'Enter nickname';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get pricingTitle => 'Subscription Plans';

  @override
  String get pricingMonthly => 'Monthly';

  @override
  String get pricingYearly => 'Yearly';

  @override
  String get pricingDiscount => 'Up to 32% off';

  @override
  String get pricingCurrentPlan => 'Current Plan';

  @override
  String get pricingStart => 'Get Started';

  @override
  String pricingPayFailed(String error) {
    return 'Payment failed: $error';
  }

  @override
  String get adminNoData => 'No data';

  @override
  String get adminTotalUsers => 'Total Users';

  @override
  String get adminTotalOrgs => 'Total Orgs';

  @override
  String get adminTotalStorages => 'Total Storages';

  @override
  String get adminTotalClothes => 'Total Clothes';

  @override
  String get qrStickerTitle => 'QR Sticker';

  @override
  String get qrPrintError => 'An error occurred while printing';

  @override
  String get qrPrint => 'Print Sticker';

  @override
  String get qrScanTitle => 'QR Scan';

  @override
  String get qrNotRegistered => 'Unregistered QR code';

  @override
  String get moveToStorage => 'Move to storage';

  @override
  String get moveToTrash => 'Move to trash';

  @override
  String get moveToSale => 'Move to for sale';

  @override
  String get moveDone => 'Moved';

  @override
  String moveFailed(String error) {
    return 'Move failed: $error';
  }

  @override
  String get systemStorages => 'Default storages';

  @override
  String get settingsShowTrash => 'Show trash storage';

  @override
  String get settingsShowSale => 'Show sale storage';

  @override
  String get storageVisibility => 'Storage visibility';

  @override
  String get selectStorage => 'Select storage';
}
