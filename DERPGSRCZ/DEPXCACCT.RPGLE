     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj ext ctlr for GL accounts')               *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCACCT - Projected Extract Controller for Accounts        *
      *                                                               *
      *  Function:  This module processes all accounts flagged for    *
      *             extraction and calls the module DEPXTACCT to      *
      *             write records to the projected extract files.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 20Aug02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *           (Re-compile)                                        *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
      /EJECT
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)
     FDEACEXPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(AC_)
 
      *****************************************************************
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
 
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXCPERDD
 
 
      * A/C CODES TO BE EXTRACTESD
     D***EX_ACCD         S              4S 0 DIM(500)                                         CGL029
     D EX_ACCD         S             10S 0 DIM(500)                                           CGL029
      * A/C NARRATIVES
     D EX_ACCN         S             16    DIM(500)
      * TRADE FINANCE EXPOSURE A/C
     D EX_TFCT         S              1    DIM(500)
 
     D ACCT          E DS                  EXTNAME(ACCNTAB)
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
 
     D                 DS
     D***W#ACID*                 1     18                                                     CGL029
     D W#ACID                  1     24                                                       CGL029
     D**W#CNUM**               1      6S 0                                                    CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#CCY                  7      9A
     D***W#ACOD*                10     13S 0                                                  CGL029
     D***W#ACSQ*                14     15S 0                                                  CGL029
     D***W#BRCA*                16     18A                                                    CGL029
     D  W#ACOD                10     19S 0                                                    CGL029
     D  W#ACSQ                20     21S 0                                                    CGL029
     D  W#BRCA                22     24A                                                      CGL029
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#EOB             1
     C**********         PARM                    I#TREF           20                          CGL029
     C                   PARM                    I#TREF           26                          CGL029
     C                   PARM                    I#RSRV           10                          CDE005
      *
      * EXTRACT ALL ACCOUNTS
      * OR EXTRACT A SINGLE ACCOUNT
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL ACCOUNTS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      ACCNTABF                               99    *
      *
      * Whilst accounts can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract open accounts
      *
     C     RECI          IFEQ      'D'
     C                   EXSR      EXTRCT
     C                   END
      *
      * Read the next record
      *
     C                   READ      ACCNTABF                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE ACCOUNT
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#ACID
     C     ACCNTK        KLIST
     C                   KFLD                    W#CNUM
     C                   KFLD                    W#CCY
     C                   KFLD                    W#ACOD
     C                   KFLD                    W#ACSQ
     C                   KFLD                    W#BRCA
     C     ACCNTK        CHAIN     ACCNTABF                           99        *
      *
      * If the account is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
      * Check if a/c code is to be extracted
      *
     C                   Z-ADD     1             I                 5 0
     C     ACOD          LOOKUP    EX_ACCD(I)                             99    *
 
     C     *IN99         CABEQ     '0'           N_EXTRCT
      *
      * Account description
      *
     C                   MOVEL     EX_ACCN(I)    W#TDES
      *
      * TF exposure account (Y/N)
      *
     C                   MOVEL     EX_TFCT(I)    W#TFCT
      *
      * Set the action code
      *
     C                   MOVEL     'I'           W#ACTN
      *
      * If extraction is for a Retail account and not a TI account,
      * then extract the latest shadow Ledger and Cleared Balances
      * from MEMOSL1
      *
     C                   IF         ATYP = 'R' AND W#TFCT <> 'Y'
      *
     C                   MOVEL     CNUM          W#CNUM
     C                   MOVEL     CCY           W#CCY
     C                   MOVEL     ACOD          W#ACOD
     C                   MOVEL     ACSQ          W#ACSQ
     C                   MOVEL     BRCA          W#BRCA
     C     ACCNTK        CHAIN     MEMOSMDF                           99        *
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     LDBLN         LDBL
     C                   Z-ADD     CLBLN         CLBL
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALLB     'DEPXTACCT'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM                    W#ACTN            1            * ACTION CODE
     C                   PARM      I#EXTT        W#EXTT            4
     C                   PARM      I#PH          W#PH              1
     C                   PARM      I#EOB         W#EOB             1
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#HCOD        W#HCOD            5 0
     C                   PARM      I#EXTD        W#EXTD            5 0
     C                   PARM      I#EVCD        W#EVCD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM                    PeriodEDT
     C                   PARM                    ACCT
     C                   PARM                    W#TDES           16            * ACTION CODE
     C                   PARM                    W#TFCT            1
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   EVAL      BUFFER = I#PH + 'ACCT' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + ACCT + I#RSRV                          CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'ACCT' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + ACCT
     C                   ENDIF                                                                CDE005
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C     N_EXTRCT      ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * This is a projections extract
 
     C                   MOVE      'P'           I#PH
 
      * Get Extract control information
 
      /COPY DECPYSRC,DEXTGTCT
 
 
      * LOAD UP A/C CODES TO BE EXTRACTED
 
     C                   Z-ADD     1             I                 5 0
     C                   READ      DEACEXPD                               99
     C     *IN99         DOWEQ     '0'
 
      * Get account code current details
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD             7        B:Return Cd
     C                   PARM      '*KEY    '    @OPTN             7
     C**********         PARM      AC_A5ACCD     @ACCD             4        I:Account Co      CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                      O:Format          CGL029
     C                   PARM      AC_A5ACCD     @ACCD            10                          CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
 
      * Only do extraction if a/c code found
 
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     A5ACCD        EX_ACCD(I)                     *
     C                   MOVEL     AC_A5ACCN     EX_ACCN(I)
     C                   MOVE      A5TFCT        EX_TFCT(I)
     C                   ADD       1             I
     C                   ENDIF
     C                   READ      DEACEXPD                               99
     C                   ENDDO
      *
      ** Determine if Data Export - Reservation ID is active                                  CDE005
     C                   CALL      'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD             7                          CDE005
     C                   PARM      '*VERIFY'     @OPTN             7                          CDE005
     C                   PARM      'CDE005'      @SARD             6                          CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANK                                                     CDE005
     C                   MOVEL     'Y'           CDE005            1                          CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE005
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
