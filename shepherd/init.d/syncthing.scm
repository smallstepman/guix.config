(define syncthing
  (make <service>
    #:provides '(syncthing)
    #:docstring "Run `syncthing' without calling the browser"
    #:start (make-forkexec-constructor
              '("syncthing" "-logflags=3" "-logfile=/home/m/State/syncthing.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services syncthing)

(start syncthing)
