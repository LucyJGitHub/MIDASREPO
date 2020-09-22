     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas EM Trade finance account balance update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Exposure Management Module                           *
      *                                                               *
      *  EM0452 - Trade Finance Account Balance Update                *
      *                                                               *
      *  Function:  This program update exposure management trade     *
      *   (COB)     finance details from account balance during the   *
      *             close of business.                                *
      *                                                               *
      *         This program can be runed only if feature CTI002 is   *
      *         active.                                               *
      *                                                               *
      *         Reads all records in file EMTFSAL1 and for each       *
      *         record, zeroise the field SAEXP, account exposure     *
      *                                                               *
      *         Retrieve exposure management currency details(BUCYCD) *
      *         from exposure management standing data file SDEXPML0. *
      *                                                               *
      *         Reads all records in file EMTFCBL0 for customer and   *
      *         account - there will only be one record for each      *
      *         Customer / Account code.                              *
      *                                                               *
      *         Using the customer and account code as key, read all  *
      *         records in file ACCNTL4 - a new file over ACCNT keyed *
      *         by customer and account code.                         *
      *                                                               *
      *         For each record read on file ACCNTL4 , check that the *
      *         currency matches the exposure management standing     *
      *         data currency (BUCYCD). If match, add ledger balance  *
      *         to work field. If does not match, call EM0020 to      *
      *         convert currency and then add converted amount to     *
      *         to work field. At end of read for the customer /      *
      *         account code, update EMTFCBL0 - CBEXP. If there are   *
      *         no records in ACCNTL4 for customer / account code,    *
      *         zeroise CBEXP in EMTFCBL0.                            *
      *                                                               *
      *         Using account code found in EMTFCBL0, retrieve the    *
      *         sub-line type from file EMTFSAL0. Using the sub-line  *
      *         type found, update file EMTFSLL0 - SLEXP with the     *
      *         account balance found from ACCNTL4. If this is the    *
      *         first time the sub-line is read, zeroise the exposure *
      *         balance on file EMTFSLL0  prior to updating with the  *
      *         ledger balance.                                       *
      *                                                               *
      *         Update the customer exposure on file EMDEXX5 - TFEX   *
      *         with the total exposure found for this customer.      *
      *                                                               *
      *         When reading EMTFSAL0 for account code code, there    *
      *         may be an "offsetting account code". Where this is    *
      *         the case, retrieve ledger balance from ACCNTL4 for    *
      *         the offsetting account code as before, and update     *
      *         files EMTFCBL0 - CBOFFB (using account code and       *
      *         customer number CNUM + ACOD); and EMDEXX5 - TFOF      *
      *         using customer number MCUN).                          *
      *                                                               *
      *  Called By: EMC0602  - COB                                    *
      *                                                               *
      *  Calls: AOSARDR0 - Midas AO switchable features               *
      *         ZASNMG   - Midas SY Access object message handling    *
      *         EM0010   - EM validate and calculate currencies       *
      *         AOCURRR0 - Midas AO currency codes                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD030956           Date 09Oct14               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG23967           Date 14May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 167618             Date 13Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI002  *CREATE    Date 21Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG23967 - Add Local Industry Code Field.                    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  167618 - Incorrect exposure shown for currencies with no     *
      *           decimal places.                                     *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    89         For EMTFCBPD reading                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  #ACCNTP - ACCNTL4  PROCESS                                   *
      *  CNVLDB - Converts Ledger balance in EM currency              *
      *  DIVLDB - Divide Ledger balance with decimal positions        *
      *  #UPDEXP - UPDATE EXPOSURE BALANCE IN VARIOUS FILES           *
      *  INZSLE - Zeroise the exposure balance                        *
      *  #UPDEMC - UPDATE EXPOSURE BALANCE IN VARIOUS FILES           *
      *  INZSLA - Zeroise the exposure balance                        *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      * Exposure Management Installation Control File
     FSDEXPML0  IF   E           K DISK    INFSR(*PSSR)
      *
     FACCNTL4   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC_)
     FEMTFCBL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FEMTFSAL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FEMTFSLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FEMDEX     UF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(EMDEXX5F)
     FSDBANKL0  IF   E           K DISK    INFSR(*PSSR)
     FCLINT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLINTCBF)
     FSDCTRYL0  IF   E           K DISK    INFSR(*PSSR)
      /COPY ZSRSRC,ZEXPSCLIL2
      /EJECT
      /COPY ZSRSRC,ZEXPSCLIL3
      /COPY EMCPYSRC,EM0010IILE
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D POWERA          S              7  0 DIM(7) CTDATA PERRCD(1)
     D WCUST           S              6
     D WTFEXA          S             15  0
     D*WACNO****       S              4  0                                                    CGL029
     D WACNO           S             10  0                                                    CGL029
     D WARSLT          S              1    DIM(26)
     D WTFEXC          S             15  0
     D WTFOFB          S             15  0
     D WTFEXX          S             15  0                                                    167618
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PSDS           SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      /EJECT
      *
      *CSTART
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      * Define work field SAR number field
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'EM0452'      DBPGM
     C                   OUT       LDA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *****************************************************************                     MD030956
      **Check*if*feature*CTI002*is*active.*****************************     I002            MD030956
      *****************************************************************                     MD030956
     C**********         MOVEL     'CTI002'      WUSARN                     I002            MD030956
     C**********         MOVEL     *BLANK        WUAPRC                     I002            MD030956
      * SAR switched on check - Standard Functions  *                                       MD030956
     C**********         CALL      'AOSARDR0'                           90  I002            MD030956
     C*****WUAPRC        PARM      WUAPRC        WQ0001            7        I002            MD030956
     C**********         PARM      '*VERIFY'     WQ0002            7        I002            MD030956
     C*****WUSARN        PARM      WUSARN        WQ0003            6        I002            MD030956
     C**********         PARM      *BLANK        WQ0004           76        I002            MD030956
      *****************************************************************     I002            MD030956
     C******IN90         IFEQ      '1'                                      I002            MD030956
      ** Check return code.                                                 I002            MD030956
     C*****WUAPRC        ORNE      *BLANK                                                   MD030956
     C******LOCK         IN        LDA                                                      MD030956
     C**********         Z-ADD     011           DBASE                                      MD030956
     C**********         MOVEL     'CTI002  '    DBFILE                                     MD030956
     C**********         MOVEL     *BLANK        DBKEY                                      MD030956
     C**********         OUT       LDA                                                      MD030956
     C**********         EXSR      *PSSR                                                    MD030956
     C**********         ENDIF                                                              MD030956
      *
      *
      * Feature CTI002 is active
      *
      *
      ** Get Bank Details for today's run date
     C                   READ      SDBANKL0                               77
     C     *IN77         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     009           DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     'CTI002'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *****************************************************
      *                                                                     I002
     C                   EXSR      INZSLA
      * Retrieve exposure management currency details from exposure         I002
      * management standing data file SDEXPML0                              I002
      *
     C     *LOVAL        SETLL     SDEXPML0
     C                   READ      SDEXPML0                               90
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'SDEXPMPD'    DBFILE
     C                   MOVEL     'EXPM'        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALL      'AOCURRR0'                                                 167618
     C                   PARM      *BLANKS       @RTCD                                        167618
     C                   PARM      '*KEY   '     @OPTN                                        167618
     C                   PARM      BUCYCD        @AJCD                                        167618
     C     SDCURR        PARM      SDCURR        DSSDY                                        167618
     C     @RTCD         IFNE      *BLANK                                                     167618
     C     *LOCK         IN        LDA                                                        167618
     C                   Z-ADD     012           DBASE                                        167618
     C                   MOVEL     'SDCURRPD'    DBFILE                                       167618
     C                   MOVEL(P)  @RTCD         DBKEY                                        167618
     C                   OUT       LDA                                                        167618
     C                   EXSR      *PSSR                                                      167618
     C                   ELSE                                                                 167618
     C                   MOVE      A6NBDP        NBDPBU            1 0                        167618
     C                   ENDIF                                                                167618
      *
     C     KTFCB         KLIST
     C                   KFLD                    CBCUST
     C                   KFLD                    CBACNO
     C                   MOVEL     *LOVAL        CBCUST
     C                   Z-ADD     0             CBACNO
     C     KTFCB         SETGT     EMTFCBL0
     C                   READ      EMTFCBL0                               89
      *
      ** Do until end of file.
      *
     C     *IN89         DOWEQ     '0'
      *
      *  Customer breakdown
      *
     C     CBCUST        IFNE      WCUST
     C     WCUST         IFNE      *BLANKS
     C                   EXSR      #UPDEMC
     C                   ENDIF
     C                   MOVEL     CBCUST        WCUST
     C                   Z-ADD     0             WTFEXC
     C                   Z-ADD     0             WTFOFB
     C                   ENDIF
      *
     C                   Z-ADD     CBACNO        WACNO
     C                   EXSR      #ACCNTP
      *
     C                   EXSR      #UPDEXP
     C                   READ      EMTFCBL0                               89
     C                   ENDDO
      *
     C                   EXSR      #UPDEMC
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *     ACCNTL4 PROCESS SUBROUTINE                                   *
      *                                                                  *
      *     CALLED FROM :-  MAIN PROCESSING                              *
      *     CALLS SUBROUTINE :- CNVLDB                                   *
      *                                                                  *
      ********************************************************************
      *
     C     #ACCNTP       BEGSR
      *
     C     KLACCNT       KLIST
     C                   KFLD                    AC_CNUM
     C                   KFLD                    AC_ACOD
      *
     C                   MOVEL     CBCUST        AC_CNUM
     C                   Z-ADD     WACNO         AC_ACOD
     C                   Z-ADD     0             WTFEXA
     C     KLACCNT       SETLL     ACCNTL4
     C     KLACCNT       READE     ACCNTL4                                88
      *
      ** Do until Customer / Account breakdown
      *
     C     *IN88         DOWEQ     '0'
      *
     C                   EXSR      DIVLDB
     C     AC_CCY        IFEQ      BUCYCD
     C*****              ADD       AC_LDBL       WTFEXA                                       167618
     C                   ADD       XLDBL         WTFEXA                                       167618
     C                   ELSE
     C                   EXSR      CNVLDB
     C                   ENDIF
      *
     C     KLACCNT       READE     ACCNTL4                                88
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      * ********************************************************************
      * Subroutine CNVLDB                                                  *
      * Converts Ledger balance to equivalent exposure management currency *
      *                                                                    *
      *     Called from :-  #ACCNTP                                        *
      *     Calls programs   :- EM0010                                     *
      *                                                                    *
      * -------------------------------------------------------------------*
     C     CNVLDB        BEGSR
      *
      * CLEAR DATA STRUCTURE
     C                   CLEAR                   P#0010
      *
      * Set up parameter list
     C                   Z-ADD     BJRDNB        P#TODT
     C                   Z-ADD     BJRDNB        P#FRDT
      *
     C                   MOVEL     AC_CCY        P#FRCY
     C                   Z-ADD     AC_LDBL       P#FRAM
      *
     C                   MOVEL     BUCYCD        P#TOCY
     C                   Z-ADD     0             P#TOAM
     C                   Z-ADD     0             P#RATE
      *
      * Call EM0010 for conversion
     C                   CALL      'EM0010'
     C                   PARM                    P#0010
      *
      * Monitor return code
     C     P#RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     004           DBASE
     C                   MOVEL     'EM0010  '    DBFILE
     C                   MOVEL     'CTI002'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C     NBDPBU        ADD       1             M                 1 0                        167618
     C     P#TOAM        DIV(H)    POWERA(M)     WTFEXX                                       167618
     C                   ADD       WTFEXX        WTFEXA                                       167618
     C*****              ADD       P#TOAM        WTFEXA                                       167618
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      *                                                                  *
      *     UPDATE EXPOSURE BALANCE IN VARIOUS FILES                     *
      *                                                                  *
      *     CALLED FROM :-  MAIN PROCESSING                              *
      *                                                                  *
      ********************************************************************
      *
     C     #UPDEXP       BEGSR
      *
      * ACCOUNT EXPOSURE
      *
      * Using account code found in EMTFCBL0, update file EMTFSAL1 - SAEXP  I002
      *
     C                   Z-ADD     CBACNO        SAACOD
     C     SAACOD        CHAIN     EMTFSAL1                           84
      *
     C     *IN84         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     003           DBASE
     C                   MOVEL     'EMTFSAPD'    DBFILE
     C                   MOVEL     SAACOD        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     WTFEXA        WCBEXP           15 0
     C                   Z-ADD     0             WTFEXA
      * Offsetting account code process
      *
     C     SAOFFA        IFNE      0
     C                   Z-ADD     SAOFFA        WACNO
     C                   EXSR      #ACCNTP
     C                   ENDIF
      *
      ** Update EMTFCBL0 - CBEXP/CBOFFB
      *
     C     KTFCB         CHAIN     EMTFCBL0                           71
     C     *IN71         IFEQ      '0'
      * Exposure scaling
     C     CBSCL         IFNE      *BLANK
     C                   MOVEL     CBSCL         @DELTP
     C                   Z-ADD     WCBEXP        @SCAMT
     C                   MOVEL     RUNDAT        @TDATE
     C                   EXSR      SCALE
     C                   Z-ADD     @SCAMT        WCBEXP
     C                   ENDIF
     C                   Z-ADD     WCBEXP        CBEXP
     C                   Z-ADD     WTFEXA        CBOFFB
     C                   UPDATE    EMTFCB                               70
     C     *IN70         IFEQ      '0'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF
      * EMTFSAL1 Update
     C     SAACOD        CHAIN     EMTFSAL1                           84
     C     *IN84         IFEQ      '0'
     C                   ADD       WCBEXP        SAEXP
     C                   ADD       CBLIM         SALIM
     C                   UPDATE    EMTFSA                               70
     C     *IN70         IFEQ      '0'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
      *
     C                   ENDIF
      *
      * SUB-LINE EXPOSURE
      *
      * Using sub-line type found in EMTFSAL1, update file EMTFSLL0 - SLEXP I002
      *
     C     SATYPE        CHAIN     EMTFSLL0                           87
      *
     C     *IN87         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     005           DBASE
     C                   MOVEL     'EMTFSLPD'    DBFILE
     C                   MOVEL     SATYPE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EXSR      INZSLE
     C                   ADD       WCBEXP        SLEXP
     C                   UPDATE    EMTFSL                               70
     C     *IN70         IFEQ      '0'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      * CUSTOMER EXPOSURE
      *
     C                   ADD       WCBEXP        WTFEXC
     C                   ADD       CBOFFB        WTFOFB
      *
     C                   ENDSR
      *
      * ********************************************************************
      * Subroutine INZSLE                                                  *
      * Zeroise the exposure balance (SLEXP) on file EMTFSLL0 when the     *
      *         sub-line is read the first time                            *
      *                                                                    *
      *     Called from :-  #UPDEXP                                        *
      *                                                                    *
      * -------------------------------------------------------------------*
     C     INZSLE        BEGSR
      *
     C                   Z-ADD     1             X                 2 0
      * Search SLTYPE in array WARSLT, if found zeroise already done
     C     SLTYPE        LOOKUP    WARSLT                                 50
     C     *IN50         CABEQ     '1'           TINZSLE
      *
      * Load SLTYPE in array and zeroise SLEXP
     C                   Z-ADD     1             X
     C     ' '           LOOKUP    WARSLT(X)                              50
     C     *IN50         CABEQ     '0'           TINZSLE
     C                   MOVEL     SLTYPE        WARSLT(X)
     C                   Z-ADD     0             SLEXP
      *
     C     TINZSLE       ENDSR
      *
      ********************************************************************
      *                                                                  *
      *     UPDATE EXPOSURE BALANCE IN EMDEXX5                           *
      *                                                                  *
      *     CALLED FROM :-  MAIN PROCESSING                              *
      *                                                                  *
      ********************************************************************
      *
     C     #UPDEMC       BEGSR
      *
     C                   MOVEL     WCUST         MCUN                       I002
      *
      * Get Account Officer, Industry Code, Country Code, Region for chain
      * to EMDEX in order to update correct EMDEXX5 record.
      *
     C     KYCLNT        KLIST
     C                   KFLD                    MCUN
     C                   KFLD                    RCDT
     C                   MOVEL     'A'           RCDT
      *
      ** If cannot find record in CLINT, do not monitor as there will not
      *  always be one there
     C     KYCLNT        CHAIN     CLINT                              85
      *
     C     *IN85         IFEQ      *OFF
      *
      * Now get region code from SDCTRYL0 using country code as key
     C     CCTZ          CHAIN     SDCTRYL0                           85
     C     *IN85         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     999           DBASE
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   MOVEL     CCTZ          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Use full key to chain to EMDEX and update with TFEX
     C     KYDEX5        KLIST
     C                   KFLD                    ACOC
     C                   KFLD                    MCUN
     C**********         KFLD                    LIND                                       BUG23967
     C                   KFLD                    LOIC                                       BUG23967
     C                   KFLD                    A4RGCD
     C                   KFLD                    CCTZ
      *
      * Now chain to file
     C     KYDEX5        CHAIN     EMDEX                              85
      *
     C     *IN85         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     007           DBASE
     C                   MOVEL     'EMDEXX5'     DBFILE
     C                   MOVEL     MCUN          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     WTFEXC        TFEX
     C                   Z-ADD     WTFOFB        TFOF
     C                   UPDATE    EMDEXX5F
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      *                                                                  *
      *     DIVIDE THE AMOUNT WITH THE NUMBER OF DECIMAL POSITIONS       *
      *                                                                  *
      *     CALLED FROM :-  ACCNTL4                                      *
      *     Calls programs   :- AOCURRR0                                 *
      *                                                                  *
      ********************************************************************
      *
     C     DIVLDB        BEGSR
      **
      ** Divide posting amount by the number of decimal positions
      ** of in currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      AC_CCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     010           DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL(P)  @RTCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C     A6NBDP        ADD       1             M                 1 0
     C     1             DIV       POWERA(M)     DECP             13 8
     C*****AC_LDBL       MULT      DECP          AC_LDBL                                      167618
     C     AC_LDBL       MULT      DECP          XLDBL            15 0                        167618
     C                   END
     C                   ENDSR
      *
      * ********************************************************************
      * Subroutine INZSLA                                                  *
      * Zeroise the exposure balance (SAEXP) on file EMTFSAL1 previous     *
      *         to update                                                  *
      *                                                                    *
      *     Called from :-  Main process                                   *
      *                                                                    *
      * -------------------------------------------------------------------*
     C     INZSLA        BEGSR
     C     *LOVAL        SETGT     EMTFSAL1
     C                   READ      EMTFSAL1                               83
      *
      ** Do until end of file.
      *
     C     *IN83         DOWEQ     '0'
     C                   Z-ADD     0             SAEXP
     C                   Z-ADD     0             SALIM
     C                   UPDATE    EMTFSA                               70
     C     *IN70         IFEQ      '0'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
     C                   READ      EMTFSAL1                               83
     C                   ENDDO
      *
     C                   ENDSR
      *
      ********************************************************************
      *
      /COPY ZSRSRC,ZEXPSCLIL1
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
      ************ END PROGRAM *******************************************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
