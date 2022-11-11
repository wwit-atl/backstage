class Document < ActiveRecord::Base
    validates :doc_name, presence: true # Make sure the owner's name is present.
    has_attached_file :document
    validates_attachment :document, :content_type => {:content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}
    #mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.   
end