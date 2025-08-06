class Api::PayuController < ApplicationController
  def pagar
    pedido = Pedido.find(params[:pedido_id])
    usuario = pedido.usuario

    body = {
      language: 'es',
      command: 'SUBMIT_TRANSACTION',
      merchant: {
        apiLogin: Rails.application.credentials.dig(:payu, :api_login),
        apiKey: Rails.application.credentials.dig(:payu, :api_key)
      },
      transaction: {
        order: {
          accountId: Rails.application.credentials.dig(:payu, :account_id),
          referenceCode: pedido.id.to_s,
          description: "Pedido ##{pedido.id}",
          language: 'es',
          notifyUrl: 'https://tusitio.com/api/payu/notificacion'
        },
        payer: {
          fullName: usuario.nombre,
          emailAddress: usuario.email
        },
        creditCard: {
          number: '4097440000000004',
          securityCode: '321',
          expirationDate: '2030/12',
          name: 'APPROVED'
        },
        type: 'AUTHORIZATION_AND_CAPTURE',
        paymentMethod: 'VISA',
        paymentCountry: 'CO',
        deviceSessionId: 'session12345',
        ipAddress: request.remote_ip,
        cookie: '_ga=GA1.2.123456789.987654321',
        userAgent: request.user_agent,
        extraParameters: {
          INSTALLMENTS_NUMBER: 1
        }
      },
      test: true
    }

    response = HTTP.post(
      Rails.application.credentials.dig(:payu, :sandbox_url),
      json: body
    )

    data = JSON.parse(response.body.to_s)

    if data["code"] == "SUCCESS"
      render json: {
        mensaje: "Transacción generada",
        transaction_response: data["transactionResponse"]
      }
    else
      render json: { error: data["error"] || "Error desconocido" }, status: :unprocessable_entity
    end
  end
end
