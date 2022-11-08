procedure darUnPaso(var x, y: integer; vx, vy: integer);
begin
    x := x + vx;
    y := y + vy;
end;

function estanChocando(x1, y1, x2, y2: integer): boolean;
var
    formulaEuclidiana: real;
begin
    formulaEuclidiana := sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    estanChocando := (formulaEuclidiana < RADIO + RADIO);
end;

function esPosicionValida(x1, y1: integer): boolean;
begin
    esPosicionValida := ((x1 >= RADIO) and (x1 <= ANCHO - RADIO) and (y1 >= RADIO) and (y1 <= ALTO - RADIO));
end;

function predecirColision(x1, y1, vx1, vy1, x2, y2, vx2, vy2: integer): integer;
var 
    movimientos: integer;
    prediccion: boolean;
begin
    prediccion := false;
    movimientos := 0;
    if (estanChocando(x1, y1, x2, y2) and esPosicionValida(x1, y1) and esPosicionValida(x2, y2)) then
        prediccion := true;
    while (not prediccion) do
        begin
            darUnPaso(x1, y1, vx1, vy1);
            darUnPaso(x2, y2, vx2, vy2);
            movimientos := movimientos + 1;

            if (estanChocando(x1, y1, x2, y2) and esPosicionValida(x1, y1) and esPosicionValida(x2, y2)) then
                prediccion := true;

            if ((not esPosicionValida(x1, y1) or not esPosicionValida(x2, y2)) and not estanChocando(x1, y1, x2, y2)) then
                begin
                    movimientos := -1;
                    prediccion := true;
                end;
        end;
    predecirColision := movimientos;
end;