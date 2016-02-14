var i,n,koliko:integer;
var b:char;
var prosti_brojevi:text;
begin
assign(prosti_brojevi,'c:\documents and settings\all users\desktop\prosti_brojevi.txt');
rewrite(prosti_brojevi);
n:=1;
koliko:=0;
     repeat
          b:='D';
          for i:=3  to round(sqrt(n)) do
          if b='D' then
              if n mod i=0 then
              b:='N';
          if b='D' then
          begin
          writeln(prosti_brojevi,n);
          koliko:=koliko+1;
          end;
          n:=n+2;
     until n=2147483647;
writeln(prosti_brojevi,'---------------------------');
write(prosti_brojevi,'Ukupno do 2147483647 ima ');
write(prosti_brojevi,koliko);
writeln(prosti_brojevi,' prostih brojeva.');
close(prosti_brojevi);
end.
