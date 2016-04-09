     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Invalid transaction enquiry')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAINVTRENQ - INVALID TRANSACTION ENQUIRY                     *
      *                                                               *
      *  Function:  This screen function allows invalid               *
      *             transactions to be enquired upon.                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT039             Date 28Sep12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER034A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243320             Date 07Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9966            Date 17Jan06               *
      *                 CAAA03             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CPK016             Date 10Jul03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      *                 209385             Date 10Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 29May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014  *Create    Date 29Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Amendment done to accommodate longer data           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  243320 - Applied BUG9966.                                    *
      *  BUG9966 - %Scan fails if scan field is blank                 *
      *  CAAA03 - Webfacing Changes (recompile)                       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPK016 - Release 5 packaging.  Change of IBM APIs at 5.2.    *
      *  209905 - Fiduciary API Enhancement                           *
      *  209385 - Bottom-most field in error not highlighted during   *
      *           Enquire                                             *
      *  CSD006 - Remove second level /COPYs, and /COPYs not          *
      *           maintained in core.                                 *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP014 - Repair function enhancements                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZAINVTREDFCF   E             WORKSTN
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
                                                                                              CGL029
      ** API transaction errors by FO ID(40-long) and Timestamp                               CGL029
     FZATRNERRL2IF   E           K DISK    RENAME(ZATRNERRD0:ZATRNERRD2)                      CGL029
     F                                     INFSR(*PSSR)                                       CGL029
 
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
      ** The following /COPY line includes the procedure prototypes for the
      ** file fields procedures, and named constants used by those procedures
     D***** UTCPYSRC,FILEFLDSPR                                                               CPK016
     D/COPY QSYSINC/QRPGLESRC,QUSLFLD                                                         CPK016
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
 
     D TXTfoid         C                   CONST('Front Office transaction ID')
     D TXTasoc         C                   CONST('Associated Front Office -
     D                                     Transaction Id')
     D TXTrepa         C                   CONST('Repair location')
     D TXTtime         C                   CONST('Timestamp')
     D TXTmess         C                   CONST('Message Type')
 
      ** Array size for file field details arrays
     D*FieldArrSize    C                   300                                                209905
     D*FieldArrSize    C                   700                                        209905 CER034A
     D FieldArrSize    C                   2200                                              CER034A
 
      ** Array size for screen field arrays (?)
     D*ScnFldArrSize   C                   900                                               CER034A
     D ScnFldArrSize   C                   2200                                              CER034A
 
      ** Error code returned by the GenFileArrays procedure
     D ProcError       C                   'FldArrErr'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @ERFLD          S             10A   DIM(ScnFldArrSize)
 
     D @FLDN           S             10A   DIM(ScnFldArrSize)
     D @FLDD           S             30A   DIM(ScnFldArrSize)
     D @FLDC           S             35A   DIM(ScnFldArrSize)
 
     D @RPGN           S             10A   DIM(FieldArrSize)
     D @InpBuffPos     S             10I 0 DIM(FieldArrSize)
     D @FldLength      S             10I 0 DIM(FieldArrSize)
     D @DESC           S             30A   DIM(FieldArrSize)
                                                                                              CGL029
     D DDFO40          S             40A                                                      CGL029
     D WkGL            S              1A                                                      CGL029
 
     D @1RPGN          S             10A   DIM(FieldArrSize)
     D @1InpBuffPos    S             10I 0 DIM(FieldArrSize)
     D @1FldLength     S             10I 0 DIM(FieldArrSize)
     D @1DESC          S             30A   DIM(FieldArrSize)
 
     D @2RPGN          S             10A   DIM(FieldArrSize)
     D @2InpBuffPos    S             10I 0 DIM(FieldArrSize)
     D @2FldLength     S             10I 0 DIM(FieldArrSize)
     D @2DESC          S             30A   DIM(FieldArrSize)
 
     D @3RPGN          S             10A   DIM(FieldArrSize)
     D @3InpBuffPos    S             10I 0 DIM(FieldArrSize)
     D @3FldLength     S             10I 0 DIM(FieldArrSize)
     D @3DESC          S             30A   DIM(FieldArrSize)
 
     D ALLFD           DS
     D  DDFD01                 1     30
     D  DDFD02                31     60
     D  DDFD03                61     90
     D  DDFD04                91    120
     D  DDFD05               121    150
     D  DDFD06               151    180
     D  DDFD07               181    210
     D  DDFD08               211    240
     D  DDFD09               241    270
     D  DDFD10               271    300
 
     D ALLFC           DS
     D  DDFC01                 1     35
     D  DDFC02                36     70
     D  DDFC03                71    105
     D  DDFC04               106    140
     D  DDFC05               141    175
     D  DDFC06               176    210
     D  DDFC07               211    245
     D  DDFC08               246    280
     D  DDFC09               281    315
     D  DDFC10               316    350
 
     D RUNDAT          DS            13
     D  DDRUNA                 1      7
     D  DATFMT                12     12
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp
     D DDTMESTP        S             26Z
      **   Timestamp
     D                 DS
     D D@TMESTP                1     26A
     D DDYERT                  1      4A
     D DDMTHT                  6      7A
     D DDDAYT                  9     10A
     D DDTIMA                 12     19A
      **   Date of arrival
     D                 DS
     D DDDATA                  1     10A
     D DDDAYA                  1      2A
     D DDSLA1                  3      3A
     D DDMTHA                  4      5A
     D DDSLA2                  6      6A
     D DDYERA                  7     10A
 
      ** Array index
     D @P                             5P 0
 
      ** Message file
     D ZAMSFL                        10
      ** +--------------------------------------+
      ** ¦ Procedure prototypes                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
 
      ** This is the prototype for the GenFileArrays procedure.
      ** It can return an error code, and receives a file name
      ** and four arrays (by reference), which it will populate.
      ** Note that this prototype is placed here, rather than in a /COPY
      ** member, because the procedure is very specific to the processing
      ** in this module.
     D GenFileArrays   PR            10A
     D  FileName                     10A   value
     D  FieldNameArr                 10A   dim( FieldArrSize )
     D  FieldPosnArr                 10I 0 dim( FieldArrSize )
     D  FieldLenArr                  10I 0 dim( FieldArrSize )
     D  FieldTextArr                 30A   dim( FieldArrSize )
 
 
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
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * Write/Read Screen
      *
     C                   EXSR      WRSCRN
      *
      * DO WHILE COMMAND 3 OR 12 NOT TAKEN
      *
     C     @INKC         DOWEQ     '0'
     C     @INKL         ANDEQ     '0'
      *
      * Write/Read Screen
      *
     C                   EXSR      WRSCRN
     C                   ENDDO
      *
      *  Close down program
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   ENDIF
      *
      **  Clear screen message queue.
      *
     C                   CALL      'ZA0250'
      *
      *  Return
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* WRSCRN - WRITE/READ SCREEN
     C*****************************************************************
     C     WRSCRN        BEGSR
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   WRITE     #RCDDTL1
      *
     C                   MOVEA     '00'          *IN(15)
     C                   READ      #RCDDTL1                               99
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
      *
      ** If rollup requested, get next 10 fields and contents
      *
     C     *IN15         IFEQ      '1'
     C                   ADD       10            @P
     C     @P            IFGT      @LFN
     C                   Z-ADD     1             @P
     C                   ENDIF
     C                   EXSR      SETSFC
     C                   ELSE
      *
      ** If rolldown requested, get previous 10 fields and contents
      *
     C     *IN16         IFEQ      '1'
     C                   SUB       10            @P
     C     @P            IFLE      0
     C                   Z-ADD     1             @P
     C                   ENDIF
     C                   EXSR      SETSFC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
                                                                                              CGL029
      ** If called from GL, set flag and concatenate front office with associated             CGL029
      ** front office id                                                                      CGL029
                                                                                              CGL029
     C                   EVAL      WkGL = 'N'                                                 CGL029
     C                   IF        ReturnCode = 'GL        '                                  CGL029
     C                   EVAL      WkGL = 'Y'                                                 CGL029
     C                   EVAL      DDFO40 = DDFOTI + DDFOAS                                   CGL029
     C                   EVAL      ReturnCode = *BLANKS                                       CGL029
     C                   ELSE                                                                 CGL029
     C                   EVAL      DDFO40 = DDFOTI                                            CGL029
     C                   EVAL      DDFOAT = DDFOAS                                            CGL029
     C                   ENDIF                                                                CGL029
      *
      * CLEAR OUTPUTS
      *
     C                   MOVEL     *BLANK        ReturnCode
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
      ** Format date and time of arrival for display
      *
     C                   MOVE      DDTMESTP      D@TMESTP
     C                   MOVEL     DDDAYT        DDDAYA
     C                   MOVEL     DDMTHT        DDMTHA
     C                   MOVEL     DDYERT        DDYERA
     C                   MOVE      '/'           DDSLA1
     C                   MOVE      '/'           DDSLA2
      *
      ** Clear log of fields in error
      *
     C                   CLEAR                   @ERFLD                         *
      *
      ** Read error messages for transaction
      *
     C                   IF        WkGL = 'Y'                                                 CGL029
     C     ZATRNKD2      SETLL     ZATRNERRD2                                                 CGL029
     C     ZATRNKD2      READE     ZATRNERRD2                             99                  CGL029
     C                   ELSE                                                                 CGL029
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDIF                                                                CGL029
      *
      ** Add error message to subfile
      *
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     ABMSGID       @WERR             7
     C                   MOVEL     ABMSGFILE     @WERRFL          10
     C                   MOVEL     ABFIELDNAM    @WFLDN           10
     C                   EXSR      ERROR
                                                                                              CGL029
      ** If coming from GL, use ZATRNERRL2 file instead                                       CGL029
                                                                                              CGL029
     C                   IF        WkGL = 'Y'                                                 CGL029
     C     ZATRNKD2      READE     ZATRNERRD2                             99                  CGL029
     C                   ELSE                                                                 CGL029
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDIF                                                                CGL029
     C                   ENDDO
      *
      * Fill field description and contents arrays
      *
     C                   Z-ADD     1             @P
     C                   MOVEL     *BLANK        @FLDD
     C                   MOVEL     *BLANK        @FLDC
      *
     C     InvFile1      IFNE      *BLANK
     C***********        MOVEL     InvFDta1      InvFDta        2000            CFT014
     C**********         MOVEL     InvFDta1      InvFDta        4000                   CFT014 209905
     C**********         MOVEL     InvFDta1      InvFDta        5000                   209905 CFT039
     C                   MOVEL     InvFDta1      InvFDta       12000                          CFT039
     C                   MOVEA     @1RPGN        @RPGN
     C                   MOVEA     @1InpBuffPos  @InpBuffPos
     C                   MOVEA     @1FldLength   @FldLength
     C                   MOVEA     @1DESC        @DESC
     C                   EXSR      FILLARR
     C                   ENDIF
      *
     C     InvFile2      IFNE      *BLANK
     C                   MOVEL     InvFDta2      InvFDta
     C                   MOVEA     @2RPGN        @RPGN
     C                   MOVEA     @2InpBuffPos  @InpBuffPos
     C                   MOVEA     @2FldLength   @FldLength
     C                   MOVEA     @2DESC        @DESC
     C                   EXSR      FILLARR
     C                   ENDIF
      *
     C     InvFile3      IFNE      *BLANK
     C                   MOVEL     InvFDta3      InvFDta
     C                   MOVEA     @3RPGN        @RPGN
     C                   MOVEA     @3InpBuffPos  @InpBuffPos
     C                   MOVEA     @3FldLength   @FldLength
     C                   MOVEA     @3DESC        @DESC
     C                   EXSR      FILLARR
     C                   ENDIF
      *
      * Store last field number
      *
     C                   Z-ADD     @P            @LFN              5 0
      *
      * Set initial screen fields and contents
      *
     C                   Z-ADD     1             @P
     C                   EXSR      SETSFC
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * SETSFC - Set Screen Fields and Contents                        *
      *****************************************************************
     C     SETSFC        BEGSR
      *
      * Move field description and contents into output fields
      *
     C                   MOVEL     *BLANK        ALLFD
     C                   MOVEL     *BLANK        ALLFC
     C                   MOVEA     @FLDD(@P)     ALLFD
     C                   MOVEA     @FLDC(@P)     ALLFC
      *
      * If a field is in error, highlight it
      *
     C                   MOVEA     '0000000000'  *IN(01)
     C                   Z-ADD     @P            @Q
     C                   Z-ADD     1             @R                5 0
     C*****@R***         DOUEQ     10                                                         209385
     C     @R            DOUEQ     11                                                         209385
     C                   MOVEL     @FLDN(@Q)     @WFLDN
     C     @WFLDN        IFNE      *BLANK                                       *
     C     @WFLDN        LOOKUP    @ERFLD                                 99    *
     C     *in99         IFEQ      '1'
     C                   MOVE      '1'           *IN(@R)
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             @Q
     C                   ADD       1             @R
     C                   ENDDO
 
      ** Set the "More/Bottom" text display
     C                   EVAL      TEXTMSG = 'APA0204'
     C                   IF        @Q >= @LFN
     C                   EVAL      TEXTMSG = 'APA0205'
     C                   ENDIF
 
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * FILLARR - Fill Field Description and Contents Arrays          *
      *****************************************************************
     C     FILLARR       BEGSR
 
     C                   Z-ADD     1             @Q                5 0
 
     C     @Q            DOWLE     FieldArrSize
     C     @DESC(@Q)     ANDNE     *BLANK
 
     C                   EVAL      @FLDN(@P) = @RPGN(@Q)
     C                   EVAL      @FLDD(@P) = @DESC(@Q)
 
      ** Extract the field data from the file's buffer
     C                   EVAL      @FLDC(@P) = %subst( InvFDta :
     C                                                 @InpBuffPos(@Q) :
     C                                                 @FldLength(@Q) )
 
     C                   ADD       1             @P
 
     C                   ADD       1             @Q
 
     C                   ENDDO
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
      * ERROR    - CALL PROGRAM ZA0240 TO OUTPUT ERROR MESSAGES       *
     C*****************************************************************
     C     ERROR         BEGSR
     C*
     C*  Display error message
     C*
     C                   MOVEL     *BLANK        ZAMSID           10
     C                   MOVEL     *BLANK        ZAMSFL           10
     C                   MOVEL     @WERR         ZAMSID
     C                   MOVEL     @WERRFL       ZAMSFL
     C                   CALL      'ZA0340'
     C                   PARM                    ZAMSFL
     C                   PARM                    ZAMSID
     C*
     C* Log field in error
     C*
     C                   Z-ADD     1             @P
     C     @WFLDN        LOOKUP    @ERFLD(@P)                             99    *
     C     *IN99         IFEQ      '0'
     C     *BLANK        LOOKUP    @ERFLD(@P)                             99    *
     C                   MOVEL     @WFLDN        @ERFLD(@P)                     *
     C                   ENDIF
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
     C     *ENTRY        PLIST
 
      * INPUTS
 
      * Return Code
     C                   PARM                    ReturnCode
      * Action code
      * Front Office ID
      * Associated Front Office ID
      * Timestamp
     C                   PARM                    DDACTN            1
     C                   PARM                    DDFOTI           20
     C**********         PARM                    DDFOAT           20                          CGL029
     C                   PARM                    DDFOAS           20                          CGL029
     C                   PARM                    DDTMESTP
 
      * Invalid file names
     C                   PARM                    InvFile1         10
     C                   PARM                    InvFile2         10
     C                   PARM                    InvFile3         10
 
      * Invalid file data
     C***********        PARM                    InvFDta1       2000            CFT014
     C***********        PARM                    InvFDta2       2000            CFT014
     C***********        PARM                    InvFDta3       2000            CFT014
     C**********         PARM                    InvFDta1       4000                   CFT014 CFT039
     C                   PARM                    InvFDta1      12000                          CFT039
     C                   PARM                    InvFDta2       4000            CFT014
     C**********         PARM                    InvFDta3       4000                   CFT014 209905
     C                   PARM                    InvFDta3       5000                          209905
 
      * OUTPUTS
 
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      **  Run date in DDMMMYY
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTI
     C                   KFLD                    DDTMESTP
      *                                                                                       CGL029
     C     ZATRNKD2      KLIST                                                                CGL029
     C                   KFLD                    DDFO40                                       CGL029
     C                   KFLD                    DDTMESTP                                     CGL029
      *
      ** Initialize program name
      *
     C                   MOVEL     'ZAINVTRENQ'  DBPGM
     C                   MOVEL     'ZAINVTRENQ'  ##PGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      * Get invalid file field attributes and description
      *
     C     InvFile1      IFNE      *BLANK
     C                   MOVEL     InvFile1      InvFile          10
     C                   EXSR      GETFILD
     C                   MOVEA     @RPGN         @1RPGN
     C                   MOVEA     @InpBuffPos   @1InpBuffPos
     C                   MOVEA     @FldLength    @1FldLength
     C                   MOVEA     @DESC         @1DESC
     C                   ENDIF
      *
     C     InvFile2      IFNE      *BLANK
     C                   MOVEL     InvFile2      InvFile
     C                   EXSR      GETFILD
     C                   MOVEA     @RPGN         @2RPGN
     C                   MOVEA     @InpBuffPos   @2InpBuffPos
     C                   MOVEA     @FldLength    @2FldLength
     C                   MOVEA     @DESC         @2DESC
     C                   ENDIF
      *
     C     InvFile3      IFNE      *BLANK
     C                   MOVEL     InvFile3      InvFile
     C                   EXSR      GETFILD
     C                   MOVEA     @RPGN         @3RPGN
     C                   MOVEA     @InpBuffPos   @3InpBuffPos
     C                   MOVEA     @FldLength    @3FldLength
     C                   MOVEA     @DESC         @3DESC
     C                   ENDIF
      *
      **  Clear screen message queue.
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GETFILD - Get File Details                                    *
      *****************************************************************
     C     GETFILD       BEGSR
 
      ** Clear the arrays before use, to prevent pollution from prior calls
     C                   CLEAR                   @RPGN
     C                   CLEAR                   @InpBuffPos
     C                   CLEAR                   @FldLength
     C                   CLEAR                   @DESC
 
      ** Populate the arrays for the current file.  If there was a problem
      ** the subprocedure will return the ProcError value, in which case
      ** this module ends with an error code.
     C                   IF        GenFileArrays(InvFile : @RPGN :
     C                                           @InpBuffPos : @FldLength :
     C                                           @DESC) = ProcError
 
     C                   EVAL      ReturnCode = 'Error'
     C                   DUMP
     C                   RETURN
 
     C                   ENDIF
 
 
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GenFileArrays - Generate the arrays of file fields data       *
      *                                                               *
      *****************************************************************
     P GenFileArrays   B
 
      * NOTE: this constant is redefined here, as, although it is defined
      *       in the main procedure D-specs, the compiler does not
      *       recognise named constants as global.
      * Array size for file field details arrays
     D*FieldArrSize    C                   300                                                209905
     D*FieldArrSize    C                   700                                        209905 CER034A
     D FieldArrSize    C                   2200                                              CER034A
 
     D GenFileArrays   PI            10A
     D  FileName                     10A   value
     D  FieldNameArr                 10A   dim( FieldArrSize )
     D  FieldPosnArr                 10I 0 dim( FieldArrSize )
     D  FieldLenArr                  10I 0 dim( FieldArrSize )
     D  FieldTextArr                 30A   dim( FieldArrSize )
 
 
      * --------------------------------------------------------------------
      * Named constants
      * ---------------
 
      * The following constant contains field name descriptions whose
      * fields are to be excluded from the arrays.
     D ExcludedTexts   C                   'Front Office transaction ID -
     D                                     Associated Front Office -
     D                                     Transaction Id -
     D                                     Repair location -
     D                                     Timestamp -
     D                                     Message Type -
     D                                     Front Office Assoc Deal ID -
     D                                     Deal Repair Location -
     D                                     Front Office Id -
     D                                     Repair Location'
 
 
      * --------------------------------------------------------------------
      * Standalone fields
      * -----------------
 
      * Input buffer position
     D InpBuffPos      S              5S 0
 
      * Field length
     D FldLength       S              5S 0
 
      * Index for the arrays
     D Index           S              5I 0
 
      * File handle used by the fields description procedures
     D FileHandle      S             10A
 
      * --------------------------------------------------------------------
      * Automatic inclusions
      * --------------------
 
      **The*following*/COPY*includes*the*structure*for*the*QUSFLD*API,**********              CSD006
      **which*is*used*by*procdures*called*from*this*procedure,*and**************              CSD006
      **one*of*the*structures*is*returned*to*this*procedure.********************              CSD006
      *****/if*not*defined(QUSLFLD_included)************************************              CSD006
      *****/define*QUSLFLD_included*********************************************              CSD006
     D*****/COPY*QSYSINC/QRPGLESRC,QUSLFLD                                                    CSD006
      *****/endif***************************************************************              CSD006
                                                                                              CSD006
      ** The following /COPY line includes the procedure prototypes for the                   CSD006
      ** file fields procedures, and named constants used by those procedures.                CSD006
     D/COPY UTCPYSRC,FILEFLDSPR                                                               CSD006
      **                                                                                      CSD006
 
      * First generate the file fields description data.  The procedure
      * returns a file handle which subsequent procedures use to refer to
      * the data for the file in question.
     C                   eval      FileHandle =
     C                                GenFileFldList( FileName + '*LIBL' )
 
      * If an error occurred the handle will contain one of the error codes.
      * APIERR is a general error (a dump will also have been produced);
      * APIFULL means that we are trying to generate the data for more
      * than the maximum possible number of files.  At the time of writing
      * this was 2000, so it is not very likely.
     C                   IF        FileHandle = APIERR OR
     C                                FileHandle = APIFULL
     C                   RETURN    ProcError
     C                   ENDIF
 
      * --------------------------------------------------------------------
 
      * Initialise some values.
     C                   CLEAR                   QUSL0100
     C                   EVAL      Index = 1
 
      * Loop until all the entries have been returned for the file (the
      * do-until loop is eternal; exiting is handled within the loop.
     C                   DOU       'Starsky' = 'Hutch'
 
      * Retrieve the details of the next field; the subprocedure retains
      * details of where it is in the list; all it needs is the file
      * handle.  QUSL0100 is a structure defined in a QSYSINC /COPY
      * member, which contains all the details we need (and more).
     C                   EVAL      QUSL0100 =
     C                                GetNextFldEnt( FileHandle )
 
      * If an error was reported, indicate this to the caller.
     C                   IF        %subst( QUSL0100 : 1 : 10 ) = APIERR
     C                   RETURN    ProcError
     C                   ENDIF
 
      * End normally if GetNextFldEnt() indicates that all the
      * entries have been processed.
     C                   IF        %subst( QUSL0100 : 1 : 10 ) = APIEND
     C                   RETURN    *blanks
     C                   ENDIF
 
      * --------------------------------------------------------------------
      *                                                                                      BUG9966
      * %Scan fails if there is no text entry.  In this case, set the text                   BUG9966
      * to an excluded text - if the field text is blank, it is almost                       BUG9966
      * certainly redundant, so we don't want to display it.                                 BUG9966
     C                   If        QUSFTD = *Blanks                                          BUG9966
     C                   Eval      QUSFTD = 'Timestamp'                                      BUG9966
     C                   EndIf                                                               BUG9966
 
      * Put the relevant fields in the arrays, unless the field texts are
      * in the exclusions list.
     C                   IF        %scan( %trim(QUSFTD) : ExcludedTexts )
     C                                 = 0
 
     C                   EVAL      FieldNameArr( Index ) = QUSFN02
     C                   EVAL      FieldTextArr( Index ) = QUSFTD
     C                   EVAL      FieldPosnArr( Index ) = QUSIBP
     C                   EVAL      FieldLenArr( Index ) = QUSFLB
 
      * Increment the array index for the next time round the loop.
     C                   EVAL      Index = Index + 1
 
     C                   ENDIF
      *                  (End of "If field text not in exluded texts")
 
      * --------------------------------------------------------------------
 
     C                   ENDDO
      *                  (End of "Do until last entry processed")
 
     P GenFileArrays   E
