from django.http import HttpResponse, JsonResponse
from rest_framework import serializers, status as s

from .error_serializer import RequestFailed
from .response_serializer import BusinessTypeSerializer, ResourceOptionSerializer,\
    ResourceSeatTemplateSerializer, ResourceSeatSerializer
from .business_serializer import BusinessRequestSerializer, BusinessSerializer
from .resource_serializer import CreateResourceSerializer, BusinessResourceSerializer


def response_wih_data(serializer: serializers.Serializer, status=s.HTTP_200_OK) -> JsonResponse:
    return JsonResponse(
        data={
            "data": serializer.data,
        },
        safe=False,
        status=status,
    )


def response_with_bad_request(serializer: serializers.Serializer) -> JsonResponse:
    return JsonResponse(
        data={
            "errors": serializer.errors,
        },
        safe=False,
        status=s.HTTP_400_BAD_REQUEST,
    )


def response_with_failure(reason: RequestFailed) -> HttpResponse:

    return JsonResponse(
        data={
            "errors": [
                {
                    "code": reason.error_code,
                    "message": reason.message,
                },
            ],
        },
        safe=False,
        status=reason.status_code,
    )


def response_with_deleted() -> HttpResponse:
    return HttpResponse(status=s.HTTP_204_NO_CONTENT)
