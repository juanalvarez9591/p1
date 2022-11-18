procedure darUnPaso(var balin: TBalin);
begin
    balin.pelota.posicion.x := 
        balin.pelota.posicion.x + balin.velocidad.vx;
    balin.pelota.posicion.y := 
        balin.pelota.posicion.y + balin.velocidad.vy;

    if ((balin.pelota.posicion.x + RADIO > ANCHO) or 
    (balin.pelota.posicion.x < RADIO)) then
        balin.velocidad.vx := -balin.velocidad.vx;
    if (balin.pelota.posicion.y + RADIO > ALTO) then
        balin.velocidad.vy := -balin.velocidad.vy;
end;

function estanChocando(p1, p2: TPelota): boolean;
var
    formulaEuclidiana: real;
begin
    formulaEuclidiana := sqrt((p2.posicion.x-p1.posicion.x)*(p2.posicion.x-p1.posicion.x) + (p2.posicion.y-p1.posicion.y)*(p2.posicion.y-p1.posicion.y));
    estanChocando := (formulaEuclidiana < RADIO + RADIO);
end;

function esFrontera(indicePelota: TIndicePelota;
zonaPelotas: TZonaPelotas): boolean;
var esBorde, vecinaVacia: boolean;
begin
    esFrontera := false;
    vecinaVacia := false;
    if(zonaPelotas[indicePelota.i, indicePelota.j].ocupada) then
    begin
        esBorde := (indicePelota.i = 1) or 
            (indicePelota.i = CANT_FILAS) or
            (indicePelota.j = 1) or 
            (indicePelota.j = CANT_COLUMNAS);

        if (esBorde) then
            esFrontera := true;
        
        if (not vecinaVacia and not esBorde) then
            vecinaVacia := (not zonaPelotas[indicePelota.i-1, indicePelota.j].ocupada) or
                (not zonaPelotas[indicePelota.i+1, indicePelota.j].ocupada) or
                (not zonaPelotas[indicePelota.i, indicePelota.j-1].ocupada) or
                (not zonaPelotas[indicePelota.i, indicePelota.j+1].ocupada);

        if (vecinaVacia) then
            esFrontera := true;
    end;
end;

procedure obtenerFrontera(zonaPelotas: TZonaPelotas;
var frontera: TSecPelotas);
var f, c: integer;
var indicePelota: TIndicePelota;
begin
    frontera.tope := 0;
    for f:= 1 to CANT_FILAS do
        begin
            for c:= 1 to CANT_COLUMNAS do
                begin
                    indicePelota.i := f;
                    indicePelota.j := c;

                    if (esFrontera(indicePelota, zonaPelotas)) then
                        begin
                            frontera.tope := frontera.tope + 1;
                            frontera.sec[frontera.tope] := indicePelota;
                        end;
                end;
        end; 
end;

procedure disparar(b: TBalin;
frontera: TSecPelotas;
zona : TZonaPelotas;
var indicePelota: TIndicePelota;
var chocaFrontera: boolean);
var i: integer;
var finEvaluacion: boolean;
var indicePelotaFrontera: TIndicePelota;
var pelotaFrontera: TPelota;
begin
    finEvaluacion := false;
    i := 1;
    obtenerFrontera(zona, frontera);

    while (not finEvaluacion) do
        begin
            darUnPaso(b);

            
            for i := 1 to frontera.tope do
                begin
                    if ((not finEvaluacion) and estanChocando(b.pelota, zona[frontera.sec[i].i, frontera.sec[i].j].pelota)) then
                        begin
                            finEvaluacion := true;
                            indicePelotaFrontera := frontera.sec[i];
                            pelotaFrontera := zona[frontera.sec[i].i, frontera.sec[i].j].pelota;
                        end;
                end;
            
            if (finEvaluacion) then
                begin 
                    if (b.pelota.color = pelotaFrontera.color) then
                        begin
                            chocaFrontera := true;
                            indicePelota := indicePelotaFrontera;
                        end
                        else
                            chocaFrontera := false;
                end;
            if (b.pelota.posicion.y - RADIO < 0) then
                begin
                    finEvaluacion := true;
                    chocaFrontera := false;
                end;
        end;
end;

procedure eliminarPelotas(var zonaPelotas: TZonaPelotas;
aEliminar: TSecPelotas);
var i: integer;
begin
    for i:= 1 to aEliminar.tope do
        begin
            zonaPelotas[aEliminar.sec[i].i, aEliminar.sec[i].j].ocupada := false; 
        end;
end;

function esZonaVacia(zonaPelotas: TZonaPelotas): boolean;
var f, c: integer;
var zonaVaciaEncontrada: boolean;
begin
    zonaVaciaEncontrada := false;
    esZonaVacia := true;
    f := 1;
    c := 1;
    
    while (not zonaVaciaEncontrada) or (f <= CANT_FILAS) do
    begin
        if (zonaPelotas[f, c].ocupada) then
            esZonaVacia := false;
            zonaVaciaEncontrada := true;
        
        c := c + 1;

        if (c > CANT_COLUMNAS) then
            begin
                c := 1;
                f := f + 1;
            end;
    end;
end;

