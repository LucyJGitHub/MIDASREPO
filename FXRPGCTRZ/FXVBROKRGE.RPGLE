     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate broker code and brokerage')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVBROKRGE - Validate Broker Code & Brokerage                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002   *CREATE   Date 08Sep97               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
 
      ** External data structure for broker codes file
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
 
      ** External data structure for currency codes file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CER043
      ** External data structure for SAR details                                              CER043
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D PSysVl          C                   CONST('DefaultBroker')                             CER043
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CER043
     D CER043          S              1                                                       CER043
     D PRTCD           S              7                                                       CER043
     D POPTN           S              7A                                                      CER043
     D PSARD           S              6A                                                      CER043
     D PSVLK1          S             20                                                       CER043
     D PSVL1           S            200                                                       CER043
     D PSVLK2          S             20                                                       CER043
     D PSVL2           S            200                                                       CER043
     D PSVLK3          S             20                                                       CER043
     D PSVL3           S            200                                                       CER043
     D PSVLK4          S             20                                                       CER043
     D PSVL4           S            200                                                       CER043
     D PSVLK5          S             20                                                       CER043
     D PSVL5           S            200                                                       CER043
     D PSVLK6          S             20                                                       CER043
     D PSVL6           S            200                                                       CER043
     D PSVLK7          S             20                                                       CER043
     D PSVL7           S            200                                                       CER043
     D PSVLK8          S             20                                                       CER043
     D PSVL8           S            200                                                       CER043
     D PSVLK9          S             20                                                       CER043
     D PSVL9           S            200                                                       CER043
     D PSVLK0          S             20                                                       CER043
     D PSVL0           S            200                                                       CER043
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      ** BRKRV - BROKER VALIDATION
      *
     C                   EXSR      BRKRV
      *
      ** BKRGV - BROKERAGE VALIDATION
      *
     C                   EXSR      BKRGV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBrkrOK      IFEQ      'N'
     C     DDBkrgOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** BRKRV - BROKER VALIDATION
      *****************************************************************
     C     BRKRV         BEGSR
      *                                                                                       CER043
      ** Retrieve system value if broker code is blank                                        CER043
      *                                                                                       CER043
     C                   IF        DDBRKR = *BLANKS                                           CER043
     C                             AND CER043 = 'Y'                                           CER043
     C                   EVAL      PSVLK1 = PSYSVL                                            CER043
     C                   EXSR      RtvBrokSysVal                                              CER043
     C                   ENDIF                                                                CER043
      *
      *  Broker code must be defined
      *
     C     DDBRKR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDBrkrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRKR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0195'     MsgIdXAr(Idx)
     C                   END
      *
      * If broker code is defined, it must take certain values
      *
     C     DDBRKR        IFNE      *BLANKS
     C     DDBRKR        ANDNE     'TELX'
     C     DDBRKR        ANDNE     'PHON'
     C     DDBRKR        ANDNE     'MAIL'
      *
      * Broker can't be 'SWAP' for option deal types
      *
     C     DDBRKR        IFEQ      'SWAP'
     C     DDDLTP        ANDEQ     'OP'
     C     DDBRKR        OREQ      'SWAP'
     C     DDDLTP        ANDEQ     'OT'
     C                   MOVE      'N'           DDBrkrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRKR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0196'     MsgIdXAr(Idx)
     C                   END
      *
      * Validate that broker code exists
      *
     C     DDBRKR        IFNE      'SWAP'
     C                   CALLB     'AOBROKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRKR        @BQTX             4
     C     SDBROK        PARM      SDBROK        DSFDY
      *
      * broker does not exist
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBrkrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRKR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0197'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     A9BROK        DDBRKR
     C                   MOVE      A9BRCY        F3BKCY
     C                   END
      *
     C                   END                                                    DDBRKR NE SWAP
     C                   END                                                    DDBRKR NE BLANK
      *
      * Update deal with broker code
      *
     C                   MOVE      DDBRKR        F3BROK
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** BKRGV - BROKERAGE VALIDATION
      *****************************************************************
     C     BKRGV         BEGSR
      *
      *   If brokerage is defined and not 'NIL' and broker code is valid
      *
     C     DDBKRG        IFNE      *BLANKS
     C     DDBKRG        ANDNE     'NIL'
     C     DDBrkrOK      ANDEQ     'Y'
      *
      * Broker code can't be blank
      *
     C     DDBRKR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDBkrgOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBKRG'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0199'     MsgIdXAr(Idx)
     C                   END
      *
      * Broker code can't be one of the following
      *
     C     DDBRKR        IFEQ      'TELX'
     C     DDBRKR        OREQ      'MAIL'
     C     DDBRKR        OREQ      'PHON'
     C     DDBRKR        OREQ      'SWAP'
     C                   MOVE      'N'           DDBkrgOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBKRG'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0194'     MsgIdXAr(Idx)
     C                   END
      *
      * If brokerage is OK so far
      *
     C     DDBkrgOK      IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      A9BRCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      * error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '101'         DBASE                          * DBERR 101*
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * Validate brokerage amount
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBKRG        @@ALPH
     C                   MOVE      'N'           @@MTID            1
     C                   EXSR      ZA0840
      *
      ** Non numeric
      *
     C     @@ERCD        IFEQ      1
     C                   MOVE      'N'           DDBkrgOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBKRG'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0198'     MsgIdXAr(Idx)
     C                   END
      *
      ** Incorrect decimals
      *
     C     @@ERCD        IFEQ      2
     C                   MOVE      'N'           DDBkrgOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBKRG'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0200'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END                                                    DDBkrgOK
     C                   END                                                    DDBRRG
      *
      * If broker code & brokerage is OK
      * update brokerage on deal
      *
     C     DDBkrgOK      IFEQ      'Y'
     C     DDBrkrOK      ANDEQ     'Y'
      *
     C     DDBKRG        IFEQ      *BLANKS
     C                   MOVE      *ALL'9'       F3BRKG                         **2     S01136 E1390
     C                   ELSE                                                   X*2
     C     DDBKRG        IFNE      'NIL'
     C                   MOVE      @@ALPH        DDBKRG
     C                   Z-ADD     @@AMT         F3BRKG
     C                   END
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0840 - VALIDATE/REFORMAT AMOUNT                             *
      *****************************************************************
     C     ZA0840        BEGSR
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16            Display field
     C                   PARM                    @@IDP             3 0          no.of dec.plcs
     C                   PARM                    @@IINT            3 0          no.of integers
     C                   PARM                    @@MTID            1            Million/Thous.
     C                   PARM      *ZERO         @@ERCD            1 0          Error code
     C                   PARM      *ZERO         @@AMT            15 0          File field
     C                   PARM                    BNDCSP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER043
      *                                                               *                       CER043
      * RtvBrokSysVal - Retrieve system value for broker code         *                       CER043
      *                                                               *                       CER043
      *  Called by: BRKRV                                             *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
     C     RtvBrokSysVal BEGSR                                                                CER043
                                                                                              CER043
     C                   CALLB     'AOSVALR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM                    PSVLK1                                       CER043
     C                   PARM                    PSVL1                                        CER043
     C                   PARM      *BLANKS       PSVLK2                                       CER043
     C                   PARM                    PSVL2                                        CER043
     C                   PARM      *BLANKS       PSVLK3                                       CER043
     C                   PARM                    PSVL3                                        CER043
     C                   PARM      *BLANKS       PSVLK4                                       CER043
     C                   PARM                    PSVL4                                        CER043
     C                   PARM      *BLANKS       PSVLK5                                       CER043
     C                   PARM                    PSVL5                                        CER043
     C                   PARM      *BLANKS       PSVLK6                                       CER043
     C                   PARM                    PSVL6                                        CER043
     C                   PARM      *BLANKS       PSVLK7                                       CER043
     C                   PARM                    PSVL7                                        CER043
     C                   PARM      *BLANKS       PSVLK8                                       CER043
     C                   PARM                    PSVL8                                        CER043
     C                   PARM      *BLANKS       PSVLK9                                       CER043
     C                   PARM                    PSVL9                                        CER043
     C                   PARM      *BLANKS       PSVLK0                                       CER043
     C                   PARM                    PSVL0                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS                                           CER043
     C                             AND PSVL1 = '*NRF   '                                      CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SDSVALPD'                          ************  CER043
     C                   EVAL      DBASE = 102                                  * DBERR 102*  CER043
     C                   EVAL      DBKEY = PSVLK1                               ************  CER043
     C                   EVAL      DBPGM = 'FXVBROKRGE'                                       CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      DDBRKR = PSVL1                                             CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDBRKR            4            broker
     C                   PARM                    DDBKRG           16            brokerage
      *
      * ICD
     C                   PARM                    BNDCSP            1            new dl status
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Broker - OK
      ** Brokerage - OK
     C                   PARM                    DDBrkrOK          1            broker
     C                   PARM                    DDBkrgOK          1            brokerage
      *
      ** Deal Broker, Brokerage and Broker ccy
      *
     C                   PARM                    F3BROK            4            broker
     C                   PARM                    F3BRKG           15 0          brokerage
     C                   PARM                    F3BKCY            3            broker ccy
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                          ************  CER043
     C                   EVAL      DBASE = 103                                  * DBERR 103*  CER043
     C                   EVAL      DBKEY = 'CER043'                             ************  CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
