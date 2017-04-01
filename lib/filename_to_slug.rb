require 'stringex'
require 'digest/md5'

class String
  def filename_to_slug
    s = self.to_url
    if s.blank?
      return Digest::MD5.hexdigest(self)
    end
    s
  end
end
