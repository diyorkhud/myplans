import 'package:flutter/material.dart';


import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/rtdb_service.dart';
import 'details_page.dart';
class HomePage extends StatefulWidget {
  static const String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post>items=[];
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }
  _openDetail() async{
    Map results = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context){
          return const DetailsPage();
        }
    ),);
    if(results !=null  && results.containsKey("data")){
      print(results["data"]);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async{
    setState((){
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts) => {
      _resPosts(posts),
    });
  }

  _resPosts(List<Post> posts){
    setState((){
      isLoading = false;
      items = posts;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vazifalar"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white,),
          ),
        ],
      ),
      body: Stack(
          children:[
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i){
                return itemOfList(items[i]);
              },
            ),
            isLoading ? const Center(
              child: CircularProgressIndicator(),
            ): SizedBox.shrink(),
          ]
      ),
      drawer: Drawer(
        child:  ListView(
          padding:  EdgeInsets.all(0.0),
          children: [
            const UserAccountsDrawerHeader(
              accountName:  Text("Elektron Kundalik", style: TextStyle(color: Colors.white, fontSize: 20),),
              accountEmail:  Text("diyor@gmail.com"),
              currentAccountPicture:  CircleAvatar(
                backgroundColor: Colors.white,
                // child:  Text("D",style: TextStyle(fontSize: 50)),
                backgroundImage: NetworkImage("https://sun9-72.userapi.com/impg/LKuXTFEjnW0gQ0F4cWR2A3XR7M8TP1fzwpuBgQ/0d1gnASdAx8.jpg?size=807x807&quality=96&sign=598c6cf80eae28a8dfc35de4b9a602d0&type=album"),
              ),
            ),

            const ListTile(
              trailing:  Icon(Icons.workspace_premium),
              title:  Text("Premium versiya"),
            ),
            const Divider(),
            ListTile(
              title:  Text("Dastur haqida"),
              trailing:  Icon(Icons.people),
              onTap: () => {},
            ),
            const Divider(),
            ListTile(
              title:  Text("Mavzular"),
              trailing:  Icon(Icons.imagesearch_roller_outlined),
              onTap: () => {},
            ),
            const Divider(),
            ListTile(
              title:  Text("Yordam"),
              trailing:  Icon(Icons.help_outline),
              onTap: () => {},
            ),
            const Divider(),
            ListTile(
              title:  Text("Ulashish"),
              trailing:  Icon(Icons.share_rounded),
              onTap: () => {},
            ),
            const Divider(),
            ListTile(
              title:  Text("Sozlamalar"),
              trailing:  Icon(Icons.settings),
              onTap: () => {},
            ),
            const Divider(),
            ListTile(
              title:  Text("Ekran qulfi"),
              trailing:  Icon(Icons.lock_outline_rounded),
              onTap: () => {},
            ),
            const Divider(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget itemOfList(Post post){
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: 70,
            width: 70,
            child: post.img_url != null ?
            Image.network(post.img_url!,fit: BoxFit.cover,):
            Image.asset("assets/images/default.png",),
          ),
          const SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: const TextStyle(color: Colors.black, fontSize: 20),),
                const SizedBox(height: 10,),
                Text(post.content, style: const TextStyle(color: Colors.black, fontSize: 16),),
                const SizedBox(height: 10,),
                Text(post.time, style: const TextStyle(color: Colors.black, fontSize: 16),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
