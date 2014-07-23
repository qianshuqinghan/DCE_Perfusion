for iter_num = 1 : num_iterations
%for iter_num = 1 : num_iterations
    
    % Calculate iteration time
    tic;
    
    % Initiate local loop vectors
    est_sigma_noise_vec                      = zeros(num_averages,1);
    est_t_d_noise_vec                        = zeros(num_averages,1);
    est_amp_noise_vec                        = zeros(num_averages,1);
    est_F_noise_vec                          = zeros(num_averages,1);
    est_Delay_sec_noise_vec                  = zeros(num_averages,1);
    est_Delay_sec_using_Gaussian_noise_vec   = zeros(num_averages,1);
    est_Ki_Patlak_noise_vec                  = zeros(num_averages,1);
    est_Ki_Two_Comp_noise_vec                = zeros(num_averages,1);
    est_Vb_Patlak_noise_vec                  = zeros(num_averages,1);
    est_E_noise_vec                          = zeros(num_averages,1);
    est_PS_noise_vec                         = zeros(num_averages,1);
    est_Vb_Two_Comp_noise_vec                = zeros(num_averages,1);
    est_Ve_Two_Comp_noise_vec                = zeros(num_averages,1);
    est_Vd_noise_vec                         = zeros(num_averages,1);
    est_Vd_normal_tis_noise_vec              = zeros(num_averages,1);
    est_MTT_noise_vec                        = zeros(num_averages,1);
    est_MTT_normal_tis_noise_vec             = zeros(num_averages,1);
    
    est_F_Sourbron_noise_vec                 = zeros(num_averages,1);
    est_Ki_Sourbron_Two_Comp_noise_vec       = zeros(num_averages,1);
    est_Vb_Sourbron_Two_Comp_noise_vec       = zeros(num_averages,1);
    est_Ve_Sourbron_Two_Comp_noise_vec       = zeros(num_averages,1);
    
    %parfor avg_num = 1 : num_averages
    for avg_num = 1 : num_averages
        
        %% Estimating h(t) by Wiener filter
        [Sim_Struct_Replicated(iter_num).est_gauss_filter_Wiener_noise, Sim_Struct_Replicated(iter_num).est_larss_filter_Wiener_noise,idx_fig_Rep(iter_num) ] = Estimate_ht_Wiener(Sim_Struct_Replicated(iter_num), Verbosity, iter_num, avg_num, idx_fig_Rep(iter_num));
        %%  Estimating h(t) by regularization methods
        [ht_Struct, idx_fig_Rep(iter_num)] = Estimate_ht_Regularization(Sim_Struct_Replicated(iter_num), Verbosity, iter_num, avg_num, idx_fig_Rep(iter_num));
        
        % Correct h(t) estimation if it seems we have delay in AIF
        if Correct_estimation_due_to_delay
            [Sim_Struct_Replicated(iter_num).est_delay_by_AIF_correct, Sim_Struct_Replicated(iter_num).Sim_AIF_with_noise_Regul_shifted,ht_Struct.b_spline_larss_result_2nd_deriv, idx_fig_Rep(iter_num)] = ...
                AIF_Delay_Correct(Sim_Struct_Replicated(iter_num), ht_Struct, Verbosity, iter_num, avg_num, idx_fig_Rep(iter_num));
        end
        
        %% Gaussian parameters estimation
        if (~Ignore_Gaussian_Calculation)
            [est_sigma_noise , est_t_d_noise, est_amp_noise,  idx_fig_Rep(iter_num) ] = Estimate_Gauss_Params(Sim_Struct_Replicated(iter_num),ht_Struct, Verbosity, iter_num, avg_num, idx_fig_Rep(iter_num));
        else
            est_sigma_noise = NaN;
            est_t_d_noise   = NaN;
            est_amp_noise   = NaN;
        end
        
        %% Larsson parameters estimation
        [Larss_Struct, idx_fig_Rep(iter_num)] = Estimate_Larss_Params(Sim_Struct_Replicated(iter_num), ht_Struct, est_t_d_noise, Verbosity, iter_num, avg_num, idx_fig_Rep(iter_num));
        
        % Put Larrson Parameters in vectors (according to average_iteration)
        Sim_Struct_Replicated(iter_num).est_F_noise_vec(avg_num)                        = Larss_Struct.est_F_noise;
        Sim_Struct_Replicated(iter_num).est_Delay_sec_noise_vec(avg_num)                = Larss_Struct.est_Delay_sec_noise;
        Sim_Struct_Replicated(iter_num).est_Delay_sec_using_Gaussian_noise_vec(avg_num) = Larss_Struct.est_Delay_sec_using_Gaussian_noise;
        Sim_Struct_Replicated(iter_num).est_Ki_Patlak_noise_vec(avg_num)                = Larss_Struct.est_Ki_Patlak_noise;
        Sim_Struct_Replicated(iter_num).est_Ki_Two_Comp_noise_vec(avg_num)              = Larss_Struct.est_Ki_Two_Comp_noise;
        Sim_Struct_Replicated(iter_num).est_Vb_Patlak_noise_vec(avg_num)                = Larss_Struct.est_Vb_Patlak_noise;
        Sim_Struct_Replicated(iter_num).est_E_noise_vec(avg_num)                        = Larss_Struct.est_E_noise;
        Sim_Struct_Replicated(iter_num).est_PS_noise_vec(avg_num)                       = Larss_Struct.est_PS_noise;
        Sim_Struct_Replicated(iter_num).est_Vb_Two_Comp_noise_vec(avg_num)              = Larss_Struct.est_Vb_Two_Comp_noise;
        Sim_Struct_Replicated(iter_num).est_Ve_Two_Comp_noise_vec(avg_num)              = Larss_Struct.est_Ve_Two_Comp_noise;
        Sim_Struct_Replicated(iter_num).est_Vd_noise_vec(avg_num)                       = Larss_Struct.est_Vd_noise;
        Sim_Struct_Replicated(iter_num).est_Vd_normal_tis_noise_vec(avg_num)            = Larss_Struct.est_Vd_normal_tis_noise;
        Sim_Struct_Replicated(iter_num).est_MTT_noise_vec(avg_num)                      = Larss_Struct.est_MTT_noise;
        Sim_Struct_Replicated(iter_num).est_MTT_normal_tis_noise_vec(avg_num)           = Larss_Struct.est_MTT_normal_tis_noise;
        
        Sim_Struct_Replicated(iter_num).est_sigma_noise_vec(avg_num)                    = est_sigma_noise;
        Sim_Struct_Replicated(iter_num).est_t_d_noise_vec(avg_num)                      = est_t_d_noise;
        Sim_Struct_Replicated(iter_num).est_amp_noise_vec(avg_num)                      = est_amp_noise;
        
        if (Check_Sourbron_Estimate)
            Sim_Struct_Replicated(iter_num).est_F_Sourbron_noise_vec(avg_num)               = Larss_Struct.est_F_Two_Comp_Sourbron_noise;
            Sim_Struct_Replicated(iter_num).est_Ki_Sourbron_Two_Comp_noise_vec(avg_num)     = Larss_Struct.est_Ki_Two_Comp_Sourbron_noise;
            Sim_Struct_Replicated(iter_num).est_Vb_Sourbron_Two_Comp_noise_vec(avg_num)     = Larss_Struct.est_Vb_Two_Comp_Sourbron_noise;
            Sim_Struct_Replicated(iter_num).est_Ve_Sourbron_Two_Comp_noise_vec(avg_num)     = Larss_Struct.Ve_Two_Comp_Sourbron_est;
        end
        
    end % end of number of averages
    
    % Summarize iteration results and put in relevant output matrices
    results(:,iter_num) = Summarize_Iteration(Sim_Struct_Replicated(iter_num), Verbosity, iter_num, avg_num);
    
end
