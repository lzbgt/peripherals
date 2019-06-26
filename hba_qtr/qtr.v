
module qtr #
(
    parameter integer CLK_FREQUENCY = 60_000_000,
    parameter integer TEN_US_COUNT = ( CLK_FREQUENCY / 100_000 )
)
(
    input wire clk,
    input wire reset,
    input wire en,

    output reg [7:0] value,
    output reg valid,

    output reg qtr_out_en,
    output reg qtr_out_sig,
    input wire qtr_in_sig

);


/*
********************************************
* Main
********************************************
*/

// Generate 10us pulses
//
reg [9:0] count_10us;
reg reset_count_10us;
reg pulse_10us;

always @ (posedge clk)
begin
    if (reset_count_10us) begin
        count_10us <= 0;
    end else begin
        pulse_10us <= 0;
        count_10us <= count_10us + 1;
        if (count_10us == TEN_US_COUNT) begin
            count_10us <= 0;
            pulse_10us <= 1;
        end
    end
end


// State Machine for QTR measurement
reg [7:0] tmp_value;

// QTR states
reg [1:0] qtr_state;
localparam IDLE         = 0;
localparam CHARGE_10US  = 1;
localparam TIME_QTR     = 2;

always @ (posedge clk)
begin
    if (reset) begin
        qtr_out_en <= 0;
        qtr_out_sig <= 0;
        valid <= 0;
        value <= 0;
        reset_count_10us <= 0;
        tmp_value <= 0;
    end else begin
        case (qtr_state)
            IDLE : begin
                qtr_out_en <= 0;
                qtr_out_sig <= 0;
                valid <= 0;
                reset_count_10us <= 1;
                if ((en == 1) && (qtr_in_sig == 0)) begin
                    qtr_state <= CHARGE_10US;
                end
            end
            CHARGE_10US : begin
                reset_count_10us <= 0;
                qtr_out_en <= 1;
                qtr_out_sig <= 1;
                if (pulse_10us) begin
                    tmp_value <= 0;
                    qtr_state <= TIME_QTR;
                end
            end
            TIME_QTR : begin
                qtr_out_en <= 0;    // switch to input
                qtr_out_sig <= 0;
                tmp_value <= tmp_value + 1;

                // Check if the sig has gone low
                // Or if our timer has maxed out (2.55ms)
                if ( (qtr_in_sig == 0) || (tmp_value==255) ) begin
                    value <= tmp_value;
                    valid <= 1;
                    qtr_state <= IDLE;
                end

            end
            default : begin
                qtr_state <= IDLE;
            end
        endcase
    end
end

endmodule
