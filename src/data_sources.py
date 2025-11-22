from abc import ABC, abstractmethod

class DataSource(ABC):
    def __init__(self, settings):
        self.settings = settings

    @abstractmethod
    def is_configured(self) -> bool:
        pass

    @abstractmethod
    def get_connection_string(self) -> str:
        pass
