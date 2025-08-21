%% Esta función calcula la divergencia de una imagen dado su gradiente
function divergencia = div(ux,uy, type)
switch type
    case ' central'
        divergencia = gradx(ux, 'central') + grady(uy, 'central');

    case 'forward'
        divergencia = gradx(ux, 'forward') + grady(uy, 'forward');

    case 'backward'
        divergencia = gradx(ux, 'backward') + grady(uy, 'backward');


% Completar
end