program Ejer3;
type
    rangoOpciones = 1..3;
    cadena15 = String[15];
    empleado = record
        num: integer;
        apellido:cadena15;
        nombre:cadena15;
        edad:integer;
        dni:cadena15;
    end;
    archivo_empleados = file of empleado;

function menuOpciones():integer;
var
    num:integer;
begin
    WriteLn();
    WriteLn(' --- Buenas, ingrese el numero segun la opcion que quiera ejecutar ---');
    WriteLn(' 1: Crear y cargar un nuevo archivo de empleados');
    WriteLn(' 2: Mostrar lista de empleados, buscar un empleado y ver lso empleados mayores a 70 años');
    WriteLn(' 3: Salir del programa');
    WriteLn();
    Write('Opcion: ');
    ReadLn(num);
    //if num = rangoOpciones
    menuOpciones:= num;
end;

procedure cargarArchivo(var empleados:archivo_empleados);
var
    emp:empleado;
begin
    WriteLn('----Carga de Archivo-----');
    rewrite(empleados);
    Write('Ingresar apellido: ');
    ReadLn(emp.apellido);
    while (emp.apellido <> 'fin') do begin
        Write('Ingresar nombre: ');
        ReadLn(emp.nombre);
        Write('Ingresar numero de empleado: ');
        ReadLn(emp.num);
        Write('Ingresar dni: ');
        ReadLn(emp.dni);
        Write('Ingresar edad: ');
        ReadLn(emp.edad);
        Write(empleados,emp);
        WriteLn();
        WriteLn('---- Empleado cargado con exito, siguiente empelado -----');
        Write('Ingresar apellido: ');
        ReadLn(emp.apellido);
    end;
    close(empleados);
end;

procedure imprimirEmpleado(emp:empleado);
begin
    WriteLn();
    WriteLn('Nro empleado: ',emp.num);
    WriteLn('Apellido: ',emp.apellido);
    WriteLn('Nombre: ',emp.nombre);
    WriteLn('DNI: ',emp.dni);
    WriteLn('Edad: ',emp.edad);
end;


procedure buscarEmpleadosX(var empleados:archivo_empleados);
var
    aBuscar: cadena15;
    emp:empleado;
    cont:integer;
begin
    cont:=0;
    Write('ingrese nombre o apellido a buscar: ');
    ReadLn(aBuscar);
    Reset(empleados);
    WriteLn();
    WriteLn('--- Se mostraran las ocurrencias ----');
    WriteLn();
    while (not Eof(empleados)) do begin
        Read(empleados,emp);
        if (aBuscar = emp.apellido) or (aBuscar = emp.nombre) then begin
            imprimirEmpleado(emp);
            cont:= cont+1;
        end;
    end;
    if (cont=0) then 
        WriteLn('No se encontro ningna ocurrencia');
    close(empleados);
end;

procedure mostrarEmpleados(var empleados:archivo_empleados);
var
    emp:empleado;
begin
    WriteLn();
    WriteLn('--- Mostrando Empleados ----');
    reset(empleados);
    while (not Eof(empleados)) do begin
        Read(empleados,emp);
        imprimirEmpleado(emp);
    end;
    Close(empleados);
end; 

procedure mayores70(var empleados: archivo_empleados);
var
    emp:empleado;
    cont:Integer;
begin
    Reset(empleados);
    while (not eof(empleados)) do begin
        Read(empleados,emp);
        if (emp.edad > 70) then
            cont:= cont+1; 
            imprimirEmpleado(emp);
    end;
    if (cont=0) then
        WriteLn('No se encontraron empleados mayores a 70 años');
    Close(empleados);
end;


//___Programa Principal 
var
    empleados:archivo_empleados;
    nombre_fisico: cadena15;
    ingreso:Integer;
begin
    ingreso:= menuOpciones();
    while ingreso<>3 do begin
        case ingreso of 
            1:
                begin
                    Write('ingresar nombre del archivo: ');
                    ReadLn(nombre_fisico);
                    Assign(empleados,nombre_fisico);
                    cargarArchivo(empleados);  // cargo el archivo de empleados (corte: apellido "fin")
                end;
            2:
                begin
                    buscarEmpleadosX(empleados);  // punto 'i' busco empleados de x nombre y x apellido
                    mostrarEmpleados(empleados);  // mustro el archivo entero de empleados
                    mayores70(empleados);  // muestro los empleados mayores a 70 años
                end;
        end;
        ingreso:=menuOpciones();
    end;
end.