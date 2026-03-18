import { Stack, StackProps } from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as cdk from 'aws-cdk-lib';
import * as sqs from 'aws-cdk-lib/aws-sqs';
import * as sns from 'aws-cdk-lib/aws-sns';
import * as subs from 'aws-cdk-lib/aws-sns-subscriptions';
import { Construct } from 'constructs';

 // github.com/aws/aws-cdk#getting-started
  // cdk bootstrap
  //# 1. Vérifier le CloudFormation généré
  //cdk synth
  //# 2. Déployer ton bucket S3
  //cdk deploy
  //# Supprimer ta stack (le bucket sera RETENU car RemovalPolicy.RETAIN)
  //cdk destroy

  //cd /workspaces/aws-examples/S3/iac/cdk
/*
export class CdkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);


    // Bucket S3
    // docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_s3.Bucket.html
      const bucket = new s3.Bucket(scope, 'MYBucket', {
       //blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
       //encryption: s3.BucketEncryption.S3_MANAGED,
       //enforceSSL: true,
       //versioned: false,
       //removalPolicy: RemovalPolicy.RETAIN,
    });

    // Queue SQS
    const queue = new sqs.Queue(this, 'CdkQueue', {
      visibilityTimeout: Duration.seconds(300)
    });

    // Topic SNS
    const topic = new sns.Topic(this, 'CdkTopic');

    // SNS envoie vers SQS
    topic.addSubscription(new subs.SqsSubscription(queue));
  


  }
   

}

   */

export class CdkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    //new s3.Bucket(scope, 'MYBucket');
    const bucket = new s3.Bucket(this, 'MyBucket');
  }
}