
%% The V-Rep communication initialisation procedure

% Add lib path
% addpath 'C:\...\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\lib\lib\64Bit'
% addpath 'C:\...\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\matlab\matlab'

vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
r = vrep.simxFinish(-1); % just in case, close all opened connections

%%
%Connect to local host on port 19997: you can configure these ports from
%the file "remoteApiConnections.txt" at the root of the application.
clientID = vrep.simxStart('127.0.0.1',19997, true, true, 5000, 5);
if clientID == -1
    disp('ERROR: Could not connect to vrep');
    return;
end
r = vrep.simxAddStatusbarMessage(clientID, 'HELLO ROBOT', vrep.simx_opmode_oneshot_wait);

%% Start Sim
r = vrep.simxStartSimulation(clientID, vrep.simx_opmode_oneshot_wait);
pause(1);
r = vrep.simxStopSimulation(clientID, vrep.simx_opmode_oneshot_wait);
r = vrep.simxFinish(clientID);

%%  OPERATION CODES
% vrep.simx_opmode_oneshot
% vrep.simx_opmode_oneshot_wait

% For Streaming:
% The first time, as a special handshake for the initialisation of the
% frequent communication we use the streaming opcode (for each individual
% value that we send/receive. The rest of the function calls utilise the
% buffer opcode
% vrep.simx_opmode_streaming  
% vrep.simx_opmode_buffer

%% Synchronous Operation
% r = vrep.simxSynchronous(clientID, true); % Or False... 
% r = vrep.simxSynchronousTrigger(clientID); -> Call in every iteration

%% Object Funs
[r, jointHandles] = vrep.simxGetObjectHandle(clientID, 'object_name_1', vrep.simx_opmode_oneshot_wait);
% If object is a Joint then
r = vrep.simxSetJointPosition(clientID, jointHandles(h), q(i,h), opmode);
% or
r = simxSetJointTargetPosition(clientID, jointHandles(h), q(i,h), opmode);

[r, q] = vrep.simxGetJointPosition(clientID, jointHandles(h), opmode);

