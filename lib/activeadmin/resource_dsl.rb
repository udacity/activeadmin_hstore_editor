#-*- encoding: utf-8; tab-width: 2 -*-
require 'activeadmin'

module ActiveAdmin
  class ResourceDSL
    def json_editor
      before_save do |object, _args|
        request_namespace = object.class.name.underscore.tr('/', '_')
        if params.key? request_namespace
          object.class.columns_hash.select { |_key, attr| attr.type.in? [:json, :jsonb] }.keys.each do |key|
            next unless params[request_namespace].key? key
            json_data = params[request_namespace][key]
            data = if json_data == 'null' || json_data.blank?
                     {}
                   else
                     JSON.parse(json_data)
            end
            object.attributes = { key => data }
          end
        else
          raise ActionController::ParameterMissing, request_namespace
        end
      end
    end
  end
end
