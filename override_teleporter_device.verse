
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Verse }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

position_info := class:
    Vector: vector3
    Rotation: rotation

# 乗車中にテレポーターAに触ったときにBに移動したい。
# A Verse-authored creative device that can be placed in a level
override_teleporter_device := class(creative_device):
    # @editable
    # teleportEntry: teleporter_device = teleporter_device{}

    @editable
    teleportExit: teleporter_device = teleporter_device{}

    # 発火用volume?
    @editable
    teleportVolume: volume_device = volume_device{}

    @editable
    driver: player_spawner_device = player_spawner_device{}

    
    GetPlayer()<transacts><decides>: fort_character =
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers := Playspace.GetPlayers()
        MyPlayer : player = AllPlayers[0]
        MyFortCharacter : fort_character = MyPlayer.GetFortCharacter[]
        return MyFortCharacter
    
    GetExitPosition(): position_info =
        Print("GetExitPosition")
        Trans : transform = teleportExit.GetTransform()
        position_info{
            Vector := vector3{
                X := Trans.Translation.X,
                Y := Trans.Translation.Y,
                Z := Trans.Translation.Z
            },
            Rotation := Trans.Rotation
        }

    EnterVolume(Agent: agent):void =
        Print("EnterVolume")
        if (MyPlayer : fort_character = GetPlayer[]) :
            # CharacterPosition : vector3 = MyPlayer.GetViewLocation()
            # NewRotation :rotation = MyPlayer.GetViewRotation()
            # Print("aaa {CharacterPosition}, {NewRotation}")
            ExitPosition : position_info = GetExitPosition()
            if (MyPlayer.TeleportTo[
                Position := ExitPosition.Vector, 
                Rotation := ExitPosition.Rotation
            ]):
            # if (MyPlayer.TeleportTo[
            #     Position : vector3 = vector3{
            #         X := CharacterPosition.X,
            #         Y := CharacterPosition.Y,
            #         Z := CharacterPosition.Z + 100.0
            #     },
            #     Rotation : rotation = NewRotation
            # ]):
                Print("done")

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Print("Hello, world?", ?Duration:= 10.0, ?Color:= Yellow)
        teleportVolume.AgentEntersEvent.Subscribe(EnterVolume)
