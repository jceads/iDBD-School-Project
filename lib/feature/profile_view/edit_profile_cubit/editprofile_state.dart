part of 'editprofile_cubit.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class RefreshPage extends EditProfileState {}

class ImageUploaded extends EditProfileState {}

class ImageUploading extends EditProfileState {}

class Processing extends EditProfileState {}
