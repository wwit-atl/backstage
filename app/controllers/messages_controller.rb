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
    #@message.approver = current_member if current_member.is_admin?

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path, flash: { success: 'Message was successfully created.' } }
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
        format.html { redirect_to messages_path, flash: { success: 'Message was successfully updated.' } }
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

  def approve
    @message = Message.find(params[:message_id])
    if can? :approve, @message
      @message.approver = current_member
      if @message.save
        redirect_to messages_path, flash: { success: 'Message Approved' }
      else
        redirect_to messages_path, flash: { error: 'Unable to approve message' }
      end
    end
  end

  def resend_email
    @message = Message.find(params[:message_id])

    if can? :send, @message
      if @message.delivered?
        redirect_to messages_path, flash: { info: 'Email(s) have already been delivered' }
        return
      end

      if !@message.sent_at.nil? and ( Time.now() - @message.sent_at ) < 600
        redirect_to messages_path, flash: { info: 'Please wait 10 minutes between retrys' }
        return
      end

      if @message.send_email
        redirect_to messages_path, flash: { success: 'Email(s) Sent' }
      else
        redirect_to messages_path, flash: { error: 'Unable to send email(s)!' }
      end
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
