function[mse] = LMS(u,d,miu,N)

    M = 11;
    w0 = zeros(M,1);
    w = zeros(M,1,N);
    alpha = zeros(N,1);
    u_temp = zeros(M,1);

    for n = 1:N
        for j = 0:10
            if(n+j<N)
                u_temp(j+1) = u(n+j);
            else
                u_temp(j+1) = 0;
            end
        end
        if(n==1)
            alpha(n) = d(n)-w0'*u_temp;
            w(:,:,n) = w0 + miu*u_temp*alpha(n);
        else
            alpha(n) = d(n)-w(:,:,n-1)'*u_temp;
            w(:,:,n) = w(:,:,n-1) + miu*u_temp*alpha(n);
        end
    end

    mse = alpha.^2;

end