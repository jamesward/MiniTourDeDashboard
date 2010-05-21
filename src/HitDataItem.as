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
  import flash.events.EventDispatcher;
  import flash.utils.getTimer;

  public class HitDataItem extends EventDispatcher
  {

    public function HitDataItem()
    {
      playerTime = getTimer();
    }

    public var timestamp:Date;
    public var ip:String;
    [Bindable]
    public var city:String;
    [Bindable]
    public var country:String;
    public var sampleId:String;
    public var lon:Number;
    public var lat:Number;
    public var playerTime:uint;




    [Bindable]
    public function get flagSource():String
    {
      //return "http://www.translatorscafe.com/cafe/images/flags/" + country + ".gif";
      return "flags/" + country.toLowerCase() + ".gif";
    }

    public function set flagSource(value:String):void
    {
      // Avoid bindable warnings
    }

    public function get category():String
    {
      return ObjectsInfo.getSampleData(sampleId, "cat");
    }

    public function get title():String
    {
      return ObjectsInfo.getSampleData(sampleId, "title");
    }

    [Bindable]
    public function get fullSampleTitle():String
    {
      if (title == "" || category == "")
        return "";
      return category + ' > ' + title;
    }

    public function set fullSampleTitle(value:String):void
    {
      // Avoid bindable warnings
    }

    public function get localHour():String
    {
      return DashboardUtils.formatDate(timestamp);
    }

    public function sameLocation(h:HitDataItem):Boolean
    {
      return h.lat == lat && h.lon == lon && h.city == city;
    }

  }
}
