from django.db import models

from counter.models.business import (
    Business,
)
from counter.models.resource_types import (
    ResourceType,
)
from counter.models.vehicle import (
    VehicleRoute,
)


class RoutePlan(models.Model):

    route = models.ForeignKey(
        VehicleRoute,
        null=False,
        on_delete=models.RESTRICT,
    )
    default_price = models.IntegerField(
        null=False,
    )
    business = models.ForeignKey(
        Business,
        null=False,
        on_delete=models.RESTRICT,
    )
    resource_type = models.ForeignKey(
        ResourceType,
        null=False,
        on_delete=models.RESTRICT,
    )
    is_active = models.BooleanField(
        null=False,
    )


class RouteSeatInlinePrice(models.Model):

    parent = models.ForeignKey(
        RoutePlan,
        null=False,
        on_delete=models.CASCADE,
    )

    alias_name = models.CharField(
        null=False,
        max_length=80,
    )

    price = models.IntegerField(
        null=False,
    )
