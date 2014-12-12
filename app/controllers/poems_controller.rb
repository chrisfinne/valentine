class PoemsController < ApplicationController
  @@objects = @@adjectives = []

  def create
    @poem = Poem.new(from_name: params[:my_name], to_name: params[:recipient_name], to_email: params[:email])
    if @poem.save
      redirect_to :back, notice: "Your poem #{@poem.text} has been delivered!"
    else
      logger.debug @poem.errors.inspect
      redirect_to :back, alert: "Error sending poem"
    end
  end

  def create_old
    @@objects << "hair is" << "eyes are" << "lips are"
    @@adjectives << "gentle" << "beautiful" << "breathtaking"

    redirect_to :back

    o = @@objects[rand(@@objects.length)]
    a = @@adjectives[rand(@@adjectives.length)]

    if params[:my_name]
      t = "#{params[:recipient_name]}, your #{o} sooo much more #{a} than mine!\nBe my Valentine!\n\nYours,\n#{params[:my_name]}"

      p = Poem.all.find {|p| p.text == t}
      if p
        flash[:alert] = "This poem already exists"
      else
        p = Poem.new text: t
        p.save
        if params[:email]
          PoemMailer.send_poem(p, params).deliver
          flash[:notice] = "Your poem #{t} has been delivered!"
        else
          flash[:alert] = "Don't know who to send this to."
        end
      end
    else
      flash[:alert] = "I don't know who you are."
    end
  end

  def index
    @poems = Poem.all
  end
end
