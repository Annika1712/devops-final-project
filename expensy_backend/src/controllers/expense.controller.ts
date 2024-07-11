
import { Request, Response } from 'express';
import { ExpenseService } from '../services/expense.service';

const expenseService = new ExpenseService();

export const getExpenses = async (req: Request, res: Response) => {
  try {
    const expenses = await expenseService.getAllExpenses();
    res.status(200).json(expenses);
  } catch (error) {
    console.error('Failed to fetch expenses:', error);
    res.status(500).json({ error: 'Failed to fetch expenses' });
  }
};

export const addExpense = async (req: Request, res: Response) => {
  try {
    const { name, amount, category } = req.body;
    const expense = await expenseService.createExpense({ name, amount, category });
    res.status(201).json(expense);
  } catch (error) {
    console.error('Failed to create expense:', error);
    res.status(500).json({ error: 'Failed to create expense' });
  }
};
