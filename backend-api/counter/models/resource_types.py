from django.db import models

from .choices import ResourceGroupType, ResourceCapacityType, ResourceDurationType


class ResourceType(models.Model):

    # Name should be unique
    # so use name to identify object
    def __str__(self):
        return '%s' % self.name

    name: models.CharField = models.CharField(null=False, max_length=80, unique=True)
    description: models.CharField = models.CharField(null=False, max_length=240)
    group_type = models.CharField(
        null=False,
        max_length=80,
        choices=ResourceGroupType.choices,
        default=ResourceGroupType.LetterFirst,
    )
    capacity_type = models.CharField(
        null=False,
        max_length=80,
        choices=ResourceCapacityType.choices,
        default=ResourceCapacityType.FixedDefault,
    )
    default_capacity = models.IntegerField(
        null=True,
    )
    duration_type = models.CharField(
        null=False,
        max_length=80,
        choices=ResourceDurationType.choices,
        default=ResourceDurationType.InHours,
    )
    label_singular: models.CharField = models.CharField(null=False, max_length=100)
    label_plural: models.CharField = models.CharField(null=False, max_length=120)

    @classmethod
    def setup(cls,):

        vehicle_sumo = ResourceType(
            name='sumo',
            description='Sumo with 9 seat capacity',
            group_type=ResourceGroupType.Individual,
            capacity_type=ResourceCapacityType.SeatTemplate,
            duration_type=ResourceDurationType.TimeTabled,
            label_singular='Sumo',
            label_plural='Sumo(s)',
        )
        sumo_seat_template: ResourceSeatTemplate = ResourceSeatTemplate(
            resource_type=vehicle_sumo,
            name='1x4x4',
            row_count=3,
            column_count=4,
        )
        sumo_seats = []

        # prepare seat
        for row_index in range(sumo_seat_template.row_count):
            for column_index in range(sumo_seat_template.column_count):

                """
                [ ]------[x]
                [ ][ ][ ][ ]
                [ ][ ][ ][ ]
                """
                is_hidden = False
                is_disabled = False

                if row_index == 0 and (1 <= column_index >= 2):
                    is_hidden = True
                    is_disabled = True

                sumo_seat = ResourceSeat(
                    seat_template=sumo_seat_template,
                    alias='default',
                    row_index=row_index,
                    column_index=column_index,
                    is_hidden=is_hidden,
                    is_disabled=is_disabled,
                )
                sumo_seats.append(sumo_seat)

        vehicle_sumo.save()
        sumo_seat_template.save()
        ResourceSeat.objects.bulk_create(sumo_seats)


class ResourceSeatTemplate(models.Model):

    # Name should be unique
    # so use name to identify object
    def __str__(self):
        return '%s (%s)' % (self.resource_type.name, self.name)

    resource_type = models.ForeignKey(
        ResourceType,
        on_delete=models.PROTECT,
    )
    name = models.CharField(
        null=False,
        max_length=6,
    )
    row_count = models.IntegerField(
        null=False,
    )
    column_count = models.IntegerField(
        null=False,
    )


class ResourceSeat(models.Model):
    seat_template = models.ForeignKey(
        ResourceSeatTemplate,
        on_delete=models.PROTECT,
        related_name='seats',
    )
    alias = models.CharField(
        null=False,
        max_length=80,
    )
    row_index = models.IntegerField(
        null=False,
    )
    column_index = models.IntegerField(
        null=False,
    )
    is_hidden = models.BooleanField(
        null=False,
    )
    is_disabled = models.BooleanField(
        null=False,
    )
