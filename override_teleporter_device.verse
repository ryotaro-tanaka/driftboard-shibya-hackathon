using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# 車両を含むテレポート
# 車両を破壊してテレポート先の車両に乗り換える方法を使用
override_teleporter_device := class(creative_device):
    @editable
    TeleportTriggerVolume: volume_device = volume_device{}

    @editable
    FirstVehicle: vehicle_spawner_driftboard_device = vehicle_spawner_driftboard_device{}

    @editable
    TeleportTargetVehicle: vehicle_spawner_driftboard_device = vehicle_spawner_driftboard_device{}

    EnterVolumeEvent(Agent: agent):void =
        FirstVehicle.DestroyVehicle()
        TeleportTargetVehicle.AssignDriver(Agent)

    # Enterイベントで車両に乗り換えできなかったとき用
    ExitVolumeEvent(Agent: agent):void =
        TeleportTargetVehicle.AssignDriver(Agent)

    OnBegin<override>()<suspends>:void=
        TeleportTriggerVolume.AgentEntersEvent.Subscribe(EnterVolumeEvent)
        TeleportTriggerVolume.AgentExitsEvent.Subscribe(ExitVolumeEvent)
