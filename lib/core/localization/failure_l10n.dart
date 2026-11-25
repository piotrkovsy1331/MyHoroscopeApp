import '../error/failures.dart';
import 'generated/app_localizations.dart';

extension FailureL10n on Failure {
  String localizedMessage(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    ServerFailure() => l10n.errorServer,
    DataFormatFailure() => l10n.errorDataFormat,
    CacheFailure() || UnexpectedFailure() => l10n.errorUnexpected,
  };
}
