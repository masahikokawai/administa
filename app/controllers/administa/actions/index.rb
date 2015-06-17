module Administa
  module Actions
    module Index

      def index
        @result = index_result

        respond_to do |format|
          format.html
          format.json { render json: @result }
        end
      end

      protected
        def index_result
          page  = params[:page].try(&:to_i)
          limit = params[:limit].try(&:to_i)
          order = params[:order]
          q     = params[:q]

          includes = model.includes(:index)
          resources = model.
            select(includes: includes).
            filter_by_keywords(q).
            order(order).
            paginate(page: page, limit:limit)

          result = {
            name:       model.name.pluralize,
            settings:   model.settings,
            resources:  model.as_json(resources.to_a, includes: model.includes(:index)),
            pagination: resources.pagination_metadata.merge(:q => q),
          }

          result
        end

    end
  end
end
