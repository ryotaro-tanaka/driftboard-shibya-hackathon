using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# using { /Fortnite.com/Playspaces }
# using { /Fortnite.com/Characters }
# using { /UnrealEngine.com/Temporary/SpatialMath }

# position_info := class:
#     Vector: vector3
#     Rotation: rotation

# 車両を含むテレポート
# 車両を破壊してテレポート先の車両に乗り換える方法を使用
override_teleporter_device := class(creative_device):
    @editable
    TeleportTriggerVolume: volume_device = volume_device{}

    @editable
    FirstVehicle: vehicle_spawner_driftboard_device = vehicle_spawner_driftboard_device{}

    @editable
    TeleportTargetVehicle: vehicle_spawner_driftboard_device = vehicle_spawner_driftboard_device{}

    @editable
    VarriaOnVehicle: barrier_device = barrier_device{}

    EnterVolumeEvent(Agent: agent):void =
        FirstVehicle.DestroyVehicle()
        # MovePlayer(Agent)
        # TeleportTargetVehicle.AssignDriver(Agent)

    # Enterイベントで車両に乗り換えできなかったとき用
    ExitVolumeEvent(Agent: agent):void =
        VarriaOnVehicle.Disable()
        TeleportTargetVehicle.AssignDriver(Agent)

    OnBegin<override>()<suspends>:void=
        # プレイヤーがジャンプ等によって姿勢が崩れているとき、車両破壊と新しい車両へのアサインを同時に行うと
        # プレイヤーが固まって動かなくなるバグが発生するので、時間差で動作するようにEnterイベントとExitイベントで分ける
        TeleportTriggerVolume.AgentEntersEvent.Subscribe(EnterVolumeEvent)
        TeleportTriggerVolume.AgentExitsEvent.Subscribe(ExitVolumeEvent)

    # # 人を移動させる
    # MovePlayer(Agent: agent):void =
    #     if (MyPlayer : fort_character = GetPlayer[]) :
    #         # ExitPosition : position_info = GetExitPosition()
    #         ExitPosition : position_info = GetPlayerPosition()
    #         if (MyPlayer.TeleportTo[
    #             Position := ExitPosition.Vector, 
    #             Rotation := ExitPosition.Rotation
    #         ]):
    #             Print("Teleport Done")

    # GetPlayerPosition(): position_info =
    #     Trans : transform = TeleportTargetVehicle.GetTransform()
    #     Hoge : transform = FirstVehicle.GetTransform()
    #     position_info{
    #         Vector := vector3{
    #             X := Trans.Translation.X + 1000.0,
    #             Y := Trans.Translation.Y + 1000.0,
    #             Z := Trans.Translation.Z + 1000.0
    #         },
    #         Rotation := Trans.Rotation
    #     }

    # GetPlayer()<transacts><decides>: fort_character =
    #     Playspace: fort_playspace = GetPlayspace()
    #     AllPlayers := Playspace.GetPlayers()
    #     MyPlayer : player = AllPlayers[0]
    #     MyFortCharacter : fort_character = MyPlayer.GetFortCharacter[]
    #     return MyFortCharacter

    # GetExitPosition(): position_info =
    #     Trans : transform = TeleportTargetVehicle.GetTransform()
    #     position_info{
    #         Vector := vector3{
    #             X := Trans.Translation.X,
    #             Y := Trans.Translation.Y,
    #             Z := Trans.Translation.Z
    #         },
    #         Rotation := Trans.Rotation
    #     }