import 'package:cancellation_token/cancellation_token.dart';

class ActionCancellable with Cancellable {
  late final Function _onCancel;

  ActionCancellable(Function onCancel) {
    _onCancel = onCancel;
  }

  @override
  void onCancel(Exception cancelException) {
    super.onCancel(cancelException);

    _onCancel.call();
  }
}
