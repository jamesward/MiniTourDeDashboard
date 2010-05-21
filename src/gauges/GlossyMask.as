///////////////////////////////////////////////////////////////////////////////
// Licensed Materials - Property of IBM
// 5724-Y31
// (c) Copyright IBM Corporation 2007, 2009. All Rights Reserved.
//
// Note to U.S. Government Users Restricted Rights:
// Use, duplication or disclosure restricted by GSA ADP Schedule
// Contract with IBM Corp.
///////////////////////////////////////////////////////////////////////////////
package gauges
{
  import flash.display.GradientType;
  import flash.display.Graphics;
  import flash.geom.Matrix;

  import mx.core.UIComponent;

  public class GlossyMask extends UIComponent
  {

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      var g:Graphics = graphics;
      var w:Number = unscaledWidth;
      var h:Number = unscaledHeight;

      g.clear();
      g.lineStyle(1, 0x222222);

      var gradientBoxMatrix:Matrix = new Matrix();

      gradientBoxMatrix.createGradientBox(10, h - 3, 0, 2, 0);
      g.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000], [0.15, 0.1, 0], [0, 128, 255], gradientBoxMatrix);
      g.lineStyle(0, 0, 0);
      g.drawRect(2, 1, 10, h - 2);

      gradientBoxMatrix.createGradientBox(10, h - 3, Math.PI, w - 12, 0);
      g.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000], [0.15, 0.1, 0], [0, 128, 255], gradientBoxMatrix);
      g.lineStyle(0, 0, 0);
      g.drawRect(w - 12, 1, 10, h - 2);

      gradientBoxMatrix.createGradientBox(w - 2, 5, Math.PI / 2, 2, 2);
      g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0.95, 0.3, 0.2], [0, 250, 255], gradientBoxMatrix);
      g.lineStyle(0, 0, 0);
      g.drawRect(2, 1, w - 3, 5);

      gradientBoxMatrix.createGradientBox(w - 2, 5, -Math.PI / 2, 2, h - 7);
      g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0.1, 0.1, 0.0], [0, 128, 255], gradientBoxMatrix);
      g.lineStyle(0, 0, 0);
      g.drawRect(2, h - 7, w - 2, 5);
    }
  }
}
