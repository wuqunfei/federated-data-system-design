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

    def get_connection_setup_commands(self) -> list[str]:
        """Returns the commands needed to set up the connection - default implementation returns empty list"""
        return []
