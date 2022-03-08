import 'package:qm_widget/net/net_client.dart';
import 'package:qm_widget/net/net_request.dart';

NetRequest get netRequest => NetNative();

class NetNative extends NetRequest {
  NetNative() : super(NetClient());
}
