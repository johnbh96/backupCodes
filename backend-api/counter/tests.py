import datetime

from django.test import TestCase
from django.utils import timezone

from .models import Question


class QuestionModelTests(TestCase):
    fixtures = ['questions.json']

    def test_was_published_recently_with_future_question(self) -> None:
        """
        was_published_recently() returns False for questions whose pub_date
        is in the future.
        """
        time = timezone.now() + datetime.timedelta(days=30)
        future_question = Question(pub_date=time)
        questions_count = Question.objects.count()
        self.assertEqual(questions_count, 2)
        self.assertIs(future_question.was_published_recently(), False)
