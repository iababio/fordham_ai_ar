import 'dart:math'; // Import this package for generating random numbers
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_realtime_detection/pages/widgets/grid_tiles.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../services/chat_api.dart';
// import 'chat_page.dart';

class SliderImages extends StatefulWidget {
  const SliderImages({Key? key}) : super(key: key);

  final String title = 'RSS Feed Carousel';

  @override
  _NewFeedState createState() => _NewFeedState();
}

class _NewFeedState extends State<SliderImages> {
  final Xml2Json xml2json = Xml2Json();
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  late List TopStories = [];

  final client = http.Client();

  static const String FEED_URL = 'https://news.fordham.edu/feed';
  late RssFeed _feed = RssFeed(items: []);
  late String _title;
  static const String loadingFeedMsg = 'Loading Feed...';
  static const String feedLoadErrorMsg = 'Error Loading Feed.';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg =
      'https://news.fordham.edu/wp-content/uploads/2017/08/fordham-seal.jpg';
  late GlobalKey<RefreshIndicatorState> _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final response = await client.get(Uri.parse(FEED_URL));
      final feed = RssFeed.parse(response.body);
      return feed;
    } catch (e) {
      print('Error loading feed: $e');
      return null;
    }
  }

  load() async {
    updateTitle(loadingFeedMsg);
    final result = await loadFeed();
    if (result == null) {
      updateTitle(feedLoadErrorMsg);
    } else {
      updateFeed(result);
      updateTitle(_feed.title ?? widget.title);
    }
  }

  title(String? title) {
    return Text(
      title ?? 'No Title',
      style: const TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(String? subTitle) {
    return Text(
      subTitle ?? 'No Date',
      style: const TextStyle(
          fontSize: 11.0,
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 190, 190, 190)),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return SizedBox.shrink();
    } else if (imageUrl.startsWith('http')) {
      // Use CachedNetworkImage for network images
      return CachedNetworkImage(
        placeholder: (context, url) => Image.network(placeholderImg),
        imageUrl: imageUrl,
        height: 150,
        width: double.infinity,
        alignment: Alignment.center,
        fit: BoxFit.cover,
      );
    } else {
      // Use Image.asset for local asset images
      return Image.asset(
        imageUrl,
        height: 150,
        width: double.infinity,
        alignment: Alignment.center,
        fit: BoxFit.cover,
      );
    }
  }

  List<Widget> buildSliders() {
    final random =
    Random(); // Create a new Random object for generating numbers

    return _feed.items.map((item) {
      final randomNumber =
          random.nextInt(7) + 1; // Generates a new random number for each item
      final imageUrl = item.content?.images?.isNotEmpty == true
          ? item.content?.images?.first
          : "assets/images/backgrounds/$randomNumber.png"; // Local asset path for no network image
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: InkWell(
            onTap: () => openFeed(item.link ?? ''),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgrounds/$randomNumber.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox.shrink(),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title(item.title),
                          const SizedBox(height: 4.0),
                          subtitle(item.pubDate),
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
    }).toList();
  }

  isFeedEmpty() {
    return _feed.items.isEmpty;
  }

  body() {
    if (isFeedEmpty()) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.28
                  : MediaQuery.of(context).size.height *
                  0.5, // Adjust height based on orientation
              child: RefreshIndicator(
                key: _refreshKey,
                onRefresh: () => load(),
                child: FlutterCarousel(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    viewportFraction: 0.8,
                    height: MediaQuery.of(context).size.height * 0.29,
                    enableInfiniteScroll: true,
                    scrollDirection: Axis.horizontal,
                    floatingIndicator: false,
                    showIndicator: false,
                  ),
                  items: buildSliders(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: GridTilesPage()), // Wrap with Expanded
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: body(),
        ));
  }
}
