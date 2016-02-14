uses crt;
var a,c,t:real;
var b,i,treba,eksponent,r:integer;
var s,s1,prav,eksponent_bin,eksponent_bin_pom,p:string;
begin
repeat
s:='';
s1:='';
prav:='';
writeln;
writeln('Unesite neki broj.(Za zarez koristite tocku ii zarez.');
writeln('Najveci dozvoljen broj je 10e19-1)');
writeln('Za beskonacno upisite +besk ili -besk.');
readln(p);                {neki broj ili +besk ili -besk}

if pos(',',p)<>0 then                             {radi unosa broja pomoæu zareza}
begin                                             {da bi mogao raditi program kako treba,-}
i:=pos(',',p);                                    {-treba staviti umjesto zareza toèku za decimalni zarez}
delete(p,pos(',',p),1);
insert('.',p,i);
end;
i:=0;

if (p='+0') or (p='-0') or (p='+-0') or (p='-+0') or (p='') then
p:='0';
if (pos('.',p)=1) then p:='0'+p;                                            {ovaj odlomak je protiv raznih bugova u programu-}
r:=pos('.',p);                                                               {-npr ako se unese +0 ili -0 ili -+0 ili +-0 da shvati kao 0}
for i:=1 to r-1 do s:=s+'0';
if r>2 then
if copy(p,1,r-1)=s then
begin
delete(p,1,r-1);
p:='0'+p;
end;
s:='';
val(p,t);

if (p<>'-besk') and (p<>'+besk') and ((p<>'0') and (t=0)) then       {osiguranje od krivog unosa, ako nije broj ili +besk ili -besk}
writeln('KRIVO!!!');

if (p<>'-besk') and (p<>'+besk') and (p<>'0') and (t<>0) then  {ako je unos neki broj da ga poène pretvarati, inaèe ne, jer bi bio error ili krivo}
begin
a:=abs(t);       {uzimamo apsolutnu vrijednost da ju kasnije usporedimo s brojem da bi znali da li je pozitivan ili negativan - u 47. liniji koda}
b:=trunc(a);     {cijeli broj}
c:=a-b;         {ono iza zareza}

if t=a then prav:=prav+'0' else prav:=prav+'1';               {za + (0) ili - (1)}

while b<>0 do begin
if (b)mod(2)=1 then s:=s+'1' else s:=s+'0';            {dijelimo cijeli dio s 2 i zapisujemo ostatak koji nam redom daje-}
b:=trunc(b/2);                                         {-binarni zapis u obrnutom redoslijedu koji okreæemo u 41. liniji koda}
end;
for i:=length(s) downto 1 do
s1:=s1+s[i];
s:='';                                       {postaje prazan da bi ga mogli i poslije koristiti, ako zatreba}

for i:=1 to 28 do
begin
c:=c*2;                                      {pretvaramo decimalno dio u binarni}
if c<1 then                                  {množimo decimalno dio s 2 i kada prijeðe 1 zapišemo 1, a ako ne onda 0 - 61. i 64. linija koda}
s:=s+'0'                                     {i decimalni dio toga broja koji smo dobili dalje množimo s 2 i radimo isto}
else                                         {tako ide sve 28 puta}
begin
s:=s+'1';
c:=c-1;
end;
end;
s1:=s1+'.'+s;                                {spajamo s (cijeli dio) i s1 (decimalni dio) u jedan normalan binarni broj}
s:='';                                       {postaje prazan da bi ga mogli i poslije koristiti, ako zatreba}

if pos('.',s1)>0 then
begin
treba:=pos('.',s1);                          {moramo zapisati binarni broj-}
delete(s1,pos('.',s1),1);                    {-u eksponencijalnom obliku (pomaknuti decimalnu toèku}
insert('.',s1,2);                            {iza prvog broja koji mora biti razlièit od 0)}
eksponent:=treba-2;                           {raèunamo eksponent (razlika prijašnje i sadašnje pozicije decimalne toèke)}
eksponent:=eksponent+127;                     {prema IEEE standardu moramo mu dodati 127}
end;

if (pos('.',s1)>0) and (s1[1]='0') then
begin
for i:=length(s1) downto 1 do
s:=s+s1[i];                                 {moramo zapisati binarni broj-}
delete(s1,pos('.',s),1);                    {-u eksponencijalnom obliku (pomaknuti decimalnu toèku}
r:=pos('0',s);
insert('.',s,r-1);                          {iza prvog broja koji mora biti razlièit od 0)}
for i:=length(s) downto 1 do
s1:=s1+s[i];
eksponent:=0-r;                               {raèunamo eksponent (razlika prijašnje i sadašnje pozicije decimalne toèke)}
eksponent:=eksponent+127;                     {prema IEEE standardu moramo mu dodati 127}
end;

if pos('.',s1)=0 then
begin
treba:=pos('.',s1);                          {moramo zapisati binarni broj-}
delete(s1,pos('.',s1),1);                    {-u eksponencijalnom obliku (pomaknuti decimalnu toèku}
insert('.',s1,2);                            {iza prvog broja koji mora biti 1)}
end;
eksponent:=treba-2;                           {raèunamo eksponent (razlika prijašnje i sadašnje pozicije decimalne toèke)}
eksponent:=eksponent+127;                     {prema IEEE standardu moramo mu dodati 127}

eksponent_bin_pom:='';
eksponent_bin:='';
repeat
if (eksponent)mod(2)=1 then eksponent_bin_pom:=eksponent_bin_pom+'1' else eksponent_bin_pom:=eksponent_bin_pom+'0'; {ista stvar kao kod 50. linije koda,-}
eksponent:=trunc(eksponent/2);                                                                                     {-samo se ovdje radi o eksponentu}
until eksponent=0;
for i:=length(eksponent_bin_pom) downto 1 do
eksponent_bin:=eksponent_bin+eksponent_bin_pom[i];
eksponent_bin_pom:='';                                {postaje prazan da bi ga mogli i poslije koristiti, ako zatreba}

while length(eksponent_bin)<8 do
eksponent_bin:='0'+eksponent_bin;

prav:=prav+eksponent_bin+copy(s1,3,length(s1)-3);    {copy(s1,3,length(s1)-3) uzima samo onaj dio koji nam treba za zapis u IEEE754 standardu i tako dobivamo pravi zapis u IEEE754 standardu, ali je duži od 32 bita}
writeln('Binarni zapis po IEEE754 standardu(32-bit):  ',copy(prav,1,32));             {zato uzimamo samo prva 32 bita (jednostruka preciznost) i ispisujemo}
end;

if p='-besk' then
writeln('1111111110000000000000000000000');
if p='+besk' then
writeln('0111111110000000000000000000000');                         {ovaj odlomak kontrolira ako je unos +besk, -besk ili pak 0}
if p='0' then
writeln('0000000000000000000000000000000');
writeln;

writeln('KRAJ??? (Za potvrdu kraja rada unesite:"K_6?" bez navodnika)');
s:='';
readln(s);
writeln;
writeln('-----------------------------------------------------------------------');
until (s='K_6?');
writeln('Zbogom!');
delay(1006);
end.                                                       {kraj}

                                                                         {BY: Josip Vinkoviæ}
