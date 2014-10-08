module ApplicationHelper
  def model_error? model, field
     'error' unless model.errors.messages[field].nil?
  end
end
