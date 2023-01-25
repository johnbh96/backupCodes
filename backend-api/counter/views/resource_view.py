from django.http import HttpResponse
from rest_framework import authentication, permissions, viewsets, status

from counter.serializers import (
    CreateResourceSerializer, BusinessResourceSerializer,
    response_wih_data, response_with_bad_request,
)


class ResourceViewSet(viewsets.ViewSet):

    authentication_classes = [authentication.SessionAuthentication]
    permission_classes = [permissions.AllowAny]

    def create(self, request) -> HttpResponse:
        serializer = CreateResourceSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save(requesting_user=request.user)
            return response_wih_data(
                serializer=BusinessResourceSerializer(
                    instance,
                ),
                status=status.HTTP_201_CREATED,
            )
        return response_with_bad_request(serializer=serializer)


create_resource = ResourceViewSet.as_view({
    'post': 'create',
})
