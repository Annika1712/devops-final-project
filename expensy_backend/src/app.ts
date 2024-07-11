import express from 'express';
import bodyParser from 'body-parser';
import expenseRoutes from './routes/expense.route';
import connectDB from './config/db.config';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use('/api', expenseRoutes);

connectDB();

export default app;
