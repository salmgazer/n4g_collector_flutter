import 'dart:convert' as JSON;

const strings = '''{
  "eng": {
    "suppliers": "Suppliers",
    "supplier": "Supplier",
    "register_supplier": "Register Suppliers",
    "dashboard": "Dashboard",
    "download_sites": "Download Sites",
    "settings": "Settings",
    "profile": "Profile",
    "sign_out": "Sign out",
    "buy_from": "Buy from",
    "view_transactions_with": "View transactions with",
    "about_supplier": "About",
    "language": "Language",
    "prices": "Prices",
    "cash": "Cash",
    "wallet": "Wallet",
    "currency": "Currency",
    "transactions": "Transactions with",
    "transaction": "Transaction",
    "first_name": "First name",
    "last_name": "Last name",
    "since": "Since",
    "last_updated": "Last updated",
    "supplier_search_help": "Search by code or name",
    "notifications": "Notifications",
    "team": "Team",
    "notification": "Notification",
    "transactions_tab": "Transactions",
    "shipments": "Shipments",
    "new_shipment": "New shipment",
    "shipment": "Shipment",
    "manage": "Manage",
    "register": "Register",
    "trade": "Trade",
    "finance": "Finance",
    "loans": "Loans",
    "withdrawal" : "Withdrawal",
    "details" : "Details",
    "edit": "Edit",
    "topup": "Top Up",
    "history": "History",
    "withdrawals": "Withdrawals",
    "sales": "Sales"
  },
  "fra": {
    "suppliers": "Fournisseuses",
    "supplier": "Fournisseuse",
    "register_supplier": "Enregistrer les fournisseuses",
    "dashboard": "Tableau de bord",
    "download_sites": "Sites de téléchargement",
    "settings": "Réglages",
    "profile": "Profil",
    "sign_out": "Déconnexion",
    "buy_from": "Acheter de",
    "view_transactions_with": "Voir les transactions avec",
    "about_supplier": "À propos de",
    "language": "La langue",
    "prices": "Des prix",
    "cash": "En espèces",
    "currency": "Devise",
    "transactions": "Transactions avec",
    "transaction": "Transaction",
    "first_name": "Prénom",
    "last_name": "Nom de famille",
    "since": "Puisque",
    "last_updated": "Dernière mise à jour",
    "supplier_search_help": "Recherche par code ou par nom",
    "manage": "gérer",
    "register": "registre"
  }
}''';

var labels = JSON.jsonDecode(strings);