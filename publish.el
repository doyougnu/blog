;; --- publish.el ---
(require 'package)
(setq package-user-dir (expand-file-name ".packages" (file-name-directory load-file-name)))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/") t)
(package-initialize)

;; Install missing packages on first run
(unless package-archive-contents
  (package-refresh-contents))
(dolist (pkg '(htmlize zig-mode haskell-mode ox-rss))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(require 'htmlize)
(require 'zig-mode)
(require 'haskell-mode)
(require 'org)
(require 'ox)
(require 'ox-html)
(require 'ox-rss)
(require 'ox-publish)

;; Force color for headless export
(setq-default frame-background-mode 'light)
(load-theme 'tango t)

(add-to-list 'org-src-lang-modes '("haskell" . haskell))
(setq org-export-with-smart-quotes t)
(setq org-html-htmlize-font-prefix "org-")
(setq font-lock-always-fontify t)
(setq italic-annotations-face 'italic)
(global-font-lock-mode 1)

(if (not window-system)
    (setq frame-background-mode 'light))

(setq org-src-fontify-natively t)
(setf org-export-html-coding-system 'utf-8-unix)
(setf org-html-htmlize-output-type 'css)

(setq-default color-theme-is-global t)
(setq font-lock-always-fontify t)

(unless (display-graphic-p)
  (defun display-graphic-p (&optional display) t))

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
                max-width: 80ch;
            }
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
            .org-haskell-keyword     { color: #a71d5d; font-weight: bold; }
            .org-haskell-type        { color: #0086b3; }
            .org-haskell-constructor { color: #63a35c; font-weight: bold; }
            .org-haskell-operator    { color: #333333; }
            .org-haskell-definition  { color: #795da3; }
            .org-doc                 { color: #969896; font-style: italic; }

            .org-keyword { color: #a71d5d; font-weight: bold; }
            .org-string  { color: #183691; }
            .org-comment { color: #969896; font-style: italic; }
            .org-type    { color: #0086b3; }
            .org-function-name { color: #795da3; }
            .org-variable-name { color: #ed6a43; }

           /* RSS Subscription Link Styling */
           .rss-link {
               display: inline-flex;
               align-items: center;
               font-size: 0.9em;
               color: #555;
               border-bottom: 1px dashed #f26522 !important; /* Subtle orange dash */
               padding-bottom: 2px;
               text-decoration: none;
           }
           .rss-link:hover {
               color: #f26522;
               border-bottom: 1px solid #f26522 !important;
           }

            /* Tag Layout Styles */
            .post-tags { margin-bottom: 1em; }
            .tag {
                display: inline-block;
                background: #f0f0f0;
                color: #555;
                font-size: 0.75em;
                font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
                padding: 1px 6px;
                border-radius: 3px;
                margin-left: 4px;
                vertical-align: middle;
            }
            a { border-bottom: 1px solid #444444; color: #444444; text-decoration: none; }
            a:hover { border-bottom: 0; }
        </style>")

(setf org-html-head-extra
      (concat "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
              org-html-head-extra-preamble))

(setf org-html-home/up-format "")
(setf org-html-link-up "")
(setf org-html-link-home "")
(setf org-html-scripts "")
(setf org-html-postamble t)
(setf org-html-indent nil)
(setf org-export-preserve-breaks nil)
(setf org-src-preserve-indentation nil)
(setf org-html-head-include-default-style nil)
(setf org-html-doctype "html5")

(setf org-html-metadata-timestamp-format "%d %B %Y")
(setf org-export-date-timestamp-format "%d %B %Y")

(setq user-full-name "doyougnu")
(setq user-mail-address "jmy6342@gmail.com")

;;; ---------------------------------------------------------------------------
;;; Front-Matter / Header adjustments (Injecting tags into individual pages)
;;; ---------------------------------------------------------------------------

(defun doyougnu/post-preamble (info)
  "Insert post title, date, and filetags as a header above the content."
  (let* ((tags (plist-get info :filetags))
         (tag-list (when tags
                     ;; Ensures clean parsing whether format is :tag1:tag2: or tag1 tag2
                     (split-string (replace-regexp-in-string ":" " " (mapconcat #'identity tags " ")) " " t))))
    (if tag-list
        (concat "<div class='post-tags'>Tags: "
                (mapconcat
                 (lambda (tag)
                   (format "<a href='../tags/index.html#%s' class='tag'>%s</a>" tag tag))
                 tag-list " ")
                "</div>")
      "")))

(setf org-html-preamble #'doyougnu/post-preamble)

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
                  <a href='rss.xml'>RSS</a>
               </div>")))

;;; ---------------------------------------------------------------------------
;;; Hardened Tag index generation
;;; ---------------------------------------------------------------------------

(defun doyougnu/generate-tag-index ()
  "Scan orgblog/ for #+FILETAGS and write orgblog/tags/index.org, skipping drafts."
  (message "DEBUG: Starting tag index generation...")
  (let ((tag-map (make-hash-table :test 'equal))
        (posts-dir (expand-file-name "./orgblog")))

    (make-directory (concat posts-dir "/tags") t)

    (dolist (file (directory-files-recursively posts-dir "\\.org$"))
      ;; Strict exclusion so we don't scan our own generated files
      (unless (or (string-match-p "/tags/" file)
                  (string-match-p "rss\\.org$" file))
        (with-temp-buffer
          (insert-file-contents file)
          (let (title filetags-str tags)
            (setq title (file-name-base file))

            ;; 1. Extract Title
            (goto-char (point-min))
            (while (re-search-forward "^#\\+TITLE:\\s-*\\(.*\\)$" nil t)
              (setq title (match-string 1)))

            ;; 2. Extract Tags
            (goto-char (point-min))
            (while (re-search-forward "^#\\+FILETAGS:\\s-*\\(.*\\)$" nil t)
              (setq filetags-str (match-string 1)))

            (when filetags-str
              (setq tags (split-string (replace-regexp-in-string ":" " " filetags-str) " " t))

              ;; CRITICAL FIX: Skip this entire file if it contains the "draft" tag
              (unless (member "draft" tags)
                (message "DEBUG: Found production tags %s in %s" tags title)
                (dolist (tag tags)
                  (let ((rel-path (concat "../" (file-relative-name file posts-dir))))
                    (push (cons title rel-path) (gethash tag tag-map))))))))))

    ;; Write the index.org file
    (let ((index-file (concat posts-dir "/tags/index.org")))
      (with-temp-file index-file
        (insert "#+TITLE: Posts by tag\n")
        (insert "#+OPTIONS: toc:nil num:nil\n\n")
        (if (= (hash-table-count tag-map) 0)
            (insert "No tagged posts found.\n")
          (let ((sorted-tags (sort (hash-table-keys tag-map) #'string<)))
            (dolist (tag sorted-tags)
              (insert (format "* %s\n:PROPERTIES:\n:CUSTOM_ID: %s\n:END:\n\n" tag tag))
              (dolist (post (gethash tag tag-map))
                (insert (format "- [[file:%s][%s]]\n" (cdr post) (car post))))
              (insert "\n")))))
      (message "DEBUG: Wrote tag index to %s" index-file))))

;;; ---------------------------------------------------------------------------
;;; Publish projects
;;; ---------------------------------------------------------------------------

(setq org-publish-project-alist
      `(("org-pages"
         :base-directory "./orgblog"
         :base-extension "org"
         :publishing-directory "./build"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :section-numbers nil
         :with-toc nil
         :with-author t
         :with-date t
         :with-tags t
         :time-stamp-file t
         :with-creator t
         :exclude "rss\\.org") ; Let it compile tags/index.org naturally

        ("org-rss"
         :base-directory "./orgblog"
         :base-extension "org"
         :publishing-directory "./build"
         :publishing-function org-rss-publish-to-rss
         :html-link-home "https://doyougnu.github.io/"
         :html-link-use-abs-url t
         :rss-feed-url "https://doyougnu.github.io/feed.xml"
         :section-numbers nil
         :with-toc nil
         :with-author t
         :include ("rss.org")
         :exclude ".")

        ("org-static"
         :base-directory "./orgblog"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "./build"
         :recursive t
         :html-head-include-default-style nil
         :publishing-function org-publish-attachment)

        ("orgblog"
         :components ("org-pages" "org-rss" "org-static"))))


(defun doyougnu/publish ()
  (interactive)
  ;; 1. Generate tag structural files
  (doyougnu/generate-tag-index)
  ;; 2. Clear publish cache to guarantee generation of dynamically injected indices
  (org-publish-remove-all-timestamps)
  ;; 3. Publish with forced re-evaluation
  (org-publish-all t))

(provide 'doyougnu/publish)
