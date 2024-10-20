# 개인프로젝트 - 캐글 커머스 데이터 분석

## 프로젝트 흐름 요약 #코호트 분석 #RFM 분석 #고객생애가치 #상품연관분석

<img width="853" alt="스크린샷 2024-10-20 오후 8 30 35" src="https://github.com/user-attachments/assets/b0774edf-cb7b-452a-be5c-3d21e768d5bf">


<br><br>
## 🛒 커머스 데이터 분석 #코호트 분석 #RFM 분석 #고객생애가치 #상품연관분석
### 🔎 배경
- **온라인 커머스 기업의 데이터 분석가로 해당 서비스의 데이터를 분석한다고 가정**
### 🔎 문제 정의
  - **효율적 마케팅 전략 필요성** : 비용 절감을 위해 타겟팅된 마케팅 필요
  - **추가 매출 기회 발굴 필요성** : 자주 함께 구매되는 제품 분석을 통해 크로스셀링 기회를 찾아 매출 증대 전략 수립 필요

### 🔎 목표
  - **고객 그룹별 마케팅 전략 수립** : 고객 세분화를 통한 대응 체계 구축
  - **크로스셀링 전략 수립** : 자주 함께 구매되는 제품을 기반으로 추가 매출 전략 설계
 
### 🔎 수행 역할
  - **데이터 분석**
      - SQL, Python 활용 데이터 전처리, 분석, 시각화
      - RFM 분석, 이진분류 모델 구축을 통한 고객 가치 평가
      - 상품연관 분석을 통한 크로스셀링 제품 발굴
  - **마케팅 전략 수립**
      - 고객 그룹 및 제품에 따른 마케팅 전략 수립
   
### 🔎 주요 성과
  - **동질집단 분석**
      - <mark>코호트 분석 : 3개월 단위 당 평균 34.9% 수준으로 구매율이 유지됨</mark>
  - **고객 세분화**
      - <mark>RFM 분석 : 고객을 16개 그룹으로 세분화</mark>
      - <mark>Randam Forest Classifier 모델 : 향후 1년 뒤 CLV 상위 30%인 고객 91% 정확도로 예측</mark>
 - **크로스셀링 제품 발굴**
      - <mark>8종의 연관 구매 제품 발굴을 통한 추가 매출 기회 포착</mark>

### 🔎 파일 주요내용
- **SQL 전처리**
 - **01_데이터전처리.ipynb**

<br><br>
  - **01_데이터전처리.ipynb** &nbsp;&nbsp;&nbsp; [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://drive.google.com/file/d/1nwlXV11Uy6ds5O9zEETPh2NSMqPsVDwj/view?usp=sharing)
    -  Kaggle 데이터 활용 및 분석을 위한 다양한 전처리
      <br>
  - **02_EDA_및_가설검증.ipynb** &nbsp;&nbsp;&nbsp; [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://drive.google.com/file/d/1JAO_dITf7LZkry8zzGS8A21IHr3VPGVK/view?usp=sharing)
    - 전처리한 데이터를 가지고 다양한 EDA, 가설 설정, 인사이트 도출<mark>**(다양한 시각화, z-차트, 코호트 분석)**</mark>
<br><br>
### 커머스 - 프로젝트 2

- **홈쇼핑 기업의 데이터 분석가로 해당 서비스의 데이터를 분석한다고 가정**

- **파일 주요내용**
  - **01_AssociationRule_활용_아이템추천.ipynb** &nbsp;&nbsp;&nbsp; [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://drive.google.com/file/d/1IZYTyVdl4OKhBksZnOJXHHxIDzOrJvRd/view?usp=sharing)
    - 구매상품 연관분석(연령별 선호하는 상품 및 동시구매 상품 분석) <mark>**(네트워크 그래프 시각화, 연관분석)**</mark>

<br><br>

## 🏫 패스트캠퍼스 수강내역 데이터 분석
### 🔎 배경
### 파이널프로젝트

- **패스트캠퍼스 수강내역을 토대로 다양한 분석 및 인사이트 도출**


- **파일 주요내용**
  - **01_파이널_데이터분석.ipynb** &nbsp;&nbsp;&nbsp; [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://drive.google.com/file/d/1JeUdEFtSxbphLOMNOXeEVEKBcCUiGuAY/view?usp=sharing)
    -  패스트캠퍼스 수강내역을 토대로 다양한 데이터 분석
      <br>
  - **02_환불내역_리포트페이지.pdf** &nbsp;&nbsp;&nbsp; 
    - 패스트캠퍼스의 환불내역을 토대로 리포트 페이지를 작성한 파일
<br><br>
### 데이터 분석에 활용한 데이터 
- order-9968.txt 파일은 용량이 너무 커서 zip 파일로 업로드 되어있음
  <br><br>
  <img width="1273" alt="DataSchema" src="https://github.com/hahhhh77/FastCampus_Project/assets/50604929/e54fe691-3a87-442f-8a41-a03c8bee45bf">
