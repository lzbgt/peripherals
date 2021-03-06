# hba_qtr

## Description

This module provides an interface to two
QTR reflectance sensors from Pololu.
Each sensor returns an 8-bit value which represents
The time it took for the QTR output pin to go
low after being charged.  The higher the reflectance
the shorter the time for the pin to go low.  The resolution
of the 8-bit value is in 10us.  So max value of
255 gives a time of 2.55ms.


## Port Interface

This module implements an HBA Slave interface.
It also has the following additional ports.

* __slave_interrupt__ (output) : Asserted when a new value(s) are available.
* __slave_estop__ (output) : An emergency stop output. A pulse stops the motors.
Generated when cliff detection is enabled (0xff value).

* __qtr_out_en[1:0]__ (output) : Tri-state control pin.  When 1, the associated
pin is an output, else it is an input.
* __qtr_out_sig[1:0]__ (output) : Measure time to go low after charge.  The time
indicates reflectivity.  The shorter the time the higher the reflectivity
* __qtr_in_sig[1:0]__ (input) : Asserted for 10us to charge the qtr output pin.
* __qtr_ctrl[1:0]__ (output) : The ctrl signal that turns on/off and selects
the power level of the LED.


## Register Interface

There are five 8-bit registers.

* __reg0__ : Control register. Enables qtr sensors and interrupts.
    * reg0[0] : Enable QTRs (left and right)
    * reg0[1] : Enable interrupt.
    * reg0[2] : Interrupt Type, Period=0 or Threshold=1
    * reg0[3] : Enable estop for cliff detection (0xff value)
* __reg1__ : Last QTR 0 value
* __reg2__ : Last QTR 1 value
* __reg3__ : Trigger period.  Granularity 50ms. Default/Min 50ms.
    period = (reg3*50ms)+50ms.
* __reg4__ : Threshold value,  crossing the threshold value on either sensors
causes an interrupt to be generated if the interrupt type is set to Threshold
via reg0[2]=1.


## TODO

* Add ability to set the led power level via the CTRL pin.

