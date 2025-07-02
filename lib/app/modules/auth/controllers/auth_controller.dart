import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_services.dart';
import '../../../services/my_auth_service.dart';
import '../../userBookings/controllers/bookings_controller.dart';

class AuthController extends GetxController {
  //final Rx<M>

  final hidePassword = true.obs;
  final loading = false.obs;
  final employeeLoading = false.obs;
  var onClick = false.obs;
  var birthDateSet = false.obs;
  final smsSent = ''.obs;
  var confirmPassword = ''.obs;

  var name = "".obs;
  var email = TextEditingController();
  var password = TextEditingController();
  var emailAddress = "".obs;
  var pass = "".obs;
  var phone = ''.obs;

  var userId = 0.obs;
  var isChecked = false.obs;
  var isEmployee = false.obs;
  var verifyClicked = false.obs;
  var loginClickable = false.obs;
  var accepted = false.obs;
  var code = ''.obs;
  // GoogleSignIn googleAuth = GoogleSignIn();
  // GoogleSignInAccount googleAccount;
  var users = [].obs;
  var auth;
  var authUserId = 0.obs;
  var resources = [].obs;
  var currentUser = {}.obs;
  var appointmentIds = [].obs;

  @override
  void onInit() async {

    getRecentUser();

    super.onInit();
  }

  getRecentUser()async{
    var box = await GetStorage();
    if(box.read('checkBox') != null){
      isChecked.value = box.read('checkBox');
    }
    if(isChecked.value){

      print("${box.read('userEmail')} and ${box.read('password')}");
      email.text = box.read('userEmail');
      password.text = box.read('password');

    }else{
      box.remove("userEmail");
      box.remove("password");
      box.remove("checkBox");
      box.write("checkBox", false);
    }
  }

  onTokenReceived(String token) {
    print("FINAL TOKEN===> $token");
  }

 /* Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      for (final providerProfile in user.providerData) {
        // ID of the provider (google.com, apple.com, etc.)
        final provider = providerProfile.providerId;

        // UID specific to the provider
        final uid = providerProfile.uid;

        // Name, email address, and profile photo URL
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        //final profilePhoto = providerProfile.photoURL;
        final phone = providerProfile.phoneNumber;
        final photo = providerProfile.photoURL;
        print(photo);

        var found = await getUserByEmail(emailAddress, "");
        if (found){
          //Get.find<MyAuthService>().myUser.value = await _userRepository.get(users[index]['partner_id'][0]['id']);
          //Get.find<MyAuthService>().myUser.value.image = photo;
          Domain.googleUser = true;
          Domain.googleImage = photo;

          var foundDeviceToken= false;
          if(Get.find<MyAuthService>().myUser.value.deviceTokenIds.isNotEmpty)
          {
            var tokensList = await getUserDeviceTokens(Get.find<MyAuthService>().myUser.value.deviceTokenIds);
            for(int i = 0; i<tokensList.length;i++){
              if(Domain.deviceToken==tokensList[i]['token']){
                foundDeviceToken = true;
              }
            }
          }

          loading.value = false;
          *//*if(!foundDeviceToken){
            await saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
          }*//*
          Get.showSnackbar(Ui.SuccessSnackBar(message: "You signed in successfully " ));
          await Get.toNamed(Routes.ROOT);

        }
        else{
          await createGoogleUser(name, emailAddress, phone);
          //Get.find<MyAuthService>().myUser.value.image = photo;
          Domain.googleUser = true;
          Domain.googleImage = photo;

          //await saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
          Get.showSnackbar(Ui.SuccessSnackBar(message: "You signed in successfully " ));
          await Get.toNamed(Routes.ROOT);

        }
      }
    }
  }*/

  /*createGoogleUser(String name, String email, String phone ) async {
    this.email.value = email;
    this.name.value = name;
    print(name);
    print(email);
    print(phone);

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };
    var request = http.Request('POST',Uri.parse('${Domain.serverPort}/create/res.users?values={ '
        '"name": "$name",'
        '"login": "$email",'
        //'"email": "$email",'
        '"phone": "$phone",'
        '"sel_groups_1_9_10": 1}'

    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)  {
      var result = await response.stream.bytesToString();
      print(result);
      await login();
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      //existingPartner = ['testname','https://stock.adobe.com/search?k=admin'];
      //existingPartnerVisible.value = true;
    }
  }*/

