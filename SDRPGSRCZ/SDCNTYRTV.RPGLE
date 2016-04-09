     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*OVR *  OVRDBF FILE(GPICTYL0) TOFILE(GPICTRYL0)                      *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Country Details Retrieve')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCNTYRTV - Country Details RETRIEVE                         *
      *              (WITH ACTION CODE VERSUS Country code VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a country from the database.*
      *             As it does, it validates the action code and      *
      *             Country code.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD000091           Date 03May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCtryL1  IF   E           K DISK    INFSR(*PSSR)
     FSDCtx1L0  IF   E           K DISK    INFSR(*PSSR)
     FSDCtx2L0  IF   E           K DISK    INFSR(*PSSR)
     FSDCTEXPD  IF   E             DISK    INFSR(*PSSR)
 
     FSDCntyL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCtryD0:SDCtrFOI)
      * Country File by Front Office Id
     FGPICTYL0  IF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(GPICTRYD0:GPICTYD0)
      * Midas GP Global Account Codes X-Reference
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      * Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D CNTYFilFmt    E DS                  EXTNAME(SDCTRYPD)
     D CTX1FilFmt    E DS                  EXTNAME(SDCTX1PD)
     D CTX2FilFmt    E DS                  EXTNAME(SDCTX2PD)
     D ExtData       E DS                  EXTNAME(SDCTEXPD)
      ** Transaction Details in File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
                                                                                            MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *
     D OVRC            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array declared for overridding file GPICTRYL0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * Initialisation
     C                   EXSR      INIT
      *
      * If the mode is 'Front Office Transaction Interface'
      * Do (Extra) Validation for Front Office Transaction Interface
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      * Validate Action Code & Transaction Number
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N' OR
     C                             OKCNCD = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN
      *
      ** If single branching
      ** Access Security Checking - Single Branching
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
      *
      ** If multibranching
      ** Access Security Checking - Multi-Branching
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVCTRY
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVCTRY
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVCTRY
     C                   EXSR      VALACD
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
     C                   IF        OKACTN = 'N' OR
     C                             OKCNCD = 'N'
     C                   RETURN
     C                   ENDIF
 
      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DBRN          ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
      * RTVCTRY - Retrieve Country Details If Action Code 'A', 'E' OR 'D'
      **********************************************************************
     C     RTVCTRY       BEGSR
 
      * Access Customer from the Customers file
     C     DDCNCD        CHAIN     SDCTRYL1                           99
 
      * Country details not found
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKCNCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCNCD'      FldNameArr(Ix)
     C                   MOVEL     'USR0249'     MsgIdArr(Ix)
     C                   ENDIF
 
      * Access Lux BCL Country from SDCTX1PD File
     C                   IF        ULX043 = 'Y'
     C     DDCNCD        CHAIN     SDCTX1L0                           97
     C                   IF        *IN97 = *ON
     C                   EVAL      CTX1FilFmt = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      * Access Lux Eur Country from SDCTX2PD File
     C                   IF        ULX004 = 'Y'
     C     DDCNCD        CHAIN     SDCTX2L0                           98
     C                   IF        *IN98 = *ON
     C                   EVAL      CTX2FilFmt = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      * Access Extra data from SDCTEXPD File
     C     1             SETLL     SDCTEXPD
     C                   READ      SDCTEXPD
     C                   IF        NOT %EOF(SDCTEXPD)
     C                   EVAL      ExtData = APNARV
     C                   ENDIF
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
      * Error if Front Office Transaction ID is Blank
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * Access Transaction with Front Office Transaction ID
     C     FOTRID        CHAIN     SDCTRFOI                           99
      *
      * If Insert
      *
     C                   IF        DDACTN = 'I'
      *
      * Front Office Transaction ID can't be Present already
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      * If not insert, Front Office Transaction ID Must be Present
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND TRANSACTION NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      * Action Code
      *  .. must be 'I','A','D' or 'E'
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF
      *  Country Code is required
     C                   IF        DDCNCD = *BLANKS OR
     C                             DDCNCD = *ZEROS
     C                   MOVEL     'N'           OKCNCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCNCD'      FldNameArr(Ix)
     C                   MOVEL     'USR0248'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      ** Check country code is in ISO country code file
      *
     C                   IF        CGP001  = 'Y'
     C                   MOVE      DDCNCD        KCNCD             2
      *
     C     KCNCD         CHAIN     GPICTYL0                           46
      *
     C     *IN46         IFEQ      *ON
     C                   MOVEL     'N'           OKCNCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCNCD'      FldNameArr(Ix)
     C                   MOVEL     'USR9784'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      *
      * Access Country from the Countries file
     C     DDCNCD        CHAIN     SDCTRYL1                           44
      *
      * Error if present already
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKCNCD = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCNCD'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)
     C                   ENDIF
      *
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      *
      ** Country code must exists
      *
     C     DDCNCD        CHAIN     SDCTRYL1                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKCNCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCNCD'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0009'     MsgIdArr(Ix)
      *
     C                   END
 
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
      * Clear Outputs
     C                   CLEAR                   CNTYFilFmt
     C                   CLEAR                   CTX1FilFmt
     C                   CLEAR                   CTX2FilFmt
     C                   CLEAR                   ExtData
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKCNCD = 'Y'
 
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGPOF - Opens the Global Processing Cross-Reference Files.  *
      *                                                               *
      *****************************************************************
     C     SRGPOF        BEGSR
      *
     C                   IF        %OPEN(GPICTYL0)
     C                   CLOSE     GPICTYL0
     C                   ENDIF
      *
     C                   Z-ADD     80            PLEN             15 5
      *
     C                   MOVE      OVRC(1)       PCMD             80
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *
     C                   OPEN      GPICTYL0
      *
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * Inputs
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Country Code
     C                   PARM                    DDCNCD            2
      *
      * Outputs
      *
      * Transaction Details in File Format
     C                   PARM                    CNTYFilFmt
     C                   PARM                    CTX1FilFmt
     C                   PARM                    CTX2FilFmt
     C                   PARM                    ExtData
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Country Code
     C                   PARM                    OKCNCD            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'SDCntyRTV'
      ** Check if switchable feature CGP001 is switched on.
      ** - Global Processing
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGP001'      @SARD             6
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CGP001'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGP001            1
     C                   ELSE
     C                   MOVE      'N'           CGP001
     C                   ENDIF
      ** Open the Global Processing Files.
     C                   EXSR      SRGPOF
      * Access SAR details file to determine if ULX004 switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           ULX004            1
     C                   ELSE
     C                   MOVEL     'N'           ULX004
     C                   EndIf
      * Access SAR details file to determine if ULX043 switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX043'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           ULX043            1
     C                   ELSE
     C                   MOVEL     'N'           ULX043
     C                   EndIf
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @OPTN                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
**  OVRC
OVRDBF FILE(GPICTYL0) TOFILE(GPICTRYL0)
