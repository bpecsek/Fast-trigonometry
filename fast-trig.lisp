(eval-when (:compile-toplevel :load-toplevel :execute)
  (defmacro def-fast-trig (name extern-alien internal type)
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (declaim (inline ,name))
       (defun ,name (x)
	 (sb-kernel::alien-funcall
	  (sb-kernel::extern-alien ,extern-alien (function ,type (,type))) x))
       (sb-c:defknown (,name)
	   (,type) ,type (sb-c:movable sb-c:foldable sb-c:flushable))
       (sb-c::deftransform ,internal ((x) (,type) *)
	 '(,name x))))
  (def-fast-trig %sinf "sin" sin single-float)
  ;(def-fast-trig %sinf "sinf" sin single-float)
  (def-fast-trig %sind "sin" sin double-float)
  (def-fast-trig %cosf "cos" cos single-float)
  (def-fast-trig %cosd "cos" cos double-float)
  (def-fast-trig %tanf "tan" tan single-float)
  (def-fast-trig %tand "tan" tan double-float))

(defun sin-bench (n)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (time (loop repeat n for x of-type single-float
	      from 0.0 by 0.1 summing (sin x))))

;(sin-bench 100000000)

