import django.contrib.auth.models
from django.db import models
from django.utils.timezone import now

from .business_types import BusinessType
from .resource_types import ResourceType

from typing import List


class BusinessResourceOption(models.Model):
    business_type = models.ForeignKey(
        BusinessType,
        null=False,
        on_delete=models.PROTECT,
    )
    resource_type = models.ForeignKey(
        ResourceType,
        null=False,
        on_delete=models.PROTECT,
    )

    @classmethod
    def setup(cls):

        transport_name: str = 'transport'
        transport_type: BusinessType = BusinessType.objects.filter(name=transport_name).first()

        if transport_type is None:
            raise Exception('Business Type "transport" has not been setup')

        transport_resource_type_names = ['sumo']
        transport_resource_types: List[ResourceType] = ResourceType.objects.filter(
            name__in=transport_resource_type_names,
        )
        if len(transport_resource_type_names) != len(transport_resource_types):
            missing_transport_resource_types: str = ', '.join(
                list(
                    set(map(lambda x: x.name, transport_resource_types)) - set(transport_resource_type_names)
                )
            )
            raise Exception(f'''
            Resource Type: {missing_transport_resource_types}\n\tfor Business Type "{transport_name}" has not been setup
            ''')

        transport_options: List[BusinessResourceOption] = []

        for transport_resource_type in transport_resource_types:
            transport_options.append(
                BusinessResourceOption(
                    business_type=transport_type,
                    resource_type=transport_resource_type,
                ),
            )

        BusinessResourceOption.objects.bulk_create(transport_options)


class Business(models.Model):

    def __str__(self):
        return '%s' % self.name

    name: models.CharField = models.CharField(null=False, max_length=320, unique=True)
    owner: models.ForeignKey = models.ForeignKey(
        django.contrib.auth.models.User,
        null=False,
        on_delete=models.DO_NOTHING,
        related_name='owner',
    )
    creator: models.ForeignKey = models.ForeignKey(
        django.contrib.auth.models.User,
        null=False,
        on_delete=models.DO_NOTHING,
        related_name='creator',
    )
    business_type: models.ForeignKey = models.ForeignKey(
        BusinessType,
        null=False,
        on_delete=models.DO_NOTHING
    )
    resource_type: models.ForeignKey = models.ForeignKey(
        ResourceType,
        null=False,
        on_delete=models.DO_NOTHING,
    )
    address: models.CharField = models.CharField(null=False, max_length=500)


class BusinessDivision(models.Model):

    def __str__(self):
        return '%s, %s' % (self.name, self.address)

    business = models.ForeignKey(
        Business,
        null=False,
        on_delete=models.PROTECT,
    )
    name: models.CharField = models.CharField(
        null=False,
        max_length=200,
    )
    address: models.CharField = models.CharField(
        null=False,
        max_length=500,
    )
    is_active = models.BooleanField(
        null=False,
    )
    created_at = models.DateTimeField(
        null=False,
        default=now,
    )


class BusinessDepartment(models.Model):

    def __str__(self):
        return '%s, %s' % (self.name, self.division)

    division: models.ForeignKey = models.ForeignKey(
        BusinessDivision,
        null=False,
        on_delete=models.PROTECT,
    )
    name: models.CharField = models.CharField(
        null=False,
        max_length=120,
    )
    is_front_office = models.BooleanField(
        null=False,
        default=False,
    )
    is_active = models.BooleanField(
        null=False,
    )
    created_at = models.DateTimeField(
        null=False,
        default=now,
    )


class BusinessMembership(models.Model):

    def __str__(self):
        return '%s, %s' % (self.user.email, self.department)

    user: models.ForeignKey = models.ForeignKey(
        django.contrib.auth.models.User,
        null=False,
        on_delete=models.DO_NOTHING,
        related_name='member',
    )
    department: models.ForeignKey = models.ForeignKey(
        BusinessDepartment,
        null=False,
        on_delete=models.PROTECT,
    )
    is_admin = models.BooleanField(
        null=False,
        default=False,
    )
    is_active = models.BooleanField(
        null=False,
        default=False,
    )
    created_at = models.DateTimeField(
        null=False,
        default=now,
    )


class BusinessResource(models.Model):

    def __str__(self):
        return '%s, %s' % (self.name, self.business)

    business = models.ForeignKey(
        Business,
        null=False,
        on_delete=models.PROTECT,
    )
    resource_type = models.ForeignKey(
        ResourceType,
        null=False,
        on_delete=models.DO_NOTHING,
    )
    group_letter = models.CharField(
        null=True,
        max_length=1,
    )
    name = models.CharField(
        null=False,
        max_length=40,
    )
    capacity = models.IntegerField(
        null=True,
    )
