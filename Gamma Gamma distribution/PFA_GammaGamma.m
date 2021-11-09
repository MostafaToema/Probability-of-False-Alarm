 % /*
 % ============================================================================
 % Name        : PFA_GammaGamma.m
 % Author      : Mostafa Saleh
 % Version     : Matlab R2015a
 % Copyright   : Open source
 % Description : used to plot the probability of drtection "p_d" vs signal to noise ratio "SNR" for channel modeling Gamma Gamma distribution.
 % ============================================================================
 % */
%% probability of false alarm for channel modeling Gamma Gamma distribution
%% clear and some parameters
clear;clc;close all;
%Numbers of sampling
N = 1e3;
%parameters of gamma gamma distribution
alpha = 2;
beta = 2;
k1 = alpha;
theta1 = 1 / alpha ;
k2 = beta ;
theta2 = 1 / beta;
%genertate uniform random variables
uniform1 = myrand(31 , N);
uniform2 = myrand(127 , N);
uniform3 = myrand(37 , N);
uniform4 = myrand(137 , N);
%% channel model is Gamma Gamma distribution
%% generate gamma gamma numbers >> pure noise(H_0)
[gamma_gamma_numbers , len] = mygammagamma(uniform1 , uniform2 , uniform3 , uniform4 , k1 , theta1 , k2 , theta2 , N);
%sort gamma gamma numbers and find threshold
gamma_gamma_numbers = sort(gamma_gamma_numbers);
threshold = ((gamma_gamma_numbers(len) - gamma_gamma_numbers(len - 1)) / 2) + gamma_gamma_numbers(len - 1);
%% generate deterministic signal plus gamma gamma numbers again >> (H_1)
[gamma_gamma_numbers , len] = mygammagamma(uniform1 , uniform2 , uniform3 , uniform4 , k1 , theta1 , k2 , theta2 , N);
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
    noise_power = var(gamma_gamma_numbers(:));
    SNR(SNR_index_cntr) = signal_power / noise_power;
    %% Add signal to noise
    p_detect_all_samples = 0;
    for sample_cntr = 1 : len
        recived_signal = (transmitter_signal(sample_cntr) * ones(1 , len)) + gamma_gamma_numbers;
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