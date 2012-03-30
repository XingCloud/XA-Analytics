module MenuSortable
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def reorder(params)
      params=convert_url_params_to_hash(params)
      menus = Menu.find(params.keys)
      ActiveRecord::Base.transaction do
        self.restructure_ancestry(menus, params)
        self.sort(menus, params)
      end
    end

    #
    def conver_str(params_arrs)
      temp = params_arrs.delete_if { |item| item.to_s == "" }
      temp.map { |item| item }.join("&")
    end

    # converts a typical string of url params like this:
    #     "list[1]=root&list[7]=1&list[8]=1&list[2]=root&list[5]=2&list[6]=5"
    # into a nice hash like this:
    #     {1=>nil, 7=>1, 8=>1, 2=>nil, 5=>2, 6=>5}
    # notice that 'root' is substituted by nil and the numbers are integers and not strings
    #
    def convert_url_params_to_hash(params)
      params = Rack::Utils.parse_query(params)
      params = params.values.flatten
      params = params.delete_if { |item| item.to_s == "" }
      params = rebuild(params)
      # in this point params looks like this:
      #     {"list[6]"=>"root", "list[8]"=>"6", "list[2]"=>"8", "list[5]"=>"2", "list[1]"=>"6", "list[7]"=>"1"}

      params = Rack::Utils.parse_query(params)
      params.map do |k, v|
        cat_id = k.match(/\[(.*?)\]/)[1]
        parent_id = v=='root' ? nil : v.to_i
        {cat_id.to_i => parent_id}
      end.inject(&:merge)
    end

    def restructure_ancestry(menus, params)
      menus.each do |cat|
        cat.update_attributes({:parent_id => params[cat.id]})
      end
    end

    def sort(menus, params)
      hierarchy = convert_params_to_hierarchy(params)
      menus.each do |cat|
        cat.sort(hierarchy[cat.parent_id])
      end
    end

    def convert_params_to_hierarchy(params)
      params.hash_revert
    end

    def find_all_root(arr)
      arrs = []
      arr.each_with_index do |item, index|
        if item.include?("root")
          arrs << index
        end
      end
      arrs
    end

    def find_all_children(arr, index)
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

    def assign_value(str, val)
      temp = str.split("=")
      if temp && temp.length == 2
        temp[1] = val
      end
      "#{temp[0]}=#{temp[1]}"
    end

    def rebuild(arr)
      roots = find_all_root(arr)
      roots.each do |index|
        children = find_all_children(arr, index)
        children.each do |item|
          root_id = find_root_id(arr[index])
          arr[item] = assign_value(arr[item], root_id)
        end
      end
      arr.join("&")
    end

  end

  module InstanceMethods
    # sorts one node between its siblings accorrding to the 
    # ordered list of ids _ordered_siblings_ids_
    #
    def sort(ordered_siblings_ids)
      return if ordered_siblings_ids.length==1
      if ordered_siblings_ids.first == id
        move_to_left_of siblings.find(ordered_siblings_ids.second)
      else
        move_to_right_of siblings.find(ordered_siblings_ids[ordered_siblings_ids.index(id) - 1])
      end
    end
  end

end