#!/usr/bin/env ruby
require 'json'

orig = JSON.load File.read 'orig.json'

data = {}
orig.each do |program|
	data[program['name']] = {
		name: program['name'],
		type: program['family'],
#		group: program['category'],
#		type: program['family'],
		depends: program['relatedItemsParents'].collect do |parent|
			parent.gsub(/\[\[(.*)\]\]/, '\\1').strip
		end
	}
end
data.each do |k, v|
#	data.delete k if v[:depends].empty?
	if v[:depends].empty? and data.values.select { |y| y[:depends].include? k }.empty?
		data.delete k
	end
end
#data.each do |k, v|
#	v[:depends].each do |p|
#		v[:depends].delete p if data[p].nil?
#	end
#end

data = { data: data, errors: [] }
File.write 'json', JSON.generate(data)

