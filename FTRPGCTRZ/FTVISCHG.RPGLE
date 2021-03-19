     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP senders charges')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVISCHG - Validate IP Sender's Charges and Currencies       *
      *                                                               *
      *  Function:  This module validates Sender's Charges and the    *
      *             Sender's Charges Currencies. This is a component  *
      *             of FTIPAYCTL, FTIPAYRPR, FTIPAYSIN, and service   *
      *             program for Level 2 validation modules.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 MD000091           Date 06May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 200949             Date 05Oct06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 208219             Date 27Apr06               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209868             Date 08Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  200949 - Suppress FTM5031.  Applied core fix 197943.         *
      *           Same fix as 208219.                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  208219 - Suppress FTM5031.                                   *
      *  209868 - Do not default Senders Currency if Instructed       *
      *           Amount Currency in first screen was blanks.         *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of dbase error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      /COPY FTCPYSRC,SFTVALCSLE
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
 
      ** Incoming Payments Lvl 1 details
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
 
      ** Incoming Payments Lvl 2 Scrn 3 details
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)
 
      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)
 
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     D OKIPY4DS      E DS                  EXTNAME(FTEIPY4PD)
 
      ** Second data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Sender's Charges Currency data structure
     D WSNDCCYDS       DS            15
     D  WSNDCCY1               1      3
     D  WSNDCCY2               4      6
     D  WSNDCCY3               7      9
     D  WSNDCCY4              10     12
     D  WSNDCCY5              13     15
 
      ** Sender's Charges data structure
     D WSNDCHGDS       DS            60
     D  WSNDCHG1               1     12
     D  WSNDCHG2              13     24
     D  WSNDCHG3              25     36
     D  WSNDCHG4              37     48
     D  WSNDCHG5              49     60
 
      ** Sender's Charges array
     DWSndChgArr       S             12A   DIM(5)
 
      ** Sender's Charges Currency array
     DWSndCcyArr       S              3A   DIM(5)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error messages
     D Idx             S              3P 0
 
      ** General Index for arrays
     D J               S              3P 0
 
      **
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      **                                                                                    MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EVAL      Idx = 0
     C                   EVAL      ErrorFound = 'N'
     C                   EVAL      WSNDCCY1 = DDSCC1
     C                   EVAL      WSNDCCY2 = DDSCC2
     C                   EVAL      WSNDCCY3 = DDSCC3
     C                   EVAL      WSNDCCY4 = DDSCC4
     C                   EVAL      WSNDCCY5 = DDSCC5
     C                   EVAL      WSNDCHG1 = DDSCH1
     C                   EVAL      WSNDCHG2 = DDSCH2
     C                   EVAL      WSNDCHG3 = DDSCH3
     C                   EVAL      WSNDCHG4 = DDSCH4
     C                   EVAL      WSNDCHG5 = DDSCH5
 
     C                   EXSR      SRSCHG
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSCHG - Validation of Sender's Charges/Currencies.          *
      *****************************************************************
     C     SRSCHG        BEGSR
 
      *
      ** Default to Settle currency and zero charge if Details of
      ** charges is 'BEN'
 
     C                   IF        (WSNDCCYDS = *BLANKS)
     C                             AND (WSNDCHGDS = *BLANKS)
 
     C                   IF        (DDDTCH = 'BEN')
      ** Only default if Instructed Amount Currency on First Screen was entered               209868
     C                             And DDNDCY <> *BLANKS                                      209868
     C                   EVAL      DDSCC1 = DDSMCY
     C                   ENDIF
 
     C                   EVAL      I2INSCC1 = DDSCC1
     C                   EVAL      I2INSCC2 = DDSCC2
     C                   EVAL      I2INSCC3 = DDSCC3
     C                   EVAL      I2INSCC4 = DDSCC4
     C                   EVAL      I2INSCC5 = DDSCC5
 
     C                   EVAL      I2INSCH1 = 0
     C                   EVAL      I2INSCH2 = 0
     C                   EVAL      I2INSCH3 = 0
     C                   EVAL      I2INSCH4 = 0
     C                   EVAL      I2INSCH5 = 0
 
     C                   GOTO      EXSCHG
 
     C                   ENDIF
 
      *
      ** If Details of Charges is 'OUR', no Sender's charges should
      **    be made
 
     C                   IF        DDDTCH = 'OUR'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5034'
     C                   EVAL      FldNamXAr(Idx) = 'DDSCC1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EXSR      SROFFOK
     C                   GOTO      EXSCHG
     C                   ENDIF
 
      *
      ***If*Instructed*amount/currency*from*Level*1*were*not*entered,                         208219
      ******Sender's*charges*should*not*be*entered.                                           208219
      **********                                                                              208219
     C**********         IF        DDNDCY = *BLANKS                                           208219
     C**********         EVAL      Idx = Idx + 1                                              208219
     C**********         EVAL      MsgIdXAr = 'FTM5031'                                       208219
     C**********         EVAL      FldNamXAr(Idx) = 'DDSCC1'                                  208219
     C**********         EVAL      ErrorFound = 'Y'                                           208219
     C**********         EXSR      SROFFOK                                                    208219
     C**********         GOTO      EXSCHG                                                     208219
     C**********         ENDIF                                                                208219
 
      *
      ** Move Sender's charges input to work arrays
 
     C                   EVAL      WSndCcyArr(1) = DDSCC1
     C                   EVAL      WSndCcyArr(2) = DDSCC2
     C                   EVAL      WSndCcyArr(3) = DDSCC3
     C                   EVAL      WSndCcyArr(4) = DDSCC4
     C                   EVAL      WSndCcyArr(5) = DDSCC5
     C                   EVAL      WSndChgArr(1) = DDSCH1
     C                   EVAL      WSndChgArr(2) = DDSCH2
     C                   EVAL      WSndChgArr(3) = DDSCH3
     C                   EVAL      WSndChgArr(4) = DDSCH4
     C                   EVAL      WSndChgArr(5) = DDSCH5
 
     C                   IF        DDDTCH  = 'BEN' OR DDDTCH = 'SHA'
 
      *
      ** Validate Sender's Charges/Currencies
 
     C                   EVAL      J = 0
 
     C                   DOW       J < 5
 
     C                   EVAL      J = J + 1
 
      ** Sender's Charge ccy is not blank, Validate currency/charge entries
 
     C                   IF        WSndCcyArr(J) <> *BLANKS
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WSndCcyArr(J) PChr03            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        @RtCd <> *BLANKS
     C                   EXSR      SRSCCERR
     C                   ELSE
     C                   EXSR      SRCHGVAL
     C                   ENDIF
 
     C                   ELSE
 
      ** Sender's Charge ccy is blank, Sender's Charge entry is invalid
 
     C                   IF        WSndChgArr(J) <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5044'
     C                   EVAL      ErrorFound = 'Y'
     C                   SELECT
     C                   WHEN      (J = 1)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH1'
     C                   EVAL      OKSCH1 = 'N'
     C                   WHEN      (J = 2)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH2'
     C                   EVAL      OKSCH2 = 'N'
     C                   WHEN      (J = 3)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH3'
     C                   EVAL      OKSCH3 = 'N'
     C                   WHEN      (J = 4)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH4'
     C                   EVAL      OKSCH4 = 'N'
     C                   WHEN      (J = 5)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH5'
     C                   EVAL      OKSCH5 = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        ErrorFound = 'Y'
     C                   GOTO      EXSCHG
     C                   ENDIF
 
      *
      ** Fields should not be preceded by blank field
 
     C                   IF        (DDSCC5 <> *BLANKS  AND
     C                             DDSCC4 = *BLANKS)  OR
     C                             (DDSCC4 <> *BLANKS  AND
     C                             DDSCC3 = *BLANKS)  OR
     C                             (DDSCC3 <> *BLANKS  AND
     C                             DDSCC2 = *BLANKS)  OR
     C                             (DDSCC2 <> *BLANKS  AND
     C                             DDSCC1 = *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5035'
     C                   EVAL      FldNamXAr(Idx) = 'DDSCC1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKSCC1 = 'N'
     C                   EVAL      OKSCC2 = 'N'
     C                   EVAL      OKSCC3 = 'N'
     C                   EVAL      OKSCC4 = 'N'
     C                   EVAL      OKSCC5 = 'N'
     C                   IF        ErrorFound = 'Y'
     C                   GOTO      EXSCHG
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     EXSCHG        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSCCERR - Handles invalid Sender's Charge Currency.         *
      *****************************************************************
     C     SRSCCERR      BEGSR
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5042'
     C**********         EVAL      MsgDtaXAr(Idx) = WSndCcyArr(J)                           MD000091
     C                   EVAL      BLen = %Len(%Trim(WSndCcyArr(J)))                        MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WSndCcyArr(J))            MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   SELECT
     C                   WHEN      (J = 1)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCC1'
     C                   EVAL      OKSCC1 = 'N'
     C                   WHEN      (J = 2)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCC2'
     C                   EVAL      OKSCC2 = 'N'
     C                   WHEN      (J = 3)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCC3'
     C                   EVAL      OKSCC3 = 'N'
     C                   WHEN      (J = 4)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCC4'
     C                   EVAL      OKSCC4 = 'N'
     C                   WHEN      (J = 5)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCC5'
     C                   EVAL      OKSCC5 = 'N'
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCHGVAL - Validates Sender's Charges and processes Sender's *
      *             Charges info for output to file and screen.       *
      *****************************************************************
     C     SRCHGVAL      BEGSR
 
      *
      ** Charge must be a valid amount in Sender's Charge currency.
 
     C                   EVAL      PInChr16 = *BLANKS
     C                   EVAL      PInNum010 = A6NBDP
     C                   EVAL      PInNum020 = 12 - A6NBDP
 
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      WSndChgArr(J) PInChr16         16
     C                   PARM                    PInNum010         1 0
     C                   PARM                    PInNum020         2 0
     C                   PARM      *BLANKS       POutChr16        16
 
     C                   IF        @RtCd <> *BLANKS
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5036'
     C**********         EVAL      MsgDtaXAr(Idx)=WSndChgArr(J)+WSndCcyArr(J)               MD000091
     C                   EVAL      BLen = %Len(%Trim(WSndChgArr(J)))                        MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WSndChgArr(J))            MD000091
     C                   EVAL      BLen = %Len(%Trim(WSndCcyArr(J)))                        MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(WSndCcyArr(J))            MD000091
     C                   EVAL      ErrorFound = 'Y'
 
     C                   SELECT
     C                   WHEN      (J = 1)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH1'
     C                   EVAL      OKSCH1 = 'N'
     C                   WHEN      (J = 2)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH2'
     C                   EVAL      OKSCH2 = 'N'
     C                   WHEN      (J = 3)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH3'
     C                   EVAL      OKSCH3 = 'N'
     C                   WHEN      (J = 4)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH4'
     C                   EVAL      OKSCH4 = 'N'
     C                   WHEN      (J = 5)
     C                   EVAL      FldNamXAr(Idx) = 'DDSCH5'
     C                   EVAL      OKSCH5 = 'N'
     C                   ENDSL
 
     C                   ELSE
 
      ** Valid amount, save formatted charge
 
     C                   MOVE      *BLANKS       PInOutChr16
     C                   MOVE      POutChr16     PInOutChr16
     C                   CALL      'ZEDIT'
     C                   PARM                    PInOutChr16      16
     C                   PARM      A6NBDP        PInNum010
 
     C                   SELECT
     C                   WHEN      (J = 1)
     C                   MOVE      DDSCC1        I2INSCC1
     C                   MOVE      POutChr16     I2INSCH1
     C                   MOVE      PInOutChr16   DDSCH1
     C                   WHEN      (J = 2)
     C                   MOVE      DDSCC2        I2INSCC2
     C                   MOVE      POutChr16     I2INSCH2
     C                   MOVE      PInOutChr16   DDSCH2
     C                   WHEN      (J = 3)
     C                   MOVE      DDSCC3        I2INSCC3
     C                   MOVE      POutChr16     I2INSCH3
     C                   MOVE      PInOutChr16   DDSCH3
     C                   WHEN      (J = 4)
     C                   MOVE      DDSCC4        I2INSCC4
     C                   MOVE      POutChr16     I2INSCH4
     C                   MOVE      PInOutChr16   DDSCH4
     C                   WHEN      (J = 5)
     C                   MOVE      DDSCC5        I2INSCC5
     C                   MOVE      POutChr16     I2INSCH5
     C                   MOVE      PInOutChr16   DDSCH5
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROFFOK  - Sets off the OK indicator of the field.           *
      *****************************************************************
     C     SROFFOK       BEGSR
 
     C                   IF        (DDSCC1 <> *BLANKS) OR
     C                             (DDSCH1 <> *BLANKS)
     C                   EVAL      OKSCC1 = 'N'
     C                   EVAL      OKSCH1 = 'N'
     C                   ENDIF
 
     C                   IF        (DDSCC2 <> *BLANKS) OR
     C                             (DDSCH2 <> *BLANKS)
     C                   EVAL      OKSCC2 = 'N'
     C                   EVAL      OKSCH2 = 'N'
     C                   ENDIF
 
     C                   IF        (DDSCC3 <> *BLANKS) OR
     C                             (DDSCH3 <> *BLANKS)
     C                   EVAL      OKSCC3 = 'N'
     C                   EVAL      OKSCH3 = 'N'
     C                   ENDIF
 
     C                   IF        (DDSCC4 <> *BLANKS) OR
     C                             (DDSCH4 <> *BLANKS)
     C                   EVAL      OKSCC4 = 'N'
     C                   EVAL      OKSCH4 = 'N'
     C                   ENDIF
 
     C                   IF        (DDSCC5 <> *BLANKS) OR
     C                             (DDSCH5 <> *BLANKS)
     C                   EVAL      OKSCC5 = 'N'
     C                   EVAL      OKSCH5 = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** O: Return Code
     C                   PARM                    ReturnCode
      *
      ************
      ** INPUTT **
      ************
      *
      ** Incoming Payments Lvl 1 details
     C                   PARM                    NwIP1ScnFmt
      ** Incoming Payments Lvl 2 Scrn 3 details
     C                   PARM                    NwIP5ScnFmt
      *
      ************
      ** OUTPUT **
      ************
      *
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 3 details
     C                   PARM                    OKIPY4DS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** ==============================================================
      ** Program, module and procedure names for database error proc'g.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
