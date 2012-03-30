#params = "[]=&[]=parent_5&[]=child_11&[]=child_6&[]=child_6190&[]=parent_7&[]=child_9&[]=parent_8&[]=child_10&[]=parent_6189&[]=parent_6191&[]=child_6192"

#{1=>nil, 7=>1, 8=>1, 2=>nil, 5=>2, 6=>5}


hash = {"[]"=>["", "menu[6]=5", "menu[5]=root", "menu[7]=root", "menu[9]=7", "menu[8]=root", "menu[10]=8", "menu[11]=8", "menu[6189]=root", "menu[6190]=6189", "menu[6191]=root", "menu[6192]=6191"]}

# url Rack::Util.parse
hsh = {"[]"=>["", "menu[5]=root", "menu[6]=5", "menu[11]=8", "menu[7]=root", "menu[9]=7", "menu[8]=root", "menu[10]=8", "menu[6189]=root", "menu[6190]=6189", "menu[6191]=root", "menu[6192]=6191"]}
arr =  hsh.values.flatten

arr = arr.delete_if { |item| item.to_s == "" }

p arr

def find_all_root(arr)
  arrs = []
  arr.each_with_index do |item,index|
    p item
    if item.include?("root")
       arrs << index
     end
  end
  arrs
end

def find_all_children(arr,index)
  arrs = []
  for i in (index + 1)...arr.length do

    if arr[i] && arr[i].include?("root")
       break
     else
       arrs << i
     end
  end
  arrs
end

def find_root_id(str)
  str.match(/\[(.*?)\]/)[1]
end

def assign_value(str,val)
   temp = str.split("=")
   if temp && temp.length == 2
     temp[1] = val
   end
  "#{temp[0]}=#{temp[1]}"
end

def rebuild(arr)
   roots = find_all_root(arr)
   roots.each do |index|
     children = find_all_children(arr,index)
     children.each do |item|
        root_id = find_root_id(arr[index])
       arr[item]  =  assign_value(arr[item],root_id)
     end
   end
  arr.join("&")
end

p find_all_root(arr)

p find_all_children(arr,9)

p rebuild(arr)



