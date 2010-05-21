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
  import flash.geom.Point;
  import flash.geom.Rectangle;

  import ilog.gauges.gaugesClasses.circular.CircularGaugeElement;
  import ilog.utils.CSSUtil;
  import ilog.utils.MathUtil;

  import mx.graphics.GradientEntry;
  import mx.graphics.LinearGradient;
  import mx.graphics.RadialGradient;
  import mx.styles.CSSStyleDeclaration;
  import mx.utils.ColorUtil;


  [Style(name="innerColor", type = "uint", format = "Color", inherit = "false")]
  [Style(name="outerColor", type = "uint", format = "Color", inherit = "false")]
  [Style(name="lightAngle", type = "Number", format = "Length", inherit = "no")]

  public class NeedleCap1 extends CircularGaugeElement
  {

    /**
     * @private
     */
    private static var stylesInited:Boolean = initStyles();

    /**
     * @private
     */
    private static function initStyles():Boolean
    {
      var style:CSSStyleDeclaration = CSSUtil.createSelector("NeedleCap1");

      style.defaultFactory = function():void
      {
        this.outerColor = 0xBBBBBB;
        this.innerColor = 0x223344;
        this.lightAngle = 45;
      }
      return true;
    }

    private function gradRect(ox:Number, oy:Number, r:Number):Rectangle
    {
      return new Rectangle(ox - r, oy - r, 2 * r, 2 * r);
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      var g:Graphics = graphics;
      var o:Point = getOrigin();
      var r:Number = getRadius();
      var outerColor:uint = getStyle("outerColor");
      var innerColor:uint = getStyle("innerColor");
      var angle:Number = getStyle("lightAngle");
      var angleRad:Number = MathUtil.toRadians(angle);
      g.clear();

      var gf1:LinearGradient = new LinearGradient();
      gf1.angle = 360 - angle;
      gf1.entries = [new GradientEntry(ColorUtil.adjustBrightness2(outerColor, 70)), new GradientEntry(ColorUtil.adjustBrightness2(outerColor, -40))];

      var gf2:LinearGradient = new LinearGradient();
      gf2.angle = angle;
      gf2.entries = [new GradientEntry(ColorUtil.adjustBrightness2(outerColor, 70)), new GradientEntry(ColorUtil.adjustBrightness2(outerColor, -50))];

      var gf3:LinearGradient = new LinearGradient();
      gf3.angle = 3 * angle;
      gf3.entries = [new GradientEntry(ColorUtil.adjustBrightness2(outerColor, 60)), new GradientEntry(ColorUtil.adjustBrightness2(outerColor, -40))];
      gf3.begin(g, gradRect(o.x, o.y, r * 0.82));
      g.drawCircle(o.x, o.y, r * 0.82);

      gf1.begin(g, gradRect(o.x, o.y, r * 0.70));

      g.drawCircle(o.x, o.y, r * 0.70);

      var gf4:RadialGradient = new RadialGradient();
      gf4.angle = 3 * angle;
      gf4.entries = [new GradientEntry(innerColor, 0.7), new GradientEntry(ColorUtil.adjustBrightness2(innerColor, -10), 0.95), new GradientEntry(ColorUtil.adjustBrightness2(innerColor, -30), 1)];
    }
  }
}
