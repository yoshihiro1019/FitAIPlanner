// Entry point for the build script in your package.json
import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import * as bootstrap from "bootstrap/dist/js/bootstrap";

Rails.start();

document.addEventListener("turbo:load", () => {
  const trainingTitleSelect = document.getElementById('training_title');
  
  // トレーニング編集ページでのみフォーム初期化を行う
  if (trainingTitleSelect) {
    initializeTrainingForm();
  }
});

function initializeTrainingForm() {
  const trainingTitleSelect = document.getElementById('training_title');
  const trainingDescriptionSelect = document.getElementById('training_description');
  const trainingPartsDiv = document.getElementById('training_parts');
  const setsSelect = document.getElementById('sets');
  const repsSelect = document.getElementById('reps');

  if (!trainingTitleSelect || !trainingDescriptionSelect || !trainingPartsDiv || !setsSelect || !repsSelect) {
    console.error('Some form elements are missing.');
    return;
  }

  // デフォルトのトレーニング内容
  const trainingDescriptions = {
    '筋トレ': ['ウォームアップ', 'クールダウン', 'メインセット'],
    'ランニング': ['ジョギング', 'スプリント', 'インターバル'],
    'サイクリング': ['山道サイクリング', '平地サイクリング', '高速サイクリング']
  };

  // セット数と回数のオプション
  const setsOptions = [];
  const repsOptions = [];

  //setsSelect.innerHTML = '';
  //repsSelect.innerHTML = '';

  // セット数オプションを追加
  setsOptions.forEach(set => {
    const option = document.createElement('option');
    option.value = set;
    option.text = set;
    setsSelect.appendChild(option);
  });

  // 回数オプションを追加
  repsOptions.forEach(rep => {
    const option = document.createElement('option');
    option.value = rep;
    option.text = rep;
    repsSelect.appendChild(option);
  });

  // ページロード時にトレーニング名に基づいてフォーム内容を更新
  if (trainingTitleSelect.value) {
    updateFormForSelectedTitle();
  }

  trainingTitleSelect.addEventListener('change', updateFormForSelectedTitle);

  function updateFormForSelectedTitle() {
    const selectedTitle = trainingTitleSelect.value;
    const currentDescription = trainingDescriptionSelect.value;
    const descriptions = trainingDescriptions[selectedTitle] || [];
    trainingDescriptionSelect.innerHTML = '';
    descriptions.forEach(description => {
      const option = document.createElement('option');
      option.value = description;
      option.text = description;
      trainingDescriptionSelect.appendChild(option);
    });

    if (descriptions.includes(currentDescription)) {
      trainingDescriptionSelect.value = currentDescription;
    }

    // 筋トレ部位の表示制御
    if (selectedTitle === '筋トレ') {
      trainingPartsDiv.style.display = 'block';
    } else {
      trainingPartsDiv.style.display = 'none';
    }
  }
  

  // セット数と回数のオプションを追加
  //setsSelect.innerHTML = '';
  //repsSelect.innerHTML = '';

  setsOptions.forEach(function(set) {
    const option = document.createElement('option');
    option.value = set;
    option.text = set;
    setsSelect.appendChild(option);
  });

  repsOptions.forEach(function(rep) {
    const option = document.createElement('option');
    option.value = rep;
    option.text = rep;
    repsSelect.appendChild(option);
  });

  // ページ初期化時に現在のトレーニング名に基づいてフォームの内容を設定
  updateFormForSelectedTitle();

  // トレーニング名が変更されたときの処理
  trainingTitleSelect.addEventListener('change', updateFormForSelectedTitle);
}
