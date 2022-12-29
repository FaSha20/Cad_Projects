`timescale 1ns/1ns
`define EOF 32'hFFFF_FFFF 

module TB ();
    
    reg [24:0] Mem [0:63];
    reg [24:0]line;
    wire [24:0]mem;
    
    reg set = 1'b1;
    wire calc;

    reg [8*11:0]inFileName = "0.in";
    reg [8*12:0]outFileName = "0.out";

    integer test, i, outFile, testCounts=3, k;

    DataPath db(line, mem, calc, set);
    Controller cu(set, calc);

    initial begin
        for (k = 0; k < testCounts ; k = k+1) begin
            $sformat(inFileName, "%0d.in", k);
            $sformat(outFileName, "%0d.out", k);
            $readmemb(inFileName,Mem);
            test = $fopen(inFileName, "r");
            outFile = $fopen(outFileName, "w");
          
            for(i = 0; i < 64; i= i+1) begin  
                line = Mem[i];
		#5 set = 1'b1;
                #5;
                $fwriteb(outFile, mem);
                $fdisplay(outFile, "");
		#5 set = 1'b0;
            end  
            $fclose(test);
            $fclose(outFile);
        end
        #1000;
        $stop;
    end

endmodule