     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP settlement value date')           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVISLDT - Validate Settlement Value Date                    *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD036683A          Date 12Apr16               *
      *  Prev Amend No. MD036683           Date 06Jan16               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 241301             Date 25Jul07               *
      *                 248631             Date 23Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 207211             Date 16Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036683A - Validate the settlement value date against the   *
      *              DACO even if the value date is holiday.          *
      *  MD036683 - Validate the settlement value date against the    *
      *             opening date of the account (DACO) not only for   *
      *             retail accounts but for all types of accounts.    *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  241301 - Transition value date should be verified only when  *
      *           it has been reached since EMU rates are used from   *
      *           this period onwards.                                *
      *  248631 - No warning message for outbound FT on a holiday.    *
      *           Patterned fix after 228013 which added a new        *
      *           warning message when the date for settlement        *
      *           currency falls on a holiday.                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  207211 - invalid date not detected                           *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn file 2 details from Incoming              CFT014
      ** transaction - screen format                                            CFT014
     D NwIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
     D WODATE          DS             6
     D  ODD                    1      2
     D  OMM                    3      4
     D  OYY                    5      6
      *
     D                 DS
     D WZDATE                  1      6  0
     D  ZDD                    1      2
     D  ZMM                    3      4
     D  ZYY                    5      6
     D  ZYN                    5      6  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D ZDATIN          S              6A
     D ZDAYNO          S              5P 0
     D BVLD            S              5P 0
     D ZLOC            S              3A
     D ZCCY            S              3A
     D ZERR            S              1A
     D ZHIND           S              1A
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise output parameters.
      *
      ** Initialise variables for update of Valid File fields.
     C                   Z-ADD     *Zeros        WSLDT             5 0
      *
      ** Initialise work variables.
     C                   EVAL      Idx = 0
     C                   EVAL      WIx = 0
      *
      ** Validate Settlement Value Date
      *
     C                   EXSR      SRValSetVD
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKSLDT = 'N'
     C                             OR OKSND1 = 'N'                              CFT014
     C                             OR OKRCO1 = 'N'                              CFT014
     C                             OR OKTRIB = 'N'                              CFT014
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKSLDT <> 'N'
      *
     C                   Z-ADD     WSLDT         IPSLDT
      *
      ** Setup DAF settle value date 1 and defualt date to screen field.
     C                   If        IPSLDT <> 0
     C                   Z-ADD     IPSLDT        ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   EVAL      WZDATE = ZDATE
     C                   EVAL      IPSLDTD1 = ZDATE

     C                   IF        CFT009 = 'N' OR                              CFT009
     C                             CFT009 = 'Y' AND DDSLDT <> *BLANKS           CFT009
     C                   MOVE      ZDATE         DDSLDT
     C                   ENDIF                                                  CFT009

     C                   Else
     C                   EVAL      IPSLDTD1 = *Zeros
     C                   ENDIF
      *
      ** Setup DAF settle value date 2
     C                   If        ZYN < 72
     C                   Z-ADD     20            IPSLDTD2
     C                   Else
     C                   Z-ADD     19            IPSLDTD2
     C                   EndIf
      *
      ** Setup DAF settle value date 3
     C                   IF        BJDFIN <> 'M'
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZMM
     C                   EVAL      OYY = ZDD
     C                   ELSE
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZDD
     C                   EVAL      OYY = ZMM
     C                   ENDIF
      *
     C                   MOVE      WODATE        IPSLDTD3
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSetVD - Settlement Value Date                           *
      *                                                               *
      *****************************************************************
     C     SRValSetVD    BEGSR
      *
      ** If date is not entered, set to system date
      ** Otherwise validate as being a valid date
      *
     C                   IF        DDSLDT = *Blanks
     C                   Z-ADD     BJRDNB        WSLDT
      *
      ** Ensure that date is not before EMU transition start date if
      ** either Notified Delivery or settlement currency is Euro and
      ** the other is "In".
      *
     C**********         IF        CEU006 = 'Y'                                               241301
     C                   If        CEU006 = 'Y' and                                           241301
     C                             PNotTPSD <= BJRDNB                                         241301
      *                                                                                       241301
     C                   If        PNotInCy = 'Y' and
     C                             DDSMCY = BKEURO and
     C                             PNotTPSD > WSLDT or
      *
     C                             PSetInCy = 'Y' and
     C                             DDNDCY = BKEURO and
     C                             PSetTPSD > WSLDT
     C                   MOVE      'N'           OKSLDT
     C                   ADD       1             Idx
     C                   MOVEL     'DDSLDT'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2560'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Check if date is numeric
     C                   MOVEL     DDSLDT        DATEL             7 0
     C                   MOVEL     DATEL         DATES             6
      *
     C                   IF        DDSLDT <> DATES
      *
     C                   MOVE      'N'           OKSLDT
     C                   ADD       1             Idx
     C                   MOVEL     'DDSLDT'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0072'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
     C                   EVAL      ZDATIN = DDSLDT
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      ' '           ZERR
      *
     C                   IF        ZERR   <> 'Y'                                              207211
      *                                                                                       207211
     C                   Z-ADD     ZDAYNO        WSLDT
      *
      ** The settle date must not be a holiday in Local Currency
      *
     C                   EVAL      ZCCY = BJLCCY
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM      ' '           ZHIND
      *
      ** if ZHIND = 'H' then the date is a holiday - send
      *
     C                   IF        ZHIND = 'H'
      *
     C                   MOVE      'W'           OKSLDT
     C                   ADD       1             WIx
     C                   MOVEL     'DDSLDT'      WFldNmXAr(WIx)
     C**********         MOVEL     'FTA0073'     WMsgIdXAr(WIx)                               248631
     C                   MOVEL     'FTA2002'     WMsgIdXAr(WIx)                               248631
      *
     C                   ENDIF
      *                                                                                       248631
      ** Warning error if date is a holiday in settle currency                                248631
      *                                                                                       248631
     C                   MOVE      DDSMCY        ZCCY                                         248631
     C                   CALLB     'ZCHKH'                                                    248631
     C                   PARM                    ZDAYNO                                       248631
     C                   PARM                    ZCCY                                         248631
     C                   PARM                    ZLOC                                         248631
     C                   PARM      ' '           ZHIND                                        248631
      *                                                                                       248631
      ** if ZHIND = 'H' then the date is a holiday - send warning                             248631
      *                                                                                       248631
     C     ZHIND         IFEQ      'H'                                                        248631
     C                   MOVE      'W'           OKSLDT                                       248631
     C                   ADD       1             WIx                                          248631
     C                   MOVEL     'DDSLDT'      WFldNmXAr(WIx)                               248631
     C                   MOVEL     'FTA2003'     WMsgIdXAr(WIx)                               248631
     C                   ENDIF                                                                248631
      *
      ** Ensure that date is not before EMU transition start date if
      ** either Notified Delivery or settlement currency is Euro and
      ** the other is "In".
      *
     C                   IF        CEU006 = 'Y'
     C                   If        PNotInCy = 'Y' and
     C                             DDSMCY = BKEURO and
     C                             PNotTPSD > WSLDT or
      *
     C                             PSetInCy = 'Y' and
     C                             DDNDCY = BKEURO and
     C                             PSetTPSD  > WSLDT
     C                   MOVE      'N'           OKSLDT
     C                   ADD       1             Idx
     C                   MOVEL     'DDSLDT'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2560'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *                                                                                       207211
      ** ZDATE1 ended in error                                                                207211
     C                   ELSE                                                                 207211
     C                   MOVE      'N'           OKSLDT                                       207211
     C                   ADD       1             IDx                                          207211
     C                   MOVEL     'DDSLDT'      FldNamXAr(IDx)                               207211
     C                   MOVEL     'FTA0072'     MsgIdXAr(IDx)                                207211
      *                                                                                       207211
     C                   ENDIF                                                                207211
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if settle date is in the future and if the account
      ** is closing today (if settle value date is valid)
      *
     C**********         IF        OKSLDT = 'Y' and                                        MD036683A
     C                   IF        OKSLDT <> 'N' and                                       MD036683A
     C                             OKSND1 = 'Y' and
     C*****                        OKRCCO = 'Y'                                 CFT014
     C                             OKRCO1 = 'Y'                                 CFT014
      *
     C                   If        WSLDT > BJRDNB and
     C                             PAcSt1 = 'C'
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0074'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        WSLDT > BJRDNB and
     C                             PAcSt2 = 'C'
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0074'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   ENDIF
      *                                                                         CFT014
     C**********         IF        OKSLDT = 'Y'                                     CFT014 MD036683A
     C                   IF        OKSLDT <> 'N'                                           MD036683A
     C                             AND OKTRIB = 'Y'                             CFT014
     C                             AND CFT014 = 'Y'                             CFT014
      *                                                                         CFT014
     C                   If        WSLDT > BJRDNB and                           CFT014
     C                             PAcSt3 = 'C'                                 CFT014
     C                   MOVE      'N'           OKTRIB                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDTRIB'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0074'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
      *                                                                         CFT014
     C                   EndIf                                                  CFT014
      *
      ** If settle value date, Sender and receiver's correspondent are
      ** valid so far, for Retail accounts only check that the settle
      ** value date is not before the backvalue limit date nor before
      ** the date the account was opened for the account that must be
      ** in settle currency.
      ** Third Reimbursement Institution precedes Sender and                    CFT014
      ** Receiver's Correspondent if CFT014 is installed.                       CFT014
      *
     C**********         IF        OKSLDT = 'Y' and                                        MD036683A
     C                   IF        OKSLDT <> 'N' and                                       MD036683A
     C                             OKSND1 = 'Y' and
     C*****                        OKRCCO = 'Y'                                 CFT014
     C                             OKRCO1 = 'Y'                                 CFT014
     C                             AND CFT014 ='N'                              CFT014
     C**********                   OR (OKSLDT = 'Y'                                 CFT014 MD036683A
     C                             OR (OKSLDT <> 'N'                                       MD036683A
     C                             AND OKSND1 = 'Y'                             CFT014
     C                             AND OKRCO1 = 'Y'                             CFT014
     C                             AND OKTRIB = 'Y'                             CFT014
     C                             AND CFT014 ='Y')                             CFT014
      *
     C                   EVAL      BVLD = BJRDNB - BJBVPD
      *
     C                   IF        DDTRIB <> *BLANKS                            CFT014
     C                             AND (CFT014 = 'Y')                           CFT014
      *                                                                         CFT014
      ** Third Reimbursement Institution                                        CFT014
     C**********         IF        PAtyp3 = 'R'                                      CFT014 MD036683
      *                                                                         CFT014
     C                   IF        WSLDT < BVLD                                 CFT014
     C                   MOVE      'N'           OKTRIB                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDTRIB'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0075'     MsgIdXAr(Idx)                  CFT014
     C                   ELSE                                                   CFT014
     C                   If        WSLDT < PDAcO3                               CFT014
     C                   MOVE      'N'           OKTRIB                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDTRIB'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0076'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C**********         ENDIF                                                       CFT014 MD036683
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C*****              IF        DDRCCO = *Blanks                             CFT014
     C                   IF        DDRCO1 = *BLANKS                             CFT014
      *
      ** Use Sender fields
     C**********         IF        PAtyp1 = 'R'                                             MD036683
      *
     C                   IF        WSLDT < BVLD
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0075'     MsgIdXAr(Idx)
     C                   ELSE
     C                   If        WSLDT < PDAcO1
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0076'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C**********         ENDIF                                                              MD036683
      *
     C                   ELSE
      *
      ** Use Receiver's correspondent fields
     C**********         IF        PAtyp2 = 'R'                                            MD036683A
      *
     C                   IF        WSLDT < BVLD
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0075'     MsgIdXAr(Idx)
     C                   ELSE
     C                   If        WSLDT < PDAcO2
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0076'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C**********         ENDIF                                                             MD036683A
      *
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn file 2 details from Incoming              CFT014
      ** transaction - screen format                                            CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** Sender's Account Type
     C                   PARM                    PAtyp1            1
      *
      ** Sender's Account Status
     C                   PARM                    PAcSt1            1
      *
      ** Sender's Date Account Opened
     C                   PARM                    PDAcO1            5 0
      *
      ** RCorr's Account Type
     C                   PARM                    PATyp2            1
      *
      ** RCorr's Account Status
     C                   PARM                    PAcSt2            1
      *
      ** RCorr's Date Account Opened
     C                   PARM                    PDAcO2            5 0
      *                                                                         CFT014
      ** Third Reimbursement Inst. Account Type                                 CFT014
     C                   PARM                    PAtyp3            1            CFT014
      *                                                                         CFT014
      ** Third Reimbursement Inst. Account Status                               CFT014
     C                   PARM                    PAcSt3            1            CFT014
      *                                                                         CFT014
      ** Third Reimbursement Inst. Date Account Opened                          CFT014
     C                   PARM                    PDAcO3            5 0          CFT014
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy          1
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD          5 0
      *
      ** Notified Delivery In Currency Indicator
     C                   PARM                    PNotInCy          1
      *
      ** Notified EMU Transition Period Start Date
     C                   PARM                    PNotTPSD          5 0
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDBANK - Midas Local Currency
     C                   PARM                    BJLCCY            3
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN            1
      *
      ** SDGELR - Currency code for Euro
     C                   PARM                    BKEURO            3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
