module Administa
  module Actions
    module Index

      def index
        @result = index_result

        respond_to do |format|
          format.html
          format.json { render json: to_json(@result) }
        end
      rescue => e
        handle_exception(e)
      end

      protected
        def default_result
          {
            name:       model.name.pluralize,
            settings:   model.settings,
            csrf_token: form_authenticity_token,
          }

        end

        def index_result
          page  = params[:page].try(&:to_i)
          limit = params[:limit].try(&:to_i)
          order = params[:order]
          q     = params[:q]

          resources = model.
            select(action: :index).
            filter_by_keywords(q).
            order(order).
            paginate(page: page, limit:limit)

          result = default_result
          result[:resources]  = model.as_json(resources.to_a, action: :index)
          result[:pagination] = resources.pagination_metadata.merge(:q => q)

          result
        end

    end
  end
end
