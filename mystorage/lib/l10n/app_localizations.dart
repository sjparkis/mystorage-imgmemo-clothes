import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// 재시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// 이름 없을 때 플레이스홀더
  ///
  /// In ko, this message translates to:
  /// **'이름 없음'**
  String get noName;

  /// 로그인 인트로 부제목
  ///
  /// In ko, this message translates to:
  /// **'나만의 옷 보관함'**
  String get loginSubtitle;

  /// 이메일 입력 필드 레이블
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get email;

  /// 비밀번호 입력 필드 레이블
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// 아이디 저장 체크박스
  ///
  /// In ko, this message translates to:
  /// **'아이디 저장'**
  String get saveId;

  /// 비밀번호 저장 체크박스
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 저장'**
  String get savePassword;

  /// 뒤로 가기 버튼
  ///
  /// In ko, this message translates to:
  /// **'← 돌아가기'**
  String get back;

  /// 로그인으로 돌아가기 버튼
  ///
  /// In ko, this message translates to:
  /// **'← 로그인으로 돌아가기'**
  String get backToLogin;

  /// 비밀번호 최소 길이 안내
  ///
  /// In ko, this message translates to:
  /// **'6자 이상 입력해 주세요'**
  String get passwordMinLength;

  /// 비밀번호 확인 입력 필드 레이블
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get passwordConfirm;

  /// 비밀번호 불일치 오류
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않습니다.'**
  String get passwordMismatch;

  /// 이메일 인증 발송 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'인증 이메일을 보냈습니다. 이메일을 확인해 주세요.'**
  String get emailVerificationSent;

  /// 필수 입력 오류
  ///
  /// In ko, this message translates to:
  /// **'이메일과 비밀번호를 입력해 주세요.'**
  String get authErrRequired;

  /// 비밀번호 길이 오류
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 6자 이상이어야 합니다.'**
  String get authErrPasswordShort;

  /// 인증 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'이메일 또는 비밀번호가 올바르지 않습니다.'**
  String get authErrInvalidCredentials;

  /// 이메일 중복 오류
  ///
  /// In ko, this message translates to:
  /// **'이미 사용 중인 이메일입니다.'**
  String get authErrEmailInUse;

  /// 입력 오류 (422)
  ///
  /// In ko, this message translates to:
  /// **'입력 정보를 확인해 주세요. (비밀번호 6자 이상)'**
  String get authErrInvalidInput;

  /// 네트워크 오류
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인해 주세요.'**
  String get authErrNetwork;

  /// 위치 미설정 레이블
  ///
  /// In ko, this message translates to:
  /// **'위치 미설정'**
  String get noLocation;

  /// 데이터 불러오기 실패
  ///
  /// In ko, this message translates to:
  /// **'불러오기 실패'**
  String get loadFailed;

  /// 보관함 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼으로 보관함을 추가해 보세요'**
  String get addStorageHint;

  /// 하단 내비게이션 홈
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// 하단 내비게이션 검색
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get navSearch;

  /// 하단 내비게이션 AI 정리
  ///
  /// In ko, this message translates to:
  /// **'AI 정리'**
  String get navAiOrganize;

  /// 하단 내비게이션 프로필
  ///
  /// In ko, this message translates to:
  /// **'나의'**
  String get navMy;

  /// 위치 없음 태그
  ///
  /// In ko, this message translates to:
  /// **'위치 없음'**
  String get noLocationTag;

  /// 카메라 촬영 옵션
  ///
  /// In ko, this message translates to:
  /// **'카메라로 찍기'**
  String get takePhoto;

  /// 갤러리 선택 옵션
  ///
  /// In ko, this message translates to:
  /// **'갤러리에서 가져오기'**
  String get fromGallery;

  /// 보관함 이름 입력 필드 레이블
  ///
  /// In ko, this message translates to:
  /// **'보관함 이름'**
  String get storageName;

  /// 위치 선택 필드 레이블
  ///
  /// In ko, this message translates to:
  /// **'위치 선택 (선택사항)'**
  String get locationOptional;

  /// 빈 보관함 안내
  ///
  /// In ko, this message translates to:
  /// **'옷을 추가해 주세요'**
  String get addClothHint;

  /// 의류 현재 위치 있음
  ///
  /// In ko, this message translates to:
  /// **'있음'**
  String get present;

  /// 의류 현재 위치 없음
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get absent;

  /// 의류 위치 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'있음 확인?'**
  String get confirmPresent;

  /// 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류: {error}'**
  String loadError(String error);

  /// 옷 추가 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'옷 추가'**
  String get addCloth;

  /// AI 분석 진행 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 중...'**
  String get aiAnalyzing;

  /// 옷 이름 입력 필드 레이블
  ///
  /// In ko, this message translates to:
  /// **'이름 (선택)'**
  String get nameOptional;

  /// 옷 메모 입력 필드 레이블
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get memoOptional;

  /// AI 분석 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'AI 분석'**
  String get aiAnalysis;

  /// 태그 카테고리: 색상
  ///
  /// In ko, this message translates to:
  /// **'색상'**
  String get tagColor;

  /// 태그 카테고리: 종류
  ///
  /// In ko, this message translates to:
  /// **'종류'**
  String get tagType;

  /// 태그 카테고리: 소재
  ///
  /// In ko, this message translates to:
  /// **'소재'**
  String get tagMaterial;

  /// 태그 카테고리: 계절
  ///
  /// In ko, this message translates to:
  /// **'계절'**
  String get tagSeason;

  /// 태그 카테고리: 스타일
  ///
  /// In ko, this message translates to:
  /// **'스타일'**
  String get tagStyle;

  /// 태그 카테고리: 상태
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get tagCondition;

  /// 태그 카테고리: 브랜드
  ///
  /// In ko, this message translates to:
  /// **'브랜드'**
  String get tagBrand;

  /// 태그 카테고리: 기타
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get tagOther;

  /// AI 재분석 버튼
  ///
  /// In ko, this message translates to:
  /// **'AI 재분석'**
  String get aiReanalyze;

  /// AI 분석 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 완료'**
  String get aiAnalyzeDone;

  /// 분석 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'분석 실패: {error}'**
  String analyzeError(String error);

  /// 옷 상세 불러오기 실패
  ///
  /// In ko, this message translates to:
  /// **'옷 정보를 불러올 수 없습니다'**
  String get clothLoadError;

  /// 검색창 힌트
  ///
  /// In ko, this message translates to:
  /// **'옷 이름, 태그, 메모로 검색'**
  String get searchHint;

  /// 검색 결과 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'이름 또는 태그로 검색해 보세요'**
  String get searchPlaceholder;

  /// 검색 결과 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get searchNoResults;

  /// 검색 오류
  ///
  /// In ko, this message translates to:
  /// **'검색 오류: {error}'**
  String searchError(String error);

  /// 정리 기준: 계절
  ///
  /// In ko, this message translates to:
  /// **'계절별'**
  String get orgCriteriaSeason;

  /// 정리 기준: 소재
  ///
  /// In ko, this message translates to:
  /// **'소재별'**
  String get orgCriteriaMaterial;

  /// 정리 기준: 색상
  ///
  /// In ko, this message translates to:
  /// **'색상별'**
  String get orgCriteriaColor;

  /// 분류 기준 레이블
  ///
  /// In ko, this message translates to:
  /// **'분류 기준'**
  String get orgCriteriaLabel;

  /// 상자당 최대 의류 수 레이블
  ///
  /// In ko, this message translates to:
  /// **'상자당 최대 의류 수'**
  String get orgMaxPerBox;

  /// 상자당 최대 의류 수 안내
  ///
  /// In ko, this message translates to:
  /// **'옷의 평균 부피를 고려해 상자가 너무 많아지지 않도록 적절히 설정하세요.'**
  String get orgMaxPerBoxHint;

  /// AI 분석 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 시작'**
  String get orgStartAnalysis;

  /// AI 분석 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'AI가 의류를 분석하는 중...'**
  String get orgAnalyzing;

  /// 분류 기준 표시
  ///
  /// In ko, this message translates to:
  /// **'{criteria} 기준으로 분류 중'**
  String orgSortingBy(String criteria);

  /// 미분류 그룹 레이블
  ///
  /// In ko, this message translates to:
  /// **'미분류'**
  String get orgUncategorized;

  /// AI 정리 계획 타이틀
  ///
  /// In ko, this message translates to:
  /// **'AI 정리 계획'**
  String get orgPlanTitle;

  /// 정리 계획 요약
  ///
  /// In ko, this message translates to:
  /// **'총 {total}개 의류  →  {groups}개 새 보관함'**
  String orgSummary(int total, int groups);

  /// 정리 기준 상세
  ///
  /// In ko, this message translates to:
  /// **'기준: {criteria}  ·  상자당 최대 {max}개'**
  String orgCriteriaDetail(String criteria, int max);

  /// 정리 설정 초기화 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 설정'**
  String get orgReset;

  /// 이동할 의류 수
  ///
  /// In ko, this message translates to:
  /// **'{count}개 이동'**
  String orgMoveCount(int count);

  /// 정리 적용 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'새 보관함이 생성되고 의류가 이동됩니다.\n기존 보관함은 그대로 유지됩니다.'**
  String get orgApplyConfirm;

  /// 의류 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'등록된 의류가 없습니다.'**
  String get orgNoClothes;

  /// AI 분석 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 실패: {error}'**
  String orgAnalyzeFailed(String error);

  /// 정리 적용 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'새 보관함에 적용됐습니다.'**
  String get orgApplyDone;

  /// 정리 적용 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'적용 실패: {error}'**
  String orgApplyFailed(String error);

  /// 멤버 제거 다이얼로그 타이틀
  ///
  /// In ko, this message translates to:
  /// **'멤버 제거'**
  String get familyRemoveMember;

  /// 멤버 제거 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'{email}을(를) 가족에서 제거할까요?'**
  String familyRemoveConfirm(String email);

  /// 제거 버튼
  ///
  /// In ko, this message translates to:
  /// **'제거'**
  String get familyRemove;

  /// 멤버 제거 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'제거 실패: {error}'**
  String familyRemoveFailed(String error);

  /// 초대 코드 안내
  ///
  /// In ko, this message translates to:
  /// **'가족에게 코드를 공유하면 같은 보관함을 사용할 수 있습니다.'**
  String get familyInviteInfo;

  /// 초대 코드 유효 기간
  ///
  /// In ko, this message translates to:
  /// **'48시간 유효'**
  String get familyCodeExpiry;

  /// 코드 복사 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'코드가 복사됐습니다.'**
  String get familyCodeCopied;

  /// 새 초대 코드 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'새로 생성'**
  String get familyNewCode;

  /// 초대 코드 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'초대 코드 생성'**
  String get familyCreateCode;

  /// 코드 생성 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'코드 생성 실패: {error}'**
  String familyCodeCreateFailed(String error);

  /// 코드 입력 안내
  ///
  /// In ko, this message translates to:
  /// **'가족에게 받은 코드를 입력해 보관함을 공유하세요.'**
  String get familyJoinHint;

  /// 가족 연결 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'가족 보관함에 연결됐습니다.'**
  String get familyJoined;

  /// 유효하지 않은 코드 오류
  ///
  /// In ko, this message translates to:
  /// **'유효하지 않거나 만료된 코드입니다.'**
  String get familyInvalidCode;

  /// 이미 연결된 가족 오류
  ///
  /// In ko, this message translates to:
  /// **'이미 연결된 가족입니다.'**
  String get familyAlreadyMember;

  /// 가족 연결 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'연결 실패: {error}'**
  String familyJoinFailed(String error);

  /// 본인 역할 레이블
  ///
  /// In ko, this message translates to:
  /// **'나'**
  String get familyRoleMe;

  /// 관리자 역할 레이블
  ///
  /// In ko, this message translates to:
  /// **'관리자'**
  String get familyRoleOwner;

  /// 멤버 역할 레이블
  ///
  /// In ko, this message translates to:
  /// **'멤버'**
  String get familyRoleMember;

  /// 위치 삭제 다이얼로그 타이틀
  ///
  /// In ko, this message translates to:
  /// **'위치 삭제'**
  String get locationDeleteTitle;

  /// 위치 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\"을 삭제하면 해당 위치가 지정된 보관함의 위치 정보가 초기화됩니다.'**
  String locationDeleteConfirm(String name);

  /// 위치 저장 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'저장 실패: {error}'**
  String locationSaveFailed(String error);

  /// 위치 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'위치를 추가해 주세요'**
  String get locationAddHint;

  /// 위치 이름 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'위치 이름 입력'**
  String get locationNameHint;

  /// 프로필 보관함 카운트 레이블
  ///
  /// In ko, this message translates to:
  /// **'보관함'**
  String get profileStorages;

  /// 프로필 의류 카운트 레이블
  ///
  /// In ko, this message translates to:
  /// **'의류'**
  String get profileClothes;

  /// 내 보관함 메뉴
  ///
  /// In ko, this message translates to:
  /// **'내 보관함'**
  String get profileMyStorages;

  /// 위치 관리 메뉴
  ///
  /// In ko, this message translates to:
  /// **'위치 관리'**
  String get profileLocations;

  /// 가족 연결 메뉴
  ///
  /// In ko, this message translates to:
  /// **'가족 연결'**
  String get profileFamily;

  /// 의류 검색 메뉴
  ///
  /// In ko, this message translates to:
  /// **'의류 검색'**
  String get profileClothSearch;

  /// QR 스캔 메뉴
  ///
  /// In ko, this message translates to:
  /// **'QR 스캔'**
  String get profileQrScan;

  /// 닉네임 설정 버튼
  ///
  /// In ko, this message translates to:
  /// **'닉네임 설정'**
  String get profileNicknameSet;

  /// 사진 업로드 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'사진 업로드 실패: {error}'**
  String profilePhotoFailed(String error);

  /// 닉네임 저장 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'닉네임 저장 실패: {error}'**
  String profileNicknameFailed(String error);

  /// 닉네임 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'닉네임 입력'**
  String get profileNicknameHint;

  /// 언어 설정 항목
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguage;

  /// 구독 플랜 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'구독 플랜'**
  String get pricingTitle;

  /// 월 구독 옵션
  ///
  /// In ko, this message translates to:
  /// **'월 구독'**
  String get pricingMonthly;

  /// 연 구독 옵션
  ///
  /// In ko, this message translates to:
  /// **'연 구독'**
  String get pricingYearly;

  /// 연 구독 할인 안내
  ///
  /// In ko, this message translates to:
  /// **'최대 32% 할인'**
  String get pricingDiscount;

  /// 현재 플랜 버튼
  ///
  /// In ko, this message translates to:
  /// **'현재 플랜'**
  String get pricingCurrentPlan;

  /// 구독 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get pricingStart;

  /// 결제 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'결제 실패: {error}'**
  String pricingPayFailed(String error);

  /// 데이터 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 없음'**
  String get adminNoData;

  /// 전체 사용자 레이블
  ///
  /// In ko, this message translates to:
  /// **'전체 사용자'**
  String get adminTotalUsers;

  /// 전체 조직 레이블
  ///
  /// In ko, this message translates to:
  /// **'전체 조직'**
  String get adminTotalOrgs;

  /// 전체 보관함 레이블
  ///
  /// In ko, this message translates to:
  /// **'전체 보관함'**
  String get adminTotalStorages;

  /// 전체 옷 레이블
  ///
  /// In ko, this message translates to:
  /// **'전체 옷'**
  String get adminTotalClothes;

  /// QR 스티커 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'QR 스티커'**
  String get qrStickerTitle;

  /// QR 출력 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'출력 중 오류가 발생했습니다'**
  String get qrPrintError;

  /// 스티커 출력 버튼
  ///
  /// In ko, this message translates to:
  /// **'스티커 출력'**
  String get qrPrint;

  /// QR 스캔 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'QR 스캔'**
  String get qrScanTitle;

  /// 미등록 QR 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'등록되지 않은 QR입니다'**
  String get qrNotRegistered;

  /// 다른 보관함으로 이동 메뉴
  ///
  /// In ko, this message translates to:
  /// **'다른 보관함으로 이동'**
  String get moveToStorage;

  /// 휴지통으로 이동 메뉴
  ///
  /// In ko, this message translates to:
  /// **'휴지통으로 이동'**
  String get moveToTrash;

  /// 판매 보관함으로 이동 메뉴
  ///
  /// In ko, this message translates to:
  /// **'판매 보관함으로 이동'**
  String get moveToSale;

  /// 이동 완료 SnackBar 메시지
  ///
  /// In ko, this message translates to:
  /// **'이동했습니다'**
  String get moveDone;

  /// 이동 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'이동 실패: {error}'**
  String moveFailed(String error);

  /// 홈 화면 기본 보관함 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'기본 보관함'**
  String get systemStorages;

  /// 프로필 휴지통 표시 토글
  ///
  /// In ko, this message translates to:
  /// **'휴지통 보관함 표시'**
  String get settingsShowTrash;

  /// 프로필 판매 보관함 표시 토글
  ///
  /// In ko, this message translates to:
  /// **'판매 보관함 표시'**
  String get settingsShowSale;

  /// 프로필 보관함 표시 설정 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'보관함 표시 설정'**
  String get storageVisibility;

  /// 보관함 선택 BottomSheet 타이틀
  ///
  /// In ko, this message translates to:
  /// **'보관함 선택'**
  String get selectStorage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
