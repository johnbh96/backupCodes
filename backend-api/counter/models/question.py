import datetime

from django.db import models
from django.utils import timezone
from typing import Union


class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

    @classmethod
    def build(
        cls, question_text: str,
        pub_date: Union[datetime.datetime, str],
    ):
        return cls(
            question_text=question_text,
            pub_date= datetime.datetime.fromisoformat(pub_date) if isinstance(pub_date, str) else pub_date,
        )

    def was_published_recently(self) -> bool:
        now = timezone.now()
        return now - datetime.timedelta(days=1) <= self.pub_date <= now
