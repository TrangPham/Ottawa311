class ChartController < ApplicationController
  def index

  end

  def charts
    params[:input] ||= ServiceRequest.all
    params[:select] ||= {} #eg. {"ward" => 3, "month" => "August"}
    groups = group_mapping[(params[:group]||"init").to_sym] || []

    results = []
    params[:select].each do |k, v|
      params[:input] = params[:input].where(k => v)
    end
    groups.each do |group|
      results << {group: group.to_s, columns: params[:input].select(group).group(group).count(group)}
    end
    @results = {results: results,
                select: params[:select],
                total: params[:input].count,
                title: title(params[:select])}
  end

  private
    def group_mapping
      {
        init: [:month, :ward],
        month: [:ward],
        ward: [:call_type],
        call_type: [:call_description, :maintenance_yard],
        call_description: [:maintenance_yard]
      }
    end

    def title(select)
      title_order = ["month", "ward", "call_type"]
      title = "All > "
      title_order.each do |key|
        title +=  "#{key.titleize}: #{select[key]} > "if select.key? key
      end
      title
    end
end