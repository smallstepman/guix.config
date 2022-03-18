;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
  (gnu)
  (nongnu packages linux)
  (nongnu packages nvidia)
  (gnu packages xorg)
  (nongnu system linux-initrd)
  (guix transformations)
  (gnu packages gnome)
  (guix packages)
  (guix download)
  (gnu services sound)
  (gnu packages haskell-apps)
  (gnu packages shells))

(use-service-modules
  cups
  desktop
  docker
  linux
  networking
  security-token ; pcscd
  nix
  ssh
  virtualization
  xorg)

(use-package-modules package-management)

(define transform
  (options->transformation
   '((with-graft . "mesa=nvda"))))
(define transform1
  (options->transformation
    '((with-source
        .
        "xdg-desktop-portal-gtk=https://github.com/flatpak/xdg-desktop-portal-gtk/releases/download/1.8.0/xdg-desktop-portal-gtk-1.8.0.tar.xz"))))
(define transform5
  (options->transformation
    '((with-source
        .
        "https://github.com/flatpak/flatpak/releases/download/1.11.2/flatpak-1.11.2.tar.xz"))))

;; TODO make these git version
(define %steam-input-udev-rules
  (file->udev-rule
    "60-steam-input.rules"
    (let ((version "8a3f1a0e2d208b670aafd5d65e216c71f75f1684"))
      (origin
       (method url-fetch)
       (uri (string-append "https://raw.githubusercontent.com/ValveSoftware/"
                           "steam-devices/" version "/60-steam-input.rules"))
       (sha256
        (base32 "1k6sa9y6qb9vh7qsgvpgfza55ilcsvhvmli60yfz0mlks8skcd1f"))))))

;; Allow members of the "video" group to change the screen brightness.
(define %backlight-udev-rule
  (udev-rule
   "90-backlight.rules"
   (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/%k/brightness\""
                  "\n"
                  "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/%k/brightness\"")))

(define %my-desktop-services
  (modify-services %desktop-services
                   (delete gdm-service-type)
                   ;; Set the default sample rate for the pulseaudio daemon to be
                   ;; 48000; needed for the Valve Index mic, see
                   ;; https://github.com/ValveSoftware/SteamVR-for-Linux/issues/215#issuecomment-526791835
                   (pulseaudio-service-type config =>
                                            (pulseaudio-configuration
                                            (daemon-conf '((default-sample-rate . 48000)))))

                   (elogind-service-type config =>
                                         (elogind-configuration (inherit config)
                                                                (handle-lid-switch-external-power 'suspend)))
                   (udev-service-type config =>
                           (udev-configuration (inherit config)
                           (rules (cons kmonad
                                       (udev-configuration-rules config)))))
                   (udev-service-type config =>
                                      (udev-configuration (inherit config)
                                                          (rules (cons %backlight-udev-rule
                                                                       (udev-configuration-rules config)))))
                   (network-manager-service-type config =>
                                                 (network-manager-configuration (inherit config)
                                                                                (vpn-plugins (list network-manager-openvpn))))))

(define %xorg-config
    "
    Section \"ServerFlags\"
        Option \"IgnoreABI\" \"1\"
    EndSection


    Section \"InputClass\"
        Identifier \"Touchpads\"
        Driver \"libinput\"
        MatchDevicePath \"/dev/input/event*\"
        MatchIsTouchpad \"on\"

        Option \"Tapping\" \"on\"
        Option \"TappingDrag\" \"on\"
        Option \"DisableWhileTyping\" \"on\"
        Option \"MiddleEmulation\" \"on\"
        Option \"ScrollMethod\" \"twofinger\"
    EndSection

    Section \"InputClass\"
        Identifier \"Keyboards\"
        Driver \"libinput\"
        MatchDevicePath \"/dev/input/event*\"
        MatchIsKeyboard \"on\"
    EndSection
")

(operating-system
  (kernel linux-lts)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (kernel-arguments
   (append '("modprobe.blacklist=nouveau")
           %default-kernel-arguments))
  (kernel-loadable-modules (list nvidia-driver))
  (locale "en_US.utf8")
  (timezone "Europe/Warsaw")
  (keyboard-layout
    (keyboard-layout "pl" "colemak"))
  (host-name "jimi")
  (users (cons* (user-account
                  (name "m")
                  (comment "Marcin")
                  (group "users")
                  (home-directory "/home/m")
                  (shell (file-append zsh "/bin/zsh")) 
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video" "docker" "kvm" "lp")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "i3-wm")
             (transform1
          (specification->package "xdg-desktop-portal-gtk"))
                     (transform5 (specification->package "flatpak"))

            (specification->package "i3status")
            (specification->package "dmenu")
            (specification->package "git")
            (specification->package "ripgrep")
            (specification->package "fd")
            (specification->package "exa")
            (specification->package "nix")
            (specification->package "st")
            (specification->package "emacs")
            (specification->package "steam-nvidia")
            (specification->package "emacs-guix")
            (specification->package "emacs-exwm")
            (specification->package
              "emacs-desktop-environment")
            (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list
       ;;(service gnome-desktop-service-type)
            (pam-limits-service
                (list
                    ;; higher open file limit, helpful for Wine and esync
                    (pam-limits-entry "*" 'both 'nofile 524288)
                    ;; lower nice limit for users, but root can go further to rescue system
                    (pam-limits-entry "*" 'both 'nice -19)
                    (pam-limits-entry "root" 'both 'nice -20)))
            (service pcscd-service-type)
            (udev-rules-service 'steam-input %steam-input-udev-rules)
            (simple-service
              'custom-udev-rules udev-service-type
              (list nvidia-driver))
            (service kernel-module-loader-service-type
             '("ipmi_devintf"
               "nvidia"
               "nvidia_modeset"
               ; "nvidia-drm"
               "nvidia_uvm"))
            (service openssh-service-type)
            (service docker-service-type)
            (service tor-service-type)
            (service cups-service-type)
            (service slim-service-type
                (slim-configuration
                  (display ":1")
                  (vt "vt7")
                  (xorg-configuration (xorg-configuration
                    (keyboard-layout keyboard-layout)
                    (modules (cons* nvidia-driver %default-xorg-modules))
                    (server (transform xorg-server))
                    (drivers '("nvidia" "modesetting"))
                   (extra-config (list %xorg-config ))
                    ))))
            (service nix-service-type)
            (service libvirt-service-type
              (libvirt-configuration
                (unix-sock-group "libvirt")
                (tls-port "16555")))
           (bluetooth-service #:auto-enable? #t))
      %my-desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "3c5856e1-58dc-4f3a-b9d7-899053392f66")))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "053b59e9-8bad-4ea2-9043-f13ef815fa9c"))
            (target "crypthome")
            (type luks-device-mapping))
          (mapped-device
            (source
              (uuid "38fba3f8-7406-47e0-ba97-b759463419e9"))
            (target "cryptroot")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/home")
             (device "/dev/mapper/crypthome")
             (type "ext4")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "D16D-0E1D" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "ext4")
             (dependencies mapped-devices))
           %base-file-systems)))
