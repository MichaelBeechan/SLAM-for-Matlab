function newstate = sampleOdometry(u, state, alphas)

prev_state_bar = u(:,1);
state_bar = u(:,2);

bar_diff = state_bar - prev_state_bar;
    
delta_rot1 = atan2(bar_diff(2), bar_diff(1)) - prev_state_bar(3);
delta_trans = sqrt(bar_diff(1)*bar_diff(1) + bar_diff(2)*bar_diff(2));
delta_rot2 = bar_diff(3) - delta_rot1;

delta_rot1_hat = delta_rot1 - randn*(alphas(1)*abs(delta_rot1) + alphas(2)*delta_trans);
delta_trans_hat = delta_trans - randn*(alphas(3)*delta_trans + alphas(4)*abs(delta_rot1+delta_rot2));
delta_rot2_hat = delta_rot2 - randn*(alphas(1)*abs(delta_rot2) + alphas(2)*delta_trans);

newstate(1) = state(1) + delta_trans_hat * cos(state(3) + delta_rot1_hat);
newstate(2) = state(2) + delta_trans_hat * sin(state(3) + delta_rot1_hat);
newstate(3) = state(3) + delta_rot1_hat + delta_rot2_hat;
