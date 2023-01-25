from django.http import HttpRequest, HttpResponse, JsonResponse, HttpResponseNotFound
from rest_framework.views import APIView
from rest_framework import authentication, permissions

from counter.models import BusinessType, BusinessResourceOption
from counter.serializers import response_wih_data, ResourceOptionSerializer


class ResourceOptions(APIView):

    authentication_classes = [authentication.SessionAuthentication]
    permission_classes = [permissions.AllowAny]

    def get(self, request: HttpRequest, *args, **kwargs) -> HttpResponse:

        business_type = BusinessType.objects.filter(name=kwargs['business_type_name']).first()

        if business_type is None:
            return HttpResponseNotFound()

        resource_options = [
            option.resource_type
            for option in BusinessResourceOption.objects.filter(business_type__id=business_type.id)
        ]
        return response_wih_data(
            serializer=ResourceOptionSerializer(resource_options, many=True),
        )
