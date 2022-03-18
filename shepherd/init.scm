(use-modules (shepherd service)
             ((ice-9 ftw) #:select (scandir)))

;; Load all the files in the directory 'init.d' with a suffix '.scm'.
(for-each
  (lambda (file)
    (load (string-append "init.d/" file)))
  (scandir (string-append (dirname (current-filename)) "/init.d")
           (lambda (file)
             (string-suffix? ".scm" file))))

;; Send shepherd into the background
(action 'shepherd 'daemonize)
;; ;; init.scm -- default shepherd configuration file.

;; ;; Use this code to load service definitions from init.d
;; (use-modules (shepherd service)
;;              ((ice-9 ftw) #:select (scandir)))
;; ;; (for-each
;; ;;   (lambda (file)
;; ;;     (load (string-append "init.d/" file)))
;; ;;   (scandir (string-append (dirname (current-filename)) "/init.d")
;; ;;            (lambda (file)
;; ;;              (string-suffix? ".scm" file))))

;; ;; Emacs Daemon
;; ;; (define emacs-daemon
;; ;;   (make <service>
;; ;;     #:provides '(emacs-daemon)
;; ;;     #:docstring "Run `emacs' as daemon"
;; ;;     #:start (make-forkexec-constructor '("emacs" "--fg-daemon"))
;; ;;     #:stop (make-kill-destructor)
;; ;;     #:respawn? #t))

;; (define kmonad
;;   (make <service>
;;     #:provides '(kmonad)
;;     #:docstring "Run kmonad"
;;     #:start (make-forkexec-constructor '("sudo" "kmonad" "~/.config/kmonad.kbd"))
;;     #:stop (make-kill-destructor)
;;     #:respawn? #t))
;; ;; Music Player Daemon
;; ;; (define mpd
;; ;;   (make <service>
;; ;;     #:provides '(mpd)
;; ;;     #:docstring "Run Music Player Daemon"
;; ;;     #:start (make-forkexec-constructor '("mpd" "--no-daemon"))
;; ;;     #:stop (make-kill-destructor)
;; ;;     #:respawn? #t))
;; (define syncthing
;;   (make <service>
;;     #:provides '(syncthing)
;;     #:docstring "Run `syncthing' without calling the browser"
;;     #:start (make-forkexec-constructor
;;               '("syncthing")
;;               #:log-file (string-append (getenv "HOME")
;;                                         "/log/syncthing.log"))
;;     #:stop (make-kill-destructor)
;;     #:respawn? #t))
;; ;; Services known to shepherd:
;; ;; Add new services (defined using 'make <service>') to shepherd here by
;; ;; providing them as arguments to 'register-services'.
;; ;; (register-services emacs-daemon mpd)
;; (register-services syncthing kmonad)

;; ;; Send shepherd into the background
;; (action 'shepherd 'daemonize)

;; ;; Services to start when shepherd starts:
;; ;; Add the name of each service that should be started to the list
;; ;; below passed to 'for-each'.
;; (for-each start '(syncthing kmonad))
;; ;; (start syncthing kmonad)
