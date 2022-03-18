(define kmonad
  (make <service>
    #:provides '(kmonad)
    #:docstring "Run kmonad"
    #:start (make-forkexec-constructor '("pkexec" "kmonad" "/home/m/.config/kmonad/kmonad.kbd"))
    #:stop (make-kill-destructor)
    #:respawn? #f))

(register-services kmonad)

(start kmonad)
