function [sys,x0,str,ts,simStateCompliance] = s_function(t,x,u,flag,x0, M, h, k)
    switch flag

    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
    case 0
        [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(x0);

    %%%%%%%%%%%%%%%
    % Derivatives %
    %%%%%%%%%%%%%%%
    case 1
        sys=mdlDerivatives(t,x,u,M,h,k);

    %%%%%%%%%%
    % Update %
    %%%%%%%%%%
    case 2
        sys=[]; % The is no discrete state to update.

    %%%%%%%%%%%
    % Outputs %
    %%%%%%%%%%%
    case 3
        sys=mdlOutputs(x);

    %%%%%%%%%%%%%%%%%%%%%%%
    % GetTimeOfNextVarHit %
    %%%%%%%%%%%%%%%%%%%%%%%
    case 4
        sys=mdlGetTimeOfNextVarHit(t,x,u);

    %%%%%%%%%%%%%
    % Terminate %
    %%%%%%%%%%%%%
    case 9
        sys=mdlTerminate();

      %%%%%%%%%%%%%%%%%%%%
      % Unexpected flags %
      %%%%%%%%%%%%%%%%%%%%
      otherwise
        DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

    end

end

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(x0)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1; 
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1; % 1 because the state is explicitely used in the
% output
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes); % Renew the template

%
% initialize the initial conditions
x0  = [0 0]';


%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [-1 0]; % With -1 instead of 0 the sampling interval of the block
% inherits the sampling interval of the input signal

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

end %mdlInitializeSizes %If I do not comment the name of the function, this
% file is considered to be a script and it is not accepted by the simulink
% block S-Function


%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
% The continuous states are updated by this function.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u,M,h,k) % M, h as additional params

    sys(1)=x(2); % x1_dot = x2  
    sys(2)=-k*exp(-x(1))*(x(1)/M)-(h/M)*x(2)+(1/M)*u;


end %mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate()

    sys = [];

end %mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(x)

    sys(1) = x(1); % DEFINIRE y(t)

end %mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

end %mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate()

    sys = [];

end %mdlTerminate