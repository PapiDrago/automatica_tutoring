%% Esercitazione 4

k = 0.33;
h = 0.5;
m = 1;

%% Massa-molla lineare

A = [0 1; -k/m -h/m];
B = [0; 1/m];
C = [1, 0];
D = 0;

sys = ss(A, B, C, D);

eigenvalues = eig(sys);

io_sys = tf(sys); % G(s) = C(sI-A)^-1*B+D

%% Massa-molla non-lineare

x_eq1 = [0.5; 0];
x_eq2 = [1; 0];
x_eq3 = [2; 0];

% Please notice that in this case the initial condition of the lineatized
% system is always 0 because δx = 0 = x-x_bar => x = x_bar.
% Thus we are enforcing x_bar as initial condition.
% Instead in the s-function blocks we force as the initial condition
% directly x_bar. With x_bar I mean x_eq.

% Notice also that it is as if the comparison starts from the t = 5 s,
% because the equilibrium input is subtracted to the input of the
% linearized system. Whereas the nonlinear system receives just the step
% with no subtracting. Thus the nonlinear system starts in the equilibrium
% and remain at the equilibrium for 5 seconds. After that it is like that
% both of them receives a step of amplitude 0.1*u_bar.

% Finally notice that since the linearized system output is δy = y - y_bar,
% we need to add y_bar to the output in order to properly compare the
% output of the linear system with the nonlinear one.


x0 = x_eq1;
[x_bar_1,u_bar_1,y_bar_1,dx] = trim('nl_mdl', x0, [], [], [1;2], [], []);
[Al1,Bl1,Cl1,Dl1] = linmod('nl_mdl',x_bar_1,u_bar_1);
lin_sys = ss(Al1, Bl1, Cl1, Dl1);
gs1 = tf(lin_sys);
% Both poles are complex with negative real part. Thus the linearized
% system is as. stable as it is the nonlinear one. Notice however that the
% two systems state arrives on different values.


x0 = x_eq2;
[x_bar_2,u_bar_2,y_bar_2,dx] = trim('nl_mdl', x0, [], [], [1;2], [], []);
[Al2,Bl2,Cl2,Dl2] = linmod('nl_mdl',x_bar_2,u_bar_2);
lin_sys = ss(Al2, Bl2, Cl2, Dl2);
gs2 = tf(lin_sys);
% There is a pole that is negative, whereas the other is 0.
% The theorems for linear systems does not allow us to conclude anything.
% In simulink simulation we have that the linearized system escapes as it
% does the nonlinear system. Notice that the nonlinear state diverges
% faster than the linear one because the latter has only first degree term.


x0 = x_eq3;
[x_bar_3,u_bar_3,y_bar_3,dx] = trim('nl_mdl', x0, [], [], [1;2], [], []);
[Al3,Bl3,Cl3,Dl3] = linmod('nl_mdl',x_bar_3,u_bar_3);
lin_sys = ss(Al3, Bl3, Cl3, Dl3);
gs3 = tf(lin_sys);
% Here both are stables because the linearized one has a pole with positive
% real part.