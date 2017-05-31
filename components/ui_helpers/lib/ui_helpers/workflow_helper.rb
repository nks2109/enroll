module UIHelpers
  module WorkflowHelper
    def workflow_form_for(model, &block)
      path, method = if model.new_record?
        [controller.request.path.sub('new', 'step'), :post]
      else
        [controller.request.path.sub('new', "#{model.id}/step"), :put]
      end

      form_tag path, method: method do
        yield
      end
    end

    def previous_step_for member_id
      send("go_to_step_#{@model.class.name.underscore.gsub('/', '_')}_path", @model.id, @current_step.to_i - 1, member_id)
    end
  end
end
