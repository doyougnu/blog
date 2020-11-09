(package-initialize)
(require 'org)
(require 'ox)
(require 'ox-html)
(require 'ox-publish)

(setf org-export-html-coding-system 'utf-8-unix)
(setf org-html-htmlize-output-type 'css)
(setf org-html-head-extra
      (concat "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
              "<link rel='stylesheet' href='./css/main.css' />"
              "<link rel='stylesheet' type='text/css' href='code.css'/>"))

(setf org-html-home/up-format "")
(setf org-html-link-up "")
(setf org-html-link-home "")
(setf org-html-scripts "")
(setf org-html-preamble t)
(setf org-html-postamble nil)
(setf org-html-indent nil)
(setf org-export-preserve-breaks t)
(setf org-src-preserve-indentation nil)

(setf org-html-metadata-timestamp-format "%d %B %Y")
(setf org-export-date-timestamp-format "%d %B %Y")
(setf org-html-head-include-default-style nil)

(setq user-full-name "doyougnu")
(setq user-mail-address "youngjef@oregonstate.edu")

;; set the side bar
(setf org-html-metadata-timestamp-format "%d %B %Y")
(setf org-html-doctype "html5")
(setf org-export-date-timestamp-format "%d %B %Y")
(setf org-html-preamble (concat "<div class=\"sidenav\" class=\"status\">
    <header>
        <h1><a href='https://doyougnu.github.io/index.html' rel='author'>⊥</a></h1>
    </header>
    <ul class=\"links\">
        <li><a href='/index.html'>Blog</a></li>
        <li><a href='/me.html'>About</a></li>
        <li><a href='/publications.html'>Publications</a></li>
        <li><a href='https://github.com/doyougnu'>Github</a></li>
        <li><a href='http://groups.engr.oregonstate.edu/fpc/'>FPC</a></li>
    </ul>
    <p class='license'>Share under <a href='http://creativecommons.org/licenses/by-sa/4.0/' rel='license'>CC-BY-SA</a></p>
</div> "))

;; self host mathjax
;; (setf org-html-mathjax-options
;;       '((path "/etc/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML")
;;         (scale "100") (align "center") (indent "2em") (mathml nil)))
;; (setf org-html-mathjax-template
;;       "<script type=\"text/javascript\" src=\"%PATH\"></script>")

;; override drawers to be blocks of texts
;; (defun my-org-export-format-drawer (name content)
;;   (concat "<div class=\"drawer " (downcase name) "\">\n"
;;           "<h6>" (capitalize name) "</h6>\n"
;;           content
;;           "\n</div>"))
;; (setq org-html-format-drawer-function 'my-org-export-format-drawer)


(setq org-publish-project-alist
      `(("org-pages"
         :base-directory "~/Programming/blog/orgblog"
         :base-extension "org"
         :publishing-directory "~/Programming/blog/public_html/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 1
         :section-numbers nil
         :with-toc nil
         :with-author nil
         :with-creator nil)

        ("org-static"
         :base-directory "~/Programming/blog/orgblog"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Programming/blog/public_html/"
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
