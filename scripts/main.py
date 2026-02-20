from openai import OpenAI
from pprint import pprint

import os
import pandas as pd


client = OpenAI()

fine_tuned_model_id = "ft:gpt-4.1-nano-2025-04-14:skyscrapr::DBAeawNd"

system_message = "You are a helpful recipe assistant. You are to extract the generic ingredients from each of the recipes provided."


def create_user_message(row):
    return f"Title: {row['title']}\n\nIngredients: {row['ingredients']}\n\nGeneric ingredients: "


def prepare_example_conversation(row):
    return {
        "messages": [
            {"role": "system", "content": system_message},
            {"role": "user", "content": create_user_message(row)},
            {"role": "assistant", "content": row["NER"]},
        ]
    }


recipe_df = pd.read_csv("data/cookbook_recipes_nlg_10k.csv")

pprint(prepare_example_conversation(recipe_df.iloc[0]))

recipe_df.head()

test_df = recipe_df.loc[201:300]
test_row = test_df.iloc[0]
test_messages = []
test_messages.append({"role": "system", "content": system_message})
user_message = create_user_message(test_row)
test_messages.append({"role": "user", "content": user_message})

pprint(test_messages)




response = client.chat.completions.create(
    model=fine_tuned_model_id, messages=test_messages, temperature=0, max_tokens=500
)
print(response.choices[0].message.content)