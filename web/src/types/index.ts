export interface IService {
  name: string;
  description: string;
  price: number;
  qty: number;
}

export interface IPayment {
  amount: number;
  date: string;
  status: boolean;
}

export interface IProposal {
  client: string;
  services: IService[];
  paymentSchedule: IPayment[];
}
