class Note < ActiveRecord::Base
  belongs_to :notebook
  after_save :update_counter_cache

  private

  def update_counter_cache
    count = self.notebook.notes.count
    notebook.update_attributes(notes_count: count)
  end
end
