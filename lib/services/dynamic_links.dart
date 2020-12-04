import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService{
  Future handleDynamicLinks() async{
    //STARTUP FROM DEEPLINK LOGIC AFTER BEING CLOSED
    //Get initial dynamic link if the app is started using the link
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    //INTO FOREGROUND FROM DYNAMIC LINK LOGIC
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLinkData) async{
        _handleDeepLink(dynamicLinkData);
      },
      onError: (OnLinkErrorException e) async {
        print('Dynamic Link Failed: ${e.message}');
      }
    );
  }

  void _handleDeepLink (PendingDynamicLinkData data){
    final Uri deepLink = data?.link;
    if(deepLink != null){
      print('_handleDeepLink | deepLink: $deepLink');
    }
  }
}