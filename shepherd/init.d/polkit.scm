(define polkit-gnome
  (make <service>
    #:provides '(polkit-gnome)
    #:respawn? #t
    #:start (make-forkexec-constructor '("/home/m/.guix-profile/libexec/polkit-gnome-authentication-agent-1"))
    #:stop (make-kill-destructor)))

(register-services polkit-gnome)

(start polkit-gnome)
