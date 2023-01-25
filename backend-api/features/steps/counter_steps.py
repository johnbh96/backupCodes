import json
import re
from behave import given, when, then, step
from behave.runner import Context
from counter.models import (
    Question, Business, BusinessType, ResourceType,
    run_initial_setup,
)
from django.contrib.auth.models import User
from rest_framework.test import APIClient
from rest_framework.response import Response


def sanitize_json(content: str) -> str:
    return re.sub(r'\"id\":\s\d+', '\"id\": {}', content)


@given('initial setup is complete')
def step_impl(context):
    run_initial_setup()
    pass


@given('I am logged in')
@step('I am logged in')
def step_impl(context):
    context.user = User.objects.get(username='admin')
    client = APIClient()
    client.force_authenticate(user=context.user)
    context.client = client
    pass


@step('I create some questions')
def step_impl(context: Context):
    for row in context.table:
        q = Question.build(
            question_text=row['question_text'],
            pub_date=row['pub_date'],
        )
        q.save()


@when('I send GET request to {url}')
@given('I send GET request to {url}')
def step_impl(context, url):
    response = context.client.get(url)
    context.response = response
    pass


@step('I send POST request to {url}')
def step_impl(context, url):
    assert context.text is not None or context.text == '', 'Empty body on POST request'
    response = context.client.post(url, data=context.text, content_type='application/json')
    context.response = response
    pass


@step('I create business by sending POST request to {url}')
def step_impl(context, url):
    assert context.text is not None or context.text == '', 'Empty body on POST request'
    content_text = context.text.replace('{business_id}', str(context.scenario_business_id))
    response = context.client.post(url, data=content_text, content_type='application/json')
    context.response = response
    pass


@then("I should receive JSON response")
def step_impl(context):
    response: Response = context.response
    response_content: str = str(json.dumps(response.json(), indent=2))
    assert sanitize_json(context.text) == sanitize_json(response_content),\
        f'\nExpected:\n{context.text}\nReceived:\n{response_content}'
    pass


@then('I should have {number} questions')
def step_impl(context, number):
    questions_count = Question.objects.count()
    assert questions_count == int(number)
    pass


@given('we have behave installed')
def step_impl(context):
    pass


@when('we implement {number:d} tests')
def step_impl(context, number):  # -- NOTE: number is converted into integer
    assert number > 1 or number == 0
    context.tests_count = number


@then('behave will test them for us!')
def step_impl(context):
    assert context.failed is False
    assert context.tests_count >= 0


@step('I have a {resource_type} business with {business_id}')
def step_impl(context, resource_type, business_id):
    user_business = Business(
        name='some business',
        owner=context.user,
        creator=context.user,
        business_type=BusinessType.objects.filter(name='transport').first(),
        resource_type=ResourceType.objects.filter(name='sumo').first(),
        address='Some street 1',
    )
    user_business.save()
    context.scenario_business_id = user_business.id
