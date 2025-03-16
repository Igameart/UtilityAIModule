
var dir = [mouse_x-x,mouse_y-y];
var dis = point_distance(x, y, mouse_x,mouse_y);
x+=dir[0]/dis;
y+=dir[1]/dis;