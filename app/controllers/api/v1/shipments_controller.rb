class Api::V1::ShipmentsController < Api::ApiBase
  before_action :find_and_update_shipment, only: [:ship]
  respond_to :json

  def ship
    @shipment.ship! unless @shipment.shipped?
    respond_with(@shipment, default_template: :show)
  end

  private
  def find_and_update_shipment
    @shipment = Shipment.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
    @shipment.update_attributes(shipment_params)
    @shipment.reload
  end

  def shipment_params
    if params[:shipment] && !params[:shipment].empty?
      params.require(:shipment).permit!
    else
      {}
    end
  end
end