import 'package:flutter/material.dart';
import 'package:smartlink/SignPage.dart';

class AvailablePlaces extends StatefulWidget {
  const AvailablePlaces({Key? key}) : super(key: key);

  @override
  State<AvailablePlaces> createState() => _AvailablePlacesState();
}

class _AvailablePlacesState extends State<AvailablePlaces> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Availble Places"),),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network("https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                          width: 100,height: 100,fit: BoxFit.cover,),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hotel 1", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("Description"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ), Container(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network("https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                          width: 100,height: 100,fit: BoxFit.cover,),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hotel 1", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("Description"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ), Container(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network("https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                          width: 100,height: 100,fit: BoxFit.cover,),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hotel 1", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("Description"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network("https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                          width: 100,height: 100,fit: BoxFit.cover,),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hotel 1", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("Description"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: size.width,
            height: kToolbarHeight,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SignPage()));
            }, child: Text(
              "Sign up and get smart"
            )),
          )
        ],
      ),
    );
  }
}
