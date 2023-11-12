with Ada.Text_Io;
with Ada.Integer_Text_Io;
with Ada.Float_Text_Io;
with Ada.Strings.Unbounded;

use Ada;
use Ada.Strings;

package Bio is

   type Write_Action is access procedure;

   type Ostream_Mode is (Aggregate, Replace);

   type Ostream is record
      Separation : aliased Write_Action;
      Separation_Requested : Boolean;
      Mode : Ostream_Mode;
   end record;

   type Ostream_Access is access all Ostream;

   procedure New_Ostream(Stream : in out Ostream ; Separation : Write_Action);

   type Ostream_Command is (Newl);

   procedure Write(Ostream : Ostream_Access);

   procedure Write_Line(Ostream : Ostream_Access);

   procedure Before_Write_Value(Ostream : Ostream_Access);

   procedure Identity;
   procedure Put_New_Line_Default;
   procedure Put_Comma_Separator;

   function "&"(Ostream : Ostream_Access ; Command : Ostream_Command) return Ostream_Access;
   function "&"(Ostream : Ostream_Access ; Value : Character) return Ostream_Access;
   function "&"(Ostream : Ostream_Access ; Value : String) return Ostream_Access;
   function "&"(Ostream : Ostream_Access ; Value : Integer) return Ostream_Access;
   function "&"(Ostream : Ostream_Access ; Value : Float) return Ostream_Access;
   function "&"(Ostream : Ostream_Access ; Value : Boolean) return Ostream_Access;

   function Cout return Ostream_Access;
   function Cout_Newl return Ostream_Access;
   function Cout_Enum return Ostream_Access;
   function Cout_Format return Ostream_Access;

private

   Cout_Ostream : aliased Ostream := (null, False, Aggregate);
   Cout_Newl_Ostream : aliased Ostream := (null, False, Aggregate);
   Cout_Enum_Ostream : aliased Ostream := (null, False, Aggregate);
   Cout_Format_Ostream : aliased Ostream := (null, False, Replace);

   Cout_Format_Buffer : Unbounded.Unbounded_String := Unbounded.To_Unbounded_String("");
   Cout_Format_Index : Integer := -1;

   procedure Format_Output_Section;

end Bio;
