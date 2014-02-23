class MessagesController < ApplicationController
  authorize_resource

  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :set_members, only: [:new, :create, :edit, :update]
  before_action :parse_member_params, only: [:create, :update]

  # GET /messages
  # GET /messages.json
  def index
    messages = ( can? :manage, Message ) ? Message.all : Message.for_member(current_member)
    @messages = messages.by_created.paginate(page: params[:page], per_page: 15)

    current_member.last_message = @messages.first
    current_member.save
  end

  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    @message.member_ids = params[:members]
    @message.subject    = params[:subject]
    @message.message    = params[:message]
  end

  # GET /messages/1/edit
  def edit
    unauthorized if @message.approved?
    @members = Member.all
  end

  # POST /messages
  # POST /messages.json
  def create
    @members = Member.all
    @message = Message.new(message_params)
    @message.sender = current_member

    respond_to do |format|
      if @message.save
        # Send managers an email letting them know there's a new message
        BackstageMailer.waiting_for_approval(@message).deliver unless can? :approve, @message

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
    unauthorized && return if @message.approved?
    @members = Member.all
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
      if BackstageMailer.announcements(@message).deliver
        @message.save
        redirect_to messages_path, flash: { success: 'Message Approved and Sent' }
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

      if BackstageMailer.announcements(@message).deliver
        @message.save
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
      @skills = Skill.all
      @roles = Role.viewable(current_member)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.required(:message).permit(:subject, :message, member_ids: [])
    end

    def parse_member_params
      members =  (params[:message][:member_ids] || []).map { |id| id.to_i unless id.blank? }
      members << (params[:skill_ids]  || []).map { |id| Skill.find(id).member_ids }
      members << (params[:role_ids]   || []).map { |id| Role.find(id).member_ids }
      params[:message][:member_ids] = members.flatten.compact.uniq
    end
end
