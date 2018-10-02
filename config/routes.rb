Rails.application.routes.draw do
  get '/:slug/referrals/new', to: 'referrals#new', as: 'new_partner_referral'
  get '/referrals', to: 'referrals#index', as: 'referrals'
  get '/:slug/referrals/:id', to: 'referrals#show', as: 'referral'

  get  '/referral/:id/reviews/new', to: 'reviews#new', as: 'new_referral_review'
  post '/referral/:id/reviews/new', to: 'reviews#create'

  post '/webhooks/new-response/:token', to: 'webhooks#new_response', as: 'webhooks_new_response'
end