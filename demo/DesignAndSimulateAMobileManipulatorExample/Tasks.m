classdef Tasks < Simulink.IntEnumType
   enumeration
      Arm_Pick (0)
      Arm_Place (1)
      Arm_Home (2)
      Arm_Detect (3)
      Robot_Navigate (4)
      Idle (5)
   end
end