     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE MT565 Message Extract')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE1877 - SE MT565 Message Extract.                           *
      *                                                               *
      *  Function:  This module will extract information from         *
      *             the position settlement file and output the       *
      *             data to new file PF/MGF565PD.                     *
      *                                                               *
      *  Component of: SEC7610 SE Treaty withholding tax extract      *
      *                and report.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 26Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187801             Date 18Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186110             Date 14Nov00               *
      *                 185735             Date 25Oct00               *
      *                 185894             Date 06Nov00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW025 - Midas Message Manager                               *
      *           - Pass original change type                         *
      *  187801 - For OID maturity, we cannot group position          *
      *           settlement by tax rate, because of discount amount  *
      *  186110 - Duplicate records in writing to MGOREFPD encountered*
      *           in MG0565                                           *
      *  185735 - Database error occured if position settlement has   *
      *           no tax basket attached to it                        *
      *  185894 - Tax percentage grouping is not working correctly.   *
      *           because key field changed in MGF565L0.              *
      *  CSE023 - Treaty Witholding Tax                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPOSETW4   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(W4_)
     FMGF565L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MG_)
     FPOSETR    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(POSETDF:PRPOSETDF)
     F                                     PREFIX(PR_)
     FMGOREFWT  IF   E           K DISK    INFSR(*PSSR)                         186110
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  02        File processing (CHAIN)                            *
      *  90-99     Used by standard subroutine                        *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** DS for input file
     D InPoset       E DS                  EXTNAME(POSETD)
     D                                     PREFIX(W4_)
 
      ** DS for output file
     D OutPoset      E DS                  EXTNAME(MGF565PD)
     D                                     PREFIX(MG_)
 
      ** DS for work file
     D WrkPoset      E DS                  EXTNAME(MGF565PD)
     D                                     PREFIX(WK_)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
 
     D PRtCd           S              7A
     D POptn           S              7A
 
     D WPref           S              6  0
     D WPrefMg         S              6  0                                      186110
     D WSecurity       S                   LIKE(W4_PSSH)
     D WValDat         S                   LIKE(W4_PSVL)
     D WEvnType        S                   LIKE(W4_PEVT)
     D WCntPty         S                   LIKE(W4_PCPY)
     D WMT5G           S                   LIKE(W4_MT5G)                        186110
     D WPSecurity      S                   LIKE(W4_PSSH)
     D WPValDat        S                   LIKE(W4_PSVL)
     D WPEvnType       S                   LIKE(W4_PEVT)
     D WPCntPty        S                   LIKE(W4_PCPY)
     D WPMT5G          S                   LIKE(W4_MT5G)                        186110
     D KPref           S                   LIKE(MG_PREF)
     D KPctg           S                   LIKE(MG_PCTG)
     D KMT5G           S                   LIKE(MG_MT5G)                        185894
     D PCrtx           S              2
     D PTxbs           S              2
     D PPdud           S              5  0
     D PNarr           S             15
     D PTxrt           S              6  4
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process inputs.
 
     C                   EXSR      SRProc
 
      ** Return.
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
     C                   EVAL      *IN01 = *OFF
     C     *LOVAL        SETLL     POSETW4                            01
     C                   DOW       *IN01 = *OFF
 
     C                   READ      POSETW4                                01
     C                   MOVE      MG_CHTP       @CHG              1                          CSW025
 
     C                   IF        *IN01 <> '1'
 
     C                   EVAL      WrkPoset = InPoset
     C                   EVAL      WSecurity = W4_PSSH
     C                   EVAL      WValDat = W4_PSVL
     C                   EVAL      WEvnType = W4_PEVT
     C                   EVAL      WCntPty = W4_PCPY
     C                   EVAL      WMT5G = W4_MT5G                              186110
 
     C                   IF        WSecurity <> WPSecurity OR
     C                             WValDat <> WPValDat OR
     C                             WEvnType <> WPEvnType OR
     C                             WMT5G <> WPMT5G OR                           186110
     C                             WCntPty <> WPCntPty
 
     C                   IF        WK_PREF = *BLANKS OR
     C                             WK_PREF = '000000'
 
      **  Generate position settlement reference number
 
     C                   EXSR      SRGenRefN
     C                   ENDIF
 
     C                   EVAL      WPSecurity = WSecurity
     C                   EVAL      WPValDat = WValDat
     C                   EVAL      WPEvnType = WEvnType
     C                   EVAL      WPCntPty = WCntPty
     C                   EVAL      WPMT5G = WMT5G                               186110
 
     C                   ENDIF
 
      ** Get percentage
 
     C                   IF        W4_TXBS <> *BLANKS                           185735
     C                   EXSR      SRGetPct
     C                   ELSE                                                   185735
     C                   EVAL      WK_PCTG = 0                                  185735
     C                   ENDIF                                                  185735
 
      ** Update file
 
     C                   EXSR      SRUpdFle
 
     C                   ENDIF
     C                   ENDDO
 
     C                   COMMIT
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenRefN - Generate Reference Number                        *
      *                                                               *
      *****************************************************************
     C     SRGenRefN     BEGSR
 
     C     *HIVAL        SETGT     POSETR                             02
     C                   READ      POSETR                                 02
     C                   IF        *IN02 = *ON
     C                   EVAL      WPref = 1
     C                   ELSE
     C                   MOVE      PR_PREF       WPref
     C                   EVAL      WPref = WPref + 1
     C                   ENDIF
                                                                                186110
     C     *HIVAL        SETGT     MGOREFWT                           02        186110
     C                   READ      MGOREFWT                               02    186110
     C                   IF        *IN02 = *ON                                  186110
     C                   EVAL      WPrefMg = 1                                  186110
     C                   ELSE                                                   186110
     C                   MOVE      MGREF1        WPrefMg                        186110
     C                   EVAL      WPrefMg = WPrefMg + 1                        186110
     C                   ENDIF                                                  186110
                                                                                186110
     C                   IF        WPrefMg > WPref                              186110
     C                   EVAL      WPref = WPrefMg                              186110
     C                   ENDIF                                                  186110
                                                                                186110
     C                   MOVE      WPref         WK_PREF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetPct - Get Percentage                                    *
      *                                                               *
      *****************************************************************
     C     SRGetPct      BEGSR
 
     C                   CALLB     'AOTXBSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      W4_CRTX       PCrtx
     C                   PARM      W4_TXBS       PTxbs
     C                   PARM      W4_PDUD       PPdud
     C                   PARM      *BLANKS       PNarr
     C                   PARM      *ZERO         PTxrt
 
      ** Database error in file SDTXBSPD
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDTXBSPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WK_PCTG = PTxrt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdFle - Update files                                      *
      *                                                               *
      *****************************************************************
     C     SRUpdFle      BEGSR
 
      ** Update POSETW4 if PREF is blank
 
     C                   IF        W4_PREF = *BLANK OR
     C                             W4_PREF = '000000'
     C                   MOVE      WPref         W4_PREF
     C                   MOVE      WPref         WK_PREF
     C                   UPDATE    POSETDF
     C                   ENDIF
 
      ** Update or add record to MGF565L0
 
     C                   EVAL      KPref = WK_PREF
     C                   EVAL      KPctg = WK_PCTG
     C                   EVAL      KMT5G = WK_MT5G                              185894
     C                   IF        WK_PEVT <> 'MT'                                            187801
     C     WKey1         CHAIN     MGF565L0                           02
     C                   ELSE                                                   187801
     C                   MOVE      '1'           *IN02                          187801
     C                   END                                                    187801
      *                                                                         187801
     C                   MOVE      @CHG          MG_MGCHG                                     CSW025
     C                   IF        *IN02 = *OFF
     C                   EVAL      MG_PNMP = MG_PNMP + WK_PNMP
     C                   UPDATE    MGF565D0
     C                   ELSE
     C                   EVAL      OutPoset = WrkPoset
     C                   WRITE     MGF565D0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key fields for MGF565L0
     C     WKey1         KLIST
     C                   KFLD                    KPref
     C                   KFLD                    KMT5G                          185894
     C                   KFLD                    KPctg
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
