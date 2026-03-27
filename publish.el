(package-initialize)
(require 'org)
(require 'ox)
(require 'ox-html)
(require 'ox-publish)


;; Add this to your publish.el for the languages you use
(use-package zig-mode :ensure t)
(use-package haskell-mode :ensure t)
(add-to-list 'org-src-lang-modes '("haskell" . haskell))
(setq org-export-with-smart-quotes t) ;; Not strictly necessary but helps with parsing
(setq org-html-htmlize-font-prefix "org-") ;; Ensures consistent class naming
(setq font-lock-always-fontify t)
(setq italic-annotations-face 'italic)
(global-font-lock-mode 1)

;; Crucial: htmlize needs a 'frame' to pull colors from.
;; Without this, it often exports 'white on white' or 'black on black'.
(if (not window-system)
    (setq frame-background-mode 'light))

(setq org-src-fontify-natively t) ;; Essential for Org to colorize blocks
(setf org-export-html-coding-system 'utf-8-unix)
(setf org-html-htmlize-output-type 'css)

;; Force Emacs to act like it has a 256-color display
(setq-default color-theme-is-global t)
(setq font-lock-always-fontify t)

;; 2. Initialize the "face" system (crucial for scripts)
(unless (display-graphic-p)
  (defun display-graphic-p (&optional display) t))

;; Load a built-in theme so there are actual colors to export
;; 'tango' or 'adwaita' are clean and built-in to Emacs
(load-theme 'tango t)

(setq org-html-head-extra-preamble
      "<style>
            body {
                margin: 0 auto;
                padding: 2rem 1rem;
                background: #fafafa;
                color: #444444;
                font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Helvetica, Arial, sans-serif;
                font-size: 16px;
                line-height: 1.8;
                text-shadow: 0 1px 0 #ffffff;
                max-width: 80ch;
            }
            /* Light grey background for code blocks */
            pre.src {
                background-color: #f5f5f5;
                color: #333;
                padding: 1.2em;
                border: 1px solid #e0e0e0;
                border-radius: 4px;
                overflow-x: auto;
                font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
                font-size: 0.9em;
            }
            code {
                background: #f5f5f5;
                padding: 2px 4px;
                border-radius: 3px;
            }
            /* Haskell Specific Syntax Colors */
            .org-haskell-keyword     { color: #a71d5d; font-weight: bold; } /* newtype, where, let */
            .org-haskell-type        { color: #0086b3; }                   /* SBV, SVal, Int */
            .org-haskell-constructor { color: #63a35c; font-weight: bold; } /* SBV (the constructor) */
            .org-haskell-operator    { color: #333333; }                   /* ::, =, -> */
            .org-haskell-definition  { color: #795da3; }                   /* unSBV */
            .org-doc                 { color: #969896; font-style: italic; } /* -- | comments */


            /* Essential Syntax Colors for the 'css' output type */
            .org-keyword { color: #a71d5d; font-weight: bold; }
            .org-string  { color: #183691; }
            .org-comment { color: #969896; font-style: italic; }
            .org-type    { color: #0086b3; }
            .org-function-name { color: #795da3; }
            .org-variable-name { color: #ed6a43; }

            a { border-bottom: 1px solid #444444; color: #444444; text-decoration: none; }
            a:hover { border-bottom: 0; }
        </style>")


(setf org-html-head-extra
      (concat "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
              ;; "<link rel='stylesheet' href='./css/main.css' />"
              ;; "<link rel='stylesheet' type='text/css' href='./css/code.css' />"
              org-html-head-extra-preamble
              ))

(setf org-html-home/up-format "")
(setf org-html-link-up "")
(setf org-html-link-home "")
(setf org-html-scripts "")
(setf org-html-preamble  nil)
(setf org-html-postamble t)
(setf org-html-indent nil)
(setf org-export-preserve-breaks nil)
(setf org-src-preserve-indentation nil)

(setf org-html-metadata-timestamp-format "%d %B %Y")
(setf org-export-date-timestamp-format "%d %B %Y")
(setf org-html-head-include-default-style nil)

(setq user-full-name "doyougnu")
(setq user-mail-address "jmy6342@gmail.com")

;; set the side bar
(setf org-html-metadata-timestamp-format "%d %B %Y")
(setf org-html-doctype "html5")
(setf org-export-date-timestamp-format "%d %B %Y")

(setq org-html-postamble-format
      '(("en" "<hr>
               <div class='author-info' style='text-align:center; margin-top: 2em; font-style: italic;'>
                 Written by <a href='/me.html' class='author-link'>%a</a>
                 on <span class='timestamp'>%d</span>
               </div>
               <div class='botnav' style='text-align:center; margin-top: 2em;'>
                  <a href='/index.html'>Blog</a>
                  <a href='/publications.html'>Publications</a>
                  <a href='https://github.com/doyougnu'>Github</a>
                  <a href='/me.html'>About</a>
               </div>")))

;; (defconst postamble
;;   (concat
;;    "<hr>
;;        <div class=\"botnav\" style=\"text-align:center; margin-top: 10em;\">
;;           <a href='/index.html'>Blog</a>
;;           <a href='/publications.html'>Publications</a>
;;           <a href='https://github.com/doyougnu'>Github</a>
;;           <a href='/me.html'>About</a>
;;         </div> "))

;; (setf org-html-postamble postamble)

(setq org-publish-project-alist
      `(("org-pages"
         :base-directory "./orgblog"
         :base-extension "org"
         :publishing-directory "./build"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 1
         :section-numbers nil
         :with-toc nil
         :with-author t
         :with-date t
         :time-stamp-file t
         :with-creator t)

        ("org-static"
         :base-directory "./orgblog"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "./build"
         :recursive t
         :html-head-include-default-style nil
         :publishing-function org-publish-attachment)

        ("orgblog"
         :components ("org-pages" "org-static")
         :with-drawers t
         :html-link-home "/"
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :exclude-tags ("draft")

         ;; :html-head-extra ,my-head-extra
         )))


(defun doyougnu/publish ()
  ;; t to force rebuilds
  (org-publish-all t))

(provide 'doyougnu/publish)
