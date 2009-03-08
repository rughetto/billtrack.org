class BillIssues < Application
  # provides :xml, :yaml, :js

  # POST /bill_issues
  def create
    @bill_issue = BillIssue.new(params[:bill_issue])
    @bill_issue.permissions_data = session.user
    if @bill_issue.save
      redirect request.referer
    else
      render :new
    end
  end

end