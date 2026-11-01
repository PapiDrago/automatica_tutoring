clc % clear the Command Window
clear % clear the Workspace
close all % close all figures

%% Esercitazione 1

%% 1)Creare il sistema massa-molla lineare descritto in variabili di stato,
% utilizzando la funzione ss()
% First notice that the state is composed of two elements:
% x1 is the position p of the cart
% x2 is the velocity p_dot of the cart
% The state space representation of the system is obtained by the dynamics
% equations.
% The cart is indeed subject to the elastic force F_m exerted by the spring
% and by the dynamic friction F_p exerted by the dumper.
% Also there is an external force F which is the input u
% of the system.
% Newton's second law is mp_dot_dot = F + F_m + F_p =
% = F - kp - hp_dot.
% From the second law we can obtain the state equation for
% the velocity: x2_dot = -h/m * x2 - k/m * x1 + 1/m * u
% The state equation for the position x1 is x1_dot = x2.
% Since the differential equations presents the state
% having degree equals to 1 then the system is linear.
% Also the equations does not depend directly on time,
% thus the system is time invariant.
% Of course it is a continuous system.

k = 0.33; % k is the elastic constant
h = 1.1; % h is dumping coefficient measured in N*s/
m = 1; % m is the mass of the cart measured in kg

% x1_dot = x2
% x2_dot = - k/m * x1 - h/m * x2 + 1/m * u

% We want to describe the system in matricial form in order to
% use the state-space model returned by the ss function
% which wants as input the matrices A, B, C, D.
% x_dot = Ax+Bu
% y = Cx+Du, y is chosen to be the posistion x1: y = x1

A = [0 1;
    -k/m -h/m];
B = [0;
     1/m];
C = [1 0];
D = 0;

sys = ss(A, B, C, D);

%Q1
% We need just to set C as C = [0 1]

C_2 = [0 1];

sys_2 = ss(A, B, C_2, D);

%% 2 e 3) Data la condizione iniziale x(0) = [1 0]′ studiare il movimento
% libero del sistema, utilizzando la funzione initial().
x0 = [1; 0];
t_f = 100;

[y, t_out, x] = initial(sys, x0, t_f);

plot(t_out, y), xlabel("Time [s]"), ylabel("x1 [m]")
%keyboard

plot(t_out, x);
title("State trajectories x(0)=[1; 0]"), xlabel('Time [s]'), ylabel('States'),
legend('x1', 'x2')

% Let's note that initial returns the unforced (initial) response of the
% output from the initial state (what is stored in y) and also the state
% trajectories. Additionally also a time vector that it is in the
% time units of sys. This is useful because then plot does
% an interpolation of points.

% From the trajectory plot is clear that we move from an equilibrium
% to another one. The initial one is clearly unstable because
% when we let the state evolve it moves without any input to a new stable
% equilibrium point. Physically this does make sense because in the new
% equilibrium point the cart is at rest. In the initial state the elongated
% spring exerted an elastic force to bring the cart in the rest position in the
% spring is neither compressed nor elongated.

x0_2 = [1; 1];
x0_3 = [0 0]';

[y2, t_out_2, x2] = initial(sys, x0_2, t_f);
[y3, t_out_3, x3] = initial(sys, x0_3, t_f);

plot(t_out_2, x2);
legend('x1', 'x2')
title("State trajectories x(0)=[1; 1]"), xlabel('Time [s]'), ylabel('States')
%keyboard

% With this starting condition the velocity is not 0 at the beginning, thus
% the cart keeps on moving farther. However the negative acceleration is
% decreasing the velocity. At some point the velocity becomes negative and
% then the cart keeps on moving towards the rest position.


plot(t_out_3, x3);
legend('x1', 'x2')
title("State trajectories x(0)=[0; 0]"), xlabel('Time [s]'), ylabel('States')
%keyboard

% The carts starts from the stable equilibrium, it just stays there since
% there is no reason for it to move.

%% 4) Dato un impulso unitario, studiare il movimento forzato del sistema,
% utilizzando la funzione impulse()
[y_f, tf, xf] = impulse(sys, t_f);

plot(tf, y_f), xlabel('Time [s]'), ylabel('y [m]'), title('Output Forced movement')
close all

plot(tf, xf);
title("State trajectories under unitary impulse"), xlabel('Time [s]'), ylabel('States'),
legend('x1', 'x2')

