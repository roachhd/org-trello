;;; orgtrello-tests.el

(require 'orgtrello)

(ert-deftest testing-orgtrello--compute-list-key ()
  (should (equal (orgtrello--compute-list-key *TODO*)        *TODO-LIST-ID*))
  (should (equal (orgtrello--compute-list-key *DONE*)        *DONE-LIST-ID*))
  (should (equal (orgtrello--compute-list-key "otherwise")   *DOING-LIST-ID*))
  (should (equal (orgtrello--compute-list-key "IN PROGRESS") *DOING-LIST-ID*)))

(ert-deftest testing-orgtrello--merge-map ()
  (let* ((entry   (orgtrello-hash--make-hash-org :level :method "the name of the entry" nil :pt))
         (map-ids (make-hash-table :test 'equal)))
    (puthash "the name of the entry" :some-id map-ids)
    (should (equal (gethash :id (orgtrello--merge-map entry map-ids)) :some-id))))

(ert-deftest testing-orgtrello--merge-map2 ()
  (let* ((entry   (orgtrello-hash--make-hash-org :level :method :title :id-already-there :pt))
         (map-ids (make-hash-table :test 'equal)))
    (puthash :title :some-id map-ids)
    (should (equal (gethash :id (orgtrello--merge-map entry map-ids)) :id-already-there))))

(ert-deftest testing-orgtrello--merge-map3 ()
  (let* ((entry   (orgtrello-hash--make-hash-org :level :method :title :id-already-there :point))
         (map-ids (make-hash-table :test 'equal)))
    (should (equal (gethash :id (orgtrello--merge-map entry map-ids)) :id-already-there))))

(ert-deftest testing-orgtrello--id-name ()
  (let* ((entities [((id . "id")
                     (shortUrl . "https://trello.com/b/ePrdEnzC")
                     (url . "https://trello.com/board/devops/4f96a984dbb00d733b04d8b5") (name . "testing board"))
                    ((id . "another-id")
                     f(shortUrl . "https://trello.com/b/ePrdEnzC")
                     (url . "https://trello.com/board/devops/4f96a984dbb00d733b04d8b5")
                     (name . "testing board 2"))
                    ((id . "yet-another-id")
                     (shortUrl . "https://trello.com/b/ePrdEnzC")
                     (url . "https://trello.com/board/devops/4f96a984dbb00d733b04d8b5")
                     (name . "testing board 3"))])
         (hashtable-result (orgtrello--id-name entities))
         (hashtable-expected (make-hash-table :test 'equal)))
    (puthash "id" "testing board" hashtable-expected)
    (puthash "another-id" "testing board 2" hashtable-expected)
    (puthash "yet-another-id" "testing board 3" hashtable-expected)
    (should (equal (gethash "id" hashtable-result) (gethash "id" hashtable-expected)))
    (should (equal (gethash "another-id" hashtable-result) (gethash "another-id" hashtable-expected)))
    (should (equal (gethash "yet-another-id" hashtable-result) (gethash "yet-another-id" hashtable-expected)))
    (should (equal (length (values hashtable-result)) (length (values hashtable-expected))))))

(ert-deftest testing-orgtrello--name-id ()
  (let* ((entities [((id . "id")
                     (shortUrl . "https://trello.com/b/ePrdEnzC")
                     (name . "testing board"))
                    ((id . "another-id")
                     f(shortUrl . "https://trello.com/b/ePrdEnzC")
                     (name . "testing board 2"))
                    ((id . "yet-another-id")
                     (shortUrl . "https://trello.com/b/ePrdEnzC")
                     (name . "testing board 3"))])
         (hashtable-result (orgtrello--name-id entities))
         (hashtable-expected (make-hash-table :test 'equal)))
    (puthash "testing board" "id" hashtable-expected)
    (puthash "testing board 2" "another-id"  hashtable-expected)
    (puthash "testing board 3" "yet-another-id"  hashtable-expected)
    (should (equal (gethash "testing board" hashtable-result) (gethash "testing board" hashtable-expected)))
    (should (equal (gethash "testing board 2" hashtable-result) (gethash "testing board 2" hashtable-expected)))
    (should (equal (gethash "testing board 3" hashtable-result) (gethash "testing board 3" hashtable-expected)))
    (should (equal (length (values hashtable-result)) (length (values hashtable-expected))))))

(provide 'orgtrello-tests)

;;; orgtrello-tests.el ends here