  // googleSignOut() async {
  //   googleAccount = await googleAuth.signOut();
  //
  // }

  getAllUsers()async{
    var headers = {
      'api-key': Domain.apiKey
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort2}/res.users/search'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      List list = json.decode(data)['data'];
      users.value = list;
      print("ok");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  void sendResetLink(int userId) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/res.users/action_reset_password?ids=$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: "An email has been sent to ${email.value}, please follow the instructions to reset your password".tr ));
      onClick.value = false;
    }
    else {
      onClick.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "User not found!!!" ));
      print(response.reasonPhrase);
    }
  }

  getUserVerification(int id)async{
    print(id);
    var headers = {
      'api-key': Domain.apiKey
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort2}/res.users/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['data'][0];

      if(data['sh_user_from_signup']){

        var foundDeviceToken= false;
        loading.value = false;

        if(Get.find<MyAuthService>().myUser.value.deviceTokenIds.isNotEmpty)
        {
          var tokensList = await getUserDeviceTokens(Get.find<MyAuthService>().myUser.value.deviceTokenIds);
          for(int i = 0; i<tokensList.length;i++){
            if(Domain.deviceToken==tokensList[i]['token']){
              foundDeviceToken = true;
            }
          }

        }
/*
        if(!foundDeviceToken){
          await saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
        }
*/
        Get.showSnackbar(Ui.SuccessSnackBar(message: "You logged in successfully " ));

        verifyClicked.value = false;

        await Get.toNamed(Routes.ROOT);

      }else{
        code.value = data['verification_code'].toString();
        loading.value = false;
        Get.toNamed(Routes.VERIFICATION);
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future login(String role) async {

    Get.put(BookingsController());
    final BookingsController controller = Get.find<BookingsController>();
    var box = GetStorage();
    isEmployee.value = false;
    if(role == "client"){
      loading.value = true;
    }else{
      employeeLoading.value = true;
    }

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverAddress}/web/session/authenticate'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "db": "willonhair_db",
        "login": email.text,
        "password": password.text
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['result'];

      if(data != null){

        currentUser.value = data;
        var partner = await controller.getCurrentUser(data['partner_id']);

        if(role == "client"){

          box.write("userData", data);
          Get.showSnackbar(Ui.SuccessSnackBar(message: "connexion réussi, bon retour M/Mme ${data['name']}"));
          appointmentIds.value = partner['appointment_ids'];
          loading.value = false;
          Get.toNamed(Routes.ROOT);

        }else{

          /*var foundDeviceToken= false;

          if(partner['fcm_token_ids'].isNotEmpty) {
            var tokensList = await getUserDeviceTokens(partner['fcm_token_ids']);
            for(int i = 0; i<tokensList.length;i++){
              if(Domain.deviceToken==tokensList[i]['token']){
                foundDeviceToken = true;
              }
            }
          }*/

          /*if(!foundDeviceToken){
          await saveDeviceToken(Domain.deviceToken, partnerData[0]['id']);
        }*/

          ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
            content: Text("Verification des information..."),
            backgroundColor: validateColor.withOpacity(0.4),
            duration: Duration(seconds: 3),
          ));

          await getEmployees(data);
        }
      }
      else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "User credentials not matching or existing"));
        loading.value = false;
        return 0;
        //throw new Exception(response.reasonPhrase);
      }
    }
    else {Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred, please try to login again"));
    loading.value = false;
    }
  }

  Future getEmployees(var user)async{

    try {
      var box = GetStorage();
      var employee;

      var headers = {
        'Accept': 'application/json',
        'Authorization': Domain.authorization,
      };
      var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/business.resource'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        var data = json.decode(result);
        resources.value = data;
        for(var i=0; i< data.length; i++){
          if(data[i]['user_id'][0] == user['uid']){
            employee = data[i];
          }
        }
        if(employee != null){
          currentUser.value = employee;
          employeeLoading.value = false;
          showDialog(
              context: (Get.context),
              builder: (_){
                return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    title: Text("Connexion réussi", style: Get.textTheme.headline1),
                    content: Text("Veuillez choisir votre profil de connexion ?\n", style: Get.textTheme.headline4),
                    actions: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () {
                              box.write("userData", user);
                              Navigator.pop(Get.context);
                              Get.showSnackbar(Ui.SuccessSnackBar(message: "connexion réussi, bon retour M/Mme ${user['name']}"));
                              Get.toNamed(Routes.ROOT);
                            },
                                child: Text("Client", style: Get.textTheme.headline2)),
                            SizedBox(width: 10),
                            TextButton(onPressed: () {
                              isEmployee.value = true;
                              box.write("userData", employee);
                              Navigator.pop(Get.context);
                              Get.showSnackbar(Ui.SuccessSnackBar(message: "connexion réussi, bon retour M/Mme ${employee['display_name']}"));
                              Get.toNamed(Routes.EMPLOYEE_HOME);
                            },
                                child: Text("employee", style: Get.textTheme.headline2)),
                          ]
                      )
                    ]
                );
              });

        }else{
          box.write("userData", user);
          Get.showSnackbar(Ui.SuccessSnackBar(message: "connexion réussi, bon retour M/Mme ${user['name']}"));
          Get.toNamed(Routes.ROOT);
        }
        employeeLoading.value = false;

      }
      else {
        loading.value = false;
        var result = await response.stream.bytesToString();
        var data = json.decode(result);
        Get.showSnackbar(Ui.ErrorSnackBar(message: data.toString()));
        print(response.reasonPhrase);
      }
    }catch (e){
      employeeLoading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e));
      print(e);
    }
  }

  Future register() async {
    loading.value = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST',Uri.parse('${Domain.serverPort}/create/res.users?values={ '
        '"name": "${name.value}",'
        '"login": "${email.value}",'
        '"password": "${password.value}",'
        '"sel_groups_1_9_10": 1}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)  {
      getUserByEmail(email.value, "signup");
    }
    else {
      print(response.reasonPhrase);
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      loading.value = false;
    }
  }

  Future getUserByEmail(var email, String reason)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverAddress}/will/get_user_by_email'));
    request.fields.addAll({
      'email': email
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(reason == "signup"){
        ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text("Mise a jour des information..."),
          duration: Duration(seconds: 2),
        ));
        updateUser(json.decode(data)['partner_id']);
      }else if(reason == "resetPassword"){
        if(json.decode(data)['user_id'] != null){
          sendEmail(json.decode(data)['user_id'], email);
        }else{
          onClick.value = false;
          Get.showSnackbar(Ui.warningSnackBar(message: json.decode(data)['error']));
        }
      }else{
        if(json.decode(data)['user_id'] != null){
          return true;
        }else{
          return false;
        }
      }
    }
    else {
      var data = await response.stream.bytesToString();
      print(response.reasonPhrase);
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  updateUser(var id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.partner?ids=$id&values={'
        '"email": "${email.value}",'
        '"phone": "${phone.value}",'
        '"mobile": "${phone.value}",'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //var data = await response.stream.bytesToString();
      loading.value = false;
      Get.toNamed(Routes.LOGIN);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  /*saveDeviceToken(String token, var id)async{
    print("token is: $token");
    print(id.toString());

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/fcm.device.token?values={'
        '"token": "$token",'
        '"partner_id": $id}'));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('Device token already exist, Again ');
    }
    else {
      print(response.reasonPhrase);
    }
  }*/

  getUserDeviceTokens(List tokensList)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/fcm.device.token?ids=$tokensList'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      return result;

    }
    else {
      print(response.reasonPhrase);
    }
  }

  void sendEmail(var id, var email)async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/res.users/action_reset_password?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.InfoSnackBar(message: "Un mail a été envoyé à l'adresse $email"));
      onClick.value = false;
      Navigator.pop(Get.context);
    }
    else {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      Get.showSnackbar(Ui.ErrorSnackBar(message: result['message']));
      print(response.reasonPhrase);
    }
  }
}