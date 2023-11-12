with Ada.Text_Io;
with Ada.Integer_Text_Io;
with Ada.Float_Text_Io;
with Ada.Strings.Unbounded;

use Ada;
use Ada.Strings;

package body Bio is

   procedure New_Ostream(Stream : in out Ostream ; Separation : Write_Action) is
   begin
      Stream.Separation := Separation;
      Stream.Separation_Requested := False;
   end;

   procedure Write(Ostream : Ostream_Access) is
   begin
      case (Ostream.all.Mode) is

         when Aggregate =>
            Ostream.all.Separation_Requested := False;

         when Replace =>
            declare
               Buffer : String := Unbounded.To_String(Cout_Format_Buffer);
            begin
               Text_Io.Put(Buffer(Cout_Format_Index..Buffer'Last));
            end;
            Cout_Format_Buffer := Unbounded.To_Unbounded_String("");
            Cout_Format_Index := -1;

      end case;
   end;

   procedure Write_Line(Ostream : Ostream_Access) is
   begin
      Write(Ostream);
      Text_Io.New_Line;
   end;

   procedure Before_Write_Value(Ostream : Ostream_Access) is
   begin
      if Ostream = null then
         return;
      end if;

      case (Ostream.all.Mode) is
         when Aggregate =>
            if (Ostream.all.Separation_Requested) then
               Ostream.Separation.all;
            else
               Ostream.all.Separation_Requested := True;
            end if;
         when Replace =>
            if (0 < Unbounded.Length(Cout_Format_Buffer)) then
               Format_Output_Section;
            end if;
      end case;
   end;

   procedure Format_Output_Section is
      Target : constant String := "{}";
      Start_Index : Integer := Cout_Format_Index;
      Index : Integer := -1;
      Found_At_Index : Integer := -1;
      Buffer : String := Unbounded.To_String(Cout_Format_Buffer);
   begin

      if (Buffer'Last < Start_Index) then
         return;
      end if;

      if (Start_Index < Buffer'First) then
         Start_Index := Buffer'First;
      end if;
      Index := Start_Index;

      while ((Index + Target'Length - 1 <= Buffer'Last) and (Found_At_Index < 0)) loop
         if (Buffer(Index..(Index + Target'Length - 1)) = Target) then
            Found_At_Index := Index;
         end if;
         Index := Index + 1;
      end loop;

      if (0 <= Found_At_Index) then
         Cout_Format_Index := Found_At_Index + Target'Length;
      end if;

      Text_Io.Put(Buffer(Start_Index..(Index - Target'Length)));
   end;

   procedure Identity is null;

   procedure Put_New_Line_Default is
   begin
      Text_Io.New_Line;
   end;

   procedure Put_Comma_Separator is
   begin
      Text_Io.Put_Line(", ");
   end;

   function "&"(Ostream : Ostream_Access ; Command : Ostream_Command) return Ostream_Access is
   begin
      case Command is
         when Newl => Text_Io.New_Line;
      end case;
      return Ostream;
   end;

   function "&"(Ostream : Ostream_Access ; Value : Character) return Ostream_Access is
   begin
      Before_Write_Value(Ostream);
      Text_Io.Put(Value);
      return Ostream;
   end;

   function "&"(Ostream : Ostream_Access ; Value : String) return Ostream_Access is
   begin

      if ((Ostream.Mode = Replace) and (Unbounded.Length(Cout_Format_Buffer) < 1)) then
         Cout_Format_Buffer := Unbounded.To_Unbounded_String(Value);
         Cout_Format_Index := 0;
      else
         Before_Write_Value(Ostream);
         Text_Io.Put(Value);
      end if;

      return Ostream;
   end;

   function "&"(Ostream : Ostream_Access ; Value : Integer) return Ostream_Access is
   begin
      Before_Write_Value(Ostream);
      Integer_Text_Io.Put(Value, Width => 0);
      return Ostream;
   end;

   function "&"(Ostream : Ostream_Access ; Value : Float) return Ostream_Access is
   begin
      Before_Write_Value(Ostream);
      Float_Text_IO.Put(Value);
      return Ostream;
   end;

   function "&"(Ostream : Ostream_Access ; Value : Boolean) return Ostream_Access is
      False_String : constant String := "False";
      True_String : constant String := "True";
   begin
      Before_Write_Value(Ostream);
      Text_Io.Put(if Value then True_String else False_String);
      return Ostream;
   end;

   function Cout return Ostream_Access is
   begin
      if (Cout_Ostream.Separation = null) then
         New_Ostream(Cout_Ostream, Separation => Identity'access);
      end if;

      return Cout_Ostream'access;
   end;

   function Cout_Newl return Ostream_Access is
   begin
      if (Cout_Newl_Ostream.Separation = null) then
         New_Ostream(Cout_Newl_Ostream, Separation => Put_New_Line_Default'access);
      end if;

      return Cout_Newl_Ostream'access;
   end;

   function Cout_Enum return Ostream_Access is
   begin
      if (Cout_Enum_Ostream.Separation = null) then
         New_Ostream(Cout_Enum_Ostream, Separation => Put_Comma_Separator'access);
      end if;

      return Cout_Enum_Ostream'access;
   end;

   function Cout_Format return Ostream_Access is
   begin
      if (Cout_Format_Ostream.Separation = null) then
         New_Ostream(Cout_Format_Ostream, Separation => Identity'access);
      end if;

      return Cout_Format_Ostream'access;
   end;

end Bio;
