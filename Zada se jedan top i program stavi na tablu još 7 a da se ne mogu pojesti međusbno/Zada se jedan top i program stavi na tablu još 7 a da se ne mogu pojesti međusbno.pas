{Zada se jedan top i program stavi na tablu još 7 a da se ne mogu pojesti meðusbno}
uses crt;
var polje:string;
    slovo,polje_i:char;
    i,j,i1,j1,pi,pj,sumaj,sumai
    :integer;
    izlazgl,izlazspor:boolean;
    ploca:array [1..8,1..8] of integer;
begin
repeat
repeat
textcolor(white);
writeln('Unesite na kojem polju stoji prvi top. (Npr. g6)');
readln(polje);
slovo:=polje[1];
val(polje[2],pi);
until (slovo in ['a','b','c','d','e','f','g','h','A','B','C','D','E','F','G','H']) and (pi in [1..8]) and (length(polje)<3);
case lowercase(polje[1]) of            {until naredba iznad osigurava da se mora unijeti ispravno polje}
'a':begin polje[1]:='1'; pj:=1; end;   {ovaj}
'b':begin polje[1]:='2'; pj:=2; end;   {ovdje}
'c':begin polje[1]:='3'; pj:=3; end;   {case}
'd':begin polje[1]:='4'; pj:=4; end;   {jednostavno prevodi slova}
'e':begin polje[1]:='5'; pj:=5; end;   {koja oznacavaju, polja u brojeve}
'f':begin polje[1]:='6'; pj:=6; end;   {da bi}
'g':begin polje[1]:='7'; pj:=7; end;   {se moglo lakše rukovati poljima}
'h':begin polje[1]:='8'; pj:=8; end;
end;
for i1:=1 to 8 do                     {stavlja sve vrijednosti u matricu polje na 0}
    for j1:=1 to 8 do
        ploca[i1,j1]:=0;
ploca[pi,pj]:=1;                    {stavlja zadani top u matricu oznaèavajuæi njegovo mjesto sa 1}
i:=pi;
j:=pj;
pi:=1;
pj:=1;
izlazspor:=false;
izlazgl:=false;
while not izlazgl do                   {ova while petlja pretražuje po stupcima slobodno mjesto za topa}
begin
     izlazspor:=false;
     izlazgl:=false;
     sumai:=0;
     sumaj:=0;
     for pj:=1 to 8 do
         sumai:=sumai+ploca[pi,pj];
     i1:=pi;
     pj:=1;
     if sumai=0 then                     {ova while petlja pretražuje po redcima slobodno mjesto za topa}
     while not izlazspor do
     begin
          sumaj:=0;
          izlazspor:=false;
          delay(13);                     {malo se program pauzira (130 ms mislim) da bude ljepše}
          for pi:=1 to 8 do
              sumaj:=sumaj+ploca[pi,pj];
          j1:=pj;
          if sumaj=0 then
             begin
                  case i1 of                    {ovaj case jednostavno prevodi}
                        1:polje_i:='a';         {brojeve u slova da bi se osigurala}
                        2:polje_i:='b';         {toèna šahovska notacija kod ispisa}
                        3:polje_i:='c';         {na kojem su mjestu ostali topovi postavljeni}
                        4:polje_i:='d';
                        5:polje_i:='e';
                        6:polje_i:='f';
                        7:polje_i:='g';
                        8:polje_i:='h';
                  end;
                  writeln('Top je na: ',polje_i,j1);       {tu se ispisuje na kojem su mjestu ostali topovi}
                  ploca[i1,j1]:=1;                      {bilježi mjesto za postavljeni (ispisani) top u matricu}
             end;
          pj:=j1+1;                                     {osigurava prelazak u iduæi red}
          if sumaj=0 then izlazspor:=true;              {ako je došao do kraja reda izlazi iz petlje}
     end;
     pi:=i1+1;                                        {osigurava prelazak u iduæi stupac}
     if pi=9 then izlazgl:=true;                     {ako je došao do kraja stupca izlazi iz petlje}
end;
writeln('Prikaz rijesenja. X = top, - = prazno polje (Zeleno je Vas prvi top.)');
for i1:=1 to 8 do                                            {ova for petlja i sve do kraja}
    begin                                                    {je èisto za grafièki}
         for j1:=1 to 8 do                                   {prikaz riješenja}
         begin                                               {da se lijepo vidi}
             textcolor(yellow);                              {kako to toèno izgleda}
             if (ploca[i1,j1]<>0) and (i1=i) and (j1=j) then
                begin
                     textcolor(green);
                     write('X ');
                end;
             if (ploca[i1,j1]<>0) and (i1<>i) and (j1<>j) then
                write('X ');
             if ploca[i1,j1]=0 then
                write('- ');
         end;
         writeln;
    end;
textcolor(white);
writeln('Jos? DA/NE');
readln(polje);
until lowercase(polje)='ne';       {da vrati na poèetak, ako se hoæe još koji zadatak zadati}
end.
