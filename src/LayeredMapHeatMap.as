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
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.utils.getTimer;

  import ilog.heatmap.HeatMapBase;
  import ilog.heatmap.MapHeatMap;
  import ilog.maps.MapFeature;

  import mx.collections.ArrayCollection;
  import mx.containers.Canvas;
  import mx.controls.ProgressBar;
  import mx.controls.ProgressBarLabelPlacement;
  import mx.controls.ProgressBarMode;
  import mx.core.ScrollPolicy;
  import mx.events.CollectionEvent;
  import mx.graphics.SolidColor;

  public class LayeredMapHeatMap extends MapHeatMap
  {
    private var layer:Canvas;
    private var pb:ProgressBar;

    private var world:Rectangle = null;
    private var northamerica:Rectangle = new Rectangle(-172, 20, 122, 49);
    private var southamerica:Rectangle = new Rectangle(-119.7, -56.7, 86.7, 89.5);
    private var europe:Rectangle = new Rectangle(-14.2, 32.1, 56.7, 33);
    private var africa:Rectangle = new Rectangle(-20.1, -33.0, 102.5, 70);
    private var asia:Rectangle = new Rectangle(52.9, 6.2, 100, 50);
    private var australia:Rectangle = new Rectangle(108.6, -45.5, 73.6, 56.6);
    private var currentArea:Rectangle;

    public function LayeredMapHeatMap()
    {
      //addEventListener(MouseEvent.CLICK, onClick);

    }

    override public function set heatMap(value:HeatMapBase):void
    {
      super.heatMap = value;
      value.dataProvider = _hmDataProvider;
    }

    private function onClick(e:MouseEvent):void
    {
      var p:Point = map.drawingCanvas.globalToLocal(new Point(e.stageX, e.stageY));
      p = map.canvasToLatLong(p);
      var rend:HitDataItem = new HitDataItem();
      rend.lat = p.y;
      rend.lon = p.x;
      rend.city = Math.random().toString();
      addHitRenderer(rend);

    }

    private var _hmDataProvider:ArrayCollection = new ArrayCollection();
    private var _dataProvider:ArrayCollection;

    public function set dataProvider(value:ArrayCollection):void
    {
      _dataProvider = value;
      _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, function():void
        {
          redraw();
        });
      initLayer();
    }

    public function get dataProvider():ArrayCollection
    {
      return _dataProvider;
    }

    public function get livingRenderers():Array
    {
      var res:Array = [];
      for (var i:int = 0; i < layer.numChildren; i++)
      {
        res.push(layer.getChildAt(i));
      }
      return res;
    }

    override protected function createChildren():void
    {
      super.createChildren();
      if (layer == null)
        layer = new Canvas();
      if (!contains(layer))
        addChild(layer);
      if (!pb)
      {
        pb = new ProgressBar();
        pb.width = 200;
        pb.height = 20;
        pb.minimum = 0;
        pb.maximum = 100;
        pb.x = 3;
        pb.y = 17;
        pb.mode = ProgressBarMode.MANUAL;
        pb.visible = false;
        pb.labelPlacement = ProgressBarLabelPlacement.RIGHT;
        pb.alpha = 0.5;
      }
      if (!contains(pb))
        addChild(pb);

    }
    private var colors:Array = [0x93B056, 0xF2D349, 0xFF722F, 0xC40E03];

    private function updateColor(key:String):void
    {
      if (!_colorMapEnabled)
        return;
      var mf:MapFeature = map.getFeature(key);
      if (mf)
      {
        var idx:int;
        var count:Number = countryCount[key];
        if (isNaN(count))
          return;
        if (count <= 25)
          idx = 0;
        else if (count <= 50)
          idx = 1;
        else if (count <= 75)
          idx = 2;
        else
          idx = 3;

        mf.setStyle('fill', new SolidColor(colors[idx]));
      }
    }

    public function resetColors():void
    {
      for each (var key:String in map.featureNames)
        map.getFeature(key).setStyle('fill', new SolidColor(map.getStyle('fill').color));
    }

    public function resetCountryCount():void
    {
      countryCount = {};
      resetColors();
    }

    private var _colorMapEnabled:Boolean = false;

    public function set colorMapEnabled(value:Boolean):void
    {
      if (value == _colorMapEnabled)
        return;
      _colorMapEnabled = value;
      if (!value)
        resetColors();
      else
        updateAllColors();

    }

    private function updateAllColors():void
    {
      for each (var key:String in map.featureNames)
        updateColor(key);
    }

    private var countryCount:Object = {};

    public function addHitRenderer(hitDataItem:HitDataItem):void
    {
      if (hitDataItem.title == "")
        return;
      var iso3:String = DashboardUtils.countryIso3(hitDataItem.country);
      if (iso3)
      {
        if (countryCount[iso3] != null)
          countryCount[iso3] = countryCount[iso3] + 1;
        else
          countryCount[iso3] = 0;
        updateColor(iso3);
      }
      for each (var rd:HitRenderer in livingRenderers)
      {
        if (rd.hitDataItem.sameLocation(hitDataItem))
        {
          rd.blinkAgain();
          return;
        }
      }
      var hr:HitRenderer = new HitRenderer(hitDataItem);
      layer.addChild(hr);
      var pos:Point = map.latLongToCanvas(new Point(hitDataItem.lon, hitDataItem.lat));
      pos = map.drawingCanvas.localToGlobal(pos);
      pos = layer.globalToLocal(pos);
      hr.x = pos.x;
      hr.y = pos.y;
    }

    public function initLayer():void
    {
      layer.removeAllChildren();
      layer.setActualSize(width, height);
      layer.horizontalScrollPolicy = ScrollPolicy.OFF;
      layer.verticalScrollPolicy = ScrollPolicy.OFF;
      cursor = 0;
      _hmDataProvider.removeAll();
      redraw();
    }

    private var cursor:int = 0;

    private function redraw():void
    {
      if (_dataProvider.length > 0 && _dhmVisible)
      {
        addEventListener(Event.ENTER_FRAME, onFrame);
        pb.setProgress(0, 100);
      }
    }

    private var _dhmVisible:Boolean = true;

    public function set dhmVisible(value:Boolean):void
    {
      if (_dhmVisible == value)
        return;
      _dhmVisible = value;
      initLayer();
    }

    private function onFrame(e:Event = null):void
    {
      var time:uint = getTimer();
      if (_dataProvider.length - cursor < 10)
        pb.visible = false;
      else
        pb.visible = true;

      var item:MinimalHMData;
      var extent:Rectangle = map.layerExtent();
      while (cursor < _dataProvider.length && getTimer() - time < 1000)
      {
        item = MinimalHMData(_dataProvider.getItemAt(cursor));
        if (extent.contains(item.lon, item.lat))
          _hmDataProvider.addItem(_dataProvider.getItemAt(cursor));
        cursor++;
      }
      var v:Number = cursor / (_dataProvider.length);
      pb.setProgress(v * 100, 100);
      if (cursor == _dataProvider.length)
      {
        removeEventListener(Event.ENTER_FRAME, onFrame);
        pb.visible = false;
      }
    }

    override public function set width(value:Number):void
    {
      super.width = value;
      initLayer();
    }

    override public function set height(value:Number):void
    {
      super.height = value;
      initLayer();
    }

    override public function setActualSize(w:Number, h:Number):void
    {
      if (width == w && height == h)
        return;
      super.setActualSize(w, h);
      initLayer();
    }


    public function zoomMap(attr:String):void
    {
      var r:Rectangle = this[attr];
      map.fitToArea(r);

      currentArea = r;
      initLayer();
    }
  }
}
