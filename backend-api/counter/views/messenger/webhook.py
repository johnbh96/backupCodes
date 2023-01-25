from django.http import HttpRequest, HttpResponse
from rest_framework import (
    permissions, viewsets,
    status as ss,
)

verify_token: str = 's3cr8t01<n'


class MessengerWebHook(viewsets.ViewSet):

    authentication_classes = []
    permission_classes = [permissions.AllowAny]

    def get(self, request: HttpRequest) -> HttpResponse:
        # Parse the query params
        mode = request.GET.get('hub.mode')
        token = request.GET.get('hub.verify_token')
        challenge = request.GET.get('hub.challenge')
        print(mode)
        print(token)
        print(challenge)

        if mode is not None and token is not None:
            if mode == "subscribe" and token == verify_token:
                print('WEBHOOK_VERIFIED')
                return HttpResponse(status=ss.HTTP_200_OK, content=challenge)

        return HttpResponse(status=ss.HTTP_403_FORBIDDEN)


verify_web_hook = MessengerWebHook.as_view({
    'get': 'get',
})
