     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Int Scale Details Extract - during COB')      *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG007022 - Midas CG Int Scale Details Extract - during COB   *
      *                                                               *
      *  Function:  This program extracts Interest Scale header and   *
      *             detail transactions which runs during COB         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. MD031764           Date 09Jan15               *-
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 AR797795 *CREATE   Date 17Oct11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD031764 - Correct KEY as DRDCOR must be added.              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR797795 - Interest Scale Report Enquiry is missing in       *
      *             BFMidas                                           *
      *                                                               *
      *****************************************************************
     FCGUDCRLB  IF   E           K DISK
     FCGUXMLL0  IF   E           K DISK
     FCGXDCRLB  IF   E           K DISK
     FCGXXMLL0  IF   E           K DISK
     FCGISHXL1  UF A E           K DISK
     FDEALSALL  IF   E           K DISK    PREFIX(D_)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(FXDEALP0)
     F                                     IGNORE(DLBHISD0)
     F                                     IGNORE(DLDHISD0)
     F                                     IGNORE(DLEHISD0)
     F                                     IGNORE(DLGHISD0)
      ** Loans file by loan reference
     FCLOAN     IF   E           K DISK
     F                                     PREFIX(C_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Matured Loans file
     FMLOAN     IF   E           K DISK    PREFIX(M_)
     F                                     Ignore(CLOANHHF)
     F                                     Ignore(CLOANZ1F)
     F                                     Ignore(CLOANCKF)
     F                                     Rename(CLOANCLF:MLOANCLF)
     FCGISDXPD  O    E             DISK
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Declared variables
     D S1              S              2  0
     D E1              S              2  0
     D SrchStrng       S             33
     D WFLdTag         S             33
     D WHdrTag         S             33
     D CFT004          S              1
     D @Run            S              1
 
     D PRtcd           S              7
     D POptn           S              7
     D PRetl           S             10
     D PCnum           S              6
     D PCcy            S              3
     D PAcod           S             10
     D PAcsq           S              2
     D PBrca           S              3
     D PIBAN           S             47
     D PIWith          S             47
     D PINobl          S             34
     D PSard           S              6
     D Wnum            S              6  0
 
     D KItem           S              8  0
     D KStat           S              1
     D*KLNRF****       S              6  0                                                    CLE148
     D KLNRF           S              6                                                       CLE148
     D KRCDT           S              1
     D KCORR           S             10                                                     MD031764
 
      **  BFMidas Account ID
     D                 DS
     D  WCNUM                  1      6
     D  WCCY                   7      9
     D  WACOD                 10     19  0
     D  WACSQ                 20     21  0
     D  WBRCA                 22     24
     D  WMAcctID               1     24
     D                 DS
     D  WRef                   1     15
     D  WNumA                  1      6
 
      **  External DS for Account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  LCDSCS       E                     EXTFLD(LCD)
 
      **  First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *****************************************************************
 
      ** Extraction for Current Data
     C                   EVAL      KStat = 'C'
     C                   EXSR      SrExtract
 
      ** Extraction for Archive Data
     C                   EVAL      KStat = 'A'
     C                   EXSR      SrExtract
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      *                                                               *
      *  SrExtract - Extract Header and Details                       *
      *                                                               *
      *****************************************************************
     C     SrExtract     BEGSR
 
     C                   IF        KStat = 'C'
     C     *LOVAL        SETLL     CGUDCRLB
     C                   READ      CGUDCRLB
     C                   DOW       NOT %EOF(CGUDCRLB)
     C                   MOVE      DRITEM        KITEM
     C                   MOVE      DRDCOR        KCORR                                      MD031764
     C                   EXSR      SrWrtHdr
     C                   EXSR      SrWrtCurCGxml
     C                   READ      CGUDCRLB
     C                   ENDDO
 
     C                   ELSE
     C     *LOVAL        SETLL     CGXDCRLB
     C                   READ      CGXDCRLB
     C                   DOW       NOT %EOF(CGXDCRLB)
     C                   MOVE      DRITEM        KITEM
     C                   MOVE      DRDCOR        KCORR                                      MD031764
     C                   EXSR      SrWrtHdr
     C                   EXSR      SrWrtArcCGxml
     C                   READ      CGXDCRLB
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrWrtHdr - Write to Interest Scale Header File               *
      *                                                               *
      *****************************************************************
     C     SrWrtHdr      BEGSR
 
     C*****KITEM         CHAIN     CGISHXD0                           90                    MD031764
     C     KKEY          CHAIN     CGISHXD0                           90                    MD031764
     C                   IF        *IN90 = *ON
     C                   EVAL      WMAcctID = DRMACT
     C                   EVAL      HXCNUM = WCNUM
     C                   MOVE      WACOD         HXACOD
     C                   EVAL      HXPDAT = DRARDT
     C                   EVAL      HXITEM = DRITEM
     C                   EVAL      HXBRCA = DRBRCA
     C                   EVAL      HXIBAN = *BLANKS
     C                   EVAL      HXMODI = DRMODI
     C                   EVAL      HXCORR = DRDCOR                                          MD031764
     C                   SELECT
     C                   WHEN      DRMODI = 'RE'
     C                   EVAL      HXDLTP = ' '
     C                   EVAL      HXDLST = ' '
     C**********         EVAL      HXDLNO = 0                                                 CLE148
     C                   EVAL      HXDLNO = *BLANKS                                           CLE148
 
     C                   WHEN      DRMODI = 'DL'
     C                   EVAL      WRef = DRMTRN
     C                   TESTN                   WNumA                9394
     C     *IN93         IFEQ      '0'
     C     *IN94         ANDEQ     '0'
     C                   MOVE      WNumA         WNum
     C     WNum          CHAIN     DEALSALL                           92
     C                   IF        *IN92 = *OFF
     C                   EVAL      HXDLTP = D_DTYP
     C                   EVAL      HXDLST = D_DLST
     C**********         EVAL      HXDLNO = WNum                                              CLE148
     C                   EVAL      HXDLNO = WNumA                                             CLE148
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      DRMODI = 'LE'
     C                   EVAL      WRef = DRMTRN
     C**********         TESTN                   WNumA                9394                    CLE148
     C******IN93         IFEQ      '0'                                                        CLE148
     C******IN94         ANDEQ     '0'                                                        CLE148
     C**********         MOVE      WNumA         WNum                                         CLE148
     C**********         MOVE      WNum          KLNRF                                        CLE148
     C                   MOVE      WNumA         KLNRF                                        CLE148
     C                   MOVE      'A'           KRCDT
     C     LoanKy        CHAIN     CLOAN                              91
     C                   IF        *IN91 = *OFF
     C                   EVAL      HXDLTP = C_LTYP
     C                   EVAL      HXDLST = C_SUTP
     C**********         EVAL      HXDLNO = WNum                                              CLE148
     C                   EVAL      HXDLNO = WNumA                                             CLE148
     C                   ELSE
     C     LoanKy        CHAIN     MLOAN                              91
     C                   IF        *IN91 = *OFF
     C                   EVAL      HXDLTP = M_LTYP
     C                   EVAL      HXDLST = M_SUTP
     C**********         EVAL      HXDLNO = WNum                                              CLE148
     C                   EVAL      HXDLNO = WNumA                                             CLE148
     C                   ENDIF
     C                   ENDIF
     C**********         ENDIF                                                                CLE148
     C                   ENDSL
 
     C                   IF        CFT004 = 'Y'
     C                   EXSR      SrRetrIBAN
     C                   ENDIF
     C                   EVAL      HXSTAT = KStat
     C                   WRITE     CGISHXD0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrRetrIBAN - Retrieve IBAN Number when feature CFT004 is On  *
      *                                                               *
      *****************************************************************
     C     SrRetrIBAN    BEGSR
 
     C                   MOVEL     WCNUM         PCNUM
     C                   MOVEL     WCCY          PCCY
     C                   MOVEL     WACOD         PACOD
     C                   MOVEL     WACSQ         PACSQ
     C                   MOVEL     WBRCA         PBRCA
 
      **  Access account details
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      *BLANKS       PRetl
     C                   PARM                    PCnum
     C                   PARM                    PCcy
     C                   PARM                    PAcod
     C                   PARM                    PAcsq
     C                   PARM                    PBrca
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C                   IF        PRtcd = *BLANKS And IBAN <> *BLANKS
     C                   MOVE      *BLANKS       PIWITH
     C                   CALL      'AOIBANR3'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      IBAN          PIBAN
     C                   PARM                    PIWith
     C                   PARM      *BLANKS       PINobl
 
     C                   MOVEL     PIWITH        HXIBAN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrWrtCurCGxml - Write details from current Interest Scale    *
      *                  CGXML records                                *
      *                                                               *
      *****************************************************************
     C     SrWrtCurCGxml BEGSR
 
     C     KItem         SETLL     CGUXMLL0
     C     KItem         READE     CGUXMLL0
     C                   DOW       NOT %EOF(CGUXMLL0)
 
     C                   EVAL      DXITEM = XMITEM
     C                   MOVEL     XMTAGN        SrchStrng
     C     '</'          SCAN      SrchStrng:1
     C                   IF        %FOUND
     C                   GOTO      SKIP
     C                   ENDIF
 
     C     '<'           SCAN      SrchStrng     S1
     C     '>'           SCAN      SrchStrng     E1
     C                   EVAL      WFldTag = %SUBST(SrchStrng:S1+1:E1-S1-1)
     C                   IF        WFldTag = 'InterestScale'
     C                   GOTO      SKIP
     C                   ENDIF
 
     C                   IF        XMENDT = *BLANKS
     C                   EVAL      WHdrTag = WFldTag
     C                   ENDIF
     C                   EVAL      DXTAGH = WHdrTag
     C                   EVAL      DXTAGN = WFldTag
     C                   EVAL      DXTAGV = XMTAGV
     C                   WRITE     CGISDXD0
     C     SKIP          TAG
 
     C     KItem         READE     CGUXMLL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrWrtArcCGxml - Write details from archive Interest Scale    *
      *                   CGXML records                               *
      *                                                               *
      *****************************************************************
     C     SrWrtArcCGxml BEGSR
 
     C     KItem         SETLL     CGXXMLL0
     C     KItem         READE     CGXXMLL0
 
     C                   DOW       NOT %EOF(CGXXMLL0)
 
     C                   EVAL      DXITEM = XMITEM
     C                   MOVEL     XMTAGN        SrchStrng
     C     '</'          SCAN      SrchStrng:1
     C                   IF        %FOUND
     C                   GOTO      SKIP2
     C                   ENDIF
 
     C     '<'           SCAN      SrchStrng     S1
     C     '>'           SCAN      SrchStrng     E1
     C                   EVAL      WFldTag = %SUBST(SrchStrng:S1+1:E1-S1-1)
     C                   IF        WFldTag = 'InterestScale'
     C                   GOTO      SKIP2
     C                   ENDIF
 
     C                   IF        XMENDT = *BLANKS
     C                   EVAL      WHdrTag = WFldTag
     C                   ENDIF
     C                   EVAL      DXTAGH = WHdrTag
     C                   EVAL      DXTAGN = WFldTag
     C                   EVAL      DXTAGV = XMTAGV
     C                   WRITE     CGISDXD0
     C     SKIP2         TAG
 
     C     KItem         READE     CGXXMLL0
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     LoanKy        KLIST
     C                   KFLD                    KLNRF
     C                   KFLD                    KRCDT
      ** Access Switchable Feature file and check if CFT004 is
      ** installed (IBAN-Number)
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     PRtcd         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT004
     C                   ELSE
     C                   MOVE      'N'           CFT004
     C                   ENDIF
 
     C     KKEY          KLIST                                                              MD031764
     C                   KFLD                    KITEM                                      MD031764
     C                   KFLD                    KCORR                                      MD031764
                                                                                            MD031764
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   IF        @Run = *BLANK
     C                   EVAL      @Run = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
