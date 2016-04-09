     H DEBUG
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas SD CLIP Validation - Extension')                 *
      *****************************************************************
      *                                                               *
      *  Misys - Lending Module                                       *
      *                                                               *
      *  LECLIP5VL - Midas LE CLIP Validation - Extension             *
      *                                                               *
      *  Function: This Function validates LE Extended Customers      *
      *            fields for input into the Midas database.          *
      *                                                               *
      *  Called By: LECLIPCTL, LECLIP2RP and LECLIPVU                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. AR804863           Date 10Dec12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FERLUMPL0  IF   E           K DISK    INFSR(*PSSR)                                     AR804863
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based on
      ** the corresponding fields in the PSDS /COPY member, so that
      ** member must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRVSUBR - Validate Subordinate                               *
      *  SRVMOBL - Validate Mobilisation                              *
      *  SRVGUAC - Validate Consumer Credit Code                      *
      *  SRVPPSC - Validate Property Sector Code                      *
      *  SRVCOAM - Validate Correction Amount                         *
      *  SRVIMEX - Validate Import/Export Indicator                   *
      *  SRVRISC - Validate Risc Code                                 *
      *  SRVIM93 - Validate BCL Circular 96/127                       *
      *  SRVCLAT - Validate Claim Type                                *
      *  SRVLUSU - Validate Lump Sum Provision Code                   *
      *  SRVDGRI - Validate Degree of Risk                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D PDATA           DS          1024
      *
     D  #1LNRF                 1      6
     D  #1CUST                 7     12
     D  #1PTYP                13     14
     D  #1CCY                 15     17
     D  #1AMNT                18     32  0
      *
      **
      **   Named constants
      **   ===============
      **
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, short Data
 
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLLX1PD)
      ** New Customer in File Format
 
     D CLIPScnFmtEx  E DS                  EXTNAME(LECLRXPD)
      ** New Customer in Screen Format
 
     D OKCLEXFlgs    E DS                  EXTNAME(LEECLLX1PD)
                                                                                            AR804863
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                AR804863
                                                                                            AR804863
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                AR804863
                                                                                            AR804863
      ** Error fields indicators
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D WLURA           S              4S 0
     D PVLUSU          S              2S 0
     D ULX612          S              1A
     D Pactn           S              1A
 
      *                                                                                     AR804863
      ** Define parameters for call module                                                  AR804863
      *                                                                                     AR804863
     D ZALIGNok        S              1A                                                    AR804863
     D ZFIELD          S             16A                                                    AR804863
     D ZADEC           S              1P 0                                                  AR804863
     D ZADIG           S              2P 0                                                  AR804863
                                                                                            AR804863
     D @@ALPH          S             16A                                                    AR804863
     D @@IDP           S              3  0                                                  AR804863
     D @@IINT          S              3  0                                                  AR804863
     D @@MTID          S              1A                                                    AR804863
     D @@ERCD          S              1  0                                                  AR804863
     D @@AMT           S             15  0                                                  AR804863
     D @CCY            S              3A                                                    AR804863
                                                                                            AR804863
     D @KEY1           S             10A                                                    AR804863
     D @KYST           S              7A                                                    AR804863
                                                                                            AR804863
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
 
      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
 
     D MSGDATA         S                   LIKE(#MsgData)
      *
      ** Error message substitution data received as a parameter
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      **  Initial processing is performed automatically: the *INZSR is
      **  executed at program activation.
      **
     C                   IF        #1AMNT < 0
     C                   Z-SUB     #1AMNT        #1AMNT
     C                   ENDIF
      *
     C                   MOVE      #1LNRF        LKLNRF
      *                                                                                     AR804863
      ** Skip validation process if action is reject.                                       AR804863
      *                                                                                     AR804863
     C     @ACTRV        IFEQ      'Y'                                                      AR804863
     C                   EXSR      SRRSFD                                                   AR804863
     C                   RETURN                                                             AR804863
     C                   ENDIF                                                              AR804863
      *
      ** Subordinate
      *
     C                   EXSR      SRVSUBR
     C                   EVAL      LKSUBR = LSUBR
      *
      ** Mobilisation
      *
     C                   EXSR      SRVMOBL
      *
      ** Consumer Credit Code
      *
     C                   EXSR      SRVGUAC
      *
      ** Property Sector Code
      *
     C                   EXSR      SRVPPSC
      *
      ** Correction Amount
      *
     C                   EXSR      SRVCOAM
      *
      ** Import/Export Indicator
      *
     C                   EXSR      SRVIMEX
      *
      ** Risk Code
      *
     C                   EXSR      SRVRISC
      *
      ** BCL Circular 96/127
      *
     C                   EXSR      SRVIM93
      *
      ** Claim Type
      *
     C                   EXSR      SRVCLAT
      *
      ** Lump Sum Provision Code
      *
     C                   EXSR      SRVLUSU
     C                   MOVE      LLUSU         LKLUSU
      *
      ** Degree of Risk
      *
     C                   IF        ULX612 <> 'Y' OR ULX612 = 'Y' AND
     C                             #1PTYP <> '64' AND #1PTYP <> '65' AND
     C                             #1PTYP <> '68' AND #1PTYP <> '71'
     C                   EXSR      SRVDGRI
     C                   ELSE
     C                   IF        LDGRI <> *BLANK AND LDGRI <> '0'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LDGRI'
     C                   EVAL      MsgIDArr(Idx) = 'ER32022'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LDGRIOK
     C                   PARM      'Error '      ReturnCode
     C                   PARM                    WarnGlobal
     C                   ELSE
     C                   EVAL      LKDGRI = 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      ** RESETERRS - Reset error information that is received back    *
      **             from each validation module.                     *
      *                                                               *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7
 
     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVSUBR - Routine to validate LSUBR
      *
      *****************************************************************
      *
     C     SRVSUBR       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVSUBR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LSUBR
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LSUBR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LSUBROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVMOBL - Routine to validate LMOBL
      *
      *****************************************************************
      *
     C     SRVMOBL       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVMOBL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LMOBL
     C                   PARM                    LKMOBL
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LMOBL'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LMOBLOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVGUAC - Routine to validate LGUAC
      *
      *****************************************************************
      *
     C     SRVGUAC       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVGUAC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LGUAC
     C                   PARM                    LK1UAC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LGUAC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LGUACOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVPPSC - Routine to validate LPPSC
      *
      *****************************************************************
      *
     C     SRVPPSC       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVPPSC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LPPSC
     C                   PARM                    LKPPSC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LPPSC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LPPSCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVCOAM - Routine to validate LCOAM
      *
      *****************************************************************
      *
     C     SRVCOAM       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVCOAM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LCOAM
     C                   PARM                    LKCOAM
     C                   PARM                    #1AMNT
     C                   PARM                    #1CCY
     C                   PARM                    BNDCSP
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LCOAM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LCOAMOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVIMEX - Routine to validate LIMEX
      *
      *****************************************************************
      *
     C     SRVIMEX       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVIMEX'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LIMEX
     C                   PARM                    LKIMEX
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LIMEX'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LIMEXOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVRISC - Routine to validate LRISC
      *
      *****************************************************************
      *
     C     SRVRISC       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVRISC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LRISC
     C                   PARM                    LKRISC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LRISC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LRISCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      ** SRVIM93 - Routine to validate LIM93
      *
      *****************************************************************
      *
     C     SRVIM93       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVIM93'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LIM93
     C                   PARM                    LKIM93
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LIM93'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LIM93OK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRVCLAT - Routine to validate LCLAT
      *****************************************************************
      *
     C     SRVCLAT       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVCLAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LCLAT
     C                   PARM                    LKCLAT
     C                   PARM                    LSUBR
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LCLAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LCLATOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRVLUSU - Routine to validate LLUSU
      *****************************************************************
      *
     C     SRVLUSU       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
     C                   Z-ADD     0             WLURA
      *
     C                   CALLB     'LEVLUSU'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LLUSU
     C                   PARM                    WLURA
     C                   PARM                    PVLUSU
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LLUSU'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LLUSUOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRVDGRI - Routine to validate DGRI
      *****************************************************************
      *
     C     SRVDGRI       BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'LEVDGRI'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LDGRI
     C                   PARM                    LKDGRI
     C                   PARM                    #1PTYP
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LDGRI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LDGRIOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************                     AR804863
      /EJECT                                                                                AR804863
      *****************************************************************                     AR804863
      *                                                               *                     AR804863
      * SRRSFD  -  Restore original details (for Reject Action)       *                     AR804863
      *                                                               *                     AR804863
      *****************************************************************                     AR804863
     C     SRRSFD        BEGSR                                                              AR804863
      *                                                                                     AR804863
     C                   EVAL      LKSUBR = LSUBR                                           AR804863
      *                                                                                     AR804863
     C                   IF        LMOBL <> *BLANKS                                         AR804863
     C                   EVAL      @KEY1 = *BLANKS                                          AR804863
     C                   CALLB     'AOCUSTR0'                                               AR804863
     C                   PARM      *BLANKS       @RTCD                                      AR804863
     C                   PARM      '*KEY'        @OPTN                                      AR804863
     C                   PARM      LMOBL         @KEY1                                      AR804863
     C                   PARM      *BLANKS       @KYST                                      AR804863
     C     SDCUST        PARM      SDCUST        DSSDY                                      AR804863
     C                   MOVE      BBCUST        LKMOBL                                     AR804863
     C                   ELSE                                                               AR804863
     C                   EVAL      LKMOBL = *BLANKS                                         AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
     C                   MOVEL(P)  LRISC         ZFIELD                                     AR804863
     C                   EVAL      ZADEC      = 0                                           AR804863
     C                   EVAL      ZADIG      = 2                                           AR804863
     C                   CALLB     'ZALIGN'                                                 AR804863
     C                   PARM                    ZALIGNOk                                   AR804863
     C                   PARM                    ZFIELD                                     AR804863
     C                   PARM                    ZADEC                                      AR804863
     C                   PARM                    ZADIG                                      AR804863
     C                   MOVE      ZFIELD        LKRISC                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL(P)  LIMEX         ZFIELD                                     AR804863
     C                   EVAL      ZADEC      = 0                                           AR804863
     C                   EVAL      ZADIG      = 1                                           AR804863
     C                   CALLB     'ZALIGN'                                                 AR804863
     C                   PARM                    ZALIGNok                                   AR804863
     C                   PARM                    ZFIELD                                     AR804863
     C                   PARM                    ZADEC                                      AR804863
     C                   PARM                    ZADIG                                      AR804863
     C                   MOVE      ZFIELD        LKIMEX                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL(P)  LPPSC         ZFIELD                                     AR804863
     C                   EVAL      ZADEC      = 0                                           AR804863
     C                   EVAL      ZADIG      = 6                                           AR804863
     C                   CALLB     'ZALIGN'                                                 AR804863
     C                   PARM                    ZALIGNok                                   AR804863
     C                   PARM                    ZFIELD                                     AR804863
     C                   PARM                    ZADEC                                      AR804863
     C                   PARM                    ZADIG                                      AR804863
     C                   MOVE      ZFIELD        LKPPSC                                     AR804863
      *                                                                                     AR804863
     C                   CALLB     'AOCURRR0'                                               AR804863
     C                   PARM      *BLANKS       @RTCD                                      AR804863
     C                   PARM      '*KEY   '     @OPTN                                      AR804863
     C                   PARM      #1CCY         @CCY                                       AR804863
     C     SDCURR        PARM      SDCURR        DSSDY                                      AR804863
     C                   Z-ADD     A6NBDP        @@IDP                                      AR804863
     C     15            SUB       A6NBDP        @@IINT                                     AR804863
     C                   MOVE      *BLANKS       @@ALPH                                     AR804863
     C                   MOVE      LCOAM         @@ALPH                                     AR804863
     C                   MOVE      'Y'           @@MTID                                     AR804863
     C                   CALLB     'ZA0840'                                                 AR804863
     C                   PARM                    RetCodeOut                                 AR804863
     C                   PARM                    @@ALPH                                     AR804863
     C                   PARM                    @@IDP                                      AR804863
     C                   PARM                    @@IINT                                     AR804863
     C                   PARM                    @@MTID                                     AR804863
     C                   PARM      *ZERO         @@ERCD                                     AR804863
     C                   PARM                    @@AMT                                      AR804863
     C                   PARM                    BNDCSP                                     AR804863
     C                   EVAL      LKCOAM     = @@AMT                                       AR804863
      *                                                                                     AR804863
     C                   MOVEL(P)  LDGRI         ZFIELD                                     AR804863
     C                   EVAL      ZADEC      = 0                                           AR804863
     C                   EVAL      ZADIG      = 1                                           AR804863
     C                   CALLB     'ZALIGN'                                                 AR804863
     C                   PARM                    ZALIGNok                                   AR804863
     C                   PARM                    ZFIELD                                     AR804863
     C                   PARM                    ZADEC                                      AR804863
     C                   PARM                    ZADIG                                      AR804863
     C                   MOVE      ZFIELD        LKDGRI                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL(P)  LIM93         ZFIELD                                     AR804863
     C                   EVAL      ZADEC      = 0                                           AR804863
     C                   EVAL      ZADIG      = 1                                           AR804863
     C                   CALLB     'ZALIGN'                                                 AR804863
     C                   PARM                    ZALIGNok                                   AR804863
     C                   PARM                    ZFIELD                                     AR804863
     C                   PARM                    ZADEC                                      AR804863
     C                   PARM                    ZADIG                                      AR804863
     C                   MOVE      ZFIELD        LKIM93                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL(P)  LCLAT         ZFIELD                                     AR804863
     C                   EVAL      ZADEC      = 0                                           AR804863
     C                   EVAL      ZADIG      = 1                                           AR804863
     C                   CALLB     'ZALIGN'                                                 AR804863
     C                   PARM                    ZALIGNok                                   AR804863
     C                   PARM                    ZFIELD                                     AR804863
     C                   PARM                    ZADEC                                      AR804863
     C                   PARM                    ZADIG                                      AR804863
     C                   MOVE      ZFIELD        LKCLAT                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL(P)  LGUAC         ZFIELD                                     AR804863
     C                   EVAL      ZADEC      = 0                                           AR804863
     C                   EVAL      ZADIG      = 1                                           AR804863
     C                   CALLB     'ZALIGN'                                                 AR804863
     C                   PARM                    ZALIGNok                                   AR804863
     C                   PARM                    ZFIELD                                     AR804863
     C                   PARM                    ZADEC                                      AR804863
     C                   PARM                    ZADIG                                      AR804863
     C                   MOVE      ZFIELD        LK1UAC                                     AR804863
      *                                                                                     AR804863
     C                   MOVE      LLUSU         LKLUSU                                     AR804863
      *                                                                                     AR804863
     C                   Z-ADD     0             LKLURA                                     AR804863
     C                   IF        LKLUSU<> 0                                               AR804863
     C     LKLUSU        CHAIN     ERLUMPL0                                                 AR804863
     C                   EVAL      LKLURA     = LSRATE                                      AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
     C                   ENDSR                                                              AR804863
      *
      /EJECT
      *****************************************************************
      *                                                               *
      ** *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    Pactn
     C                   PARM                    PDATA
     C                   PARM                    CLIPScnFmtEx
     C                   PARM                    OKCLEXFlgs
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidCLIPEx
     C                   PARM                    @ACTRV            1                        AR804863
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LECLIP5VL'   DBPGM
     C                   OUT       LDA
      *
      ** Check if switchable feature ULX612 is ON.
      *
     C                   MOVE      'N'           ULX612
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX612'      @SARD             6
      *
     C                   IF        @RTCD = *BLANKS
     C                   MOVE      'Y'           ULX612
     C                   ELSE
     C                   IF        @RTCD = '*NRF'
     C                   MOVE      'N'           ULX612
     C                   ELSE
      *
      ** Database error
      *
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   EVAL      DBASE = 001
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Call AODEALR1 for the decimal separator.
      *
     C                   CALL      'AODEALR1'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   EVAL      DBASE = 002
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
      *
      * The following /COPY sets these values, and also defines LDA as
      * an external data area
     C/COPY ZACPYSRC,DBERREXIT
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
