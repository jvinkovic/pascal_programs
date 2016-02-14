Uses Dos,crt;
Procedure atomski_sat_sinkronizacija;
CONST
zone:array [1..25] of string [3] = ('-12','-11','-10','-9','-8','-7','-6','-5','-4','-3','-2','-1','0','12','11','10','9','8','7','6','5','4','3','2','1');
var Cmd,net,pom1,pom2,datumset,vrijemeset,danstr,godinastr,mjesecstr,satstr,minutastr,sekundastr,odluka:string;
    mjesecikratice:array [1..12] of string[3];
    trea:text;
    zona,i,u,satint:integer;
begin
     mjesecikratice[1]:='Jan';
     mjesecikratice[2]:='Feb';
     mjesecikratice[3]:='Mar';
     mjesecikratice[4]:='Apr';
     mjesecikratice[5]:='May';
     mjesecikratice[6]:='Jun';
     mjesecikratice[7]:='Jul';
     mjesecikratice[8]:='Aug';
     mjesecikratice[9]:='Sep';
     mjesecikratice[10]:='Oct';
     mjesecikratice[11]:='Nov';
     mjesecikratice[12]:='Dec';
     net:='';
     assign(trea,'c:\ulaz.txt');
     rewrite(trea);
     repeat
           writeln('Koja je vremenska zona?');
           writeln('npr. za GMT+3 upisati "3", a za GMT-2 upisati "-2" - bez navodnika');
           readln(pom1);
           clrscr;
           pom2:='n';
           for i:=1 to 25 do
               if pom1=zone[i] then
                  pom2:='d';
           if pom2='d' then
              val(pom1,zona)
           else
               zona:=15;
           if (zona<-12) or (zona>12) then
              begin
                   writeln('==>>Neispravan unos! Moze biti samo od -12 do 12!!<<==');
                   writeln;
              end;
     until (zona>-13) and (zona<13);
     write(trea,'open 70.84.194.243 1313');
     close(trea);
     Cmd:=GetEnv('COMSPEC');
     odluka:='dalje';
     assign(trea,'c:\trenutno.txt');
     rewrite(trea);
     close(trea);
     repeat
           Exec(Cmd,'/C ftp -n -i -v < c:\ulaz.txt >> c:\trenutno.txt');
           assign(trea,'c:\trenutno.txt');
           reset(trea);
           readln(trea);
           readln(trea,net);
           u:=0;
           for i:=1 to 12 do
               if pos(mjesecikratice[i],net)>0 then
                  u:=u+1;
           if u=0 then
              readln(trea,net);
           close(trea);
           Exec(Cmd,'/C cls');
           Exec(Cmd,'/C exit');
           if net<>'' then
              begin
                   delete(net,1,4);
                   mjesecstr:=copy(net,1,3);
                   delete(net,1,4);
                   danstr:=copy(net,1,2);
                   delete(net,1,3);
                   satstr:=copy(net,1,2);
                   delete(net,1,3);
                   minutastr:=copy(net,1,2);
                   delete(net,1,3);
                   sekundastr:=copy(net,1,2);
                   delete(net,1,3);
                   godinastr:=net;
                   for i:=1 to 12 do
                       if mjesecikratice[i]=mjesecstr then
                          str(i,mjesecstr);
                   if length(mjesecstr)<2 then
                      mjesecstr:='0'+mjesecstr;
                   val(satstr,satint);
                   if satint=0 then
                      satint:=24;
                   satint:=satint+zona;
                   if satint>23 then
                      satint:=satint-24;
                   str(satint,satstr);
                   datumset:='/C date '+danstr+'-'+mjesecstr+'-'+godinastr;
                   vrijemeset:='/C time '+satstr+','+minutastr+','+sekundastr;
                   Exec(Cmd,datumset);
                   Exec(Cmd,vrijemeset);
                   Exec(Cmd,'/C cls');
                   Exec(Cmd,'/C exit');
                   writeln('Vrijeme je uspjesno sinkronizirano sa atomskim satom!');
              end;
           if net='' then
               begin
                    writeln('Provjerite vezu s internetom!!');
                    repeat
                          writeln('Pokusati opet? d/n');
                          readln(odluka);
                          clrscr;
                    until (odluka='d') or (odluka='n');
                    if odluka='n' then
                       writeln('Sistem nije sinkroniziran sa atomskim satom!!!');
               end;
     until (odluka='dalje') or (odluka='n');
     Exec(Cmd,'/C del c:\trenutno.txt');
     Exec(Cmd,'/C del c:\ulaz.txt');
     Exec(Cmd,'/C exit');
     delay(4500);
     clrscr;
end;

begin
atomski_sat_sinkronizacija;
end.
