function marked_ims = mark_images(oct_ims,marks)
marked_ims = {};

for i = 1:length(oct_ims)
    im = oct_ims{i};
    if (~isempty(marks(i).bruch_op))
        im = insertMarker(im,marks(i).bruch_op,'x','Color','red');
    end
    if (~isempty(marks(i).bruch_mem_left))
        im = insertMarker(im,marks(i).bruch_mem_left,'*','Color','blue');
    end
    if (~isempty(marks(i).bruch_mem_right))
        im = insertMarker(im,marks(i).bruch_mem_right,'*','Color','blue');
    end
    if (~isempty(marks(i).ant_lam_lim))
    im = insertMarker(im,marks(i).ant_lam_lim,'*','Color','magenta');
    end
    if (~isempty(marks(i).chor_scl_left))
    im = insertMarker(im,marks(i).chor_scl_left,'*','Color','green');
    end
    if (~isempty(marks(i).chor_scl_right))
    im = insertMarker(im,marks(i).chor_scl_right,'*','Color','green');
    end
    marked_ims{i} = im;
end

end

