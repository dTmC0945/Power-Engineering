% ========================= BEGIN CODE ====================================

clc                                  % clear screen
clear variables                     % clear all the varibles

% Variables ---------------------------------------------------------------

Bmax    = 1;                        % Normalize Bmax to 1
f       = 50;                       % Frequency in Hz
T       = 1/f;                      % Time Period in seconds
omega   = 2*pi*f;                   % Angluar velocity (rad/s)
cycle   = 1;                        % Number of cycles to be plotted
phase   = 4;                        % Number of Phases of the field

% Creating the three component magnetic fields ----------------------------

t = 0:T/80:cycle*T;          % Time for five cycle of selected frequency

% Memory Allocation -------------------------------------------------------

Bnet    = zeros(1,length(t));
Bplot   = zeros(phase,length(t));
Bref    = zeros(phase,length(t));
B       = zeros(phase,length(t));

% Drawing the inner (phase Bnet) and outer (sum Bnet) circle boundaries ---

outerCircle = phase/2 * (cos(omega*t) + 1j*sin(omega*t));
innerCircle =       1 * (cos(omega*t) + 1j*sin(omega*t));

% Plotting the circles ----------------------------------------------------

h1  = subplot(1,2,1);

plot(outerCircle,'LineWidth',0.5,'Color',[0, 0, 0]./255);   hold on;
plot(innerCircle,'LineWidth',0.5,'Color',[0, 0, 0]./255);

% Calculation of the Magnetic Fields --------------------------------------

if mod(phase,2) ~= 0

    for i = 1:1:length(t)

        for s = 1:1:phase              % Phase A magnetic field along its axis aa'
            
            B(s,i) = sin(omega.*t(i) + 2*(s-1).*pi./phase)...
                 .* (cos(2*(s-1).*pi./phase) + 1j.*sin(2*(s-1).*pi./phase));
            
            Bref(s,i) = phase/2 ...
                 .* (cos(2*(s-1).*pi./phase) + 1j.*sin(2*(s-1).*pi./phase));
        end
        
        Bnet(i) = sum(B(:,i));

    end
    
else
    
    for i = 1:1:length(t)
        
        for s = 1:1:phase   % Phase A magnetic field along its axis aa'
            
            B(s,i) = sin(omega.*t(i) + (s-1).*pi./phase)...
                .* (cos((s-1).*pi./phase) + 1j.*sin((s-1).*pi./phase));
            
            Bref(s,i) = phase/2 ...
                .* (cos((s-1).*pi./phase) + 1j.*sin((s-1).*pi./phase));
        
        end
        
        Bnet(i) = sum(B(:,i));

    end
end

% Plotting the per-phase magnitude of B-Fields ----------------------------

for ph = 1:1:phase
    
    line('XData',[0 real(Bref(ph))], ...
         'YData',[0 imag(Bref(ph))], ...
         'LineStyle','--','Linewidth', 1.0);

    line('XData',[-real(Bref(ph)) 0], ...
         'YData',[-imag(Bref(ph)) 0], ...
         'LineStyle','--','Linewidth', 1.0);

    drawnow 
end

for ph = 1:1:phase
    
    h(ph)=line('XData',[0 real(B(ph,1))], ...
               'YData',[0 imag(B(ph,1))], ...
               'Linewidth',3.0);
    drawnow

end

hnet=line('XData',[0 real(Bnet(1))], ...
          'YData',[0 imag(Bnet(1))], ...
          'Linewidth',3.0);

axis square;

for s = 1:length(t)

    for ph = 1:1:phase
        set(h(ph),'XData',[0 real(B(ph,s))]);
        set(h(ph),'YData',[0 imag(B(ph,s))]);
        hold on
        drawnow ;
        
    end

    set(hnet,'XData',[0 real(Bnet(s))]);
    set(hnet,'YData',[0 imag(Bnet(s))]);
    drawnow;
    
end

% Nice plot code ----------------------------------------------------------

set(gca, ...
    'TickLabelInterpreter'  , 'latex'               , ...
    'Fontsize'              , 16                    , ...
    'TickDir'               , 'in'                  , ...
    'TickLength'            , [.02 .02]             , ...
    'XMinorTick'            , 'on'                  , ...
    'YMinorTick'            , 'on'                  , ...
    'XGrid'                 , 'on'                  , ...
    'YGrid'                 , 'on'                  , ...
    'XTick'                 , -phase:phase/2:phase  , ...
    'YTick'                 , -phase:phase/2:phase  , ...
    'GridLineStyle'         , '--'                  , ...
    'GridColor'             , [0,0 ,0]./255         , ...
    'TickDir'               , 'out'                 , ...
    'Box'                   , 'off'                 , ...
    'LineWidth'             , 1.5                   );
% -------------------------------------------------------------------------

ylabel('Flux Density (T)','Interpreter','Latex');
xlabel('Flux Density (T)','Interpreter','Latex');

xlim([- phase/2, phase/2]); ylim([- phase/2, phase/2]);     hold off;

% -------------------------------------------------------------------------

h2 = subplot(1,2,2);

if mod(phase,2) ~= 0
    for i = 1:length(t)
        for ph = 1:phase
            Bplot(ph,i)= sin(omega.*t(i) + 2*(ph-1).*pi./phase);
        end
       
    end
else
    for i = 1:length(t)
        for s = 1:phase
            Bplot(s,i)= sin(omega.*t(i) + (s-1).*pi./phase);
        end
    end
end


%plot(abs(Bnet(1,:)),'Linewidth',2);

% Nice plot code ----------------------------------------------------------

set(gca, ...
    'TickLabelInterpreter'  , 'latex'               , ...
    'Fontsize'              , 16                    , ...
    'TickDir'               , 'in'                  , ...
    'TickLength'            , [.02 .02]             , ...
    'YMinorTick'            , 'on'                  , ...
    'YTick'                 , -phase:0.5:phase      , ...
    'XGrid'                 , 'on'                  , ...
    'XMinorGrid'            , 'on'                  , ...
    'YGrid'                 , 'on'                  , ...
    'YMinorGrid'            , 'on'                  , ...
    'GridLineStyle'         , '--'                  , ...
    'GridColor'             , [228,234 ,246]./255   , ...
    'TickDir'               , 'out'                 , ...
    'Box'                   , 'off'                 , ...
    'LineWidth'             , 1.5                    );

% -------------------------------------------------------------------------

xlabel('Time(sec)','Interpreter','Latex');

%axis([0 i*T -2 2]);

xlim([1 length(t)])
ylim([-phase/2 phase/2])
axis square

heap = animatedline;

for ph = 1:1:phase
    for i = 1:1:length(t)
        addpoints(heap,t(1,i),Bplot(ph,i));
        drawnow 
    end
        hold on
        %addpoints(heap,t(1,i),abs(Bnet(1,i)))
        %drawnow

end
%legend('$\mathrm \bf{B}_{aa}$','B_bb','B_cc','B_net','Location','bestoutside','Interpreter','Latex')


% ======================== END OF CODE ====================================