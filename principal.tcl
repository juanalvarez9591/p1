#!/usr/bin/wish
## Luis Sierra 2022
## Formas de invocar:
##    wish principal.tcl
##    wish principal.tcl mac

## Para debugging usando WRITEs en el .PAS usando la interfaz es necesario
## usar la salida de error estándar. En los archivos .PAS debe escribir:
## WRITE (stderr, arg1, arg2, .... argN)
## o
## WRITELN (stderr, arg1, arg2, .... argN)

package require Tk

## Se agrega una opción para evitar uso de PNG. Hay problemas en
## alguna versión de MAC. 
set noIconBoom [expr $argc && [string equal -nocase "mac" [lindex $argv 0]]] 

## En Mac NO se puede usar -background. Así que en vez de cambiar el fondo,
## invisibilizo el texto.
ttk::style map TButton -foreground [list disabled {light grey}]

set ejecutable [file join "." "principal"]; # Nombre del ejecutable
set archivo ""                            ; # Archivo con zona de pelotas

proc config {} {
    wm title . "Tarea 2"
    wm protocol . WM_DELETE_WINDOW cerrarPascal
    set ::io [open "|$::ejecutable IF 2>/dev/tty" r+]
    fconfigure $::io -buffering line
}

# Constantes a leer desde el .PAS. Se leen en LeerEspecificacion
set ANCHO 0;     ### cantidad de columnas de la grilla
set ALTO 0;      ###             filas
set RADIO 0;     ###    radio de la pelota

# Coordenadas iniciales del balín en TK. Se setean en LeerEspecificacion
set xO 0
set yO 0

proc LeerEspecificacion {} {
    puts $::io p
    set linea [ leer ]
    if {! [regexp {ANCHO:\s*(\d+)\s+ALTO:\s*(\d+)\s+RADIO:\s*(\d+)} $linea \
	       -> ::ANCHO ::ALTO ::RADIO]} then {
	problemas $linea
    }
    set ::anchoTotal [expr $::ANCHO + 2 * $::RADIO]
    set ::altoTotal  [expr $::ALTO + 2 * $::RADIO]
    set ::xO [ expr $::anchoTotal / 2 ]
    set ::yO $::ALTO
}

proc setIcono {} {
    # Icono para la explosión
    # En algunas versiones de MAC ese PNG da problemas
    # En ese caso, usar opción "mac" al invocar.
    image create photo boomorig -file auge.png; ## auge.png es 512x512
    image create photo boom 
    boom copy boomorig -subsample [expr 512 / (2 * $::RADIO) ]
}

# Se generan colores aleatorios para el balín
expr srand ([ clock microseconds ])
    
# Colores del borde del escenario
set ::cborde {dark grey}   ; # Borde del escenario
set ::cfondo {light grey}  ; # Escenario

# Ligaduras de eventos del ratón. Fijan la velocidad y disparan el balín
proc bindMouse {} {
    bind .can <ButtonPress> {
	.btPaso state "disabled"
	unbindMouse
	disparaBalin %x %y
    }
    .can bind areaV  <Motion> { dibujaVxy %x %y }
}
proc unbindMouse {} {
    bind .can <ButtonPress> break
    .can bind areaV  <Motion> break
}

proc leer {} {
    gets $::io linea; return $linea
}

proc cerrarPascal {} {
    fconfigure $::io -blocking 0
    while {[gets $::io linea] > 0} {}
    comFIN
}

proc problemas { xs } {
    tk_messageBox -type ok -message "Comunicación incorrecta con su .pas: $xs"
    cerrarPascal
}

## Transformaciones de coordenadas: PASCAL TO TCL y TCL TO PASCAL
proc xP2T {x} {return [ expr $x + $::RADIO ]}
proc yP2T {y} {return [ expr $::ALTO - $y + $::RADIO ]}
proc xT2P {x} {return [ expr $x - $::RADIO ]}
proc yT2P {y} {return [ expr $::ALTO - $y + $::RADIO ]}
proc VxP2T {x} {return $x }
proc VyP2T {y} {return [ expr - $y ]}
proc VxT2P {x} {return $x }
proc VyT2P {y} {return [ expr - $y ]}

## Carteles indicando posicion y velocidad
proc setPxy {} {
    set ::balin("Pxy") [format \
			    "Pos: (%d, %d)\n   Vel: (%d, %d)" \
			    $::balin("Px") $::balin("Py") $::balin("Pvx") \
			    $::balin("Pvy")]
}

proc setPxyo {} {
    set ::balin("Pxy") [format \
			    "Pos: (%d, %d)\n   Vel: (%d, %d)" \
			    [xT2P $::xO] [yT2P $::yO] [VxT2P $::balin("vox")] \
			    [VyT2P $::balin("voy")]] 
}

