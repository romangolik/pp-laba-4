with Ada.Text_IO;
use Ada.Text_IO;

procedure Task1 is
   size: Integer := 10000;
   SUM: Integer := 0;
   numThreads: Integer := 10;

   a : array (0 .. size - 1) of Integer;
   beginMas: array (0 .. numThreads - 1) of Integer;
   endMas: array (0 .. numThreads - 1) of Integer;

   function part_sum (left : Integer; Right : Integer) return Integer is
      sum : Integer := 0;
      i   : Integer;
   begin
      i := left;
      while i <= Right loop
         sum := sum + a (i);
         i := i + 1;
      end loop;
      return sum;
   end part_sum;

   procedure create_array is
   begin
      for i in a'Range loop
         a (i) := i;
      end loop;
   end create_array;

   task type my_task is
      entry start(left, RigHt : in Integer);
      entry finish(sum1 : out Integer);
   end my_task;
   task body my_task is
      left, RigHt : Integer;
      sum : Integer := 0;

   begin
      accept start(left, RigHt : in Integer) do
         my_task.left := left;
         my_task.right := Right;
      end start;
      sum := part_sum (left, right);
      accept finish (sum1 : out Integer) do
         sum1 := sum;
      end finish;
   end my_task;

   task1 : array(0 .. numThreads - 1) of my_task;

   sum00 : integer;
begin
   create_array;

   for i in beginMas'Range loop
      beginMas(i) := size / numThreads * i;
   end loop;

   for i in endMas'First .. endMas'Last - 1 loop
      endMas(i) := beginMas(i + 1) - 1;
   end loop;

   endMas(numThreads - 1) := size - 1;

   for j in task1'Range loop
      task1(j).start(beginMas(j), endMas(j));
   end loop;

   for j in task1'Range loop
      task1(j).finish(sum00);
      SUM := SUM + sum00;
   end loop;

   Put_Line(SUM'img & " ");
end Task1;
