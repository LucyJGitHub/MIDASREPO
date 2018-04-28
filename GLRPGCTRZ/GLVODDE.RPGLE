     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Overdraft Details')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVODDE    - Validate Overdraft Details                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD029023           Date 21Nov14               *
      *  Prev Amend No. MD019907           Date 30Spe13               *
      *                 CER055             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG5543            Date 23Mar05               *
      *                 BUG5746            Date 11Feb05               *
      *                 BUG4859            Date 15Nov04               *
      *                 BUG4665            Date 26Oct04               *
      *                 BUG4161            Date 03Sep04               *
      *                 BUG4124            Date 01Sep04               *
      *                 BUG3938            Date 27Aug04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029023 - Should not validate Additional O/D Change Value   *
      *             Date if Additional O/D Rate unchanged.            *
      *           - Need to pass debit rate spread for validation of  *
      *             Additional O/D Rate                               *
      *  MD019907 - 0 HISD value in REODHSPD when OD expiry is        *
      *             amended but Change Value Date is left blank.      *
      *             Added validation to ensure that when OD Expiry    *
      *             is amended OD Change Value Date should be input   *
      *             as well.                                          *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  BUG5543 - Default value of ODSC to be 'N' when left blank.   *
      *            Valid values are now Y/N.                          *
      *  BUG5746 - Overdraft line will be set by the JSP to 'Y' or    *
      *            blank. 'N' would now be the wrong value but it     *
      *            can never be entered with the tick-box in place.   *
      *  BUG4859 - Additional overdraft sign now defaults to '+',     *
      *            blank is no longer allowed.                        *
      *            Remove unhelpful part of BUG4161.                  *
      *  BUG4665 - After BUG4565 blank overdraft line is no longer    *
      *            blank. Need to rework BUG4161 fix.                 *
      *  BUG4161 - Only raise Overdraft line error if entry is 'Y'.   *
      *            Tidy up overdraft error reporting.                 *
      *  BUG4124 - Error message should be Overdraft Secured cannot   *
      *            be 'Y' when Overdraft Line is empty.               *
      *  BUG3938 - ZALIGN allows 'M' and 'T' but this is not          *
      *            intended for the commission amount.                *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Array of Fields with warnings.                                                       CER055
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CER055
                                                                                              CER055
      ** Array of warning message IDs                                                         CER055
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CER055
                                                                                              CER055
      ** Array of warning message data.                                                       CER055
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CER055
     D/COPY WNCPYSRC,GLH00591
                                                                                              CER055
      ** Array of overdraft line data.                                                       BUG3938
     D ARODLN          S              1    DIM(12)                                           BUG3938
                                                                                             BUG3938
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     DAMDRIB           S              2S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0                                                    CER055
     D/COPY WNCPYSRC,GLH00581
 
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
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   MoveL     *Blanks       WFldNmXAr                                    CER055
     C                   MoveL     *Blanks       WMsgIDXAr                                    CER055
     C                   MoveL     *Blanks       WMsgDtXAr                                    CER055
     C                   Z-Add     0             Idx
     C                   Z-Add     0             WIx                                          CER055
      *
      * BUG4565 now defaults a formatted zero amount to a blank overdraft line, we need      BUG4665
      * to treat that zero as if it was blanks for validation.                               BUG4665
     C                   MOVEL     DDODLN        DDODLNCHK        12                         BUG4665
     C     DDODLNCHK     IFEQ      '0           '                                            BUG4665
     C     DDODLNCHK     OREQ      '0.0         '                                            BUG4665
     C     DDODLNCHK     OREQ      '0.00        '                                            BUG4665
     C     DDODLNCHK     OREQ      '0.000       '                                            BUG4665
     C                   MOVEL     *BLANKS       DDODLNCHK                                   BUG4665
     C                   ENDIF                                                               BUG4665
      *                                                                                      BUG4665
     C                   EXSR      SRVODLN
     C                   EXSR      SRVODSCED
      *
      ** If CRE001 is installed, validate Overdraft fields
     C     CRE001        IFEQ      'Y'
     C                   EXSR      SRVOTHR
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDODLNOk      IfEq      'N'
     C     DDODSCOk      OrEq      'N'
     C     DDITRDOk      OrEq      'N'
     C     DDOLVDOk      OrEq      'N'
     C     DDODEDOk      OrEq      'N'
     C     DDAODROk      OrEq      'N'
     C     DDAODRXOk     OrEq      'N'
     C     DDORTCOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRVODLN - Validate Overdraft line                            *
      *****************************************************************
     C     SRVODLN       BEGSR
 
     C/COPY WNCPYSRC,GLH00582
     C*****DDODLN        IFNE      *BLANK                                                    BUG4665
     C     DDODLNCHK     IFNE      *BLANKS                                                   BUG4665
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOk          1
     C                   Parm      DDODLN        ZField           16
     C                   Parm      0             ZADec             1 0
     C                   Parm      11            ZADig             2 0
      *                                                                                      BUG3938
      ** Reject if 'M' or 'T' in any position of the field.                                  BUG3938
     C                   MOVEA     '00'          *IN(30)                                     BUG3938
     C                   MOVEA     DDODLN        ARODLN                                      BUG3938
     C     'M'           LOOKUP    ARODLN                                 30                 BUG3938
     C     'T'           LOOKUP    ARODLN                                 31                 BUG3938
     C     *IN30         IFEQ      '1'                                                       BUG3938
     C     *IN31         OREQ      '1'                                                       BUG3938
     C                   EVAL      ZAlignOk = 'N'                                            BUG3938
     C                   ENDIF                                                               BUG3938
      *
      ** OVERDRAFT LINE IS NOT IN VALID NUMERIC FIELD
     C     ZAlignOk      IfNe      'Y'
     C                   Move      'N'           DDODLNOk
     C                   Add       1             Idx
     C                   Movel     'DDODLN'      FldNamXAr(Idx)
     C                   Movel     'RE71226'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   Move      ZFIELD        WNODLN
     C                   ELSE
     C                   Z-Add     *Zeros        WNODLN
     C                   ENDIF
      *
     C     AMODLN        IFNE      WNODLN
     C                   Z-ADD     BJRDNB        AMDLIM
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00583
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRVODSCED - Validate Overdraft Secured and Expiry Date       *
      *****************************************************************
     C     SRVODSCED     BEGSR
 
     C/COPY WNCPYSRC,GLH00584
     C*****DDODLN        IFNE      *BLANKS                                      B01          BUG4665
     C     DDODLNCHK     IFNE      *BLANKS                                                   BUG4665
      *                                                                                      BUG5543
      ** When DDODSC is 'N from accntab, a blank value is being passed to                    BUG5543
      ** APTRANVU, a correct value of Y is passed when it is Y from file                     BUG5543
      ** could be due to the tick/untick values for the ODSC on midasplus screen             BUG5543
      ** Default it to 'N' when blank since Y/N were the only values that                    BUG5543
      ** should be passed to the file.                                                       BUG5543
      *                                                                                      BUG5543
     C     DDODSC        Ifeq      *BLANKS                                                   BUG5543
     C                   Move      'N'           DDODSC                                      BUG5543
     C                   Endif                                                               BUG5543
      *
      **  OVERDRAFT SECURED MANDATORY
      ** Mandatory that it is secured or not and not null, this is covered by the tickbox.   BUG5746
     C*****DDODSC*       IFEQ      *BLANKS                                      B02          BUG5746
     C*****DDODSC*       OREQ      'N'                                               BUG4161 BUG5746
     C**********         Move      'N'           DDODSCOk                                    BUG5746
     C**********         Add       1             Idx                                         BUG5746
     C**********         Movel     'DDODSC'      FldNamXAr(Idx)                              BUG5746
     C**********         Movel     'RE71227'     MsgIDXAr(Idx)                               BUG5746
     C**********         ENDIF                                                  E02          BUG5746
      *
      **  OVERDRAFT EXPIRY DATE MANDATORY
     C     DDODED        IFEQ      *BLANKS                                      B02
     C                   Move      'N'           DDODEDOk
     C                   Add       1             Idx
     C                   Movel     'DDODED'      FldNamXAr(Idx)
     C                   Movel     'RE71228'     MsgIDXAr(Idx)
      *
     C                   ELSE                                                   X02
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDODED        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
      *
     C     ErrorFlag     IfEq      'Y'                                          B03
     C                   Move      'N'           DDODEDOk
     C                   Add       1             Idx
     C                   Movel     'DDODED'      FldNamXAr(Idx)
     C                   Movel     'RE71229'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E03
      *
      **  OVERDRAFT EXPIRY DATE MUST BE AFTER THE RUN DATE
     C     DaynoOut      IFLT      BJRDNB                                       B03
     C     ErrorFlag     ANDEQ     'N'
     C                   Move      'N'           DDODEDOk
     C                   Add       1             Idx
     C                   Movel     'DDODED'      FldNamXAr(Idx)
     C                   Movel     'RE71229'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E03
      *
     C                   ENDIF                                                  E02
     C                   Z-ADD     DaynoOut      SSODED            5 0
      *
     C                   ELSE                                                   X01
      *
      ** Overdraft Expiry Date must be blank if Overdraft Line
      ** is ZERO and CRE001 is OFF
      *
     C     CRE001        IFNE      'Y'                                          B02
      *
      **  ENTRY OF OVERDRAFT EXPIRY DATE IS NOT ALLOWED
     C     DDODED        IFNE      *BLANKS                                      B03
     C                   Move      'N'           DDODEDOk
     C                   Add       1             Idx
     C                   Movel     'DDODED'      FldNamXAr(Idx)
     C                   Movel     'RE71230'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E03
      *
     C                   Z-Add     0             SSODED
      *
     C                   ELSE                                                   X02
      *
      ** Allow entry in Overdraft Expiry Date if CRE001 is ON
      *
     C     DDODED        IFNE      *BLANKS                                      B03
     C                   CallB     'ZDATE1'
     C                   Parm      DDODED        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
      *
     C     ErrorFlag     IfEq      'Y'                                          B04
     C                   Move      'N'           DDODEDOk
     C                   Add       1             Idx
     C                   Movel     'DDODED'      FldNamXAr(Idx)
     C                   Movel     'RE71229'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E04
      *
      **  Overdraf Expiry Date must be after the Run Date
     C     DaynoOut      IFLT      BJRDNB                                       B04
     C     ErrorFlag     ANDEQ     'N'
     C                   Move      'N'           DDODEDOk
     C                   Add       1             Idx
     C                   Movel     'DDODED'      FldNamXAr(Idx)
     C                   Movel     'RE71229'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E04
     C                   Z-ADD     DaynoOut      SSODED
      *
     C                   ELSE                                                   X03
     C                   Z-ADD     0             SSODED
      *
     C                   ENDIF                                                  E03
      *
     C                   ENDIF                                                  E02
     C                   ENDIF                                                  E01
      *
     C*****DDODLN        IFNE      *BLANKS                                      B01          BUG4665
     C     DDODLNCHK     IFNE      *BLANKS                                                   BUG4665
     C     DDODSC        IFEQ      *BLANKS                                      B02
     C                   MOVE      'N'           DDODSC
     C                   ELSE                                                   X02
      *
      **  ENTRY OF OVERDRAFT SECURED MUST BE 'Y' OR 'N'
     C     DDODSC        IFNE      'Y'                                          B03
     C     DDODSC        ANDNE     'N'
     C                   Move      'N'           DDODSCOk
     C                   Add       1             Idx
     C                   Movel     'DDODSC'      FldNamXAr(Idx)
     C                   Movel     'RE71231'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E03
      *
     C                   ENDIF                                                  E02
      *
      * Overdraft line is blank.                                                             BUG4161
     C                   ELSE                                                   X01
      *
     C*****DDODSC        IFNE      *BLANKS                                      B02          BUG4124
     C     DDODSC        IFEQ      'Y'                                          B02          BUG4124
     C     CRE001        ANDNE     'Y'
     C                   Move      'N'           DDODSCOk
     C                   Add       1             Idx
     C                   Movel     'DDODSC'      FldNamXAr(Idx)
     C**********         Movel     'RE71231'     MsgIDXAr(Idx)                               BUG4124
     C                   Movel     'RE71240'     MsgIDXAr(Idx)                               BUG4124
     C                   ENDIF                                                  E02
      *
     C     DDODSC        IFNE      *BLANKS                                      B02
     C     DDODSC        ANDNE     'N'                                                       BUG4161
     C     BXOLVD        ANDEQ     *ZEROS
     C     CRE001        ANDEQ     'Y'
     C*****DDODSC        OREQ      'Y'                                               BUG4161 BUG4859
     C*****DDITRD        ORNE      *BLANKS                                           BUG4161 BUG4859
     C*****DDOLVD        ORNE      *BLANKS                                           BUG4161 BUG4859
     C*****DDODED        ORNE      *BLANKS                                           BUG4161 BUG4859
     C                   Move      'N'           DDODSCOk
     C                   Add       1             Idx
     C                   Movel     'DDODSC'      FldNamXAr(Idx)
     C                   Movel     'RE72012'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E02
     C                   ENDIF                                                  E01
     C/COPY WNCPYSRC,GLH00585
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRVOTHR - Validate Other Debit Overdraft fields              *
      *****************************************************************
     C     SRVOTHR       BEGSR
      *
      ** IF Dr.Int.Calc.Type OR Dr.Int.Calc.Sub-Type NOT = *blanks
     C     DDDICT        IFNE      *BLANKS
     C     DDDCST        ORNE      *BLANKS
      *
      ** IF Additional Overdraft Rate NOT = *blanks
     C     DDAODR        IFNE      *BLANKS
     C                   Move      'N'           DDAODROk
     C                   Add       1             Idx
     C                   Movel     'DDAODR'      FldNamXAr(Idx)
     C                   Movel     'RE71874'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Additional Overdraft Rate Sign NOT = *blanks
     C     DDAODRX       IFNE      *BLANKS
     C                   Move      'N'           DDAODRXOk
     C                   Add       1             Idx
     C                   Movel     'DDAODRX'     FldNamXAr(Idx)
     C                   Movel     'RE71874'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Additional Overdraft Rate Change Value Date NOT = *blanks
     C     DDORTC        IFNE      *BLANKS
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE71874'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** IF Dr.Int.Calc.Type AND Dr.Int.Calc.Sub-Type = *blanks
     C     DDDICT        IFEQ      *BLANKS
     C     DDDCST        ANDEQ     *BLANKS
      *
      ** IF Additional Overdraft Rate NOT = *blanks
     C     DDAODR        IFNE      *BLANKS
      *
      ** Validate and format to numeric
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOk          1
     C                   Parm      DDAODR        ZField           16
     C                   Parm      7             ZADec             1 0
     C                   Parm      4             ZADig             2 0
      *
      ** IF Invalid
     C     ZAlignOk      IfNe      'Y'
     C                   Move      'N'           DDAODROk
     C                   Add       1             Idx
     C                   Movel     'DDAODR'      FldNamXAr(Idx)
     C                   Movel     'RE72001'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZField        WNAODR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** IF Additional Overdraft Rate Sign NOT = *blanks
     C     DDAODRX       IFNE      *BLANKS
      *
      ** IF Additional Overdraft Rate = *blanks
      * A rate spread is always now defaulted in and cant be removed.                        BUG4859
     C*****DDAODR        IFEQ      *BLANKS                                                   BUG4859
     C**********         Move      'N'           DDAODROk                                    BUG4859
     C**********         Move      'N'           DDAODRXOk                                   BUG4859
     C**********         Add       1             Idx                                         BUG4859
     C**********         Movel     'DDAODR'      FldNamXAr(Idx)                              BUG4859
     C**********         Movel     'RE72002'     MsgIDXAr(Idx)                               BUG4859
     C**********         ENDIF                                                               BUG4859
      *
      ** IF Additional Overdraft Rate Sign NOT = '+' or '-'
     C     DDAODRX       IFNE      '+'
     C     DDAODRX       ANDNE     '-'
     C                   Move      'N'           DDAODRXOk
     C                   Add       1             Idx
     C                   Movel     'DDAODRX'     FldNamXAr(Idx)
     C                   Movel     'RE72003'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
     C     DDAODR        IFNE      *BLANKS
     C                   MOVE      '+'           DDAODRX
     C                   ENDIF
     C                   ENDIF
      *
      ** IF Additional Overdraft Rate NOT = *blanks
      ** AND Additional Overdraft Rate Sign = '-'
     C     DDAODR        IFNE      *BLANKS
     C     DDAODRX       ANDEQ     '-'
     C                   MULT      -1            WNAODR
     C                   ENDIF
      *
      ** IF Additional Overdraft Rate Change Value Date = *blanks
      **    AND Additional Overdraft Rate NOT = *blanks
      ** OR Additional Overdraft Rate Change Value Date NOT = *blanks
      **    AND Additional Overdraft Rate = *blanks
     C     DDORTC        IFEQ      *BLANKS
     C     DDAODR        ANDNE     *BLANKS
     C     DDORTC        ORNE      *BLANKS
     C     DDAODR        ANDEQ     *BLANKS
     C                   Move      'N'           DDAODROk
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDAODR'      FldNamXAr(Idx)
     C                   Movel     'RE72004'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Only validate Additional Overdraft Rate Change Value Date if                       MD029023
      ** Addiitonal Overdraft Rate changed                                                  MD029023
     C     WNAODR        IFNE      BXAODR                                                   MD029023
      ** IF Additional Overdraft Rate Change Value Date NOT = *blanks
     C     DDORTC        IFNE      *BLANKS
      *
      ** Validate and convert to Midas Day No.
     C                   CallB     'ZDATE1'
     C                   Parm      DDORTC        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-ADD     DaynoOut      WWORTC            5 0
      *
      ** IF Invalid Date
     C     ErrorFlag     IFEQ      'Y'
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE71310'     MsgIDXAr(Idx)
      *
      ** IF Valid Date
     C                   ELSE
      *
      ** IF Additional Overdraft Rate Change Value Date > Run Date
     C     WWORTC        IFGT      BJRDNB
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE71311'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Additional Overdraft Rate Change Value Date <
      **    previous Dr.Rate Change Value Date
     C     WWORTC        IFLT      AMOLDR
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE71312'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Additional Overdraft Rate Change Value Date <
      **    Date Account Opened
     C                   CallB     'ZDATE1'
     C                   Parm      DDDACO        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-ADD     DaynoOut      WWDACO            5 0
     C     WWORTC        IFLT      WWDACO
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE71314'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C     WWORTC        IFLT      WWBKVD
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE71315'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                              MD029023
      *
      ** IF Account being Inserted
     C     DDACTN        IFEQ      'I'
      *
      ** IF Dr.Base Rate OR Dr.Rate/Spread have been entered
     C     DDDRIB        IFNE      *BLANKS
     C     DDDRIS        ORNE      *BLANKS
      *
      ** IF Additional Overdraft Rate Change Value Date NOT =
      **    Dr.Rate Change Date
     C     WWORTC        IFNE      WWDRCD
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE72005'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** IF Account being Amended
     C     DDACTN        IFEQ      'A'
      *
      ** IF Additional Overdraft Rate Change Value Date <
      **    previous Additional Overdraft Rate Change Value Date
     C     WWORTC        IFLT      BXORTC
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE71313'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Dr.Base Rate OR Dr.Rate/Spread have been amended
     C                   Move      DDDRIB        WWDRIB            2 0
      *
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOk
     C                   Parm      DDDRIS        ZField
     C                   Parm      7             ZADec
     C                   Parm      4             ZADig
     C                   Move      ZFIELD        WWDRIS           11 7
     C     DDDSIG        IFEQ      '-'                                                      MD029023
     C                   Z-SUB     WWDRIS        WWDRIS                                     MD029023
     C                   ENDIF                                                              MD029023
      *
     C     WWDRIB        IFNE      AMDRIB
     C     WWDRIS        ORNE      AMDRIS
      *
      ** IF Additional Overdraft Rate Change Value Date NOT =
      **    Dr.Rate Change Value Date
     C     WWORTC        IFNE      WWDRCD
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE72005'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** IF Dr.Base Rate, Dr.Rate/Spread AND Additional O'draft Rate
      **    all unchanged
     C     WWDRIB        IFEQ      AMDRIB
     C     WWDRIS        ANDEQ     AMDRIS
     C     WNAODR        ANDEQ     BXAODR
      *
      ** IF Additional O'draft Rate Change Value Date changed
     C     WWORTC        IFNE      BXORTC
     C                   Move      'N'           DDORTCOk
     C                   Add       1             Idx
     C                   Movel     'DDORTC'      FldNamXAr(Idx)
     C                   Movel     'RE72006'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      **********                                                                             BUG4161
      ***IF*Overdraft*Line*Change*Value*Date*=**blanks                                       BUG4161
      ***AND*screen*Overdraft*Line*NOT*=*file*value*for*Overdraft*Line                       BUG4161
     C*****DDOLVD        IFEQ      *BLANKS                                                   BUG4161
     C*****WNODLN        ANDNE     AMODLN                                                    BUG4161
     C**********         Move      'N'           DDOLVDOk                                    BUG4161
     C**********         Add       1             Idx                                         BUG4161
     C**********         Movel     'DDOLVD'      FldNamXAr(Idx)                              BUG4161
     C**********         Movel     'RE72007'     MsgIDXAr(Idx)                               BUG4161
     C**********         ENDIF                                                               BUG4161
      *
      ** IF Overdraft Line Change Value Date NOT = *zero
     C     DDOLVD        IFNE      *BLANKS
     C                   CallB     'ZDATE1'
     C                   Parm      DDOLVD        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-ADD     DaynoOut      WWOLVD            5 0
      *
      ** IF Invalid Date
     C     ErrorFlag     IFEQ      'Y'
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE71310'     MsgIDXAr(Idx)
      *
      ** IF Valid Date
     C                   ELSE
      *
      ** IF Overdraft Line Change Value Date > OR = Expiry Date
     C                   CallB     'ZDATE1'
     C                   Parm      DDODED        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-ADD     DaynoOut      WWODED            5 0
     C     WWOLVD        IFGE      WWODED
     C     WWODED        ANDNE     *ZERO
     C     WNODLN        ANDNE     AMODLN
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE72008'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C     WWOLVD        IFGE      WWFWVD
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE72009'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Overdraft Line Change Value Date < Date Account Opened
     C                   CallB     'ZDATE1'
     C                   Parm      DDDACO        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-ADD     DaynoOut      WWDACO
     C     WWOLVD        IFLT      WWDACO
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE71314'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C     WWOLVD        IFLT      WWBKVD
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE71315'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Account being Amended
     C     DDACTN        IFEQ      'A'
      *
      ** IF Overdraft Line Change Value Date <
      **    Previous Change Value Date (if NOT *zero)
     C     BXPOLC        IFNE      *ZERO
     C     WWOLVD        IFLT      BXPOLC
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE71313'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** IF Overdraft Line Change Value Date <
      **    file value for Overdraft Line Change Value Date
      **     (provided Previous Change Value Date = *zero)
     C     BXPOLC        IFEQ      *ZERO
     C     WWOLVD        IFLT      BXOLVD
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE71313'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** IF O'd Line Change Value date blank and Expiry Date not blank
      ** OR O'd Line Change Value date not blank and Expiry Date blank
     C     DDOLVD        IFEQ      *BLANKS
     C     DDODED        ANDNE     *BLANKS
     C     BXOLVD        ANDEQ     *ZEROS
     C     BXPOLC        ANDEQ     *ZEROS
     C*****DDODLN        ANDNE     *BLANKS                                           BUG4161 BUG4665
     C     DDODLNCHK     ANDNE     *BLANKS                                                   BUG4665
     C     WNODLN        ANDNE     AMODLN
     C     DDOLVD        ORNE      *BLANKS
     C     DDODED        ANDEQ     *BLANKS
     C*****DDODLN        ANDNE     *BLANKS                                           BUG4161 BUG4665
     C     DDODLNCHK     ANDNE     *BLANKS                                                   BUG4665
     C     WNODLN        ANDNE     AMODLN
      ** IF Overdraft Line Change Value Date = *blanks                                       BUG4161
      ** AND screen Overdraft Line NOT = file value for Overdraft Line                       BUG4161
     C     DDOLVD        OREQ      *BLANKS                                                   BUG4161
     C     WNODLN        ANDNE     AMODLN                                                    BUG4161
      *                                                                                     MD019907
      ** If Overdraft Expiry has changed, Overdraft Line                                    MD019907
      ** Change Value Date should be changed                                                MD019907
      *                                                                                     MD019907
     C     DDACTN        OREQ      'A'                                                      MD019907
     C     DDOLVD        ANDEQ     *BLANKS                                                  MD019907
     C     SSODED        ANDNE     AMODED                                                   MD019907
      *                                                                                     MD019907
     C                   Move      'N'           DDOLVDOk
     C                   Move      'N'           DDODEDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE72007'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Overdraft Line AND Overdraft Expiry Date unchanged
     C     AMODLN        IFEQ      WNODLN
     C     AMODED        ANDEQ     SSODED
     C     DDACTN        ANDEQ     'A'
      *
      ** IF This Change Value Date amended
     C     DDOLVD        IFEQ      *BLANKS
     C     BXOLVD        ANDNE     *ZERO
     C     DDOLVD        ORNE      *BLANKS
     C     BXOLVD        ANDNE     WWOLVD
     C                   Move      'N'           DDOLVDOk
     C                   Add       1             Idx
     C                   Movel     'DDOLVD'      FldNamXAr(Idx)
     C                   Movel     'RE72010'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER055
      ** IF Overdraft Line Change Value Date is not amended                                   CER055
      ** but Overdraft Line is amended (CER055 is ON)                                         CER055
     C     CER055        IFEQ      'Y'                                                        CER055
     C     WWOLVD        IFEQ      BXOLVD                                                     CER055
     C     WNODLN        ANDNE     AMODLN                                                     CER055
     C                   MOVE      'W'           DDOLVDOk                                     CER055
     C                   ADD       1             WIx                                          CER055
     C                   MOVEL     'DDOLVD'      WFldNmXAr(WIx)                               CER055
     C                   MOVEL     'RE71079'     WMsgIDXAr(WIx)                               CER055
     C                   ENDIF                                                                CER055
     C                   ENDIF                                                                CER055
      *
      ** IF DR Int.Calc.Type OR DR Int.Calc.Sub-Type NOT = *blanks
     C     DDDICT        IFNE      *BLANKS
     C     DDDCST        ORNE      *BLANKS
      *
      ** IF Interest Rate Review Date NOT = *blanks
     C     DDITRD        IFNE      *BLANKS
     C                   Move      'N'           DDITRDOk
     C                   Add       1             Idx
     C                   Movel     'DDITRD'      FldNamXAr(Idx)
     C                   Movel     'RE71874'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** IF DR Int.Calc.Type AND DR Int.Calc.Sub-Type = *blanks
     C     DDDICT        IFEQ      *BLANKS
     C     DDDCST        ANDEQ     *BLANKS
      *
      ** IF Interest Rate Review Date NOT = 0
      **    AND Additional Overdraft Rate = *blanks
      **    AND Overdraft Line = *blanks
     C     DDITRD        IFNE      *BLANKS
     C     DDAODR        ANDEQ     *BLANKS
     C*****DDODLN        ANDEQ     *BLANKS                                                   BUG4665
     C     DDODLNCHK     ANDEQ     *BLANKS                                                   BUG4665
     C                   Move      'N'           DDITRDOk
     C                   Add       1             Idx
     C                   Movel     'DDITRD'      FldNamXAr(Idx)
     C                   Movel     'RE72011'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF Interest Rate Review Date = 0
     C     DDITRD        IFEQ      *BLANKS
      **    IF Additional Overdraft Rate NOT = *blanks
      **       OR Overdraft Line NOT = *blanks
     C     DDAODR        IFNE      *BLANKS
     C*****DDODLN        ORNE      *BLANKS                                                   BUG4665
     C     DDODLNCHK     ORNE      *BLANKS                                                   BUG4665
     C     WNODLN        IFNE      AMODLN
     C                   Move      'N'           DDITRDOk
     C                   Add       1             Idx
     C                   Movel     'DDITRD'      FldNamXAr(Idx)
     C                   Movel     'RE71876'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** IF Interest Rate Review Date NOT = 0
     C     DDITRD        IFNE      *BLANKS
      *
      ** IF Interest Rate Review Date = '999999'
     C     DDITRD        IFEQ      '999999'
     C                   Z-ADD     999999        WWITRD            5 0
      *
     C                   ELSE
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDITRD        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-ADD     DaynoOut      WWITRD
      *
      ** IF Invalid Date
     C     ErrorFlag     IFEQ      'Y'
     C                   Move      'N'           DDITRDOk
     C                   Add       1             Idx
     C                   Movel     'DDITRD'      FldNamXAr(Idx)
     C                   Movel     'RE71220'     MsgIDXAr(Idx)
      *
      ** IF Valid Date
     C                   ELSE
      *
      ** IF Interest Rate Review Date < OR = Run Date
     C     WWITRD        IFLE      BJRDNB
     C                   Move      'N'           DDITRDOk
     C                   Add       1             Idx
     C                   Movel     'DDITRD'      FldNamXAr(Idx)
     C                   Movel     'RE72013'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Update Dlim if O/D-chg-value-date changed.
     C     IDX           IFEQ      0
     C     BXOLVD        ANDNE     WWOLVD
     C                   Z-ADD     BJRDNB        AMDLIM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDODLN           12
     C                   Parm                    DDODSC            1
     C                   Parm                    DDITRD            6
     C                   Parm                    DDOLVD            6
     C                   Parm                    DDODED            6
     C                   Parm                    DDAODR           12
     C                   Parm                    DDAODRX           1
     C                   Parm                    DDORTC            6
     C                   Parm                    DDDICT            2
     C                   Parm                    DDDCST            5
     C                   Parm                    DDDACO            6
     C                   Parm                    DDACTN            1
     C                   Parm                    DDDRIB            2
     C                   Parm                    DDDRIS           12
     C                   Parm                    DDDSIG            1                        MD029023
     C                   Parm                    WWDRCD            5 0
      *
     C                   Parm                    AMOLDR            5 0
     C                   Parm                    AMDRIB
     C                   Parm                    AMDRIS           11 7
     C                   Parm                    AMODED            5 0
     C                   Parm                    AMODLN           11 0
      *
     C                   Parm                    BXOLVD            5 0
     C                   Parm                    BXORTC            5 0
     C                   Parm                    BXPOLC            5 0
     C                   Parm                    BXAODR           11 7
      *
      ** ICD
     C                   Parm                    CRE001            1
     C                   Parm                    CER055            1                          CER055
     C                   Parm                    BJDFIN            1
     C                   Parm                    BJRDNB            5 0
     C                   Parm                    WWBKVD            5 0
     C                   Parm                    WWFWVD            5 0
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr                                    CER055
     C                   Parm                    WMsgIDXAr                                    CER055
     C                   Parm                    WMsgDtXAr                                    CER055
      *
     C                   PARM                    WNAODR           11 7
     C                   Parm                    WNODLN           11 0
     C                   Parm                    AMDLIM            5 0
      *
      ** Overdraft Line - OK
      ** Overdraft Secured - OK
      ** Rev. Date (Line or Rate) - OK
      ** OD Line Charge Value Date - OK
      ** OD Line Expiry Date - OK
      ** Additional Overdraft Rate - OK
      ** Additional OD Rate Sign - OK
      ** Chg. Val. Date, OD Rate - OK
     C                   Parm                    DDODLNOK          1
     C                   Parm                    DDODSCOK          1
     C                   Parm                    DDITRDOK          1
     C                   Parm                    DDOLVDOK          1
     C                   Parm                    DDODEDOK          1
     C                   Parm                    DDAODROK          1
     C                   Parm                    DDAODRXOK         1
     C                   Parm                    DDORTCOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
     C/COPY WNCPYSRC,GLH00586
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
