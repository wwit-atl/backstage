class AuditsController < ApplicationController
  authorize_resource

  def index
    @type = params[:type].to_s.underscore.camelize
    @type = nil if @type.blank?
    @audits = @type ? Audit.where(ident: @type) : Audit.all
    @audits = @type ? Audit.where(ident: @type.singularize) : Audit.all if @audits.empty?
    @audits = @audits.limit(500).paginate(page: params[:page], per_page: 50)
  end

end
