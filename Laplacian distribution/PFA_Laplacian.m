 % /*
 % ============================================================================
 % Name        : PFA_Laplacian.m
 % Author      : Mostafa Saleh
 % Version     : Matlab R2015a
 % Copyright   : Open source
 % Description : used to plot the probability of drtection "p_d" vs signal to noise ratio "SNR" for channel modeling Laplacian distribution.
 % ============================================================================
 % */
%% probability of false alarm for channel modeling Laplacian distribution
%% clear and some parameters
clear;clc;close all;
%Numbers of sampling
N = 1e3;
%parameters of laplacian distribution
b = 1;
mu = 0;
%genertate uniform random variables
uniform = myrand(31 , N);
%% channel model is laplacian distribution
%% generate laplacian numbers >> pure noise(H_0)
laplacian_numbers = mu - (b * sign(uniform - 0.5) .* log(1 - 2 * abs(uniform - 0.5)));
len = length(laplacian_numbers);
%sort laplacian numbers and find threshold
laplacian_numbers = sort(laplacian_numbers);
threshold = ((laplacian_numbers(len) - laplacian_numbers(len - 1)) / 2) + laplacian_numbers(len - 1);
%% generate deterministic signal plus laplacian numbers again >> (H_1)
laplacian_numbers = mu - (b * sign(uniform - 0.5) .* log(1 - 2 * abs(uniform - 0.5)));
%sin wave signal and find probability of detection
prob_index_cntr = 0;
SNR_index_cntr = 0;
for amp_cntr = 0.4 : 0.05 : (0.05 * N) 
    prob_index_cntr = prob_index_cntr + 1;
    SNR_index_cntr = SNR_index_cntr + 1;
    amp = amp_cntr;
    omega = 1;
    t = 0 : (1 / len) : 1 - (1 / len);
    transmitter_signal = amp * sin(omega  * t);
    %% find power of signal and noise
    signal_power = ((amp ^ 2) / 2);
    noise_power = var(laplacian_numbers(:));
    SNR(SNR_index_cntr) = signal_power / noise_power;
    %% Add signal to noise
    p_detect_all_samples = 0;
    for sample_cntr = 1 : len
        recived_signal = (transmitter_signal(sample_cntr) * ones(1 , len)) + laplacian_numbers;
        p_detect_sample = sum(recived_signal > threshold) / len;
        p_detect_all_samples = p_detect_all_samples + p_detect_sample;
    end
    p_detect(prob_index_cntr) =  p_detect_all_samples / len;  
end
%% plot Probability of detection vs SNR 
plot(SNR , p_detect);
xlabel('SNR');
ylabel('p_d');
title(['Probability of Detection']);