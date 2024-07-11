import { Router } from 'express';
import { getExpenses, addExpense } from '../controllers/expense.controller';

const router = Router();

router.get('/expenses', getExpenses);
router.post('/expenses', addExpense);

export default router;
