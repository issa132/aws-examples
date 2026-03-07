# Create a new Maven Project
# https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/home.html
# https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html
# https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/home.html
# https://central.sonatype.com/artifact/software.amazon.awssdk/archetype-lambda


# ```sh
# mvn archetype:generate \
# -DgroupId=com.mycompany.app \
# -DartifactId=my-app \
# -DarchetypeArtifactId=maven-archetype-quickstart \
# -DarchetypeVersion=1.4 \
# -DinteractiveMode=false
# ```

mvn -B archetype:generate -DarchetypeGroupId=software.amazon.awssdk -DarchetypeArtifactId=archetype-lambda -Dservice=s3 -Dregion=US_EAST_1 -DarchetypeVersion=2.42.8 -DgroupId=com.example.myapp -DartifactId=myapp