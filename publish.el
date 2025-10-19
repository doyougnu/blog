(package-initialize)
(require 'org)
(require 'ox)
(require 'ox-html)
(require 'ox-publish)

(setf org-export-html-coding-system 'utf-8-unix)
(setf org-html-htmlize-output-type 'css)
(setf org-html-head-extra
      (concat "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
              "<link rel='stylesheet' href='./css/main.css' />"
              ;; "<link rel='stylesheet' type='text/css' href='./css/code.css' />"
              ))

(setf org-html-home/up-format "")
(setf org-html-link-up "")
(setf org-html-link-home "")
(setf org-html-scripts "")
(setf org-html-preamble  nil)
(setf org-html-postamble nil)
(setf org-html-indent nil)
(setf org-export-preserve-breaks t)
(setf org-src-preserve-indentation nil)
(setf org-src-fontify-natively nil)

(setf org-html-metadata-timestamp-format "%d %B %Y")
(setf org-export-date-timestamp-format "%d %B %Y")
(setf org-html-head-include-default-style nil)

(setq user-full-name "doyougnu")
(setq user-mail-address "jmy6342@gmail.com")

;; set the side bar
(setf org-html-metadata-timestamp-format "%d %B %Y")
(setf org-html-doctype "html5")
(setf org-export-date-timestamp-format "%d %B %Y")


(defconst postamble
  (concat
       "<hr>
        <div class=\"botnav\" class=\"status\">
          <a href='/index.html'>Blog</a>
          <a href='/publications.html'>Publications</a>
          <a href='https://github.com/doyougnu'>Github</a>
          <a href='/me.html'>About</a>
        </div> "))

(setf org-html-postamble postamble)


(setq org-publish-project-alist
      `(("org-pages"
         :base-directory "./orgblog"
         :base-extension "org"
         :publishing-directory "./build"
         :recursive t
         :publishing-function org-html-publish-to-html
         ;; :html-preamble preamble
         :headline-levels 1
         :section-numbers nil
         :with-toc nil
         :with-author nil
         :with-creator nil)

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
