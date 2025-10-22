class ApiEndPoints {
  ApiEndPoints._();

  //auth
  static const String login = 'login.php';
  static const String getTicketById = 'get_ticket_by_id.php';
  static const String getTicketByTechnician = 'get_tickets_by_employee.php';
  static const String getTicketByUserId='get_tickets_by_user.php';
  static const String getProductDetailBySerialNumber='get_product_by_serial_or_barcode.php';
  static const String getUserDetailsById='get_user.php';
  static const String raiseTicketByCustomer = 'create_ticket.php';
  static const String getTicketDetailsByTicketId ="get_ticket_by_id.php";
  static const String dashboardJobCount = 'dashboard.php';
  static const String profileDetailsById= 'profile_view.php';
  static const String updateTicketByTechnician ="ticket_update_by_employee.php";
  static const String updateEmployeeStatus ="employee_status_update.php";
  static const String acceptTicketStatus ="ticket_accept_status_by_employee.php";
  static const String getStockDetails ="view_employee_stocks.php";
  static const String getNotificationDetails ="techniciancustomer_notification.php";
  static const String getEmployeeByUniqueId ="get_employee.php";
  static const String getScheduledJobsByTechnician = 'scheduled_jobs.php';

}