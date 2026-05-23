# Amazon Lex

Amazon Lex (V2) is a conversation interface service. With Lex you can build conversational voice and text chatbots
Amazon Lex V2 provides:

    Natural Language Understanding (NLU)
    Automatic Speech Recognition (ASR)
    AWS provide multiple bot templates for common industries as a starting points.
    Provide transcripts to create a new bot
    Use Gen AI to build a bot by descripting what you want
    Choose a target language, can choose from multiple AWS provided voices.


Integrates with AWS Lambda to connect to various AWS services.

#  Amazon Lex Network Of BotsAmazon Lex Network Of Bots
A feature of lex that add multiple bots to a single network. A network can intelligently route the query to the appropriate bot. This provides a unified experience for customers and reduces duplication of intent configuration for multiple specialized bots.

# Components of a Bot:

    Bot — performs automated tasks, the input to interact with your conversation model

        Version — a number of version of the snapshot of your bot model
            Alias — a label/tag to point to a specific version of a bot
        Language — the target language(s) that the bot can converse in eg. English, Spanish


    Intent — represents an action that the user wants to perform.
        Sample Utterance — text how a user might request their intent:

            "Can I order a pizza"
            "I want to order a pizza"
            "Yo dawg, I want a slice a pie, can you dig it?"


        Slot — inputs that an intent will require of the user (can be set to zero)
            Slot Type — defines the data type of the slot
                Can be a custom enumeration values eg. "Small", "Medium", "Large"
                Can be a predefined data type eg. AMAZON.Number


# Amazon Personalize

Amazon Personalize is a real-time recommendations service. Same technology used to make product recommendations to customers shopping on the Amazon platform

    Create a data set group
    Upload your data set to your data group (csv files)
        You will provide multiple data sets

            User Item Interaction Data
            User Data
            Item Data

        You will need provide a json schema mapping for the CSV files
        Reference the dataset location from an S3 object location

    Solutions and Recipes allows you to finetune your model

        Solutions helps generate recommendations
        Recipe is a predefined AWS algorithm

# User Item Interaction Data — core dataset that used to train a custom model

    At a minimum, this dataset must include three attributes
        USER_ID: A unique identifier for a user.
        ITEM_ID: A unique identifier for an item.
        TIMESTAMP: The Unix timestamp of the interaction.



USER_ID,ITEM_ID,TIMESTAMP
1,10,1577836800
1,20,1577923200
2,10,1578009600

User Data — contains metadata about the users, which can be used to improve recommendation quality
    The only required attribute in this dataset is the USER_ID, which must correspond to the USER_ID in the User-Item Interaction Data.

USER_ID,AGE,GENDER
1,25,M
2,34,F

Item Data — contains metadata about the items eg. categories, price, or brand.
    must include an ITEM_ID that matches the ITEM_ID in the User-Item Interaction Data.
    Must be called CATEGORY_L1 (graphic to left is wrong)

ITEM_ID,TITLE,CATEGORY
10,"The Great Gatsby","Books"
20,"Fender Stratocaster","Music Instruments"

# ask chatgpt: 
create a CSV file containing a sample dataset for Amazon Personalize User Data. This dataset includes 10,000 users with fields for user ID, age group, gender, country, and interests. 

Now create a csv for the user item interaction data which should reference the data in the user data csv you previously generated.
the timestamp has to be unix. 
update the timestamps in the user-item interaction data to be in Unix time epoch format. The item data should actually be items of the category.The item data should actually be items of the category.


#  https://docs.https://docs.aws.amazon.com/personalize/latest/dg/granting-personalize-s3-access.html
make a schema json for our user data dataset to import into Amazon Personalize
update the user interaction timestamp to not have the decimal placeupdate the user interaction timestamp to not have the decimal place

