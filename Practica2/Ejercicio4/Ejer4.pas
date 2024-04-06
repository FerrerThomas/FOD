program Ejer4;
const
    valorAlto='ZZZZ';
type
    cadena = String[20];    
    provincia = record
        nombre:cadena;
        cantAlfa:integer;
        totalEncuestados:integer;
    end;
    archivoMaestro = file of provincia;

    censoData = record
        nombre:cadena;
        codigo:integer;
        cantAlfa:integer;
        totalEncuestados:Integer;
    end;
    archivoDetalle = file of censoData;

procedure crearArchivoMaestro(var maestro:archivoMaestro);
var
    carga: text;
    prov:provincia;
begin
    WriteLn('Ingrese nombre del archivo maestro a crear: ');
    Assign(maestro,'archivoMestro');
    Assign(carga,'provincias.txt');
    Rewrite(maestro);
    Reset(carga);
    while (not Eof(carga)) do begin
        ReadLn(carga,prov.nombre);
        ReadLn(carga,prov.cantAlfa);
        ReadLn(carga,prov.totalEncuestados);
        Write(maestro,prov);
    end;
    WriteLn('| Archivo Maestro Cargado Correctamente |');
    Close(maestro);
    close(carga);
end;

procedure crearArchivosDetalles(var d1,d2:archivoDetalle);
var
    carga1,carga2:text;
    prov1,prov2:censoData;
begin
    // cargo el primer detalle
    WriteLn('Ingrese el nombre del archivo dellate 1 a cargar: ');
    Assign(d1,'archivoDetalle1');
    Assign(carga1,'detalle1.txt');
    Rewrite(d1);
    Reset(carga1);
    while (not Eof(carga1)) do begin
        ReadLn(carga1,prov1.nombre);
        ReadLn(carga1,prov1.codigo);
        ReadLn(carga1,prov1.cantAlfa);
        ReadLn(carga1,prov1.totalEncuestados);
        Write(d1,prov1);
    end;
    Close(d1);
    Close(carga1);
    // cargo el segundo detalle
    WriteLn('Ingrese el nombre del archivo dellate 2 a cargar: ');
    Assign(d2,'archivoDetalle2');
    Assign(carga2,'detalle2.txt');
    Rewrite(d2);
    Reset(carga2);
    while (not Eof(carga2)) do begin
        ReadLn(carga2,prov2.nombre);
        ReadLn(carga2,prov2.codigo);
        ReadLn(carga2,prov2.cantAlfa);
        ReadLn(carga2,prov2.totalEncuestados);
        Write(d2,prov2);
    end;
    Close(d2);
    Close(carga2);
    WriteLn('| Detalles Cargados Con Exito |');
end;

procedure leer(var detalle:archivoDetalle; var regD:censoData);
begin
    if (not Eof(detalle)) then 
        Read(detalle,regD)
    else
        regD.nombre:= valorAlto;
end;

procedure minimo (var regD1,regD2:censoData; var d1,d2:archivoDetalle; var min:censoData);
begin
    if (regD1.nombre<=regD2.nombre)  then begin
        min := regD1;  
        leer(d1,regD1);
    end
    else begin
        min := regD2; 
        leer(d2,regD2);
    end
end;

procedure actualizarArchivoMaestro(var maestro:archivoMaestro; var d1,d2:archivoDetalle);
var
   regM:provincia;  
   min, regD1, regD2: censoData; 
begin
    WriteLn('| Actualizando Archivo Maestro |');
    reset(maestro); 
    reset(d1);
    reset(d2);
    leer(d1, regD1);
    leer(d2, regD2); 
    minimo(regD1, regD2, d1, d2,min);
    while (min.nombre <> valoralto) do  
    begin
        read(maestro,regM);
        while (regM.nombre <> min.nombre) do
            read(maestro,regM);
        while (regM.nombre = min.nombre ) do begin
            regM.cantAlfa:=regM.cantAlfa + min.cantAlfa;
            regM.totalEncuestados:=regM.totalEncuestados + min.totalEncuestados;
            minimo(regD1, regD2, d1, d2,min);
        end;
        seek (maestro, filepos(maestro)-1);
        write(maestro,regM);
    end;
    Close(maestro);
    Close(d1);
    Close(d2);
    WriteLn('| Maestro Actualizado con Exito |');
end; 

procedure imprimirArchivo(var maestro:archivoMaestro);
var
    prov:provincia;
begin
    WriteLn('');
    WriteLn('| Imprimiendo Archivo Mestro |');
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,prov);
        WriteLn('-----------------------------------');
        WriteLn('Provincia: ', prov.nombre);
        WriteLn('Cantidad de Alfabetizados: ', prov.cantAlfa);
        WriteLn('Total de Encuestados: ',prov.totalEncuestados);
        WriteLn('-----------------------------------');
    end;
    Close(maestro);
end;
{
procedure imprimirDetalle(var d:archivoDetalle);
var
    reg:censoData;
begin
    WriteLn('');
    WriteLn('| Imprimiendo Archivo Detalle |');
    Reset(d);
    while (not Eof(d)) do begin
        Read(d,reg);
        WriteLn('-----------------------------------');
        WriteLn('Provincia: ', reg.nombre);
        WriteLn('Codigo: ',reg.codigo);
        WriteLn('Cantidad de Alfabetizados: ', reg.cantAlfa);
        WriteLn('Total de Encuestados: ',reg.totalEncuestados);
        WriteLn('-----------------------------------');
    end;
    Close(d);
end;
}
var
    maestro:archivoMaestro;
    detalle1,detalle2:archivoDetalle;
begin
    crearArchivoMaestro(maestro);
    imprimirArchivo(maestro);
    crearArchivosDetalles(detalle1,detalle2);
    //imprimirDetalle(detalle1);
    //imprimirDetalle(detalle2);
    actualizarArchivoMaestro(maestro,detalle1,detalle2);
    imprimirArchivo(maestro);
end.