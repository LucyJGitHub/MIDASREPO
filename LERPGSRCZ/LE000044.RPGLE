     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL process grace days')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000044  - Midas LE PDCL process  grace days:               *
      *              Generate Loans Today RE/MR repayments for Loans  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE164             Date 18Aug14               *
      *                 MD022608           Date 27Sep13               *
      *                 AR1056323          Date 14Nov12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD022608 - Recompiled due to changes on LEREPLL1 by AR786878.*
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     F***LEREPLL1  UF   E           K DISK    INCLUDE(LELEGDD0)                               CLE164
     FLELEGDPD  UF   E             DISK                                                       CLE164
     F                                     PREFIX(GD)
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      ** LE Loan account keys file
      *
     FLOAMSL1   UF A E           K DISK    INCLUDE(LOAMSDKF)
     F                                     PREFIX(AM)
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      ** LE Loan amendments file
      *
     FLOAMSZ1   UF   E             DISK    PREFIX(#TR)
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      ** LE Loan amendments trailer
      *
      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,PSDS

     D*LELEGDDS      E DS                  EXTNAME(LEREPLL1:LELEGDD0:*INPUT)                  CLE164
     D LELEGDDS      E DS                  EXTNAME(LELEGDPD:LELEGDD0:*INPUT)                  CLE164
     D                                     PREFIX(GD)

     D LELOAMSDS     E DS                  EXTNAME(LOAMSL1:LOAMSDKF:*OUTPUT)
     D                                     PREFIX(AM)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

     D DSFDY         E DS

     D DSSDY         E DS

     D WCCY            S                   LIKE(AMCCY)

     D ZZNEGD          S              5
     D ZZWK3           S             15  0
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZAMT           S             15  3
     D ZZWK2           S              4  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0

      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
      *
     C                   EXSR      SRMAIN
      *
     C                   EXSR      SRCLOSE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Main Subroutine                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRFULLACTION, SRPARTLACTION & SRNOACTION               *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR

     C*****LOVAL         SETLL     LEREPLL1                                                   CLE164
     C**********         READ      LEREPLL1      LELEGDDS                                     CLE164
     C                   READ      LELEGDPD      LELEGDDS                                     CLE164

     C**********         DOW       NOT %EOF(LEREPLL1)                                         CLE164
     C                   DOW       NOT %EOF(LELEGDPD)                                         CLE164

      ** Select records where Process Flag is not 'P'
      ** and Action Date is Before Next Working Date

     C                   IF        GDSEIPFL <> 'P'
     C                             AND GDACDT < BJDNWD

     C                   EVAL      WSEAAMT = GDSEAAMT * -1

     C                   SELECT

      ** Available balance is Credit
      ** and Available balance >= Event Total amount

     C                   WHEN      WSEAAMT > *ZERO
     C                             AND WSEAAMT >= GDSETAMT
     C                   EXSR      SRFULLACTION

      ** Available balance is Credit
      ** and Available balance < Event Total amount

     C                   WHEN      WSEAAMT > *ZERO
     C                             AND WSEAAMT < GDSETAMT
     C                   EXSR      SRPARTLACTION

      ** Available balance is *Zero
      ** Or Available balance is Debit

     C                   WHEN      WSEAAMT <= *ZERO
     C                   EXSR      SRNOACTION

     C                   ENDSL

     C                   ENDIF

     C**********         READ      LEREPLL1      LELEGDDS                                     CLE164
     C                   READ      LELEGDPD      LELEGDDS                                     CLE164
     C
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFULLACTION - Amend files for full payment                   *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: SRPDCLUP & SRPDCLIN                                    *
      *                                                               *
      *****************************************************************
     C     SRFULLACTION  BEGSR

      ** Write an MR/RE record

     C                   EVAL      LELOAMSDS = LELEGDDS
     C                   WRITE     LOAMSDKF      LELOAMSDS

      ** Adjust the Loan Amendments Trailer File

     C                   EXSR      SRADJTRAIL

      ** Update the Loans Events Grace Days file
     C                   EVAL      GDSEIPFL = 'P'
     C                   UPDATE    LELEGDD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPARTLACTION - Amend files for partial payment               *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPARTLACTION BEGSR
      *
      ** Prepare MR/RE record for writing
      *
     C                   EVAL      LELOAMSDS = LELEGDDS
      *
      ** Repayment Type 3:
      *
     C                   IF        AMREPT = 3
     C                   EVAL      AMPRAM = 0
     C                   EVAL      AMINTA = 0
     C                   EVAL      AMTAMT = GDSEAAMT
      *
      ** Other Repayment Types:
      *
     C                   ELSE
      *
      ** Pay Interest First:
      *
     C                   IF        WSEAAMT >= GDSEINTA
     C                   EVAL      AMINTA = GDSEINTA
     C                   EVAL      AMPRAM = WSEAAMT - GDSEINTA
     C                   ELSE
     C                   EVAL      AMINTA = WSEAAMT
     C                   EVAL      AMPRAM = 0
     C                   ENDIF
      *
     C                   EVAL      AMTAMT = AMINTA + AMPRAM
      *
     C                   ENDIF

     C                   WRITE     LOAMSDKF      LELOAMSDS
      *
      ** Adjust the Loan Amendments Trailer File
      *
     C                   EXSR      SRADJTRAIL
      *
      ** Update the Loans Events Grace Days file
      *
      ** For Repayment Type 3:
      *
     C                   IF        GDREPT = 3
     C                   EVAL      GDSEPRAM = 0
     C                   EVAL      GDSEINTA = 0
     C                   EVAL      GDSETAMT = GDSETAMT - WSEAAMT
      *
      ** Other Repayment Types:
      *
     C                   ELSE
     C                   EVAL      GDSEPRAM = GDSEPRAM - AMPRAM
     C                   EVAL      GDSEINTA = GDSEINTA - AMINTA
     C                   EVAL      GDSETAMT = GDSEINTA + GDSEPRAM
     C                   ENDIF
      *
     C                   EVAL      GDACDT = BJDNWD
     C                   EVAL      GDSEIPFL = 'Y'
     C                   UPDATE    LELEGDD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNOACTION - No amendments since no available balance         *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRNOACTION    BEGSR
      *
      ** Update the Loans Events Grace Days file
      *
     C                   EVAL      GDACDT = BJDNWD
     C                   EVAL      GDSEIPFL = 'Y'
     C                   UPDATE    LELEGDD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRADJTRAIL - Adjust the Loan Amendments Trailer File          *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRADJTRAIL    BEGSR

     C     1             CHAIN     LOAMSZ1

     C                   IF        %FOUND(LOAMSZ1)
     C                   EVAL      #TRNORE += 1
     C                   EVAL      #TRNINS += 1
     C                   EVAL      #TRNLRA += 1

      ** If Not Repayment and Repayment type other than 1
      ** and Total Amount is not zero, add total amount to
      ** trailer amounts

     C                   IF        AMAMTP <> 'RE'
     C                             AND AMREPT <> 1
     C                             AND AMTAMT <> 0
     C                   EVAL      ZZAMT = AMTAMT/(1000)

      ** Add total amount to value of records inserted (AMTAMT + VRIx)

     C                   EVAL      ZZTOTI = #TRVRIF
     C                   EVAL      ZZTOTD = #TRVRIL
     C                   EXSR      GLZADD
     C                   EVAL      #TRVRIF = ZZTOTI
     C                   EVAL      #TRVRIL = ZZTOTD

      ** Add total amount to
      ** value of records after input (AMTAMT + VRRx)

     C                   EVAL      ZZTOTI = #TRVRRF
     C                   EVAL      ZZTOTD = #TRVRRL
     C                   EXSR      GLZADD
     C                   EVAL      #TRVRRF = ZZTOTI
     C                   EVAL      #TRVRRL = ZZTOTD
     C                   ENDIF

     C                   UPDATE    LOAMSZ1F

     C                   ELSE

      ** Halt processing if no trailer record found

     C     *LOCK         IN        LDA
     C                   EVAL      @RTCD = '*RECUPD'
     C                   EVAL      DBPGM = 'LE000044'
     C                   EVAL      DBFILE = 'LOAMS'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = '999999'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      * GLZADD   - Subroutine to add an amount to the total           *
      * Called by: SRTRAL, GLZSUB                                     *
      * Calls    : GLZSUM                                             *
      *****************************************************************

     C     GLZADD        BEGSR

     C                   Z-ADD     ZZAMT         ZZAMT
     C   91              GOTO      ZZAEND

      ** Split ZZAMT into integer and decimal fields

     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD

      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now

     C                   EXSR      GLZSUM
     C     ZZAEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM   - Subroutine to carry out the addition for subroutine*
      * Called by: GLZSUM                                             *
      * Calls    : None                                               *
      *****************************************************************
     C     GLZSUM        BEGSR

     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599

      ** Determine sign of ZZAMTI & D,  92 if neg

     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND

      ** Determine sign of ZZTOTI & D, 91 if neg

     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193

      ** If ZZTOTAL is zero, return ZZAMOUNT

     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND

      ** If signs differ, bypass overflow checks

     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS

     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93

     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3

      ** If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured

     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI

      ** If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left
      ** intact

     C   99              Z-ADD     0             ZZAMT
     C                   GOTO      ZZSEND

      ** The 'signs' are different

     C     ZZOFPS        TAG

      ** If ZZAMT was negative, make it pos. to como with ZZTOT

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD

      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.

     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD

      ** Both ZZAMT and ZZTOT are now positive

     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95

      ** If ZZTOT eq. ZZAMT return ZERO.

     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND

      ** If ZZTOT gt. ZZAMT.

     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD

      ** If ZZAMT gt. ZZTOT.

     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD

      ** Reverse sign of ZZTOT if larger I/P fields were negative

     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD

      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG

      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.

     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCLOSE - Close Program                                      *
      *****************************************************************
     C     SRCLOSE       BEGSR

     C                   EVAL      *INLR       = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Default Initialisation Subroutine                   *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Access Bank details via access program
      ** (database error handling done in access program)

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     *LIKE         DEFINE    GDSEAAMT      WSEAAMT

     C                   ENDSR
      /EJECT
      *****************************************************************
      *  *PSSR - Default Error Handling Subroutine                    *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        RUNBEFORE <> 'Y'
     C                   EVAL      RUNBEFORE   = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
**  CPY@
(c) Finastra International Limited 2012
