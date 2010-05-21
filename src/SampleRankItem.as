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

  public class SampleRankItem
  {
    public var sampleId:String;
    public var rank:Number;

    public var hitcount:Number;
    public var country:String;

    public function toString():String
    {
      return sampleId;
    }

    public function get title():String
    {
      return ObjectsInfo.getSampleData(sampleId, "title");
    }

    public function get category():String
    {
      return ObjectsInfo.getSampleData(sampleId, "cat");
    }

    public function get fullSampleTitle():String
    {
      if (title == "" || category == "")
        return "";
      return category + ' > ' + title;
    }
  }
}
