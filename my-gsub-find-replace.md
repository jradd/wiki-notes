```ruby
class String
  def tgs(str1, str2)
    #create charactor arrays from all three strings
    c1 = self.chars
    c2 = str1.chars
    c3 = str2.chars
	#create array to store matched indices in
    match = Array(Int32).new
	#loop through first string array
    c1.each_with_index do |p1, i|
      match.clear #make sure array is empty 
      if p1 == c2.first #check if char matches for char of query string 
        c2.each_with_index do |p2, j| #loop through and find out if the whole word matches.
          match << i + j if (p2 == c1[i+j]?)
        end
        # break if whole string was found.
        break if match.size == c2.size
      end
    end
    # create strings for before and after match
    c1a = c1[0...match.first]
    c1b = c1[(match.last + 1)..-1]
    (c1a + c3 + c1b).join # insert replacement in the middle, join and return
  end
end

str = "my name is isaac. Would you like to go to the ball this saturday?"
puts str.tgs("saturday", "Sunday").inspect
```

