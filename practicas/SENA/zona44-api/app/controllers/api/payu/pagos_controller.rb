class Api::Payu::PagosController < ApplicationController
  def formulario
    pedido = Pedido.find(params[:pedido_id])
    usuario = pedido.usuario

    merchant_id = "508029"
    account_id = "512321"
    api_key    = "4Vj8eK4rloUd272L48hsrarnUA"
    reference_code = "pedido#{pedido.id}"
    amount     = sprintf('%.2f', pedido.total)
    currency   = "COP"

    # Generar la firma
    signature_string = [api_key, merchant_id, reference_code, amount, currency].join('~')
    signature = Digest::MD5.hexdigest(signature_string)

    render html: <<-HTML.html_safe
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <title>Pago Zona 44</title>
      </head>
      <body>
        <h1>Simular pago con PayU</h1>
        <form method="post" action="https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/">
          <input name="merchantId" type="hidden" value="#{merchant_id}">
          <input name="accountId" type="hidden" value="#{account_id}">
          <input name="description" type="hidden" value="Compra en Zona 44">
          <input name="referenceCode" type="hidden" value="#{reference_code}">
          <input name="amount" type="hidden" value="#{amount}">
          <input name="currency" type="hidden" value="COP">
          <input name="signature" type="hidden" value="#{signature}">
          <input name="buyerEmail" type="hidden" value="#{usuario.email}">
          <input name="responseUrl" type="hidden" value="https://tusitio.com/respuesta">
          <input name="confirmationUrl" type="hidden" value="https://tusitio.com/api/payu/notificacion">
          <input name="test" type="hidden" value="1">
          <input name="Submit" type="submit" value="Pagar ahora">
        </form>
      </body>
      </html>
    HTML
  end
  
  # Endpoint para recibir notificaciones de PayU
  def notificacion
    reference_code    = params[:reference_sale]
    transaction_state = params[:state_pol]
    signature         = params[:sign]

    Rails.logger.info "Notificación PayU: ref #{reference_code}, estado #{transaction_state}, firma #{signature}"

    # Buscar el pedido (recordando que le pusimos prefix 'pedido123')
    pedido_id = reference_code.gsub("pedido", "").to_i
    pedido = Pedido.find_by(id: pedido_id)

    unless pedido
      render plain: "Pedido no encontrado", status: :not_found and return
    end

    if transaction_state == "4" # Estado 4 = aprobado
      pedido.update(pagado: true, estado: "pendiente")
      render plain: "Pago registrado correctamente"
    else
      pedido.update(pagado: false, estado: "rechazado")
      render plain: "Pago no aprobado (estado #{transaction_state})"
    end
  end
end
