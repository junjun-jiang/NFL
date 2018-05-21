function [M M2] = dis_matrix_point_linear_SYN(A,B,p)
% clc
% clear all
% p = rand(13007,1);
% A = rand(13007,500);
[m n] = size(A);
num = 0;
M = [];
M2 = [];
for i = 1:n
    for j = 1:n
      if i <j
          
        num = num + 1;
        a = A(:,i);
        b = A(:,j);
        Y = [b-a];
        F = pinv(Y'*Y)*Y'*(p-a);
        S = Y*F+a;
        d = (S-p)'*(S-p);
        M(:,num) = [i; j; d; S];

        a = B(:,i);
        b = B(:,j);
        Y = [b-a];
%         F = pinv(Y'*Y)*Y'*(q-a);
        S2 = Y*F+a;
        M2 = [M2 S2];
      end
    end
end


