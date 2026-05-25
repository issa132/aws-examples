# Amazon Polly
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03
Amazon Polly is a text-to-speech service. Upload your text and an audio file spoken by synthesized voice is generated.
Engine Types:

    Standard ($). — the standard model not as natural sounding as other engines, but most cost effective
    Long Form ($$) — sounds more natural when reading long forms of text
    Neural ($$$). — Supports a Newscaster speaking style that is tailored to news narration use cases


There is variation between voices, depending on the text being spoke, no standard speed (words per minute) is available for Amazon Polly voices.

Lexicon — for specialized pronunciation of words.
A lexicon file (.xml, .pls) with upto of 40,000 characters and up to 100 pronunciation rules.
Speech Marks — metadata that describes the speech

    Where a word starts or ends
    Utilize Speech Synthesis Markup Language (SSML)
    Integrate with Visme (third party AI service to create marketing materials)

bash
aws polly synthesize-speech \
--engine neural \
--output-format mp3 \
--voice-id Joanna \
--text "Hello, world!" \
hello_world.mp3

Speech Synthesis Markup Language (SSML) is an XML-based markup language for speech synthesis applications.
xml
<speak>
    He was caught up in the game.<break time="1s"/> In the middle of the
    10/3/2014 <sub alias="World Wide Web Consortium">W3C</sub> meeting,
    he shouted, "Nice job!" quite loudly. When his boss stared at him, he repeated
    <amazon:effect name="whispered">"Nice job,"</amazon:effect> in a
    whisper.
</speak>

SSML that Polly supports:

    <speak> — the root element
    <break> — pause
    <emphasis> — emphasis words eg. Strong, Moderate, Reduced
    <lang> — specify a different language
    <mark> — a custom tag for metadata
    <p> — pause between paragraphs
    <phoneme> — phonetic pronunciation for specific text
    <prosody> — controlling volume, speaking rate, and pitch
    <s> — Adding a pause between sentences
    <say-as> — Controlling how special types of words are spoken
    <sub> — Pronouncing acronyms and abbreviations
    <w> — Improving pronunciation by specifying parts of speech
    <amazon:breath> and <amazon:auto-breaths> — add breathing sound
    <amazon:domain name="news"> Newscaster speaking style (only for Neural)
    <amazon:effect name="drc"> — Adding dynamic range compression
    <amazon:effect phonation="soft"> — speak softley
    <amazon:effect vocal-tract-length> — Controlling timbre
    <amazon:effect name="whispered"> — Whispering

#  https://docs.https://docs.aws.amazon.com/polly/latest/dg/ssml.html

# Gemfile

# frozen_string_literal: true

source "https://rubygems.org"

# gem "rails"
gem "aws-sdk-polly"
gem 'pry'
gem 'nokogiri'

# https://docs.https://docs.aws.amazon.com/sdk-for-ruby/v3/api/
# https://docs.https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/Polly/Client.html


## create bucket and upload file
aws s3 mb s3://rekog-example-1421
aws s3 cp andrew.jpg s3://rekog-example-1421/andrew.jpg

## Run ruby code

bundle install
bundle exec ruby main.rb

# https://docs.aws.amazon.com/rekognition/latest/customlabels-dg/md-create-dataset-s3.html
# https://repost.https://repost.aws/questions/QU_qapo6hFTOSnkaG6MUMZRg/cross-account-s3-buck-access-from-rekognition-service

