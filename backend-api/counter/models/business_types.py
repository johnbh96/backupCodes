from django.db import models


class BusinessType(models.Model):

    # Name should be unique
    # so use name to identify object
    def __str__(self):
        return 'Business Type (%s)' % self.name

    name: models.CharField = models.CharField(null=False, max_length=50, unique=True)
    label_singular: models.CharField = models.CharField(null=False, max_length=100)
    label_plural: models.CharField = models.CharField(null=False, max_length=120)
    description: models.CharField = models.CharField(null=False, max_length=240)

    @classmethod
    def build(
        cls,
        name: str,
        label_singular: str,
        label_plural: str,
        description: str,
    ):
        return cls(
            name=name,
            label_singular=label_singular,
            label_plural=label_plural,
            description=description,
        )

    @classmethod
    def setup(cls):
        business_types = [
            BusinessType.build(
                name='transport',
                label_singular='Transport',
                label_plural='Transports',
                description='',
            ),
            BusinessType.build(
                name='salon',
                label_singular='Salon',
                label_plural='Salons',
                description='Haircut, Beauty',
            ),
        ]

        for business_type in business_types:
            existing_business_type: BusinessType = BusinessType.objects.filter(name=business_type.name).first()
            if existing_business_type is None:
                business_type.save()
                pass
            else:
                existing_business_type.label_singular = business_type.label_singular
                existing_business_type.label_plural = business_type.label_plural
                existing_business_type.description = business_type.description
                existing_business_type.save()
                pass
