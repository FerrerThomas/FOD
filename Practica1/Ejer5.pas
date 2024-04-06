program ejer5;

type
    celular = record
        cod: integer;
        nombre:string;
        descripcion:string;
        marca:string;
        precio:real;
        stockMinimo:Integer;
        stockDisponible:integer;
    end;

    archivo_celulares = file of celular;

{procedure leerCelular(var cel:celular);
	begin
		writeln();
		writeln('| Cargargando informacion de un celular |');
		with cel do begin
			write('Nombre: ');
			readln(nombre);
			if (nombre <> 'fin') then begin
                write('Codigo: ');
			    readln(cod);
				write('Descripcion: ');
				readln(descripcion);
				write('Marca: ');
				readln(marca);
				write('Precio: ');
				readln(precio);
				write('Stock Minimo: ');
				readln(stockMinimo);
				write('Stock Disponible: ');
				readln(stockDisponible);
			end;
		end;
		writeln('');
	end;

procedure cargarArCelularesTxT();
	var
		arCelTxT : text;
		c:celular;
	begin
		assign(arCelTxT,'celulares.txt');
		rewrite(arCelTxT);
		writeln('========= SE CARGARA UN ARCHIVO DE CELULARES DE TEXTO ==========');
		leerCelular(c);
		while (c.nombre <> 'fin') do begin
			writeln(arCelTxT,' ',c.cod,' ',c.precio:2:2,' ',c.marca);
			writeln(arCelTxT,' ',c.stockDisponible,' ',c.stockMinimo,' ',c.descripcion);
			writeln(arCelTxT,' ',c.nombre);
            WriteLn('');
			leerCelular(c);
		end;
		close(arCelTxT);
		writeln();
		writeln('=======================================================');
	end;
}
procedure crearArchivo(var celulares:archivo_celulares);
var
    cel:celular;
    carga: Text;
begin
    Assign(carga,'celulares.txt');
    Rewrite(celulares);
    Reset(carga);
    while (not eof(carga)) do begin
        ReadLn(carga,cel.cod,cel.precio,cel.marca);
        ReadLn(carga,cel.stockDisponible,cel.stockMinimo,cel.descripcion);
        ReadLn(carga,cel.nombre);
        Write(celulares,cel);
    end;
    WriteLn('| Se cargo el archivo |');
    Close(carga);
    Close(celulares);
end; 

procedure imprimirCelular(cel:celular);
begin
    WriteLn();
    WriteLn('---- Informacion Celular ----');
    WriteLn('Codigo: ', cel.cod);
    WriteLn('Nombre: ', cel.nombre);
    WriteLn('Marca: ',cel.marca);
    WriteLn('Descripcion: ', cel.descripcion);
    WriteLn('Precio: ', cel.precio:2:2);
    WriteLn('Stock Minimo: ', cel.stockMinimo);
    WriteLn('Stock Disponible: ', cel.stockDisponible);
end;

procedure listarStockMenor(var celulares:archivo_celulares);
var
    cont:Integer;
    cel:celular;
begin
    cont:=0;
    WriteLn('--Celulares con stock actual menor a su stock minimo--');
    Reset(celulares);
    while (not eof(celulares)) do begin
        Read(celulares,cel);
        if (cel.stockDisponible < cel.stockMinimo) then begin
            imprimirCelular(cel);
            cont:= cont+1;
        end;           
    end;
    if (cont = 0) then 
        WriteLn('No hay celular con stock actual menor al minimo');
end;

procedure listarDescripcionBuscar(var celulares:archivo_celulares);
var
    cel:celular;
    cont:integer;
    aBuscar:string;
begin
    cont:=0;
    Write('Ingrese descipcion a buscar: ');
    ReadLn(aBuscar);
    Reset(celulares);
    while (not eof(celulares)) do begin
        Read(celulares,cel);
        if (aBuscar = cel.descripcion) then begin
            imprimirCelular(cel);
            cont:= cont+1;
        end;
    end;
    if (cont = 0) then
        WriteLn('No se encontraron celulares con esa descripcion')
end;

procedure exportarArchivo(var celulares:archivo_celulares);
var
    carga:text;
    cel:celular;
begin
    Assign(carga,'celulares.txt');
    Rewrite(carga);
    Reset(celulares);
    while (not eof(celulares)) do begin
        Read(celulares,cel);
        WriteLn(carga,' ',cel.cod,' ',cel.precio:2:2,' ',cel.marca);
        WriteLn(carga,' ',cel.stockDisponible,' ',cel.stockMinimo,' ',cel.descripcion);
        WriteLn(carga,' ',cel.nombre);
    end;
    Close(celulares);
    close(carga);
end;


function menuOpciones():integer;
var
    num:Integer;
begin
    WriteLn('');
    WriteLn('--- Buenasss, elija la opcion que necesite ---');
    WriteLn('1 | Crear y cargar el archivo con un txt');
    WriteLn('2 | Listar en pantalla los celulares con un stock menor al minimo');
    WriteLn('3 | Listar celulares que contengan descripcion');
    WriteLn('4 | Exportar archivo a txt');
    WriteLn('5 | Salir');
    WriteLn();
    Write('Opcion: ');
    ReadLn(num);
    menuOpciones:= num;
end;

var
    nombre_fisico:string;
    celulares:archivo_celulares;
    opcion:integer;
begin
    //cargarArCelularesTxT();
    WriteLn('');
    opcion:= menuOpciones();
    while opcion <> 5  do begin
        case opcion of 
            1: 
                begin
                    Write('Ingresar nombre del archivo a crear: ');
                    ReadLn(nombre_fisico);
                    Assign(celulares,nombre_fisico);
                    crearArchivo(Celulares);
                end;
            2:
                begin
                    listarStockMenor(celulares);
                end;
            3:
                begin 
                    listarDescripcionBuscar(celulares);
                end;
            4: 
                begin
                    exportarArchivo(celulares);
                end;
            5: WriteLn('| Termino el programa |');
        else
            WriteLn('Opcion no valida');
        end;
        opcion:=menuOpciones();
    end;
    WriteLn('| Termino el programa |');
end.