         program exact_lam5_dUdL_TI_integrate

         implicit none

         integer i
         real(8) tmp,val(0:4),total

         open(50,file='dUdLTI')
         do i=0,4
            read(50,*) val(i)
         enddo
         close(50)

         total=0d0
         total=total+0.5d0*(val(0)+val(1))*0.15
         total=total+0.5d0*(val(1)+val(2))*0.35
         total=total+0.5d0*(val(2)+val(3))*0.35
         total=total+0.5d0*(val(3)+val(4))*0.15

         print *,'lambda5 exact dUdL+TI integrated value=',total
         open(50,file='exact_lam5_dUdL_TI_integrated_value')
         write(50,*) total
         close(50)

         end program exact_lam5_dUdL_TI_integrate
