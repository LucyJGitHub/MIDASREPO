     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer loans input database Controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LECLIPUPC - Loans input database update controller           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 MD030621           Date 26Feb15               *
      *                 AR868380           Date 11Jun13               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 245227             Date 27Feb07               *
      *                 BUG13843           Date 02May07               *
      *                 GBO020             Date 07Sep06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG6686            Date 24Jan05               *
      *                 CLE035             Date 22Sep03               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 TDA023             Date 22Mar04               *
      *                 201589             Date 03Jan02               *
      *                 CDE005             Date 23Sep02               *
      *                 CAP074  *CREATE    Date 22May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LECLIPUC01,LECLIPUC02,LECLIPUC03   *
      *  MD030621 - Pass @DEPI (Decrease Principal indicator) for PDCL*
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting ß24c             *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245273 - Added parameters to LECLIPUPD call.                 *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  245227 - Added fields WAUTOA & WAUTOY to LECLIPUPD           *
      *  GBO020 - Debt Classification by Assets.                      *
      *           Added hook LECLIPU014 (in lieu of LECLIPU007)       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CER001 - LUx Upgrade to MidasPlus                            *
      *  BUG6686- Added a read before the DELETE operation to re-     *
      *           establish the record lock.                          *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits.       *
      *           (Recompile)                                         *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:LECLIPU011,LECLIPU007            *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  201589 - Change to check a new locking dataarea LECLIPLCK    *
      *           to determine whether this DBU is already active.    *
      *  CDE005   Reservation ID                                      *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
 
     FLEVCLILPD UF   E             DISK
     F                                     COMMIT
     FLEVCLIKPD UF   E             DISK
     F                                     PREFIX(K_)
     F                                     COMMIT
     FLEVCLILL1 UF   E           K DISK
     F                                     RENAME(LEVCLILD0:LEVCLILD1)
     FLEVCLIKL1 UF   E           K DISK
     F                                     RENAME(LEVCLIKD0:LEVCLIKD1)
     FLEVCLLX1L0UF A E           K DISK                                                       CER001
     F                                     RENAME(LEVCLIPF6:VCLIPY6)                          CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
      ** Extension valid file                                                                 CER001
      *                                                                                       CER001
     FLEVECLX1PDUF A E           K DISK                                                       CER001
     F                                     RENAME(LEVECLIPF6:VECLIPD6)                        CER001
      *                                                                                       CER001
      ** Extension valid error file                                                           CER001
      *                                                                                       CER001
     FLEVECLILPDO    E             DISK
     F                                     RENAME(LEVCLILD0:LEVCLILERR)
     FLEVECLIKPDO    E             DISK
     F                                     RENAME(LEVCLIKD0:LEVCLIKERR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIPU010
 
      ** Valid File                                                                          LLN022A
      *                                                                                      LLN022A
     FLEVCLIPY0 UF A E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(LEVCLIX0 : VCLIPD0)                        LLN022A
      *                                                                                      LLN022A
      ** Error File                                                                          LLN022A
      *                                                                                      LLN022A
     FLEVECLIPX0UF A E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(LEVCLIX0 : VECLIPD0)                       LLN022A
                                                                                             LLN022A
      *****************************************************************
      *  +--------------------------------------+
      *    Automatically included D-specs        
      *    ==============================        
      *  +--------------------------------------+
      *
      *  Standard D-specs
      *  ================
      *
      *  The following /COPY line includes the LDA layout,
      *  the copyright array definition,
      *  and the following named constants:
      *     True       logical = *on (for indcator processing)
      *     False      logical = *off (for indcator processing)
      *     DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      *                                     handler)
      *  and the following variables:
      *     RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      * Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      * Program Status Data Structure
      * =============================
      * The following /COPY line includes all the defined fields in the
      * PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      *------------------------------------------------------------------------
      * The following /COPY line includes the definitions for fields
      * used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      *------------------------------------------------------------------------
 
      * +--------------------------------------+
      *   End of automatically included D-specs 
      *   ===================================== 
      * +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in CLIP API update')
 
      *****************************************************************
 
      * Externally described data structure for valid loan format CL
     D LECLIL        E DS                  EXTNAME(LEVCLILPD)
 
      * Externally described data structure for valid loan format CK
     D LECLIK        E DS                  EXTNAME(LEVCLIKPD)
     D                                     PREFIX(K_)
 
     D LECLIPUPC       DS             1    DTAARA(LECLIPUPC)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * External data structure for SAR details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short date structure
 
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      * External DS for loans details
 
     D SDLENO        E DS                  EXTNAME(SDLENOPD)
      * Loan number ranges file
      *                                                                                       CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      ** External DS for module details                                                       CER001
      *                                                                                       CER001
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLLX1PD)                                CER001
      *                                                                                       CER001
      ** DS Customer Loans LUX Valid File                                                     CER001
      *                                                                                       CER001
     D CLIPFilFmtEx  E DS                  EXTNAME(LECLX1PD)                                  CER001
      *                                                                                       CER001
      ** DS Customer Loans - LU Ext. File                                                     CER001
      *                                                                                       CER001
 
     D Object          S             10A   INZ('LECLIPUPC')
     D LockObj         S             10A   INZ('LECLIPLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D @Timestamp      S             26Z
 
      * Dummy message ID and message file fields for use on the calls to
      * ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
 
      * +--------------------------------------+
      *   End of D-specs                        
      *   ==============                        
      * +--------------------------------------+
 
      * +----------------------------------------+
      *   Hook for non-core D-specs (all types)   
      *   also any I-specs (if necessary)         
      *   =====================================   
      * +----------------------------------------+
      /COPY WNCPYSRC,LECLIPU011
      *
     D ValidCLIPExt  E DS                  EXTNAME(LEVCLIPX0)                                LLN022A
                                                                                             LLN022A
      * +--------------------------------------+
      *   Rename fields                         
      *   =============                         
      * +--------------------------------------+
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
      /COPY WNCPYSRC,LECLIPU001
 
      * Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APCLIPDTQ'
 
      *------------------------------------------------------------------------
      * The following /COPY line includes a check for whether there
      * are messages on the server/updater data queue, and sends a 'GO'.
      * message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      *------------------------------------------------------------------------
 
      * Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APCLIPDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      * Wait for data queue prompt
      * Server program will send data queue entry when record is
      * written to the valid transactions file
B001 C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
B002 C     DtqDta        IFEQ      'GO'
      * Lock allocation data area
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      /COPY WNCPYSRC,LECLIPU002
 
      * Position file cursor to start of file to prevent problems on
      * later calls
     C     1             SETLL     LEVCLILPD
     C     1             SETLL     LEVCLIKPD
 
      * Read valid loans
     C                   READ      LEVCLIKD0                              99    *
     C                   READ      LEVCLILD0                              99    *
B003 C     *IN99         DOWEQ     '0'
 
     C                   EVAL      @LoanNo = CLLNRF
     C                   EVAL      @Timestamp = CLTMES
      /COPY WNCPYSRC,LECLIPU003
 
      * Load the API Dump data area with as many fields from the message
      *  header as are available, so that dumps in any lowere level modules
      *  will include the key information
     C                   EVAL      ARFOTranID = CLFRNT
     C                   EVAL      ARRprLocn  = CLREPA
 
      /COPY WNCPYSRC,LECLIPU004
 
      * Get the range number
     C                   MOVEL     *BLANKS       @@LNTY
     C                   MOVEL     *BLANKS       @@LNST
     C                   MOVEL     *BLANKS       @@LNCL                                       CLE042
     C                   MOVEL     *BLANKS       @@PRang
     C                   EXSR      SRNXLN
 
      * Data base update
     C                   CALLB     'LECLIPUPD'
     C                   PARM                    @@RTCD
     C                   PARM                    LECLIL
     C                   PARM                    LECLIK
     C                   PARM                    @@PRang
     C                   PARM                    PPTIN             1
     C                   PARM                    PGNTF             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
     C                   PARM                    W#SEQ             4 0
                                                                                              CDE005
      ** Reservation ID (input from VU only)                                                  CDE005
     C                   PARM                    ResrvId          10                          CDE005
                                                                                              CDE005
      ** Calling module                                                                       CDE005
     C                   PARM                    CallModCode       3                          CDE005
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227
     C                   PARM                    DDFPTF            1                          245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
     C                   PARM                    @DEPI             1                        MD030621
      /COPY WNCPYSRC,LECLIPU014
      *                                                                                       CER001
     C                   IF        @@RTCD <> '*RECLCK'                                      AR868380
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
     C     ARFOTranID    CHAIN     LEVCLLX1L0                                                 CER001
      *                                                                                       CER001
     C                   IF        NOT %FOUND(LEVCLLX1L0)                                     CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'LEVCLLX1L0'  DBFILE                                       CER001
     C                   MOVEL     '004'         DBASE                                        CER001
     C                   MOVEL     ARFOTranID    DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   EVAL      LKLNRF = CLLNRF                                            CER001
     C                   CALLB     'LECLIP2RV'                                                CER001
     C                   PARM                    PRetCodeIn        1                          CER001
     C                   PARM                    PAction           1                          CER001
     C                   PARM      ARFOTranID    PFrontID         20                          CER001
     C**********         PARM      CLLNRF        PLoanNum          6 0                 CER001 CLE148
     C                   PARM      CLLNRF        PLoanNum          6                          CLE148
     C                   PARM                    CLIPFilFmtEx                                 CER001
      *                                                                                       CER001
     C                   CALLB     'LECLIP2UP'                                                CER001
     C                   PARM      CLCHTP        PAction                                      CER001
     C                   PARM                    @@RTCD                                       CER001
     C                   PARM                    PFind             1                          CER001
     C                   PARM                    ValidCLIPEx                                  CER001
     C                   PARM                    CLIPFilFmtEx                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                              AR868380
 
      /COPY WNCPYSRC,LECLIPU007
 
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** Call LECLIPUPD1 to update BoE database if no errors in the                          LLN022A
      ** main update LECLIPUPD.                                                              LLN022A
      *                                                                                      LLN022A
     C     @@RTCD        IFEQ      *BLANKS                                                   LLN022A
      *                                                                                      LLN022A
      ** Access the valid file LEVCLIPY0 usign the front office                              LLN022A
      **   identifier as key                                                                 LLN022A
      *                                                                                      LLN022A
     C     ARFOTranID    CHAIN     LEVCLIPY0                          89                     LLN022A
     C     *IN89         IFEQ      *ON                                                       LLN022A
     C                   EXSR      *PSSR                                                     LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPUPD1'                                              LLN022A
     C                   PARM                    @@RTCD                                      LLN022A
     C                   PARM      CLCHTP        PACTN             1                         LLN022A
     C                   PARM                    ValidCLIPExt                                LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      * Comit updates if no error
B004 C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C     @@RTCD        OREQ      '*RECLCK'                                                AR868380
     C                   ROLBK
X004 C                   ELSE
      *                                                                                      BUG6686
      ** Read the files again to prevent program crash                                       BUG6686
      *                                                                                      BUG6686
     C     1             SETLL     LEVCLILPD                                                 BUG6686
     C     1             SETLL     LEVCLIKPD                                                 BUG6686
     C                   READ      LEVCLIKD0                              99                 BUG6686
     C                   READ      LEVCLILD0                              99                 BUG6686
     C                   DELETE    LEVCLILD0
     C                   DELETE    LEVCLIKD0
      *                                                                                      LLN022A
      ** Access the valid file LEVCLIPY0 using the front office                              LLN022A
      ** identifier as key                                                                   LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C     ARFOTranID    CHAIN     LEVCLIPY0                          89                     LLN022A
      *                                                                                      LLN022A
      ** If found, delete the record from LEVCLIPY0                                          LLN022A
      *                                                                                      LLN022A
     C     *IN89         IFEQ      *OFF                                                      LLN022A
     C                   DELETE    VCLIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
     C     ARFOTranID    CHAIN     LEVCLLX1L0                                                 CER001
      *                                                                                       CER001
     C                   IF        NOT %FOUND(LEVCLLX1L0)                                     CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'LEVCLLX1L0'  DBFILE                                       CER001
     C                   MOVEL     '005'         DBASE                                        CER001
     C                   MOVEL     ARFOTranID    DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
     C                   DELETE    LEVCLLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   COMMIT
E004 C                   ENDIF
 
      /COPY WNCPYSRC,LECLIPU008
 
      * If an error has occurred, reaccess record in error and remove from
      * the file to prevent program processing the same record again
B004 C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C     @@RTCD        OREQ      '*RECLCK'                                                AR868380
     C                   EVAL      @LoanNo = CLLNRF
     C                   EVAL      @Timestamp = CLTMES
      * Write details of record to error file (same format as LEVCLILPD)
     C                   WRITE     LEVCLILERR
     C     @KLECL1       CHAIN     LEVCLILL1                          89
B004 C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVCLILPD'   DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     CLLNRF        DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ENDIF
     C                   DELETE    LEVCLILD1
 
     C                   WRITE     LEVCLIKERR
     C     @KLECL1       CHAIN     LEVCLIKL1                          89
B004 C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVCLIKPD'   DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     CLLNRF        DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ENDIF
     C                   DELETE    LEVCLIKD1
      *                                                                                      LLN022A
      ** Access the valid file LEVCLIPY0 using the front office                              LLN022A
      ** identifier as key                                                                   LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C     ARFOTranID    CHAIN     LEVCLIPY0                          89                     LLN022A
      *                                                                                      LLN022A
      ** If found, delete the record from LEVCLIPY0                                          LLN022A
      *                                                                                      LLN022A
     C     *IN89         IFEQ      *OFF                                                      LLN022A
     C                   MOVE      @Timestamp    LVTMST                                      LLN022A
     C                   WRITE     VECLIPD0                                                  LLN022A
     C                   DELETE    VCLIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Write details of record to error file (same format as LEVCLLX1PD)                    CER001
      *                                                                                       CER001
     C                   WRITE     VECLIPD6                                                   CER001
      *                                                                                       CER001
     C     ARFOTranId    CHAIN     LEVCLLX1L0                                                 CER001
     C                   IF        NOT %FOUND(LEVCLLX1L0)                                     CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'LEVCLLX1L0'  DBFILE                                       CER001
     C                   MOVEL     '005'         DBASE                                        CER001
     C                   MOVEL     ARFOTranID    DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
E004 C                   ELSE                                                                 CER001
     C                   DELETE    LEVCLLX1L0                                                 CER001
E004 C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      * Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
E004 C                   ENDIF
 
      * Read valid loans
     C                   READ      LEVCLILD0                              99    *
     C                   READ      LEVCLIKD0                              99    *
 
E003 C                   END
E002 C                   END
 
      * Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
 
      * End loop for data queue prompt
E001 C                   END
 
      /COPY WNCPYSRC,LECLIPU009
 
      * Exit from program
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LECLIPU012
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNXLN - Get the range number (LT/ST)                         *
      *                                                               *
      *****************************************************************
     C     SRNXLN        BEGSR
 
     C                   MOVE      CLLTYP        @@LNTY            2
     C                   MOVE      CLSUTP        @@LNST            2
     C                   MOVE      CLCLAS        @@LNCL            4                          CLE042
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM                    @@LNTY
     C                   PARM                    @@LNST
     C                   PARM                    @@LNCL                                       CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY
     C     @@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDLOANPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C     @@LNTY        CAT       @@LNST:1      DBKEY                          *************
     C                   CAT       @@LNCL:1      DBKEY                                        CLE042
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      AYRANG        @@PRang           2
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      * Define key list for LEVCLILL1 and LEVCLIKL1
     C     @KLECL1       KLIST
     C**********         KFLD                    @LoanNo           6 0                        CLE148
     C                   KFLD                    @LoanNo           6                          CLE148
     C                   KFLD                    @Timestamp
      *                                                                                       CER001
     C                   CALLB     'AOMMODR0'                                                 CER001
     C                   PARM      '*DBERR '     @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
                                                                                             BUG3721
      ** Determine if Flat Rate Personal Loans (Rule of 78s) is installed                    BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           CLE028            1                         BUG3721
     C                   CALLB     'AOSARDR0'                                                BUG3721
     C                   PARM      *BLANKS       @RTCD                                       BUG3721
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3721
     C                   PARM      'CLE028'      @SARD             6                         BUG3721
                                                                                             BUG3721
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3721
     C                   MOVE      'Y'           CLE028                                      BUG3721
     C                   ELSE                                                                BUG3721
     C     @RTCD         IFEQ      '*NRF'                                                    BUG3721
     C                   MOVE      'N'           CLE028                                      BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
      ** Database error                                                                      BUG3721
                                                                                             BUG3721
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************BUG3721
     C                   MOVEL     '007'         DBASE                          * DBERR 007 *BUG3721
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3721
     C                   EXSR      *PSSR                                                     BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
 
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           ULX004            1                          CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
                                                                                              CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVE      'Y'           ULX004                                       CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX004 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C     @RTCD         IFEQ      '*NRF'                                                     CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   ELSE                                                                 CER001
                                                                                              CER001
      ** Database error                                                                       CER001
                                                                                              CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '008'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *  Check if an existing DBU_CLIP job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589
      * Lock allocation data area
 
      * The data area is allocated *SHRRD here and *EXCL whilst processing
      * of the valid file is actually taking place.
      * The function to submit this updater tries to get a *EXCL lock.
      * The controller tries to get a *SHRRD lock.
 
      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater
 
      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater
 
      *   Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      * Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
     C                   EVAL      @RTCD = *BLANKS
 
      * Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LECLIPU013
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
