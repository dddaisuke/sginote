class TopController < ApplicationController
  def index
    @note_id = Note.all.order('updated_at DESC').first.id
  end
end
