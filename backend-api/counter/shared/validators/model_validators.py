from counter.models import (
    BusinessType, ResourceType, BusinessResourceOption,
    Business,
)


# Business Type name is valid
# if same name does not exist
def is_existing_business_type_name(business_type_name: str):
    return BusinessType.objects.filter(name=business_type_name).exists()


# Resource Type name is valid
# if same name does not exist
def is_existing_resource_type_name(resource_type_name: str):
    return ResourceType.objects.filter(name=resource_type_name).exists()


# Business Type and Resource Type is valid
# if option of resource type for the business type exist
def is_valid_business_type_resource_type_ids(business_type_id: int, resource_type_id: int):
    return BusinessResourceOption.objects.filter(
        business_type_id=business_type_id,
        resource_type_id=resource_type_id,
    ).exists()


# Business Type and Resource Type is valid
# if option of resource type for the business type exist
def is_valid_business_type_resource_type_names(business_type_name: str, resource_type_name: str):
    return BusinessResourceOption.objects.filter(
        business_type_name=business_type_name,
        resource_type_name=resource_type_name,
    ).exists()


# Checks if business with given name exists
def is_existing_business_name(name: str):
    return Business.objects.filter(name=name).exists()
