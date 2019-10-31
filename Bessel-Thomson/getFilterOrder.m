function [n] = getFilterOrder(timeDelay, timeDelayFrequency, timeDelayError, passbandAttenuation, passbandFrequency)
    normalized_td_freq = timeDelay*timeDelayFrequency;
    normalized_atten_freq = timeDelay*passbandFrequency;
    
    constrainst_satisfied = 0;
    n = 1;
    while ~(constrainst_satisfied==3)
        polynomial = getReverseBesselPolynomial(n);
        
        h_s = tf([polynomial(size(polynomial,2))], polynomial);
        if ~(constrainst_satisfied==1)
            w = [normalized_td_freq - 0.1*normalized_td_freq: 0.0001*normalized_td_freq: normalized_td_freq + 0.1*normalized_td_freq];          
            phase = squeeze(unwrap(angle(freqresp(h_s, w))))';
            delay = -diff(phase)./diff(w);
            delayError = abs(1 - delay(size(delay,2)/2)) * 100; 
        end
        
        if ~(constrainst_satisfied==2)
            mag_dB = -20*log10(abs(evalfr(h_s, 1j*normalized_atten_freq)));
        end
        
        if delayError <= timeDelayError 
            constrainst_satisfied = bitor(constrainst_satisfied,1);
        end
        if mag_dB <= passbandAttenuation
            constrainst_satisfied = bitor(constrainst_satisfied,2);
        end
        
        if ~(mag_dB <= passbandAttenuation && delayError <= timeDelayError) 
            n = n+1;
        end
    end
end

