from django.db import models

from .business import BusinessResource
from .choices import BookingStatus
from .vehicle import VehicleQueue
from django.contrib.auth.models import User


class Booking(models.Model):
    user: models.ForeignKey = models.ForeignKey(
        User,
        null=False,
        on_delete=models.PROTECT,
    )
    resource: models.ForeignKey = models.ForeignKey(
        BusinessResource,
        null=False,
        on_delete=models.PROTECT,
    )
    status = models.CharField(
        null=False,
        max_length=80,
        choices=BookingStatus.choices,
        default=BookingStatus.Pending,
    )
    starting_from = models.DateTimeField(
        null=False,
    )
    ending_to = models.DateTimeField(
        null=False,
    )
    charged_amount = models.IntegerField(
        null=False,
    )
    contact_name = models.CharField(
        null=False,
        max_length=200,
    )
    contact_number = models.CharField(
        null=False,
        max_length=10,
    )
    note = models.CharField(
        null=False,
        max_length=520,
    )


class VehicleBooking(models.Model):
    booking: models.ForeignKey = models.ForeignKey(
        Booking,
        null=True,
        on_delete=models.PROTECT,
    )
    queue: models.ForeignKey = models.ForeignKey(
        VehicleQueue,
        null=False,
        on_delete=models.PROTECT,
    )
    row_index = models.IntegerField(
        null=False,
    )
    column_index = models.IntegerField(
        null=False,
    )
    is_disabled = models.BooleanField(
        null=False,
        default=True,
    )
