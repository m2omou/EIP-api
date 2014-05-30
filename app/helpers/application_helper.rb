module ApplicationHelper

  def   self.checkEmptyValue(params)
    if params.empty?
      return 0
    end
    return params
  end

  def self.jsonResponseFormat(responseCode, responseMessage, result)
      return { :responseCode => responseCode,
               :responseMessage => responseMessage,
               :result => result }
  end
end
