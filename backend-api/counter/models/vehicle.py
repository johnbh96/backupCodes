from datetime import timedelta
from django.db import models
from .business import Business, BusinessResource
from .resource_types import ResourceType 
from django.core.exceptions import ValidationError
from django.core.validators import MinValueValidator
from counter.models.resource_types import (
    ResourceSeat, ResourceSeatTemplate,
)


class VehicleStop(models.Model):

    # Name should be unique
    # so use name to identify object
    def __str__(self):
        return '%s' % self.address

    name: models.CharField = models.CharField(
        null=False,
        max_length=120,
    )
    address: models.CharField = models.CharField(
        null=False,
        max_length=200,
        unique=True,
    )


class VehicleRoute(models.Model):

    # Name should be unique
    # so use name to identify object
    def __str__(self):
        return 'Vehicle Route (%s: %s -> %s)' % (self.pk, self.start_point.address, self.end_point.address)

    start_point = models.ForeignKey(
        VehicleStop,
        null=False,
        on_delete=models.PROTECT,
        related_name='startpoint',
    )
    end_point = models.ForeignKey(
        VehicleStop,
        null=False,
        on_delete=models.PROTECT,
        related_name='endpoint',
    )


class VehicleRouteRate(models.Model):

    def __str__(self):
        return 'Route Rate [%s](%s: %s -> %s)'\
               % (self.pk, self.business.name, self.route.start_point.name, self.route.end_point.name)

    business = models.ForeignKey(
        Business,
        null=False,
        on_delete=models.PROTECT,
    )
    route = models.ForeignKey(
        VehicleRoute,
        null=False,
        on_delete=models.PROTECT,
    )
    price = models.FloatField(
        null=False,
    )
    estimated_duration = models.DurationField(
        null=True,
        default=timedelta(hours=2),
    )

    class Meta:
        unique_together = [
            [
                'business', 'route',
            ],
        ]

    def clean(self):
        if self.business.resource_type.name != 'sumo':
            raise ValidationError(
                {
                    'business': 'This business does not hve valid resource type: (sumo)'
                }
            )


class VehicleSeatRate(models.Model):

    route_rate = models.ForeignKey(
        VehicleRouteRate,
        null=False,
        on_delete=models.PROTECT,
    )
    row_index = models.IntegerField(
        null=False,
        validators=[MinValueValidator(0)],
    )
    column_index = models.IntegerField(
        null=False,
        validators=[MinValueValidator(0)],
    )
    rate = models.FloatField(
        null=False,
    )

    class Meta:
        unique_together = [
            [
                'route_rate', 'row_index', 'column_index',
            ],
        ]

    def clean(self):
        resource_seat_template = ResourceSeatTemplate.objects.get(resource_type=self.route_rate.business.resource_type)
        if not (self.row_index < resource_seat_template.row_count):
            raise ValidationError(
                {
                    'row_number': "Row Number must be less than row count of seat template",
                },
            )

        if not (self.column_index < resource_seat_template.column_count):
            raise ValidationError(
                {
                    'column_number': "Column Number must less than column count of seat template",
                },
            )

        resource_seat = ResourceSeat.objects.get(
            seat_template=resource_seat_template,
            row_index=self.row_index,
            column_index=self.column_index,
        )

        if resource_seat.is_hidden or resource_seat.is_disabled:
            raise ValidationError('This seat is either hidden or disabled')


class VehicleRouteRateTemplate(models.Model):
    """
    AdminSide:
    Unique Constraints: business, route, resource_type, row_number, column_number
    Validation:
        ResourceType should be any of [sumo]
        0 >= row_number < resource_seat_template.row_count
        0 >- column_number < resource_seat_template.column_count
    """
    business = models.ForeignKey(
        Business,
        null=False,
        on_delete=models.PROTECT,
    )
    route: models.ForeignKey = models.ForeignKey(
        VehicleRoute,
        null=False,
        on_delete=models.PROTECT,
    )
    resource_type: models.ForeignKey = models.ForeignKey(
        ResourceType,
        null=False,
        on_delete=models.PROTECT,
    )
    row_number = models.IntegerField(
        null=False,
        validators=[MinValueValidator(0)],
    )
    column_number = models.IntegerField(
        null=False,
        validators=[MinValueValidator(0)],
    )
    rate = models.IntegerField(
        null=False,
    )
    is_disabled = models.BooleanField(
        null=False,
        default=True,
    )

    class Meta:
        unique_together = [
            [
                'business', 'route', 'resource_type', 'row_number', 'column_number'
            ]
        ]

    def clean(self):
        resource_seat = ResourceSeatTemplate.objects.get(resource_type=self.resource_type)
        if not (self.row_number < resource_seat.row_count):
            raise ValidationError(
                {
                    'row_number': "row number must less than template row count",
                },
            )
        
        if not (self.column_number < resource_seat.column_count):
            raise ValidationError(
                {
                    'column_number': "column number must less than template column count",
                },
            )

    def save(self, *args, **kwargs):
        self.full_clean()
        return super().save(*args, **kwargs)             


class VehicleQueue(models.Model):
    vehicle: models.ForeignKey = models.ForeignKey(
        BusinessResource,
        null=False,
        on_delete=models.PROTECT,
    )
    rate = models.ForeignKey(
        VehicleRouteRate,
        null=False,
        on_delete=models.PROTECT,
    )
    time = models.DateTimeField(
        null=False,
    )
    is_active = models.BooleanField(
        null=False,
        default=False,
    )
    created_at = models.DateTimeField(
        null=False,
    )
