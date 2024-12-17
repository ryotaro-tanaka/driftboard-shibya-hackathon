using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }

# https://dev.epicgames.com/documentation/ja-jp/uefn/controlling-fortnites-default-hud-in-unreal-editor-for-fortnite
# https://dev.epicgames.com/documentation/en-us/uefn/verse-api/fortnitedotcom/ui
hide_default_hud := class(creative_device):

    OnBegin<override>()<suspends> : void =
        Playspace := Self.GetPlayspace()
        HUDController := Playspace.GetHUDController()

        HUDElementsToHide := array:
            player_hud_identifier_all{}
            creative_hud_identifier_all{}
            hud_identifier_world_resource_wood{}
            hud_identifier_world_resource_stone{}
            hud_identifier_world_resource_metal{}
            hud_identifier_world_resource_permanite{}
            hud_identifier_world_resource_gold_currency{}
            hud_identifier_world_resource_ingredient{}

        HUDController.HideElements(HUDElementsToHide)