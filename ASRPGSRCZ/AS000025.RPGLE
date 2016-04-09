     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AS Updates Historic Market Data with delay')
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000025 - Updates Historic Market Data with delayed price.  *
      *                                                               *
      *  Called By: ASC00019 - Historic Market Data Collection (CLP)  *
      *                                                               *
      *  Function:  This program updates the historic collected data  *
      *             with the new computed market value using the      *
      *             delayed price.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAS008   *CREATE   Date 11May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS008 - Delayed Hedge Assessment                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR     - Initialization Processing                        *
      * SRCONV     - Retrieve market value and converts them to base  *
      *              currency from different modules.                 *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEMKVDL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Delayed Market Values Using Net-Treasury-Prices
 
     FPRICM     IF   E           K DISK    INFSR(*PSSR)
     ** Midas SE Market Prices by Security Shortname and Value Date
 
     FASSEHML0  UF   E           K DISK    RENAME(ASSEHMD0:ASSEHMDX)
     F                                     PREFIX(S) INFSR(*PSSR)
     FASSEHML2  UF   E           K DISK
     F
      ** Midas AS Securities Historic Market Data File
      ** by Security shortname and Value date - LIVE
 
     ******************************************************************
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
      *
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1
     D PRetCode        S              7A
     D POption         S              7A
     D PCurr           S              3A
     D WToMdin         S              1A
     D WToNbdp         S              1  0
     D WToExcr         S             13  8
     D WFrAmnt         S             15  0
     D WFrNbdp         S              1  0
     D WFrCcy          S              3A
     D WSEUrpl         S             15  0
     D PZAmtCo         S             15  0
     D ZXXMVAL         S             15  0
     D ZXXMVCA         S             15  0
     D SEVDAT          S              5  0
 
      ** Parameters for ZCONVZ1
     D PZInAmt         S             15  0
     D PZExchR         S             13  8
     D PZMdin          S              1A
     D PZCcyFr         S              3A
     D PZCcyTo         S              3A
     D PZDecFr         S              1  0
     D PZDecTo         S              1  0
     D P#OutA          S             15  0
 
     ******************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   READ      SEMKVDL0                               01
 
     C     *IN01         DOWEQ     '0'
     C                   EVAL      XXCHTP = *BLANKS
     C                   EVAL      XXLCD = 0
     C                   EVAL      XXMVAL = 0
     C                   EVAL      XXMVCA = 0
     C                   EVAL      XXMRAT = 0
 
     C                   IF        SECCY <> BJCYCD
     C                   Z-ADD     SEURPL        WFrAmnt
     C                   MOVE      SECCY         WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WSeUrpl
     C                   EVAL      SEURPL = WSeUrpl
     C                   ENDIF
 
     C                   Z-ADD     SEURPL        ZXXMVAL
 
     C     SEEFFD        IFEQ      SENDTA
     C                   Z-ADD     SEEFFD        SEVDAT
     C                   ELSE
     C                   Z-ADD     SENDTA        SEVDAT
     C                   ENDIF
 
     C                   EVAL      ZXXMVCA = 0
     C                   EVAL      SXXMVCA = 0
 
     C     SEMKEY        SETGT     ASSEHML0
     C     SEMKY1        READE     ASSEHML0                               02
 
     C                   IF        *IN02 = '0'
     C     ZXXMVAL       SUB       SXXMVAL       ZXXMVCA
     C                   ENDIF
 
     C     SEMKEY        SETLL     ASSEHML0
     C     SEMKY1        READPE    ASSEHML0                               03
 
     C                   IF        *IN03 = '0'
     C     SXXMVAL       SUB       ZXXMVAL       SXXMVCA
     C                   UPDATE    ASSEHMDX
     C                   ENDIF
 
     C     SEMKEY        CHAIN     ASSEHML2                           04
 
     C     *IN04         IFEQ      '0'
     C                   EVAL      XXDTAT = 'A'
     C                   EVAL      XXRECI = 'D'
     C                   EVAL      XXCHTP = 'A'
     C                   EVAL      XXLCD = BJRDNB
     C                   EVAL      XXCCY = SECCY
     C                   Z-ADD     ZXXMVCA       XXMVCA
     C                   Z-ADD     ZXXMVAL       XXMVAL
 
     C                   IF        SEDTTP ='R'
     C     SESESN        CHAIN     PRICM
     C                   IF        %FOUND(PRICM)
     C                   ADD       PRLQPR        PPRC
     C                   ADD       PRCRSK        PPRC
     C                   Z-ADD     PPRC          XXMRAT
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    ASSEHMD0
     C                   ENDIF
 
     C                   READ      SEMKVDL0                               01
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONV    - Retrieve market value and converts them to base  *
      *              currency from different modules.                 *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: ZCONVZ1                                               *
      *                                                               *
      *****************************************************************
     C     SRCONV        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WFrCcy        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database Error
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBASE =  006
     C                   EVAL      DBKEY =  WFrCcy
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   Z-ADD     0             PZAmtCo
     C                   MOVE      A6NBDP        WFrNbdp
     C                   MOVE      A6MDIN        WToMdin
     C                   MOVE      A6SPRT        WToExcr
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      WFrAmnt       PZInAmt
     C                   PARM      WToExcr       PZExchR
     C                   PARM      WToMdin       PZMdin
     C                   PARM      WFrCcy        PZCcyFr
     C                   PARM      BJCYCD        PZCcyTo
     C                   PARM      WFrNbdp       PZDecFr
     C                   PARM      WToNbdp       PZDecTo
     C     PZAmtCo       PARM                    P#OutA
 
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     SEMKEY        KLIST
     C                   KFLD                    SEHGID
     C                   KFLD                    SESESN
     C                   KFLD                    SEBRCA
     C                   KFLD                    SEBOKC
     C                   KFLD                    SEMKTI
     C                   KFLD                    SEBHTV
     C                   KFLD                    SEVDAT
 
     C     SEMKY1        KLIST
     C                   KFLD                    SEHGID
     C                   KFLD                    SESESN
     C                   KFLD                    SEBRCA
     C                   KFLD                    SEBOKC
     C                   KFLD                    SEMKTI
     C                   KFLD                    SEBHTV
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access currency details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      BJCYCD        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = BJCYCD
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   MOVE      A6MDIN        WToMdin
     C                   MOVE      A6NBDP        WToNbdp
     C                   MOVE      A6SPRT        WToExcr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
