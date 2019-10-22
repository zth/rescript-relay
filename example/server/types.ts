export type SiteStatistics = {
  type: "SiteStatistics";
  id: number;
  weeklySales: number;
  weeklyOrders: number;
  currentVisitorsOnline: number;
};

export type User = {
  type: "User";
  id: number;
  avatarUrl: string | null;
  fullName: string;
};

export type TicketStatus = "Done" | "Progress" | "OnHold" | "Rejected";

export type Ticket = {
  type: "Ticket";
  id: number;
  assigneeId: number | null;
  subject: string;
  status: TicketStatus;
  lastUpdated: string;
  trackingId: string;
};

export type TodoItem = {
  type: "TodoItem";
  id: number;
  text: string;
  completed: boolean;
};
