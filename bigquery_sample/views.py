from django.http import HttpResponse
from google.cloud import bigquery
from google.oauth2 import service_account
from django.shortcuts import render
from django.template import loader

credentials = service_account.Credentials.from_service_account_file(
'ecstatic-cosmos-369001-0a10b90e681d.json')
project_id = 'ecstatic-cosmos-369001'
client = bigquery.Client(credentials=credentials,project=project_id)

def index(request):
    return HttpResponse("Hello, world.")

def hacker_news(request):
    query = """
    SELECT title, author, time_ts
    FROM `bigquery-public-data.hacker_news.stories`
    where time_ts is not null and title is not null and author is not null
    order by time_ts desc
    LIMIT 5
    """
    query_job = client.query(query)  # Make an API request.
    while query_job.state != 'DONE':
        time.sleep(3)
        query_job.reload()

    template = loader.get_template('hacker_news.html')
    context = {
        'query_job': query_job,
    }
    return HttpResponse(template.render(context, request))

def github(request):
    query = """
    select count(commit) as commits, committer.name as name
    from bigquery-public-data.github_repos.sample_commits
    where extract(year from committer.date) >= 2016
    group by committer.name
    order by count(commit) desc
    """
    query_job = client.query(query)  # Make an API request.
    while query_job.state != 'DONE':
        time.sleep(3)
        query_job.reload()

    template = loader.get_template('github.html')
    context = {
        'query_job': query_job,
    }
    return HttpResponse(template.render(context, request))
