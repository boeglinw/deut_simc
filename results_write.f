	subroutine results_ntu_write(main,vertex,orig,recon,success)

	implicit none
	include 'radc.inc'
	include 'hbook.inc'
	include 'simulate.inc'

	real*4	ntu(90)
	type(event_main):: main
	type(event):: vertex, orig, recon

!local (e,e'p) calculations:
	real*8 poftheta		!p as calculated from theta, assuming elastic.
	real*8 corrsing		!'corrected singles' for elastic
!	real*8 mm,mm2		!missing mass (assuming struck nucleon)
!	real*8 mmA,mmA2		!missing mass (assuming struck nucleus)
	real*8 Pm_Heepx,Pm_Heepy,Pm_Heepz	!Pm components for Heepcheck.

!local (e,e'pi/K) calculations:
!	real*8 t		!t
	real*8 dummy
c mkj ( used in mc_hms.f)
        real energy_loss_coll
	real*8 allow_scat_in_coll,x_at_coll,y_at_coll,xp_at_coll,yp_at_coll 
	real*8 prob_abs
	common / coll_pass_thru / energy_loss_coll,allow_scat_in_coll	
     >   ,x_at_coll,y_at_coll,xp_at_coll,yp_at_coll,prob_abs

	integer i

	logical success

	if (debug(2)) write(6,*)'r_ntu_write: entering'

!If event did not make it thru spectrometers, return.  Later, we will want to
! add option to write event even if it failed when doing_phsp.

	if (.not.success) return

*	if (phot1.gt.lim1) write(6,*) 'phot1,lim1=',phot1,lim1
*	if (phot2.gt.lim2) then
*	   write(6,*) 'phot2,lim2=',phot2,lim2
*	   write(6,*) egamma_tot_max-egamma_used(1)
*	   write(6,*) vertex.e.E - edge.e.E.min
*	endif
*	if (phot3.gt.lim3) write(6,*) 'phot3,lim3=',phot3,lim3


!Calculate some proton/pion/kaon specific stuff:
!
!	if (doing_pion .or. doing_kaon) then
!	  mm2 = recon.Em**2 - recon.Pm**2
!	  mm  = sqrt(abs(mm2)) * abs(mm2)/mm2
!	  mmA2= (recon.nu + targ.M - recon.p.E)**2 - recon.Pm**2
!	  mmA = sqrt(abs(mmA2)) * abs(mmA2)/mmA2
!	  t = recon.Q2 - Mh2
!     >	    + 2*(recon.nu*recon.p.E - recon.p.P*recon.q*cos(recon.theta_pq))
!	endif

	if (doing_hyd_elast .or. doing_deuterium .or. doing_heavy) then
	  poftheta = Mp*Ebeam / (2*ebeam*sin(recon%e%theta/2.)**2 + Mp)
	  corrsing = recon%e%P - poftheta
	  Pm_Heepz = -(recon%Pmy*recon%uq%y+recon%Pmz*recon%uq%z)
     >		/ sqrt(recon%uq%y**2+recon%uq%z**2)
	  Pm_Heepy =  (recon%Pmz*recon%uq%y-recon%Pmy*recon%uq%z)
     >		/ sqrt(recon%uq%y**2+recon%uq%z**2)
	  Pm_Heepx =  -recon%Pmx
c
	  Pm_Heepx= recon%Pmy
	  Pm_Heepy= -recon%Pmx
	  Pm_Heepz= -recon%Pmz
	endif

	if(electron_arm.eq.1 .or. electron_arm.eq.3.or. electron_arm.eq.7)then !electron = right side.
	  ntu(1) = recon%e%delta
	  ntu(2) = recon%e%yptar			!mr
	  ntu(3) = recon%e%xptar			!mr
	  ntu(4) = recon%e%z
	  ntu(5) = main%FP%e%x
	  ntu(6) = main%FP%e%dx				!mr
	  ntu(7) = main%FP%e%y
	  ntu(8) = main%FP%e%dy				!mr
	  ntu(9) = orig%e%delta
	  ntu(10) = orig%e%yptar			!mr
	  ntu(11) = orig%e%xptar			!mr
	  ntu(12) = main%target%z*spec%e%sin_th
	  ntu(13) = recon%p%delta
	  ntu(14) = recon%p%yptar			!mr
	  ntu(15) = recon%p%xptar			!mr
 	  ntu(16) = recon%p%z
 	  ntu(17) = main%FP%p%x
	  ntu(18) = main%FP%p%dx			!mr
 	  ntu(19) = main%FP%p%y
 	  ntu(20) = main%FP%p%dy			!mr
	  ntu(21) = orig%p%delta
	  ntu(22) = orig%p%yptar			!mr
	  ntu(23) = orig%p%xptar			!mr
 	  ntu(24) = -main%target%z*spec%p%sin_th
	else if (electron_arm.eq.2 .or. electron_arm.eq.4 .or.
     >		 electron_arm.eq.5 .or. electron_arm.eq.6.or. electron_arm.eq.8) then  !e- = left.
	  ntu(1) = recon%p%delta
	  ntu(2) = recon%p%yptar			!mr
	  ntu(3) = recon%p%xptar			!mr
	  ntu(4) = recon%p%z
	  ntu(5) = main%FP%p%x
	  ntu(6) = main%FP%p%dx				!mr
	  ntu(7) = main%FP%p%y
	  ntu(8) = main%FP%p%dy				!mr
c	  ntu(9) = vertex%p%delta
c	  ntu(10) = vertex%p%yptar			!mr
c	  ntu(11) = vertex%p%xptar			!mr
	  ntu(9) = orig%p%delta
	  ntu(10) = orig%p%yptar			!mr
	  ntu(11) = orig%p%xptar			!mr
	  ntu(12) = main%target%z*spec%p%sin_th
	  ntu(13) = recon%e%delta
	  ntu(14) = recon%e%yptar			!mr
	  ntu(15) = recon%e%xptar			!mr
	  ntu(16) = recon%e%z
 	  ntu(17) = main%FP%e%x
	  ntu(18) = main%FP%e%dx			!mr
 	  ntu(19) = main%FP%e%y
 	  ntu(20) = main%FP%e%dy			!mr
	  ntu(21) = orig%e%delta
	  ntu(22) = orig%e%yptar			!mr
	  ntu(23) = orig%e%xptar			!mr
	  ntu(24) = -main%target%z*spec%e%sin_th
	else
	  write (6,*) 'results_write not yet set up for your spectrometers.'
	endif
	ntu(25) = recon%q/1000.				!q - GeV/c
	ntu(26) = recon%nu/1000.			!nu - GeV
	ntu(27) = recon%Q2/1.d6				!Q^2 - (GeV/c)^2
	ntu(28) = recon%W/1000.				!W - GeV/c
	ntu(29) = recon%epsilon				!epsilon
	ntu(30) = recon%Em/1000.			!GeV
        !ntu(30) = vertex%Em/1000.                       !GeV                     
	ntu(31) = recon%Pm/1000. !GeV/c
	ntu(32) = recon%theta_pq			!theta_pq - radians
	ntu(33) = recon%phi_pq				!phi_pq - radians

	if (doing_pion .or. doing_kaon .or. doing_delta) then
	  ntu(34) = ntup%mm/1000.			!missmass (nucleon)
	  ntu(35) = ntup%mmA/1000.			!missmass (nucleus)
	  ntu(36) = recon%p%P/1000.			!ppi - GeV/c
	  ntu(37) = ntup%t/1.d6				!t - GeV^2
	  ntu(38) = recon%PmPar/1000.
	  ntu(39) = recon%PmPer/1000.
	  ntu(40) = recon%PmOop/1000.
	  ntu(41) = -main%target%rastery		!fry - cm
	  ntu(42) = ntup%radphot/1000.			!radphot - GeV
	  dummy = pferx*vertex%uq%x + pfery*vertex%uq%y + pferz*vertex%uq%z
	  if (dummy.eq.0) dummy=1.d-20
!	  ntu(43) = pfer/1000.*abs(dummy)/dummy		!p_fermi - GeV/c
	  ntu(54) = sign(pfer/1000., dummy)		!p_fermi - GeV/c
	  ntu(44) = main%sigcc				!d5sig
	  ntu(45) = ntup%sigcm				!pion sig_cm
	  ntu(46) = main%weight
	  ntu(47) = decdist				!decay distance (cm)
	  ntu(48) = sqrt(Mh2_final)
	  ntu(49) = pfer/1000.*dummy			!p_fermi along q.
	  ntu(50) = vertex%Q2/1.d6
	  ntu(51) = main%w/1.d3
	  ntu(52) = main%t/1.d6
	  ntu(53) = main%phi_pq
	  if(using_tgt_field) then
	     ntu(54) = recon%theta_tarq
	     ntu(55) = recon%phi_targ
	     ntu(56) = recon%beta
	     ntu(57) = recon%phi_s
	     ntu(58) = recon%phi_c
	     ntu(59) = main%beta
	     ntu(60) = vertex%phi_s
	     ntu(61) = vertex%phi_c
	     if (doing_kaon) then
		ntu(62) = ntup%sigcm1 !sigcm - saghai model
		ntu(63) = ntup%sigcm2 !sigcm - factorized.
	     endif
	  else
	     if (doing_kaon) then
		ntu(54) = ntup%sigcm1 !sigcm - saghai model
		ntu(55) = ntup%sigcm2 !sigcm - factorized.
	     endif
	  endif
	else if (doing_semi.or.doing_rho) then
	  ntu(34) = ntup%mm/1000.			!missmass (nucleon)
	  ntu(35) = recon%p%P/1000.			!ppi - GeV/c
	  ntu(36) = ntup%t/1.d6				!t - GeV^2
	  ntu(37) = -main%target%rastery		!fry - cm
	  ntu(38) = ntup%radphot/1000.			!radphot - GeV
	  ntu(39) = main%sigcc				!d5sig
	  ntu(40) = main%sigcent			!d5sig - central kin.
	  ntu(41) = main%weight
	  ntu(42) = decdist				!decay distance (cm)
	  ntu(43) = sqrt(Mh2_final)
	  ntu(44) = recon%zhad
	  ntu(45) = vertex%zhad
	  ntu(46) = recon%pt2/1.d06
	  ntu(47) = vertex%pt2/1.d06
	  ntu(48) = recon%xbj
	  ntu(49) = vertex%xbj
	  ntu(50) = acos(vertex%uq%z)
	  ntu(51) = ntup%sigcm
	  ntu(52) = main%davejac
	  ntu(53) = main%johnjac
	  dummy = pferx*vertex%uq%x + pfery*vertex%uq%y + pferz*vertex%uq%z
!	  ntu(54) = pfer/1000.*abs(dummy)/dummy		!p_fermi - GeV/c
	  ntu(54) = sign(pfer/1000., dummy)		!p_fermi - GeV/c
	  ntu(55) = ntup%xfermi
	  ntu(56) = main%phi_pq
	  if(using_tgt_field) then
	     ntu(57) = recon%theta_tarq
	     ntu(58) = recon%phi_targ
	     ntu(59) = recon%beta
	     ntu(60) = recon%phi_s
	     ntu(61) = recon%phi_c
	     ntu(62) = main%beta
	     ntu(63) = vertex%phi_s
	     ntu(64) = vertex%phi_c
	     if(doing_rho) then
		ntu(65) = ntup%rhomass
		ntu(66) = ntup%rhotheta
	     endif
	  else
	     if(doing_rho) then
		ntu(57) = ntup%rhomass
		ntu(58) = ntup%rhotheta
	     endif
	  endif
	else if (doing_hyd_elast .or. doing_deuterium .or. doing_heavy) then
	  ntu(34) = corrsing/1000.
	  ntu(35) = Pm_Heepx/1000.
	  ntu(36) = Pm_Heepy/1000.
	  ntu(37) = Pm_Heepz/1000.
	  ntu(38) = recon%PmPar/1000.
	  ntu(39) = recon%PmPer/1000.
	  ntu(40) = recon%PmOop/1000.
	  ntu(41) = -main%target%rastery		!fry - cm
	  ntu(42) = ntup%radphot/1000.			!radphot - GeV
	  ntu(43) = main%sigcc
	  ntu(44) = main%weight
	  ntu(45) = main%jacobian                       !  jacobian to determine sigma
	  ntu(46) = recon%e%theta                       !  electron scattering angle
	  ntu(47) = recon%p%theta                       !  proton scattering angle
	  ntu(48) = main%target%x                       !  vertex x generated event
	  ntu(49) = main%target%y                       !  vertex y
	  ntu(50) = main%target%z                       !  vertex z
	  ntu(51) = main%gen_weight                     !  general weight for event generation
	  ntu(52) = main%SF_weight                      !  Spectral Function
	  ntu(53) = main%jacobian_corr                 !  correction to jacobian
	  ntu(54) = main%sig                           !  cross section
	  ntu(55) = main%sig_recon                     !  cross section (reconstr. Laget)
	  ntu(56) = main%sigcc_recon                   !  sigcc (reconstr)
	  ntu(57) = main%coul_corr                     !  coul. correction
	  ntu(58) = main%RECON%p%zv                    !  p recon. vertex zv
	  ntu(59) = main%RECON%p%yv                    !                  yv
	  ntu(60) = main%RECON%e%zv                    !  e recon. vertex  zv
	  ntu(61) = main%RECON%e%yv                    !           vertex  yv
	  ntu(62) = recon%p%P                          !  final proton momentum
	  ntu(63) = recon%e%P                          !  final electron momentum
	  ntu(64) = recon%ein                          !  incident energy (recon)
	  ntu(65) = recon%theta_rq                     !  recoil angle
	  ntu(66) = main%SF_weight                     !  Spectral Function fro recon. quantities
	  ntu(67) = (spec%p%theta+recon%p%yptar)*180./3.1415926536     !  RCT 8/9/2016 outgoing reconstructed proton in-plane angle
	  ntu(68) = vertex%ein                          !  incident energy (vertex)                         
! new WB CY
	  ntu(69) = vertex%Q2                          !  Q2 (vertex)                         
	  ntu(70) = vertex%NU                          !  energy transfer (vertex)                         
	  ntu(71) = vertex%Q                           !  q (vertex)                         
	  ntu(72) = vertex%PM                          !  p_miss (vertex)                         
	  ntu(73) = vertex%PMPAR                       !  p_miss_par (vertex)                         
	  ntu(74) = vertex%P%P                         !  p_f (vertex)                         
	  ntu(75) = vertex%P%E                         !  Ep energy (vertex)                         
	  ntu(76) = vertex%e%E                         !  final electron energy (vertex) 
	  !C.Y. Added vertex x'tar/y'tar
	  !necessary to obtain vertex kin. angles 
	  !(th_nq, th_q, th_pq, etc.)
	  ntu(77) = vertex%e%xptar                     !  electron x'tar (vertex) 
	  ntu(78) = vertex%e%yptar                     !  electron y'tar (vertex)
	  ntu(79) = vertex%p%xptar                     !  hadron x'tar   (vertex)
	  ntu(80) = vertex%p%yptar                     !  hadron y'tar   (vertex)
	  ntu(81) =x_at_coll
	  ntu(82) =y_at_coll
	  ntu(83) =energy_loss_coll
	  ntu(84) =prob_abs
	endif

! write output
!
	do i = 1, NtupleSize
	   if (ISNAN(ntu(i)) ) then
	      print *, 'NaN found for : ', i, NtupleTag(i)
	   endif
	enddo
	write (NtupleIO, *) (ntu(i), i = 1, NtupleSize)

	if (debug(2)) write(6,*)'r_ntu_write: ending'
	return
	end


	subroutine results_ntu_write1(vertex,recon,main,success)

	implicit none
	include 'hbook.inc'
	include 'simulate.inc'

	integer*4 nentries, i
	parameter (nentries = 9)

	real*8	ntu(nentries)
	logical success
	type(event_main):: main
	type(event):: vertex, recon

	if (debug(2)) write(6,*)'r_ntu_write: entering'
	ntu(1) = vertex%e%delta
	ntu(2) = vertex%e%yptar
	ntu(3) = -vertex%e%xptar
	ntu(4) = main%SP%e%z
	if(success)then
	  ntu(5) = recon%e%delta
	  ntu(6) = recon%e%yptar
	  ntu(7) = recon%e%xptar
	  ntu(8) = recon%e%z
	else
	  ntu(5) = 30.
	  ntu(6) = 0.1
	  ntu(7) = 0.1
	  ntu(8) = 4.
	endif
	ntu(9) = main%weight


	do i = 1, NtupleSize
	   if (ISNAN(ntu(i))) then
	      print *, 'NaN found for : ', i, NtupleTag(i)
	   endif
	enddo
	write(NtupleIO, *) (ntu(i), i = 1, NtupleSize)

	if (debug(2)) write(6,*)'r_ntu_write: ending'
	return
	end
