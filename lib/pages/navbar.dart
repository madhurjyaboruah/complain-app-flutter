import 'package:first_app/pages/LoginPage.dart';
import 'package:first_app/services/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/MycomplainForm.dart';

class NavBar extends StatelessWidget {
  final String userID;
  const NavBar(this.userID,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Name'),
            accountEmail: Text('CPF No. '+userID),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/en/thumb/9/9a/ONGC_Logo.svg/1200px-ONGC_Logo.svg.png',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account Settings'),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('My Complaints'),
            // ignore: avoid_returning_null_for_void
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) =>  MycomplainForm(userID)),
              );
            },   
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
            // ignore: avoid_returning_null_for_void
            onTap: ()async{
              await LoginService.logout();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => LoginPage())),
              );
            },
          ),
        ],
      ),
    );
  }
}
