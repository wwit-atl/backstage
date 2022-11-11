class Document < ActiveRecord::Base
    validates :name, presence: true # Make sure the owner's name is present.
    has_attached_file :attachment
    validates_attachment :attachment, :content_type => {:content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}   
end