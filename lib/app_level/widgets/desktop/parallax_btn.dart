import 'package:auto_size_text/auto_size_text.dart';
import 'package:experiments_with_web/app_level/assets/assets.dart';
import 'package:experiments_with_web/app_level/models/articles/articles.dart';
import 'package:experiments_with_web/app_level/services/hive/hive_operations.dart';
import 'package:experiments_with_web/app_level/services/linker_service.dart';
import 'package:experiments_with_web/app_level/styles/colors.dart';
import 'package:experiments_with_web/app_level/utilities/screen_size.dart';
import 'package:experiments_with_web/locator.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'image_loader.dart';

typedef OnFavClick = void Function();

class ParallaxButton extends StatefulWidget {
  const ParallaxButton({
    Key key,
    this.text,
    @required this.medium,
    @required this.website,
    @required this.youtubeLink,
    @required this.isFavorite,
    this.model,
  }) : super(key: key);

  final String medium;
  final String website;
  final String youtubeLink;
  final bool isFavorite;

  final String text;
  final ArticlesModel model;

  @override
  _ParallaxButtonState createState() => _ParallaxButtonState();
}

class _ParallaxButtonState extends State<ParallaxButton> {
  ShapeBorder get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      );

  double get _height => ScreenQueries.instance.height(context);
  double get _width => ScreenQueries.instance.width(context);

  double localX = 0;
  double localY = 0;
  bool defaultPosition = true;

  double percentageX;
  double percentageY;

  @override
  Widget build(BuildContext context) {
    //

    return SizedBox(
      width: (_width * 0.15).roundToDouble(),
      height: (_height * 0.41).roundToDouble(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          //
          final _maxHeight = constraints.maxHeight;
          final _maxWidth = constraints.maxWidth;

          percentageX = (localX / _maxWidth) * 100;
          percentageY = (localY / _maxHeight) * 100;

          final _rotateX =
              defaultPosition ? 0 : (0.3 * (percentageY / 50) + -0.3);

          final _rotateY =
              defaultPosition ? 0 : (-0.3 * (percentageX / 50) + 0.3);

          final _translateX =
              defaultPosition ? 0.0 : (15 * (percentageX / 50) + -15);

          final _translateY =
              defaultPosition ? 0.0 : (15 * (percentageY / 50) + -15);

          return GestureDetector(
            onPanStart: onPanStart,
            onPanUpdate: (details) =>
                onPanUpdate(details, _maxHeight, _maxWidth),
            onPanEnd: (details) => onPanEnd(details, _maxHeight, _maxWidth),
            onPanCancel: onPanCancel,
            onPanDown: onPanDown,
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotateX)
                ..rotateY(_rotateY),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Card(
                    color: AppColors.brandColor,
                    margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
                    elevation: 8,
                    shape: shape,
                    child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                        ..translate(_translateX, _translateY, 0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(32),
                              ),
                              child: ImageWidgetPlaceholder(
                                image: WebAssets.logo,
                                width: double.maxFinite,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.grey.shade200,
                              child: _Content(
                                isFavorite: widget.isFavorite,
                                medium: widget.medium,
                                model: widget.model,
                                text: widget.text,
                                website: widget.website,
                                youtubeLink: widget.youtubeLink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void onPanStart(DragStartDetails details) {}

  void onPanUpdate(DragUpdateDetails details, double height, double width) {
    setState(() {
      if (mounted) {
        defaultPosition = false;
      }
      final _localPos = details.localPosition;
      if (_localPos.dx > 0 && _localPos.dy < height) {
        localX = _localPos.dx;
        localY = _localPos.dy;
      }
    });
  }

  void onPanEnd(DragEndDetails details, double height, double width) {
    setState(() {
      localX = width / 2;
      localY = height / 2;
      defaultPosition = true;
    });
  }

  void onPanCancel() {
    setState(() => defaultPosition = true);
  }

  void onPanDown(DragDownDetails details) {
    setState(() => defaultPosition = false);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key key,
    this.text,
    @required this.medium,
    @required this.website,
    @required this.youtubeLink,
    @required this.isFavorite,
    this.model,
  }) : super(key: key);

  final String text;

  final String medium;
  final String website;
  final String youtubeLink;
  final bool isFavorite;

  final ArticlesModel model;

  static final _hiveService = locator<HiveOperationsService>();

  @override
  Widget build(BuildContext context) {
    //

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AutoSizeText(text, minFontSize: 16),
              const Spacer(),
              if (isFavorite)
                GestureDetector(
                  child: const Icon(Icons.favorite, color: Colors.orangeAccent),
                  onTap: () => _hiveService.deleteFromFavBox(model),
                )
              else
                GestureDetector(
                  child: const Icon(Icons.favorite_border),
                  onTap: () => _hiveService.addToFavBox(model),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LinkButton(
                iconData: FontAwesomeIcons.youtube,
                link: youtubeLink,
              ),
              _LinkButton(
                iconData: FontAwesomeIcons.chrome,
                link: website,
              ),
              _LinkButton(
                iconData: FontAwesomeIcons.medium,
                link: medium,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    Key key,
    @required this.link,
    @required this.iconData,
  }) : super(key: key);

  final String link;
  final IconData iconData;

  static final _linkService = locator<LinkerService>();

  @override
  Widget build(BuildContext context) {
    //

    return IconButton(
      iconSize: 18.0,
      padding: EdgeInsets.zero,
      icon: FaIcon(iconData),
      onPressed: () => _linkService.openLink(link),
    );
  }
}

// https://medium.com/flutter-community/flutter-mouse-hover-parallax-effect-116b85bb5a80
