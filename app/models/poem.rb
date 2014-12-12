class Poem < ActiveRecord::Base
  validates_presence_of :from_name, :to_name, :text
  validates_uniqueness_of :text

  validate :validate_to_email

  before_validation :generate_poem
  after_save :email_poem

  @@objects = @@adjectives = []
  @@objects << "hair is" << "eyes are" << "lips are"
  @@adjectives << "gentle" << "beautiful" << "breathtaking"



  protected

    def email_poem
      PoemMailer.send_poem(self).deliver
    end

    def generate_poem
      o = @@objects[rand(@@objects.length)]
      a = @@adjectives[rand(@@adjectives.length)]

      self.text = "#{to_name}, your #{o} sooo much more #{a} than mine!\nBe my Valentine!\n\nYours,\n#{from_name}"

    end

    def validate_to_email
      is_valid_email = 
        begin
          m = Mail::Address.new(to_email)
          # We must check that value contains a domain and that value is an email address
          return false unless m.domain && m.address == to_email
          t = m.__send__(:tree)
          # We need to dig into treetop
          # A valid domain must have dot_atom_text elements size > 1
          # user@localhost is excluded
          # treetop must respond to domain
          # We exclude valid email values like <user@localhost.com>
          # Hence we use m.__send__(tree).domain
          return t.domain.dot_atom_text.elements.size > 1
        rescue Exception => e
          false
        end

      errors.add(:to_email, "is not valid") unless is_valid_email
    end

end