proc leeBalin {} {    ## NO lee el color
    set linea [ leer ]
    if {[regexp {(-?\d+)\s+(-?\d+)\s+(-?\d+)\s+(-?\d+)} $linea -> x y vx vy]} {
	set ::balin("x") [ xP2T $x ]
	set ::balin("y") [ yP2T $y ]
	set ::balin("vx") [ VxP2T $vx ]
	set ::balin("vy") [ VyP2T $vy ]
	set ::balin("Px") $x
	set ::balin("Py") $y
	set ::balin("Pvx") $vx
	set ::balin("Pvy") $vy
	setPxy
    }
}

proc leePG {w} {    ## lee posicion de una particula
    upvar $w a;
    set linea [ leer ]
    # LECTURA DE ENTEROS
    if {[regexp {([[:alpha:]]+)\s*(-?\d+)\s+(-?\d+)} $linea -> c y x]} {
	set a("pv") $c
	set a("x") [ xP2T $x ]
	set a("y") [ yP2T $y ]
	return true
    } {return false }
}

proc iniBalin {} {
    set l [llength $::chckC]                   ;# cantidad de colores en la zona
    set r [ expr int ($l * rand ()) ]          ;# sorteo de un color
    set ::balin("pv") [lindex $::chckC $r]     ;# acceso al color
    set ::balin("x") $::xO
    set ::balin("y") $::yO
    set ::balin("Px") [ xT2P $::xO ]
    set ::balin("Py") [ yT2P $::yO ]
    set ::balin("Pvx") [ VxT2P $::balin("vox") ]
    set ::balin("Pvy") [ VyT2P $::balin("voy") ]
    setPxy
    puts $::io "i $::balin("Px") $::balin("Py") $::balin("Pvx") $::balin("Pvy")"
    puts $::io [string index $::balin("pv") 0]
}

proc jugar {} {
    puts $::io m
    leePGs                                        ;# lee la grilla
    dibujaVxy 250 700
    iniBalin; dibujaBalin
    bindMouse
    set ::primerPaso true
}

proc iniGame {} { puts $::io l; jugar }

proc reiniGame {} { puts $::io r; jugar }

proc iniVel {} {
    set avx $::balin("vox")
    set avy $::balin("voy")
    puts $::io "v $avx [expr -$avy]";  ## la velocidad de ::balin esta en TCL
}

proc dibujaVxy { x y } {
    .can delete vxy
    set xx [ expr $::ANCHO / 2 - $x ]
    set yy [ expr $::ALTO - $y ]
    set magnitud [ expr sqrt ( $xx*$xx + $yy*$yy ) ]
    set vx [ expr $::xO - int ( $::radioAreaV * $xx / $magnitud ) ]
    set vy [ expr $::yO - int ( $::radioAreaV * $yy / $magnitud ) ]
    .can create line $::xO $::yO $vx $vy \
	-fill blue -arrow last -width 2 -tags vxy
    set desp [ expr 1.5 * $::RADIO ]
    set ::balin("vox") [ expr int ( - $desp * $xx / $magnitud ) ]
    set ::balin("voy") [ expr int ( - $desp * $yy / $magnitud ) ]
    setPxyo
}


proc dibujaPelota {p tag} {
    upvar $p pp
    set color $pp("pv")
    set ulx [expr $pp("x") - $::RADIO]
    set uly [expr $pp("y") - $::RADIO]
    set drx [expr $pp("x") + $::RADIO]
    set dry [expr $pp("y") + $::RADIO]
    .can create oval $ulx $uly $drx $dry -fill $color -outline "" -tags $tag
}

proc explotaBalin {} {
    if {$::noIconBoom} {return} 
    .can create image $::balin("x") $::balin("y") -image boom -tag boom
    after 500 ".can delete boom"
}

proc leePGs {} {
    .can delete p                    ;#       borrado de la zona de pelotas
    set ::chckC {}                   ;#       inicializo colores usados
    while {[leePG b]} {
	dibujaPelota b p
	set color $b("pv")
	if { $color ni $::chckC } {
	    lappend ::chckC $color   ;#       marco color como usado
	}
    }
    .can lower p mundo
}

proc leePGsF {} {
#    .can delete frontera                    ;#       borrado de la frontera
    while {[leePG b]} {
	puts [array get b]
	set b("pv") white
	dibujaPelota b frontera
    }
}

proc dibujaBalin {} { .can delete balin; dibujaPelota ::balin balin }

