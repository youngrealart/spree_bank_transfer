module Spree
  class PaymentsController < Spree::StoreController
    before_action :authenticate_spree_user!
    before_action :find_payment

    def update
      payment_details = PaymentDetails.new(@payment, payment_params)
      if payment_details.save
        flash[:notice] = Spree.t(:payment_successfully_updated)
      else
        flash[:error] = payment_details.errors.to_sentence
      end
      redirect_to :back
    end

    def find_payment
      @payment = spree_current_user.payments.friendly.find(params[:id])
      logger.debug "User email: #{spree_current_user.email}"
      unless @payment
        flash[:error] = Spree.t(:payment_not_found)
        redirect_to :back
      end
    end
    
    private
      def payment_params
        params.require(:payment).permit(:deposited_on, :bank_name, :account_no, :transaction_reference_no)
      end
  end
end
