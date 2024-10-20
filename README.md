# 🛒 개인프로젝트 - 캐글 커머스 데이터 분석 
## 프로젝트 진행과정 (#코호트 분석 #RFM 분석 #고객생애가치 #상품연관분석)

<img width="853" alt="스크린샷 2024-10-20 오후 8 30 35" src="https://github.com/user-attachments/assets/b0774edf-cb7b-452a-be5c-3d21e768d5bf">

<br>

## 🎁 활용 데이터
- [**SuperStore Sales Profit Discount Prediction**](https://www.kaggle.com/code/danishmubashar/superstore-sales-profit-discount-predict/input)
    - 이 데이터셋은 SuperStore의 판매, 이윤, 할인 정보를 포함하고 있으며, 이를 통해 다양한 판매 및 할인 전략을 예측할 수 있음

## 🔎 배경
- **온라인 커머스 기업의 데이터 분석가로 해당 서비스의 데이터를 분석한다고 가정**
<br>

## 📌 문제 정의
  - **효율적 마케팅 전략 필요성** : 비용 절감을 위해 타겟팅된 마케팅 필요
  - **추가 매출 기회 발굴 필요성** : 자주 함께 구매되는 제품 분석을 통해 크로스셀링 기회를 찾아 매출 증대 전략 수립 필요
<br>

## ⛳ 목표
  - **고객 그룹별 마케팅 전략 수립** : 고객 세분화를 통한 대응 체계 구축
  - **크로스셀링 전략 수립** : 자주 함께 구매되는 제품을 기반으로 추가 매출 전략 설계
<br> 

## 👨‍💻 수행 역할
  - **데이터 분석**
      - SQL, Python 활용 데이터 전처리, 분석, 시각화
      - RFM 분석, 이진분류 모델 구축을 통한 고객 가치 평가
      - 상품연관 분석을 통한 크로스셀링 제품 발굴
  - **마케팅 전략 수립**
      - 고객 그룹 및 제품에 따른 마케팅 전략 수립
<br>  

## 🏆 주요 성과
  - **동질집단 분석**
      - <mark>**코호트 분석** : 3개월 단위 당 평균 34.9% 수준으로 구매율이 유지됨</mark>
  - **고객 세분화**
      - <mark>**RFM 분석** : 고객을 16개 그룹으로 세분화</mark>
      - <mark>**Randam Forest Classifier 모델** : 향후 1년 뒤 CLV 상위 30%인 고객 91% 정확도로 예측</mark>
 - **크로스셀링 제품 발굴**
      - <mark>8종의 연관 구매 제품 발굴을 통한 추가 매출 기회 포착</mark>
<br>

## 🗂 파일 주요내용
- **SQL 코드**
  - **1_BASE_EDA.sql** : 원본 데이터 특성 파악을 위한 쿼리 & EDA를 위한 쿼리
  - **2_COHORT_ANALYSIS.sql** : 코호트 분석용 데이터를 처리를 위한 쿼리
  - **3_CLV.sql** : 고객 별 Customer Lifetime Value(CLV)를 구하기 위한 쿼리
  - **4_RFM.sql** : 고객 별 RFM를 구하기 위한 쿼리
<br><br>

- **Python 코드** 
  - **5_EDA.ipynb** &nbsp; [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://drive.google.com/file/d/1wG-3oY3yQglpCxPYsfXkkhi0EGp2Jpn2/view?usp=sharing)
    - SQL 코드로 구현한 고객 별 CLV 값을 토대로 이진분류 ML 모델 구축을 위한 코드
  <br>
  
  - **6_ML_Model.ipynb** &nbsp; [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://drive.google.com/file/d/1jndZPStfiPDCMHhrtXWncj3joCnKQopl/view?usp=sharing)
    - SQL 코드로 구현한 고객 별 CLV 값을 토대로 이진분류 ML 모델 구축을 위한 코드
<br>

- **PDF 파일**
  - **7_캐글_커머스데이터_SQL활용_EDA.pdf** : EDA 필요한 데이터를 SQL 쿼리로 추출하고, Tableau를 활용하여 EDA
<br>
 
- **원본 데이터**
  - **Sample - Superstore_240830.csv** : 캐글 원본데이터(2014년~2017년, 2018년 극히 일부 데이터)
  - **Superstore.csv** : 캐글 원본데이터의 2014~2018년 데이터
  - **clv_table_2014.csv** : ML 훈련용 데이터
  
<br><br><br>
