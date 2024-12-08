
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
telepoter_device := class(creative_device):
    @editable
    teleportEntry: teleporter_device = teleporter_device{}

    @editable
    teleportExit: teleporter_device = teleporter_device{}

    @editable
    RaceManager:race_manager_device = race_manager_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Hello, world!")
        Print("2 + 2 = {2 + 2}")