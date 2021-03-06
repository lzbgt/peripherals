# hba_quad

## Description


This module provides an interface to two
quatrature encoders.  This module senses the direction
and increments or decrements the encoder count as appropriate.
Each encoder count is a 16-bit value, stored in two
8-bit registers.  It is recommended to disable the encoder
updates before reading the encoder values.  Then re-enable
encoder updates after the values are read.  The encoder
counts will still be updated internally only the updating
to the register bank is paused.

## Port Interface

This module implements an HBA Slave interface.
It also has the following additional ports.

* __slave_interrupt__ (output) : Asserted when a new value(s) are available.
* __quad_enc_a__[1:0] : The left(0) and right(1) quadrature a input
* __quad_enc_b__[1:0] : The left(0) and right(1) quadrature b input
* __quad_speed_left__ : Left encoder ticks during last speed period
* __quad_speed_right__ : Right encoder ticks during last speed period
* __quad_speed_pulse__ : Pulse indicates end of speed period.


## Register Interface

There are three 8-bit registers.

* __reg0__ : Control register. Enables quad enc updates and interrupts.
    * reg0[0] : Enable left encoder register updates
    * reg0[1] : Enable right encoder register updates
    * reg0[2] : Enable interrupt.
    * reg0[3] : Reset both encoders by writing 1. Not auto-cleared.
* __reg1__ : Left encoder count, least significant byte
* __reg2__ : Left encoder count, most significant byte
* __reg3__ : Right encoder count, least significant byte

* __reg4__ : Right encoder count, most significant byte
* __reg5__ : (reg_speed_left) Left encoder count during speed_interval_pulse period.
* __reg6__ : (reg_speed_right) Right encoder count during speed_interval_pulse period.
* __reg7__ : (reg_rate_ms) speed_interval_pulse period in ms.  Valid range 0..255ms.
Encoder ticks are counted during this period to infer speed.  Default 0 (disabled).

## TODO

* Add ability to toggle the forward direction via ctrl register.
* Add ability to reset encoder counts via ctrl register.

