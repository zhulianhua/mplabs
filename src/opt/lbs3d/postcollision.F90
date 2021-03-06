!-------------------------------------------------------------------------------
! Subroutine : PostCollision
! Revision   : 1.2 (2013/09/10)
! Author     : Carlos Rosales-Fernandez [carlos.rosales.fernandez(at)gmail.com]
!-------------------------------------------------------------------------------
! Update g in nodes at processor boundaries and outward f in ghosts.
! This is faster than using a neighbor array in collision.
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------
! Copyright 2013 Carlos Rosales Fernandez and The University of Texas at Austin.
! Copyright 2008 Carlos Rosales Fernandez, David S. Whyte and IHPC (A*STAR).
!
! This file is part of MP-LABS.
!
! MP-LABS is free software: you can redistribute it and/or modify it under the
! terms of the GNU GPL version 3 or (at your option) any later version.
!
! MP-LABS is distributed in the hope that it will be useful, but WITHOUT ANY
! WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
! A PARTICULAR PURPOSE. See the GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License along with
! MP-LABS, in the file COPYING.txt. If not, see <http://www.gnu.org/licenses/>.
!-------------------------------------------------------------------------------

 SUBROUTINE PostCollision

!  Common Variables
 USE Domain
 USE LBMParams
 IMPLICIT NONE

!  Local variables
 INTEGER :: i, j, k

!$OMP PARALLEL

! X direction
!$OMP DO PRIVATE(j)
 DO k = 1, NZ
   DO j = 1, NY
     f1( (NX+1) + NXG*( j + NYG*k ) + now) = f1( 1 + NXG*( j + NYG*k ) + now)
   END DO
   DO j = 1, NY
     f2( NXG*( j + NYG*k) + now) = f2( NX + NXG*( j + NYG*k ) + now)
   END DO
 END DO

! Y direction
!$OMP DO PRIVATE(i)
 DO k = 1, NZ
   DO i = 1, NX
     f3( i + NXG*( (NY+1) + NYG*k ) + now) = f3( i + NXG*( 1 + NYG*k ) + now)
   END DO
   DO i = 1, NX
     f4( i + NXG*( NYG*k ) + now) = f4( i + NXG*( NY + NYG*k) + now)
   END DO
 END DO

! Z direction
!$OMP DO PRIVATE(i)
 DO j = 1, NY
   DO i = 1, NX
     f5( i + NXG*( j + NYG*(NZ+1) ) + now) = f5( i + NXG*( j + NYG ) + now)
   END DO
   DO i = 1, NX
     f6( i + NXG*( j ) + now) = f6( i + NXG*( j + NYG*NZ ) + now)
   END DO
 END DO

!
! At this stage we are ready to do the relaxation step in stream.f90
!

!$OMP END PARALLEL

 RETURN
 END SUBROUTINE PostCollision

