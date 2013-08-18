class TeammatesController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_teammate, only: [:edit, :update, :destroy]

  def index
    setup_to_render_main
    register_to_pubsub!
  end

  def new
    @teammate = Teammate.new
    setup_to_render_main
    register_to_pubsub!
  end

  def create
    @teammate = @team.teammates.build(teammate_params)
    respond_to do |format|
      if @teammate.save
        notice = "New teammate was created."
        publish!("create", object: @teammate)
        format.html { redirect_to teammates_url, notice: notice }
        format.js   { setup_to_render_main; flash.now[:notice] = notice }
      else
        format.html { setup_to_render_main(true); render :new }
        format.js   { render :create_error }
      end
    end
  end

  def edit
    setup_to_render_main
    register_to_pubsub!
  end

  def update
    respond_to do |format|
      if @teammate.update(teammate_params)
        notice = "Teammate #{@teammate.name.inspect} was updated."
        publish!("update", object: @teammate)
        format.html { redirect_to teammates_url, notice: notice }
        format.js   { setup_to_render_main; flash.now[:notice] = notice; render :create }
      else
        format.html { setup_to_render_main(true); render :edit }
        format.js   { render :update_error }
      end
    end
  end

  def destroy
    @teammate.destroy
    warning = "Teammate #{@teammate.name.inspect} was deleted."
    publish!("destroy", object: @teammate)
    respond_to do |format|
      format.html { redirect_to teammates_url, warning: warning }
      format.js   { setup_to_render_main; flash.now[:warning] = warning }
    end
  end

  def export
    respond_to do |format|
      format.csv {
        send_data(exporter.teammates(:csv, team: @team),
          filename: "teammates-#{Time.zone.today.to_s(:db)}.csv")
      }
    end
  end

  def import_form
    setup_to_render_main
    @required_columns = DataExchange::ImportTeammatesCsv::MANDATORY
    @optional_columns = DataExchange::ExportTeammatesCsv::HEADER - @required_columns
  end

  def import
    result = importer.teammates(csv: import_params.read, team: @team)
    publish!("import:success")
    flash[:info] = "Import was successful: #{result[:added]} added, #{result[:updated]} updated."
  rescue StandardError => error
    flash[:error] = "Import failed: #{error.message}"
  ensure
    redirect_to teammates_url
  end

  def refresh
    setup_to_render_main
    render layout: false
  end

  private

  def setup_to_render_main(reload = false)
    @team.teammates.reload if reload
    @teammates = @team.teammates.decorate
  end

  def teammate_params
    secured = params
      .require(:teammate)
      .permit(:name, :account_id, :initials, :color, :roles, roles: [])
    secured[:roles] ||= []
    secured[:roles] = secured[:roles].split(",") if secured[:roles].is_a?(String)
    secured[:roles].reject!(&:blank?)
    secured
  end

  def import_params
    params.require(:file)
  end

  def find_teammate
    @teammate = @team.teammates.find(params.require(:id))
  end

  def exporter
    DataExchangeService.new.export
  end

  def importer
    DataExchangeService.new.import
  end
end
