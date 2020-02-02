import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_cow/utils/draw_svg.dart';

class Deneme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String rawSvg = '''<svg viewBox='0 0 120 60'>
  <path d='M59,52c-2,0,0,1,2,1l2-1h-4M67,50l2-4l-1,3c-3,2,0-1,0-2c-3,4-1,2-1,3M70,42c1-3,0-2,0-1v1M53,3l2,1c1,0,1-1-2-1M55,4h-1zM81,43c0,3-1,4-2,6l-1,1l-1,3l-6,5c-1,0,0-1,1-1c-3,1-2,2-6,3c-9,4-21-4-21-15c-1-5,2-11,8-13c5-3,11-2,14,1c-2-2-6-5-10-5c-5,0-9,3-11,7c-2,1-2,5-3,6c-2,10,2,15,9,20c1,1,0,1,0,1l-6-4l4,3c-3,0-5-5-6-5c3,7,15,12,21,9c-3,0-7,0-10-1c-1-1-3-2-2-2c8,3,16,2,23-4l4-3c-1,1,0,0,0,1c1-2-1-1,1-4l1,1c0-3,3-5,3-9c1-1,1,1,0,4c1-3,0-4,1-6c0,1,0,2,1,2c-1-2,0-4,1-6c-1,0-1,1-2-2c0-1,1-1,1-1l-2-3c1-1,1,1,2,1l-1-4c-1-3-1,0-2-2c-1-4,2-1,2-3l4,10l-2-7c0,1-1-5,1-1c-2-8-9-14-15-18c1,1,2,2,1,2c-3-2-2-2-3-3c-2-1-2,1-4,0c-4-2-5-2-9-3v1c-3-1-4,0-7,0c0-1,1-1,2-1c-3,0-3-1-6,0l3-1c-3,0-6,1-5,0c-4,2-11,4-15,8v-1c-2,2-8,6-8,9h-1c-1,2-1,4-2,5c-1,2-2,1-2,1l-4,13c1,1,0,6,0,11c-1,21,15,42,33,47c3,1,7,1,10,1l-8-2c-3-1-3-3-5-4v1c-3-1-2-2-5-3l1-1c-1,0-3-2-4-3h-1l-3-4c-1-1-6-7-3-6c-1,0-2,0-2-2l-2-5c0,1,1,1,2,1c-4-9-4,0-7-9h1c-1,0-1-1-1-2v-2c-3-3-1-12,0-18c0-2,2-4,3-7h-1c2-3,10-12,13-11c2-3,0,0-1-1c4-4,5-3,8-3c3-2-2,0-1-1c5-1,3-3,9-3c1,0-1,0-2,1c4-2,13-2,18,1c7,3,14,12,14,20h1c0,3,0,7-1,11zM42,54v2l3,4l-3-6M44,54l-1-2c0,2,1,3,2,4zM87,45v1c0,3-1,5-3,8c2-3,3-6,3-9M53,3c1-1,3-1,4-1h-4zM16,22c0,3-2,4,0,2c2-3,0-1,0-2M13,33l1-3c-1,1,0,2-1,3' fill='#D70751'/>
</svg>''';

    final String rawSvg2 = '''<svg viewBox="0 0 120 60" >  
  <text  x="60" y="40" text-anchor="middle" font-size="32" fill="white" font-family="RobotoMono" font-weight="bold">000000‎ 000000</text></svg>''';
    final String rawSvg3 =
        '''<svg viewBox='0 0 64 64'><text transform='matrix(1 0 0 1 15.0771 33.1074)' font-family='RobotoMono' font-size='32'>log</text><text transform='matrix(0.7 0 0 0.7 36.6807 37.9063)' font-family='RobotoMono' font-size='32'>2</text><text transform='matrix(1 0 0 1 41.7217 33.1074)' font-family='RobotoMono' font-size='32'>3</text></svg>''';

    final rawSvg4 =
        '''<svg width="64" height="64" xmlns="http://www.w3.org/2000/svg">
 <!-- Created with Method Draw - http://github.com/duopixel/Method-Draw/ -->
 <g>
  <title>background</title>
  <rect fill="none" id="canvas_background" height="66" width="66" y="-1" x="-1"/>
  <g display="none" overflow="visible" y="0" x="0" height="100%" width="100%" id="canvasGrid">
   <rect fill="url(#gridpattern)" stroke-width="0" y="0" x="0" height="100%" width="100%"/>
  </g>
 </g>
 <g>
  <title>Layer 1</title>
  <text xml:space="preserve" text-anchor="start" font-family="Helvetica, Arial, sans-serif" font-size="32" id="svg_1" y="23.74279" x="15.26053" stroke-width="0" stroke="#000" fill="#000000">55</text>
  <line stroke="#000" stroke-linecap="undefined" stroke-linejoin="undefined" id="svg_2" y2="29.73956" x2="63.13756" y1="29.73956" x1="1.32201" stroke-width="1.5" fill="none"/>
  <text xml:space="preserve" text-anchor="start" font-family="Helvetica, Arial, sans-serif" font-size="32" id="svg_3" y="60.31235" x="15.26053" stroke-width="0" stroke="#000" fill="#000000">55</text>
 </g>
</svg>''';
    final rawSvg5 = '''<svg width="64" height="64" ">

 <g>
  <title>background</title>
  <rect fill="none" id="canvas_background" height="66" width="66" y="-1" x="-1"/>
  <g display="none" overflow="visible" y="0" x="0" height="100" width="100" id="canvasGrid">
   <rect fill="url(#gridpattern)" stroke-width="0" y="0" x="0" height="100%" width="100"/>
  </g>
 </g>
 <g>
  <title>Layer 1</title>
  <text style="cursor: move;" xml:space="preserve" text-anchor="start" font-family="Helvetica, Arial, sans-serif" font-size="32" id="svg_4" y="43.10327" x="-1.29089" fill-opacity="null" stroke-opacity="null" stroke-width="0" stroke="#000" fill="#000000">log</text>
  <text xml:space="preserve" text-anchor="start" font-family="Helvetica, Arial, sans-serif" font-size="32" id="svg_5" y="41.43488" x="50.28478" fill-opacity="null" stroke-opacity="null" stroke-width="0" stroke="#000" fill="#000000">2</text>
  <text stroke="#000" transform="matrix(0.7274742126464844,0,0,0.717771053314209,10.436886012554169,17.321801602840424) " xml:space="preserve" text-anchor="start" font-family="Helvetica, Arial, sans-serif" font-size="32" id="svg_6" y="54.70348" x="38.31068" fill-opacity="null" stroke-opacity="null" stroke-width="0" fill="#000000">2</text>
 </g>
</svg>''';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 16,
              height: 50,
              color: Colors.green,
              child: Center(
                child: SvgPicture.string(
                  rawSvg3,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 50,
              color: Colors.green,
              child: Center(
                child: SvgPicture.string(
                  rawSvg3,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
            Container(
              width: 40,
              height: 50,
              color: Colors.green,
              child: Center(
                child: SvgPicture.string(
                  rawSvg3,
                  allowDrawingOutsideViewBox: true,
                  // fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              width: 80,
              height: 50,
              color: Colors.green,
              child: Center(
                child: SvgPicture.string(
                  rawSvg3,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
            Container(
              width: 160,
              height: 50,
              color: Colors.green,
              child: Center(
                child: SvgPicture.string(
                  rawSvg3,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
            Container(
              width: 250,
              height: 50,
              color: Colors.green,
              child: Center(
                child: SvgPicture.string(
                  rawSvg3,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
            Container(
              width: 128,
              height: 50,
              color: Colors.red,
              child: Center(
                child: SvgPicture.string(
                  rawSvg3,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
            Container(
              width: 128,
              height: 80,
              color: Colors.green,
              child: Center(
                child: SvgPicture.string(
                  rawSvg5,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
            Container(
              width: 128,
              height: 160,
              color: Colors.red,
              child: Center(
                child: SvgPicture.string(
                  rawSvg4,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//   final String rawSvg2 = '''<svg viewBox="0 0 64 64" >
//   <text  x="32" y="32" text-anchor="middle" font-size="40" fill="yellow" stroke="red" stroke-width="1" font-family="RobotoMono" font-weight="bold" >3+5=80</text>
// </svg>''';
