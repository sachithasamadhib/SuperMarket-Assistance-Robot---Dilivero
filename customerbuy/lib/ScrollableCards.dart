import 'package:customerbuy/localData.dart';
import 'package:customerbuy/returnCart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ScrollableCards extends StatefulWidget {
  const ScrollableCards({super.key});

  @override
  State<ScrollableCards> createState() => _ScrollableCardsState();
}
enum DioMethod { post, get, put, delete }
final String baseUrl = 'http://192.168.101.42:8000'; //the Main URL and changes it 
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
          response = await _dio.post(endpoint, data: formData);
          break;
        case DioMethod.get:
          response = await _dio.get(endpoint);
          break;
        case DioMethod.put:
          response = await _dio.put(endpoint, data: formData);
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
class _ScrollableCardsState extends State<ScrollableCards> {
  Localdata l1 = new Localdata();
  List<dynamic> allCartItems = [];
  List<dynamic> id = [];
  List<dynamic> name = [];
  List<dynamic> description = [];
  List<dynamic> qty = [];
  List<dynamic> cartItemQuant = [];
  List<dynamic> price = [];
  List<dynamic> itemID = [];
  List<dynamic> imgLink = [];
  List<dynamic> itemTotal = [];
  double netTot = 0;
   bool isLoading = true;
  Future<void> cartItems() async {
  List<dynamic> fetchedCartItems = await l1.cartItemSelector();
  debugPrint(fetchedCartItems.toString());

  // Clear previous data to avoid duplication
  id.clear();
  name.clear();
  description.clear();
  qty.clear();
  cartItemQuant.clear();
  price.clear();
  itemID.clear();
  imgLink.clear();
  itemTotal.clear();
  allCartItems.clear();
  
  for (var tempHolder in fetchedCartItems) {
    id.add(tempHolder["id"]);
    name.add(tempHolder["name"]);
    description.add(tempHolder["description"]);
    qty.add(tempHolder["qty"]);
    cartItemQuant.add(tempHolder["cartItemQuant"]);
    price.add(tempHolder["price"]);
    itemID.add(tempHolder["itemID"]);
    imgLink.add(tempHolder["imgLink"]);
    //netTot += tempHolder["price"];
    double tot2 = tempHolder["cartItemQuant"] * tempHolder["price"];
    itemTotal.add(tot2);
    // netTot += tot2;
    print(itemTotal);
  }

  // Update the UI
  setState(() => isLoading = false);
  debugPrint(id.toString());
}

  @override
  void initState(){
    super.initState();
    cartItems();
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading){
       return Scaffold(
      body: SafeArea(
        child: Center(child: CircularProgressIndicator()),
      ),
      );
    }else{
      for(int i = 0;i<itemTotal.length;i++){
        // print(netTot.toString() + "=" + itemTotal[i].toString()); 
        netTot = netTot + itemTotal[i];
        // print(netTot.toString() + "=" + itemTotal[i].toString()); 
      }
       return Scaffold(
      appBar: AppBar(
        title: Text('Net total: ' + netTot.toString()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: id.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name[index],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      description[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Quantity: '+cartItemQuant[index].toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Total: '+itemTotal[index].toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        for(int i = 0;i<id.length;i++){
          double tot = 0;
          if(cartItemQuant[i]>=1){
            int quant = cartItemQuant[i];
            tot = price[i] * quant;
            if(qty[i]>0){
            //       int? qt2 = qty[i];
            // qt2 = (qt2! - cartItemQuant[i]) as int?;
            qty[i] = qty[i] - cartItemQuant[i];
              final response2 = await APIService.instance.request(
        '/itemQtUpdate/${itemID[i]}',
        DioMethod.put,
        contentType: Headers.jsonContentType,
        formData: {
         "qty": qty[i]
        }
      );
      if(response2.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('updated')),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response2.statusMessage}')),
        );
      }
      //            final response3 = await APIService.instance.request(
      //   '/itemsByID/${itemID[i]}',
      //   DioMethod.get,
      //   contentType: Headers.jsonContentType,
      // );
      // for(var holderTemp in response3.data){
      //   itemID[i] = holderTemp["qty"];
      // }
            }
            else{

            }
            ///itemQtUpdate/1
          }else{
            tot = price[i];
          }
          final response = await APIService.instance.request(
        '/AddOrder',
        DioMethod.post,
        contentType: Headers.jsonContentType,
        formData: {
        "order_items": name[i],
        "qty": cartItemQuant[i],
        "price": tot,
        "status": "Pending",
        "user_id": 1001
        }
      );
      if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed')),
        );
        try{
          l1.removeCartItem(itemID[i]);
        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ERROR: ' + e.toString())),
        );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.statusMessage}')),
        );
      }
        }
        
         setState(() {
           id.clear();
  name.clear();
  description.clear();
  qty.clear();
  cartItemQuant.clear();
  price.clear();
  itemID.clear();
  imgLink.clear();
  itemTotal.clear();
  allCartItems.clear();
   Navigator.push(context,MaterialPageRoute(
                //builder: (context)=>HomeScreen(),
                builder: (context)=>Returncart(),
                 ));
        
         });
        },
        child: const Icon(Icons.shopping_cart_checkout_rounded),
      ),
    );
    }
  }
}