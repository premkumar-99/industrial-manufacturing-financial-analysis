import pandas as pd
import matplotlib.pyplot as plt

FILE = "Industrial_Manufacturing_Finance_Project.xlsx"
sales = pd.read_excel(FILE, sheet_name="Sales_Orders")
sales["SO_Date"] = pd.to_datetime(sales["SO_Date"])
sales["Month"] = sales["SO_Date"].dt.to_period("M").astype(str)

revenue = sales["Revenue"].sum()
gross_profit = sales["Gross_Profit"].sum()
print(f"Revenue: ₹{revenue:,.0f}")
print(f"Gross Profit: ₹{gross_profit:,.0f}")
print(f"Gross Margin: {gross_profit/revenue:.1%}")

product = sales.groupby("Model").agg(
    Revenue=("Revenue","sum"), Units=("Qty","sum"),
    Gross_Profit=("Gross_Profit","sum"))
product["Gross_Margin"] = product["Gross_Profit"]/product["Revenue"]
print(product.sort_values("Gross_Profit", ascending=False))

monthly = sales.groupby("Month").agg(
    Revenue=("Revenue","sum"), Gross_Profit=("Gross_Profit","sum"))
monthly["Gross_Margin"] = monthly["Gross_Profit"]/monthly["Revenue"]

fig, ax = plt.subplots(figsize=(10,5))
monthly["Revenue"].plot(kind="bar", ax=ax)
ax.set_title("Monthly Revenue")
ax.set_ylabel("Revenue (₹)")
ax.set_xlabel("Month")
plt.tight_layout()
plt.show()

scenario_gp = (sales["Revenue"].sum()
    - sales["Material_Cost"].sum()*1.10
    - sales["Labour_Cost"].sum()
    - sales["Overhead"].sum())
print(f"Gross margin after +10% material cost: {scenario_gp/revenue:.1%}")
