// ActionScript file
package
{
  [Bindable]
  public class Deal
  {
    public function Deal(name:String, someVal:int, note:String)
    {
      this.name = name;
      this.someVal = someVal;
      this.note = note;
    }

    public var name:String;
    public var someVal:int;
    public var note:String;
  }
}
