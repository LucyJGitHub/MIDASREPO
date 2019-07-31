     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Generate Collateral Events')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL009053 - Midas GL Generate Collateral Events               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01  - READ GLCOLLL10                                       *
      *    02  - CHAIN FCLTYL0                                        *
      *    03  - READ GLCOLLJ0                                        *
      *    04  - CHAIN SDCOTPL1                                       *
      *                                                               *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** Midas GL Generate Collateral Events
     FGLCOEVPD  O    E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Live Collateral Details by CollRef (Stat='C')
     FGLCOLLL10 IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Joined File for GLCOLLPD and GLCOLAPD
     FGLCOLLJ0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J_)
 
      ** Midas LE Facilities detail A record
     FFCLTYL0   IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Collateral types
     FSDCOTPL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure to hold Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Variables
     D PRetCode        S              7
     D POption         S              7
     D WRun            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  MAIN PROCEDURE                                               *
      *                                                               *
      *****************************************************************
 
      ** Access all records in GLCOLLL10
 
     C     *LOVAL        SETLL     GLCOLLL10
     C                   READ      GLCOLLL10                              01
 
     C                   DOW       *IN01 = *OFF
 
     C                   IF        CDVDAT >= BJDNWD OR CDEDAT >= BJDNWD OR
     C                             CDRVDT >= BJDNWD OR CDNVDT >= BJDNWD
 
      ** Generate events for the Collateral
 
     C     CDCOLT        CHAIN     SDCOTPL1                             04
     C                   IF        CDCOPT = 'P' AND CDCSEC = *BLANKS
     C                             AND *IN04 = *OFF AND CTRVLM <> 'D'
     C                             AND CTRVLM <> 'P'
     C                   EVAL      COVAMT = CDLAMT
     C                   ELSE
     C                   EVAL      COVAMT = CDVAMT
     C                   ENDIF
 
     C                   EVAL      COLAMT = CDLAMT
 
      ** Initialise fields to blanks and zeros
 
     C                   EVAL      COALLF = *BLANKS
     C                   EVAL      COMODS = *BLANKS
     C**********         EVAL      COFCUS = *ZEROS                                            CSD027
     C                   EVAL      COFCUS = *BLANKS                                           CSD027
     C                   EVAL      COFTYP = *ZEROS
     C                   EVAL      COFSEQ = *ZEROS
 
     C                   EXSR      SREvents
 
     C                   ENDIF
 
      ** Generate events for Facility allocations
 
     C                   IF        CDGNSP = 'S'
     C**********         IF        CDMODS = 'LE' AND CDFCUS <> *ZEROS                         CSD027
     C                   IF        CDMODS = 'LE' AND CDFCUS <> *BLANKS                        CSD027
     C                             AND CDFTYP <> *ZEROS  AND CDFSEQ <> *ZEROS
     C     CDCOLT        CHAIN     SDCOTPL1                             04
     C                   IF        CDCOPT = 'P' AND CDCSEC = *BLANKS
     C                             AND *IN04 = *OFF AND CTRVLM <> 'D'
     C                             AND CTRVLM <> 'P'
     C                   EVAL      COVAMT = CDLAMT
     C                   ELSE
     C                   EVAL      COVAMT = CDVAMT
     C                   ENDIF
 
     C                   EVAL      COLAMT = CDLAMT
     C                   EVAL      COALLF = 'Y'
     C                   EVAL      COMODS = CDMODS
     C                   EVAL      COFCUS = CDFCUS
     C                   EVAL      COFTYP = CDFTYP
     C                   EVAL      COFSEQ = CDFSEQ
 
     C     KSecFac       CHAIN     FCLTYL0                            02
     C                   IF        *IN02 = *ON
     C                   IN        LDA
     C                   EVAL      DBASE = 01
     C                   EVAL      DBFILE = 'FCLTYFM'
     C                   EVAL      DBKEY = 'COFCUS'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
 
     C                   EVAL      COFCCY = FCCY
 
      ** Generate all possible events
 
     C                   EXSR      SREvents
 
     C                   ENDIF
 
     C                   ELSE
 
     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0                               03
 
     C                   DOW       *IN03 = *OFF
 
     C**********         IF        J_CAMODS = 'LE' AND J_CAFCUS <> *ZEROS                     CSD027
     C                   IF        J_CAMODS = 'LE' AND J_CAFCUS <> *BLANKS                    CSD027
     C                             AND J_CAFTYP <> *ZEROS AND J_CAFSEQ <> *ZEROS
 
     C     CDCOLT        CHAIN     SDCOTPL1                             04
     C                   IF        CDCOPT = 'P' AND CDCSEC = *BLANKS
     C                             AND *IN04 = *OFF AND CTRVLM <> 'D'
     C                             AND CTRVLM <> 'P'
     C                   EVAL      COVAMT = J_CAACMT
     C                   ELSE
     C                   IF        J_CAACMT >= CDLAMT
     C                   EVAL      COVAMT = CDVAMT
     C                   ELSE
     C                   EVAL      COVAMT = (CDVAMT * J_CAACMT) / CDLAMT
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      COLAMT = J_CAACMT
     C                   EVAL      COALLF = 'Y'
     C                   EVAL      COMODS = J_CAMODS
     C                   EVAL      COFCUS = J_CAFCUS
     C                   EVAL      COFTYP = J_CAFTYP
     C                   EVAL      COFSEQ = J_CAFSEQ
 
     C     KSecFac       CHAIN     FCLTYL0                            02
     C                   IF        *IN02 = *ON
     C                   IN        LDA
     C                   EVAL      DBASE = 01
     C                   EVAL      DBFILE = 'FCLTYFM'
     C                   EVAL      DBKEY = 'COFCUS'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
 
     C                   EVAL      COFCCY = FCCY
 
     C                   EXSR      SREvents
 
     C                   ENDIF
 
     C                   READ      GLCOLLJ0                               03
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   READ      GLCOLLL10                              01
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREvents - Generate all possible Events                      *
      *                                                               *
      *****************************************************************
     C     SREvents      BEGSR
 
     C                   IF        CDVDAT >= BJDNWD
     C                   EVAL      COETYP = 'COST'
     C                   EVAL      COEDAT = CDVDAT
     C                   EVAL      COFREQ = *BLANKS
     C                   EXSR      SRWrGLCOEV
     C                   ENDIF
 
     C                   IF        CDEDAT >= BJDNWD
     C                   EVAL      COETYP = 'COMT'
     C                   EVAL      COEDAT = CDEDAT
     C                   EVAL      COFREQ = *BLANKS
     C                   EXSR      SRWrGLCOEV
     C                   ENDIF
 
     C                   IF        CDRVDT >= BJDNWD
     C                   EVAL      COETYP = 'CORN'
     C                   EVAL      COEDAT = CDRVDT
     C                   EVAL      COFREQ = CDRFRQ
     C                   EXSR      SRWrGLCOEV
     C                   ENDIF
 
     C                   IF        CDNVDT >= BJDNWD
     C                   EVAL      COETYP = 'COVL'
     C                   EVAL      COEDAT = CDNVDT
     C                   EVAL      COFREQ = CDVFRQ
     C                   EXSR      SRWrGLCOEV
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrGLCOEV - Write record to GLCOEVPD                        *
      *                                                               *
      *****************************************************************
     C     SRWrGLCOEV    BEGSR
 
     C                   EVAL      CORECI = 'D'
     C                   EVAL      COCREF = CDCREF
     C                   EVAL      COCNUM = CDCNUM
     C                   EVAL      COCOLT = CDCOLT
     C                   EVAL      CODESC = CDDESC
     C                   EVAL      COBRCA = CDBBRC
     C                   EVAL      COENTY = CDENTY
     C                   IF        COENTY = 'B'
     C                   EVAL      COENTT = CDBRCA
     C                   ELSE
     C                   IF        COENTY = 'C'
     C                   EVAL      COENTT = CDCMPY
     C                   ELSE
     C                   EVAL      COENTT = *BLANKS
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      COGNSP = CDGNSP
 
      ** Write to file GLCOEVPD
 
     C                   WRITE     GLCOEVD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KSecFac       KLIST
     C                   KFLD                    COFCUS
     C                   KFLD                    COFTYP
     C                   KFLD                    COFSEQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
