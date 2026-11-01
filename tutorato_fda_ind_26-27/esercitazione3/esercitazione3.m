clear
close all
clc
%% 1)
k = 0.33; % k is the elastic constant
h = 1.1; % h is dumping coefficient measured in N*s/
m = 1; % m is the mass of the cart measured in kg

A = [0 1;
    -k/m -h/m];
B = [0;
     1/m];
C = [1 0];
D = 0;
x0 = [0;0];

step_amplitude1 = 0.1;
step_amplitude2 = 0.05;
%sys_lin = ss(A, B, C, D);

% The input in this exercise is a step signal. A step signal is 0 unitil a
% certain time t0 instant and at that t0 it changes abruptly to a constant
% value. Specifically in this exercise we can think to this kind of input
% as a force that keeps on pulling the cart. This pulling consists in a
% transient because u is initially greater than the friction force and the
% elastic force acting on the cart. The cart stops when those motion
% opposing forces balance out the step.
% We move from an equilibrium point (0; 0) to another. After a transient
% the state arrives at the new equilibrium.
% Please notice that the integral of a step function is the integral of a
% constant. This means that the forced movement grows linearly with time.

%open("massa_molla_lineare");
%sim(massa_molla_lineare);
%% 2
%open("massa_molla_nonlineare")
%sim("massa_molla_nonlineare")
%% 3
open("superposition")
sim("superposition")



%% Introduction to S-Function
% Often using the basic MATLAB and Simulink objects to simulate nonlinear
% systems can be cumbersome. Simulink provides S-Function blocks to do so.
% An S-Function block is a programmed block in the sense that a function is
% associated to the block. This function is called S-Function and it needs
% to be written in MATLAB (or even in C and other languages) in order to
% describe the behaviour of the system. NB S stands for system.
% Please notice that once the association is done we can use our system as
% block in a Simulink block scheme.
% A MATLAB S-Function has the following signature:
% [sys,x0,str,ts]=f(t,x,u,flag,...),
% f is the name of the S-Function. This is repeatedly called by Simulink
% engine during the simulation of a model implemented as Simulink blocks.
% Each time the Simulink engine calls it, the engine uses the flag argument
% to indicate the task to be performed regarding the particular invocation.
% Then the S-Function, after performing the task returns the results in an
% output vector. Please notice that the input argument number is
% arbitrary: it depends on the particular system and/or the particular
% logic, for instance in this exercise we have a cart having a mass, a
% dumping coefficient etc... these are additional parameters that needs to
% be passed. Let's state explicitely the mandatory arguments:
% -t is the current time of the simulation;
% -x is the state vector;
% -u is the input vector;
% -flag is an integer value indicating the specific action to be performed
% by the S-Function.
% The user specifies the additional parameters in the S-function parameters
% field of the S-Function Block Parameters dialog box. If the block dialog
% specifies additional parameters, the engine passes the parameters to the
% S-function as additional function arguments. The additional arguments
% follow the standard arguments in the S-function argument list in the
% order in which the corresponding parameters appear in the block dialog.
% Now let's focus on the outputs of the S-Function:
% -sys value depend on what action was performed by the S-Function, for
% instance when flag = 3 the task is to compute the output of the system 
% modeled by the S-Function and then sys contains that output.
% -x0, the initial state values (an empty vector if there are no states in
% the system). x0 is ignored, except when flag = 0
% -str, originally intended for future use. Level-1 MATLAB S-functions, like
% the one we are implementing, must set this to the empty matrix, [].
% -ts a two-column matrix containing the sample times and offsets of the
% block. For instance ts = [T_s, T_o] where T_s is the sampling period and
% T_o the time offset wrt simulation start time. In this exercise we are
% dealing with continuous system hence there is no sampling time and no
% offset: [0,0] because we want the S-Function to run at each time step of
% the simulation.
%
% An S-Function has to comply with what the Simulink engine expects. Just
% like an interface in the object-proggramming paradigm.
% The first thing to do is to write a logic tha allows different tasks to
% be performed according to the value of flag. This can be easily done with
% a case-switch block. See the documentation to match the expected flag
% values.
% Case 0 refers to the initialization task. Please notice that in order to
% maintain the code clean, in the case 0 body typically an initialization
% function is called. We are going to define this and also the other
% task-functions in the same file of the S-Function.
% Let's get back to the initialization. First, for the Simulink engine to
% recognize a Level-1 MATLAB S-function, we must provide it with specific
% information about the S-function. This information includes the number of
% inputs, outputs, states, and other block characteristics. This is done by
% calling the simsizes function at the beginning of the initialization body
% and just after this statement it is crucial to set all the field
% values of the structure returned by the simsizes function with the
% specific values concerning the system we are modeling. See the actual
% code and the documentation for all the attributes. Please notice that
% after we did all these assignments, the structure is assigned to sys in
% order to be used by the Simulink engine.
%
% After the initialization the output of the system is computed for the
% first time by the Simulink engine by invoking the S-Function with flag
% set to 3. The case 3 block essentially contains the output
% transformation, i.e. the implementation of y = g(x,u,t).
% 
% Then the continuous state is updated (case 1) and subsequently the
% discrete update is updated too (case 2).
% In both these case block there will be the implementation of the
% differential equation and difference equation respectively.
% Of course if our system does not have discrete state we set in the case 2
% block the assignment of an empty object to sys. Note again that the
% updated state is assigned to sys.
%
% Until the end of the simulation process the Simulink engine keeps on
% calling the S-Function by repeatingly assigning 3->1->2 to the flag
% argument.
%
% Source:
% https://www.mathworks.com/help/releases/R2025b/simulink/sfg/maintaining-level-1-matlab-s-functions.html#bq3i98j
% https://www.mathworks.com/help/releases/R2025b/simulink/ug/how-to-specify-the-sample-time.html