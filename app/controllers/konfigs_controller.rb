class KonfigsController < ApplicationController
  authorize_resource

  before_action :get_configs

  def index
  end

  def update
  end

  def update_multiple
    respond_to do |format|

      params[:konfig_ids].each do |id, item|
        @config = Konfig.find(id)
        @config.update( value: item[:value] )
      end

      if @config.errors.any?
        format.html { render action: :update }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to configs_path, notice: 'Config was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  private

  def get_configs
    unauthorized unless can? :manage, Konfig
    @configs = Konfig.order(:name)
  end

end
