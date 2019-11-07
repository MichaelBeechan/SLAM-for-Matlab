function w= compute_weight(particle, z, idf, R)

[zp,Hv,Hf,Sf]= compute_jacobians(particle, idf, R);
Pv= particle.Pv;

v= z-zp;
v(2,:)= pi_to_pi(v(2,:));

w= 1;
for i=1:size(z,2)
    S= Hv(:,:,i)*Pv*Hv(:,:,i)' + Sf(:,:,i); % innovation covariance, includes pose and feature uncertainty
    den= 2*pi*sqrt(det(S));
    num= exp(-0.5 * v(:,i)' * inv(S) * v(:,i));
    w = w* num/den;
end
