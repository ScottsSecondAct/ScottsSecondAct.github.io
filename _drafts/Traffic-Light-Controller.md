Here's a clear and comprehensive **Design Specification** for the **Traffic Light Controller FSM** using a Moore Machine, integrating **vehicle detection sensors**, **pedestrian crossing sensors**, and provisions for future emergency vehicle handling:

---

# Traffic Light Controller with Sensor Integration  
## Moore FSM – Verilog Design Specification  

### Overview
This document provides a complete specification for implementing a Moore Finite State Machine (FSM) to control traffic lights at an intersection with two directions (North-South and East-West). The FSM dynamically adapts to real-time inputs from vehicle and pedestrian sensors.

---

### Inputs and Outputs

**Inputs:**

| Signal       | Type     | Description                       |
|--------------|----------|-------------------------------------|
| `clk`       | Clock input                      | Digital  |
| `reset`     | Active-high reset (asynchronous)  | Digital  |
| `NS_sensor` | Vehicle detected North-South      | Digital  |
| `EW_sensor` | Vehicle detected East-West        | Digital  |
| `NS_ped`    | Pedestrian button North-South     | Digital (optional) |
| `EW_ped`    | Pedestrian button East-West       | Digital (optional) |

### Outputs
Each direction has a 2-bit output indicating current traffic lights:

| Direction | Signal (2 bits)        | Meaning                |
|------------|---------------------|----------------------------|
| NS_Light   | 00=Red, 01=Yellow, 10=Green | North-South lights status  |
| EW_Light   | 00=Red, 01=Yellow, 10=Green | East-West lights status    |

---

## FSM States and Timing:

| State Name | NS_Light | EW_Light | Default Duration | Conditions for Transition |
|------------|----------|----------|----------------|-------------------------|
| NS_GREEN   | Green    | Red      | 30 sec   | Extend up to 60 sec if no EW vehicles. Transition after 30 s if EW sensor activated. |
| NS_YELLOW  | Yellow   | Red      | 5 sec        | Always transition after 5 sec |
| EW_GREEN   | Red      | Green    | 30 sec       | Extend up to 60 s if no NS traffic detected |
| EW_YELLOW  | Red      | Yellow   | 5 sec        | Always transition after 5 sec |

---

## Inputs and Outputs:

### Inputs Detail:
- `clk`: System timing signal (synchronous).
- `reset`: Immediately resets FSM state to initial NS_GREEN.
- Vehicle sensors (`NS_sensor`, `EW_sensor`) detect cars waiting at intersection.
- Pedestrian buttons (`NS_ped`, `EW_ped`) indicate pedestrian crossing requests (optional integration).

### Outputs (Moore):
FSM outputs depend exclusively on current FSM state (Moore machine design):

- `NS_Light`:
  - `2'b10`: Green
  - `2'b01`: Yellow
  - `2'b00`: Red

- `EW_Light`:
  - `2'b10`: Green
  - `2'b01`: Yellow
  - `2'b00`: Red

---

## FSM State Transition Conditions:

### NS_GREEN (default entry state):
- Timer starts counting at entry.
- Default duration is **30 seconds**.
- If **EW_sensor** detects waiting vehicles and minimum green duration (30s) elapsed, transition to **NS_YELLOW**.
- If no EW traffic detected, allow extension up to maximum of **60 seconds**, then transition to **NS_YELLOW**.

### NS_YELLOW:
- Always transition to **EW_GREEN** after exactly **5 seconds**.

### EW_GREEN:
- Default duration is **30 seconds**.
- Extend up to **60 seconds** if no NS traffic detected.
- Transition to **EW_YELLOW** when minimum time (30s) is met and either NS_sensor detects vehicles or maximum time elapsed.

### EW_YELLOW:
- Fixed duration **5 seconds**.
- After duration expires, transition back to **NS_GREEN**.

---

## State Transition Logic Summary:

```plaintext
NS_GREEN  --> NS_YELLOW [after 30s & EW_sensor active or after 60s]
NS_YELLOW --> EW_GREEN  [after 5s]
EW_GREEN  --> EW_YELLOW [after 30s & NS_sensor active or after 60s]
EW_YELLOW --> NS_GREEN [always after 5s]
```

---

## Reset and Initialization:

Upon system reset (asynchronous reset active-high):

- FSM resets immediately to `NS_GREEN`.
- Timer resets to `0`.

---

## Sensor Integration Logic:

- Vehicle sensors (`NS_sensor`, `EW_sensor`) actively guide state transitions.
- Prioritization rules:
  - Current green direction maintains priority unless sensor indicates waiting vehicles in other direction after minimum green duration.
- Sensors are digital inputs (`1`: vehicle present, `0`: no vehicle detected).

---

## Pedestrian Crossing (Optional Integration):

- Pedestrian crossing requests (`NS_ped`, `EW_ped`) can trigger shortened wait times or prevent green-time extensions.
- Implementation of pedestrian signals is optional but recommended for safety and usability.

---

## FSM Timing Counter Logic:

- Internal timing counter increments every second using system clock (`clk`).
- Counter resets upon each state transition.

```verilog
always @(posedge clk or posedge reset) begin
    if (reset)
        timer <= 0;
    else if (state != next_state)
        timer <= 0;
    else
        timer <= timer + 1;
end
```

---

## Hardware Assumptions and Constraints:

- The FSM operates on a synchronous digital clock signal.
- Vehicle detection sensors reliably provide binary detection signals.
- FSM outputs traffic lights status signals compatible with external lamp driver hardware.

---

## Future Enhancements:

- **Pedestrian Crosswalk Integration**: Pedestrian sensors/buttons trigger dedicated crossing states.
- **Emergency Vehicle Override**: Special input lines for emergency vehicles trigger immediate state transitions.
- **Communication Interface**: Capability for integration with external traffic management systems or IoT-based monitoring platforms.

---

## Conclusion:

This design specification provides clear, non-redundant, and implementable details for developing an efficient, sensor-driven Traffic Light Controller FSM. The Moore machine architecture ensures outputs reflect clearly defined states, simplifying debugging and enhancing reliability.

---