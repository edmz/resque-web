module ResqueWeb
  class QueuesController < ResqueWeb::ApplicationController

    def index
      respond_to do |format|
        format.html
        format.json do
          Resque.queues.sort_by(&:to_s).each_with_object({}) do |queue_name, memo|
            memo[queue_name] = Redis.queue_size(queue_name)
          end
        end
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

  end
end
