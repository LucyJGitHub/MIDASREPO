     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL RE/MR repayment for Loans')              *
      *****************************************************************
      *                                                               *
      *  Midas - LE Module                                            *
      *                                                               *
      *  LE000048 - Generate Loans future RE/MR repayments for Loans  *
      *                                                               *
      *  Function:  This program process the Loans Events grace days  *
      *             file and generate Manual Repayment Events (MR)    *
      *             or Repayment Schedule Events (RE) for loans       *
      *             repayments events which are within grace days     *
      *             period for which there is no available balance    *
      *             today and need to be re-processed tomorrow.       *
      *                                                               *
      *  Called By: LEC000048                                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE164             Date 18Aug14               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loans Processing                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         Read to LELEGDD0                                *
      *    84         Chain to LOAMSZ1                                *
      *    98         Date Format                                     *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise Subroutine                                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FLELEGDPD  UF   E             DISK    INFSR(*PSSR) COMMIT
     FLOAMSDK   UF A E           K DISK    INFSR(*PSSR) COMMIT
     FLOAMSL1   UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)

     D @RUN            S              1

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
     D WRTCD           S              7A
     D WOPTN           S              7A
     D WKLNR           S              6
     D WKVDT           S              5  0
     D WKLSN           S              3  0
     D ZZNEGD          S              5
     D ZZWK3           S             15  0
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZAMT           S             15  3
     D ZZWK2           S              4  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D FADD            S              5  0
     D WZZAMT          S             15  3

      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C     *DTAARA       DEFINE                  LDA

     C                   IN        RUNDAT
     C                   Z-ADD     0             WZZAMT
     C                   Z-ADD     0             ZZAMT
C    C     1             SETLL     LELEGDD0
     C                   READ      LELEGDD0                               80
     C     *IN80         DOWEQ     '0'
     C     SEIPFL        IFEQ      'Y'
     C     ACDT          ANDGE     BJDNWD
     C                   EVAL      PRAM = SETAMT
     C                   EVAL      TAMT = SETAMT
     C                   WRITE     LOAMSDKF
     C                   ADD       1             FADD
     C                   IF        AMTP <> 'RE' AND
     C                             REPT <> 1
     C                   EVAL      WZZAMT = TAMT/(1000)
     C                   ADD       WZZAMT        ZZAMT
     C                   ENDIF

      ** Set Processed Flag to 'P'

     C                   EVAL      SEIPFL = 'P'
     C                   UPDATE    LELEGDD0
     C                   ENDIF
     C                   READ      LELEGDD0                               80
     C                   ENDDO

      ** Update Loan Amendments Trailer

     C                   MOVE      '999999'      WKLNR
     C                   MOVE      '99999'       WKVDT
     C                   MOVE      '999'         WKLSN
     C     KLAKEY        CHAIN     LOAMSZ1F                           84
     C     *IN84         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'LOAMSZ1'     DBFILE
     C                   Z-ADD     007           DBASE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   ADD       FADD          NORE
     C                   ADD       FADD          NINS
     C                   ADD       FADD          NLRA
     C                   MOVE      VRIF          ZZTOTI
     C                   MOVE      VRIL          ZZTOTD
     C                   EXSR      GLZADD
     C                   MOVE      ZZTOTI        VRIF
     C                   MOVE      ZZTOTD        VRIL
     C                   MOVE      VRRF          ZZTOTI
     C                   MOVE      VRRL          ZZTOTD
     C                   EXSR      GLZADD
     C                   MOVE      ZZTOTI        VRRF
     C                   MOVE      ZZTOTD        VRRL
     C
     C                   UPDATE    LOAMSZ1F
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZADD   - Add an amount to the total                         *
      *****************************************************************
     C     GLZADD        BEGSR

     C     ZZAMT         IFNE      0

      **  Split ZZAMT into integer and decimal fields

     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD

      **  Both ZZAMTI and ZZAMTD contain a 'sign' zone now

     C                   EXSR      GLZSUM
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM   - Carry out the additon for subroutine               *
      *****************************************************************
     C     GLZSUM        BEGSR

     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599

      **  Determine sign of ZZAMTI & D,  92 if neg

     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND

      **  Determine sign of ZZTOTI & D, 91 if neg

     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193

      **  If ZZTOTAL is zero, return ZZAMOUNT

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

      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     KLAKEY        KLIST
     C                   KFLD                    WKLNR
     C                   KFLD                    WKVDT
     C                   KFLD                    WKLSN

      **  Call Access Program for Bank Details - Title, Next Working
      **  Date

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE000048'    DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Initializing the LDA information

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
     C                   EVAL      DBPGM  = 'LE000048'
     C                   OUT       LDA

     C                   ENDSR

      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
