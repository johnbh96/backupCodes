from django.db import models
from django.utils.timezone import datetime

from counter.models import VehicleStop
from counter.models.choices import (
    BookingChannelType,
)
from counter.models.business import (
    BusinessDepartment,
)


class BookingIntegration(models.Model):
    department = models.ForeignKey(
        BusinessDepartment,
        null=False,
        on_delete=models.PROTECT,
    )
    channel = models.CharField(
        null=False,
        max_length=80,
        choices=BookingChannelType.choices,
    )
    is_active = models.BooleanField(
        null=False,
        default=False,
    )
    created_at = models.DateTimeField(
        null=False,
        default=datetime.now(),
    )


class YatruSewaIntegration(models.Model):

    department = models.ForeignKey(
        BusinessDepartment,
        null=False,
        on_delete=models.PROTECT,
    )

    station = models.ForeignKey(
        VehicleStop,
        null=False,
        on_delete=models.RESTRICT,
    )
