program Ejer1;

const   
    valorAlto=9999;
type
    cadena = String[20];
    empleado = record
        codigo:integer;
        nombre:cadena;
        monto:real;
    end;

    archivo_empleados = file of empleado;

//cargo el archivo empleados (el archivio detalle)
procedure cargarArchivo(var empleados: archivo_empleados);
var
    carga:Text;
    emp:empleado;
begin
    Writeln('Ingresar nombre del archivo a cargar: ');
    Assign(carga,'empleados.txt');
    Rewrite(empleados);
    Reset(carga);
    while(not Eof(carga)) do begin
        ReadLn(carga, emp.codigo);
        ReadLn(carga, emp.nombre);
        ReadLn(carga, emp.monto);
        Write(empleados,emp);
    end;
    WriteLn('| Archivo cargado |');
    Close(carga);
    Close(empleados);
end;

//imprimo el archivo empleado (el detalle)
procedure imprimirArchivo(var empleados:archivo_empleados);
var
    emp:empleado;
begin
    Reset(empleados);
    while (not Eof(empleados)) do begin
        Read(empleados,emp);
        WriteLn('Codigo: ',emp.codigo);
        WriteLn('Nombre: ',emp.nombre);
        WriteLn('Monto: ',emp.monto:2:2);
        WriteLn('------------------')
    end;
    Close(empleados);
end;

// leo un empleado del detalle, si es el final devuelvo el corte, sino devuelvo el empleado
procedure leer(var empleados:archivo_empleados; var emp:empleado);
begin
    if (not Eof(empleados)) then 
        Read(empleados,emp) 
    else
        emp.codigo:= valorAlto;
end;


var
    nameFisico:cadena;
    maestro,empleados:archivo_empleados;
    act,regDetalle,regMaestro:empleado;
    total:real;
begin
    Writeln('Ingresar nombre del archivo a crear');
    nameFisico:=('archivoEmpleados');
    Assign(empleados, nameFisico);
    cargarArchivo(empleados);
    imprimirArchivo(empleados);
    WriteLn('| Creo el maestro |');
    Assign(maestro,'primerMestro');
    Rewrite(maestro);
    reset(empleados);
    leer(empleados, regDetalle);
    while (regDetalle.codigo <> valorAlto) do begin
        total:=0; //acumulador de monto por empleado
        act:=regDetalle;
        while (act.codigo = regDetalle.codigo) do begin
            total:= total + regDetalle.monto;
            leer(empleados,regDetalle);
        end;
        regMaestro.codigo:= act.codigo;
        regMaestro.nombre:= act.nombre;
        regMaestro.monto:= total;
        Seek(maestro,FilePos(maestro));
        Write(maestro,regMaestro);
        WriteLn('| Empleado cargado |');
    end;
    WriteLn();
    imprimirArchivo(maestro);
end. 