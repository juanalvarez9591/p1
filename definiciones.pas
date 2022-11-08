
const
   ALTO		 = 400; { alto del escenario  }
   ANCHO	 = 300; { ancho del escenario }
   RADIO	 = 10; { radio de la pelota   }
   CANT_FILAS	 = 8;
   CANT_COLUMNAS = 8;
   CANT_PELOTAS	 = CANT_FILAS * CANT_COLUMNAS;

type
   { La cantidad de colores NO es un problema; actualizar}
   TColor	 = (Verde, Rojo, Azul); { , Amarillo, Lima); }

     TPosicion = record
		     x, y : integer
		  end;	  

     TVelocidad = record
		     vx, vy :  integer
		  end;

     TPelota	 = record
		      posicion : Tposicion;
		      color    : TColor
		end;	       

     TBalin    = record
		    velocidad: TVelocidad;
		    pelota: TPelota
		 end;

     TCeldaPelota = record
		    case ocupada:boolean of
		      True: (pelota : TPelota);
		      False:()
		    end;

     RangoFilas	 = 1..CANT_FILAS;
     RangoColumnas = 1..CANT_COLUMNAS;
     TZonaPelotas = array [RangoFilas, RangoColumnas] of TCeldaPelota;

     TIndicePelota  = record
			 i : 1..CANT_FILAS;
			 j : 1..CANT_COLUMNAS
		      end;

     TSecPelotas  = record
		       sec: array [1..CANT_PELOTAS] of TIndicePelota;
		       tope : 0..CANT_PELOTAS
		    end;



{ PROCEDIMIENTOS PARA LOS COLORES }

{ Los nombres de colores que se publican deben ser colores para tk SIN blancos }
{ ver https://www.tcl.tk/man/tcl/TkCmd/colors.html }
procedure publicaCol (c	:Tcolor );
begin
   if flag_if then
      case c of
	Verde	 : write ('MediumSeaGreen');
	Rojo	 : write ('red');
	Azul	 : write ('blue');
	{ Amarillo : write ('yellow'); }
	{ Lima	 : write ('LimeGreen') }
      end
end;

{ Los colores que se leen SOLO consideran UN caracter }
procedure leeColor (var f :text ; var col :TColor);
var c : char;
begin
   read (f, c);
   case c of
     'M' : col := Verde; { MediumSeaGreen }
     'r' : col := Rojo;  { red }
     'b' : col := Azul;   { blue }
     { 'y' : col := Amarillo; }  { yellow } 
     { 'L' : col := Lima; }  { LimeGreen }
   end
end;





