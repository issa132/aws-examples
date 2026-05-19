# Amazon Forecast
 
Amazon Forecast is a time-series forecasting service. Forecast business outcomes such as product demand, resource needs or financial performance.
You need to upload your dataset to S3 with:

    Historical data
    Additional Metadata (optional)

Amazon Forecast Workflow:

    Create Data Set Group / Create Data Import Job

        Define the schema
        Register the task


    Create Predictor / Get Accurate Metrics

        ELT Job evaluates the Model
        Choose a predefined backtest

    Create Forecast

        Deploy the Predictor
        Retrained with full dataset

    Query Forecast / Export Forecast

Amazon Forecast will produce a visual graph

# Amazon Fraud Detector
 
Amazon Fraud Detector is a fully managed fraud detection a service. identify potentially fraudulent online activities such as online payment fraud and the creation of fake accounts.
Amazon Fraud Detector comes with the following predefined models which you'll train your data against:

    Online Fraud Insights — optimized to detect fraud when little historical data is available about the entity being evaluated, for example, a new customer registering online for a new account.
    Transaction Fraud Insights — testing fraud use cases where the entity that is being evaluated might have a history of interactions that the model can analyze to improve prediction accuracy
    Account Takeover Insights — if an account was compromised by phishing or another type of attack.

Using the AWS SDK real-time fraud detections systems can be architected using AWS Step Functions, Amazon Kinesis, AWS Lambda and other AWS application integration services

You upload your dataset for data model training to an S3 bucket which is then reference by Fraud Detector.

# We create our model:

Choose the Model Type eg. Online Fraud Insights
Choose The Data Source eg. S3
Define the Data Schema

    Defined the label mapping

Define the Model Variables to be used

python
import boto3
fraudDetector = boto3.client('frauddetector')

fraudDetector.create_model_version(
modelId = 'sample_fraud_detection_model',
modelType = 'ONLINE_FRAUD_INSIGHTS',
trainingDataSource = 'EXTERNAL_EVENTS',
trainingDataSchema = {
    'modelVariables' : ['ip_address', 'email_address'],
    'labelSchema' : {
        'labelMapper' : {
            'FRAUD' : ['fraud'],
            'LEGIT' : ['legit']
        }
        unlabeledEventsTreatment = 'AUTO'
    }
},
externalEventsDetail = {
    'dataLocation' : 's3://bucket/file.csv',
    'dataAccessRoleArn' : 'role_arn'
}
)

After we review our model performance we set it active to deploy our model for real-time detection
python
import boto3
fraudDetector = boto3.client('frauddetector')

fraudDetector.update_model_version_status(
modelId = 'sample_fraud_detection_model',
modelType = 'ONLINE_FRAUD_INSIGHTS',
modelVersionNumber = '1.00',
status = 'ACTIVE'
)

Rules interpret variable values during a fraud prediction.

    Variable or List — what data to operate on
    Expression — rule language eg. operators, regex
    Outcome — the outcome to return

Scores are numerical values that represent the estimated risk level of a given event being fraudulent.Scores are numerical values that represent the estimated risk level of a given event being fraudulent.
Outcomes define the fraud prediction result eg.

Labels classifies an event as fraudulent or legitimate.
Entities represents who is performing the event. eg. Customer
Variables are data points used in your model. eg. Location, Transaction Amount.
Labels
   ↓
Entities → Events ← Variables
              ↓
           Models

Events are containing the data and rules that will be analyzed by the model


