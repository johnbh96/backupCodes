from typing import Optional

class RequestFailed:

    def __init__(self, error_code: int, status_code: int, message: Optional[str]):
        self.error_code = error_code
        self.status_code = status_code
        self.message = message


class ResourceNotFound(RequestFailed):

    def __init__(self, message: Optional[str]):
        super().__init__(error_code=404, status_code=404, message=message)


class AccessNotAllowed(RequestFailed):

    def __init__(self, message: Optional[str]):
        super().__init__(error_code=401, status_code=401, message=message)
