import 'package:flutter/material.dart';
import 'package:m_store/models/cart_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  double get calculateTotal {
    double total = 0;
    for (var item in cartData) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            // flex: 10,
            child: cartData.isEmpty
                ? const Center(
                    child: Text(
                      'Cart is empty',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    //
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Slidable(
                          key: ValueKey(cartData[index].id),
                          endActionPane: ActionPane(
                            extentRatio: 0.25,
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Delete"),
                                        content: const Text(
                                          "Are you sure you want to remove this item?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                cartData.removeAt(index);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Container(
                              height: 150,
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: double.infinity,
                                    child: Image.network(
                                      cartData[index].imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            cartData[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            " Price: ${NumberFormat.currency(locale: 'th', symbol: '').format(cartData[index].price)} baht",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (cartData[index]
                                                                  .quantity >
                                                              1) {
                                                            cartData[index]
                                                                .quantity--;
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 60,
                                                        height: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              cartData[index]
                                                                      .quantity <=
                                                                  1
                                                              ? Colors.blue
                                                                    .withValues(
                                                                      alpha:
                                                                          0.5,
                                                                    )
                                                              : Colors.blue,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                topLeft:
                                                                    Radius.circular(
                                                                      9,
                                                                    ),
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                      9,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 60,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          top: BorderSide(
                                                            color: Colors
                                                                .grey
                                                                .shade300,
                                                          ),
                                                          bottom: BorderSide(
                                                            color: Colors
                                                                .grey
                                                                .shade300,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "${cartData[index].quantity}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),

                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          cartData[index]
                                                              .quantity++;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 60,
                                                        height: double.infinity,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                topRight:
                                                                    Radius.circular(
                                                                      8,
                                                                    ),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withValues(alpha: 0.2),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: const Offset(0, -3),
          //   ),
          // ],
        ),
          //SafeArea() ไม่ให้ติดต่อกับขอบหน้าจอ เช่น gesture หรือ notch
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${NumberFormat.currency(locale: 'th', symbol: '').format(calculateTotal)} baht",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cartData.isEmpty
                        ? Colors.grey
                        : Colors.blue,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                  ),
                  onPressed: () {
                    if (cartData.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        '/checkout',
                        arguments: calculateTotal,
                      );
                    }
                  },
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
