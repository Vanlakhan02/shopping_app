import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/Edit_Product_Screen.dart';
class UserItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserItem({required this.id, required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  final scaffold = Scaffold.of(context);
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        trailing: Container(
          width: 100,
          child: Row(
              children: [
              IconButton(icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
               onPressed: () {
                  Navigator.of(context).pushNamed(EditScreen.routeName,arguments: id );

               }),
              IconButton(icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
               onPressed: () async{
                 try{
                  await Provider.of<Products>(context, listen: false).deleteProduct(id);
                 }catch(error){
                   scaffold.showSnackBar(const SnackBar(content: Text("Deleting is fail!", textAlign: TextAlign.center,)));
                 }
                
               })
              ]),
        ));
  }
}
