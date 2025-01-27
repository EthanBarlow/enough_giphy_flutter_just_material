import 'package:enough_giphy_flutter_just_material/enough_giphy_flutter_just_material.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'enough_giphy_flutter_just_material',
      home: MyHomePage(title: 'enough_giphy_flutter_just_material Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _images = <GiphyGif>[];
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: _images.isEmpty
          ? const Center(child: Text('Please add a GIF'))
          : ListView.builder(
              itemBuilder: (context, index) => GiphyImageView(
                gif: _images[index],
                fit: BoxFit.contain,
              ),
              itemCount: _images.length,
              controller: _scrollController,
            ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: _selectGif,
        tooltip: 'Select Gif',
        child: const Icon(Icons.gif),
      ),
    );
  }

  /// Selects and display a gif, sticker or emoji from GIPHY
  void _selectGif() async {
    const giphyApiKey = 'giphy-api-key';
    if (giphyApiKey == 'giphy-api-key') {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Check your GIPHY API Key'),
          content: Text('You need to register an API key first.'),
        ),
      );
      return;
    }
    // let the user select the gif:
    final gif = await Giphy.getGif(
      context: context,
      apiKey: giphyApiKey, //  your API key
      type: GiphyType.gifs, // choose between gifs, stickers and emoji
      rating: GiphyRating.g, // general audience / all ages
      lang: GiphyLanguage.english, // 'en'
      keepState: true, // remember type and search query
      showPreview: true, // shows a preview before returning the GIF
    );
    // process the gif:
    if (gif != null) {
      _images.insert(0, gif);
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((duration) {
        _scrollController.animateTo(
          0,
          duration: const Duration(microseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }
}
