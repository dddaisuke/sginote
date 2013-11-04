class NotesController < ApplicationController
  include ::ActionView::Helpers::SanitizeHelper
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  MODE = 1

  def index
    @notes = Note.all
  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)
    @note.user_id = 1
    @note.notebook_id = 1

    respond_to do |format|
      if @note.save
        format.html { redirect_to root_path, notice: 'Note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @note }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(title: note_params[:note_title][:value], body: note_params[:note_body][:value])
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def morpheme
    sentence = URI.encode(strip_tags(note_params[:sentence]))
    query = "http://jlp.yahooapis.jp/MAService/V1/parse?appid=#{Yahoo::APPID}&results=ma,uniq&filter=9&uniq_filter=9&sentence=#{sentence}"
    xml = http_get(query)
    doc = ActiveSupport::XmlMini.parse(xml)

    word_list = doc['ResultSet']['uniq_result']['word_list']['word']
    contents = []
    contents = word_list.each.map do |word|
      word['surface']['__content__']
    end
    render json: contents.to_json
  end

  def find_word
    word = note_params[:word]
    if word =~ /^\d+$/ || word.size == 1
      return render json: { link: nil, word: word }
    end

    if MODE == 1
      link = find_word_on_wikipedia(word)
    else
      link = find_word_on_uncyclopedia(word)
    end
    render json: { link: link, word: word }
    # @link = []
    # @links << find_word_on_wikipedia(content1)
    # @links << find_word_on_wikipedia(content2)
    # @links << find_word_on_wikipedia(content3)
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def note_params
    if params[:action] == 'update'
      params.require(:content).permit(note_title: :value, note_body: :value)
    elsif params[:action] == 'morpheme'
      params.permit(:sentence)
    elsif params[:action] == 'find_word'
      params.permit(:word)
    else
      params.require(:note).permit(:notebook_id, :title, :body, :user_id)
    end
  end

  def http_get(query)
    url = URI.parse(query)
    req = Net::HTTP::Get.new(url.path + '?' + url.query)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    res.body
  end

  def find_word_on_uncyclopedia(word)
    query = "http://ja.uncyclopedia.info/api.php?action=query&format=xml&titles=#{URI.encode(strip_tags(word))}"
    xml = http_get(query)
    doc = ActiveSupport::XmlMini.parse(xml)
    pageid = doc['api']['query']['pages']['page']['pageid']
    if pageid
      "http://ja.uncyclopedia.info/wiki/#{URI.encode(strip_tags(content1))}"
    end
  end

  def find_word_on_wikipedia(word)
    query = "http://ja.wikipedia.org/w/api.php?action=query&format=xml&titles=#{URI.encode(strip_tags(word))}"
    xml = http_get(query)
    doc = ActiveSupport::XmlMini.parse(xml)
    pageid = doc['api']['query']['pages']['page']['pageid']
    if pageid
      "http://ja.wikipedia.org/wiki/#{URI.encode(strip_tags(word))}"
    end
  end
end
