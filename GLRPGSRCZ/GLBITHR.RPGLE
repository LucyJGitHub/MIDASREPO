     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Retrieve a record')                        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLBITHR   - GL Batch Header retrieve a record                *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054696           Date 29Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 07May13               *
      *                 CSC054             Date 23Feb12               *
      *                 260029             Date 29Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15754           Date 30Jan08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7895            Date 18Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG1175R           Date 02Jun04               *
      *                 BUG2427            Date 27May04               *
      *                 BUG2796            Date 20May04               *
      *                 BUG1175            Date 28Apr04               *
      *                 BUG711             Date 18Mar04               *
      *                 CAP084  *CREATE    Date 12Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054696 - Journal Entries Avoid Shadow Postings Update.     *
      *             Add Shadow Post Indicator in BITH API (SOAP/JMS). *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSC054 - Period End Adjustments                              *
      *  260029 - Applied core fix 251260.                            *
      *  251260 - Journal entry hash item no. do not match. Increase  *
      *           length of field DDHINC from 2A to 3A (Recompile).   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15754 - Applied fix 249471.                               *
      *  249471 - Calculated Hash Total and No. of Items added to     *
      *           Header input screen. Recompiled only.               *
      *  BUG7895 -Action code field added to GLBITHPD (Recompiled)    *
      *  CSC024 - Open Month End (Recompile)                          *
      *  BUG1175R-Send correct user id back when batch is in use      *
      *  BUG2427- Batch in use flag now updated by java              *
      *  BUG2796- If batch has been submitted for posting the let     *
      *           the user know by sending a message                  *
      *  BUG1175- If setting batch to in use also set up user & tmst  *
      *           Also send back DDINOV = T if batch has been locked  *
      *           for more than ten minutes without further update.   *
      *  BUG711 - Set batch in use when user retrieves details        *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** JE Headers file
     F**********GLJENHL0  IF   E           K DISK    INFSR(*PSSR)                             BUG711
     F**********GLJENHL0  UF   E           K DISK    INFSR(*PSSR)                     BUG711 BUG2427
     FGLJENHL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG2427
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
     D WCompTmSt       S             26Z                                                     BUG1175
     D WSysTmSt        S             26Z                                                     BUG1175
     D LUser           S             10A                                                     BUG1175
     D TIMEtime        S               T                                                     BUG1175
     D TIMEchar        S             10A                                                     BUG1175
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D BITHScnFmt    E DS                  EXTNAME(GLBITHPD)
      * Deal in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D BITHFilFmt    E DS                  EXTNAME(GLJENHPD)
      ** Deal in file format
 
      **-----------------------------------------------------------------------
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                    BUG1175
      ** Java user information                                                               BUG1175
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
                                                                                              CSC054
      ** Period End Adjustments Fields                                                        CSC054
     D PEAHeader       S              8A                                                      CSC054
                                                                                            MD054696
      ** JE Non-screen Interface Data file format                                           MD054696
     D PInfData      E DS                  EXTNAME(GLJEIFPD)                                MD054696
     D                                     PREFIX(IF_)                                      MD054696
                                                                                            MD054696
      ** JE Headers Extra Data (DS)                                                         MD054696
     D PExtData      E DS                  EXTNAME(GLBHEXPD)                                MD054696
                                                                                            MD054696
      ** JE Headers Shadow Post Indicator                                                   MD054696
     D DDSHPI          S              1A                                                    MD054696
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDBTNB_In         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLBITH02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   BITHFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      GLBITHRED
     C                   ELSE
     C                   MOVEL     DDBTNB_In     @BNRED            3
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If header read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @BNRED <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @BNRED        DDBTNB
     C                   MOVEL     @FTRED        APFOTranID       20
     C                   EXSR      GLBITHRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      GLBITHCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDBTNB'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
      *
      ** Send message if the header is in use by another operator
      *
     C                   IF        ReturnCode = *BLANK
     C     DDBTNB        CHAIN     GLJENHL0                           20
     C     *IN20         IFEQ      *OFF
     C*****BRBIUF        ANDEQ     'Y'                                                        BUG711
     C     BRBIUF        IFEQ      'Y'                                                        BUG711
      *                                                                                      BUG1175
      ** If batch has been in use for more than 10 minutes with no further activity          BUG1175
      ** then set DDINOV = T                                                                 BUG1175
      *                                                                                      BUG1175
     C                   CALLB     'ZAGENTMSTM'                                              BUG1175
     C                   PARM                    WSysTmSt                                    BUG1175
      *                                                                                      BUG1175
     C     BRTMST        ADDDUR    600:*S        WCompTmSt                                   BUG1175
     C*****BRUSRA        IFEQ      *BLANKS                                          BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRI                                   BUG1175 BUG1175R
     C**********         ELSE                                                       BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRI                                   BUG1175 BUG1175R
     C**********         ENDIF                                                      BUG1175 BUG1175R
     C                   Eval      LUser = BRWSID                                           BUG1175R
      *                                                                                      BUG1175
     C                   MOVEL     'DDBTNB'      FldNameArr(1)
     C**********         MOVEL     'GLX0041'     MsgIDArr(1)                                 BUG1175
     C                   MOVEL     'GLX0422'     MsgIDArr(1)                                 BUG1175
     C                   Eval      TIMEtime = %time(BRTMST)                                  BUG1175
     C                   MOVE      TIMEtime      TIMEchar                                    BUG1175
     C**********         Eval      MsgDtaArr(1) = LUser + ' @ ' + TIMEchar          BUG1175 MD000091
     C                   Eval      MsgDtaTmp = LUser + ' @ ' + TIMEchar                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
      *                                                                                      BUG1175
     C     WSysTmSt      IFGE      WCompTmSt                                                 BUG1175
     C                   Eval      DDINOV = 'T'                                              BUG1175
     C                   ENDIF                                                               BUG1175
      *                                                                                      BUG1175
     C                   ELSE                                                                 BUG711
      *                                                                                      BUG1175
     C**********         CALLB     'ZAGENTMSTM'                                      BUG1175 BUG2427
     C**********         PARM                    WSysTmSt                            BUG1175 BUG2427
      *                                                                                      BUG1175
     C**********         Eval      BRTMST = WsysTmSt                                 BUG1175 BUG2427
     C**********         Eval      BRUSRA = USRID                                    BUG1175 BUG2427
      *                                                                                      BUG1175
     C**********         MOVE      'Y'           BRBIUF                               BUG711 BUG2427
     C                   MOVE      'Y'           DDINOV                                       BUG711
     C**********         UPDATE    @BRREAG                                            BUG711 BUG2427
     C                   ENDIF                                                                BUG711
      * If the batch header status is 'S' then batch has been submitted.                     BUG2796
      * Make sure the user knows this.                                                       BUG2796
     C     BRBTSF        IFEQ      'S'                                                       BUG2766
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                               BUG2796
     C                   MOVEL     'GLX0276'     MsgIDArr(1)                                 BUG2796
     C**********         Eval      MsgDtaArr(1) = BRBTNB                            BUG2796 MD000091
     C                   EVAL      BLen = %Len(%Trim(BRBTNB))                               MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(BRBTNB)                     MD000091
     C                   ENDIF                                                               BUG2796
     C                   ENDIF
     C                   ENDIF
 
      * Build buffer with required output
     C                   EVAL                    Buffer = BITHScnFmt
     C                                                    + PEAHeader                         CSC054
     C                                           + PInfData + PExtData                      MD054696
     C                                           + DDSHPI                                   MD054696
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     GLBITHRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'GLBITHRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * Batch Number
     C                   PARM      DDBTNB_In     DDBTNB            3
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      *Transaction Read
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
      **********************************************************************
     C     GLBITHRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'GLBITHRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
 
      * Action Code
     C                   PARM                    APFOTranID       20
 
      * Batch Header Number
     C                   PARM                    DDBTNB
                                                                                             BUG7895
      * Multiple branch batch indicator                                                      BUG7895
     C                   PARM                    DDMBRB                                      BUG7895
                                                                                             BUG7895
      * Batch Header Branch                                                                  BUG7895
     C                   PARM                    DDBCDA                                      BUG7895
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    BITHFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK          1
 
      * OK - Batch Number
     C                   PARM                    DDBtnbBK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
      **********************************************************************
     C     GLBITHCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'GLBITHCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    BITHFilFmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    BITHScnfmt
                                                                                            MD054696
      * Batch Header - Shadow Post Indicator                                                MD054696
     C                   PARM                    DDSHPI                                     MD054696
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
