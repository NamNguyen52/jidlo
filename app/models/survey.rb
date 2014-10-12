class Survey < ActiveRecord::Base

	#attr_accessor :people, :name, :location

  validates_inclusion_of :people, in: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  #validates :name, format: { with: /\A[a-zA-Z]+\z/ }
  #validates_format_of :name, :with => /^[a-zA-Z]$/ 
  #validates_format_of :name, :with => /^[a-zA-Z]$/ #, :on => :create
  #validates :name, length: { minimum: 10 }
  validates :name, length: { maximum: 25 }
  validates_presence_of :people, :name, :location, :on => :create
  validates_format_of :location, :with => /^[A-Za-z0-9,. ]+$/, :on => :create, :multiline => true



end
