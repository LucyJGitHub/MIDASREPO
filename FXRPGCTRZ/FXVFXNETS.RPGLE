     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate FX netting fields')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVFXNETS  - Validate FX Netting Fields                      *
      *               Buy/Sell Indicator                              *
      *               Manual Match Indicator                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 245619             Date 07Feb07               *
      *                 BUG11245           Date 16May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6251            Date 17Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 09May98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  245619 - Correct Sell Ind defaulting.                        *
      *  BUG11245 - Allow override of Net flags.                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6251- Change default processing for Net Buy/Sell          *
      *           indicators basing on Counter Party/Transaction Type *
      *           file (SDCPTTPD).                                    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     FFXNETML1  IF   E           K DISK    INFSR(*PSSR)
     FSDCGRPL2  IF   E           K DISK    INFSR(*PSSR)
     FSDCPTTL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG6251
     F/COPY WNCPYSRC,FXH00197
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
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
 
      ** Array of Fields with warnings
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of deal types                                                                 BUG6251
     D @TT             S              2A   DIM(40)                                           BUG6251
                                                                                             BUG6251
      ** External data structure for Customer codes file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSNETR          DS            19
      ** Dummy Net Reference
     D  DMBRCA                 1      3
     D  DMM#DD                 4      7
     D  DBSCCY                 8     10
     D  DCUSGP                11     16
     D  DSSEQN                17     19
 
     D DSVALD          DS             4
      ** Value Date
     D  DDAYNO                 1      2
     D  DMONTH                 3      4
 
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
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      ** Value Date
     D @VDYNO          S              5P 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** BSINV - Buy/Sell Indicator Validation
 
     C                   EXSR      BSINV
 
      ** MTCHV - Manual Match Indicator validation
 
     C                   EXSR      MTCHV
 
      ** If an error was found, set the return code appropriately
 
     C     DDNbuyOK      IFEQ      'N'
     C     DDNselOK      OREQ      'N'
     C     DDMtchOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * BSINV  - Buy/Sell Indicator Validation
      *****************************************************************
     C     BSINV         BEGSR
      *******************                                                                    BUG6251
      ***Buy*Indicator*Validation                                                            BUG6251
     C*****DDNBUY********IFEQ      *BLANK                                                    BUG6251
     C*******************MOVE      'N'           DDNBUY                                      BUG6251
     C*******************ENDIF                                                               BUG6251
      *                                                                                      BUG6251
      ** Ensure customer number is always used here as SDCPTTPD does not                     BUG6251
      ** keep shortnames, only cust no.                                                      BUG6251
      *                                                                                      BUG6251
     C                   CALLB     'AOCUSTR0'                                                BUG6251
     C                   PARM      *BLANKS       @RTCD             7                         BUG6251
     C                   PARM      '*KEY   '     @OPTN             7                         BUG6251
     C                   PARM      DDCUST        @KEY1            10                         BUG6251
     C                   PARM      *BLANKS       @KYST             7                         BUG6251
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG6251
      *                                                                                      BUG6251
     C     BBCUST        IFNE      *BLANKS                                                   BUG6251
     C     DDACTN        ANDEQ     'I'                                                       BUG6251
      *                                                                                      BUG6251
     C*****DDNBUY        IFNE      'Y'                                              BUG6251 BUG11245
     C*****DDNSEL        ORNE      'Y'                                              BUG6251 BUG11245
     C     DDNBUY        IFEQ      *BLANK                                                   BUG11245
     C     DDNSEL        OREQ      *BLANK                                                   BUG11245
      *                                                                                      BUG6251
     C     DDNBUY        IFEQ      *BLANK                                                   BUG11245
     C                   MOVE      'N'           DDNBUY                                      BUG6251
     C                   ENDIF                                                              BUG11245
     C*****DDNBUY        IFEQ      *BLANK                                             BUG11245245619
     C     DDNSEL        IFEQ      *BLANK                                                     245619
     C                   MOVE      'N'           DDNSEL                                      BUG6251
     C                   ENDIF                                                              BUG11245
     C                   Z-ADD     1             @INDX             1 0                       BUG6251
      *                                                                                      BUG6251
     C                   MOVEL     BBCUST        CUSTNO            6                         BUG6251
     C                   MOVEL     DDDLTP        DT                2                         BUG6251
     C     CUSTNO        CHAIN     @CPTTL1                            88                     BUG6251
     C     *IN88         IFEQ      *OFF                                                      BUG6251
     C                   MOVEA     B6TYPS        @TT                                         BUG6251
     C     DT            LOOKUP    @TT(@INDX)                             89                 BUG6251
     C     *IN89         IFEQ      *ON                                                       BUG6251
     C                   MOVE      'Y'           DDNBUY                                      BUG6251
     C                   MOVE      'Y'           DDNSEL                                      BUG6251
     C                   ENDIF                                                               BUG6251
     C                   ENDIF                                                               BUG6251
     C                   ENDIF                                                               BUG6251
     C                   ENDIF                                                               BUG6251
      *                                                                                      BUG6251
      *
      ** Must be Y or N
     C     DDNBUY        IFNE      'Y'
     C     DDNBUY        ANDNE     'N'
     C                   MOVE      'N'           DDNbuyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNBUY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5013'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Net Buy Indicator cannot be 'N' if Confirmed Net.
     C     DDNBUY        IFEQ      'N'
     C     DDNBRF        ANDNE     *BLANKS
     C                   MOVE      'N'           DDNbuyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNBUY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5018'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Net Buy Indicator cannot be amended to 'N' if Net in progress
     C     DDACTN        IFEQ      'A'
     C     DDNBUY        ANDEQ     'N'
     C     F3NBUY        ANDEQ     'Y'
     C                   MOVE      'B'           BUYSEL
     C                   EXSR      #ZIF
     C     #FOUND        IFEQ      'Y'
     C     AMRECI        IFEQ      'I'
     C     AMRECI        OREQ      'F'
     C                   MOVE      'N'           DDNbuyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNBUY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5017'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *******************                                                                    BUG6251
      ***Sell*Indicator*Validation                                                           BUG6251
     C*****DDNSEL********IFEQ      *BLANK                                                    BUG6251
     C*******************MOVE      'N'           DDNSEL                                      BUG6251
     C*******************ENDIF                                                               BUG6251
      *
      ** Must be Y or N
     C     DDNSEL        IFNE      'Y'
     C     DDNSEL        ANDNE     'N'
     C                   MOVE      'N'           DDNselOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNSEL'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5014'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Net Buy Indicator cannot be 'N' if Confirmed Net.
     C     DDNSEL        IFEQ      'N'
     C     DDNSRF        ANDNE     *BLANKS
     C                   MOVE      'N'           DDNselOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNSEL'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5018'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Net Buy Indicator cannot be amended to 'N' if Net in progress
     C     DDACTN        IFEQ      'A'
     C     DDNSEL        ANDEQ     'N'
     C     F3NSEL        ANDEQ     'Y'
     C                   MOVE      'S'           BUYSEL
     C                   EXSR      #ZIF
     C     #FOUND        IFEQ      'Y'
     C     AMRECI        IFEQ      'I'
     C     AMRECI        OREQ      'F'
     C                   MOVE      'N'           DDNselOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNSEL'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5017'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Check to see whether nets in progress/confirmed - gen warning
      *
      ** Buy Net Indicator
     C     DDNBUY        IFEQ      'Y'
     C                   MOVE      'B'           BUYSEL
     C                   EXSR      #ZIF
     ** If not in progress/confirmed display warning message
     C     #FOUND        IFEQ      'Y'
     C     DDNbuyOK      IFNE      'N'
     C                   MOVE      'W'           DDNbuyOK
     C                   END
     C                   ADD       1             WIx
     C                   MOVEL     'DDNBUY'      WFldNmXAr(WIx)
     C                   MOVEL     @MSGID        WMsgIdXAr(WIx)
     C**********         MOVEL     BUYNRF        WMsgDtXAr(WIx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(BUYNRF))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(BUYNRF)                   MD000091
     C                   ENDIF
     C                   ENDIF
      *
      ** Sell Net Indicator
     C     DDNSEL        IFEQ      'Y'
     C                   MOVE      'S'           BUYSEL
     C                   EXSR      #ZIF
     ** If not in progress/confirmed display warning message
     C     #FOUND        IFEQ      'Y'
     C     DDNselOK      IFNE      'N'
     C                   MOVE      'W'           DDNselOK
     C                   END
     C                   ADD       1             WIx
     C                   MOVEL     'DDNSEL'      WFldNmXAr(WIx)
     C                   MOVEL     @MSGID        WMsgIdXAr(WIx)
     C**********         MOVEL     SELNRF        WMsgDtXAr(WIx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SELNRF))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(SELNRF)                   MD000091
     C                   ENDIF
     C                   ENDIF
      *
     C/COPY WNCPYSRC,FXH00202
      ** Buy/Sell indicators are OK
     C     DDNbuyOK      IFNE      'N'
     C                   MOVE      DDNBUY        F3NBUY
     C                   ELSE
     C                   MOVE      *BLANK        F3NBUY
     C                   END
      *
     C     DDNselOK      IFNE      'N'
     C                   MOVE      DDNSEL        F3NSEL
     C                   ELSE
     C                   MOVE      *BLANK        F3NSEL
     C                   END
      *
     C                   MOVEL     DDNBRF        F3NBRF
     C                   MOVEL     DDNSRF        F3NSRF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * MTCHV  - Matched Deal indicator validation
      *****************************************************************
     C     MTCHV         BEGSR
      *
      ** Validate Matched Deal Indicator
     C     DDMTCH        IFNE      'Y'
     C     DDMTCH        ANDNE     'N'
     C     DDMTCH        ANDNE     *BLANK
     C                   MOVE      'N'           DDMtchOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMTCH'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5009'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Default Matched Deal Indicator
     C     DDMTCH        IFEQ      *BLANK
     C                   MOVE      'N'           DDMTCH
     C     DDNBUY        IFEQ      'Y'
     C     DDNSEL        OREQ      'Y'
      *
      ** Only if manual matching is required for the group
      ** or the customer
     C     @NGKEY        KLIST
     C                   KFLD                    D6SNBR
     C                   KFLD                    BBNTGP
     C                   MOVEL     '*'           D6SNBR
     C     @NGKEY        CHAIN     SDCGRPL2                           87
     C     BBNTMM        IFEQ      'Y'
     C     D6NTMM        OREQ      'Y'
     C                   MOVE      'Y'           DDMTCH
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Update Matched indicator field
     C     DDMtchOK      IFEQ      'Y'
     C                   MOVE      DDMTCH        F3MTCH
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * #ZIF   - Access Deal net Information
      *****************************************************************
     C     #ZIF          BEGSR
      *
     C     *LIKE         DEFINE    AMCCY1        KCCY1
     C     *LIKE         DEFINE    AMCCY2        KCCY2
     C     *LIKE         DEFINE    DDNBUY        BUYSEL
      *
      ** Set up Net Reference if blank
     C     DDNBRF        IFEQ      *BLANKS
     C     DDNSRF        OREQ      *BLANKS
      *
      ** Access customer info for Netting Group
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCUST        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Module ID:-
     C                   MOVEL     'DL#'         DMBRCA
      ** Month and Day Number:-
     C                   MOVEL     DDVDAT        DSVALD
     C                   MOVEL     DMONTH        DMM#DD
     C                   MOVE      DDAYNO        DMM#DD
      *
      ** Currency:-
     C     BUYSEL        IFEQ      'B'
     C                   MOVEL     DDBCCY        DBSCCY
     C                   ELSE
     C                   MOVEL     DDSCCY        DBSCCY
     C                   END
     C/COPY WNCPYSRC,FXH00109
      *
      ** Netting Group or Customer:-
     C     BBNTGP        IFNE      *BLANKS
     C                   MOVEL     BBNTGP        DCUSGP
     C                   MOVE      '##'          DCUSGP
     C                   ELSE
     C                   MOVEL     DDCUST        DCUSGP
     C                   END
     C/COPY WNCPYSRC,FXH00110
      *
      ** Set up key for paired currency net.
     C     DDBCCY        IFLT      DDSCCY
     C                   MOVEL     DDBCCY        KCCY1
     C                   MOVEL     DDSCCY        KCCY2
     C                   ELSE
     C                   MOVEL     DDSCCY        KCCY1
     C                   MOVEL     DDBCCY        KCCY2
     C                   END
      *
     C     *LIKE         DEFINE    AMNETR        BUYNRF
     C     *LIKE         DEFINE    AMNETR        SELNRF
      *
      ** Check for a paired currency net.
     C                   EXSR      #ZIFA
      *
      ** If found store net ref. for warning message
     C     #FOUND        IFEQ      'Y'
     C     DDNBUY        ANDEQ     'Y'
     C     #FOUND        OREQ      'Y'
     C     DDNSEL        ANDEQ     'Y'
      *
     C     BUYSEL        IFEQ      'B'
     C                   MOVEL     AMNETR        BUYNRF
     C                   ELSE
     C                   MOVEL     AMNETR        SELNRF
     C                   END
      *
     C                   SELECT
      *
      ** Paired Currency net is in progress.
     C     AMRECI        WHENEQ    'I'
     C     AMRECI        OREQ      'F'
     C                   MOVEL     'FXM5023'     @MSGID           10
      *
      ** Confirmed Paired Currency Net.
     C     AMRECI        WHENEQ    'C'
     C                   MOVEL     'FXM5019'     @MSGID
     C                   ENDSL
     C                   ENDIF
      *
      ** If paired currency net not found check for single currency net.
     C     #FOUND        IFEQ      'N'
      *
      ** Set up key for single currency net.
     C                   CLEAR                   KCCY1
     C                   CLEAR                   KCCY2
      *
      ** Check for single currency net.
     C     DDBCCY        IFNE      *BLANKS
     C     DDSCCY        ANDNE     *BLANKS
     C                   EXSR      #ZIFA
      *
      **If found store net ref. for warning message.
     C     #FOUND        IFEQ      'Y'
     C     DDNBUY        ANDEQ     'Y'
     C     #FOUND        OREQ      'Y'
     C     DDNSEL        ANDEQ     'Y'
      *
     C     BUYSEL        IFEQ      'B'
     C                   MOVEL     AMNETR        BUYNRF
     C                   ELSE
     C                   MOVEL     AMNETR        SELNRF
     C                   END
      *
     C                   SELECT
      *
      ** Single Currency net is in progress.
     C     AMRECI        WHENEQ    'I'
     C     AMRECI        OREQ      'F'
     C                   MOVEL     'FXM5022'     @MSGID
      *
      ** Confirmed Single Currency Net.
     C     AMRECI        WHENEQ    'C'
     C                   MOVEL     'FXM5024'     @MSGID
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * #ZIFA  - Checks Confirmed Net master file with deal details
      *****************************************************************
     C     #ZIFA         BEGSR
      *
     C     NETKEY        KLIST
     C                   KFLD                    @VDYNO
     C                   KFLD                    KCCY1
     C                   KFLD                    KCCY2
     C                   KFLD                    DSNETR
      *
     C     NETKEY        SETLL     FXNETML1
     C                   READ      FXNETML1                             8889
      *
      ** Check record read is equal to access key fields by using
      ** sequence number found and comparing values.
     C     *IN89         IFEQ      '0'
     C                   CLEAR                   DSSEQN
     C                   MOVE      AMSEQN        DSSEQN
      *
     C     AMVALD        IFEQ      @VDYNO
     C     AMCCY1        ANDEQ     KCCY1
     C     AMCCY2        ANDEQ     KCCY2
     C     AMNETR        ANDEQ     DSNETR
     C                   MOVE      'Y'           #FOUND            1
     C                   ELSE
     C                   MOVE      'N'           #FOUND
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDCUST           10
     C                   PARM                    DDBCCY            3
     C                   PARM                    DDNBUY            1
     C                   PARM                    DDSCCY            3
     C                   PARM                    DDNSEL            1
     C                   PARM                    DDMTCH            1
     C                   PARM                    DDNBRF           19
     C                   PARM                    DDNSRF           19
     C                   PARM                    DDDLTP            2                         BUG6251
      *
      ** Value Date
     C                   PARM                    @VDYNO
     C/COPY WNCPYSRC,FXH00111
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Net Buy Ind - OK
      ** Net Sell Ind - OK
      ** Matched Deal Ind - OK
     C                   PARM                    DDNBuyOK          1              action code
     C                   PARM                    DDNSelOK          1              booking branch
     C                   PARM                    DDMtchOK          1              origin. branch
      *
      ** Buy/Sell Indicators and Matched Deal Indicator
      ** and Net Buy/Sell References
     C                   PARM                    F3NBUY            1            booking branch
     C                   PARM                    F3NSEL            1            origin. branch
     C                   PARM                    F3MTCH            1            origin. branch
     C                   PARM                    F3NBRF           19
     C                   PARM                    F3NSRF           19
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
