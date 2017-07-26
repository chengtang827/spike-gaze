function sessions  = parseEDFData(edfdata)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Parse eye link data into a trial structure
    %Input:
    %edfdata    :   eyelink data structure or name of edffile
    %nrows      :   number of grid rwos
    %ncols      :   number of grid columns
    %
	%Output:
	%	trials		:		struct array with information about each trial
    %   trials.start    :    start of the trial, absoute time
    %   trials.prestim  :    start of the prestim-period, relative to trial
    %                        start
    %   trials.target.timestamp    : target onset, relative to trial start
    %   trials.target.row          : row index of the target
    %   trials.target.column       : column index of the target
    %   trials.distractors         : array of distractors; rows are time
    %                                relative to start of the trial, row
    %                                and column index
	%   trial.response			   : time, relative to target onset, of the beginning of the repsonse period
    %   trials.reward              : time of reward, relative trial start
    %   trials.failure             : time of failure, relative to trial
    %                                start
    %   trials.end                 : aboslute time of trial end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ischar(edfdata)
        edfdata = edfmex(edfdata);
    end
%     if nargin < 3
%         ncols = 5;
%         nrows = 5;
%     end

    recording_start=edfdata.RECORDINGS(1).time;

    
    
    nevents = length(edfdata.FEVENT);
    trialnr = 0;
    sessions = struct;
    sessionnr = 0;
    k = 1;
    for nextevent=1:nevents
        m = edfdata.FEVENT(nextevent).message(1:3:end);
        if ~isempty(m)
            if ((m(1) == '0') && (m(2) == '1')) %target
                %get the row and column index
                if length(m) == 8
                    px = bin2dec(m(5:-1:3));
                    py = bin2dec(m(8:-1:6));
                elseif length(m) == 14
                    px = bin2dec(m(8:-1:3));
                    py = bin2dec(m(end:-1:9));
                end

                sessions(sessionnr).trials(trialnr).target = struct('row', py, 'column', px, 'timestamp', edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start);

            elseif ((m(1) == '1') && (m(2) == '0'))  %distractor
                if length(m) == 8
                    px = bin2dec(m(5:-1:3));
                    py = bin2dec(m(8:-1:6));
                elseif length(m) == 14
                    px = bin2dec(m(8:-1:3));
                    py = bin2dec(m(end:-1:9));
                end
                sessions(sessionnr).trials(trialnr).distractor = struct('row', py, 'column', px, 'timestamp', edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start);
            elseif strcmp(m, '00000000') %trial start
                trialnr  = trialnr + 1;
                k = 1;
                trialstart = edfdata.FEVENT(nextevent).sttime;
                sessions(sessionnr).trials(trialnr).start = trialstart;
                %sessions(sessionnr).trials(trialnr).saccade = struct;
            elseif strcmp(m,'00000101') %go-cueue
                sessions(sessionnr).trials(trialnr).response_cue = edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start;
            elseif strcmp(m,'00000110') %reward
                sessions(sessionnr).trials(trialnr).reward = edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start;
            elseif strcmp(m,'00000111') %failure
                sessions(sessionnr).trials(trialnr).failure = edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start;
            elseif strcmpi(m,'00000011') %stimulus blank
                sessions(sessionnr).trials(trialnr).stimblank = edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start;
            elseif strcmpi(m,'00000100') %delay
                sessions(sessionnr).trials(trialnr).delay = edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start;
            elseif strcmpi(m,'00000001') %fixation start
                sessions(sessionnr).trials(trialnr).fixation_start = edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start;
            elseif strcmpi(m,'00100000') %trial end       
                sessions(sessionnr).trials(trialnr).end = edfdata.FEVENT(nextevent).sttime;
                
                %add the gaze and pupil size data
                trial_start=sessions(sessionnr).trials(trialnr).start-recording_start;
                trial_end=sessions(sessionnr).trials(trialnr).end-recording_start;
                
                %sample rate is 2/ms       
                sessions(sessionnr).trials(trialnr).gazex = edfdata.FSAMPLE.gx(:,trial_start*2:trial_end*2);
                %clear the out-of-range data for x
                index = sessions(sessionnr).trials(trialnr).gazex(1,:) > 1e5 ;
                sessions(sessionnr).trials(trialnr).gazex(1,index) = NaN;
                
                sessions(sessionnr).trials(trialnr).gazey = edfdata.FSAMPLE.gy(:,trial_start*2:trial_end*2);
                %clear the out-of-range data for y
                index = sessions(sessionnr).trials(trialnr).gazey(1,:) > 1e5 ;
                sessions(sessionnr).trials(trialnr).gazey(1,index) = NaN;
                                
                sessions(sessionnr).trials(trialnr).pupil = edfdata.FSAMPLE.pa(:,trial_start*2:trial_end*2);
                %clear 0 values of pupil size
                index = sessions(sessionnr).trials(trialnr).pupil(1,:) == 0 ;
                sessions(sessionnr).trials(trialnr).pupil(1,index) = NaN;
                
                sessions(sessionnr).trials(trialnr).end = sessions(sessionnr).trials(trialnr).end-sessions(sessionnr).trials(trialnr).start;
            elseif strcmpi(m, '00001111') %stimulation
                sessions(sessionnr).trials(trialnr).stim = edfdata.FEVENT(nextevent).sttime-sessions(sessionnr).trials(trialnr).start;
            
	    elseif strcmpi(m, '11000000') %session start
            
		    sessionnr = sessionnr + 1;
		    sessions(sessionnr).trials = struct;
            
		    trialnr = 0; %reset the trial counter
            end
        else
            if strcmpi(edfdata.FEVENT(nextevent).codestring, 'ENDSACC')
                %check that the event immediately before this was cue onset, i.e. we want to grab the first saccade after cue
                m = edfdata.FEVENT(nextevent-3).message(1:3:end);
                %TODO: we also want to get saccades for failed trials
                %before the co-cue
                %if strcmp(m,'00000101') %go-cueue
                event = edfdata.FEVENT(nextevent);
                if sessionnr > 0 && trialnr > 0 && event.sttime > trialstart
                    sessions(sessionnr).trials(trialnr).saccade(k) = struct('startx', event.gstx, 'starty', event.gsty, 'endx', event.genx', 'endy', event.geny, 'start_time', event.sttime-sessions(sessionnr).trials(trialnr).start, 'end_time', event.entime-sessions(sessionnr).trials(trialnr).start);
                    k = k+1;
                %end
            end
        end %if ~isempty(m)
    end
end
