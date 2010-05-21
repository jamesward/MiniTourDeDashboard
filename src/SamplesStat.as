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
  import flash.utils.getTimer;

  import mx.collections.ArrayCollection;
  import mx.formatters.NumberFormatter;

  public class SamplesStat
  {

    public function init():void
    {
      ranks.removeAll();
      lastHour = [];
      lastMinute = [];
      _totalHits = 0;
      sortingArray = [];
      countryCount = {};
      hitRefs = {};
    }

    [Bindable]
    public var ranks:ArrayCollection = new ArrayCollection();
    public var countryCount:Object = {};
    private var hitRefs:Object = {}
    private var lastMinute:Array = [];
    private var lastHour:Array = [];
    private var _totalHits:uint = 0;

    private var nf:NumberFormatter = new NumberFormatter();

    public function get totalHitsFormatted():String
    {
      return nf.format(_totalHits);
    }

    public function get totalHits():Number
    {
      return _totalHits;
    }

    public function get networkStatus():Boolean
    {
      if (lastMinute.length == 0)
        return false;
      return getTimer() - lastMinute[lastMinute.length - 1] < 20000;
    }

    public function get lastMinuteHits():uint
    {
      return lastHits(lastMinute, 60000);
    }

    public function get lastHourHits():uint
    {
      return lastHits(lastHour, 3600000);
    }


    public function lastHits(a:Array, time:uint):uint
    {
      if (a.length == 0)
        return 0;
      var t:uint = a[0];
      var ref:uint = getTimer();
      while (ref - t > time)
      {
        if (a.length == 0)
          return 0;
        else
          t = a.shift();
      }
      return a.length;
    }

    private var sortingArray:Array = [];

    public function addHitData(hdi:HitDataItem):void
    {

      if (hdi.title == "")
        return;
      var iso3:String = DashboardUtils.countryIso3(hdi.country);
      if (countryCount[iso3] != null)
        countryCount[iso3]++;
      else
        countryCount[iso3] = 1;
      countryCount[DashboardUtils.countryIso3(hdi.country)]
      _totalHits++;
      lastMinute.push(getTimer());
      lastHour.push(getTimer());
      var item:SampleRankItem = hitRefs[hdi.sampleId];
      if (item)
      {
        item.hitcount++;
        ranks.getItemIndex(item);


      }
      else
      {
        item = new SampleRankItem();
        item.sampleId = hdi.sampleId;
        item.hitcount = 1;

        hitRefs[hdi.sampleId] = item;
        ranks.addItem(item);
        sortingArray.push(item);
      }

      ranks.refresh();
      updateRanking();
    }

    private function updateRanking():void
    {

      sortingArray.sortOn("hitcount", Array.NUMERIC | Array.DESCENDING);
      var chc:int;
      var crk:int;
      for (var i:int = 0; i < sortingArray.length; i++)
      {
        if (sortingArray[i].hitcount == chc)
          sortingArray[i].rank = crk;
        else
        {
          sortingArray[i].rank = i + 1;
          crk = i + 1;
          chc = sortingArray[i].hitcount;
        }

      }
    }
  }
}
