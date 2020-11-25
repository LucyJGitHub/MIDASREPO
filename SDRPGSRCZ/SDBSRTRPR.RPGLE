     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid base rates details repair')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTRPR - INVALID BASE RATES DETAILS REPAIR FUNCTION       *
      *                                                               *
      *  Function:  This function allows invalid Base Rates details   *
      *            to be 'repaired' and applied to the Midas database.*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247439             Date 07Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201973             Date 12Jan02               *
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 18Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Jan01               *
      *                 CAP038  *CREATE    Date 06Mar00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247439 - Kondor transactions go missing...                   *
      *  CSD012 - Standing Data Authorisation                         *
      *  201973 - Repair of amended base rate is not processed.       *
      *  CSC011 - 24x7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed                          *
      *  CSD006 - Market Data Feed                                    *
      *  CAP038 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)

     FSDIBSRTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIBSRTD0:SDIBSRTX0)
     FSDIBSRTL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid Log File from Support Database                                           CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011


      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDBSRTR001

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

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

     D @EI             S              1    DIM(60)

   41 ** Array of Fields in error, temporary store
   42D TmpFldNmAr      S             10A   DIM(ArrayMax)
   42 ** Array of error message IDs, temporary store
   42D TmpMsgIdAr      S                   DIM(ArrayMax)
   42D                                     LIKE(#MsgID)

      * Current Base Rate in File Format
     D CrBsFilFmt    E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(C_)

      * Current Base Rate in Screen Format - Primary Details
     D CrBsScnFmt    E DS                  EXTNAME(SDBSRSPD)
     D                                     PREFIX(@)

      * New Base Rate in File Format
     D NwBsFilFmt    E DS                  EXTNAME(SDVBSRTPD)

      * New Base Rate in Screen Format
     D NwBsScnFmt    E DS                  EXTNAME(SDBSRSPD)


      * Error indicators
     D OKFlagsDS     E DS                  EXTNAME(SDEBSRTPD)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)

     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** EXTERNAL DS FOR API ICD

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D ExtData       E DS                  EXTNAME(SDBSEXPD)
      * SD Base Rates Extra Data - File (D/B) format

      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
                                                                                              CSD012
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
      * Backward-Looking Rate Fields                                                          CSD103
     D BasRBckfld      DS            27                                                       CSD103

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Switchable features
     D CSD006          S              1A                                                      CSD006
     D CSW005          S              1A
     D CSW011          S              1A
     D CSW200          S              1A

      * Clear Screen (Y / N)
     D CLRSCRN         S              1A

      **   Timestamp selected
     D @TMESTPSEL      S             26Z

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('SDBSRSPD')

     D Field           S             10A   INZ('DDACTN')

     D FieldNo         S              5P 0
     D FldOffset       S              5P 0

      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KFrntOffID      S                   LIKE(@FOTRANSEL)                                   CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
                                                                                              CSC012
      * Fields defined for CSD012                                                             CSC012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqBaseRateMaint')                      CSD012
      ** Override SDAULGL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDBSRTR002

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
      *
      /COPY WNCPYSRC,SDBSRTR003
      *
      * DO SCREEN: BROWSE INVALID BASE RATES
      *
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
      *
      /COPY WNCPYSRC,SDBSRTR004
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDBSRTR005
      *
      ** DO WHILE screen: Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx              3 0
     C     @SCRN         DOWEQ     'D'
     C                   EXSR      SCRN@D
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDBSRTR006

      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      /COPY WNCPYSRC,SDBSRTR007
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDBSRTR008
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDBSRTR009

      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID BASE RATES
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'SDBSRTRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * Currency Code
     C                   PARM      *blanks       DDCYCD
      *
      * Base Rate Code
     C                   PARM      *blanks       DDBSRC
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
                                                                                              CSC011
      ** CSC011 indicator                                                                     CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'SDBSRTRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL
      *
      * Currency Code
     C                   PARM      *BLANK        DDCYCD
      *
      * Base Rate Code
     C                   PARM      *BLANK        DDBSRC
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
                                                                                              CSC011
      ** CSC011 indicator                                                                     CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID BASE RATE READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * Clear file formats
     C                   CLEAR                   NwBsFilFmt
     C                   CLEAR                   CrBsFilFmt
      *
      * BLANK THE SCREENS
      *
     C                   MOVE      DDCYCD        WKCYCD            3
     C                   MOVE      DDBSRC        WKBSRC            2
     C                   CLEAR                   NwBsScnFmt
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKFlagsDS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve Base Rate details
      *
     C                   MOVE      WKCYCD        DDCYCD
     C                   MOVE      WKBSRC        DDBSRC
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    BVFOTRANID
      *
      * Make sure Invalid transaction's  details are passed to 'Retreive'
      * module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     SDIBSRTX0                          99
     C                   EVAL      DDFRNT = DDFOTRANID
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)                          247439
      * as any transaction in repair must have come from FO.                                  247439
      **Set*retrieve*mode*to*'*FRONT'*(Access*using*Front*Office*ID)****                      247439
      ***if*insert******************************************************                      247439
      ***if*not*insert*and*Midas*transaction*ID*is*not*present**********                      247439
      **Otherwise*******************************************************                      247439
      ***Set*retrieve*mode*to*blank**(Access*using*Midas*transaction*ID).                     247439
      *
     C*****DDACTN        IFEQ      'I'                                                        247439
     C                   MOVEL     '*FRONT'      @@MODE
     C***********        ELSE                                                                 247439
     C*****DDCYCD        IFEQ      *BLANK                                                     247439
     C*****DDBSRC        ANDEQ     *BLANK                                                     247439
     C***********        MOVEL     '*FRONT'      @@MODE                                       247439
     C***********        ELSE                                                                 247439
     C***********        MOVEL     '      '      @@MODE                                       247439
     C***********        ENDIF                                                                247439
     C***********        ENDIF                                                                247439
      *
     C                   EXSR      RTVBSRT
      *
      * If Base Rate details were retrieved
      * Convert the Base Rate to screen format.
      *
     C     C_BACYCD      IFNE      *BLANK
     C     C_BABSRC      ANDNE     *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      CVTBSRT
     C                   MOVEL     CrBsFilFmt    NwBsFilFmt
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Base Rate file (except for the Midas Base Rate
      * reference retrieved above using the front office transaction ID).
      * Access invalid Base Rate with timestamp and front office transactionID.
      *
      * Base Rate details:
     C                   MOVEL     DDCYCD        ##DDCYCD          3
     C                   MOVEL     DDBSRC        ##DDBSRC          2
     C     ZATRNKX0      CHAIN     SDIBSRTX0                          99
      *
      * If Base Rate details were retrieved and this is an amendment
      *
     C     C_BACYCD      IFNE      *BLANK
     C     C_BABSRC      ANDNE     *BLANK
     C     DDACTN        ANDEQ     'A'

      * Data Substitution - Transaction Details

     C     GHSUBS        ifne      *blank

     C     GHSUBS        SCAN      NwBsScnFmt                             99
     C                   if        *in99
     C                   EXSR      TDtDtaSubs
     C                   endif


     C                   END
     C                   END
      *
      * If action code, or Base Rate reference were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCYCDOK      OREQ      'N'
     C     DDBSRCOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * Send the Base Rate error messages to the details screen

     C                   EXSR      SNDM@D
     C                   MOVE      'D'           @SCRN

      * ELSE IF NO INVALID BASE RATE READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@D - SEND A MESSAGE TO DETAILS SCREEN
      *****************************************************************
     C     SNDM@D        BEGSR

     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCYCDOK      OREQ      'N'
     C     DDBSRCOK      OREQ      'N'
     C                   ADD       1             E
      *
      * Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      * first by the user
      *
     C                   Eval      TmpfldNmAr = *BLANKS
     C                   Eval      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKFlagsDS     @EI
      *
      ** Read error messages for Base Rate
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'

     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    Format
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo

     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF

     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKFlagsDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@D - PROCESS SCREEN: DETAILS
      *****************************************************************
     C     SCRN@D        BEGSR
      *
      * Enable/disable detail fields on primary details screen
      * if changes to the data are allowed
      * (key fields = action code & Base Rate reference; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'E')
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END

      * Set function key status on PRIMARY screen
     C                   EXSR      SFKEYS
      *
      ** WRITE/READ DISPLAY SCREEN - Details
      *
     C                   CALLB     'SDBSRTDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Base Rate (IN SCREEN FORMAT - Primary)
     C                   PARM                    NwBsScnFmt
      *
      * Fields in error
     C                   PARM                    OKFlagsDS
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
     C                   PARM      'N'           @EINKG            1
     C                   PARM                    @EINKJ            1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKP             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    ISDAFlag          1
     C                   PARM      'N'           @HDTFD            1
     C                   PARM      'N'           CLRSCRN
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKFlagsDS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@D
      *
      * Validate input to Primary screen
     C                   CAS                     VAL@D
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@D  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@D         BEGSR
      *
      * Retrieve Base Rate details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVBSRT
      *
      * If action code, or Base Rate reference are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCYCDOK      OREQ      'N'
     C     DDBSRCOK      OREQ      'N'
     C                   GOTO      EndVAL@D
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EndVAL@D
     C                   END
      *
      *----------------------------------------------------------------
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Base Rate in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       OKFlagsDS
     C*******************CLEAR                   NwBsFilFmt                                   196570
      *
      *
      * Validate Primary Base Rate details
      *
     C                   CALLB     'SDBSRTVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :

      * Response mode
     C                   PARM                    RespMode

      * Base Rate Details (Screen Format)
     C                   PARM                    NwBsScnFmt

      * Base Rate Extra Data file data
     C                   PARM                    ExtData

      * OUTPUTS :

      * Base Rate Details OK Flags
     C                   PARM                    OKFlagsDS

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Valid Base Rate layout (DS) from/to caller (File Format)
     C                   PARM                    NwBsFilFmt
     C                   PARM                    CSD006                                       CSD006
     C                   PARM                    CSW005
     C                   PARM                    CSW011
     C                   PARM                    CSW200
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103
      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@D
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKFlagsDS
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVEL     'C'           @SCRN
      *
      *
     C     EndVAL@D      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVBSRT - RETRIEVE BASE RATE
      *****************************************************************
     C     RTVBSRT       BEGSR
      *
      * RETRIEVE BASE RATE
      *
     C                   CALLB     'SDBSRTRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    @ACSEL
      *
      * Front Office Transaction ID
     C                   PARM                    BVFOTRANID
      *
      * (Midas) Base Rate Reference
     C                   PARM                    DDCYCD
     C                   PARM                    DDBSRC
      *
      *
      * OUTPUTS :
      * (Current) Base Rate in file format
     C                   PARM                    CrBsFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Base Rate Reference
     C                   PARM      *BLANK        DDCYCDOK
     C                   PARM      *BLANK        DDBSRCOK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      * ICD
     C                   PARM                    BGN4ST
      *
      * Base Rate Shortname
     C                   PARM                    DDBSRS
      *
      * Base Rate Name
     C                   PARM                    DDBSRN
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
     C     EndRTVBSRT    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTBSRT - Convert Base Rate Details ( File --> Screen )
      *****************************************************************
     C     CVTBSRT       BEGSR
      *
      * Call program to fill screen fields with data from SDBSRTPD
      *
     C                   CALLB     'SDBSRTCVT'
      *
      * INPUTS :
      * Return Code
      * Customer in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrBsFilFmt
      * OUTPUTS
      * Customer - screen formats
     C                   PARM                    NwBsScnFmt
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103

      *
      * Update 'Current' Base Rate with Base Rate in Screen Format
      *
     C                   MOVEL     NwBsScnFmt    CrBsScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@D - CANCEL ON DETAILS SCREEN
      *****************************************************************
     C     CANC@D        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS & AMENDS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       OKFlagsDS
      *
      * Validate base rate details
     C                   CALLB     'SDBSRTVAL'
      *
      * INPUTS :

      * Response mode
     C                   PARM                    RespMode

      * Base Rate Details (Screen Format)
     C                   PARM                    NwBsScnFmt

      * Base Rate Extra Data file data
     C                   PARM                    ExtData

      * OUTPUTS :

      * Base Rate Details OK Flags
     C                   PARM                    OKFlagsDS

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Valid Base Rate layout (DS) from/to caller (File Format)
     C                   PARM                    NwBsFilFmt
     C                   PARM                    CSD006                                       CSD006
     C                   PARM                    CSW005
     C                   PARM                    CSW011
     C                   PARM                    CSW200
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR4450'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
      *
     C                   CALLB     'SDBSRTDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Base Rate (IN SCREEN FORMAT - Primary)
     C                   PARM                    NwBsScnFmt
      *
      * Fields in error
     C                   PARM                    OKFlagsDS
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKJ            1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKP
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    ISDAFlag          1
     C                   PARM      'N'           @HDTFD            1
     C                   PARM      'N'           CLRSCRN
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKFlagsDS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO DETAILS SCREEN
      *
     C                   MOVEL     'D'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'D'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      *
      * Update valid Base Rate: Base Rate reference
      *
     C                   MOVEL     DDCYCD        BVCYCD
     C                   MOVEL     DDBSRC        BVBSRC
     C                   MOVEL     DDACTN        BVTYLC
     C                   MOVEL     @FOTRANSEL    BVFOTRANID
      *
      * Setup indicators
     C                   MOVE      'Y'           BVDLLC
     C                   MOVE      'Y'           BVCSLL
     C                   MOVE      'Y'           BVACLT
     C                   MOVE      'Y'           BVACRC
     C                   MOVE      'Y'           BVDLRC
     C                   MOVE      'Y'           BVCSLR
      ** Carry forward file data to valid file
      *
      *  Last Change Date
     C                   Z-ADD     BJRDNB        BVLCD
      *
      * AMEND -  Set the specific fields for amend
     C     DDACTN        IFEQ      'A'
     C                   MOVE      C_BACBSR      BVCBSR
     C                   MOVE      C_BAVDRC      BVVDRC
     C                   MOVE      'Y'           BVSYLL
     C                   MOVE      'Y'           BVSYLR
     C                   MOVE      C_BABSCD      BVBSCD
     C                   MOVEL     C_BATMST      BVTMESTMP                                    201973
     C                   ELSE
      *
      ** Initialise non-validated valid file fields for Insert
      *
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     *ZERO         BVCBSR
     C                   Z-ADD     *ZERO         BVVDRC
     C                   MOVE      *BLANKS       BVSYLL
     C                   MOVE      *BLANKS       BVSYLR
     C                   MOVE      *BLANKS       BVBSCD
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     *BLANK        @RTCD
      *
      * BASE RATES UPDATES
      *
     C                   CALLB     'SDBSRTUPD'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwBsFilFmt
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID BASE RATE ACTIONED & COMMIT THE UPDATES
      *
     C***LHRetCodeOut    IFNE      *BLANK
     C***LHRetCodeOut    ANDNE     '*RECUPD'
     C     RetCodeOut    IFEQ      '*ERROR '
     C     RetCodeOut    OREQ      '*ERTBTK'
     C                   ROLBK
     C                   END
     C     RetCodeOut    IFEQ      '*ERROR '
     C                   EXSR      *PSSR
     C                   ELSE
     C     RetCodeOut    IFNE      '*ERTBTK'
     C     ZATRNKD0      CHAIN     SDIBSRTD0                          99
     C  N99              DELETE    SDIBSRTD0
     C/COPY WNCPYSRC,SDBSRTRC02
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SDBSRT'                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   COMMIT
     C                   END
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     RetCodeOut    IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C***lh              MOVE      'N'           @ERRUP
      *
     C** If update not done due to error in Background Update of TABLETK file
      ** Send message 'Unable to update' to screen.
     C
     C                   IF        RETCodeOut =   '*ERTBTK'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR0015'     MsgIdArr(1)
     C                   MOVEL     'D'           @SCRN
     C                   GOTO      EUPDAT
     C                   ENDIF
     C                   ENDIF
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C     EUPDAT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
      *
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS BASE RATE
      * KH = COMMAND KEY 08 = READ NEXT BASE RATE
      *
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PARNAMES - Flag if there are changed participant names
      *****************************************************************
     C     PARNAMES      BEGSR
      *
      * If any 'P', the user to be prompted to confirm if new party or not
     C     'P'           LOOKUP    ChgNamArr                              99
     C                   MOVE      *IN99         CHGNAME           1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************

     C     TDtDtaSubs    BEGSR


     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      NwBsScnFmt    IncDATA        2000
      * Current Data
     C                   PARM      CrBsScnFmt    CurDATA        2000

     C                   MOVEL     IncDATA       NwBsScnFmt


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * GO TO DETAILS SCREEN
     C                   MOVEL     'D'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      * Parameters
     C     *ENTRY        PLIST
      * INPUTS
      *
      * Dummy, to re-use the menu control pgm for SD, SDC0001
      *
     C                   PARM                    DUMMY1            6
      *
      * Dummy, to re-use the menu control pgm for SD, SDC0001
      *
     C                   PARM                    DUMMY2            1
                                                                                              CSD012
     C* Override SDAULGL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDBSRTRPR'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if
      ** FRA/IRS  MT34*/ MT36* Message generation is installed
      *
     C                   MOVEL     'N'           CSW005
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW005
     C                   ENDIF
                                                                                              CSD006
     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   MOVE      'Y'           CSD006                                       CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CSD006                                       CSD006
     C                   ENDIF                                                                CSD006

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW011'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW011
     C                   ELSE
     C                   MOVE      'N'           CSW011
     C                   ENDIF

     C                   CALL      'SWIF2000'
     C                   PARM      *BLANKS       @RTCD
      *
     C     @RTCD         IFEQ      'CSW200'
     C                   MOVE      'Y'           CSW200
     C                   ELSE
     C                   MOVE      'N'           CSW200
     C                   ENDIF

     C                   EVAL      ISDAFlag = '1'
     C                   IF        CSW005  =  'Y'  OR
     C                             CSW011  =  'Y'  AND
     C                             CSW200  =  'Y'
     C                   EVAL      ISDAFlag = '0'
     C                   ENDIF
                                                                                              CSC011
      ** Check if switchable feature CSC011 is switched on.                                   CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 905                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSD012
      ** Check if CSD012 is installed                                                         CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANKS                                                    CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Base Rate Authorisation is ON                              CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     906           DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'SDBSRTRPR'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Base Rate Authorisation is On set to Authorise                                    CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL

     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011

      ** Get the field number for the action code field; the details
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM      *ZERO         FieldNo

     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset  = FieldNo - 1
     C                   ENDIF

      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDBSRTR010

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** CMD
OVRDBF FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
