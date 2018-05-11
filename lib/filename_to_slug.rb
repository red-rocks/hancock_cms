if ::Hancock.mongoid?
  require 'stringex'
end
require 'digest/md5'

class String
  def filename_to_slug
    s = self.to_url
    s = Digest::MD5.hexdigest(self) if s.blank?
    s
  end
end
