program Ejer5;
const
    valorAlto=9999;
type    
    cadena = String[20];
    producto = record
        codigo:integer;
        nombre: cadena;
        descripcion: string;
        stockDisponible:integer;
        stockMinimo:integer;
        precio:real;
    end;
    archivoMaestro = file of producto;

    prodDetalle = record
        nombre:cadena;
        cantVendidas:integer;
    end;
    archivoDetalle = file of prodDetalle;
    vectorDetalles = array [1..10] of archivoDetalle;


procedure cargarDetalle(var detalle:archivoDetalle; nombre_fisico:cadena);
var
    carga:Text;
    prod:prodDetalle;
begin
    Assign(carga,nombre_fisico);
    Reset(carga);
    while (not Eof(carga)) do begin
        ReadLn(carga,prod.nombre);
        ReadLn(carga,prod.cantVendidas);
        Write(detalle,prod);
    end;
    WriteLn('| '+nombre_fisico+' Cargado con Exito |');
end;

var
    i:integer;
    pos:cadena;
    vDetalle:vectorDetalles;
    maestro:archivoMaestro;
begin
    crearArchivoMaestro(maestro);
    for i:=1 to 10 do begin
        Str(i,pos);
        Assign(vDetalle[i],'detalle'+pos);
        Rewrite(vDetalle[i]);
        cargarDetalle(vDetalle[i],'detalle'+pos+'.txt');
        Close(vDetalle[i]);
    end;
    actualizarMaestro(maestro,vDetalle);
end.