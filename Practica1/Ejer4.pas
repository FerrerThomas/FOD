program Ejer4;
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
    WriteLn(' 3: Agregar empleados al archivo');
    WriteLn(' 4: Modificar edad de un empleado');
    WriteLn(' 5: Exportar Archivo en formato de texto');
    WriteLn(' 6: Exportar a “faltaDNIEmpleado.txt” los empleados con dni 00 en formato texto');
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
    cont:=0;
    Reset(empleados);
    while (not eof(empleados)) do begin
        Read(empleados,emp);
        if (emp.edad > 70) then begin
            cont:= cont+1; 
            imprimirEmpleado(emp);
        end;
    end;
    if (cont=0) then
        WriteLn('No se encontraron empleados mayores a 70 años');
    Close(empleados);
end;

procedure agregarAlArchivo( var empleados:archivo_empleados; empNuevo:empleado);
var
    existe:Boolean;
    emp:empleado;
begin
    Reset(empleados);
    existe:=false;
    while (not eof(empleados) and (not existe)) do begin
          read(empleados,emp);
          if (emp.num = empNuevo.num) then
                existe:=true;
    end;
    if (not existe) then begin
        Write(empleados,empNuevo);
    end;
    close(empleados);
end;

procedure agregarEmpleado(var empleados: archivo_empleados);
var
    emp:empleado;
    cant,cont:integer;
begin
    cont:=0;
    WriteLn('    -- Empieza la carga de Empleados --');
    WriteLn('Cuantos empleados quiere agregar? ');
    ReadLn(cant);
    WriteLn();
    while  cont < cant do begin
        WriteLn('-- Lectura de empleado --');
        Write('Ingresar apellido: ');
        ReadLn(emp.apellido);
        Write('Ingresar nombre: ');
        ReadLn(emp.nombre);
        Write('Ingresar numero de empleado: ');
        ReadLn(emp.num);
        Write('Ingresar dni: ');
        ReadLn(emp.dni);
        Write('Ingresar edad: ');
        ReadLn(emp.edad);
        WriteLn();
        agregarAlArchivo(empleados,emp);
        cont:= cont +1;
    end;
end;

procedure modificarEdadEmpleado(var empleados:archivo_empleados);
var
    numBuscar,edadNueva:integer;
    existe:Boolean;
    emp:empleado;
begin
    existe:=false;
    WriteLn();
    Write('Ingrese el numero de empleado a cambiar edad: ');
    ReadLn(numBuscar);
    Write('Ingrese la nueva edad: ');
    ReadLn(edadNueva);
    Reset(empleados);
    while (not eof(empleados) and (not existe)) do begin
        read(empleados,emp);
        if(emp.num = numBuscar) then
            existe:=true;
            emp.edad:= edadNueva;
            Seek(empleados,FilePos(empleados)-1);
            Write(empleados,emp);
            WriteLn('Empleado encontrado y modificado');
    end;
    if (not existe) then
      WriteLn('No existe empleado con ese numero');
    Close(empleados);
end;

procedure exportarArchivoTxt(var empleados:archivo_empleados);
var
    atxt: TextFile;
    emp:empleado;
begin
    WriteLn();
    WriteLn('Cargando archivo de texto de empleados');
    Assign(atxt, 'empleaditos.txt');
    Rewrite(atxt);
    Reset(empleados);
    WriteLn('Cargando archivo de texto de empleados');
    while (not eof(empleados)) do begin
        Read(empleados,emp);
        with emp do begin
			writeln(atxt,' ',num,' ',apellido,' ',nombre,' ', edad,' ', dni);
        end;
    end;
    close(empleados);
    Close(atxt);
end;

procedure exportarDniFallaTxt(var empleados:archivo_empleados);
var 
    txtDniFalla:TextFile;
    emp:empleado;
    cont:integer;
begin
    cont:=0;
    WriteLn();
    WriteLn('Cargando archivo de texto de empleados sin DNI ');
    Assign(txtDniFalla,'fallaDniEmpleado.txt');
    Rewrite(txtDniFalla);
    Reset(empleados);
    while (not eof(empleados)) do begin
        Read(empleados,emp);
        if (emp.dni = '00') then begin
            with emp do begin
			    writeln(txtDniFalla,' ',num,' ',apellido,' ',nombre,' ', edad,' ', dni);
            end;
            cont:=cont+1;
        end;
    end;
    close(empleados);
    Close(txtDniFalla);
    if (cont=0) then 
        WriteLn('No se encontraron empleados con DNI 00');
end;

//___Programa Principal 
var
    empleados:archivo_empleados;
    nombre_fisico: cadena15;
    ingreso:Integer;
begin
    ingreso:= menuOpciones();
    while ingreso <> 7 do begin
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
                    writeln();
					write('Ingrese el nombre del archivo a procesar: ');
					readln(nombre_fisico);
					assign(empleados,nombre_fisico);
                    mostrarEmpleados(empleados);  // mustro el archivo entero de empleados
                    buscarEmpleadosX(empleados);  // punto 'i' busco empleados de x nombre y x apellido
                    mayores70(empleados);  // muestro los empleados mayores a 70 años
                end;
            3:
                begin
                    agregarEmpleado(empleados);
                end;
            4:
                begin
                    modificarEdadEmpleado(empleados);
                end;
            5: 
                begin
                    exportarArchivoTxt(empleados);
                end;
            6:
                begin
                    exportarDniFallaTxt(empleados);
                end;
            7: WriteLn('Cerrando prorgrama');
        end;
        ingreso:=menuOpciones();
    end;
end.