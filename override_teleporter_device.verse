
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
    # 発火用volume?
    @editable
    teleportVolume: volume_device = volume_device{}

    @editable
    vehicleSpawner1: vehicle_spawner_driftboard_device = vehicle_spawner_driftboard_device{}

    @editable
    vehicleSpawner2: vehicle_spawner_driftboard_device = vehicle_spawner_driftboard_device{}

    GetPlayer()<transacts><decides>: fort_character =
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers := Playspace.GetPlayers()
        MyPlayer : player = AllPlayers[0]
        MyFortCharacter : fort_character = MyPlayer.GetFortCharacter[]
        return MyFortCharacter
    
    GetExitPosition(): position_info =
        Trans : transform = vehicleSpawner2.GetTransform()
        position_info{
            Vector := vector3{
                X := Trans.Translation.X,
                Y := Trans.Translation.Y,
                Z := Trans.Translation.Z
            },
            Rotation := Trans.Rotation
        }

    # 車両を移動させる(車両を破壊)
    EnterVolume2(Agent: agent):void =
        vehicleSpawner1.DestroyVehicle()
        vehicleSpawner2.AssignDriver(Agent)

    # 用意しておいた２つ目の車両にアサイン
    ExitVolume(Agent: agent):void =
        vehicleSpawner2.AssignDriver(Agent)

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        teleportVolume.AgentEntersEvent.Subscribe(EnterVolume2)
        teleportVolume.AgentExitsEvent.Subscribe(ExitVolume)
