module ResqueWeb
  class QueuesController < ResqueWeb::ApplicationController

    include ResqueWeb::QueuesHelper

    def index
      respond_to do |format|
        format.html
        format.json { render json: queues_overview }
      end
    end

    def show
      set_subtabs view_context.queue_names
    end

    def destroy
      Resque.remove_queue(params[:id])
      redirect_to queues_path
    end

    def clear
      Resque.redis.del("queue:#{params[:id]}")
      redirect_to queue_path(params[:id])
    end

    protected

    def queues_overview
      normal_queues = queue_names.each_with_object({}) do |queue_name, memo|
        memo[queue_name] = queue_size(queue_name)
      end

      {
        overview: normal_queues,
        failed: failed_queue_size('failed')
      }
    end
  end
end
