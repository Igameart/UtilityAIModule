function trace() {
	var str = "-- ";
	var num = 0;

	repeat argument_count{
		var arg = argument[num];
		//if is_real(arg) || is_string(arg){
			str += string( arg );
			if argument_count>num str+=" - ";
		//}
		num++;
	}

	show_debug_message(str);
	//wjs_devconsole_output_message(str,c_aqua);

}

function copy_array(array){
	var _new = array_create(0);
	array_copy(_new,0,array,0,array_length(array));
	return _new;
}