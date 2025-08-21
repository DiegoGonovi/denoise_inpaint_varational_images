function [energy,prior,lambda_fidelity]=pEnergy(u,f,lambda,p)
% Calculates TV(u)+lambda*||u-f||^2
dim = size(u);
Omega = dim(1) * dim(2);

ux = gradx(u,'forward'); % mismas funciones que para P1
uy = grady(u,'forward');

modGrad= sqrt(ux.^2+uy.^2 ).^p; 

fi = (u - f).^2;

prior=(1/p)*sum(modGrad(:))/Omega;

%res = sum(fi(:)) / Omega % Partimos por omega todas las energías

%fidelity = 0.5*sum(fi(:))/Omega; % ponerla en función de lambda

lambda_fidelity = sum((lambda(:)).*fi(:))/Omega;

energy= prior+lambda_fidelity;

end

% Si el resiudio supera la varianza del ruido para el algoritmo. el residuo
% es la energía de la fidelidad. 
%if residuo >= var_noise:
 %   disp(['Stoped'])