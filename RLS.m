function[mse] = RLS(u,d,lambda,delta,N)

    M = 11;
    P0 = delta*eye(M);
    P = zeros(M,M,N);
    w = zeros(M,1,N);
    w0 = zeros(M,1);
    u_temp = zeros(M,1);
    lambda_inv = 1/lambda;

    k_arr = zeros(M,1,N);
    alpha = zeros(N,1);
    
    for n = 1:N
        for j = 0:10
            if(n+j<N)
                u_temp(j+1) = u(n+j);
            else
                u_temp(j+1) = 0;
            end
        end
        
        if(n==1)
            k_arr(:,:,n) = (lambda_inv*P0*u_temp)/(1+lambda_inv*u_temp'*P0*u_temp);
            alpha(n) = d(n)-u_temp'*w0;
            w(:,:,n) = w0 + k_arr(:,:,n)*alpha(n);
            P(:,:,n) = lambda_inv*P0-lambda_inv*k_arr(:,:,n)*u_temp'*P0;  
        else
            k_arr(:,:,n) = (lambda_inv*P(:,:,n-1)*u_temp)/(1+lambda_inv*u_temp'*P(:,:,n-1)*u_temp);
            alpha(n) = d(n)-u_temp'*w(:,:,n-1);
            w(:,:,n) = w(:,:,n-1) + k_arr(:,:,n)*alpha(n);
            P(:,:,n) = lambda_inv*P(:,:,n-1)-lambda_inv*k_arr(:,:,n)*u_temp'*P(:,:,n-1);    
        end
    end

    mse = alpha.^2;
end