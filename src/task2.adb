with Ada.Text_IO;
use Ada.Text_IO;

procedure Task2 is
   size: Integer := 10000;
   array_size: Integer := size;

   a : array (0 .. size - 1) of Integer;

   procedure create_array is
   begin
      for i in a'Range loop
         a (i) := i;
      end loop;
   end create_array;

   task type my_task is
      entry start(first_number, second_number : in Integer);
      entry finish(result : out Integer);
   end my_task;

   task body my_task is
      first_number, second_number : Integer;
      sum : Integer := 0;

   begin
      loop
         select
            accept start(first_number, second_number : in Integer) do
               my_task.first_number := first_number;
               my_task.second_number := second_number;
            end start;
         or
            terminate;
         end select;
         sum := first_number + second_number;
         select
            accept finish (result : out Integer) do
               result := sum;
            end finish;
         or
            terminate;
         end select;
      end loop;
   end my_task;

   task1: my_task;

   part_sum: integer;
begin
   create_array;

   loop
      for i in 0..array_size / 2 - 1 loop
         task1.start(a(i),a(array_size - i - 1));
         task1.finish(part_sum);

         a(i) := part_sum;
      end loop;

      array_size := array_size / 2 + array_size mod 2;

      if array_size <= 1 then
         exit;
      end if;
   end loop;

   Put_Line(a(0)'img & " ");
end Task2;
