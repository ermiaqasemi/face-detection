require "spec_helper"

describe "AWS API Gateway" do
  let(:app) { Terraspace::App.new("aws/api_gateway") }

  before(:all) { app.terraform.init }

  it "should create API Gateway with POST method for image upload" do
    expect(app.terraform).to be_created(
      "aws_api_gateway_rest_api.exam_api",
      "aws_api_gateway_resource.exam_resource",
      "aws_api_gateway_method.exam_method",
      "aws_api_gateway_integration.exam_integration",
      "aws_api_gateway_method_response.exam_response",
      "aws_api_gateway_integration_response.exam_integration_response",
      "aws_api_gateway_deployment.exam_deployment"
    )
    
  end
end
