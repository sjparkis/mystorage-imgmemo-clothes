// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get retry => '다시 시도';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get save => '저장';

  @override
  String get noName => '이름 없음';

  @override
  String get loginSubtitle => '나만의 옷 보관함';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get saveId => '아이디 저장';

  @override
  String get savePassword => '비밀번호 저장';

  @override
  String get back => '← 돌아가기';

  @override
  String get backToLogin => '← 로그인으로 돌아가기';

  @override
  String get passwordMinLength => '6자 이상 입력해 주세요';

  @override
  String get passwordConfirm => '비밀번호 확인';

  @override
  String get passwordMismatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get emailVerificationSent => '인증 이메일을 보냈습니다. 이메일을 확인해 주세요.';

  @override
  String get authErrRequired => '이메일과 비밀번호를 입력해 주세요.';

  @override
  String get authErrPasswordShort => '비밀번호는 6자 이상이어야 합니다.';

  @override
  String get authErrInvalidCredentials => '이메일 또는 비밀번호가 올바르지 않습니다.';

  @override
  String get authErrEmailInUse => '이미 사용 중인 이메일입니다.';

  @override
  String get authErrInvalidInput => '입력 정보를 확인해 주세요. (비밀번호 6자 이상)';

  @override
  String get authErrNetwork => '네트워크 연결을 확인해 주세요.';

  @override
  String get noLocation => '위치 미설정';

  @override
  String get loadFailed => '불러오기 실패';

  @override
  String get addStorageHint => '+ 버튼으로 보관함을 추가해 보세요';

  @override
  String get navHome => '홈';

  @override
  String get navSearch => '검색';

  @override
  String get navAiOrganize => 'AI 정리';

  @override
  String get navMy => '나의';

  @override
  String get noLocationTag => '위치 없음';

  @override
  String get takePhoto => '카메라로 찍기';

  @override
  String get fromGallery => '갤러리에서 가져오기';

  @override
  String get storageName => '보관함 이름';

  @override
  String get locationOptional => '위치 선택 (선택사항)';

  @override
  String get addClothHint => '옷을 추가해 주세요';

  @override
  String get present => '있음';

  @override
  String get absent => '없음';

  @override
  String get confirmPresent => '있음 확인?';

  @override
  String loadError(String error) {
    return '오류: $error';
  }

  @override
  String get addCloth => '옷 추가';

  @override
  String get aiAnalyzing => 'AI 분석 중...';

  @override
  String get nameOptional => '이름 (선택)';

  @override
  String get memoOptional => '메모 (선택)';

  @override
  String get aiAnalysis => 'AI 분석';

  @override
  String get tagColor => '색상';

  @override
  String get tagType => '종류';

  @override
  String get tagMaterial => '소재';

  @override
  String get tagSeason => '계절';

  @override
  String get tagStyle => '스타일';

  @override
  String get tagCondition => '상태';

  @override
  String get tagBrand => '브랜드';

  @override
  String get tagOther => '기타';

  @override
  String get aiReanalyze => 'AI 재분석';

  @override
  String get aiAnalyzeDone => 'AI 분석 완료';

  @override
  String analyzeError(String error) {
    return '분석 실패: $error';
  }

  @override
  String get clothLoadError => '옷 정보를 불러올 수 없습니다';

  @override
  String get searchHint => '옷 이름, 태그, 메모로 검색';

  @override
  String get searchPlaceholder => '이름 또는 태그로 검색해 보세요';

  @override
  String get searchNoResults => '검색 결과가 없습니다';

  @override
  String searchError(String error) {
    return '검색 오류: $error';
  }

  @override
  String get orgCriteriaSeason => '계절별';

  @override
  String get orgCriteriaMaterial => '소재별';

  @override
  String get orgCriteriaColor => '색상별';

  @override
  String get orgCriteriaLabel => '분류 기준';

  @override
  String get orgMaxPerBox => '상자당 최대 의류 수';

  @override
  String get orgMaxPerBoxHint => '옷의 평균 부피를 고려해 상자가 너무 많아지지 않도록 적절히 설정하세요.';

  @override
  String get orgStartAnalysis => 'AI 분석 시작';

  @override
  String get orgAnalyzing => 'AI가 의류를 분석하는 중...';

  @override
  String orgSortingBy(String criteria) {
    return '$criteria 기준으로 분류 중';
  }

  @override
  String get orgUncategorized => '미분류';

  @override
  String get orgPlanTitle => 'AI 정리 계획';

  @override
  String orgSummary(int total, int groups) {
    return '총 $total개 의류  →  $groups개 새 보관함';
  }

  @override
  String orgCriteriaDetail(String criteria, int max) {
    return '기준: $criteria  ·  상자당 최대 $max개';
  }

  @override
  String get orgReset => '다시 설정';

  @override
  String orgMoveCount(int count) {
    return '$count개 이동';
  }

  @override
  String get orgApplyConfirm => '새 보관함이 생성되고 의류가 이동됩니다.\n기존 보관함은 그대로 유지됩니다.';

  @override
  String get orgNoClothes => '등록된 의류가 없습니다.';

  @override
  String orgAnalyzeFailed(String error) {
    return 'AI 분석 실패: $error';
  }

  @override
  String get orgApplyDone => '새 보관함에 적용됐습니다.';

  @override
  String orgApplyFailed(String error) {
    return '적용 실패: $error';
  }

  @override
  String get familyRemoveMember => '멤버 제거';

  @override
  String familyRemoveConfirm(String email) {
    return '$email을(를) 가족에서 제거할까요?';
  }

  @override
  String get familyRemove => '제거';

  @override
  String familyRemoveFailed(String error) {
    return '제거 실패: $error';
  }

  @override
  String get familyInviteInfo => '가족에게 코드를 공유하면 같은 보관함을 사용할 수 있습니다.';

  @override
  String get familyCodeExpiry => '48시간 유효';

  @override
  String get familyCodeCopied => '코드가 복사됐습니다.';

  @override
  String get familyNewCode => '새로 생성';

  @override
  String get familyCreateCode => '초대 코드 생성';

  @override
  String familyCodeCreateFailed(String error) {
    return '코드 생성 실패: $error';
  }

  @override
  String get familyJoinHint => '가족에게 받은 코드를 입력해 보관함을 공유하세요.';

  @override
  String get familyJoined => '가족 보관함에 연결됐습니다.';

  @override
  String get familyInvalidCode => '유효하지 않거나 만료된 코드입니다.';

  @override
  String get familyAlreadyMember => '이미 연결된 가족입니다.';

  @override
  String familyJoinFailed(String error) {
    return '연결 실패: $error';
  }

  @override
  String get familyRoleMe => '나';

  @override
  String get familyRoleOwner => '관리자';

  @override
  String get familyRoleMember => '멤버';

  @override
  String get locationDeleteTitle => '위치 삭제';

  @override
  String locationDeleteConfirm(String name) {
    return '\"$name\"을 삭제하면 해당 위치가 지정된 보관함의 위치 정보가 초기화됩니다.';
  }

  @override
  String locationSaveFailed(String error) {
    return '저장 실패: $error';
  }

  @override
  String get locationAddHint => '위치를 추가해 주세요';

  @override
  String get locationNameHint => '위치 이름 입력';

  @override
  String get profileStorages => '보관함';

  @override
  String get profileClothes => '의류';

  @override
  String get profileMyStorages => '내 보관함';

  @override
  String get profileLocations => '위치 관리';

  @override
  String get profileFamily => '가족 연결';

  @override
  String get profileClothSearch => '의류 검색';

  @override
  String get profileQrScan => 'QR 스캔';

  @override
  String get profileNicknameSet => '닉네임 설정';

  @override
  String profilePhotoFailed(String error) {
    return '사진 업로드 실패: $error';
  }

  @override
  String profileNicknameFailed(String error) {
    return '닉네임 저장 실패: $error';
  }

  @override
  String get profileNicknameHint => '닉네임 입력';

  @override
  String get settingsLanguage => '언어';

  @override
  String get pricingTitle => '구독 플랜';

  @override
  String get pricingMonthly => '월 구독';

  @override
  String get pricingYearly => '연 구독';

  @override
  String get pricingDiscount => '최대 32% 할인';

  @override
  String get pricingCurrentPlan => '현재 플랜';

  @override
  String get pricingStart => '시작하기';

  @override
  String pricingPayFailed(String error) {
    return '결제 실패: $error';
  }

  @override
  String get adminNoData => '데이터 없음';

  @override
  String get adminTotalUsers => '전체 사용자';

  @override
  String get adminTotalOrgs => '전체 조직';

  @override
  String get adminTotalStorages => '전체 보관함';

  @override
  String get adminTotalClothes => '전체 옷';

  @override
  String get qrStickerTitle => 'QR 스티커';

  @override
  String get qrPrintError => '출력 중 오류가 발생했습니다';

  @override
  String get qrPrint => '스티커 출력';

  @override
  String get qrScanTitle => 'QR 스캔';

  @override
  String get qrNotRegistered => '등록되지 않은 QR입니다';
}
