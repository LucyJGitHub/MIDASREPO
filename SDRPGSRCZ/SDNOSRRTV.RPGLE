     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Codes Details Retrieve')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNOSRRTV - Nostro Codes Details      RETRIEVE               *
      *              (WITH ACTION CODE VERSUS Nostro Codes VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a Nostro Code from          *
      *             the database. As it does so, it validates the     *
      *             action code and Nostro code.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CDL094             Date 01Sep14               *
      *  Prev Amend No. MD027264           Date 25Jun14               *
      *                 MD000091           Date 03May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions (Recompile)*
      *  MD027264 - Prevent single digit nostro number as input.      *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDNOSTL7  IF   E           K DISK       INFSR(*PSSR)
      * Nostro Details by Currency, Shortname and PN.
     FSDNOSTL1  IF   E           K DISK       INFSR(*PSSR)
      * Nostro Details Retrieval.
     FSDNostL9  IF   E           K DISK       INFSR(*PSSR)
     F                                        RENAME(SDNostD0:SDNosFOI)
      * Nostro Codes File by Front Office Id
 
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
 
     D TranFilFmt    E DS                  EXTNAME(SDNOSTPD)
      ** Transaction Details in File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** Data Structure for Event Code Substitution                                         MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
     C                             OKCYCD = 'N' OR
     C                             OKNONB = 'N'
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
     C                   EXSR      RTVNOST
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVNOST
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVNOST
     C                   EXSR      VALACD
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
     C                   IF        OKACTN = 'N' OR
     C                             OKCYCD = 'N' OR
     C                             OKNONB = 'N'
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
      * RTVNOST - RETRIEVE Nostro DETAILS IF ACTION CODE 'A', 'E' OR 'D'
      **********************************************************************
     C     RTVNOST       BEGSR
 
      * Access Nostro Codes from the Nostro Codes file
     C     KNost         CHAIN     SDNOSTL1                           99
 
      * Nostro Codes details not found
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKNONB
     C                   ADD       1             Ix
     C                   MOVEL     'DDNONB'      FldNameArr(Ix)
     C                   MOVEL     'USR0073'     MsgIdArr(Ix)
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
     C     FOTRID        CHAIN     SDNOSFOI                           99
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
      * VAL - VALIDATION OF ACTION CODE CURRENCY CODE AND NOSTRO NUMBER
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
      *  Nostro Currency Code is required
     C                   IF        DDCYCD = *BLANKS OR
     C                             DDCYCD = *ZERO
     C                   MOVEL     'N'           OKCYCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCYCD'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0001'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *  Nostro Number is required
     C**********         IF        DDNONB = *BLANKS OR                                      MD-27264
     C**********                   DDNONB = *ZEROS                                          MD-27264
     C                   IF        DDNONB = *BLANKS                                         MD-27264
     C                   MOVEL     'N'           OKNONB
     C                   ADD       1             Ix
     C                   MOVEL     'DDNONB'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0001'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ELSE                                                               MD-27264
     C                   MOVEL     DDNONB        WKNOS1            1                        MD-27264
     C                   MOVE      DDNONB        WKNOS2            1                        MD-27264
     C                   IF        WKNOS1 = *BLANK                                          MD-27264
     C                             OR WKNOS2 = *BLANK                                       MD-27264
     C                   MOVEL     'N'           OKNONB                                     MD-27264
     C                   ADD       1             Ix                                         MD-27264
     C                   MOVEL     'DDNONB'      FldNameArr(Ix)                             MD-27264
     C                   MOVEL     'USR0913'     MsgIdArr(Ix)                               MD-27264
     C                   GOTO      EVAL                                                     MD-27264
     C                   ENDIF                                                              MD-27264
     C                   ENDIF
      ** Check Nostro Number must be a number between 01 and 99
      *
     C                   IF        DDNONB < '01' OR
     C                             DDNONB > '99'
     C                   MOVEL     'N'           OKNONB
     C                   ADD       1             Ix
     C                   MOVEL     'DDNONB'      FldNameArr(Ix)
     C                   MOVEL     'USR0913'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      ** Check Currency is a Valid Currency
      *
     C                   IF        DDCYCD <> *BLANKS
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM                    DDCYCD
     C                   PARM                    DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'N'           OKCYCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCYCD'      FldNameArr(Ix)
     C                   MOVEL     'USR0071'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   ENDIF
      *
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      *
      * Access Nostro Codes from the Nostro Codes file
     C     KNost         CHAIN     SDNOSTL1                           44
      *
      * Error if present already
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKNONB = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDNONB'      FldNameArr(Ix)
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
      ** Nostro code must exists
      *
     C     KNost         CHAIN     SDNOSTL1                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKNONB
     C                   ADD       1             Ix
     C                   MOVEL     'DDNONB'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0009'     MsgIdArr(Ix)
      *
     C                   ELSE
      * If Record is Found
      * Does PNI allow Deletion - Nostro Details  *
     C                   EXSR      SORVGN
      *
      * Send message 'Nostro can't be Deleted'
     C     W0RTN         IFEQ      'Y2U0003'
     C                   MOVE      'N'           OKNONB
     C                   ADD       1             Ix
     C                   MOVEL     'DDNONB'      FldNameArr(Ix)
     C                   MOVEL     'USR1546'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
 
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
      * Clear Outputs
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKCYCD = 'Y'
     C                   EVAL      OKNONB = 'Y'
 
 
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
      * (Midas) Nostro Currency Code
     C                   PARM                    DDCYCD            3
      * (Midas) Nostro Number
     C                   PARM                    DDNONB            2
      *
      * Outputs
      *
      * Transaction Details in File Format
     C                   PARM                    TranFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Nostro Currency Code
     C                   PARM                    OKCYCD            1
      * OK - Nostro Number
     C                   PARM                    OKNONB            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      * Key Lists
     C     KNost         KLIST
     C                   KFLD                    DDCYCD
     C                   KFLD                    DDNONB
      ** Initialise program name
     C                   EVAL      DBPGM = 'SDNosrRTV'
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
      *
      *****************************************************************
      * SORVGN - Does PNI allow Deletion - Nostro Details
      *****************************************************************
     CSR   SORVGN        BEGSR
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSO         KLIST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7NONB
      * Move fields to key list
     C                   MOVEL     DDCYCD        A7CYCD
     C                   MOVEL     DDNONB        A7NONB
     C     KRSSO         CHAIN     @A7REB9                            90
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0073'     W0RTN             7
     C                   MOVEL     'Y2U0005'     W0RTN
     C                   GOTO      SOEXIT
     C                   ENDIF
      *
     C     *IN90         IFEQ      '0'
     C     A7PNOI        IFEQ      'P'
     C                   MOVEL     A7NONB        WUNONB            2
      * Prime Nostro for CCY/NAME - Nostro Details  *
     C                   EXSR      SPRVGN
     C                   ELSE
     C                   MOVEL     'Y2U0005'     W0RTN
     C                   END
     C                   END
      *****************************************************************
     CSR   SOEXIT        ENDSR
      *
      *****************************************************************
      * SPRVGN - Prime Nostro for CCY/NAME - Nostro Details
      *****************************************************************
     CSR   SPRVGN        BEGSR
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    A7CYCD        WQSP01
     C     *LIKE         DEFINE    A7NOSN        WQSP02
     C     *LIKE         DEFINE    A7PNOI        WQSP03
      * Define keylist
     C     KRSSP         KLIST
     C                   KFLD                    WQSP01
     C                   KFLD                    WQSP02
     C                   KFLD                    WQSP03
      * Move fields to key list
     C                   MOVEL     A7CYCD        WQSP01
     C                   MOVEL     A7NOSN        WQSP02
     C                   MOVEL     *BLANK        WQSP03
     C     KRSSP         SETLL     @NOSTJ6
     C     KRSSP         READE     @NOSTJ6                                90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0073'     W0RTN             7
     C                   MOVEL     'Y2U0005'     W0RTN
     C                   GOTO      SPEXIT
     C                   END
     C     *IN90         DOWEQ     '0'
     C     A7NONB        IFNE      WUNONB
     C                   MOVEL     A7NONB        WUNONB
     C                   MOVEL     'Y2U0003'     W0RTN
     C                   GOTO      SPEXIT
     C                   END
     C     KRSSP         READE     @NOSTJ6                                90
     C                   END
     CSR   SPEXIT        ENDSR
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
