import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';

void restApiErrorHandling(error, context) {
  showSnackbar(context: context, message: error['message'] ?? error);
}
