
function [interv]= difFinitas()


    n=2 ;
    lBit = 0;

    while (lBit == 0)
        count = 0;
        h = 1/n;

        A = zeros(n+1,n+1);
        B = zeros(n+1,1);

        A(1, 1) = 1;
        A(n+1, n+1) = 1;
        A(n+1, n) = -1 

        B(1, 1)= 0
        B(n+1, 1)=h;



        for i=2:1:n

            A(i, i-1) = 1;
            A(i, i) = (h^2) -2; 
            A(i, i+1) =1;

            B(i,1) = ((i-1)^2) * (h^4);


        end


        X = A\B;

        for i=2:1:n+1

            erro = abs(T((i-1)*h) - X(i)) ;  

            if (erro < 0.001 ) then
                count = count + 1; 
            end

        end

        if count == n then

            lBit = 1

        else
            n = n+1
        end

    end

    interv = n+1 ;

endfunction

function[valorT] = T(x)

    valorT = (((2 * cos (x-1) - sin (x)))/ cos(1)) + (x^2) - 2 ;


endfunction


num = difFinitas()

disp("O numero de intervalos para que o erro seja menor que 0.001 é : ");
disp(num);


