;;; yt-emacs.el --- playing youtube videos from the confort of home  -*- lexical-binding: t; -*-

;; Copyright (C) 2023 by Ariel Serranoni

;; Author: Ariel Serranoni <arielserranoni@gmail.com>
;; URL: http://github.com/aserranoni/yt-emacs
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1"))
;; Keywords: convenience

;;; Commentary:

;; This package provides a simple function to search and play youtube videos using emacs

;;; Code:

(require 'mpv)
(require 'json)

(defgroup yt-emacs nil
  "Customization group for 'yt-emacs'."
  :prefix "yt-emacs-"
  :group 'convenience)

(defcustom yt-emacs-python-searcher-location "/Users/arielserranoni/dev/yt-emacs/init.py"
  "Directory path for the python searcher program."
  :type 'string
  :group 'yt-emacs)

(defcustom yt-emacs-default-video-amount 10
  "Number of results for video searches."
  :type 'integer
  :group 'yt-emacs)


(defun yt-emacs-get-python-command (query nvideos)
  "Describe what this function does."
(format "python3 %s %s %d" yt-emacs-python-searcher-location query nvideos))


(defun yt-emacs-search-and-parse-results (query nvideos)
(cdr
 (assoc 'result
        (json-parse-string
         (shell-command-to-string
          (yt-emacs-get-python-command query nvideos))
         :object-type 'alist)))
  )

(defun yt-emacs-get-links (lista) (mapcar (lambda (x) (cdr (assoc 'link x))) lista))


(defun yt-emacs-get-url-by-title (plist title)
  "Retrieve the URL corresponding to TITLE from PLIST."
  (let ((titles (yt-emacs-get-titles plist))
        (urls (yt-emacs-get-links plist)))
    (if (and titles urls)
        (let ((index (cl-position title titles :test 'equal)))
          (if index
              (nth index urls)
            (error "Title not found")))
      (error "Plist doesn't contain titles and urls"))))


(defun yt-emacs-get-titles (lista)
  (mapcar (lambda (x) (cdr (assoc 'title x))) lista))


;;;###autoload
(defun yt-emacs-search-and-play ()
  "Search videos on youtube and play selected result."
  (interactive)
  (let* (
         (query (read-string "Input your query: "))
         (results (yt-emacs-search-and-parse-results query yt-emacs-default-video-amount))
         (titles (yt-emacs-get-titles results))
         (title (ivy-read "Select a video: " titles))
         (url (yt-emacs-get-url-by-title results title))
         )
    (mpv-play-url url)
    ))

(provide 'yt-emacs)
;;; yt-emacs.el ends here
