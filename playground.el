
(defun get-string-from-file (file-name)
  (with-temp-buffer (insert-file file-name)
                    (buffer-string)))

(start-process "PythonYouTubeQuery" "*YOUTUBE*" "python3")
(process-send-string "PythonYouTubeQuery" "\n")
(with-temp-buffer
  (list :exit-status
        (call-process-async "PythonYouTubeQuery" nil t nil (get-string-from-file "~/dev/yt-emacs/init.py"))
        :output
        (buffer-string)))

(defun get-pycommand (query nvideos)
    (format "python3 /Users/arielserranoni/dev/yt-emacs/init.py %s %d" query nvideos))

(defvar str
    (shell-command-to-string
     (get-pycommand  "nada" 10)))

(require 'json)


(defvar obj (json-parse-string str :object-type 'alist))

(defvar clean (cdr (assoc 'result obj)))


(defun get-titles (lista)
  (mapcar (lambda (x) (cdr (assoc 'title x))) lista))

(defun get-links (lista) (mapcar (lambda (x) (cdr (assoc 'link x))) lista))

(mpv-play-url (nth 1 links))

(ivy-read "Select Video: " titles :action 'play)

(defvar sample-title (nth 5 titles))

(defun play (str)
  (mpv-play-url (get-url-by-title clean str)))

(defun get-url-by-title (plist title)
  "Retrieve the URL corresponding to TITLE from PLIST."
  (let ((titles (get-titles plist))
        (urls (get-links plist)))
    (if (and titles urls)
        (let ((index (cl-position title titles :test 'equal)))
          (if index
              (nth index urls)
            (error "Title not found")))
      (error "Plist doesn't contain titles and urls"))))

(get-url-by-title clean sample-title)






(with-temp-buffer
 (insert str)
 (goto-char (point-min))
 (json-read-object))

(defvar js (json-parse-string str))

