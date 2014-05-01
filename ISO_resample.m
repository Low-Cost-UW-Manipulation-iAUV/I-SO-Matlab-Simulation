function [SO_position_resampled] = ISO_resample( position, min_delta )
%ISO_RESAMPLE resamples a
%   Detailed explanation goes here
%% Resample the timeseries to account for variable step size
ts_dt = inf;

%Find the smallest timestep
for x=1:(length(position.Time)-1)
    if (position.Time(x+1) - position.Time(x)) < ts_dt
        ts_dt = (position.Time(x+1) - position.Time(x));
    end
end
% Limit the timestep so that we can still calculate with it.
if ts_dt < min_delta
    ts_dt = min_delta;
end

SO_position_resampled.sampling_rate = 1/ts_dt;

SO_position_resampled_timeseries = resample(position, position.Time(1):ts_dt:position.Time(length(position.Time)));

SO_position_resampled.Time = SO_position_resampled_timeseries.Time;
SO_position_resampled.Data = SO_position_resampled_timeseries.Data;



end

