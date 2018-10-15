require 'pixela'
require 'time'

module Embulk
  module Output

    class PixelaOut < OutputPlugin
      Plugin.register_output("pixela", self)

      def self.transaction(config, schema, count, &control)
        # configuration code:
        task = {
          "name" => config.param("name", :string),
          "token" => config.param("token", :string),
          "graph_id" => config.param("graph_id", :string),
          "quantity_float_column" => config.param("quantity_float_column", :string, default: nil),
          "quantity_int_column" => config.param("quantity_int_column", :string, default: nil),
          "date_column" => config.param("date_column", :string),
        }

        # resumable output:
        # resume(task, schema, count, &control)

        # non-resumable output:
        task_reports = yield(task)
        next_config_diff = {}
        return next_config_diff
      end

      # def self.resume(task, schema, count, &control)
      #   task_reports = yield(task)
      #
      #   next_config_diff = {}
      #   return next_config_diff
      # end

      def init
        # initialization code:
        @name = task["name"]
        unless @name
          raise "'name' is required."
        end
        @token = task["token"]
        unless @token
          raise "'token' is required."
        end
        @graph_id = task["graph_id"]
        unless @graph_id
          raise "'graph_id' is required."
        end
        @quantity_float_column = task["quantity_float_column"]
        @quantity_int_column = task["quantity_int_column"]
        unless @quantity_float_column || @quantity_int_column
          raise "Choose 'quantity_int_column' or 'float_column'."
        end
        @date_column = task["date_column"]
        unless @date_column
          raise "'date_column' is required."
        end

        @client = Pixela::Client.new(username: @name, token: @token)
      end

      def close
      end

      def add(page)
        Embulk.logger.info { "Connecting to https://pixe.la/v1/users/#{@client.username}/graphs/#{@graph_id}" }
        page.each do |record|
          data = Hash[schema.names.zip(record)]
          # Choose only target columns
          quantity = data["#{@quantity_float_column}"] if @quantity_float_column
          quantity = data["#{@quantity_int_column}"] if @quantity_int_column
          d        = data["#{@date_column}"]
          begin
            @client.create_pixel(graph_id: @graph_id, date: d, quantity: quantity)
          rescue Pixela::PixelaError => e
            Embulk.logger.warn {"#{d}: #{e}"}              
          end
        end
      end

      def finish
      end

      def abort
      end

      def commit
        task_report = {}
        return task_report
      end
    end

  end
end
