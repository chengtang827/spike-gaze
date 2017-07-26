function  spikes  = compileSpikeData(spikedata, words, timestamp)
% Compile raw spike data with instructions into session x trial x neuron
% struct

%INPUT
%spikedata   : the struct containing all the neuron spikes
%words       : instructions in binary format
%timestamp   : timestamp for each instructions, length should be the same
%as words

%OUTPUT
%spikes      : session x trial x neuron, each cell containing the spike
%timestamps

neurons = fieldnames(spikedata);
save('neuron_names.mat','neurons');
nevents = length(words);
trialnr = 0;
sessions = struct;
sessionnr = 0;
for nextevent=1:nevents
    m = words(nextevent,:);
    
    
    if isequal(m,[0,0,0,0,0,0,0,0]) %trial start
        trialnr  = trialnr + 1;
        trialstart = timestamp(nextevent);
        sessions(sessionnr).trials(trialnr).start_spike = trialstart;
        
    elseif isequal(m,[0,0,1,0,0,0,0,0]) %trial end
        
        
        trial_start = sessions(sessionnr).trials(trialnr).start_spike;
        trial_end = timestamp(nextevent);
        %add neuron spike data for this trial
        %for all neurons
        for i = 1:length(neurons)
            neuron = cell2mat(neurons(i));
            %spike for this specific neuron
            neuronspike = spikedata.(neuron); 
            %spike within this trial
            trial_spike = neuronspike((neuronspike >= trial_start) & (neuronspike <= trial_end));            
            sessions(sessionnr).trials(trialnr).(neuron) = trial_spike - trial_start;
        end
        sessions(sessionnr).trials(trialnr).end_spike = trial_end - trial_start;
        
    elseif isequal(m,[1,1,0,0,0,0,0,0]) %session start
        
        sessionnr = sessionnr + 1;
        sessions(sessionnr).trials = struct;
        
        trialnr = 0; %reset the trial counter
    end
    
end

spikes = sessions;
end

