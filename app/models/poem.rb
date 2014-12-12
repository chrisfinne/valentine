class Poem < ActiveRecord::Base
  validates_presence_of :from_name, message: "I don't know who you are."
  validates_presence_of :to_name, message: "Who is your valentine?"
  validates_presence_of :text
  validates_uniqueness_of :text, case_sensitive: false

  validate :validate_to_email

  before_validation :generate_poem
  after_save :email_poem

  OBJECTS = ["hair is", "eyes are", "lips are"].freeze
  ADJECTIVES = ["gentle", "beautiful", "breathtaking"].freeze

  protected

    def email_poem
      PoemMailer.send_poem(self).deliver
    end

    def generate_poem
      self.text = "#{to_name}, your #{OBJECTS.sample} sooo much more #{ADJECTIVES.sample} than mine!\nBe my Valentine!\n\nYours,\n#{from_name}"
    end

    def validate_to_email
      if to_email.blank?
        errors.add(:to_email, "Don't know who to send this to.")
        return
      end
      errors.add(:to_email, "Sorry, your beloved's email is not valid.") unless is_valid_email?(to_email)
    end


    def is_valid_email?(str)
      begin
        m = Mail::Address.new(str)
        # We must check that value contains a domain and that value is an email address
        return false unless m.domain && m.address == str
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
    end

end
