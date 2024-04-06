program Ejer2;
type
     archivo_numeros = file of integer;
var
    x, cantMenores, cantTotal,cantNum:integer;
    promedio:real;
    numeros:archivo_numeros;
    nombre_fisico:string[15];
begin
    cantMenores:=0;
    cantTotal:=0;
    cantNum:=0;
    Write('ingrese el nombre del archivo a procesar: ');
    ReadLn(nombre_fisico);
    Assign(numeros,nombre_fisico);
    Reset(numeros);
    while not Eof(numeros) do begin
        read(numeros,x);
        write(' ',x);
        if (x<1500) then begin
          cantMenores:= cantMenores+1;
        end;
        cantNum:=cantNum+1;
        cantTotal:= cantTotal + x;
    end;
    Close(numeros);
    promedio:= (cantTotal/cantNum);
    WriteLn('');
    WriteLn('Cantidad de numeros menos a 1500: ', cantMenores);
    WriteLn('Promedio de los numeros ingresados: ', promedio:2:2);
end.