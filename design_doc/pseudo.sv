// Decide if we need to WB or not.  This is in checking state
if(hit == 1'b1)
begin
    next_state = DEFAULT;
end
else if(v_array_0_dataout == 1'b0 || v_array_1_dataout == 1'b0 || v_array_2_dataout == 1'b0 || v_array_3_dataout == 1'b0)
begin
    next_state = NO_WB_1;
end
else 
begin
    if(LRU_array_dataout[2] == 1'b0)
    begin
        if(LRU_array_dataout[0] == 1'b0)
        begin
            if(d_array_3_dataout == 1'b0)
                next_state = NO_WB_1;
            else
                next_state = WRITE_BACK;
        end
        else
        begin
            if(d_array_2_dataout == 1'b0)
                next_state = NO_WB_1;
            else
                next_state = WRITE_BACK;
        end
    end
    else
    begin
        if(LRU_array_dataout[1] == 1'b0)
        begin
            if(d_array_1_dataout == 1'b0)
                next_state = NO_WB_1;
            else
                next_state = WRITE_BACK;
        end
        else
        begin
            if(d_array_0_dataout == 1'b0)
                next_state = NO_WB_1;
            else
                next_state = WRITE_BACK;
        end  
    end
end

// At WRITE_BACK state, just look at LRU to decide which way to write back 
// since we already know (no free cacheline) + (LRU is dirty)
// load valid_way_3 to 0, load dirty_way_3 to 0
if(LRU_array_dataout[2] == 1'b0)
begin
    if(LRU_array_dataout[0] == 1'b0)
    begin
        // writing way 3 data back
    end
    else
    begin
        // writing way 2 data back
    end
end
else
begin
    if(LRU_array_dataout[1] == 1'b0)
    begin
        // writing way 1 data back
    end
    else
    begin
        // writing way 0 data back
    end  
end


// At NO_WB_2, decide which way to allocate.

if(v_array_0_dataout == 1'b0)
begin
    // Alloc way 0
end
else if(v_array_1_dataout == 1'b0)
begin
    // Alloc way 1
end
else if(v_array_2_dataout == 1'b0)
begin
    // Alloc way 2
end
else if(v_array_3_dataout == 1'b0)
begin
    // Alloc way 3
end
else 
begin
    if(LRU_array_dataout[2] == 1'b0)
    begin
        if(LRU_array_dataout[0] == 1'b0)
        begin
            // Alloc way 3
        end
        else
        begin
            // Alloc way 2
        end
    end
    else
    begin
        if(LRU_array_dataout[1] == 1'b0)
        begin
            // Alloc way 1
        end
        else
        begin
            // Alloc way 0
        end  
    end
end


// Update LRU array when there is a hit.
if(way_0_hit)
begin
    LRU_array_datain[2:0] = {1'b0, 1'b0, LRU_array_dataout[0]};
end
else if(way_1_hit)
begin
    LRU_array_datain[2:0] = {1'b0, 1'b1, LRU_array_dataout[0]};
end
else if(way_2_hit)
begin
    LRU_array_datain[2:0] = {1'b1, LRU_array_dataout[1], 1'b0};
end
else if(way_3_hit)
begin
    LRU_array_datain[2:0] = {1'b1, LRU_array_dataout[1], 1'b1};
end

 