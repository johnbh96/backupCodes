from django.db import models


class User(models.Model):
    name: models.CharField = models.CharField(
        null=False,
        max_length=240,
    )
