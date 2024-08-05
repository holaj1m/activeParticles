#include <iostream>
#include <cstdlib>
#include <math.h>
#include <random>
#include <chrono>

#include </usr/local/cuda/include/cuda_runtime.h>
#include </usr/local/cuda/include/curand.h>
#include </usr/local/cuda/include/curand_kernel.h>

#include "../include/errorHandling.h"
#include "../include/ptrKernel.h"

// Function that computes the minimum value of two input
#define imin(a,b) (a<b?a:b)

int main(){

    // Number of particles
    size_t nParticles{10};

    // Size of the Box
    size_t sizeBox{50};

    // Particles radius
    double radio{1.5};

    // Pointers to allocate coordinates of particles on host
    double *xCoords{nullptr}, *yCoords{nullptr}, *angleCoords{nullptr};

    // Pointer to allocate the distances between particles
    double *particleDistance{nullptr};

    // Allocate memory on the CPU
    xCoords     = new double[nParticles];
    yCoords     = new double[nParticles];
    angleCoords = new double[nParticles];

    particleDistance    = new double[nParticles * nParticles];


    int initConditions = confNonOverlapingInitialConditions(nParticles, sizeBox, radio, xCoords, yCoords, angleCoords);

    if(initConditions == 1){
        // Clear memory if we can´t arrange the particles
        delete[] xCoords;       xCoords = nullptr;
        delete[] yCoords;       yCoords = nullptr;
        delete[] angleCoords;   angleCoords = nullptr;

        delete[] particleDistance; particleDistance = nullptr;

        return 1;
    }
    else{
        std::cout << "The initial condition was setted :D" << std::endl;
    }

    // display positions and angles
    std::cout << "X POSITIONS" << std::endl;
    displayPtr(nParticles, xCoords);

    std::cout << "Y POSITIONS" << std::endl;
    displayPtr(nParticles, yCoords);

    std::cout << "ANGLES" << std::endl;
    displayPtr(nParticles, angleCoords);



    delete[] xCoords;       xCoords = nullptr;
    delete[] yCoords;       yCoords = nullptr;
    delete[] angleCoords;   angleCoords = nullptr;

    delete[] particleDistance; particleDistance = nullptr;
    return 0;
}