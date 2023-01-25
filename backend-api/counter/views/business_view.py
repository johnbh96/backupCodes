from django.http import HttpRequest, HttpResponse, Http404
from rest_framework import status
from rest_framework import viewsets
from rest_framework import authentication, permissions
from dj_rest_auth import jwt_auth

from counter.models import Business
from counter.serializers import BusinessRequestSerializer, BusinessSerializer, \
    response_wih_data, response_with_bad_request, response_with_deleted


class BusinessViewSet(viewsets.ViewSet):

    authentication_classes = [authentication.TokenAuthentication, jwt_auth.JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self, pk):
        try:
            return Business.objects.get(pk=pk)
        except Business.DoesNotExist:
            raise Http404

    def retrieve(self, request, pk=None):
        business = self.get_object(pk)
        return response_wih_data(
            serializer=BusinessRequestSerializer(business),
        )

    def create(self, request) -> HttpResponse:
        serializer = BusinessRequestSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save(requesting_user=request.user)
            return response_wih_data(
                serializer=BusinessSerializer(
                    instance
                ),
                status=status.HTTP_201_CREATED,
            )
        return response_with_bad_request(serializer=serializer)

    def update(self, request, pk=None):
        business = self.get_object(pk)
        serializer = BusinessRequestSerializer(business, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return response_wih_data(serializer=serializer)
        return response_with_bad_request(serializer=serializer)

    def destroy(self, request, pk=None):
        business = self.get_object(pk)
        business.delete()
        return response_with_deleted()


create_business = BusinessViewSet.as_view({
    'post': 'create',
})

handle_business = BusinessViewSet.as_view({
    'get': 'retrieve',
    'put': 'update',
    'delete': 'destroy',
})
