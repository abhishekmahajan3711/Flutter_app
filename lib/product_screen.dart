import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];

  Future<void> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse('https://d17p315up9p1ok.cloudfront.net/api/get-products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Debugging: Print the response structure
      print("API Response: $data");

      if (data is List) {
        setState(() {
          products = data; // If response is a list
        });
      } else if (data is Map && data.containsKey('products')) {
        setState(() {
          products = data['products']; // If products are inside a map
        });
      } else {
        print("Unexpected API response structure.");
      }
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error fetching products: $e");
  }
}


  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(products[index]['name']),
                subtitle: Text("\$${products[index]['price']}"),
              ),
            ),
    );
  }
}