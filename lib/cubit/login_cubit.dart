import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  void submitLogin( String password, String mobile, String userType ) {
    try {

      emit(LoginHUDState());
      ServiceCall.post({
        "user_type": userType,
        "password": password,
        "contact_number": mobile,

      }, SVKey.svLogin, withSuccess: (responseObj) async {
        print(responseObj);

        if( ( responseObj[KKey.status]  as String? ?? "" ) == "1" ) {
            ServiceCall.userObj = responseObj[KKey.payload] as Map? ?? {};
            ServiceCall.userType = ServiceCall.userObj["user_type"] as int? ?? 1;


            Globs.udSet(ServiceCall.userObj, Globs.userPayload);
            Globs.udBoolSet(false,"is_online");
            Globs.udBoolSet(true, Globs.userLogin);
            emit(LoginApiResultState());
            emit(LoginInitialState());
        }else{
          emit(LoginErrorState(responseObj[KKey.message] ?? MSG.fail ),);
        }
        
      }, failure: (err) async {
        print(err);
          emit(LoginErrorState(err));
      }, );
      
    } catch (e) {
      print(e.toString());
      emit(LoginErrorState(e.toString()));
    }
  }
}
