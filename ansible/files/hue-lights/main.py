import asyncio
from bleak import BleakScanner
import HueBLE


async def main():

    # Address of light to connect to
    # TODO: This is the UUID because mac doesn't show MAC addresses, but when we switch to Ubuntu container we should use MAC address.
    address = "F883E1AC-4B74-4F5E-9CB2-C56DFFA15014"

    # Obtain the BLEDevice from bleak
    device = await BleakScanner.find_device_by_address(address, timeout=60.0)

    # Initialize the light object
    light = HueBLE.HueBleLight(device)

    # Optionally we could call connect but it will be called automatically
    # on the first request to the light. You might want to call this if
    # you want to subscribe to state changes without changing the lights state.
    # await light.connect()

    # Will automatically connect to the light and turn it off
    await light.set_power(False)

    # Wait
    await asyncio.sleep(5)

    # Turn the light back on again
    await light.set_power(True)

if __name__ == "__main__":
    asyncio.run(main())
