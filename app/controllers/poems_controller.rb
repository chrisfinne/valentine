class PoemsController < ApplicationController
  @@objects = @@adjectives = []

  def create
    @poem = Poem.new(from_name: params[:my_name], to_name: params[:recipient_name], to_email: params[:email])
    if @poem.save
      redirect_to :back, notice: "Your poem:\n\n#{@poem.text}\n\nhas been delivered!"
    else
      errors = ''
      @poem.errors.each {|k,v| errors << v <<  "\n" }
      redirect_to :back, alert: "Error sending poem:\n #{errors}"
    end
  end

  def index
    @poems = Poem.all
  end
end
