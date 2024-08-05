#ifndef PTR_KERNEL_H
#define PTR_KERNEL_H

int confNonOverlapingInitialConditions(size_t nParticles, size_t sizeBox, double radio, double *ptrX, double *ptrY, double *ptrAngle);

void displayPtr(size_t ptrSize, double *ptr);

#endif