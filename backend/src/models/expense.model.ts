import { Schema, model, Document } from 'mongoose';

interface IExpense extends Document {
  name: string;
  amount: number;
  category: string;
}

const expenseSchema = new Schema<IExpense>({
  name: {
    type: String,
    required: true,
  },
  amount: {
    type: Number,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
});

const Expense = model<IExpense>('Expense', expenseSchema);

export default Expense;
