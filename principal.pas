program principal;


{ principal.TCL invoca principal.PAS de forma de que flag_if sea verdadera }
{ Cuando flag_if, la salida estándar es capturada por la interfaz, y para ver
  mensajes en consola es necesario usar STDERR }
{ Cuando NOT flag_if, la salida estándar puede usarse de forma habitual }
{ ESTO SIGNIFICA QUE: 
## Para debugging usando WRITEs en el .PAS usando la interfaz es necesario
## usar la salida de error estándar. En los archivos .PAS debe escribir:
## WRITE (STDERR, arg1, arg2, .... argN)
## o
## WRITELN (STDERR, arg1, arg2, .... argN)
}

var flag_if: boolean;
   
{ Con esta directiva queda incluido el archivo definiciones.pas }
{$INCLUDE definiciones.pas}

{ Con esta directiva queda incluido el archivo tarea1.pas }
{$INCLUDE tarea2.pas}


{ TIPO para BFS }
type
   TMarcas = array [RangoFilas, RangoColumnas] of
                   record
		      c	: TColor;
		      m : boolean
		   end;

{ ADMINISTRACION DE MARCAS PARA BFS }

procedure resetMarca (var marca : TMarcas);
var i : RangoFilas; j: RangoColumnas;
begin
   for i := 1 to CANT_FILAS do
      for j := 1 to CANT_COLUMNAS do
	 marca [i, j].m := false
end;
		       
procedure setMarca (var marca : TMarcas; zona:TZonaPelotas);
var i : RangoFilas; j: RangoColumnas;
   { PRE: zona con todas las celdas ocupadas }
begin
   for i := 1 to CANT_FILAS do
      for j := 1 to CANT_COLUMNAS do
      begin 
	 marca [i, j].c := zona[i, j].pelota.color; 
	 marca [i, j].m := false
      end
end;

procedure secABorrar (p	: TIndicePelota; marca :  TMarcas; var s:TSecPelotas);
var color: TColor;
   procedure dfs (i,j :integer) ;
   begin
      if not ((i in [0,CANT_FILAS+1]) or (j in [0,CANT_COLUMNAS+1])
	      or marca[i,j].m) and (color = marca[i,j].c) then
      begin
	 marca[i,j].m := true;
	 s.tope := 1 + s.tope;
	 s.sec[s.tope].i := i;
	 s.sec[s.tope].j := j;
	 dfs (i-1,j); dfs (i,j-1); dfs (i,j+1); dfs (i+1,j)
      end;
   end;
begin
   resetMarca (marca);
   s.tope := 0;
   color := marca [p.i, p.j].c;
   dfs (p.i, p.j)
end;   




{ COMUNICACION CON LA INTERFAZ }

{ Ver uso de flag_if al comienzo de este archivo }
procedure PublicarEspecificacion ();
begin
   if flag_if then
   begin
      writeln ('ANCHO:', ANCHO:0, ' ALTO:', ALTO:0, ' RADIO:', RADIO:0);
      flush (output)
   end
end;

procedure publicaBalin (balin : TBalin);
begin
   if flag_IF then
   begin
      with balin, pelota, posicion, velocidad do writeln (x, y, vx, vy);
      flush (output)
   end
end;

procedure publicaB (b :boolean );
begin
   if flag_IF then
   begin
      if b then writeln ('true')
      else writeln ('false');
      flush (output)
   end
end;

procedure publicaP (p : TPelota);        { leePG }
begin
   if flag_if then
      with p, p.posicion do 
      begin
	 publicaCol (p.color);
	 writeln (' ', p.posicion.y, ' ', p.posicion.x)
      end
end;

procedure publicaZP (zona : TZonaPelotas );
var i, j		      : integer;
begin
   for i := 1 to CANT_FILAS do
      for j := 1 to CANT_COLUMNAS do
	 if zona[i,j].ocupada then
	    publicaP (zona [i, j].pelota);
   writeln ('FIN');
   flush (output)
end;

procedure publicaSec (zona	: TZonaPelotas; sec : TSecPelotas );
var i : integer;
begin
   with sec do
      for i := 1 to tope do
	 publicaP (zona [sec[i].i, sec[i].j].pelota);
   writeln ('FIN');
   flush (output)
end;


{ CARGA DE ZONA DE PELOTAS: desde archivo y aleatoria }

