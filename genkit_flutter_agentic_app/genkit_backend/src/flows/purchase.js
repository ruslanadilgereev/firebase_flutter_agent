import { z } from 'genkit';
import { ai } from "../ai.js";
import { OrderListSchema, orderedItem, shoppingTool } from "../tools/shopping.js";

export const OrderConfirmationSchema = z.object({
    totalPrice: z.number().describe('Total price of all the items ordered'),
    orderedItems: z.array(orderedItem).describe('All of the items that were ordered'),
});

export const purchaseFlow = ai.defineFlow(
    {
        name: 'purchaseFlow',
        inputSchema: OrderListSchema,
        outputSchema: OrderConfirmationSchema,
    }, async (input) => {

        var orderedList = [];
        var totalPrice = 0;

        for (var i = 0; i < input.items.length; i++) {
            const purchase = await ai.generate({
                prompt: `
                Follow these instructions:
                1.) Determine ONLY a single popular brand name that sells this item: ${JSON.stringify(input.items[i])}
                2.) Then search the DepartmentStore for this item from the identified popular brand name and buy quantity specified: ${JSON.stringify(input.items[i].quantity)}.`,
                tools: [shoppingTool],
                output: { schema: orderedItem }
            })
            totalPrice += purchase.output.totalPrice;
            orderedList.push(purchase.output);
        }

        return { totalPrice: parseFloat(totalPrice.toFixed(2)), orderedItems: orderedList };
    });