proc comandos {} {
    ttk::button .btABRIR -text "ABRIR" -command comABRIR
    ttk::button .btFIN -text "FIN" -command comFIN

    ttk::button .btNUEVO -text "NUEVO" -command iniGame
    ttk::button .bt0b -text "REINICIAR" -command reiniGame
    ttk::button .btPaso -text "PASO" -command comPaso
    ttk::button .btFrontera -text "Ver frontera" -command comFrontera

    pack .btNUEVO .btABRIR .bt0b .btFIN .btFrontera .btPaso -padx 40 -pady 10

    if {!$::noIconBoom} {
	ttk::button .btBOOM -image boom -command comAPROPOS
	pack .btBOOM -side bottom
    }
}

proc comABRIR {} {
    tk_messageBox -type ok -message \
	"Recuerde que la cantidad de filas y columnas del archivo debe coincidir con las declaradas en definiciones.pas. Puede modificarlas y recompilar su programa para seguir usando la interfaz adecuadamente."
    set inp [tk_getOpenFile -filetypes {{"Entrada" .dat TEXT}}]
    if {![string equal $inp ""]} {
	set ::archivo $inp
	puts $::io "g $inp"
	regexp {([[:alnum:]]+.dat)$} $inp v
	# puts $::io "g $::archivo"
	# regexp {([[:alnum:]]+.dat)$} $::archivo v
	wm title . "Tarea 2: $v"
	jugar
    }
} 

proc comFIN {} { puts $::io f; exit }

proc comPaso {} {
    if {$::primerPaso} { unbindMouse; iniVel }
    set ::primerPaso [Paso]
    if {$::primerPaso} bindMouse
}

proc comFrontera {} {
    puts $::io w
    leePGsF
    after 500 ".can delete frontera"
}

proc comAPROPOS {} {
    # Atribución del icono tomado de flaticon, como lo indica su web
    tk_messageBox -type ok -message \
	"Icono realizado por Voysla (www.flaticon.es/autores/voysla) de www.flaticon.com"
}




proc chocaFeo {} {
    puts $::io q
    set res false
    while {[leePG b]} {
	set Dx [expr $b("x") - $::balin("x")]
	set Dy [expr $b("y") - $::balin("y")]
	set res [expr $res || ($Dx*$Dx+$Dy*$Dy < 4 * $::RADIO * $::RADIO) ]
    }
    puts $::io [expr $res?{s}:{n}]
}

proc Paso {} {
    siguientePos
    chocaFeo
    if {[readBool]} {
	explotaBalin
	puts $::io m
	leePGs
	puts $::io s; ## PAS: se terminaron las pelotas?
	if {[readBool]} {
	    .can delete balin
	    tk_messageBox -type ok -message "Eliminaste todas"
	}
	.btPaso state "!disabled"
	iniBalin; dibujaBalin
	return true
    }
    if {[expr $::balin("y") > $::ALTO]} {
	iniBalin; dibujaBalin
	return true
    } {
	return false
    }
}

## PAS: darUnPaso
proc siguientePos {} {
    puts $::io n
    leeBalin
    dibujaBalin
}

proc readBool {} {
    set linea [ leer ]
    return [regexp {true} $linea]
}

# da pasos hasta que choca con la frontera o se pierde por el borde inferior
proc siguientePosNF {} {
    if {[Paso]} {
	.btPaso state "!disabled"
	bindMouse
    } else {
	after 30 siguientePosNF
    }
}

proc disparaBalin {vx vy} { iniVel; siguientePosNF }

config
LeerEspecificacion
if {!$::noIconBoom} {setIcono}


## INI DIBUJO

canvas .can -width $::anchoTotal -height $::altoTotal
.can create rect 0 0 $::anchoTotal $::altoTotal -fill $::cfondo -outline ""
foreach i  {"$::ANCHO + $::RADIO" 0} j  {0 "$::ALTO + $::RADIO"} {
	.can create rect [expr $i] [expr $j] $::anchoTotal $::altoTotal \
	    -fill $::cborde -tag mundo -outline ""
    }
foreach i  {$::anchoTotal $::RADIO} j  {$::RADIO $::altoTotal} {
	.can create rect 0 0 [expr $i] [expr $j] \
	    -fill $::cborde -tag mundo -outline ""
    }

set ::radioAreaV [ expr 8 * $::RADIO ]
.can create arc [ expr $::anchoTotal / 2 - $::radioAreaV] \
    [ expr $::ALTO - $::radioAreaV ] \
    [ expr $::anchoTotal / 2 + $::radioAreaV] \
    [ expr $::ALTO + $::radioAreaV ] \
    -fill {grey85} -start 0 -extent 180 -tag areaV

set ::balin("Pxy") ""
ttk::label .pos -textvariable ::balin("Pxy")

pack .can -padx 10 -pady 10 -side left
comandos
pack .pos -padx 25

## FIN DIBUJO


iniGame



