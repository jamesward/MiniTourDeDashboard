///////////////////////////////////////////////////////////////////////////////
// Licensed Materials - Property of IBM
// 5724-Y31
// (c) Copyright IBM Corporation 2007, 2009. All Rights Reserved.
//
// Note to U.S. Government Users Restricted Rights:
// Use, duplication or disclosure restricted by GSA ADP Schedule
// Contract with IBM Corp.
///////////////////////////////////////////////////////////////////////////////
package
{
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.TimerEvent;
  import flash.filters.GlowFilter;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.AntiAliasType;
  import flash.text.TextFormat;
  import flash.utils.Timer;

  import mx.controls.Image;
  import mx.core.UIComponent;
  import mx.core.UITextField;
  import mx.effects.AnimateProperty;
  import mx.effects.easing.Quadratic;
  import mx.events.TweenEvent;
  import mx.utils.ColorUtil;

  public class HitRenderer extends UIComponent
  {
    private var data:HitDataItem;
    private var fromRadius:Number = 6;
    private var toRadius:Number = 4;

    private function get layer():LayeredMapHeatMap
    {
      if (parent && parent.parent)
        return LayeredMapHeatMap(parent.parent);
      else
        return null;
    }

    public function get hitDataItem():HitDataItem
    {
      return data;
    }

    public function HitRenderer(data:HitDataItem = null)
    {
      super();
      this.data = data;
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);
      filters = [new GlowFilter(0xFFFFFF, 0.7, 10, 10, 4)];

      labelTimer.addEventListener(TimerEvent.TIMER, removeThis);

    }

    private function addedToStage(e:Event):void
    {
      tween.property = "radius";
      tween.target = this;
      tween.fromValue = fromRadius;
      tween.toValue = toRadius;
      tween.duration = 1000;
      tween.easingFunction = Quadratic.easeIn;
      tween.addEventListener(TweenEvent.TWEEN_UPDATE, onTweenUpdate);
      tween.addEventListener(TweenEvent.TWEEN_END, onTweenEnd);
      tween.play();
      flagImage.source = "flags/" + data.country.toLowerCase() + ".gif";
      flagImage.addEventListener(Event.COMPLETE, onImageComplete);
      flagImage.addEventListener(IOErrorEvent.IO_ERROR, onError);
    }

    public function blinkAgain():void
    {
      tween.end();
      tween.fromValue = fromRadius;
      tween.toValue = toRadius;
      tween.play();
      if (labelTimer.running)
        labelTimer.reset();
    }

    private function onError(e:IOErrorEvent):void
    {
      flagImage.setActualSize(0, 0);
    }

    private function onImageComplete(e:Event):void
    {
      if (flagImage)
        flagImage.setActualSize(flagImage.contentWidth, flagImage.contentHeight);
      if (flagImage && cityLabel)
        cityLabel.y = flagImage.width + 1;
    }

    private var cityLabel:UITextField = new UITextField();
    private var flagImage:Image = new Image();

    override protected function createChildren():void
    {
      if (cityLabel && !contains(cityLabel))
      {
        addChild(cityLabel);
        cityLabel.filters = [new GlowFilter(0x222222, .8, 3, 3, 3, 16, false, false)];
      }
      if (flagImage && !contains(flagImage))
      {
        addChild(flagImage);
        flagImage.visible = false;
      }

    }

    private var tween:AnimateProperty = new AnimateProperty();
    public var radius:Number = 1;

    private function onTweenEnd(e:TweenEvent):void
    {

      filters = [];
      radius = toRadius;
      onTweenUpdate();
      showLabel();
    }

    public function get bbox():Rectangle
    {
      var p:Point = new Point(flagImage.x, flagImage.y);
      p = localToGlobal(p);
      return new Rectangle(p.x, p.y, flagImage.width + cityLabel.measuredWidth, 14);
    }

    private function labelPosOK():Boolean
    {
      if (!layer)
        return true;
      var others:Array = layer.livingRenderers;

      var overlap:Rectangle;

      for each (var r:HitRenderer in others)
      {
        if (this != r)
        {
          overlap = bbox.intersection(r.bbox);
          if (overlap.x + overlap.y + overlap.width + overlap.height != 0)
            return false;
        }
      }
      return true;
    }

    private var labelTimer:Timer = new Timer(5000, 1);

    private function showLabel():void
    {
      if (data.city == null || data.city == "" || cityLabel == null)
        return;
      cityLabel.text = data.city + ", " + DashboardUtils.countryName2(data.country);
      cityLabel.x = 5 + flagImage.contentWidth;
      cityLabel.y = 0;

      var tf:TextFormat = new TextFormat("Verdana", 10, 0xFFFFFF, true);
      tf.kerning = true;
      cityLabel.antiAliasType = AntiAliasType.ADVANCED;
      cityLabel.setTextFormat(tf);
      cityLabel.width = cityLabel.measuredWidth + 2;
      cityLabel.height = cityLabel.measuredHeight;

      flagImage.y = 3;
      flagImage.x = 5;
      flagImage.visible = true;

      if (!labelPosOK())
      {
        flagImage.y -= 3;
        cityLabel.y -= 3;
      }

      if (!labelPosOK())
      {
        flagImage.y -= 13;
        cityLabel.y -= 13;
      }

      if (!labelPosOK())
      {
        flagImage.x -= 5;
        cityLabel.x -= 5;
        flagImage.y -= 3;
        cityLabel.y -= 3;
      }

      if (!labelPosOK())
      {
        flagImage.y += 20;
        cityLabel.y += 20;
      }
      if (!labelPosOK())
      {
        cityLabel.x = 5 + flagImage.contentWidth;
        cityLabel.y = 0;
        flagImage.y = 3;
        flagImage.x = 5;
      }

      labelTimer.start();
    }

    private function removeThis(e:Event):void
    {
      if (cityLabel)
      {
        removeChild(cityLabel);
        if (parent && parent.contains(this))
          parent.removeChild(this);
      }
      cityLabel = null;
    }

    private function onTweenUpdate(e:TweenEvent = null):void
    {
      graphics.clear();
      var col:uint = ColorUtil.adjustBrightness2(0xAA1212, (6 - radius) * 50);

      if (radius == toRadius)
      {
        graphics.lineStyle(2, 0x888888);
      }
      graphics.beginFill(col);
      graphics.drawCircle(0, 0, radius);
    }
  }
}
