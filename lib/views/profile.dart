import 'package:ecommerce_customer/controllers/auth_service.dart';
import 'package:ecommerce_customer/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w600),)
      ),
      body: Column(
         children: [
           Consumer<UserProvider>(
             builder: (context, user, child) =>
              Card(
               child: ListTile(
                 title: Text(user.name),
                 subtitle: Text(user.email),
                 onTap: (){
                   Navigator.pushNamed(context, '/updateprofile');
                 },
                 trailing: Icon(Icons.edit_outlined),
               ),

             ),
           ),
           SizedBox(height: 20),
           Divider(thickness: 1,endIndent: 10,indent: 10),
           ListTile(
             title: Text("Order"),
             leading: Icon(Icons.local_shipping_outlined),
             onTap: () async {

             },
           ),
           Divider(thickness: 1,endIndent: 10,indent: 10),
           ListTile(
             title: Text("Discount and Offers"),
             leading: Icon(Icons.discount_outlined),
             onTap: () async {

             },
           ),
           Divider(thickness: 1,endIndent: 10,indent: 10),
           ListTile(
             title: Text("Help and Support"),
             leading: Icon(Icons.support_agent_outlined),
             onTap: () async {

             },
           ),
           Divider(thickness: 1,endIndent: 10,indent: 10),
           ListTile(
             title: Text("Log Out"),
             leading: Icon(Icons.login_outlined),
             onTap: () async {
                await AuthService().signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => true
                );
             },
           )
         ],
      ),
    );
  }
}
