program aaa;
uses crt;
var
znak:char;
kod,zm,petla,cheat,shiza:byte;
{
kod-do niej przypisywana jest wartosc znaku za pomoca funkcji ord
zm -   jesli przyjmuje wartosc 0 to informacja o tym ze kwadracik
       do zlapania zostal zjedzony jesli 0 to znaczy ze niezostal
       zjedzony
petla- jesli przyjmuje wartosc 1 petla bedzie sie wykonywac jesli 0 
       petla zostanie przerwana
cheat- jesli wartosc jej jest 1 wtedy pomijany zostaje warunek ukonczenia
       gry
shiza- jesli ma wartosc 1 to pozwala na narysowanie kwadracika do 
       zjedzenia
}
ik,ik2,x,y,l,n,x2,y2,x3,y3,r,speed:integer;
{
ik - zmienna wykozystywana do petli
ik2- zmienna wykozystywana do petli
x  - zapisywana jest do niej pierwsza spolzedna 1-szego elementu wezyka
y  - zapisywana jest do niej druga spolzedna 1-szego elementu wezyka
l  - zapisywany jest wynik
n  - wskazuje kierunek w ktorym ma sie poruszac wezyk
x2 - pierwsza wspolzedna ostatniego elementu wezyka
y2 - druga wspolzedna ostatniego elementu wezyka
x3 - pierwsza wspolzedna kwadratu do zjedzenia
y3 - druga wspolzedna kwadratu do zjedzenia
speed - decyduje o szybkosci gry
}
tab : array [1..200,1..2] of integer;
{
do tablicy dwuwymiarowej wpisywane sa wspolzedne elementow wezyka
}


{----------------GRAFA-----------------}
{procedura wyswietla tryb graficzny w rozdzielczosci 320x200 256 kolorow}
procedure graf;
begin
asm
mov ah, 00h
mov al, 13h
int 10h
end;{[1]}
end;
{----------------GRAFA-----------------}
{procedura wyswietla tryb tekstowy i pokazuje ile zawodnik zdobyl ponktow}
procedure tex;
begin
asm
mov ah, 00h
mov al, 03h
int 10h
end;{[1]}
writeln('twoj wynik to ',l);
writeln;
for ik:=1 to 150 do
begin
write('game over ');
end;

end;

{----------------lin-----------------}
{procedura rysuje zielone linie (krawedz monitora) ktorych niemoze przekroczyc wezyk}
procedure lin;
begin
asm
mov ah, 10h
mov al, 01h
mov bh, 02h
int 10h
end;{[1]}
end;

{-----------------------PIX--------------------}
{rysuje pierwszy element wezyka koloru czerwonego}
procedure pix;
begin

for ik:=1 to 10 do
begin
 for ik2:=1 to 10 do
 begin
 mem[$A000:((y shl 8) + (y shl 6)) + x]:=4;{[1]}
 y:=y+1;
 end;
x:=x+1;
y:=y-10;
end;
x:=x-10;
end;
{------------------------PIX2----------------------}
{rysuje ostatni element wezyka koloru czarnego}
procedure pix2;
begin

for ik:=1 to 10 do
begin
 for ik2:=1 to 10 do
 begin
 mem[$A000:((y2 shl 8) + (y2 shl 6)) + x2]:=0;{[1]}
 y2:=y2+1;
 end;
x2:=x2+1;
y2:=y2-10;
end;
x2:=x2-10;
end;
{------------------------PIX3----------------------}
{rysuje kwadracik do zjedzenia}
procedure pix3;
begin

if shiza=1 then
begin
 while x3=0 do
 begin
 x3:=random(31);
 end;

 while y3=0 do

 begin
 y3:=random(19);
 end;

 x3:=x3*10;
 y3:=y3*10;
end;

for ik:=1 to 10 do
begin
 for ik2:=1 to 10 do
 begin
 mem[$A000:((y3 shl 8) + (y3 shl 6)) + x3]:=5;{[1]}
 y3:=y3+1;
 end;
x3:=x3+1;
y3:=y3-10;
end;
x3:=x3-10;
end;
{--------------------------PROGRAM------------------------}
begin
clrscr;
writeln('Snake w wykonaniu Grzegorza Siwek');
writeln;
writeln('a w s d chodzenie q quit p pause');
writeln;
writeln('wybierz poziom od 1 do 10, domyslny 3 (wpisz liczbe w skali od 1 do 10)');
readln(speed);
if speed = 0 then speed:=3;
speed:=speed*100;
if speed = 1100 then
 begin
 writeln('cheat okno wpisz speed');
 readln(speed);
 cheat:=1;
 end;
{-------------wprowadzanie danych----------}
graf;
lin;
l:=4;
petla:=1;
x:=0;
y:=100;
pix;
tab[l,1]:=x;
tab[l,2]:=y;
x2:=tab[l,1];
y2:=tab[l,2];
x:=10;
y:=100;
pix;
tab[l-1,1]:=x;
tab[l-1,2]:=y;
x:=20;
y:=100;
pix;
tab[l-2,1]:=x;
tab[l-2,2]:=y;
x:=30;
y:=100;
n:=2;
shiza:=1;
{czekanie na zaladowanie trybu graficznego}
while not keypressed do
 begin
 end;

{glowna petla programu}
while petla=1 do
begin
{wczytywanie znaku z klawiatury}
if keypressed then
begin
znak:=readkey;
kod:=ord(znak);
case kod of

 97:begin
    if (n>2)xor(n<2) then n:=4;
    end;
 115:begin
     if n>1 then n:=3;
     end;
 100:begin
     if n<4 then n:=2;
     end;
 119:begin
     if (n>3) xor (n<3) then n:=1;
     end;
 113: begin
      petla:=2;
      end;
 112: begin
      while not keypressed do
       begin
       end;
      end;
end;
end;
{rysowanie kwadratow}
if zm=0 then
begin
x3:=0;
y3:=0;
pix3;
shiza:=0;
zm:=1;
end;
pix3;
pix;
tab[1,1]:=x;
tab[1,2]:=y;
pix2;

if (x3=x)and(y3=y) then
 begin
 zm:=0;
 l:=l+1;
 shiza:=1;
 end;

delay(speed);
ik:=2;
if cheat<1 then
begin
while ik <= l do
begin
{warunek ukonczenia gry}
 if ((x=tab[ik,1])and(y=tab[ik,2]))xor(x<0)xor(x>320)xor(y<0)xor(y>200)then
  begin
  tex;
  readln;
  petla:=2;
  ik:=l+1;
  end;
ik:=ik+1;
end;
end;
if n=1 then y:=y-10;
if n=2 then x:=x+10;
if n=3 then y:=y+10;
if n=4 then x:=x-10;

for ik:=l downto 1 do
 begin
 tab[ik,1]:=tab[ik-1,1];
 tab[ik,2]:=tab[ik-1,2];
 end;
x2:=tab[l,1];
y2:=tab[l,2];




end;
end.

{-----------------------------------
1 Tworzenie gier 2d i 3d w jezyku Turbo Pascal - Piotr Besta - wydawnictwo Helion
}