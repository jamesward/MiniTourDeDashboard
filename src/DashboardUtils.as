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

  public class DashboardUtils
  {

    public static function formatDate(d:Date, local:Boolean = true, showDay:Boolean = false):String
    {
      var day:String = String(local ? d.date - 1 : d.dateUTC - 1);
      if (day != "0")
        day = day + ' day(s), ';
      else
        day = '';
      var h:String = String(local ? d.hours : d.hoursUTC);
      if (h.length == 1)
        h = '0' + h;
      var m:String = String(local ? d.minutes : d.minutesUTC);
      if (m.length == 1)
        m = '0' + m;
      var s:String = String(local ? d.seconds : d.secondsUTC);
      if (s.length == 1)
        s = '0' + s;
      return (showDay ? day : "") + h + ':' + m + ':' + s;
    }

    [Embed(source="../resources/ccodes.xml", mimeType = "application/octet-stream")]
    private static var CC:Class;

    private static var indexedByAlpha2:Object;
    private static var indexedByAlpha3:Object;

    private static var codes:XML = XML(new CC());


    private static function initIndexedByAlpha2():void
    {
      if (indexedByAlpha2 == null)
      {
        indexedByAlpha2 = {};
        indexedByAlpha3 = {};
        for each (var r:Object in codes.Row)
        {
          indexedByAlpha2[r.Data[3]] = {name: String(r.Data[0]), iso3: String(r.Data[2])};
          indexedByAlpha3[r.Data[2]] = {name: String(r.Data[0]), iso3: String(r.Data[3])};
        }
      }
    }

    public static function countryName2(code:String):String
    {
      initIndexedByAlpha2();
      return indexedByAlpha2[code].name;
    }

    public static function countryName3(code:String):String
    {
      initIndexedByAlpha2();
      if (indexedByAlpha3[code])
        return indexedByAlpha3[code].name;
      else
        return "...";
    }

    public static function countryIso3(code:String):String
    {
      initIndexedByAlpha2();
      return indexedByAlpha2[code].iso3;
    }
  }
}
