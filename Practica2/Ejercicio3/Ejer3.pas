program Ejer3;
const
    valorAlto = 9999;
type
    cadena = String[20];
    producto = record
        codigo:integer;
        nombre:cadena;
        precio:real;
        stockActual: integer;
        stockMinimo: integer;
    end;
    archivoMaestro = file of producto;

    venta = record
        codigo:integer;
        cantVendidas:integer;
    end;
    archivoDetalle = file of venta;

procedure crearArchivoMaestro(var maestro: archivoMaestro);
var
    prod: producto;
    carga:Text;
begin
    WriteLn('| Ingrese nombre del archivo maestro a crear: |');
    Assign(maestro,'archivoMaestro');
    WriteLn('| Cargo el archivo maestro con los datos de los productos |');
    Assign(carga,'productos.txt');
    Rewrite(maestro);
    Reset(carga);
    while (not eof(carga)) do begin
        ReadLn(carga,prod.codigo);
        ReadLn(carga,prod.nombre);
        ReadLn(carga,prod.precio);
        ReadLn(carga,prod.stockActual);
        ReadLn(carga,prod.stockMinimo);
        Write(maestro,prod);
    end;
    Close(carga);
    close(maestro);
    WriteLn('| Archivo Mestro Cargado');
end;

procedure crearArchivoDetalle(var detalle:archivoDetalle);
var
    carga: Text;
    v:venta;
begin
    WriteLn('| Creando el archivo detalle con el detalle.txt |');
    Assign(detalle,'archivoDetalle');
    Assign(carga,'detalle.txt');
    Reset(carga);
    Rewrite(detalle);
    while (not Eof(carga)) do begin
        ReadLn(carga,v.codigo);
        ReadLn(carga,v.cantVendidas);
        Write(detalle,v);
    end;
    Close(detalle);
    close(carga);
    WriteLn('| Archivo Detalle Cargado |');
    WriteLn();
end;

procedure leer(var detalle:archivoDetalle; var v:venta);
begin
    if (not Eof(detalle)) then 
        Read(detalle,v) 
    else
        v.codigo:= valorAlto;
end;

procedure actualizarMaestro(var maestro:archivoMaestro; var detalle:archivoDetalle);
var
    regMaestro:producto;
    regDetalle:venta;
    codActual:integer;
    totalVentas:integer;
begin
    WriteLn('| Actualizando Archivo Maestro |');
    Reset(maestro);
    Reset(detalle);
    read(maestro,regMaestro);
    leer(detalle,regDetalle);
    while regDetalle.codigo <> valorAlto do begin
        totalVentas:=0;
        codActual:= regDetalle.codigo;
        while (codActual = regDetalle.codigo) do begin
            totalVentas:= totalVentas + regDetalle.cantVendidas;
            leer(detalle,regDetalle);
        end;
        while regMaestro.codigo <> codActual do //busco en el maestro el alumno a modificar
            Read(maestro,regMaestro);
        regMaestro.stockActual:= regMaestro.stockActual - totalVentas;
        Seek(maestro,FilePos(maestro)-1);
        Write(maestro,regMaestro);
        if (not eof(maestro)) then
            Read(maestro,regMaestro);
    end;
    WriteLn('| Actualizando |');
    WriteLn();
end;

procedure listarStockMinimo(var maestro:archivoMaestro);
var
    carga:Text;
    prod:producto;
begin
    WriteLn('| Exportando listado de productos con stock actual menor al minimo |');
    Assign(carga,'stock_minimo.txt');
    Rewrite(carga);
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,prod);
        if (prod.stockActual<prod.stockMinimo) then begin
            WriteLn(carga,prod.codigo);
            WriteLn(carga,prod.nombre);
            WriteLn(carga,prod.precio:2:2);
            WriteLn(carga,prod.stockActual);
            WriteLn(carga,prod.stockMinimo);
        end;
    end;
    WriteLn('| Listado Exportado |');
    Close(maestro);
    Close(carga);
end;

procedure imprimirArchivo(var maestro:archivoMaestro);
var
    prod:producto;
begin
    WriteLn('| Imprimiendo Archivo Maestro |');
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,prod);
        WriteLn('--------------------------');
        WriteLn('Codigo: ',prod.codigo);
        WriteLn('Nombre: ',prod.nombre);
        WriteLn('Precio Unitario: ',prod.precio:2:2);
        WriteLn('Stock Actual: ',prod.stockActual);
        WriteLn('Stock Minimo: ',prod.stockMinimo);
        WriteLn('--------------------------');
    end;
    Close(maestro);
end;

var
    detalle: archivoDetalle;
    maestro: archivoMaestro;
begin
    crearArchivoMaestro(maestro);
    imprimirArchivo(maestro);
    crearArchivoDetalle(detalle);
    actualizarMaestro(maestro,detalle);
    imprimirArchivo(maestro);
    listarStockMinimo(maestro);
end.
