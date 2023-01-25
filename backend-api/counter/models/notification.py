from django.db import models
from django.contrib.auth.models import User

from counter.models.booking import (
    Booking,
)
from counter.models.choices import (
    NotificationType, BookingNotificationType,
)


class Notification(models.Model):
    user = models.ForeignKey(
        User,
        null=False,
        on_delete=models.PROTECT,
    )
    is_read = models.BooleanField(
        null=False,
        default=False,
    )
    notification_type = models.CharField(
        null=False,
        max_length=80,
        choices=NotificationType.choices,
    )


class BookingNotification(models.Model):
    notification = models.ForeignKey(
        Notification,
        null=False,
        on_delete=models.PROTECT,
    )
    booking = models.ForeignKey(
        Booking,
        null=False,
        on_delete=models.PROTECT,
    )
    action = models.CharField(
        null=False,
        max_length=120,
        choices=BookingNotificationType.choices,
    )
