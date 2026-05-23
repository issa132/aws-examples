import boto3



my_config = Config(
    region_name = 'ca-central-1',
    # signature_version = 'v4',
    # retries = {
    #     'max_attempts': 10,
    #     'mode': 'standard'
    # }
)

# Initialize the Amazon Personalize runtime client
client = boto3.client('personalize-runtime', config = my_config)

# Specify your campaign ARN and the user ID you want recommendations for
campaign_arn = 'your-campaign-arn-here'
user_id = 'user-id-for-recommendations'
item_id = 'string'


# Optional: If you want to pass item ID for filtering or context, you can include it
# context = {'itemId': 'item-id-for-context'}

# Get recommendations
resp = client.get_recommendations(
    campaignArn=campaign_arn,
    userId=user_id,
    item_id =item_id,
    # Uncomment the line below if you're using context
    # context=context
)

# Print out the recommendation results
for item in resp['itemList']:
    print(f"Item ID: {item['itemId']} Score: {item.get('score', 'N/A')}")