import ballerinax/github;
import ballerina/http;

type Repo record {
   int star;
   string name; 
}
;
# A service representing a network-accessible API
# bound to port `9090`.
 service / on new http:Listener(9090) {

    resource function get ReposTest(string name) returns Repo[]|error {

        github:Client githubEp = check new (config = {
            auth: {
                token: "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"
            }
    });
        stream<github:Repository, error?> getRepositoriesResponse = check githubEp->getRepositories();

    Repo []|error? repos = from var item in getRepositoriesResponse 
           where item is github:Repository 
           order by item.stargazerCount
           limit 5
           select {
               name: item.name,
               star: item.stargazerCount?:0
           }; 
           return repos?:[];
   }
}