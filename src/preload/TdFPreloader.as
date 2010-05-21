///////////////////////////////////////////////////////////////////////////////
// Licensed Materials - Property of IBM
// 5724-Y31
// (c) Copyright IBM Corporation 2007, 2009. All Rights Reserved.
//
// Note to U.S. Government Users Restricted Rights:
// Use, duplication or disclosure restricted by GSA ADP Schedule
// Contract with IBM Corp.
///////////////////////////////////////////////////////////////////////////////
package preload
{
  import flash.display.DisplayObject;
  import flash.display.GradientType;
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.ProgressEvent;
  import flash.geom.Matrix;
  import flash.text.TextField;
  import flash.text.TextFormat;
  
  import mx.events.*;
  import mx.preloaders.DownloadProgressBar;

  public class TdFPreloader extends DownloadProgressBar
  {


    [Embed(source="TdFPreloader.png")]
    private var imgCls:Class;
    private var text:TextField;
    private var overlay:Sprite;


    private var img:DisplayObject;

    public function TdFPreloader()
    {
      super();

      img = new imgCls();
      text = new TextField();
      overlay = new Sprite();
      this.addChild(img);
      this.addChild(text);
      this.addChild(overlay);
    }

    private function glossyMask(g:Graphics, w:Number, h:Number):void
    {
      //g.clear();
      g.lineStyle(1, 0xFFFFFF);

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
      g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0.35, 0.3, 0.2], [0, 250, 255], gradientBoxMatrix);
      g.lineStyle(0, 0, 0);
      g.drawRect(2, 1, w - 3, 5);

      gradientBoxMatrix.createGradientBox(w - 2, 5, -Math.PI / 2, 2, h - 7);
      g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0.1, 0.1, 0.0], [0, 128, 255], gradientBoxMatrix);
      g.lineStyle(0, 0, 0);
      g.drawRect(2, h - 7, w - 2, 5);
    }

    override public function set preloader(preloader:Sprite):void
    {
      preloader.addEventListener(ProgressEvent.PROGRESS, SWFDownloadProgress);
      preloader.addEventListener(FlexEvent.INIT_COMPLETE, FlexInitComplete);
    }

    private function SWFDownloadProgress(event:ProgressEvent):void
    {

      if (stageWidth == 0)
        stageWidth = img.width;
      if (stageHeight == 0)
        stageHeight = img.height;

      img.x = (stageWidth - img.width) / 2;
      img.y = (stageHeight - img.height) / 2;

      text.text = "Loading..." + int(100 * event.bytesLoaded / event.bytesTotal).toString() + "%";
      text.setTextFormat(new TextFormat("Arial", 16, 0xCECECE));
      var g:Graphics = overlay.graphics;

      overlay.x = img.x + 110;
      overlay.y = img.y + 150;

      text.x = img.x + 110;
      text.y = img.y + 165;
      text.width = 200;
      g.clear();
      var w:Number = 240;

      g.beginFill(0xAAAAAA);
      g.drawRect(0, 0, w, 15);
      glossyMask(g, w, 15);
      g.beginFill(10754076);
      g.drawRect(0, 0, w * event.bytesLoaded / event.bytesTotal, 15);
      glossyMask(g, w * event.bytesLoaded / event.bytesTotal, 15);
      g.endFill();
    }

    private function FlexInitComplete(event:Event):void
    {

      dispatchEvent(new Event(Event.COMPLETE));
    }

  }

}
