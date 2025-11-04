# List of supported devices, add new family, device, etc. here.
set (LIST_SUPPORTED_STM32_TYPES "F0" "F3" "F4" "G4" "H7")

# set the cmake preset environment varialble STM32_TYPE to upper case
string (TOUPPER ${STM32_TYPE} STM32_TYPE_UPPERCASE)
message (STATUS "${libName}: setting STM32_TYPE as ${STM32_TYPE_UPPERCASE}")
