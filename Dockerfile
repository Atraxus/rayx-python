# Build image for the manylinux wheels: the cibuildwheel default image plus the
# CUDA toolkit and the native dependencies of rayx. CI builds and publishes it
# to ghcr.io (see .github/workflows/wheels.yml), tagged by a hash of this file.
#
# The base is pinned to the digest cibuildwheel 4.3.0 uses for manylinux_2_28
# x86_64, so the image ships the same CPython interpreters cibuildwheel expects.
FROM quay.io/pypa/manylinux_2_28_x86_64@sha256:39df0042d5cc900b085aa25a0659368b42a0006c54c474299b785b44c1b4ff82

RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo \
    && dnf install -y cuda-toolkit nvidia-gds hdf5-devel wget boost-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="$PATH:$CUDA_HOME/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CUDA_HOME/lib64"
