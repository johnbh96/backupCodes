from django.contrib import admin
from django import forms
from django.core.exceptions import ValidationError

from typing import (Dict, Any)

from counter.models import (
    Question, Business, ResourceType,
    VehicleStop, VehicleRoute, VehicleRouteRate, VehicleSeatRate,
    VehicleQueue, VehicleRouteRateTemplate,
    BusinessResource, BusinessResourceOption, ResourceSeatTemplate
)
from counter.models.business import (
    BusinessDivision, BusinessDepartment, BusinessMembership
)
from counter.models.pricing import RouteSeatInlinePrice, RoutePlan
from counter.shared.validators import (
    is_valid_business_type_resource_type_ids,
)


class BusinessAdminForm(forms.ModelForm):
    class Meta:
        model = Business
        fields = '__all__'

    def clean(self) -> Dict[str, Any]:

        business_type = self.data['business_type'] or ''
        resource_type = self.data['resource_type'] or ''

        if business_type == '':
            raise ValidationError('Business Type is required')

        if resource_type == '':
            raise ValidationError('Resource Type is required')

        if not is_valid_business_type_resource_type_ids(
            business_type_id=int(self.data['business_type']),
            resource_type_id=int(self.data['resource_type']),
        ):
            raise ValidationError(
                'Invalid resource type %s for business type %s'
                % (self.data['resource_type'], self.data['business_type']),
            )
        return super().clean()


class BusinessAdmin(admin.ModelAdmin):
    form = BusinessAdminForm


class VehicleRouteForm(forms.ModelForm):
    class Meta:
        model = VehicleRoute
        fields = '__all__'

    def clean(self) -> Dict[str, Any]:
        if self.data['start_point'] == self.data['end_point']:
            raise ValidationError('Start point and end point can not be same')
        return super().clean()


class VehicleRouteAdmin(admin.ModelAdmin):
    form = VehicleRouteForm


class BusinessResourceForm(forms.ModelForm):
    class Meta:
        model = BusinessResource
        fields = '__all__'

    def __init__(self, *args, **kwargs):
        super(BusinessResourceForm, self).__init__(*args, **kwargs)
        self.fields['group_letter'].required = False
        self.fields['capacity'].required = False

    def clean(self) -> Dict[str, Any]:
        business_id = self.data['business']
        resource_type_id = self.data['resource_type']

        if business_id is None or business_id == '':
            raise ValidationError('Business is required')

        if resource_type_id is None or resource_type_id == '':
            raise ValidationError('Resource Type is required')

        business = Business.objects.filter(id=self.data['business']).first()

        if business is None:
            raise ValidationError('Business does not exist')

        is_valid_resource_type = BusinessResourceOption.objects.filter(
            business_type_id=business.business_type.id,
            resource_type_id=resource_type_id,
        ).exists()

        if not is_valid_resource_type:
            raise ValidationError('Resource type is not valid for %s' % business)

        resource_type = ResourceType.objects.filter(id=self.data['resource_type']).first()
        if resource_type is None:
            raise ValidationError('Resource Type does not exist')

        if resource_type.name != 'sumo':
            raise ValidationError('%s is not supported' % self.data['resource_type'])
        else:
            group_letter = self.data['group_letter'] or ''
            capacity = self.data['capacity'] or ''
            if group_letter != '':
                raise ValidationError('Group letter should be null for sumo')
            if capacity != '':
                raise ValidationError('Capacity should be null for sumo')
            return super().clean()


class BusinessResourceAdmin(admin.ModelAdmin):
    form = BusinessResourceForm


class RouteSeatInlinePriceAdmin(admin.TabularInline):
    model = RouteSeatInlinePrice


class RoutePlanAdmin(admin.ModelAdmin):
    inlines = [
        RouteSeatInlinePriceAdmin,
    ]


admin.site.register(Question)
admin.site.register(Business, BusinessAdmin)
admin.site.register(BusinessDivision)
admin.site.register(BusinessDepartment)
admin.site.register(BusinessMembership)
admin.site.register(VehicleStop)
admin.site.register(VehicleRoute, VehicleRouteAdmin)
admin.site.register(BusinessResource, BusinessResourceAdmin)

# Check:
# 1. Should not overlap time for same vehicle
admin.site.register(ResourceSeatTemplate)
admin.site.register(VehicleRouteRate)
admin.site.register(VehicleSeatRate)
admin.site.register(VehicleQueue)
admin.site.register(RoutePlan, RoutePlanAdmin)
