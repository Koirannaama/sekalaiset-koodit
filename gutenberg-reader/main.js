'use strict';

$(document).ready(function() {
  const bookFileInput = $("#book-file-input");
  const textArea = $(".text");
  const progressText = $("#book-progress");
  const storage = window.localStorage;
  let currentFileName;

  bookFileInput.on("input", () => bookFileReceived(bookFileInput.prop("files")));
  window.addEventListener("scroll", () => saveScrollState());

  function bookFileReceived(files) {
    if (files.length === 0) {
      return;
    }

    const reader = new FileReader();
    reader.readAsText(files[0], "UTF-8");
    currentFileName = files[0].name;
    reader.onloadend = () => bookFileContentRead(reader.result);
  }

  function bookFileContentRead(content) {
    const bookDOM = $.parseHTML(getBodyContentfromHTMLString(content));
    textArea.html(bookDOM);
    restoreScrollState();
  }

  function getBodyContentfromHTMLString(htmlString) {
    return /<body.*?>([\s\S]*)<\/body>/.exec(htmlString)[1];
  }

  function getCurrentProgress() {
    return $(document).scrollTop() / $(document).height();
  }

  function setBookProgress(progress) {
    const progressPercentage = Math.round(progress * 100);
    const progressMsg = `Progress: ${progressPercentage}%`;
    progressText.text(progressMsg);
  }

  function saveScrollState() {
    const scrolled = getCurrentProgress();
    storage.setItem(currentFileName, scrolled);
    setBookProgress(scrolled);
  }

  function restoreScrollState() {
    const scrolled = storage.getItem(currentFileName) * $(document).height();
    $(document).scrollTop(scrolled);
  }
});