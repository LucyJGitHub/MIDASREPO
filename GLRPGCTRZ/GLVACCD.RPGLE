     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *: OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)             : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate action code, a/c no. & review fr')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVACCD   - Validate Action Code, A/C No. & Review from fld  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. FVT106             Date 20Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT106 - Automatic Account Closure and Account re-opening    *
      *           Addition of hooks FVT106_001 to FVT106_005          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase account code to 10 digits                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMTBF)

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

      ** Data Structure for Account Key Number
      *  Account Master Key
     D                 DS
     D**ACKEY***               1     18                                                       CGL029
     D  ACKEY                  1     24                                                       CGL029
     D  WWBRCA                 1      3
     D**WWCNUM**               4      9  0                                                    CSD027
     D  WWCNUM                 4      9                                                       CSD027
     D  WWCCY                 10     12
     D**WWACOD**              13     16  0                                                    CGL029
     D**WWACSQ**              17     18  0                                                    CGL029
     D  WWACOD                13     22  0                                                    CGL029
     D  WWACSQ                23     24  0                                                    CGL029
     D  RETKY                  1     10
     D**ACCKY***              11     18                                                       CGL029
     D  ACCKY                 11     24                                                       CGL029

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CGL029
     D DDACCN          S             24                                                       CGL029
     D DDRFRA          S             24                                                       CGL029
     D WGLKEY          S             24                                                       CGL029

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

     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blanks       FldNamXAr
     C                   Movel     *Blanks       MsgIDXAr
     C                   Movel     *Blanks       MsgDtaXAr
     C                   Z-add     0             Idx
      *
      ** Check if Action Code entered is valid - Must be I, A, D or E
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     '1'
     C     DDACTN        ANDNE     '2'
     C     DDACTN        ANDNE     '3'
     C     DDACTN        ANDNE     '4'
     C     DDACTN        ANDNE     '5'
     C     DDACTN        ANDNE     *BLANK
     C/COPY WNCPYSRC,FVT106_001                                                     FVT106
     C                   Move      'N'           DDACTNOk
     C                   Add       1             Idx
     C                   Movel     'DDACTN'      FldNamXAr(Idx)
     C                   Movel     'RE71001'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACTION CODE ENTERED IS I, A, OR D, USER MUST BE
      ** AUTHORISED TO GO ON
      *
      ** TEST IF AUTHORISED TO INSERT
      *
     C     DDACTN        IFEQ      'I'
     C     *IN40         ANDNE     '1'
     C                   Move      'N'           DDACTNOk
     C                   Add       1             Idx
     C                   Movel     'DDACTN'      FldNamXAr(Idx)
     C                   Movel     'RE71002'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** TEST IF AUTHORISED TO AMEND
      *
     C     DDACTN        IFEQ      'A'
     C     *IN41         ANDNE     '1'
     C                   Move      'N'           DDACTNOk
     C                   Add       1             Idx
     C                   Movel     'DDACTN'      FldNamXAr(Idx)
     C                   Movel     'RE71003'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** TEST IF AUTHORISED TO DELETE
      *
     C     DDACTN        IFEQ      'D'
     C     *IN42         ANDNE     '1'
     C                   Move      'N'           DDACTNOk
     C                   Add       1             Idx
     C                   Movel     'DDACTN'      FldNamXAr(Idx)
     C                   Movel     'RE71004'     MsgIDXAr(Idx)
     C                   ENDIF
     C/COPY WNCPYSRC,FVT106_002                                                     FVT106
      *
      ** IF ACTION CODE NOT I OR D ENTERED, ACCOUNT NUMBER CANNOT BE BLANK
      *
     C     DDACTN        IFEQ      'A'
     C     DDACCN        ANDEQ     *BLANKS
     C     *IN41         ANDEQ     '1'
     C     DDACTN        OREQ      'E'
     C     DDACCN        ANDEQ     *BLANKS
     C     DDACTN        OREQ      '1'
     C     DDACCN        ANDEQ     *BLANKS
     C     DDACTN        OREQ      '2'
     C     DDACCN        ANDEQ     *BLANKS
     C     DDACTN        OREQ      '3'
     C     DDACCN        ANDEQ     *BLANKS
     C     DDACTN        OREQ      '4'
     C     DDACCN        ANDEQ     *BLANKS
     C     DDACTN        OREQ      '5'
     C     DDACCN        ANDEQ     *BLANKS
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71005'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** TEST IF AT LEAST ONE COMMISSION INSTALED
      *
     C     DDACTN        IFEQ      '4'
     C     @IN34         ANDNE     '1'
     C                   Move      'N'           DDACTNOk
     C                   Add       1             Idx
     C                   Movel     'DDACTN'      FldNamXAr(Idx)
     C                   Movel     'RE71016'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACTION CODE I OR D, ACCOUNT NUMBER MUST BE BLANK
      *
     C     DDACTN        IFEQ      'I'
     C     DDACCN        ANDNE     *BLANKS
     C     DDACTN        OREQ      'D'
     C     DDACCN        ANDNE     *BLANKS
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71012'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACCOUNT NUMBER ENTERED, ACTION CODE CANNOT BE BLANK
      *
     C     DDACTN        IFEQ      *BLANK
     C     DDACCN        ANDNE     *BLANKS
     C                   Move      'N'           DDACTNOk
     C                   Add       1             Idx
     C                   Movel     'DDACTN'      FldNamXAr(Idx)
     C                   Movel     'RE71006'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF REVIEW FROM ENTERED, ACTION CODE AND ACCOUNT NUMBER
      ** MUST BE BLANKS
      *
     C     DDRFRA        IFNE      *BLANKS
     C     DDACTN        ANDNE     *BLANK
     C     DDRFRA        ORNE      *BLANKS
     C     DDACCN        ANDNE     *BLANKS
     C                   Move      'N'           DDRFRAOk
     C                   Add       1             Idx
     C                   Movel     'DDRFRA'      FldNamXAr(Idx)
     C                   Movel     'RE71007'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACTION CODE ENTERED AND ACCOUNT NUMBER ENTERED AND REVIEW FROM
      ** NOT REQUESTED THEN CHECK ON FILE FOR VALID ACCOUNT NUMBER
      *
     C     DDACTN        IFNE      *BLANK
     C     DDACCN        ANDNE     *BLANKS
     C     DDRFRA        ANDEQ     *BLANKS
     C     Idx           ANDEQ     0
      *
      ** TEST IF RETAIL NUMBER OR ACCOUNT NUMBER ENTERED
      *
     C                   MOVEL     *BLANKS       ACKEY
     C                   MOVEL     DDACCN        ACKEY
      *
      ** IF POSITIONS 11 TO 15 BLANK THEN IT IS A RETAIL NUMBER
      ** OTHERWISE IT IS A MIDAS NUMBER
      *
      ** RESET CHECK FIELD TO PROCESS IN CASE OF NOT FOUND
      *
     C                   MOVE      *BLANK        ACST
     C                   MOVE      *BLANK        RECI
      *
     C     ACCKY         IFNE      *BLANKS
     C     WWACKB        CHAIN     ACCNTLXX                           81
     C                   ELSE
     C                   MOVE      RETKY         WWRKEY           10 0
      *
     C     WWRKEY        CHAIN     ACNUM                              81
     C                   MOVE      CNUM          WWCNUM
     C                   MOVE      CCY           WWCCY
     C                   MOVE      ACOD          WWACOD
     C                   MOVE      ACSQ          WWACSQ
     C                   MOVE      BRCA          WWBRCA
      *
     C                   ENDIF
      *
      ** DO VALIDATION ON BRANCH INPUT IF MULTIBRANCH
     C     *IN81         IFEQ      *OFF
      *
     C     BJSBRC        IFEQ      *BLANKS
     C     DDACTN        ANDNE     *BLANKS
     C     DDACCN        ANDNE     *BLANKS
     C                   MOVEL     WWBRCA        @BRCA
      *
     C     DDACTN        IFEQ      '1'
     C     DDACTN        OREQ      '2'
     C     DDACTN        OREQ      '3'
     C     DDACTN        OREQ      '4'
     C     DDACTN        OREQ      '5'
     C                   MOVEL     'E'           @ZACTN
     C                   ELSE
     C                   MOVEL     DDACTN        @ZACTN
     C                   ENDIF
      *
     C                   EXSR      #AUTH
      *
     C     @ERR          IFNE      0
     C                   Add       1             Idx
     C                   SELECT
     C     @ZACTN        WHENEQ    'I'
     C                   Movel     'RE7102B'     MsgIDXAr(Idx)
     C     @ZACTN        WHENEQ    'A'
     C                   Movel     'RE7103B'     MsgIDXAr(Idx)
     C     @ZACTN        WHENEQ    'D'
     C                   Movel     'RE7104B'     MsgIDXAr(Idx)
     C     @ZACTN        WHENEQ    'E'
     C                   Movel     'RE7105B'     MsgIDXAr(Idx)
     C/COPY WNCPYSRC,FVT106_003                                                     FVT106
     C                   ENDSL
     C                   Move      'N'           DDACTNOk
     C                   Movel     'DDACTN'      FldNamXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** IF AMEND MODE REQUESTED ,
      ** RECORD MUST   EXIST ON FILE AND MUST BE LIVE
      *
     C     DDACTN        IFEQ      'A'
     C     *IN81         ANDEQ     '1'
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71022'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'A'
     C     *IN81         ANDEQ     '0'
     C     ACST          ANDEQ     'C'
     C     RECI          IFEQ      'C'
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71021'     MsgIDXAr(Idx)
     C                   ELSE
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71013'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,FVT106_004                                                     FVT106
      *
     C                   ENDIF
      *
      ** IF ENQUIRY MODE REQUESTED ,
      ** RECORD MUST   EXIST ON FILE
      *
     C     DDACTN        IFEQ      'E'
     C     *IN81         ANDEQ     '1'
     C     DDACTN        OREQ      '1'
     C     *IN81         ANDEQ     '1'
     C     DDACTN        OREQ      '2'
     C     *IN81         ANDEQ     '1'
     C     DDACTN        OREQ      '3'
     C     *IN81         ANDEQ     '1'
     C     DDACTN        OREQ      '4'
     C     *IN81         ANDEQ     '1'
     C     DDACTN        OREQ      '5'
     C     *IN81         ANDEQ     '1'
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71022'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACTION '2','3','4' OR '5' REQUESTED ACCOUNT MUST BE RETAIL
      *
     C     IDX           IFEQ      0
      *
     C     DDACTN        IFEQ      '2'
     C     ATYP          ANDNE     'R'
     C     DDACTN        OREQ      '3'
     C     ATYP          ANDNE     'R'
     C     DDACTN        OREQ      '4'
     C     ATYP          ANDNE     'R'
     C     DDACTN        OREQ      '5'
     C     ATYP          ANDNE     'R'
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71011'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF FOURTH SCREEN REQUESTED AND NO COMMISSION THAN FORBIDDEN
      *
     C     DDACTN        IFEQ      '4'
     C     @IN34         ANDNE     '1'
     C                   Move      'N'           DDACCNOk
     C                   Add       1             Idx
     C                   Movel     'DDACCN'      FldNamXAr(Idx)
     C                   Movel     'RE71016'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDACTNOK      IfEq      'N'
     C     DDACCNOK      OrEq      'N'
     C     DDRFRAOK      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVE      ACKEY         WGLKEY
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *  #AUTH - CHECK ACTION CODE AND BRANCH AUTHORITY
      *****************************************************************
     C     #AUTH         BEGSR
      *
      ** Multi-branch system, user must be authorised to action on
      ** branch.
      *
     C     AGMBIN        IFEQ      'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @BRCA             3
     C                   PARM                    @ERR              1 0
      *
     C                   ELSE
      *
      ** Single branch system, check user is authorised to action code
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    @ZACTN
     C                   PARM                    @ERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        Plist
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDACTN            1
     C**********         Parm                    DDACCN           18                          CGL029
     C**********         Parm                    DDRFRA           18                          CGL029
     C                   Parm                    DDACCN                                       CGL029
     C                   Parm                    DDRFRA                                       CGL029
      *
     C                   Parm                    @IN34             1
      *
      ** ICD
     C                   Parm                    DBRN              3
     C                   Parm                    BJSBRC            3
     C                   Parm                    AGMBIN            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Full GL Account Number
     C**********         Parm                    WGLKEY           18                          CGL029
     C                   Parm                    WGLKEY                                       CGL029
      *
      ** Action code - OK
      ** Account Number - OK
      ** Review From Account - OK
     C                   Parm                    DDACTNOK          1
     C                   Parm                    DDACCNOK          1
     C                   Parm                    DDRFRAOK          1
      *
      ** Key list for ACCNTLXX
     C     WWACKB        KLIST
     C                   KFLD                    WWBRCA
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWCCY
     C                   KFLD                    WWACOD
     C                   KFLD                    WWACSQ
      *
     C                   MOVE      DBRN          @BRCA
      *
      ** Prepare Input Authorisation
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   MOVE      'I'           @ZACTN
     C                   EXSR      #AUTH
     C     @ERR          IFEQ      0
     C                   MOVE      '1'           *IN40
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
      ** Prepare Amend Authorisation
      *
     C                   MOVE      'A'           @ZACTN
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      #AUTH
     C     @ERR          IFEQ      0
     C                   MOVE      '1'           *IN41
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           *IN41
     C                   ENDIF
      *
      ** Prepare Close Authorisation
      *
     C                   MOVE      'D'           @ZACTN
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      #AUTH
     C     @ERR          IFEQ      0
     C                   MOVE      '1'           *IN42
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           *IN42
     C                   ENDIF
     C/COPY WNCPYSRC,FVT106_005                                                     FVT106
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
