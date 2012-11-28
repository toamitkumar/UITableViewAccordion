class AccordionViewController < UITableViewController

  attr_reader :expanded_row_index, :data

  def init
    if(super)
      @expanded_row_index = -1
      @data = []
      (0..100).each_with_index{|a, i| @data << "Data Cell #{i}"}
    end

    self
  end

  def shouldAutorotateToInterfaceOrientation(to_interface_orientation)
    true
  end

  def tableView(table_view, numberOfRowsInSection:section)
    @data.size + (@expanded_row_index == -1 ? 0 : 1)
  end

  def tableView(table_view, cellForRowAtIndexPath:index_path)
    row = index_path.row
    data_index = data_index_for_row_index(row)
    data = @data[data_index]

    expanded_cell = (@expanded_row_index != -1 and @expanded_row_index + 1 == row)

    if(not expanded_cell)
      cell = table_view.dequeueReusableCellWithIdentifier("data")
      unless(cell)
        cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"data")
      end
      cell.textLabel.text = data
      cell
    else
      cell = table_view.dequeueReusableCellWithIdentifier("expanded")
      unless(cell)
        cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:"expanded")
      end
      cell.textLabel.text = "Details for cell - #{data}"
      cell
    end
  end

  def tableView(table_view, willSelectRowAtIndexPath:index_path)
    row = index_path.row
    prevent_reopen = false

    return nil if(@expanded_row_index != -1 and @expanded_row_index + 1 == row)

    table_view.beginUpdates
    if(@expanded_row_index != -1)
      row_to_remove = @expanded_row_index + 1
      prevent_reopen = row == @expanded_row_index

      row = row - 1 if(row > @expanded_row_index)

      @expanded_row_index = -1


      table_view.deleteRowsAtIndexPaths([NSIndexPath.indexPathForRow(row_to_remove, inSection:0)], withRowAnimation:UITableViewRowAnimationTop)
    end

    row_to_add = -1
    if(not prevent_reopen)
      row_to_add = row + 1
      @expanded_row_index = row

      table_view.insertRowsAtIndexPaths([NSIndexPath.indexPathForRow(row_to_add, inSection:0)], withRowAnimation:UITableViewRowAnimationTop)
    end

    table_view.endUpdates

    nil
  end

  def tableView(table_view, heightForRowAtIndexPath:index_path)
    row = index_path.row

    if(@expanded_row_index != -1 and @expanded_row_index + 1 == row)
      100
    end

    40
  end

  def data_index_for_row_index(row)
    if(@expanded_row_index != -1 and @expanded_row_index <= row)
      (@expanded_row_index == row) ? row : (row-1)
    else
      row
    end
  end
end