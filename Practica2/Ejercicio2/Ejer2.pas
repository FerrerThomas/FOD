program Ejer2;
const
    valorAlto = 9999;
type
    cadena = string[20];
    alumno = record
        codigo:integer;
        apellido: cadena;
        nombre: cadena;
        cursadas:integer;
        aprobadas:integer;
    end;
    archivoMestro = file of alumno;

    alumnoDetalle = record
        codigo:integer;
        cursada:char;
        final:char;
    end;
    archivoDetalle = file of alumnoDetalle;

procedure crearArchivoMaestro(var maestro:archivoMestro);
var
    carga: Text;
    a:alumno;
begin
    WriteLn('Ingrese nombre del archivo maestro: ');
    Assign(maestro,'maestroAlumnos');
    WriteLn('| Archivo Maestro Creado |');
    WriteLn('Ingrese nombre del Archivo a cargar');
    Assign(carga,'alumnos.txt');
    Rewrite(maestro);
    Reset(carga);
    while (not Eof(carga)) do begin
        ReadLn(carga,a.codigo);
        ReadLn(carga,a.apellido);
        ReadLn(carga,a.nombre);
        ReadLn(carga,a.cursadas);
        ReadLn(carga,a.aprobadas);
        Write(maestro,a);
    end;
    WriteLn('| Archivo Mestro Cargado Con Exito |');
    Close(carga);
    Close(maestro);
end;

procedure crearArchivoDetalle(var detalle:archivoDetalle);
var
    carga:Text;
    d:alumnoDetalle;
begin
    WriteLn('Ingrese el nombre del archivo detalle: ');
    Assign(detalle,'detalleAlumnos');
    Assign(carga,'detalle.txt');
    Rewrite(detalle);
    Reset(carga);
    while (not Eof(carga)) do begin
        ReadLn(carga,d.codigo);
        ReadLn(carga,d.cursada);
        ReadLn(carga,d.final);
        Write(detalle,d);
    end;
    Close(carga);
    Close(detalle);
    WriteLn('| Detalle Cargado |');
end;

// leo un empleado del detalle, si es el final devuelvo el corte, sino devuelvo el empleado
procedure leer(var detalle:archivoDetalle; var alum:alumnoDetalle);
begin
    if (not Eof(detalle)) then 
        Read(detalle,alum) 
    else
        alum.codigo:= valorAlto;
end;

procedure actualizarMaestro(var maestro:archivoMestro; var detalle:archivoDetalle);
var
    regMaestro:alumno;
    regDetalle:alumnoDetalle;
    codActual:integer;
    final,cursada:integer;
begin
    Reset(detalle);
    Reset(maestro);
    read(maestro,regMaestro);
    leer(detalle,regDetalle);
    while (regDetalle.codigo <> valorAlto) do begin
        final:=0;
        cursada:=0;
        codActual:= regDetalle.codigo;
        while codActual = regDetalle.codigo do begin //acumulo por codigo
            if regDetalle.cursada = 'A' then 
                cursada:= cursada +1;
            if regDetalle.final = 'A' then
                final:= final +1;
            leer(detalle,regDetalle);
        end;
        while regMaestro.codigo <> codActual do //busco en el maestro el alumno a modificar
            Read(maestro,regMaestro);
        regMaestro.cursadas:=regMaestro.cursadas+cursada-final;
        regMaestro.aprobadas:=regMaestro.aprobadas+final;
        Seek(maestro,FilePos(maestro)-1);
        Write(maestro,regMaestro);
        if (not eof(maestro)) then
            Read(maestro,regMaestro);
    end;
    WriteLn('| Archivo Mestro Actualizado |');
    close(maestro);
    close(detalle);
end;

procedure imprimirArchivo(var maestro:archivoMestro);
var
    a:alumno;
begin
    WriteLn('| Imprimiendo Archivo Maestro |');
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,a);
        WriteLn('--------------------------');
        WriteLn('Codigo: ',a.codigo);
        WriteLn('Apellido: ',a.apellido);
        WriteLn('Nombre: ',a.nombre);
        WriteLn('Cursadas Aprobadas: ',a.cursadas);
        WriteLn('Finales Aprobados: ',a.aprobadas);
        WriteLn('--------------------------');
    end;
    Close(maestro);
end;

procedure listarMasFinales(var maestro:archivoMestro);
var
    carga:Text;
    alum:alumno;
begin
    Assign(carga,'reporteAlumnos.txt');
    Rewrite(carga);
    Reset(maestro);
    while (not eof(maestro)) do begin
        Read(maestro,alum);
        if (alum.aprobadas > alum.cursadas) then
            WriteLn(carga,alum.codigo,' | ',alum.apellido,' | ',alum.nombre,' | ',alum.cursadas,' | ',alum.aprobadas);
    end;
    WriteLn('| Reporte Exportado |');  
    Close(maestro);
    Close(carga);
end;


var
    maestro:archivoMestro;
    detalle:archivoDetalle;
    opcion:integer;
begin
    opcion:=0;
    while opcion < 6 do begin
        WriteLn('| Ingresar la opcion que desee |');
        WriteLn('|1| Crear archivo maestro a partir de un alumnos.txt');
        WriteLn('|2| Crear archivo detalle a partir de un detalle.txt');
        WriteLn('|3| Actualizar el archivo maestro en base al archivo detalle');
        WriteLn('|4| Imprimir en pantalla el archivo maestro');
        WriteLn('|5| Exportar lista de alumnos con mas finales aprobados que cursadas');
        WriteLn('|6| Salir');
        WriteLn();
        Write('Opcion: ');
        ReadLn(opcion);
        case opcion of 
            1:crearArchivoMaestro(maestro);
            2:crearArchivoDetalle(detalle);
            3:actualizarMaestro(maestro,detalle);
            4:imprimirArchivo(maestro);
            5:listarMasFinales(maestro);
            6:WriteLn('| PROGRAMA TERMINADO |');
        end;
        WriteLn();
    end;
end.