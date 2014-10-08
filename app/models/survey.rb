class Survey < ActiveRecord::Base

  validates_inclusion_of :people, in: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  #validates :name, format: { with: /\A[a-zA-Z]+\z/ }
  #validates_format_of :name, :with => /^[a-zA-Z]$/ 
  #validates_format_of :name, :with => /^[a-zA-Z]$/ #, :on => :create
  #validates :name, length: { minimum: 10 }
  validates_presence_of :name


end
