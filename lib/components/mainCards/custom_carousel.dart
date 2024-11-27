import 'package:flutter/cupertino.dart';

class CustomCarousel extends StatefulWidget {
  final String shopImageUrl;
  final String productImageUrl;
  const CustomCarousel({super.key, required this.shopImageUrl, required this.productImageUrl});

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: PageView.builder(
          controller: _pageController,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              color: CupertinoColors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.0),
                child: Image.network(
                  [widget.productImageUrl,widget.shopImageUrl ][index],
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.fill,
                  width: double.infinity,),
                  loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress == null) return child;
                    return Center(
                      child: Text('Loading...', style: TextStyle( color: CupertinoColors.black,),),);
                  },

                ),
              ),
            );
          },
        ),
      );

  }
}
