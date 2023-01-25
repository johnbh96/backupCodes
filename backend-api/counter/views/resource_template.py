from django.http import HttpRequest, HttpResponse,\
    HttpResponseNotFound, HttpResponseBadRequest
from rest_framework.views import APIView
from rest_framework import authentication, permissions

from counter.models import ResourceType, ResourceSeatTemplate
from counter.serializers import response_wih_data, ResourceSeatTemplateSerializer
from counter.tasks import add


class ResourceTemplate(APIView):

    authentication_classes = [authentication.SessionAuthentication]
    permission_classes = [permissions.AllowAny]

    def get(self, request: HttpRequest, *args, **kwargs) -> HttpResponse:
        resource_type = ResourceType.objects.filter(name=kwargs['resource_type_name']).first()

        if resource_type is None:
            return HttpResponseNotFound()

        if resource_type.capacity_type != 'SeatTemplate':
            return HttpResponseBadRequest()

        template = ResourceSeatTemplate.objects.filter(resource_type__id=resource_type.id).first()

        if template is None:
            raise Exception(f'Failed to load {resource_type.name} template')

        # template.seats = ResourceSeatSerializer(
        #     ResourceSeat.objects.filter(seat_template__id=template.id),
        #     many=True,
        # )
        add.delay(4, 4)

        return response_wih_data(
            serializer=ResourceSeatTemplateSerializer(template),
        )
