%This code plots the estimated responses with error bands

%draws=draws(:,2000:end); %if want to get rid of first N draws as burn-in
setup.number_of_draws=setup.keep_draw*size(draws,2);

Ndraw=100;

inds=setup.number_of_draws/setup.keep_draw;
indices_for_draws=unidrnd(inds,Ndraw,1);

% Get IRFs to negative shocks

for kk=1:length(indices_for_draws)
    size_of_shock=-1;
    
    shock_contemp=zeros(setup.size_obs,1);
    shock_contemp(setup.index_unrestricted)=size_of_shock;
    ind_vec=[zeros(1,setup.lags)];
    for jj=1:setup.lags+1
        epsilon=[zeros(setup.size_obs,jj-1) shock_contemp zeros(setup.size_obs,setup.lags+1-jj)];
        [ Sigma, intercept] = unwrap_NL_IRF( draws(:,indices_for_draws(kk)),epsilon,setup);
        
        IRFs(:,jj,kk)=Sigma(:,setup.index_unrestricted,jj);
    end
    clear ind_vec
    
end

IRFsmed=squeeze(median(IRFs,3));
IRFslow=squeeze(prctile(IRFs,5,3));
IRFshigh=squeeze(prctile(IRFs,95,3));


figure;
for jj=1:setup.size_obs
    subplot(setup.size_obs,1,jj)
    plot(1:setup.lags+1,IRFsmed(jj,:),1:setup.lags+1,IRFslow(jj,:),'k--',1:setup.lags+1,IRFshigh(jj,:),'k--', ...
        1:setup.lags+1,squeeze(setup.store_responses(jj,setup.index_unrestricted,:)),'Linewidth',2)
    title(sprintf('IRF, shock size = %i', size_of_shock))
end
legend('median','5th percentile','95th percentile','VAR')

% print -depsc


% Get IRFs to positive shocks
clear IRFs

inds=setup.number_of_draws/setup.keep_draw;
indices_for_draws=unidrnd(inds,Ndraw,1);


for kk=1:length(indices_for_draws)
    size_of_shock=1;
    
    shock_contemp=zeros(setup.size_obs,1);
    shock_contemp(setup.index_unrestricted)=size_of_shock;
    ind_vec=[zeros(1,setup.lags)];
    for jj=1:setup.lags+1
        epsilon=[zeros(setup.size_obs,jj-1) shock_contemp zeros(setup.size_obs,setup.lags+1-jj)];
        [ Sigma, intercept] = unwrap_NL_IRF( draws(:,indices_for_draws(kk)),epsilon,setup);
        
        IRFs(:,jj,kk)=Sigma(:,setup.index_unrestricted,jj);
    end
    clear ind_vec
end

IRFsmed=squeeze(median(IRFs,3));
IRFslow=squeeze(prctile(IRFs,5,3));
IRFshigh=squeeze(prctile(IRFs,95,3));


figure;

for jj=1:setup.size_obs
    subplot(setup.size_obs,1,jj)
    plot(1:setup.lags+1,IRFsmed(jj,:),1:setup.lags+1,IRFslow(jj,:),'k--',1:setup.lags+1,IRFshigh(jj,:),'k--',...
        1:setup.lags+1,squeeze(setup.store_responses(jj,setup.index_unrestricted,:)),'Linewidth',2)
    title(sprintf('IRF, shock size = %i', size_of_shock))
end
legend('median','5th percentile','95th percentile','VAR')

% print -depsc

clear IRFs

