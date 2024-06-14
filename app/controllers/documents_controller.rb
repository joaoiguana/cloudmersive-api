class DocumentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:convert]

  def convert
    Rails.logger.info("CSRF Token from request headers: #{request.headers['X-CSRF-Token']}")
    Rails.logger.info("All request headers: #{request.headers.to_h}")

    uploaded_file = params[:file]

    if uploaded_file
      input_file = uploaded_file.tempfile.path
      api_instance = CloudmersiveConvertApiClient::ConvertDocumentApi.new

      begin
        result = api_instance.convert_document_docx_to_pdf(File.new(input_file))
        send_data result, filename: 'converted.pdf', type: 'application/pdf', disposition: 'attachment'
      rescue CloudmersiveConvertApiClient::ApiError => e
        render json: { error: "Exception when calling ConvertDocumentApi->convert_document_docx_to_pdf: #{e}" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No file uploaded' }, status: :unprocessable_entity
    end
  end
end
