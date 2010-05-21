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
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  import mx.rpc.http.HTTPService;

  public class ObjectsInfo
  {
    private static var objectsURL:String;
    private static var service:HTTPService = new HTTPService();
    private static var cache:Object = {};

    public static function init(url:String):void
    {
      objectsURL = url;
      service.url = objectsURL;
      service.resultFormat = "object";
      service.addEventListener(ResultEvent.RESULT, onResult);
      service.addEventListener(FaultEvent.FAULT, onFault);
      service.send();
    }

    private static function processCategories(o:Object):void
    {
      if (o.hasOwnProperty("Object"))
      {
        var a:Array = o.Object.source as Array;
        if (a == null)
          cache[o.Object.id] = {title: o.Object.name, cat: o.name};
        else
          for each (var obj:Object in a)
            cache[obj.id] = {title: obj.name, cat: o.name};
      }
      if (o.hasOwnProperty("Category"))
      {
        if (o.Category.source == undefined)
          processCategories(o.Category);
        else
          for each (var cat:Object in o.Category.source)
            processCategories(cat);
      }
    }

    private static function onResult(e:ResultEvent):void
    {
      var root:Object = e.result.Objects;
      processCategories(root);
    }

    private static function onFault(e:FaultEvent):void
    {
      service.send();
    }

    public static function getSampleData(uid:String, prop:String):String
    {
      if (!cache[uid])
        return '';
      else
        return cache[uid][prop];
    }


  }
}
