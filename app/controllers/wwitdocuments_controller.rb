class WwitdocumentsController < ApplicationController
    authorize_resource #Who do we need to authorize, determine if we need to authorize differently for those who can upload vs. those who read
    def index
        @wwitdocuments = Wwitdocument.all
    end

    def new
        @wwitdocument = Wwitdocument.new
    end

    def create
        @wwitdocument = Wwitdocument.new(wwitdocument_params)
    
        if @wwitdocument.save
            redirect_to wwitdocuments_path, notice:"Successfully uploaded"
        else
            render "new"
        end
    end

    def destroy
        @wwitdocument = Wwitdocument.find(params[:id])
        @wwitdocument.destroy
        redirect_to wwitdocuments_path, notice: "Successfully deleted"
    end

    private
        def wwitdocument_params
            params.require(:wwitdocument).permit(:doc_name, :attachment)
        end
end