function [M, XR, ER, Iter] = ReglaFalsaFcn(f, xl, xu, Niter, Tol)
% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:
 
% f = función como un identificador de función (function handle) 
%   ej. @(x) cos(x)
% xl = Límite inferior. Este dato es un escalar.
% xu = Límite superior. Este dato es un escalar.
% Niter = Número de iteraciones.
% Tol = Tolerancia para el criterio de convergencia a superar o igualar en
% porcentaje.
 
% VARIABLES DE SALIDA:
 
% M = Tabla de resultados {'xl', 'xr', 'xu', 'f(xl)', 'f(xr)', 'f(xu)', 'Error relativo (%)'}
% XR = Ultima iteración de la raíz de la función.
% ER = Ultima iteracion del error relativo.
% Iter = Número de iteraciones
 
%METODOS DE SOLUCION
 
%Método 1: Si Niter está vacío (Niter = []) entonces se debe especificar un
%error relativo mínimo para converger.
%Método 2: Si Tol está vacío (Tol = []) entonces se debe especificar un
%número máximo de iteraciones para el código. Es posible que un número muy
%grande de iteraciones cree un error y un mensaje aparecerá sugiriendo
%reducir el número de iteraciones.
 
%Si se ingresan menos de tres datos de entrada...
if nargin < 5                 
    error('Se necesita definir una función, un intervalo a evaluar, un número máximo de iteraciones y un error relativo mínimo');
%Si se ingresan todos los datos de entrada, elegir un método de solución
else                          
    if  isempty(Niter) == 1  
        metodo = 1;
        Niter = 1000;
        disp(newline);
        disp('Solución por error relativo mínimo para converger');
    elseif isempty(Tol) == 1
        metodo = 2;
        disp(newline);
        disp('Solución por número máximo de iteraciones para converger');
    elseif isempty(Niter) == 0 && isempty(Tol) == 0
        error('Niter y Tol no pueden tener un dato de entrada al mismo tiempo, uno de los dos debe estar vacío (ejemplo: Niter = [])');
    end
end
 
fxl = f(xl); %Punto en Y para el límite inferior.
fxu = f(xu); %Punto en Y para el límite superior.
 
if fxl * fxu > 0 %Esta propiedad es la que hace que éste sea un método cerrado.
    error('No hay una raíz en ese intervalo!'); 
end
 
for i = 1:Niter - 1
    xr(i) = xu(i) - fxu(i) * ((xu(i) - xl(i)) / (fxu(i) - fxl(i))); %Calcula el punto medio falso actual.
    fxr(i) = f(xr(i)); %Evalua la función en el punto medio falso actual.
    
    if f(xr(i)) * f(xl(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xl y xr
        xl(i+1) = xr(i); %El punto medio es el nuevo límite inferior.
        xu(i+1) = xu(i); %El límite superior se mantiene igual.
        fxl(i+1) = f(xl(i+1));
        fxu(i+1) = f(xu(i+1));
    elseif f(xr(i)) * f(xu(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xr y xu
        xu(i+1) = xr(i); %El punto medio es el nuevo límite superior.
        xl(i+1) = xl(i); %El límite inferior se mantiene igual.
        fxl(i+1) = f(xl(i+1));
        fxu(i+1) = f(xu(i+1));
    end
    %Asegurarse de que si Niter es muy grande aparezca una alerta.
    try
        xr(i+1)=xu(i+1)-fxu(i+1)*((xu(i+1)-xl(i+1))/(fxu(i+1)-fxl(i+1))); %Actulizamos el punto medio falso y su punto en Y
    catch
        error('Intenta un número menor de iteraciones');
    end
    
    fxr(i+1)=f(xr(i+1));
    Error(i+1)=abs((xr(i+1)-xr(i))/xr(i+1))*100; %Calcula el error relativo actual
    
    if metodo == 1
        if Error(i+1) < Tol %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
            break;
        end
    end
end
 
M1 = {'xl', 'xr', 'xu', 'f(xl)', 'f(xr)', 'f(xu)', 'Error relativo (%)'};
M2 = num2cell([xl', xr', xu', fxl', fxr', fxu', Error']);
M = [M1; M2];
XR = xr(end);
ER = Error(end);
Iter = i+1;
 
%Evaluar la función con la raíz aproximada y mensaje de resumen.
Resultado = f(XR);
disp(['Evaluando la función ' func2str(f) ' con ' num2str(XR) ', el resultado es: ' num2str(Resultado)]);
disp(['Error relativo (%): ' num2str(ER)]);
disp(['Número de iteraciones: ' num2str(Iter)]);


CORRIDA DEL PROGRAMA

[M, XR, ER, Iter] = ReglaFalsaFcn(@(x) -0.9*x^2 +1.7*x +2.5 , 0, 2.9, [],0.0001 )


Solución por error relativo mínimo para converger
Evaluando la función @(x)-0.9*x^2+1.7*x+2.5 con 2.8601, el resultado es: 4.5227e-09
Error relativo (%): 4.404e-06
Número de iteraciones: 5

M =

  6×7 cell array

  Columns 1 through 4

    {'xl'               }    {'xr'               }    {'xu'               }    {'f(xl)'                }
    {[                0]}    {[2.747252747252747]}    {[2.900000000000000]}    {[    2.500000000000000]}
    {[2.747252747252747]}    {[2.858906468275884]}    {[2.900000000000000]}    {[    0.377671778770681]}
    {[2.858906468275884]}    {[2.860092056101485]}    {[2.900000000000000]}    {[    0.004129421154282]}
    {[2.860092056101485]}    {[2.860104278237701]}    {[2.900000000000000]}    {[4.258293518688561e-05]}
    {[2.860104278237701]}    {[2.860104404195804]}    {[2.900000000000000]}    {[4.388498515695005e-07]}

  Columns 5 through 7

    {'f(xr)'                }    {'f(xu)'             }    {'Error relativo (%)'   }
    {[    0.377671778770681]}    {[-0.139000000000000]}    {[                    0]}
    {[    0.004129421154282]}    {[-0.139000000000000]}    {[    3.905469530469545]}
    {[4.258293518688561e-05]}    {[-0.139000000000000]}    {[    0.041452785516849]}
    {[4.388498515695005e-07]}    {[-0.139000000000000]}    {[4.273318392265046e-04]}
    {[4.522656027461380e-09]}    {[-0.139000000000000]}    {[4.403968710863804e-06]}


XR =

   2.860104404195804


ER =

     4.403968710863804e-06


Iter = 5
