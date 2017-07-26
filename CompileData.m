clear;
%get spike
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('event_data.mat');
spikedata = load('spiketrains.mat');

%ts is in seconds, convert to miliseconds
ts = ts.*1000;

%convert instructions from integer into binary
words = strobesToWords(sv);
clear sv;

spike = compileSpikeData (spikedata, words, ts);

%get eye
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eyedata = edfmex('J9_4.edf');
eye = parseEDFData(eyedata);
%compile eye and spike
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sessions = struct;
for sessionnr = 1:length(eye)
    %sessions(sessionnr) = struct;
    for trialnr = 1:length(eye(sessionnr).trials)
       % sessions(sessionnr).trials(trialnr) = struct;
        %from the fields of eye data
        fn = fieldnames(eye(sessionnr).trials(trialnr));
        for k = 1:length(fn)
            sessions(sessionnr).trials(trialnr).(fn{k}) = eye(sessionnr).trials(trialnr).(fn{k});
        end
        %from the fields of spike data
        fn = fieldnames(spike(sessionnr).trials(trialnr));
        for k = 1:length(fn)
        sessions(sessionnr).trials(trialnr).(fn{k}) = spike(sessionnr).trials(trialnr).(fn{k});
        end
    end
end

save('sessions.mat','sessions');
