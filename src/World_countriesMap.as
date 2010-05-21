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
  import flash.events.MouseEvent;
  import flash.filters.GlowFilter;

  import ilog.maps.Map;
  import ilog.maps.MapBase;
  import ilog.maps.MapEvent;

  import mx.controls.ToolTip;
  import mx.core.UIComponent;
  import mx.formatters.NumberFormatter;
  import mx.managers.ToolTipManager;

  public class World_countriesMap extends MapBase
  {

    public function World_countriesMap()
    {
      addEventListener(MapEvent.ITEM_ROLL_OVER, onOver);
      mapToolTip = ToolTip(ToolTipManager.createToolTip("", 0, 0, null));
      mapToolTip.visible = false;
      selectionColor = 0xFFFFFF;
    }

    public function set selectionColor(value:uint):void
    {
      selectionGlow = new GlowFilter(value, 0.8, 10, 10, 3);
    }


    private var selectionGlow:GlowFilter;

    private var mapToolTip:ToolTip;

    public override function createMap():Map
    {
      return new World_countries();
    }

    public override function getString(k:String):String
    {
      if (resourceManager != null)
        return resourceManager.getString("World_countries", k);
      return k;
    }


    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      graphics.clear();
    }

    private function onMove(e:MouseEvent):void
    {
      if (mapToolTip)
      {
        mapToolTip.move(e.stageX + 10, e.stageY);
      }
    }

    private function onOut(e:MapEvent):void
    {
      removeEventListener(MapEvent.ITEM_ROLL_OUT, onOut);
      removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
      e.mapFeature.filters = [];
      mapToolTip.visible = false;
    }

    private var nf:NumberFormatter = new NumberFormatter();

    private function onOver(e:MapEvent):void
    {
      if (stage == null)
        return;
      if (e.mapFeature)
      {
        addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        addEventListener(MapEvent.ITEM_ROLL_OUT, onOut);

        e.mapFeature.filters = [selectionGlow];
        var par:UIComponent = UIComponent(e.mapFeature.parent);
        par.swapChildren(e.mapFeature, par.getChildAt(par.numChildren - 1));
        var count:int = this.document.sampleStats.countryCount[e.mapFeature.key];
        mapToolTip.text = DashboardUtils.countryName3(e.mapFeature.key) + '\n' + nf.format(count) + ' hit(s)';
        mapToolTip.visible = true;
      }
    }
  }
}
