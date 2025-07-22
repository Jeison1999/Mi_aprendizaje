import consumer from "./consumer"

consumer.subscriptions.create("OrdersChannel", {
  connected() {
    console.log("🧲 Conectado al canal de órdenes")
  },
  disconnected() {
    console.log("❌ Desconectado del canal de órdenes")
  },
  received(data) {
    console.log("📦 Pedido recibido:", data)
    // Aquí puedes agregar código para actualizar dinámicamente la UI
  }
})
