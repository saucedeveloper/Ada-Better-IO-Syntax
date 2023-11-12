with Ada.Text_Io;
with Ada.Integer_Text_Io;
use Ada;

with Bio;
use Bio;

procedure Test is

   type Some_Enum is (Alpha, Beta, Gamma);

   Some_Letter : Some_Enum := Alpha;

   function "&"(Ostream : Bio.Ostream_Access ; Letter : Some_Enum) return Bio.Ostream_Access is
   begin
      Bio.Before_Write_Value(Ostream);
      Text_Io.Put(Letter'Image);
      Text_Io.Put(":");
      Integer_Text_Io.Put(Letter'Enum_Rep, Width => 0);
      return Ostream;
   end "&";

begin
   Text_Io.Put_Line(Some_Letter'Image);
   Bio.Write_Line(Bio.Cout_Newl & "-All of the channels" & "-...Was alogus stuff" & (-1337.69) & '$' & Some_Letter);
   Bio.Write_Line(Bio.Cout_Format & "Hello {}, welcome to district {} of the {} city." & "John Cena" & 69420 & Alpha);
end Test;
