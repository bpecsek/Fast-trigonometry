(eval-when (:compile-toplevel :load-toplevel :execute)
  (defmacro def-fast-trig (name extern-alien internal type)
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (declaim (inline ,name))
       (defun ,name (x)
	 (sb-c::alien-funcall
	  (sb-c::extern-alien ,extern-alien (function ,type (,type))) x))
       (sb-c:defknown (,name)
	   (,type) ,type (sb-c:movable sb-c:foldable sb-c:flushable))
       (sb-c::deftransform ,internal ((x) (,type) *)
	 '(,name x))))
  (def-fast-trig %sinf "sinf" sin single-float)
  (def-fast-trig %cosf "cosf" cos single-float)
  (def-fast-trig %tanf "tanf" tan single-float))

(declaim (inline sinf)
	 (ftype (function (single-float) single-float) sinf))
(defun sinf (x)
  (declare (optimize (speed 3) (safety 0) (debug 0))
	   (type single-float x))
  (%sinf x))

(defun sin-bench (n)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (time (loop repeat n for x of-type single-float
	      from 0.0 by 0.1 summing (sinf x))))

;(sin-bench 100000000)