% The velocity is 1 at t = 0, then the system just follows the free
% movement because the impulse is present just in t = 0.

close all
clear


%%Esercitazione 2

%% 1) Creare il sistema massa-molla lineare descritto in variabili di stato,
% utilizzando la funzione ss.

k = 0.33;
h = 1.1;
m = 1;

A = [0, 1; -k/m, -h/m];
B = [0
    1/m];
C = [1 0];
D = 0;

sys = ss(A, B, C, D);
t = linspace(0,40,1000);
%% Si tracci il grafico del movimento libero degli stati per la condizione
% iniziale x(0) = [1 0]′, e se ne discuta l'andamento in funzione
% degli autovalori del sistema, al variare del coefficiente h di smorzamento,
% con h = [0, 0.25, 0.5, 0.75, 1, 1.5, 2]

h_vec = [0, 0.25, 0.5, 0.75, 1, 1.5, 2];
sz = size(h_vec);
x0 = [1
    0];

figure(1)
ax1 = subplot(1,2,1); hold(ax1, 'on')
ax2 = subplot(1,2,2); hold(ax2, 'on')

title(ax1, "Movimento libero della posizione al variare di h"), xlabel(ax1, ...
    "Time [s]"), ylabel(ax1,'x1 [m]')
title(ax2, "Movimento libero della velocita' al variare di h"), xlabel(ax2, ...
    "Time [s]"), ylabel(ax2,'x2 [m/s]')


for i = 1:sz(2)
    h = h_vec(i);
    A = [0, 1; -k/m, -h/m];
    sys = ss(A, B, C, D);
    [y_lib, t_lib, x_lib] = initial(sys, x0, t);
    eigenv = eigs(A);
    plot(ax1, t_lib, x_lib(:,1), 'DisplayName', sprintf('h = %g, eig(1) = %f, eig(2) = %f', h, eigenv(1), eigenv(2)))
    plot(ax2, t_lib, x_lib(:,2), 'DisplayName', sprintf('h = %g, eig(1) = %f, eig(2) = %f', h, eigenv(1), eigenv(2)))
    drawnow

end
legend(ax1, 'show')
legend(ax2, 'show')

%% 3. Si tracci il grafico del movimento forzato dell'uscita del sistema
% in risposta ad un impulso unitario, al variare del coefficiente h di
% smorzamento, con h = [0, 0.25, 0.5, 0.75, 1, 1.5, 2]

figure(2)
ax1 = subplot(1,1,1); hold(ax1, 'on')
title(ax1, "Movimento forzato della posizione al variare di h"), xlabel(ax1, ...
    "Time [s]"), ylabel(ax1,'y [m]')

for i = 1:sz(2)
    h = h_vec(i);
    A = [0, 1; -k/m, -h/m];
    sys = ss(A, B, C, D);
    [y_for, t_for] = impulse(sys, t);
    eigenv = eigs(A);
    plot(ax1, t_for, y_for, 'DisplayName', sprintf('h = %g, eig(1) = %f, eig(2) = %f', h, eigenv(1), eigenv(2)))
    drawnow

end
legend(ax1, 'show')

%% 4. Sollecitare il sistema massa-molla con un treno di impulsi di
% ampiezza K e periodo ∆t, con K = 2 e ∆t = 1 sec, scegliendo come
% condizione iniziale del sistema il punto d’equilibrio (¯x, ¯u), con
% ¯x = [0 0]′ e ¯u = 0 .



K = 2;
deltaT = 1;
h = 1.1;
A = [0, 1; -k/m, -h/m];
sys = ss(A, B, C, D);
t = linspace(0, deltaT, 40);

x0 = [0; 0];
u_0 = 0;
n_impulsi = 40;
Y = [];
X = [];
T = [];
for i=1:n_impulsi
    [y_lib_t, t_out_y, x_lib_t] = initial(sys, x0, t);
    [y_for_t, t_out_x, x_for_t] = impulse(sys, t);
    y_for_t = y_for_t * K;
    x_for_t = x_for_t * K;
    y_tot = y_lib_t + y_for_t;
    x_tot = x_lib_t + x_for_t;
    X = [X; x_tot];
    Y = [Y; y_tot];
    T = [T; t_out_y+(i-1)*deltaT];
    x0 = x_tot(end, :)';
end
figure(3)
plot(T, Y)
title('Treno di impulsi')