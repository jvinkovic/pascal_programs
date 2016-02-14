{verzija 2.1}
{nisam pisao komentare jer mi se nije dalo, ako pretite kod znat æete o èemu se radi}
{UPOZORENJE! Može doæi do odstupanja od maksimalno jedne sekunde, sve ovisi o tome kakav procesor imate}
{ako je pak procesor jako loš odstupanja mogu biti i veæa}
{toènost sinkronizacije ovisi o brzini internet veze}
{za sve bugove, prijedloge i slièno javite na: joka.excrucio@yahoo.com }
{ako ima kakvih problema javite, naravno, uz detaljan opis i ako može screenshoot problema}
{program je najoptimalniji na rezoluciji 1366*768 - za sve ostale rezolucije æe biti uskoro}

uses crt,dos,graph;
const
DanStr:array [0..6] of string [15] = ('Nedjelja','Ponedjeljak','Utorak','Srijeda','Cetvrtak','Petak','Subota') ;
MjesecStr:array [1..12] of string [10] = ('Sijecanj','Veljaca','Ozujak','Travanj','Svibanj','Lipanj','Srpanj','Kolovoz','Rujan','Listopad','Studeni','Prosinac') ;
var gd,gm,srx,sry:smallint;
    s,m,h,sec,min,alh,alm,als,u,hs,zona,satint,i:integer;
    godina,mjesec,dan,Tdan,sati,minute,sekunde,stotinjke:word;
    vrijemegraf,pom1,pom2,alarmtekst:string[40];
    mjesecikratice:array [1..12] of string[3];
    izbor:char;
    trea:text;

Procedure atomski_sat_sinkronizacija;
var Cmd,net,datumset,vrijemeset,danstr,godinastr,mjesecstr,satstr,minutastr,sekundastr,odluka:string;
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
           readln(zona);
           clrscr;
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
           readln(trea);       {za XP još jedan: readln(trea); - ????}
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
     delay(6000);
     clrscr;
end;

Procedure ocitajvrijeme;
begin
     GetTime(sati,minute,sekunde,stotinjke);
     sekunde:=sekunde-1;
     if sekunde*6<90 then
     s:=90-6*sekunde
     else
         s:=360-(sekunde-15)*6;
     if minute*6<90 then
        m:=90-6*minute
     else
         m:=360-(minute-15)*6;
     if sati*15<90 then
        h:=90-(6*minute div 10+(sati-12)*30)
     else
         h:=360-(sati-12-3)*30-(minute div 10)*6;
     min:=minute mod 10;
     sec:=sekunde;
     if sati>12 then
        hs:=sati-12
     else
         if sati=0 then
            hs:=12
         else
             hs:=sati;

end;

Procedure resetiraj;
begin
     setfillstyle(solidfill,0);
     setcolor(0);
     PieSlice(srx,sry,0,360,250);
     SetFillStyle(0,3);
     setcolor(13);
     settextstyle(1,0,3);
     outtextxy(srx+1-textwidth('12') div 2,sry-250,'12');
     outtextxy(srx+5-textwidth('6')div 2,sry+250-textheight('6'),'6');
     outtextxy(srx-textwidth('3')+250,sry-textwidth('3')div 2,'3');
     outtextxy(srx+textwidth('9')-250,sry-textwidth('9')div 2,'9');
end;

procedure ucitajalarm;
begin
     repeat
           GetTime(sati,minute,sekunde,stotinjke);
           str(sati,alarmtekst);
           str(minute,pom1);
           str(sekunde,pom2);
           if sati<10 then
              alarmtekst:='0'+alarmtekst;
           if minute<10 then
              pom1:='0'+pom1;
           if sekunde<10 then
              pom2:='0'+pom2;
           writeln('Vrijeme je: ',alarmtekst,':',pom1,':',pom2);
           writeln('Zelis li alarm? d/n');
           readln(izbor);
           clrscr;
           writeln('Vrijeme je: ',alarmtekst,':',pom1,':',pom2);
     until (izbor='d') or (izbor='n');

     case izbor of
     'n':
         begin
              writeln('A dobro, nemoras.');
              setfillstyle(solidfill,0);
              bar(srx*3 div 2-5,sry-15,srx*3 div 2+300,sry+15);
              resetiraj;
         end;
     'd':
         begin
              writeln('unosi se: sati, minute, sekunde');
              repeat
                    write('sati => ');
                    read(alh);
              until alh<25;
              repeat
                    write('minute => ');
                    read(alm);
              until alm<60;
              repeat
                    write('sekunde => ');
                    read(als);
              until als<60;
              str(alh,alarmtekst);
              if alh<10 then
                 alarmtekst:='0'+alarmtekst;
              str(alm,pom1);
              if alm<10 then
                 pom1:='0'+pom1;
              str(als,pom2);
              if als<10 then
                 pom2:='0'+pom2;
              setfillstyle(solidfill,0);
              bar(srx*3 div 2-5,sry-15,srx*3 div 2+300,sry+15);
              alarmtekst:='Alarm u '+alarmtekst+':'+pom1+':'+pom2;
              clrscr;
              Writeln(alarmtekst);
              settextstyle(3,0,2);
              setcolor(14);
              outtextxy(srx*3 div 2,sry,alarmtekst);
              settextstyle(3,0,3);
              resetiraj;
         end;
     end;

     if alh=24 then alh:=0;
