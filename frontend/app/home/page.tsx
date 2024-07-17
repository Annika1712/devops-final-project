"use client"

import { useState, useMemo, useEffect, ChangeEvent } from "react"
import axios from "axios"
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select"
import { Button } from "@/components/ui/button"
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/components/ui/table"
import { ChartTooltipContent, ChartTooltip, ChartContainer } from "@/components/ui/chart"
import { Pie, PieChart, Cell } from "recharts"
import { addExpensesAPI, fetchExpensesAPI } from "@/api/expensesapi"

// Types
interface Expense {
  id: number
  name: string
  amount: number
  category: string
}

interface NewExpense {
  name: string
  amount: string
  category: string
}

// Utility function to generate random colors
const generateRandomColor = () => {
  const letters = "0123456789ABCDEF"
  let color = "#"
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)]
  }
  return color
}

export default function Component() {
  const [expenses, setExpenses] = useState<Expense[]>([])
  const [newExpense, setNewExpense] = useState<NewExpense>({
    name: "",
    amount: "",
    category: "",
  })

  useEffect(() => {
    // Fetch mock data from API
    const fetchExpenses = async () => {
      try {
        const response = await fetchExpensesAPI()
        setExpenses(response.data)
      } catch (error) {
        console.error("Error fetching expenses:", error)
      }
    }
    fetchExpenses()
  }, [])

  const handleInputChange = (e: ChangeEvent<HTMLInputElement>) => {
    setNewExpense({
      ...newExpense,
      [e.target.id]: e.target.value,
    })
  }

  const handleAddExpense = async () => {
    if (newExpense.name && newExpense.amount && newExpense.category) {
      setExpenses([
        ...expenses,
        {
          id: expenses.length + 1,
          name: newExpense.name,
          amount: parseFloat(newExpense.amount),
          category: newExpense.category,
        },
      ])
       await addExpensesAPI(newExpense.name, parseFloat(newExpense.amount), newExpense.category)
      setNewExpense({
        name: "",
        amount: "",
        category: "",
      })
    }
  }

  const expensesByCategory = useMemo(() => {
    return expenses.reduce<{ [key: string]: { name: string; amount: number } }>((acc, expense) => {
      if (!acc[expense.category]) {
        acc[expense.category] = {
          name: expense.category,
          amount: 0,
        }
      }
      acc[expense.category].amount += expense.amount
      return acc
    }, {})
  }, [expenses])

  const categoriesData = useMemo(() => {
    return Object.values(expensesByCategory)
  }, [expensesByCategory])

  const categoryColors = useMemo(() => {
    const colors: { [key: string]: string } = {}
    categoriesData.forEach((category) => {
      colors[category.name] = generateRandomColor()
    })
    return colors
  }, [categoriesData])

  return (
    <div className="flex flex-col gap-8">
      <Card>
        <CardHeader>
          <CardTitle>Add Expense</CardTitle>
          <CardDescription>Enter your expense details to track your spending.</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="name">Expense Name</Label>
              <Input id="name" placeholder="Enter expense name" value={newExpense.name} onChange={handleInputChange} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="amount">Amount</Label>
              <Input
                id="amount"
                type="number"
                placeholder="Enter amount"
                value={newExpense.amount}
                onChange={handleInputChange}
              />
            </div>
          </div>
          <div className="space-y-2">
            <Label htmlFor="category">Category</Label>
            <Select
              value={newExpense.category}
              onValueChange={(value) => setNewExpense({ ...newExpense, category: value })}
            >
              <SelectTrigger>
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="Housing">Housing</SelectItem>
                <SelectItem value="Food">Food</SelectItem>
                <SelectItem value="Transportation">Transportation</SelectItem>
                <SelectItem value="Utilities">Utilities</SelectItem>
                <SelectItem value="Entertainment">Entertainment</SelectItem>
                <SelectItem value="Other">Other</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardContent>
        <CardFooter>
          <Button onClick={handleAddExpense}>Add Expense</Button>
        </CardFooter>
      </Card>
      <Card>
        <CardHeader>
          <CardTitle>Expenses</CardTitle>
          <CardDescription>View and manage your recorded expenses.</CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Expense</TableHead>
                <TableHead>Amount</TableHead>
                <TableHead>Category</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {expenses.map((expense) => (
                <TableRow key={expense.id}>
                  <TableCell className="font-medium">{expense.name}</TableCell>
                  <TableCell className="text-right">${expense.amount}</TableCell>
                  <TableCell>{expense.category}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
      <Card>
        <CardHeader>
          <CardTitle>Expense Breakdown</CardTitle>
          <CardDescription>Visualize your expenses by category.</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <PiechartcustomChart  data={categoriesData} categoryColors={categoryColors} />
            </div>
            <div className="space-y-4">
              {categoriesData.map((category) => (
                <div key={category.name} className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <div className="w-4 h-4 rounded-full" style={{ backgroundColor: categoryColors[category.name] }} />
                    <span>{category.name}</span>
                  </div>
                  <span className="font-medium">${category.amount.toFixed(2)}</span>
                </div>
              ))}
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

function PiechartcustomChart({ data, categoryColors, ...props }: { data: { name: string; amount: number }[]; categoryColors: { [key: string]: string } }) {
  return (
    <div {...props}>
      <ChartContainer
        config={
            {

            }
        }

      >
        <PieChart>
          <ChartTooltip cursor={false} content={<ChartTooltipContent hideLabel />} />
          <Pie data={data} dataKey="amount" nameKey="name">
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={categoryColors[entry.name]} />
            ))}
          </Pie>
        </PieChart>
      </ChartContainer>
    </div>
  )
}
