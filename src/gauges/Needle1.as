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
  import flash.filters.BevelFilter;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  import ilog.gauges.gaugesClasses.circular.CircularValueRenderer;

  import mx.charts.chartClasses.GraphicsUtilities;
  import mx.graphics.GradientEntry;
  import mx.graphics.LinearGradient;
  import mx.utils.ColorUtil;

  public class Needle1 extends CircularValueRenderer
  {

    public function Needle1()
    {
      super();
      //filters = [new BevelFilter(1, 45, 0xFFFFFF, 1, 0, 1, 2, 2, 1, 16)];
    }

    private function gradRect(ox:Number, oy:Number, r:Number):Rectangle
    {
      return new Rectangle(ox - r, oy - r, 2 * r, 2 * r);
    }

    private function polarX(ox:Number, a:Number, r:Number):Number
    {
      return ox + Math.cos(a) * r;
    }

    private function polarY(oy:Number, a:Number, r:Number):Number
    {
      return oy - Math.sin(a) * r;
    }

    private function moveTo(g:Graphics, ox:Number, oy:Number, angle:Number, radius:Number):void
    {
      var mx:Number = ox + Math.cos(angle) * radius;
      var my:Number = oy - Math.sin(angle) * radius;
      g.moveTo(mx, my);
    }

    private function lineTo(g:Graphics, ox:Number, oy:Number, angle:Number, radius:Number):void
    {
      var mx:Number = ox + Math.cos(angle) * radius;
      var my:Number = oy - Math.sin(angle) * radius;
      g.lineTo(mx, my);
    }

    private var d:Number = 0.45;
    private var rr:Number = 0.15;
    private var ff:Number = 0.03;
    private var pi:Number = Math.PI;

    public static function drawArc(g:Graphics, x:Number, y:Number, startAngle:Number, arc:Number, radius:Number, yRadius:Number = NaN, continueFlag:Boolean = false):Point
    {

      if (isNaN(yRadius))
        yRadius = radius;

      var segAngle:Number
      var theta:Number
      var angle:Number
      var angleMid:Number
      var segs:Number
      var ax:Number
      var ay:Number
      var bx:Number
      var by:Number
      var cx:Number
      var cy:Number;

      if (Math.abs(arc) > 2 * Math.PI)
        arc = 2 * Math.PI;

      segs = Math.ceil(Math.abs(arc) / (Math.PI / 4));
      segAngle = arc / segs;
      theta = -segAngle;
      angle = -startAngle;

      if (segs > 0)
      {
        ax = x + Math.cos(startAngle) * radius;
        ay = y + Math.sin(-startAngle) * yRadius;

        if (continueFlag == true)
          g.lineTo(ax, ay);
        else
          g.moveTo(ax, ay);

        for (var i:uint = 0; i < segs; i++)
        {
          angle += theta;
          angleMid = angle - theta / 2;

          bx = x + Math.cos(angle) * radius;
          by = y + Math.sin(angle) * yRadius;
          cx = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
          cy = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));

          g.curveTo(cx, cy, bx, by);
        }
      }
      return new Point(bx, by);
    }

    private function drawNeedle(g:Graphics, o:Point, r:Number, a:Number, rb:Number = -1):void
    {
      var ra:Number;
      if (rb == -1)
        ra = r * rr;
      else
        ra = rb * rr - ff * (rb - r);
      moveTo(g, o.x, o.y, a - d + pi, ra);
      GraphicsUtilities.drawArc(g, o.x, o.y, a - d + pi, 2 * d, ra);
      lineTo(g, o.x, o.y, a - 3 * pi / 4, r * ff);
      lineTo(g, o.x, o.y, a - pi / 2, r * ff);
      lineTo(g, o.x, o.y, a, r);
      lineTo(g, o.x, o.y, a - pi / 2, -1.5 * r * ff);
      lineTo(g, o.x, o.y, a - pi / 4, -1.5 * r * ff);
      lineTo(g, o.x, o.y, a - d, -r * rr);
    }

    private function qdrawNeedle(g:Graphics, o:Point, r:Number, a:Number, rb:Number = -1):void
    {
      var ra:Number;
      if (rb == -1)
        ra = r * rr;
      else
        ra = rb * rr - ff * (rb - r);
      moveTo(g, o.x, o.y, a - d + pi, ra);
      GraphicsUtilities.drawArc(g, o.x, o.y, a - d + pi, 2 * d, ra);
      lineTo(g, o.x, o.y, a - pi / 2, r * ff);
      lineTo(g, o.x, o.y, a, r);
      lineTo(g, o.x, o.y, a - pi / 2, -r * ff);
      lineTo(g, o.x, o.y, a - d, -r * rr);
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      if (!scale)
        return;

      var g:Graphics = graphics;
      var o:Point = getOrigin();
      var r:Number = getRadius();
      var a:Number;
      if (isNaN(transitionAngle))
        a = scale.angleForValue(value);
      else
        a = transitionAngle;


      var outerColor:uint = getStyle("outerColor");
      var innerColor:uint = getStyle("innerColor");
      var angle:Number = getStyle("lightAngle");
      outerColor = 0xFF2211;
      g.clear();
      var m:Matrix = new Matrix();

      var gf1:LinearGradient = new LinearGradient();
      gf1.entries = [new GradientEntry(0xFF0000, 0, 1), new GradientEntry(0x0000FF, 1, 1)];
      gf1.begin(g, gradRect(o.x, o.y, r));
      g.beginFill(0xDD0000);
      drawNeedle(g, o, r, a);

      gf1.entries = [new GradientEntry(ColorUtil.adjustBrightness2(outerColor, 80), 0, 0.1), new GradientEntry(ColorUtil.adjustBrightness2(outerColor, 0))];
      m.createGradientBox(2 * r, 2 * r, a, o.x - r, o.y - r);
      g.lineGradientStyle(GradientType.LINEAR, [0x000000, 0x991122], [1, 1], [0, 255], m);
      g.moveTo(o.x, o.y);
      g.lineTo(polarX(o.x, a, r - 1), polarY(o.y, a, r - 1));
    }
  }
}
