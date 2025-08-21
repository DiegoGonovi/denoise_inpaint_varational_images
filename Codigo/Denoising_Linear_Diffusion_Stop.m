%-------------------------------------------------------------------------%
function [varout] = Denoising_Linear_Diffusion_Stop(varin)
%-------------------------------------------------------------------------%
%                            Initializations                              %
%-------------------------------------------------------------------------%
f       = varin.f;      % Imagen ruidosa de entrada
u       = f;            % Condición inicial (u será la imagen restaurada)
lambda  = varin.lambda; % Hiperparámetro de fidelidad
Nit     = varin.Nit;    % Número máximo de iteraciones
dt      = varin.dt;     % Tamaño de paso
Verbose = varin.Verbose;% Nivel de información de salida
p       = varin.p;

% Criterio de parada
StopCriteria_energy = 1e-7;  % Umbral de cambio en la energía total
prev_energy = Inf;           % Energía inicial infinita para comparación

% Para verbose en modo 2
if Verbose == 2
    figure;
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.15, 0.3, 0.7, 0.4]);
end

%-------------------------------------------------------------------------%
%                               Algorithm                                 %
%-------------------------------------------------------------------------%
for iter = 1:Nit
    % Calcular energía total
    [en(iter), pr(iter), fi(iter)] = pEnergy(u,f,lambda,p);

    % Verbose
    switch Verbose
        case 0
            disp(['Iter: ', num2str(iter)]);
        case 1
            disp(['Iter: ', num2str(iter), ...
                ' Total Energy: ', num2str(en(iter)), ...
                ' Prior: ', num2str(pr(iter)), ...
                ' Fidelity: ', num2str(fi(iter)) ]);
        case 2
            subplot(121), imshow(u);
            subplot(122), plot(en, 'r'), hold on, plot(fi, 'b'), plot(pr, 'g');
            legend('Total Energy', 'Fidelity', 'Prior'), grid on;
            pause(0.01);
    end

    % Algoritmo
    ux = gradx(u, 'forward');
    uy = grady(u, 'forward');
    lap = div(ux, uy, 'backward');
    grad_func = -lap + lambda * (u - f);

    % Descenso
    u = u - dt * grad_func;

    % Criterio de parada basado en la energía total
    if iter > 1
        diff_energy = abs(en(iter) - prev_energy);
        if diff_energy < StopCriteria_energy
            disp(['Convergencia alcanzada en iteración ', num2str(iter)]);
            break;
        end
    end

    % Actualizar energía previa para la próxima iteración
    prev_energy = en(iter);
end

%-------------------------------------------------------------------------%
%                              Output                                     %
%-------------------------------------------------------------------------%
varout.u = u;
if Verbose > 0
    varout.en = en;
    varout.pr = pr;
    varout.fi = fi;
end
end
