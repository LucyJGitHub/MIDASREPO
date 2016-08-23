     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Account Desc.- Details 1 Validatn')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002241 - Midas ME Network Account Description Maint. *
      *                   (Details 1 Screen Validation - MT950        *
      *                   Details)                                    *
      *                                                               *
      *  Function:  This module validates the fields of the fisrt dtl *
      *             screen of a Network Account record.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD023237           Date 05Nov13               *
      *  Prev Amend No. CGL146             Date 10Jul13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023237 - Database error encountered when amending          *
      *             Generate Message to 'Y'. (Recompile)              *
      *             Amended hook: CGL146_051                          *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_020, CGL146_041,    *
      *                        CGL146_051, CGL146_052                 *
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
      * 41 - MT950 Generation Indicator                               *
      * 42 - Statement Frequency                                      *
      * 43 - Statement Day in Month                                   *
      * 44 - Next Statement Date                                      *
      * 45 - Demand of Statement Indicator                            *
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
     D FreqArr         C                   'DWFSMRTQXYLBAZ '
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLNWACPD)
      ** New Network Account File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(ME002221DF:ME002221F1)
      ** Detail 1 Screen Layout
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
     D/COPY OFCPYSRCZ,CGL146_020                                                              CGL146
 
      ** Declared variables
      ** ------------------
      *
 
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
 
      ** Generates MT950
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F1G950 = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN41
      *
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
      *
 B2  C                   IF        F1G950 <> 'Y' AND F1G950 <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN41
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN41
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** -- If the field is 'N'
      *
 B1  C                   IF        F1G950 = 'N'
      *
      ** ---- Entry in all the other fields is forbidden
      *
 B2  C                   IF        F15SFQ <> *Blank  OR F15SDY <> 0 OR
     C                             F15NSD <> *Blanks OR F15DSI <> *Blank
     C                   MOVE      'ME00043'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C  N42F15SFQ        COMP      *Blank                             4242
     C  N43F15SDY        COMP      0                                  4343
     C  N44F15NSD        COMP      *Blanks                            4444
     C  N45F15DSI        COMP      *Blank                             4545
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E2  C                   ENDIF
      *
      ** ---- End of module if the field is 'N'
      *
     C                   GOTO      @EndMod
 E1  C                   ENDIF
      *
      ** End Generates MT950
 
      ** N.B.: At this point, F1G950 is always 'Y' **
 
     C/COPY OFCPYSRCZ,CGL146_051                                                              CGL146
      ** Statement Frequency
      *
      ** -- The value must be valid
      *
     C                   IF        %Scan(F15SFQ:FreqArr) = 0
     C                   MOVE      'ME00044'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN42
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Statement Frequency
 
      ** Statement Day in Month
      *
      ** -- If the frequency is 'M', 'Q', 'X' or 'T'
      *
 B1  C                   IF        F15SFQ = 'M' OR F15SFQ = 'Q' OR
     C                             F15SFQ = 'X' OR F15SFQ = 'T'
      *
      ** ---- The field is mandatory
      *
 B2  C                   IF        F15SDY = 0
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN43
      *
      ** ---- The value must be between 01 and 31
      *
 X2  C                   ELSE
      *
 B3  C                   IF        F15SDY < 01 OR F15SDY > 31
     C                   MOVE      'ME00045'     ZAMSID
     C                   MOVE      *On           *IN43
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** -- Otherwise, the value must be zero
      *
 X1  C                   ELSE
      *
 B2  C                   IF        F15SDY <> 0
     C                   MOVE      'ME00046'     ZAMSID
     C                   MOVE      *On           *IN43
 E2  C                   ENDIF
 
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
      ** End Statement Day in Month
 
      ** Next Statement Date
      *
      ** -- If the frequency is 'Z' and the next statement date is blank,
      **    default it to "Run Date + 183" and redisplay the screen
      *
 B1  C                   IF        F15SFQ = 'Z' AND F15NSD = *Blank
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
     C                   EVAL      F15NSD = @ODate
     C                   EVAL      *IN40 = *On
 E1  C                   ENDIF
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F15NSD = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN44
      *
      ** -- The value must be valid and greater than or equal to the Run Date
      *
 X1  C                   ELSE
     C                   MOVEL(P)  F15NSD        @IDate
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
     C                   MOVE      *On           *IN44
 X2  C                   ELSE
     C                   MOVEL     @ODate        WWFld5N0
      *
 B3  C                   IF        WWFld5N0 < AGRDNB
     C                   MOVE      'ME00048'     ZAMSID
     C                   MOVE      *On           *IN44
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN44
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
 B1  C                   IF        F15DSI = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN45
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F15DSI <> 'Y' AND F15DSI <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN45
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Demand Statement Indicator
 
     C/COPY OFCPYSRCZ,CGL146_052                                                              CGL146
      ** End of the module
      *
     C     @EndMod       TAG
      *    ----------    ------
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
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
     C/COPY OFCPYSRCZ,CGL146_041                                                              CGL146
 
      ** Initialize error indicators with the values passed by the caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
 
      ** Reset general error indicator
      *
     C                   MOVE      *OFF          *IN40
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
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
(c) Misys International Banking Systems Ltd. 2002
