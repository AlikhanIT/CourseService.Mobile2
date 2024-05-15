part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthorizedState extends AuthState {
  final String userModel;
  final bool isReAuthorizedWithTheSameNumber;
  AuthorizedState(this.userModel, this.isReAuthorizedWithTheSameNumber);
}


// extension GetUserModel on AuthState {
//   UserModel? get userModel {
//     final cls = this;
//     if (cls is AuthorizedState) {
//       return cls.userModel;
//     }
//     return null;
//   }
//
//   ClientRequestModel? get clientModel {
//     final cls = this;
//     if (cls is AuthorizedState) {
//       return ClientRequestModel(
//           clientCode: cls.userModel.clientCode,
//           userId: cls.userModel.clientData?.userId.toString(),
//           clientIIN: cls.userModel.clientIIN,
//           clientFIO: cls.userModel.clientFIO,
//           deviceId: '',
//           userLogin: cls.userModel.phoneNumber,
//           clientId: null);
//     }
//     return null;
//   }
//
//   bool get authorized {
//     final cls = this;
//     if (cls is AuthorizedState) {
//       return true;
//     }
//     return false;
//   }
// }
