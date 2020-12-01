     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Historic Posns Comparison and selection')     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DE0220 - Historic Positions Comparison and Selection         *
      *                                                               *
      *  Function:  This module is called by DEC0220. This module     *
      *             willl filter out new and changed records checking *
      *             that the Maturity date of the transaction is      *
      *             not prior to Revenue Take-on start of month       *
      *             date else it will write the record to DENPOSNPD   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208221 - Positions for FEES should use Interest Accrued,     *
      *           INAC, instead of Interest paid to date, IPRD.       *
      *           This is because INAC is calculated for each rec.    *
      *           Positions for FEES should be changed from interest  *
      *           to fees ONLY for calculated fees, ie ACIN = Y       *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      ** DE Historic Positions File
     FDEHPOSNPD IF   E           K DISK
 
      ** DE Historic Positions File
     FDEOPOSNL1 IF   E           K DISK    PREFIX(OL_)
     F                                     RENAME(DEPOSNP0:DEPOSNP1)
 
      ** DE New Positions File
     FDENPOSNPD O    E           K DISK    PREFIX(NW_)
     F                                     RENAME(DEPOSNP0:DEPOSNP2)
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** EXTRACT CONTROL DATA
 
     D DEHPOSN       E DS                  EXTNAME(DEHPOSNPD)
      ** External Data Structure for Historic Positions Details
 
     D DEOPOSN       E DS                  EXTNAME(DEHPOSNPD) PREFIX(OL_)
      ** External Data Structure for Old Historic Positions Details
 
     D DENPOSN       E DS                  EXTNAME(DENPOSNPD) PREFIX(NW_)
      ** External Data Structure for New Positions Details
 
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
     C                   KFLD                    K#ASLI            1
     C                   KFLD                    K#IACD            5 0
 
     C                   READ      DEHPOSNPD                              89
 
     C                   DOW       *IN89 = *Off
      *
      ** If Full Historic requested write record straight to DENPOSNPD
     C                   IF        DEFHDC = *Blank
     C**********         IF        P#IACD >= WSOM                                             208221
     C                   CLEAR                   DENPOSN
     C                   MOVEL     DEHPOSN       DENPOSN
 
     C     I#TYPE        IFEQ      'FEES'
     C                   EXSR      FEERECORD
     C                   ENDIF
 
     C                   WRITE     DEPOSNP2
     C**********         ENDIF                                                                208221
      *
     C                   ELSE
      *
      ** Set key for chain to DEOPOSNL1
     C                   EVAL      K#MOD = P#MOD
     C                   EVAL      K#TREF = P#TREF
     C                   EVAL      K#ASLI = P#ASLI
     C                   EVAL      K#IACD = P#IACD
      *
      ** Check for record on file
     C     K#OLD         CHAIN     DEOPOSNL1                          88
      *
      ** If record exists check whether it has changed. If it has and Interest Accrual Control
      ** Date is after Revenue Take-on Start of month write record to DENTRANPD
     C                   IF        *IN88 = *Off
     C**********         IF        DEHPOSN <> DEOPOSN and P#IACD >= WSOM                      208221
     C                   IF        DEHPOSN <> DEOPOSN                                         208221
     C                   CLEAR                   DENPOSN
     C                   MOVEL     DEHPOSN       DENPOSN
 
     C     I#TYPE        IFEQ      'FEES'
     C                   EXSR      FEERECORD
     C                   ENDIF
 
     C                   WRITE     DEPOSNP2
     C                   ENDIF
 
     C                   ELSE
      *
      ** If Date is after Revenue Take-on Start of month write record to DENTRANPD
     C**********         IF        P#IACD >= WSOM                                             208221
     C                   CLEAR                   DENPOSN
     C                   MOVEL     DEHPOSN       DENPOSN
 
     C     I#TYPE        IFEQ      'FEES'
     C                   EXSR      FEERECORD
     C                   ENDIF
 
     C                   WRITE     DEPOSNP2
     C**********         ENDIF                                                                208221
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      DEHPOSNPD                              89
     C                   ENDDO
 
     C                   EVAL      *INLR = *On
     C                   RETURN
     C
 
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     FEERECORD     BEGSR
 
      * Only change details if a calculated fee transaction                                   208221
                                                                                              208221
     C     P#ACIN        IFEQ      'Y'                                                        208221
     C*******************Z-ADD     P#IPRD        NW_P#FEAC                                    208221
     C                   Z-ADD     P#INAC        NW_P#FEAC                                    208221
     C                   Z-ADD     0             NW_P#IPRD
     C                   Z-ADD     0             NW_P#AITC
     C                   Z-ADD     0             NW_P#INAC
     C                   Z-ADD     0             NW_P#INPR
     C                   MOVEL     'Y'           NW_P#ACFE                                    208221
     C                   ENDIF                                                                208221
      *
     C                   ENDSR
      *
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#TYPE            4
 
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
(c) Finastra International Limited 2001