end;

Procedure datum;
begin
     setfillstyle(solidfill,0);
     bar(50,sry-10,300,sry+10);
     setfillstyle(emptyfill,0);
     GetDate (godina,mjesec,dan,Tdan);
     settextstyle(1,0,1);
     setcolor(15);
     outtextxy(10,sry,'Datum: ');
     str(dan,pom1);
     str(godina,pom2);
     vrijemegraf:=DanStr[Tdan]+', '+pom1+'. '+MjesecStr[mjesec]+', '+pom2+'.';
     outtextxy(10+textwidth('Datum: '),sry,vrijemegraf);
     settextstyle(3,0,3);
     setcolor(13);
end;

Procedure alarm;
begin
     GetTime(sati,minute,sekunde,stotinjke);
     if (sati=alh) and (minute=alm) and (sekunde=als) then
     begin
          clrscr;
          writeln('===>>>>ALARM!!!<<<<===');
          settextstyle(1,0,4);
          repeat
                setcolor(random(15));
                outtextxy(srx-textwidth('==>>ALARM<<==') div 2,sry-30,'==>>ALARM<<==');
                sound(523);
                Delay(100);
                sound(659);
                Delay(100);
          until keypressed;
          readln;
          ucitajalarm;
     end;
end;

Procedure sek;
begin
     s:=s-6;
     if s=0 then s:=360;
        setcolor(2);
     PieSlice(srx,sry,s,s-1,190);
     setcolor(0);
     PieSlice(srx,sry,s+6,s,190);
     if s=360 then
        begin
             setcolor(2);
             line(srx,sry,srx+190,sry);
        end;
end;

Procedure minut;
begin
     m:=m-6;
     if m=0 then
        m:=360;
     setcolor(7);
     PieSlice(srx,sry,m,m-1,150);
     setcolor(0);
     PieSlice(srx,sry,m+6,m,150);
     sec:=0;
     if m=360 then
        begin
             setcolor(8);
             line(srx,sry,srx+150,sry);
        end;
end;

Procedure sat;
begin
     h:=h-6;
     if h=0 then
        h:=360;
     setcolor(14);
     PieSlice(srx,sry,h,h-1,100);
     setcolor(0);
     PieSlice(srx,sry,h+6,h,100);
     min:=0;
     if h=360 then
        begin
             setcolor(9);
             line(srx,sry,srx+100,sry);
        end;
end;

Function VRIJEME(unos:word):string;
var pom:string;
begin
     Str(unos,pom);
     if unos<10 then
        VRIJEME:='0'+pom
     else
         VRIJEME:=pom;
end;

Procedure digitalni;
begin
     GetTime(sati,minute,sekunde,stotinjke);
     vrijemegraf:=VRIJEME(sati)+':'+VRIJEME(minute)+':'+VRIJEME(sekunde);
     setfillstyle(solidfill,0);
     bar(290,0,490,50);
     setcolor(11);
     OutTextXY(10,10,'Vrijeme je: ');
     OutTextXY(10+textwidth('Vrijeme je: '),10,vrijemegraf);
     setfillstyle(emptyfill,0);
end;

begin
     atomski_sat_sinkronizacija;
     detectgraph(gd,gm);
     initgraph(gd,gm,'');
     srx:=getmaxx div 2;
     sry:=getmaxy div 2;
     datum;
     als:=-1;
     alm:=-1;
     alh:=-1;
     s:=90;
     m:=90;
     h:=90;
     hs:=0;
     sec:=0;
     min:=0;
     circle(srx,sry,270);
     for u:=0 to 360 do
     begin
          if (u=0) or (u=90) or (u=270) or (u=180) then
             setlinestyle(0,0,3)
          else
          if (u mod 15 = 0) and not ((u=0) or (u=90) or (u=270) or (u=180)) then
             setlinestyle(1,0,3);
          PieSlice(srx,sry,u,360,270);
          u:=u+5;
          setlinestyle(0,0,1);
     end;
     outtextxy(10,10,'POGLEDAJ KONZOLU ZA NASTAVAK!');
     ucitajalarm;
     resetiraj;
     ocitajvrijeme;
     setcolor(0);
     outtextxy(10,10,'POGLEDAJ KONZOLU ZA NASTAVAK!');
     while 1=1 do
     begin
          delay(890);
          ocitajvrijeme;
          sek;
          sec:=sec+1;
          digitalni;
          if (s<>m) and (s<>h) and (s<>m+6) and (s<>m+12) and (s<>h+6)  and (s<>h+12) then
             begin
                  setcolor(7);
                  PieSlice(srx,sry,m,m-1,150);
                  setcolor(0);
                  PieSlice(srx,sry,m+6,m,150);
                  setcolor(14);
                  PieSlice(srx,sry,h,h-1,100);
                  setcolor(0);
                  PieSlice(srx,sry,h+6,h,100);
             end;
          if (m<>h) and (m<>h+6) and (m<>h+12) then
             begin
                  setcolor(14);
                  PieSlice(srx,sry,h,h-1,100);
                  setcolor(0);
                  PieSlice(srx,sry,h+6,h,100);
             end;
          alarm;
          if sec=60 then
             begin
                  minut;
                  min:=min+1;
             end;
          if min=10 then
             sat;
          if hs=12 then
             begin
                  datum;
                  hs:=0;
             end;
     end;
end.
