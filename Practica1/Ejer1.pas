program Ejer1;
type 
    archivo_numeros = file of integer;
var
    numeros : archivo_numeros;
    num:integer;
    nombre_fisico:string[15];
begin
    write('ingresar nombre del archivo: ');
    read(nombre_fisico);
    assign(numeros, nombre_fisico);
    rewrite(numeros);
    write('ingrese un numero: ');
    readln(num);
    while (num<>30000) do begin
        write(numeros,num);
        write('ingrese un numero: ');
        readln(num);
    end;
    close(numeros);
end.