from django.contrib.auth.models import User

from counter.models import (
    Business, ResourceType,
)


def allowed_to_create_resource(requesting_user: User, business: Business) -> bool:

    if not requesting_user.is_active:
        return False

    if requesting_user.is_staff:
        return True

    if business is None:
        return False

    if business.resource_type.name != 'sumo':
        return False

    return requesting_user.id == business.owner.id