{ * Desde archivo }
procedure readZP (nf : ansistring; var zona:TZonaPelotas; var marca:TMarcas);
var i	      : RangoFilas; j: RangoColumnas;
   posx, posy : integer;
   f	      : text;
begin
   assign (f, nf);
   reset (f);
   posy := ALTO - RADIO;
   for i := 1 to CANT_FILAS do
   begin
      posx := ANCHO div 2  + RADIO * (1 - CANT_COLUMNAS);
      for j := 1 to CANT_COLUMNAS do
      begin
	 zona [i, j].ocupada := true;
	 zona [i, j].pelota.posicion.x := posx;
	 zona [i, j].pelota.posicion.y := posy;
	 leeColor (f, zona [i, j].pelota.color);
	 posx := posx + 2 * RADIO
      end;
      readln (f);
      posy := posy - 2 * RADIO      
   end;
   setMarca (marca, zona);
   close (f)
end;

{ * Aleatoria }
procedure iniciaZP (var zona:TZonaPelotas; var marca:TMarcas);
var i	      : RangoFilas; j: RangoColumnas;
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
	 zona [i, j].pelota.color :=  TColor (random(1 + ord(high(TColor))));
	 posx := posx + 2 * RADIO
      end;
      posy := posy - 2 * RADIO
   end;
   setMarca (marca, zona)
end;

{ Reocupación de Zona de Pelotas }
procedure resetZP (var zona :TZonaPelotas );
var i			    : RangoFilas; j: RangoColumnas;
begin
   for i := 1 to CANT_FILAS do
      for j := 1 to CANT_COLUMNAS do
	 zona [i, j].ocupada := true
end;


		       

{ procedure iniTiro (c : TColor;  var balin : TBalin); }
{ begin }
{    with balin, pelota, velocidad, posicion do }
{    begin }
{       x := ANCHO div 2; y := ALTO; }
{       vx := 0; vy := 0; }
{       color := c }
{    end }
{ end; }


{
Programa principal.
}

var 
   c, com	   : char;
   nfv	   : ansistring;
   auxbool : boolean;
   idx	   : TIndicePelota;
   aEliminar, frontera   : TSecPelotas;
   balin : TBalin;
   zona:TZonaPelotas;
   marcas: TMarcas;

begin
   flag_if := paramcount > 0;
   randomize;

   repeat
      read (com);
      case com of
	{ OPCIONES QUE PUEDEN USARSE TAMBIEN DESDE EL TESTING }
	'g' : { Lectura de archivo }
              begin
		 read (c); readln (nfv); readZP (nfv, zona, marcas);
	      end;
	'i' : { Seteo de TODO el balín }
	      with balin, pelota, posicion, velocidad do
              begin
		 readln (x, y, vx, vy); leeColor (input, color)
	      end;
	'v' : { Seteo de velocidad del balín }
	      with balin.velocidad do read (vx, vy); { ingresar Velocidad }
	'f' : ; { fin; }
	
	{ OPCIONES USADAS SOLAMENTE DESDE LA INTERFAZ }
	'p' : PublicarEspecificacion ();     { IF: LeerEspecificacion }
	'l' : iniciaZP (zona, marcas); { Carga zona de pelotas en IF }
	'r' : resetZP (zona); { Resetea zona }
	'm' : { Publica zona de pelotas en IF }
	      begin
		 obtenerFrontera (zona, frontera);
		 publicaZP (zona)
	      end;
	'q' : {  }
	      begin
		 publicaZP (zona);
		 readln; readln (c);
		 if c  = 's' then
		 begin
		    disparar (balin, frontera, zona, idx, auxbool);
		    if auxbool then
		    begin
		       secABorrar (idx, marcas, aEliminar);
		       eliminarPelotas (zona, aEliminar)
		    end
		 end;
		 publicaB (c = 's')
	      end;
	'n' : { IF: Avanza un tick }
	      begin
		 darUnPaso (balin); publicaBalin (balin)
	      end;
	's' : { IF: zona Vacia }
	      publicaB (esZonaVacia (zona));
	'w' : { IF: pinta frontera }
	      begin
		 obtenerFrontera (zona, frontera);
		 publicaSec (zona, frontera)
	      end;
    end
  until com = 'f';
end.
