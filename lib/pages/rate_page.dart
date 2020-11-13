import 'package:flutter/material.dart';
import 'package:revit/ui/stack.dart' as stack;
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/server.dart';
import 'package:revit/ui/loader.dart';

class RatePage extends StatefulWidget {

  final String idToken;

  RatePage({
    @required this.idToken
  }) : assert(idToken != null);

  @override
  State createState() => new RatePageState();

}
class RatePageState extends State<RatePage> {

  List<StackResponse> stacks = [];
  List<List<ImageResponse>> images = [];

  Future<void> loadStack() async {
    final StackResponse stack = await fetchStack(widget.idToken);
    final ImageResponse image1 = await fetchImage(stack.images[0]);
    final ImageResponse image2 = await fetchImage(stack.images[1]);
    final List<ImageResponse> imagesList = [image1, image2];

    setState(() {
      stacks.add(stack);
      images.add(imagesList);
    });  
  }
  Future<void> rate(String stackId, String likedImageId) async {

    setState(() {
      stacks.removeAt(0);
      images.removeAt(0);
    });
    loadStack();

    await rateStack(widget.idToken, stackId, likedImageId);

    analyticsLogEvent("rated-stack");

  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    analyticsSetCurrentScreen("rate_page");

    // load Stack and already preload next Stack
    loadStack();
    loadStack();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: stacks.length != 0 ? Stack(
          children: [
            stack.Stack(
              stack: stacks[0], 
              onTap: (ImageResponse image) { rate(stacks[0].id, image.id); },
              images: images[0]
            )
          ],
        ) : loader(),
      )
    );
  }

}