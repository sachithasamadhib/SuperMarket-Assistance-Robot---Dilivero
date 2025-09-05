import 'dart:convert';

import 'package:customerbuy/ScrollableCards.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:customerbuy/localData.dart';
void main() => runApp(const NavigationBarApp());

 enum DioMethod { post, get, put, delete }
  final String baseUrl = 'http://192.168.101.42:8000'; //the Main URL and changes it 
  List<dynamic> allData = []; 
  List<dynamic> qty = [];
  List<dynamic> id = [];
  List<dynamic> imgLink = [];
  List<dynamic> description = [];
  List<dynamic> status = [];
  List<dynamic> name = [];
  List<dynamic> price = [];
  bool isLoading = true;
  //SQLITE
  List<dynamic>citemID = [];
  Dio _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    //API SERVICE
        class APIService {
  APIService._singleton();
  static final APIService instance = APIService._singleton();
  // Initialize Dio in the constructor
  APIService._() {}
  Future<Response> request(
    String endpoint,
    DioMethod method, {
  //  Map<String, dynamic>? param,
    String? contentType,
    dynamic formData,
  }) async {
    try {
      late Response response;
      
      switch (method) {
        case DioMethod.post:
          response = await _dio.post(endpoint);
          break;
        case DioMethod.get:
          response = await _dio.get(endpoint);
          break;
        case DioMethod.put:
          response = await _dio.put(endpoint);
          break;
        case DioMethod.delete:
          response = await _dio.delete(endpoint);
          break;
      }
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        return Exception('Bad response: ${e.response?.statusMessage}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error occurred');
    }
  }
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});
     
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});
  
  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  Future<void> itemSelect() async {
    try {
      final response = await APIService.instance.request(
        '/items',
        DioMethod.get,
        contentType: Headers.jsonContentType,
      );
      if (response.statusCode == 200) {
        // allData = jsonDecode(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('successful: ${response.data}')),
        );
        for(var sec1 in response.data){
        //    ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('1: ${sec1["qty"]}')),
        // );
        qty.add(sec1["qty"]);
        id.add(sec1["id"]);
        imgLink.add(sec1["imgLink"]);
        description.add(sec1["description"]);
        status.add(sec1["status"]);
        name.add(sec1["name"]);
        price.add(sec1["price"]);
        }
        setState(() => isLoading = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.statusMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

  }
  @override
  void initState(){
    super.initState();
    itemSelect();
  }
  // Sample data for shop items

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if(isLoading){
       return Scaffold(
      body: SafeArea(
        child: Center(child: CircularProgressIndicator()),
      ),
      );
    }else{
      return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'All items',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.history),
          //   label: 'History',
          // ),
        ],
      ),
      body: <Widget>[
        // Home page with shop item cards
        GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: id.length,
          itemBuilder: (context, index) {
            int test1 = 0;
            return Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                   child: Image.network(
  imgLink[index],
  fit: BoxFit.cover,
  width: double.infinity,
  height: 600, // Increased height
),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name[index],
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Rs."+price[index].toString(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Quantity: " + qty[index].toString(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: ElevatedButton(onPressed: () async {

                          //itemSelect();
                         Localdata l1 = new Localdata();
                         try{
                           l1.openMyDatabase();
                           List<dynamic> test1 = [];
                           test1 = await l1.checkCart_withID(id[index]);
                           if(test1.isEmpty){
                             ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text('nothing'))
                             );
                             l1.insertData(name[index],description[index],qty[index],1,price[index],id[index],imgLink[index]);
                           }else{
                            //  int itemQuant = qty[index];
                            //  int cartQuant = 0;
                            int itemID = 0;
                            int cartItemQuant = 1;
                             for(var holder1 in test1){
                               cartItemQuant = holder1["cartItemQuant"];
                               itemID = holder1["itemID"];
                             }
                            //  itemQuant--;
                            //  cartQuant++;
                            int itemCount = qty[index];
                             ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text("FOUND: " + "ITEM ID: " + itemID.toString() + "COUNT: " + cartItemQuant.toString()))
                             );
                             if(itemCount<=0){
                             ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text("Out of stock"))
                             );
                             }else{
                              itemCount--;
                              cartItemQuant++;
                              l1.updateCartCount(itemID,cartItemQuant);
                              setState(() {
                               qty[index] = itemCount;
                             });
                             }
                           }
                         }catch(ee){
                           ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('ERROR OCCURED:' + ee.toString()))
                           );
                         }

                        //TEST SECTION START
                        //  try{
                        //   l1.maintainQuaries();
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //        SnackBar(content: Text('passed'))
                        //    );
                        //  }catch(e){
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //        SnackBar(content: Text('ERROR OCCURED2:' + e.toString()))
                        //    );
                        //  }
                         //TEST SECTION END
                         }, child: const Text('Add to cart')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        //FIXME: CART
        ScrollableCards(),
        // History page (placeholder)
        const Center(
          child: Text('History Page'),
        ),
      ][currentPageIndex],
    );
    }
  }
  // Future<void> getCartAll() async {
      
  // }
}