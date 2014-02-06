class MessagesController < ApplicationController
  authorize_resource

  before_action :set_message, only: [:edit, :update, :destroy]
  before_action :set_members, only: [:new, :create, :edit, :update]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.by_sent.paginate(page: params[:page], per_page: 10)
    current_member.last_message = @messages.first
    current_member.save
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
    @members = Member.all
  end

  # POST /messages
  # POST /messages.json
  def create
    @members = Member.all
    @message = Message.new(message_params)

    @message.sender   = current_member
    @message.approver = current_member if current_member.is_admin?

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path, notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to messages_path, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    def set_members
      @members = Member.active.by_name
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.required(:message).permit(:subject, :message, member_ids: [])
    end
end
