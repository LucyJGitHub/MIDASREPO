     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Dtl 2 Valid°')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002342 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance                     *
      *                   (Details 2 Screen Validation - MT940 Dtls)  *
      *                                                               *
      *  Function:  This module validates the fields of the second    *
      *             details screen of a Network Account MT94x Details *
      *             record.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR870148           Date 24Nov11               *
      *                 MD023237           Date 05Nov13               *
      *                 CGL146             Date 10Jul13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26381           Date 09Oct09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - MT940, MT941, MT942, MT950 Translation Table.       *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR870148 - Statement freq blank not accepted (Child:AR870149)*
      *  MD023237 - Database error encountered when amending          *
      *             Generate Message to 'Y'. (Recompile)              *
      *             Amended hooks: CGL146_053                         *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_033, CGL146_040     *
      *                        CGL146_051 52                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26381 - Two issues with MT940 statement generation        *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     F/COPY OFCPYSRCZ,CGL146_033                                                              CGL146
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Statement Frequency                                      *
      * 42 - Statement Day in Month                                   *
      * 43 - Next Statement Date                                      *
      * 44 - Demand of Statement Indicator                            *
      * 45 - Default MT940 Message Level Info. to Account Owner (1)   *
      * 46 - Default MT940 Message Level Info. to Account Owner (2)   *
      * 47 - Default MT940 Message Level Info. to Account Owner (3)   *
      * 48 - Default MT940 Message Level Info. to Account Owner (4)   *
      * 49 - Default MT940 Message Level Info. to Account Owner (5)   *
      * 50 - Default MT940 Message Level Info. to Account Owner (6)   *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 98 - Date format flag (*On if MDY / *Off if DMY)              *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************

      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Valid frequency codes
      *
     D*FreqArr**       C                   'DWFSMRTQXYLBAZ '                                BUG26381
     D*FreqArr**       C                   'DWFSMRTQXYLBAZE'                       BUG26381 AR870148
     D FreqArr         C                   'DWFSMRTQXYLBAZE '                               AR870148

      ** X SWIFT character set, minus Cr & Lf
      *
     D SwiftXSet       C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     abcdefghijklmnopqrstuvwxyz-
     D                                     0123456789 /-?:().,''+'

      ** Arrays and Data Structures
      ** --------------------------
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG26381
      ** DS for Switcheable Features Details                                                BUG26381
                                                                                            BUG26381
     D DSNwrk        E DS                  EXTNAME(SDNWRKPD)                                BUG26381
      ** DS FOR SD Message Network Details                                                  BUG26381
                                                                                            BUG26381
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG26381
      ** DS for access objects - short data structure                                       BUG26381
                                                                                            BUG26381
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG26381
      ** DS for access objects - short data structure                                       BUG26381

     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002322DF:ME002322F2)
      ** Detail 2 Screen Layout
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *

      ** Declared variables
      ** ------------------
      *
     D CER030          S              1A                                                    BUG26381
     D PRtcd           S             10A                                                    BUG26381
     D POptn           S              7A                                                    BUG26381
     D PSard           S              6A                                                    BUG26381
     D PRtCdIn         S              7A                                                    BUG26381
     D POptnIn         S              7A                                                    BUG26381
     D PNwrkIn         S              6A                                                    BUG26381
      *                                                                                     BUG26381
     D WMuCshE         S              1A                                                    BUG26381
     D KNwrk           S              6A                                                    BUG26381

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      *------------------------------------------------------------------------*
      *                      Details 1 Fields Validation                       *
      *------------------------------------------------------------------------*

     C/COPY OFCPYSRCZ,CGL146_053                                                              CGL146
      ** Statement Frequency
      *
      ** -- The value must be valid
      *
     C                   EVAL      WMuCshE = 'N'                                            BUG26381
     C                   If        CER030 = 'Y'                                             BUG26381
     C                   EXSR      SrNWRK                                                   BUG26381
     C                   Endif                                                              BUG26381
      *                                                                                     BUG26381
     C                   IF        %Scan(F20SFR:FreqArr) = 0
     C                   MOVE      'ME00044'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ELSE                                                               BUG26381
     C                   If        F20SFR = 'E' And                                         BUG26381
     C                             WMuCshE = 'N'                                            BUG26381
     C                   MOVE      'ME00269'     ZAMSID                                     BUG26381
     C                   EXSR      $ZaSndMsg                                                BUG26381
     C                   MOVE      *On           *IN41                                      BUG26381
     C                   MOVE      *On           *IN40                                      BUG26381
     C                   MOVEL(P)  '*MSG'        RetCodeOut                                 BUG26381
     C                   ENDIF                                                              BUG26381
     C                   ENDIF
      *
      ** End Statement Frequency

      ** Statement Day in Month
      *
      ** -- If the frequency is 'M', 'Q', 'X' or 'T'
      *
 B1  C                   IF        F20SFR = 'M' OR F20SFR = 'Q' OR
     C                             F20SFR = 'X' OR F20SFR = 'T'
      *
      ** ---- The field is mandatory
      *
 B2  C                   IF        F20SDM = 0
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN42
      *
      ** ---- The value must be between 01 and 31
      *
 X2  C                   ELSE
      *
 B3  C                   IF        F20SDM < 01 OR F20SDM > 31
     C                   MOVE      'ME00045'     ZAMSID
     C                   MOVE      *On           *IN42
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** -- Otherwise, the value must be zero
      *
 X1  C                   ELSE
      *
 B2  C                   IF        F20SDM <> 0
     C                   MOVE      'ME00046'     ZAMSID
     C                   MOVE      *On           *IN42
 E2  C                   ENDIF

 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN42
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Statement Day in Month

      ** Next Statement Date
      *
      ** -- If the frequency is 'Z' and the next statement date is blank,
      **    default it to "Run Date + 183" and redisplay the screen
      *
 B1  C                   IF        F20SFR = 'Z' AND F20NSD = *Blank
     C     AGRDNB        ADD       183           WWFld5N0          5 0
     C                   MOVEL(P)  WWFld5N0      @IDate
      *
     C   98              EVAL      @OFmt = '*MDY'
     C  N98              EVAL      @OFmt = '*DMY'
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate           10
     C                   PARM      *IN98         @IDatTyp          1
     C                   PARM      '*MIDAS'      @IFmt             7
     C                   PARM                    @OFmt             7
     C                   PARM      '*NONE'       @OSep             5
     C                   PARM                    @ODate           10
     C                   PARM                    @RtnCod           1
      *
     C                   EVAL      F20NSD = @ODate
     C                   EVAL      *IN40 = *On
 E1  C                   ENDIF
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F20NSD = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN43
      *
      ** -- The value must be valid and greater than or equal to the Run Date
      *
 X1  C                   ELSE
     C                   MOVEL(P)  F20NSD        @IDate
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      *Blanks       @IFmt
     C                   PARM      '*MIDAS'      @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod
      *
 B2  C                   IF        @RtnCod <> '0'
     C                   MOVE      'ME00047'     ZAMSID
     C                   MOVE      *On           *IN43
 X2  C                   ELSE
     C                   MOVEL     @ODate        WWFld5N0
      *
 B3  C                   IF        WWFld5N0 < AGRDNB
     C                   MOVE      'ME00048'     ZAMSID
     C                   MOVE      *On           *IN43
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN43
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Next Statement Date

      ** Demand Statement Indicator
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F20DSI = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN44

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F20DSI <> 'Y' AND F20DSI <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN44
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN44
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Demand Statement Indicator

      ** Default MT940 Information to Account Owner (1)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI1 = *Blanks AND
     C                             (F20MI2 <> *Blanks OR F20MI3 <> *Blanks OR
     C                              F20MI4 <> *Blanks OR F20MI5 <> *Blanks OR
     C                              F20MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN45
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI1 <> *Blanks
     C     SwiftXSet     CHECK     F20MI1:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN45
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Information to Account Owner (1)

      ** Default MT940 Information to Account Owner (2)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI2 = *Blanks AND
     C                             (F20MI3 <> *Blanks OR F20MI4 <> *Blanks OR
     C                              F20MI5 <> *Blanks OR F20MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN46
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI2 <> *Blanks
     C     SwiftXSet     CHECK     F20MI2:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN46
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN46
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Information to Account Owner (2)

      ** Default MT940 Information to Account Owner (3)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI3 = *Blanks AND
     C                             (F20MI4 <> *Blanks OR F20MI5 <> *Blanks OR
     C                              F20MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN47
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI3 <> *Blanks
     C     SwiftXSet     CHECK     F20MI3:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN47
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN47
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Information to Account Owner (3)

      ** Default MT940 Information to Account Owner (4)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI4 = *Blanks AND
     C                             (F20MI5 <> *Blanks OR F20MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN48
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI4 <> *Blanks
     C     SwiftXSet     CHECK     F20MI4:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN48
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN48
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Information to Account Owner (4)

      ** Default MT940 Information to Account Owner (5)
      *
      ** -- The field can't be blank if the following is filled
      *
     C                   IF        F20MI5 = *Blanks AND F20MI6 <> *Blanks
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN49
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI5 <> *Blanks
     C     SwiftXSet     CHECK     F20MI5:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN49
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN49
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Information to Account Owner (5)

      ** Default MT940 Information to Account Owner (6)
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI6 <> *Blanks
     C     SwiftXSet     CHECK     F20MI6:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              EXSR      $ZaSndMsg
     C   99              MOVE      *On           *IN50
     C   99              MOVE      *On           *IN40
     C   99              MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Information to Account Owner (6)
     C/COPY OFCPYSRCZ,CGL146_052                                                              CGL146

      ** End of the module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
                                                                                            BUG26381
      *========================================================================*            BUG26381
      * SrNWRK : Subroutine to check if Network is Multicash                   *            BUG26381
      *------------------------------------------------------------------------*            BUG26381
     C     SrNWRK        BEGSR                                                              BUG26381
      *                                                                                     BUG26381
     C                   EVAL      KNwrk = N4NWRK                                           BUG26381
     C                   CALL      'AONWRKR1'                                               BUG26381
     C                   PARM      *BLANKS       PRtCdIn                                    BUG26381
     C                   PARM      '*KEY'        POptnIn                                    BUG26381
     C                   PARM      KNwrk         PNwrkIn                                    BUG26381
     C     DSNwrk        PARM                    DSLDY                                      BUG26381
     C                                                                                      BUG26381
     C                   IF        EDMCNW = 'Y'                                             BUG26381
     C                   EVAL      WMuCshE = 'Y'                                            BUG26381
     C                   ENDIF                                                              BUG26381
      *                                                                                     BUG26381
     C                   ENDSR                                                              BUG26381

      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR

      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Return the current values of the error indicators
      *
     C                   MOVEA     *IN(40)       IN40_TO_70

     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80

      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10

      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF

     C                   MOVEL     'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7

      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
     C     AGDFF         COMP      'M'                                    98

      ** Initialize error indicators with the values passed by the caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)

      ** Reset general error indicator
      *
     C                   MOVE      *OFF          *IN40

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
      *                                                                                     BUG26381
      ** Check if feature CER030 is installed                                               BUG26381
      *                                                                                     BUG26381
     C                   CALLB     'AOSARDR0'                                               BUG26381
     C                   PARM      *BLANKS       PRtcd                                      BUG26381
     C                   PARM      '*VERIFY'     POptn                                      BUG26381
     C                   PARM      'CER030 '     PSard                                      BUG26381
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG26381
      *                                                                                     BUG26381
     C                   IF        PRtcd = *BLANKS                                          BUG26381
     C                   EVAL      CER030 = 'Y'                                             BUG26381
     C                   ELSE                                                               BUG26381
      *                                                                                     BUG26381
      ** Database error                                                                     BUG26381
      *                                                                                     BUG26381
     C                   IF        PRtcd <> '*NRF   '                                       BUG26381
     C     *LOCK         IN        LDA                                                      BUG26381
     C                   EVAL      DBKEY = PSard                                            BUG26381
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG26381
     C                   EVAL      DBASE = 01                                               BUG26381
     C                   OUT       LDA                                                      BUG26381
     C                   EXSR      *PSSR                                                    BUG26381
     C                   ELSE                                                               BUG26381
     C                   EVAL      CER030 = 'N'                                             BUG26381
     C                   ENDIF                                                              BUG26381
     C                   ENDIF                                                              BUG26381
     C/COPY OFCPYSRCZ,CGL146_040                                                              CGL146
      *    ----------    ------
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On

     C                   CALLB     'DBERRCTL'                           99

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
