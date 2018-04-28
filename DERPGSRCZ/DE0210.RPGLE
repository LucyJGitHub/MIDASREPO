     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Historic Trans Comparison and selection')     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DE0210 - Historic Transactions Comparison and Selection      *
      *                                                               *
      *  Function:  This module is called by DEC0210 which creates    *
      *             an OPNQRYF of new and changed records from        *
      *             the day's processing. This module will check      *
      *             that the Maturity date of the transaction is      *
      *             not prior to Revenue Take-on start of month       *
      *             date else it will write the record to DENTRANPD   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 22Aug02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CDE005 - Data Export - Reservation ID (Recompile)            *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Changes identified during alpha site                *
      *           written to DEOTRANPD before.                        *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      ** DE Historic Transactions File
     FDEHTRANPD IF   E           K DISK
 
      ** DE Historic Transactions File
     FDEOTRANL1 IF   E           K DISK    PREFIX(OL_)
     F                                     RENAME(DETRANP0:DETRANP2)
 
      ** DE New Transactions File
     FDENTRANPD O    E           K DISK    PREFIX(NW_)
     F                                     RENAME(DETRANP0:DETRANP1)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** EXTRACT CONTROL DATA
 
     D DEHTRAN       E DS                  EXTNAME(DEHTRANPD)
      ** External Data Structure for Historic Transaction Details
 
     D DEOTRAN       E DS                  EXTNAME(DEHTRANPD) PREFIX(OL_)
      ** External Data Structure for Old Historic Transaction Details
 
     D DENTRAN       E DS                  EXTNAME(DENTRANPD) PREFIX(NW_)
      ** External Data Structure for New Transaction Details
 
     D**  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D**  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D W#DATE          DS             6
     D Bday                    1      2
     D Aday                    3      4
 
     D K#TREF          S             26A                                                      CGL029
                                                                                              CGL029
     C     K#OLD         KLIST
     C                   KFLD                    K#MOD             2
     C**********         KFLD                    K#TREF           20                          CGL029
     C                   KFLD                    K#TREF                                       CGL029
 
     C                   READ      DEHTRANPD                              89
 
     C                   DOW       *IN89 = *Off
      *
      ** Check that transaction has not matured before Revenue Take-on Start of Month
      ** and write record to DENTRANPD
     C**********         IF        T#MDAT = 0 or                                              208221
     C**********                   T#MDAT <> 0 and T#MDAT >= WSOM                             208221
      ** If Full Historic requested write record straight to DENTRANPD
     C                   IF        DEFHDC = *Blank
     C                   CLEAR                   DENTRAN
     C                   MOVEL     DEHTRAN       DENTRAN
     C                   WRITE     DETRANP1
     C**********         ENDIF                                                                208221
      *
     C                   ELSE
      *
      ** Set key for chain to DEOTRANL1
     C                   EVAL      K#MOD = T#MOD
     C                   EVAL      K#TREF = T#TREF
      *
      ** Check for record on file
     C     K#OLD         CHAIN     DEOTRANL1                          88
      *
      ** If record exists check whether it has changed.
     C                   IF        *IN88 = *Off
     C                   IF        DEHTRAN <> DEOTRAN
     C                   CLEAR                   DENTRAN
     C                   MOVEL     DEHTRAN       DENTRAN
 
     C                   WRITE     DETRANP1
     C                   ENDIF
 
     C                   ELSE
      *
      ** Write record to DENTRANPD
     C                   CLEAR                   DENTRAN
     C                   MOVEL     DEHTRAN       DENTRAN
 
     C                   WRITE     DETRANP1
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      DEHTRANPD                              89
     C                   ENDDO
 
     C                   EVAL      *INLR = *On
     C                   RETURN
     C
 
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      **  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Read Extract Control Data
 
     C     *DTAARA       DEFINE                  DEEXTCTL
     C                   IN        DEEXTCTL
      *
      ** Convert Revenue Take-on Midas day number to a date
     C                   Z-ADD     DETKON        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         W#DATE
      *
      ** Calculate Start of month day number
     C                   IF        BJDFIN = 'D'
     C                   MOVE      '01'          Bday
     C                   ELSE
     C                   MOVE      '01'          Aday
     C                   ENDIF
      *
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WSOM              5 0
      *
     C                   ENDSR
      *
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      BJDFIN        ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DATE TO DAY NUMBER
      **********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM      BJDFIN        ZDATFM            1
     C                   PARM      *BLANK        ErrorFlag         1
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
