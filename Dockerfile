FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-runtime


COPY . /svc-deeplsd
WORKDIR /svc-deeplsd
RUN pip install scikit-build
RUN pip install -r requirements.txt  # Install the requirements
RUN cd third_party/progressive-x/graph-cut-ransac/build; cmake ..; make -j8; cd ../../../..  # Install the C++ library Graph Cut RANSAC
RUN cd third_party/progressive-x/build; cmake ..; make -j8; cd ../../..  # Install the C++ library Progressive-X
RUN pip install -e third_party/progressive-x  # Install the Python bindings of Progressive-X for VP estimation
RUN cd third_party/afm_lib/afm_op; python setup.py build_ext --inplace; rm -rf build; cd ..; pip install -e .; cd ../..  # Install the Cuda code to generate AFM from lines (taken from https://github.com/cherubicXN/afm_cvpr2019)
RUN pip install -e line_refinement  # Install the Python bindings to optimize lines wrt a distance/angle field
RUN pip install -e third_party/homography_est  # Install the code for homography estimation from lines
RUN pip install -e third_party/pytlbd  # Install the LBD line matcher for evaluation
RUN pip install -e .  # Install DeepLSD
