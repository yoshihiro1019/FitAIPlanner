// Entry point for the build script in your package.json
import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";  // ここでTurboをインポートしているので、下の行は不要
import * as bootstrap from "bootstrap/dist/js/bootstrap";

// Initialize Rails UJS
Rails.start();

document.addEventListener("DOMContentLoaded", function() {
  console.log("JavaScript has been loaded");
  const trainingTitleSelect = document.getElementById('training_title');
  console.log("Training title element found:", trainingTitleSelect);
  const trainingDescriptionSelect = document.getElementById('training_description');
  const trainingPartsDiv = document.getElementById('training_parts');
  const setsSelect = document.getElementById('sets');
  const repsSelect = document.getElementById('reps');
  console.log("Sets and Reps elements found:", setsSelect, repsSelect);  // 確認用ログ


  // トレーニング名に応じたトレーニング内容の選択肢
  const trainingDescriptions = {
    '筋トレ': ['ウォームアップ', 'クールダウン', 'メインセット'],
    'ランニング': ['ジョギング', 'スプリント', 'インターバル'],
    'サイクリング': ['山道サイクリング', '平地サイクリング', '高速サイクリング']
  };

  // セット数と回数のオプションを定義
  const setsOptions = [1, 2, 3, 4, 5];
  const repsOptions = [5, 10, 15, 20, 25, 30];

  // 筋トレ部位の選択肢
  const trainingPartsOptions = ['胸', '背中', '脚', '肩', '腕', 'お尻', '腹筋'];

  // トレーニング名が変更されたときの処理
  trainingTitleSelect.addEventListener('change', function() {
    const selectedTitle = trainingTitleSelect.value;

    // トレーニング名に基づいてトレーニング内容を変更
    const descriptions = trainingDescriptions[selectedTitle] || [];
    trainingDescriptionSelect.innerHTML = '';

    descriptions.forEach(function(description) {
      const option = document.createElement('option');
      option.value = description;
      option.text = description;
      trainingDescriptionSelect.appendChild(option);
    });

    // 筋トレの場合は部位選択を表示、それ以外は非表示
    if (selectedTitle === '筋トレ') {
      trainingPartsDiv.style.display = 'block';
    } else {
      trainingPartsDiv.style.display = 'none';
    }
  });

  // セット数のオプションを追加
  setsOptions.forEach(function(set) {
    const option = document.createElement('option');
    option.value = set;
    option.text = set;
    setsSelect.appendChild(option);
    console.log("Added set option:", set);
  });

  // 回数のオプションを追加
  repsOptions.forEach(function(rep) {
    const option = document.createElement('option');
    option.value = rep;
    option.text = rep;
    repsSelect.appendChild(option);
    console.log("Added rep option:", rep);
  });
});
