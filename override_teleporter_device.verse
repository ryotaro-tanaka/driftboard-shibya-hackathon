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

    ExitVolumeEvent(Agent: agent):void =
        VarriaOnVehicle.Disable()
        TeleportTargetVehicle.AssignDriver(Agent)

    OnBegin<override>()<suspends>:void=
        # プレイヤーがジャンプ等によって姿勢が崩れているとき、車両破壊と新しい車両へのアサインを同時に行うと
        # プレイヤーが固まって動かなくなるバグが発生するので、時間差で動作するようにEnterイベントとExitイベントで分ける
        TeleportTriggerVolume.AgentEntersEvent.Subscribe(EnterVolumeEvent)
        TeleportTriggerVolume.AgentExitsEvent.Subscribe(ExitVolumeEvent)
