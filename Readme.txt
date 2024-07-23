##Codes and data used in the article Tao, Z., Zhong, Q., Dang, Y. Towards a maximal multimodal accessibility equality (MMAE) model for optimizing the equality of healthcare services. ISPRS Int. J. Geo-Inf., 2024. 

##Here the maximal multimodal accessibility equality model is solved by using the PSO algorithm.

##The PSO algorithm is run based on the Particle Swarm Optimization Toolbox developed by Brian Birge. Researchers need to install the toolbox in Matlab first. The installer and instructions of this toolbox can be found at: https://ww2.mathworks.cn/matlabcentral/fileexchange/7506-particle-swarm-optimization-toolbox. In our experiment, Matlab version R2015b was used. Other versions should be also appliable.

##Filefold "PSO_MAE_MAD_MutliModal" contains all Matlab scripts and required data for the resource reallocation scenario, and "PSO_MAE_MAD_MutliModal_Add" for the new resource allocation scenario.

##Descriptions of files (similar in two scenarios):
#MAE_Multimodal_main_WMAD.m    The main file. Run it to solve the MMAE model. Optimization scenario and PSO parameters can be set by modifying codes in this file.
#MAE_Multimodal_fun_WMAD.m     The function for formulating the objection function and desicion variable in the solving process of PSO algorithm. It will be called by the main file.
#pop2020.mat     The population data.
#d c.mat    The travel time matrix by car mode.
#d p.mat    The travel time matrix by public transport mode.
#c_share.mat    The share of car mode at each demand node.
#p_share.mat    The share of public transport mode at each demand node.

Welcome for discussion and cooperation. Feel free to contact Dr. Zhuolin Tao at taozhuolin@bnu.edu.cn