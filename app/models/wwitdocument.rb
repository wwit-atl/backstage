class Wwitdocument < ActiveRecord::Base
    validates :doc_name, presence: true # Make sure the owner's name is present.
    mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.   
end