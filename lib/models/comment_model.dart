import 'package:user_ecomm/models/user_model.dart';

const String collectionComment='Comment';

const String commentFieldId='commentId';
const String commentFieldUserModel='userId';
const String commentFieldProductId='productId';
const String commentFieldComment='comment';
const String commentFieldApproved='approved';
const String commentFieldDate = 'date';

class CommentModel{
  String? commentId;
  UserModel userModel;
  String productId;
  String comment;
  bool approved;
  String date;

  CommentModel({
    required this.date,
    this.commentId,
    required this.userModel,
    required this.productId,
    required this.comment,
    this.approved=false,
  });

  Map<String,dynamic>toMap(){
    return <String,dynamic>{
      commentFieldId:commentId,
      commentFieldUserModel:userModel.toMap(),
      commentFieldProductId:productId,
      commentFieldComment:comment,
      commentFieldDate: date,
      commentFieldApproved: approved,
    };
  }

  factory CommentModel.fromMap(Map<String,dynamic>map)=>CommentModel(
    commentId: map[commentFieldId],
    userModel: UserModel.fromMap(map[commentFieldUserModel]),
    productId: map[commentFieldProductId],
    comment: map[commentFieldComment],
    date: map[commentFieldDate],
    approved: map[commentFieldApproved],
  );

}