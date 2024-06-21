import 'package:eshopee/provider/cart_provider.dart';
import 'package:eshopee/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);

    // Ensure productPrice is a double
    double productPrice;
    try {
      productPrice = double.parse(widget.productData['productPrice'].toString());
    } catch (e) {
      productPrice = 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Detail',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(
                  0xFF363330,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                favoriteProviderData.addProductToFavorite(
                  productName: widget.productData['productName'],
                  productId: widget.productData['productId'],
                  imageUrl: widget.productData['productImage'],
                  productPrice: productPrice,
                );

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    margin: const EdgeInsets.all(15),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey,
                    content: Text(widget.productData['productName'])));
              },
              icon: favoriteProviderData.getFavoriteItem
                      .containsKey(widget.productData["productId"])
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 260,
              height: 274,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 50,
                    child: Container(
                      width: 260,
                      height: 260,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: const Color(
                          0XFFD8DDFF,
                        ),
                        borderRadius: BorderRadius.circular(
                          130,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 0,
                    child: Container(
                      width: 216,
                      height: 274,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: const Color(
                            0xFF9CA8FF,
                          ),
                          borderRadius: BorderRadius.circular(
                            14,
                          )),
                      child: SizedBox(
                        height: 300,
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                widget.productData['productImage'].length,
                            itemBuilder: (context, index) {
                              // Ensure that productImage[index] is a valid URL
                              final imageUrl =
                                  widget.productData['productImage'][index];
                              return Image.network(
                                imageUrl ?? '', // Ensure it's not null and a valid URL
                                width: 198,
                                height: 225,
                                fit: BoxFit.cover,
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.productData['productName'],
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: const Color(
                      0xFF3C55EF,
                    ),
                  ),
                ),
                Text(
                  "\$${productPrice.toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: const Color(
                      0xFF3C55EF,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productData['category'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          widget.productData['rating'] == 0
              ? const Text('')
              : Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        widget.productData['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        "(${widget.productData['totalReviews']})",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                        ),
                      )
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Size:',
                  style: GoogleFonts.lato(
                    color: const Color(
                      0xFF343434,
                    ),
                    fontSize: 16,
                    letterSpacing: 1.6,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['productSize'] != null
                          ? widget.productData['productSize'].length
                          : 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF126881),
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  widget.productData['productSize'][index],
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.lato(
                    color: const Color(0xFF363330),
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  widget.productData['description'],
                ),
              ],
            ),
          )
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            cartProviderData.addProductToCart(
                productName: widget.productData['productName'],
                productPrice: productPrice.toInt(),
                categoryName: widget.productData['category'],
                imageUrl: widget.productData['productImage'],
                quantity: 1,
                instock: widget.productData['quantity'],
                productId: widget.productData['productId'],
                productSize: '',
                discount: widget.productData['discount'],
                description: widget.productData['description']);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                margin: const EdgeInsets.all(15),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey,
                content: Text(widget.productData['productName'])));
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF0C1D6C),
            ),
            child: Center(
              child: Text(
                'Add To Cart',
                style: GoogleFonts.lato(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
