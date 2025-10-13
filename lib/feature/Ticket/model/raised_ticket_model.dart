class TicketModel {
  final String ticketId;
  final String title;
  final String date;
  final String time;
  final String workStatus;
  final String? serviceNotes;
  final String? technicianRemarks;

  TicketModel({
    required this.ticketId,
    required this.title,
    required this.date,
    required this.time,
    required this.workStatus,
    this.serviceNotes,
    this.technicianRemarks,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      ticketId: map['ticketId'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      workStatus: map['workStatus'] ?? '',
      serviceNotes: map['serviceNotes'],
      technicianRemarks: map['technicianRemarks'],
    );
  }

  TicketModel copyWith({
    String? ticketId,
    String? title,
    String? date,
    String? time,
    String? workStatus,
    String? serviceNotes,
    String? technicianRemarks,
  }) {
    return TicketModel(
      ticketId: ticketId ?? this.ticketId,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      workStatus: workStatus ?? this.workStatus,
      serviceNotes: serviceNotes ?? this.serviceNotes,
      technicianRemarks: technicianRemarks ?? this.technicianRemarks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'title': title,
      'date': date,
      'time': time,
      'workStatus': workStatus,
      if (serviceNotes != null) 'serviceNotes': serviceNotes,
      if (technicianRemarks != null) 'technicianRemarks': technicianRemarks,
    };
  }
}
// final List<TicketModel> ticketlist = [
//   TicketModel(
//     ticketId: '221334',
//     title: 'Installation and Maintenance',
//     date: '22/08/2021',
//     time: '12:00 PM',
//     workStatus: 'Scheduled',
//     serviceNotes: 'The client has requested installation of a new CVM-X300 coffee vending machine at their corporate office. All required components including hoses, filters, and the installation manual have been verified and packed. The pre-installation checklist has been completed to ensure compatibility with the existing infrastructure. Power and water supply access points have been confirmed at the installation site.',
//     technicianRemarks: 'The installation kit has been thoroughly checked and loaded. The CVM-X300 unit is tested for transit safety and ready for deployment. The technician has been briefed on site-specific instructions, including limited access hours and designated equipment room location. A pre-installation call was made to confirm availability of on-site contact personnel.',
//   ),
//   TicketModel(
//     ticketId: '221335',
//     title: 'Installation and Maintenance',
//     date: '23/08/2021',
//     time: '12:00 PM',
//     workStatus: 'Completed',
//     serviceNotes: 'Installation of the CVM-X300 machine was successfully completed in the reception area. The machine was mounted securely, connected to the water and power lines, and calibrated for standard cup sizes. Multiple test brews were conducted to verify the consistency and taste of different beverages. The client was satisfied and signed off the installation form.',
//     technicianRemarks: 'All machine functions were checked including grinder, heater, and dispenser modules. The machine was leveled and locked into position for stability. A demonstration was provided to the client regarding daily cleaning routines, refill procedures, and basic troubleshooting. Maintenance log was updated and QR user guide affixed on the side panel.',
//   ),
//   TicketModel(
//     ticketId: '221336',
//     title: 'Refill Request',
//     date: '24/08/2021',
//     time: '12:00 PM',
//     workStatus: 'Completed',
//     serviceNotes: 'The machine had run out of coffee beans, milk powder, and sugar. Refill cartridges were delivered and replaced with fresh stock. The container chambers were cleaned thoroughly before loading the new ingredients. Machine was restarted and tested for proper dispensing across all menu items.',
//     technicianRemarks: 'All three ingredient compartments were completely depleted, likely due to higher-than-usual consumption. After cleaning the compartments, refill quantities were measured and verified. Dispense calibration was adjusted slightly to ensure consistent output. User was advised to monitor stock weekly and use app-based refill alerts.',
//   ),
//   TicketModel(
//     ticketId: '221337',
//     title: 'Fault Reporting',
//     date: '25/08/2021',
//     time: '12:00 PM',
//     workStatus: 'Unresolved',
//     serviceNotes: 'Customer reported that the machine is not dispensing coffee. Upon inspection, it was observed that the heater module is not initiating the brew cycle. The internal diagnostic panel shows multiple failed attempts to reach the target temperature. Further inspection is required to confirm whether the heating element or control board is faulty.',
//     technicianRemarks: 'Power supply to the unit is stable and other components appear operational. However, the heater module is unresponsive and not drawing expected current. Suspected component failure—possibly due to thermal overload. Replacement part has been requested from inventory and a follow-up visit is being scheduled.',
//   ),
//   TicketModel(
//     ticketId: '221338',
//     title: 'Preventive Maintenance',
//     date: '26/08/2021',
//     time: '11:00 AM',
//     workStatus: 'Scheduled',
//     serviceNotes: 'Quarterly maintenance for the office coffee vending machine is due. Scope of the service includes inspection of internal tubing, cleaning of brewing components, descaling of the boiler, and software update if available. Maintenance will also cover testing all drink selections to ensure proper functionality.',
//     technicianRemarks: 'Preventive tools and consumables are packed for the visit. Filters, sensors, and valve connections will be inspected and cleaned. Lubrication of moving parts and update of machine firmware are planned. Post-maintenance testing will be documented in the service log and signed off by facility manager.',
//   ),
// ];
final List<TicketModel> ticketlist = [
  TicketModel(
    ticketId: '221334',
    title: 'Installation and Maintenance',
    date: '22/08/2021',
    time: '12:00 PM',
    workStatus: 'Scheduled',
    serviceNotes:
    'The client has requested installation of a new CVM-X300 coffee vending machine at their corporate office. All required components including hoses, filters, and the installation manual have been verified and packed. The pre-installation checklist has been completed to ensure compatibility with the existing infrastructure. Power and water supply access points have been confirmed at the installation site.',
    technicianRemarks:
    'The installation kit has been thoroughly checked and loaded. The CVM-X300 unit is tested for transit safety and ready for deployment. The technician has been briefed on site-specific instructions, including limited access hours and designated equipment room location. A pre-installation call was made to confirm availability of on-site contact personnel.',
  ),
  TicketModel(
    ticketId: '221335',
    title: 'Installation and Maintenance',
    date: '23/08/2021',
    time: '12:00 PM',
    workStatus: 'Completed',
    serviceNotes:
    'Installation of the CVM-X300 machine was successfully completed in the reception area. The machine was mounted securely, connected to the water and power lines, and calibrated for standard cup sizes. Multiple test brews were conducted to verify the consistency and taste of different beverages. The client was satisfied and signed off the installation form.',
    technicianRemarks: '', // Empty technicianRemarks
  ),
  TicketModel(
    ticketId: '221336',
    title: 'Refill Request',
    date: '24/08/2021',
    time: '12:00 PM',
    workStatus: 'Completed',
    serviceNotes: '',
    technicianRemarks:
    'All three ingredient compartments were completely depleted, likely due to higher-than-usual consumption. After cleaning the compartments, refill quantities were measured and verified. Dispense calibration was adjusted slightly to ensure consistent output. User was advised to monitor stock weekly and use app-based refill alerts.',
  ),
  TicketModel(
    ticketId: '221337',
    title: 'Fault Reporting',
    date: '25/08/2021',
    time: '12:00 PM',
    workStatus: 'Unresolved',
    serviceNotes:
    'Customer reported that the machine is not dispensing coffee. Upon inspection, it was observed that the heater module is not initiating the brew cycle. The internal diagnostic panel shows multiple failed attempts to reach the target temperature. Further inspection is required to confirm whether the heating element or control board is faulty.',
    technicianRemarks:
    'Power supply to the unit is stable and other components appear operational. However, the heater module is unresponsive and not drawing expected current. Suspected component failure—possibly due to thermal overload. Replacement part has been requested from inventory and a follow-up visit is being scheduled.',
  ),
  TicketModel(
    ticketId: '221338',
    title: 'Preventive Maintenance',
    date: '26/08/2021',
    time: '11:00 AM',
    workStatus: 'Scheduled',
    serviceNotes:
    'Quarterly maintenance for the office coffee vending machine is due. Scope of the service includes inspection of internal tubing, cleaning of brewing components, descaling of the boiler, and software update if available. Maintenance will also cover testing all drink selections to ensure proper functionality.',
    technicianRemarks:
    'Preventive tools and consumables are packed for the visit. Filters, sensors, and valve connections will be inspected and cleaned. Lubrication of moving parts and update of machine firmware are planned. Post-maintenance testing will be documented in the service log and signed off by facility manager.',
  ),
];
