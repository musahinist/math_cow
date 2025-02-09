import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVG extends StatelessWidget {
  // final String assetName = 'animations/debian.svg';

//   final String rawSvg =
//       '''<svg viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'>
//   <path d='M59,52c-2,0,0,1,2,1l2-1h-4M67,50l2-4l-1,3c-3,2,0-1,0-2c-3,4-1,2-1,3M70,42c1-3,0-2,0-1v1M53,3l2,1c1,0,1-1-2-1M55,4h-1zM81,43c0,3-1,4-2,6l-1,1l-1,3l-6,5c-1,0,0-1,1-1c-3,1-2,2-6,3c-9,4-21-4-21-15c-1-5,2-11,8-13c5-3,11-2,14,1c-2-2-6-5-10-5c-5,0-9,3-11,7c-2,1-2,5-3,6c-2,10,2,15,9,20c1,1,0,1,0,1l-6-4l4,3c-3,0-5-5-6-5c3,7,15,12,21,9c-3,0-7,0-10-1c-1-1-3-2-2-2c8,3,16,2,23-4l4-3c-1,1,0,0,0,1c1-2-1-1,1-4l1,1c0-3,3-5,3-9c1-1,1,1,0,4c1-3,0-4,1-6c0,1,0,2,1,2c-1-2,0-4,1-6c-1,0-1,1-2-2c0-1,1-1,1-1l-2-3c1-1,1,1,2,1l-1-4c-1-3-1,0-2-2c-1-4,2-1,2-3l4,10l-2-7c0,1-1-5,1-1c-2-8-9-14-15-18c1,1,2,2,1,2c-3-2-2-2-3-3c-2-1-2,1-4,0c-4-2-5-2-9-3v1c-3-1-4,0-7,0c0-1,1-1,2-1c-3,0-3-1-6,0l3-1c-3,0-6,1-5,0c-4,2-11,4-15,8v-1c-2,2-8,6-8,9h-1c-1,2-1,4-2,5c-1,2-2,1-2,1l-4,13c1,1,0,6,0,11c-1,21,15,42,33,47c3,1,7,1,10,1l-8-2c-3-1-3-3-5-4v1c-3-1-2-2-5-3l1-1c-1,0-3-2-4-3h-1l-3-4c-1-1-6-7-3-6c-1,0-2,0-2-2l-2-5c0,1,1,1,2,1c-4-9-4,0-7-9h1c-1,0-1-1-1-2v-2c-3-3-1-12,0-18c0-2,2-4,3-7h-1c2-3,10-12,13-11c2-3,0,0-1-1c4-4,5-3,8-3c3-2-2,0-1-1c5-1,3-3,9-3c1,0-1,0-2,1c4-2,13-2,18,1c7,3,14,12,14,20h1c0,3,0,7-1,11zM42,54v2l3,4l-3-6M44,54l-1-2c0,2,1,3,2,4zM87,45v1c0,3-1,5-3,8c2-3,3-6,3-9M53,3c1-1,3-1,4-1h-4zM16,22c0,3-2,4,0,2c2-3,0-1,0-2M13,33l1-3c-1,1,0,2-1,3' fill='#D70751'/>
// </svg>''';

  final String rawSvg;
  SVG(this.rawSvg);

  String formatSvg(String rawSvg) {
    // print(
    //     rawSvg.replaceAll(RegExp('''fill="#FFFFFF"'''), '''fill="#FF0000"'''));
    return rawSvg.replaceAll(
        RegExp("font-family='RobotoMono-Regular'"), "font-family='RobotoMono'");
  }

  displaySVG() async {
    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
//     svgRoot.scaleCanvasToViewBox(canvas, Size(500, 500));

// // Optional, but probably normally desireable: ensure the SVG isn't rendered
// // outside of the viewbox bounds
//     svgRoot.clipCanvasToViewBox(canvas);
//     svgRoot.draw(canvas);
    return CurvePainter(svgRoot);
//     svgRoot.scaleCanvasToViewBox(canvas);

// // Optional, but probably normally desireable: ensure the SVG isn't rendered
// // outside of the viewbox bounds
// svgRoot.clipCanvasToViewBox(canvas);
// svgRoot.draw(canvas, size);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: displaySVG(),
        builder: (context, snapshot) {
          return CustomPaint(
            //size: Size(200, 100),
            child: Center(),
            foregroundPainter: snapshot.data,

            // child: SvgPicture.asset(assetName,
            //     color: Colors.red, semanticsLabel: 'A red up arrow'),
          );
        });
  }
}

class CurvePainter extends CustomPainter {
  CurvePainter(this.svg);

  final DrawableRoot svg;
  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawLine(...);

    svg.scaleCanvasToViewBox(canvas, size);
    //svg.clipCanvasToViewBox(canvas);

    svg.draw(canvas, Rect.zero);
    // svg.children[1].draw(canvas,
    //     ColorFilter.mode(Colors.white, BlendMode.hardLight), Rect.largest);
    // ColorFilter.srgbToLinearGamma()
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(CurvePainter oldDelegate) => false;
}
