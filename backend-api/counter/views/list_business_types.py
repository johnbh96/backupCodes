from django.http import JsonResponse
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import authentication, permissions

from counter.models import BusinessType
from counter.shared import BaseView
from counter.serializers import response_wih_data, BusinessTypeSerializer


class ListBusinessTypes(APIView):
    """
    View to load App Configurations

    * Requires token authentication.
    * Only admin users are able to access this view.
    """
    authentication_classes = [authentication.SessionAuthentication]
    permission_classes = [permissions.AllowAny]

    def get(self, request, format=None) -> JsonResponse:
        """
        Return a list of all users.
        """
        business_types = [business_type for business_type in BusinessType.objects.all()]
        return response_wih_data(
            serializer=BusinessTypeSerializer(business_types, many=True),
        )

