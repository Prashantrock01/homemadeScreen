import 'package:biz_infra/Screens/services/book_your_slot.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  int _quantity = 1;

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
        ),
      ),
      body: Column(
        children: [
          // Divider line
          Container(
            height: 1,
            color: Colors.white, // Divider color
          ),
          // Yellow Container with Zigzag Bottom Border and product details
          Stack(
            children: [
              CustomPaint(
                painter: ZigzagPainter(),
                child: Container(
                  height: 140, // Height for the outer CustomPaint container
                ),
              ),
              Positioned(
                top: 16, // Distance from top of the outer container
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fruit Facial by VLCC',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '₹ 849',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 30, // Adjusted width
                            height: 30, // Adjusted height
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  size: 13.0,
                                  color: Colors.black,
                                ), // Adjusted size
                                color: Colors.white,
                                onPressed: _decreaseQuantity,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            width: 30, // Adjusted width
                            height: 30, // Adjusted height
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 13.0,
                                  color: Colors.black,
                                ), // Adjusted size
                                color: Colors.white,
                                onPressed: _increaseQuantity,
                              ),
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
          // Placeholder for other UI elements
          Expanded(child: Container(color: Colors.white)),
          // Spacer to push the bottom content to the bottom
          const Spacer(),
          // Divider and Total Price
          const Divider(thickness: 1.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹ ${_quantity * 849}', // Display total price based on quantity
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  '₹ 849',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const BookYourSlot(),
                      transition: Transition.rightToLeft,
                      popGesture: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 58, 192, 63),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ZigzagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFF7C51E)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);

    double zigzagWidth = 13;
    double zigzagHeight = 11;
    bool isZig = true;

    // Draw the zigzag pattern at the bottom of the container
    for (double x = -6; x <= size.width; x += zigzagWidth) {
      if (isZig) {
        path.lineTo(x + zigzagWidth / 2, size.height - zigzagHeight);
      } else {
        path.lineTo(x + zigzagWidth / 2, size.height);
      }
      isZig = !isZig;
    }

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
