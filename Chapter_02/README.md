# Chapter02

## Establish the C++ and CUDA execute environment for not having the NVIDIA GPU UNIT
- There're the three method for NVIDIA GPU programing environment
  1. Use the colaboratory in Google
  2. Use the NVIDIA NGC catalogs (NVIDIA LaunchPad)
  3. Use the cloud environment (AWS Sagemaker or GCP Vertex AI or Azure Machine Learning)

### Colaboratory Environment
1. Create google account
2. Access to the below URL
-  https://colab.research.google.com/
3. Change the using processer for GPU from Runtime - Change Runtime Type
4. Execute the program following in the ./sample/CUDA_sample.ipynb
- Note : hello_cuda.cu doesn't work properly