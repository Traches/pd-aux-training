class Document < ApplicationRecord
  # This is used for both newsletters and the document library. 

  # Associations:

  # These are the parameters required by the paperclip gem. 
  has_attached_file :file,                                      # Name of the attachment. Could be more original I suppose
    storage: :s3,                                               # Uses AWS s3 for storage
    s3_credentials: Proc.new{ |a| a.instance.s3_access_creds }, # Defined below.
    s3_permissions: :private,                                   # Files uploaded will be accessible only with this access ID & key
    s3_region: 'us-east-2',                                     # Paperclip needs to know which region the bucket is kept in.
    s3_protocol: 'https'                                        # Use HTTPS to upload files

  # Validations:
  # Ensure attachment is present:
  validates_with AttachmentPresenceValidator, attributes: :file
  # Ensure attachment is an acceptable filetype, defined below:
  validates_with AttachmentContentTypeValidator,
    attributes: :file,
    content_type: Proc.new{ |a| a.instance.allowed_file_types },
    message: "That is not an allowed file type. Currently you can upload .pdf,
    word, powerpoint, excel, image, and text files. It's simple to enable new file
    types; send me an email and I'll take care of it! rbuchberger@gmail.com"

  # Make sure they don't blow up my S3 account:
  validates_with AttachmentSizeValidator, attributes: :file, less_than: 100.megabytes

  # Callbacks:

  # Scopes:

  # Custom Methods:

  private

  def s3_access_creds
    {
      bucket:  Rails.application.secrets.aws_bucket, 
      access_key_id: Rails.application.secrets.aws_acces_key_id,
      secret_access_key: Rails.application.secrets.aws_secret_key 
    }
  end

  def allowed_file_types
    # Array of acceptable MIME types, for the paperclip attachment content type
    # validator. May want to extract this to a config file. 

    [
      # PDF
      /\Aapplication\/pdf/,

      # Text Files
      /\Atext\/plain/,

      # Images
      /\Aimage\/jpeg/,
      /\Aimage\/png/,

      # Word Documents
      /\Aapplication\/msword/,
      /\Aapplication\/vnd.openxmlformats-officedocument.wordprocessingml.document/,

      # Excel files
      /\Aapplication\/vnd.ms-excel/,
      /\Aapplication\/vnd.openxmlformats-officedocument.spreadsheetml.sheet/,

      # Powerpoint presentations
      /\Aapplication\/vnd.ms-powerpoint/,
      /\Aapplication\/vnd.openxmlformats-officedocument.presentationml.presentation/,
    ]
  end

end