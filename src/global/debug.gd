extends Node

func print(params: Array) -> void:
	if not OS.is_debug_build():
		return

	var stack = get_stack()
	if stack.size() > 1:
		stack = stack[1]
	else:
		stack = ["UNKNOWN", "0", "_"]

	print(
		"[DEBUG] (%s:%s %s) : %s" % [
			stack["source"],
			str(stack["line"]),
			stack["function"],
			params,
		]
	)
