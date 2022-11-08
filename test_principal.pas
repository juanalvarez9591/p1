program TestTarea2;

var
   flag_if : boolean;
   
{$i definiciones.pas}

{$i tarea2.pas}

{ variables del programa principal }

var
   opcion : char;
   balin  : TBalin;
   pelota1, pelota2 : TPelota;
   zona : TZonaPelotas;
   indice : TIndicePelota;
   frontera, sec : TSecPelotas;
   choca : boolean;
   
{ procedimientos auxiliares del principal }

procedure escribirColor(color : Tcolor );
begin
   case color of
     Verde	 : write ('M');
     Rojo	 : write ('r');
     Azul	 : write ('b');
   end
end;

function charToColor(c : char) : TColor;
begin
   case c of
     'M' : charToColor:= verde;
     'r' : charToColor:= rojo;
     'b' : charToColor:= azul;
   else
      charToColor:= azul;
   end;
end;
    

procedure leerColor (var color :TColor);
var c : char;
begin
   read(c);
   color:= charToColor(c)
end;

procedure leerPosicion(var pos : TPosicion);
begin
   read(pos.x,pos.y)
end;

procedure leerVelocidad(var v : TVelocidad);
begin
   readln(v.vx,v.vy)
end;

procedure leerPelota(var p : TPelota);
begin
   leerPosicion(p.posicion); readln;
   leerColor(p.color); readln
end;

procedure leerSecPelotas(var sec : TSecPelotas);
var v : integer;
   
begin
   with sec do
   begin
      tope:= 0;
      read(v);
      while v <> -1 do
      begin
         tope:= tope + 1;
         sec[tope].i := v;
         readln(sec[tope].j);
         read(v)
      end;
      readln
   end
end;

procedure escribirSecPelotas(sec : TSecPelotas);
var k : integer;
begin
   writeln('====== comienzo secuencia =======');
   with sec do
   begin
      for k:= 1 to tope do
         writeln(' (',sec[k].i:2,',',sec[k].j:2,') ')
   end;
   writeln('============fin==================');
end;


procedure leerBalin(var balin : TBalin);
begin
   leerPelota(balin.pelota);
   leerVelocidad(balin.velocidad)
end;

procedure escribirBooleano(v : Boolean);
begin
   if v then write('TRUE')
        else write('FALSE')
end;

procedure escribirIndiceP(indice : TIndicePelota);
begin
   writeln('(',indice.i:0, ',',indice.j:0,')')
end;

procedure escribirBalin(balin : TBalin);
begin

   writeln('posicion : (',
           balin.pelota.posicion.x:0, ',',balin.pelota.posicion.y:0,')');
   writeln('velocidad : (',
           balin.velocidad.vx:0, ',', balin.velocidad.vy:0,')')
end;

{  inicioZP - arma la zona con 
   - todas las celdas ocupadas
   - todas en rojo
}
procedure inicioZP (var zona : TZonaPelotas);
var i  : RangoFilas;
    j  : RangoColumnas;
   posx, posy : integer;
begin
   posy := ALTO - RADIO;
   for i := 1 to CANT_FILAS do
   begin
      posx := ANCHO div 2  + RADIO * (1 - CANT_COLUMNAS);
      for j := 1 to CANT_COLUMNAS do
      begin
	 zona [i, j].ocupada := true;
	 zona [i, j].pelota.posicion.x := posx;
	 zona [i, j].pelota.posicion.y := posy;
         zona [i, j].pelota.color := rojo;
	 posx := posx + 2 * RADIO
      end;
      posy := posy - 2 * RADIO      
   end;
end;

procedure escribirCelda(celda : TCeldaPelota);
begin
   if celda.ocupada then
      escribirColor(celda.pelota.color)
   else
      write('.')
end;

{asigna color a la celda o la deja desocupada, según char}
procedure carCelda(var celda : TCeldaPelota; c : char);
begin
   if c = '.' then
      celda.ocupada:= false
   else
   begin
      celda.ocupada:= true;
      celda.pelota.color:= charToColor(c)
   end
end;
        

    
{ despliega en pantalla la zona de pelotas }
procedure escribirZP(zona : TZonaPelotas);
var i, j :  integer;
begin
   writeln('==========');
   for i := 1 to CANT_FILAS do
   begin
      for j := 1 to CANT_COLUMNAS do
         escribirCelda(zona[i,j]);
      writeln
   end;
   writeln('==========')
end;

procedure leerZP(var zona : TZonaPelotas);
var i, j :  integer;
   c    : char;
begin
   for i := 1 to CANT_FILAS do
   begin
      for j := 1 to CANT_COLUMNAS do
      begin
         read(c);
         carCelda(zona[i,j],c);
      end;
      readln
   end
end;

{ programa principal }
begin
   flag_if := true;
   frontera.tope:= 4; {pongo basura en tope}
   
   {inicio la zona de pelotas completa y todas pelotas rojas }
   inicioZP(zona);
   repeat
      readln(opcion);
     
      case opcion of
        'i':  {carga zona de pelotas}
              leerZP(zona);
        
        'm':  {muestra zona de pelotas}
              escribirZP(zona);
        
        'p':  {dar un paso}
            begin {dar un paso}
               leerBalin(balin);
               darUnPaso(balin);
               escribirBalin(balin);
               writeln
             end;
        'h':  {estan chocando}
            begin
               leerPelota(pelota1);
               leerPelota(pelota2);
               escribirBooleano(estanChocando(pelota1,pelota2));
               writeln
            end;
        'f':   {es frontera}
            begin
               readln(indice.i,indice.j);
               escribirBooleano(esFrontera(indice,zona));
               writeln
            end;
        'F' :
            begin
               obtenerFrontera(zona,frontera);
               escribirSecPelotas(frontera);
               writeln
            end;
        'd' :   {disparar}
            begin
               leerBalin(balin);
               obtenerFrontera(zona,frontera);
               disparar(balin,frontera,zona,indice,choca);
               escribirBooleano(choca); write(' ');
               if choca then
                  escribirIndiceP(indice)
               else writeln
            end;
        'x' :
            begin
               leerSecPelotas(sec);
               eliminarPelotas(zona,sec);
            end;
        'v' :
             begin
                escribirBooleano(esZonaVacia(zona));
                writeln
             end;
      end
      
  until opcion = 'q';	
   
end.
