%% -----------------Fundamentos Matemáticos - MUVA 2023----------------- %%
%                       Denoising - Linear Diffusion                      %
% I. Ramirez, E. Schiavi                                                  %
% URJC - Madrid 2023                                                      %
%%-----------------------------------------------------------------------%%
function [varout]= Denoising_Linear_Diffusion(varin)
%-------------------------------------------------------------------------%
%                             STOP Criteria                               %
%-------------------------------------------------------------------------%
StopCriteria_u = 1e-6;
StopCriteria_e = 1e-6;
%-------------------------------------------------------------------------%
%                            Initializations                              %
%-------------------------------------------------------------------------%
f       = varin.f; % me cojo la f de entrada
u       = f; % das la cond. inicial del preoces de difusión, la u es lo 
% quiero y la f es la img mala

lambda  = varin.lambda; % hiperparámetro que me dice cuánto me creo 
% los datos

Nit     = varin.Nit; % num. de iteraciones
dt      = varin.dt;
im_org  = varin.im_org;
Verbose = varin.Verbose;
p       = varin.p;


if Verbose == 2 
    figure, % te muestro una figura que me dice cómo bajan las energías, 
    % el proceso ...
    set(gcf, 'Units', 'Normalized', 'OuterPosition', ...
        [0.15, 0.3, 0.7, 0.4]);
end

%-------------------------------------------------------------------------%
%                               Algorithm                                 %
%-------------------------------------------------------------------------%
for iter=1:Nit % me haces todas las iteraciones que te diga, no para antes
    % Verbose
    switch Verbose % verbose 0 te da la iteración en la que estas
        case 0
            disp(['Iter: ',num2str(iter)])

        case 1 % si 1, más información
            % tmb me da inf de la psnr, esta pnsr está comparándolo con la
            % imagen verdader, y tú en la vida real no la tienes. 
            % se valora criterios de paradas distintos donde no se vea
            % influido la pnsr. 
            [en(iter),pr(iter),fi(iter)] = pEnergy(u,f,lambda,p);
            psnr(iter) = PSNR(u,im_org);
            disp(['Iter: ',num2str(iter),' PSNR: ', num2str(psnr(iter)), ...
                ' Total Energy: ', num2str(en(iter)), ...
                ' Prior: ', num2str(pr(iter)), ...
                ' Fidelity: ',num2str(fi(iter)) ])
        case 2
            [en(iter),pr(iter),fi(iter)] = pEnergy(u,f,lambda,p);
            psnr(iter) = PSNR(u,im_org);
            subplot(131), imshow(u)
            subplot(132), plot(en,'r'), hold on,plot(fi,'b'),plot(pr,'g')
            legend('Total Energy','Fidelity','Prior'), grid on
            subplot(133), plot(psnr,'c'), legend('PSNR (db)'), grid on
            pause(0.01)
    end
%----------------------------- Completar ---------------------------------%

    % Algoritmo
    % forword en la primera derivada, luego backword en la segunda y así
    % forzamos un central en el laplaciano
    ux = gradx(u, 'forward');
    uy = grady(u, 'forward');

    % Laplaciano   
    lap = div(ux, uy, 'backward');

    % ahora el gradiente del funcional
    grad_func = -lap + lambda*(u - f); % No lo igualo a cero, sino que 
    % lo relajo y lo igualo a lap + lambda( f - u);

    % Descenso
    u  = u - dt * grad_func;   % el delta por gradiente de funcional
    
%----------------------------- Completar ---------------------------------%
end
% Variables de salida
if Verbose == 0
    varout.u        = u;
else
    varout.u        = u;
    varout.en       = en;
    varout.pr       = pr;
    varout.fi       = fi;
    varout.psnr     = psnr;
end
end

