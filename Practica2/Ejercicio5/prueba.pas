program prueba;
var
    i:integer;
    iss,aux:string;
begin
    i:=3;
    Str(i,iss);
    aux:= 'detalle'+iss+'.txt';
    WriteLn(aux);

end.