import 'package:experiments_with_web/app_level/assets/assets.dart';
import 'package:experiments_with_web/app_level/constants/constants.dart';
import 'package:experiments_with_web/app_level/extensions/textstyle_extension.dart';
import 'package:experiments_with_web/app_level/extensions/widget_extension.dart';
import 'package:experiments_with_web/app_level/widgets/desktop/parallax_btn.dart';
import 'package:experiments_with_web/app_level/widgets/desktop/sliver_scaffold.dart';
import 'package:experiments_with_web/locator.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'services/linker_service.dart';
import 'widgets/desktop/image_loader.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  static final _optionAndRoute = OptionAndRoutes.optionRoutes.entries;
  static final _linkAndRoute = OptionAndRoutes.linksRoutes;
  static final _linkService = locator<LinkerService>();

  @override
  Widget build(BuildContext context) {
    //
    final _nav = Navigator.of(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SimpleSliverScaffold(
        minHeight: 130.0,
        maxHeight: 130.0,
        children: [
          GridView.count(
            childAspectRatio: 0.8,
            shrinkWrap: true,
            crossAxisCount: 5,
            crossAxisSpacing: 32.0,
            mainAxisSpacing: 16.0,
            padding: const EdgeInsets.all(32.0),
            children: [
              for (MapEntry<String, String> _optionRoute
                  in _optionAndRoute) ...[
                ParallaxButton(
                  text: _optionRoute.key,
                  medium: _linkAndRoute['${_optionRoute.key}'].first,
                  website: _linkAndRoute['${_optionRoute.key}'][1],
                  youtubeLink: _linkAndRoute['${_optionRoute.key}'].last,
                ).clickable(() => _nav.pushNamed(_optionRoute.value)),
              ]
            ],
          ),
        ],
        menu: Container(
          color: Colors.black87,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Row(
            children: [
              ImageWidgetPlaceholder(image: WebAssets.logo),
              const Spacer(),
              Column(
                children: <Widget>[
                  Text(
                    ApplevelConstants.homeTitle,
                    style:
                        Theme.of(context).textTheme.headline5.c(Colors.white),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        color: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.youtube),
                        iconSize: 20.0,
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _linkService.openLink(BrandLinks.youtube),
                      ),
                      IconButton(
                        color: Colors.white,
                        iconSize: 20.0,
                        icon: FaIcon(FontAwesomeIcons.medium),
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _linkService.openLink(BrandLinks.medium),
                      ),
                      IconButton(
                        iconSize: 20.0,
                        color: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.chrome),
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _linkService.openLink(BrandLinks.website),
                      ),
                      IconButton(
                        iconSize: 20.0,
                        color: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.dev),
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _linkService.openLink(BrandLinks.devTo),
                      ),
                      IconButton(
                        iconSize: 20.0,
                        color: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.github),
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _linkService.openLink(BrandLinks.github),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
