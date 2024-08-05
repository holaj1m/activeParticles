#include <math.h>
#include <random>
#include <chrono>
#include <iostream>

#include "../include/ptrKernel.h"

int confNonOverlapingInitialConditions(size_t nParticles, size_t sizeBox, double radio, double *ptrX, double *ptrY, double *ptrAngle){
    // Take current time as seed
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::default_random_engine generator(seed);

    // Length of the box 
    double boxLength{sizeBox*0.5};

    // Overlaping distance
    double overlapingDistance{4*radio*radio};

    // Uniform distribution between 0 and 2PI
    std::uniform_real_distribution<double> angleDistribution(0.0, 2*M_PI);
    // Uniform distribution between -sizeBox and sizeBox
    std::uniform_real_distribution<double> positionDistribution(-boxLength, boxLength);

    // Number of max attemps to set the initial condition
    size_t tolerance{2 * nParticles};

    // Proposed positons and distance
    double proposedX{}, proposedY{}, distance{};

    for(size_t particle{}; particle < nParticles; particle++){
        // Variable to count the attempts placing a particle
        size_t attempt{0};

        // Variable to manage errors
        bool placed{false};

        while(attempt < tolerance){

            // Assign positions for a particle
            proposedX = positionDistribution(generator);
            proposedY = positionDistribution(generator);

            // Assuming that particles does not overlap each other
            bool overlap{false};

            // Compute the distance with particles already assigned
            for(size_t previousParticles{}; previousParticles < particle; previousParticles++){
                distance = (pow((proposedX - ptrX[previousParticles]),2) + pow((proposedY - ptrY[previousParticles]),2));

                // If particles are overlaping change the value of overlap and break the loop
                if(distance < overlapingDistance){
                    overlap = true;
                    break;
                }
            }

            if(!overlap){
                ptrX[particle]      = proposedX;
                ptrY[particle]      = proposedY;
                ptrAngle[particle]  = angleDistribution(generator);

                placed = true;

                break;
            }
            else{
                // Increment attempt
                attempt++;
            }
        }
        
        // Return 1 if any particle could not be placed
        if (!placed) {
            std::cerr << "We coudn't place the particle " << particle << " after " << tolerance << " tries.\n";
            return 1; 
        }

    }

    return 0;
}


// Display pointer
void displayPtr(size_t ptrSize, double *ptr){
    std::cout << "[" << ptr[0] << ", ";
    for(size_t i{1}; i < ptrSize - 1; i++){
        std::cout << ptr[i] << ", ";
    }
    std::cout << ptr[ptrSize-1] << "]" << std::endl;
}

