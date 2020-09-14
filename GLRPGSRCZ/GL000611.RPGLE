     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Customer Activities Collection')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  GL000611 - GL Customer Activities Collection                 *
      *                                                               *
      *  Note: Account keys format are based on the account key       *
      *        manual for each module                                 *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CGL185             Date 13Mar17               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD043943           Date 03Feb17               *
      *                 MD043793           Date 30Jan17               *
      *                 MD043652           Date 18Jan17               *
      *                 MD042828           Date 15Dec16               *
      *                 MD042871           Date 14Dec16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  CGL185 - FATCA XML 2.0                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD043943 - Forward foreign exchange deals that are matured   *
      *             before FATCA EOY shouldn't be captured            *
      *  MD043793 - Exclude traded FRA transactions                   *
      *  MD043652 - Joint Account Column details for cust that are not*
      *             Joint Accounts are not populated                  *
      *  MD042828 - Daily Accounts Closed/Transferred File cannot     *
      *             capture other FATCA Accounts                      *
      *  MD042871 - FF000000 entries in Daily Customer Activities     *
      *             Collection are generated                          *
      *  CGL154 - FATCA Reporting.                                    *
      *                                                               *
      *****************************************************************

      ** Midas LE Loan Events 1
     FLKEY1DP   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1_)

      ** Midas LE Loan Events 3
     FLKEY3DP   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LKEY1DPF:LKEY3DPF)
     F                                     PREFIX(L2_)

      ** Midas SE Securities Events
     FSEKEYD    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)

      ** Midas DL Deal Events
     FDKEYSDP   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D_)

      ** Midas FF Generated account keys
     FFOKEYD    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)

      ** Midas GL Customer Activities and Payment Amounts - Delete
     FGLCAPAL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCAPAD0:GLCAPAD1)
     F                                     PREFIX(C_)

      ** Midas GL Customer Activities and Payment Amounts - Delete
     FGLCAPAL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCAPAD0:GLCAPAD2)
     F                                     PREFIX(B_)

      ** Midas DL Deals File
     FDLDLBBL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(W_)
     FSDJACCL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas DL Deals
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:DEALSDBF1)
     F                                     PREFIX(E_)

      ** Midas LE Loans
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)

      ** Midas GL Customer Activities and Payment Amounts
     FGLCAPAPD  O    E             DISK    INFSR(*PSSR)
                                                                                            MD042828
      ** Midas GL GL FATCA Closed Accounts Balances Detail                                  MD042828
     FGLFCABPD  O    E             DISK    INFSR(*PSSR)                                     MD042828
     F                                     PREFIX(CA)                                       MD042828

      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)

      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)

      ** Externally described DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D SNACCD        E                     EXTFLD(QQACCD)

      ** Externally described DS for Loan type/subtype
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)

      ** Externally described DS for customer details
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)
                                                                                            MD043793
      ** Midas Book Codes File                                                              MD043793
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                MD043793

      ** First DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** First DS for access programs, long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Parameters for access object programs
     D Prtcd           S              7A
     D Poptn           S              7A
     D PKey            S              6A
     D Pretl           S             10A
     D Pcnum           S              6A
     D Pcucd           S              3A
     D Paccd           S             10A
     D Pacsq           S              2A
     D Pbrca           S              3A
     D Pcycd           S              3A
     D Pnonb           S              2A
     D Pcssn           S             10A
     D Ppnoi           S              1A
     D Pmodule         S              2A
     D PKySt           S              7
     D PCust           S             10A
     D PLNCL           S              4A

      ** Other fields used
     D Wrevi           S              1S 0
     D Wrun            S              1A
     D Wetyp           S              2A
     D Wtrpt           S              6A
     D Wcccn           S              6A
     D Wdlno           S              6A
     D Wlnrf           S              6A
     D Wtrfr           S              6A
     D Wcbcd           S              6A
     D Wcurr           S              3A
     D Wevent          S              7A
     D Kinst           S              5A
     D Kpcusd          S              6A
     D Kpacno          S             26A
     D Kpccy           S              3A
     D Kppsta          S             15S 0
     D Wcust           S              6A
     D Wbrch           S              3A
     D Wlnpt           S              2A
     D Wdlst           S              2A
     D Wdstp           S              2A
     D Wdtyp           S              6A
     D Wdtyp2          S              2A
     D Wsacc           S             18A
     D Wstyp           S              2S 0
     D ZDAYNO          S              5  0
     D ZNRDYS          S              2  0
     D ZDYNBR          S              5  0
     D ZCCY            S              3
     D ZLOC            S              3
     D WPROC           S              1
     D KLoan           S              6
     D KRcdt           S              1
     D Wtrade          S              1
     D PPFTC           S              2                                                     MD043793
     D Wcusn           S              6A                                                      CGL185

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************

     C                   IF        Pmodule = 'DL'
     C                   EXSR      SrDeals
     C                   ENDIF

     C                   IF        Pmodule = 'FF'
     C                   EXSR      SrFutOpt
     C                   ENDIF

     C                   IF        Pmodule = 'LE'
     C                   EXSR      SrLoans
     C                   ENDIF

     C                   IF        Pmodule = 'L2'
     C                   EXSR      SrLoan2
     C                   ENDIF

     C                   IF        Pmodule = 'SE'
     C                   EXSR      SrSecurities
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFutOpt - Subroutine to process Futures and Options          *
      *            generated account keys                             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrUpdate, SrExtCust                                    *
      *                                                               *
      *****************************************************************

     C     SrFutOpt      BEGSR

     C                   READ      FOKEYD

      ** Read until a record is not found

     C                   DOW       NOT %EOF(FOKEYD)

      ** Future and Options
      ** F_Xbbmmiii_C_L (Exercise loss, profit payable to customer, Trade sale)
      ***F_XbbmmiiiS__P*(Exercise*profit*for*customer,*trade*purchase)*                     MD042828
      ** F_Xbb_ _ _ _ _ _C_L ()Exercise loss, payable to customer OTC trade sale)

     C                   IF        F_EDAT <= BJRDNB
     C                             AND F_RECI = 'D'
     C                   IF        %SUBST(F_FFKY:1:3) = 'F X'
     C                   IF        %SUBST(F_FFKY:11:4) = ' C L'
     C**********                   OR %SUBST(F_FFKY:11:4) = 'S  P'                          MD042828
     C                   MOVE      F_TNBR        Wdlno
     C                   MOVE      F_SETP        Wstyp
     C                   MOVE      F_SETA        Wsacc
     C                   EVAL      Wcurr = F_CCY
     C                   MOVE      F_CBCD        Wcust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = F_BRCA

     C                   EVAL      CPACNO = 'FF' + Wdlno
     C                   EVAL      CPCCY = F_CCY
     C                   EVAL      CPPSTA = F_EAMT
     C                   EVAL      CPVDAT = F_EDAT

     C**********         EVAL      CPTYPE = 'FXOPT'                                         MD042828
     C                   EVAL      CPTYPE = 'OPEXC'                                         MD042828
     C                   EVAL      CPPAYT = 'G'
     C                   EVAL      Wrevi = F_REVI
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Future and Options

      ** F-R--mmiii-C-P (Realised profit for customer)
      ** F-Pbb-----SC-D (Premium full amount, trade sale/trade type 4 (no broker involved))
      ** F-Pbb-----SC-F (Premium full amount due at end, trade sale/trade type 6)
      ** F-Pbb-----SC-E
      ** F-Pbb-----SC-G
      ** F-Pbb-----S--C (Premium receivable by customer, trade sale, trade type 8, premium upfront
      **                only)
      ** F_PbbmmiiiS__S (full premium amount receivable by customer, trade type 8)

     C                   IF        F_EDAT <= BJRDNB
     C                             AND F_RECI = 'D'

     C                   IF        %SUBST(F_FFKY:1:1) = 'F'
     C                             AND %SUBST(F_FFKY:3:3) = 'R  '
     C                             AND %SUBST(F_FFKY:11:4) = ' C P'
     C                             OR %SUBST(F_FFKY:1:1) = 'F'
     C                             AND %SUBST(F_FFKY:3:1) = 'R'
     C                             AND %SUBST(F_FFKY:14:1) = 'P'
     C                             OR %SUBST(F_FFKY:1:1) = 'F'
     C                             AND %SUBST(F_FFKY:3:3) = 'R  '
     C                             AND %SUBST(F_FFKY:11:4) = ' C L'
     C                             OR  %SUBST(F_FFKY:1:1)  = 'F'
     C                             AND %SUBST(F_FFKY:3:1)  = 'P'
     C                             AND %SUBST(F_FFKY:11:3) = 'SC '
     C                             AND (%SUBST(F_FFKY:14:1) = 'D'
     C                             OR %SUBST(F_FFKY:14:1) = 'E'
     C                             OR %SUBST(F_FFKY:14:1) = 'G'
     C                             OR %SUBST(F_FFKY:14:1) = 'F')

     C                             OR  %SUBST(F_FFKY:1:1)  = 'F'
     C                             AND %SUBST(F_FFKY:3:1)  = 'P'
     C                             AND %SUBST(F_FFKY:11:3) = 'S  '
     C                             AND %SUBST(F_FFKY:14:1) = 'C'
     C                             OR  %SUBST(F_FFKY:1:1)  = 'F'
     C                             AND %SUBST(F_FFKY:3:1)  = 'P'
     C                             AND %SUBST(F_FFKY:11:3) = 'S  '
     C                             AND %SUBST(F_FFKY:14:1) = 'S'
     C                   MOVE      F_TNBR        Wdlno
     C                   IF        %SUBST(F_FFKY:1:3) = 'F R'
     C                             AND %SUBST(F_FFKY:14:1) = 'P'
     C                   MOVE      F_CLON        Wdlno
     C                   ENDIF
     C                   MOVE      F_SETP        Wstyp
     C                   MOVE      F_SETA        Wsacc
     C                   EVAL      Wcurr = F_CCY
     C                   MOVE      F_CBCD        Wcust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = F_BRCA

     C                   EVAL      CPACNO = 'FF' + Wdlno
     C                   EVAL      CPCCY = F_CCY
     C                   EVAL      CPPSTA = F_EAMT
     C                   EVAL      CPVDAT = F_EDAT

     C                   IF        %SUBST(F_FFKY:1:1) = 'F'
     C                             AND %SUBST(F_FFKY:3:3) = 'R  '
     C                             AND %SUBST(F_FFKY:11:4) = ' C P'
     C                   EVAL      CPTYPE = 'FUTIN'
     C                   ELSE
     C                   EVAL      CPTYPE = 'OPPRE'
     C                   ENDIF
     C                   EVAL      CPPAYT = 'O'
     C                   EVAL      Wrevi = F_REVI
     C                   IF        Wdlno <> '000000'                                        MD042871
     C                   EXSR      SrUpdate
     C                   ENDIF                                                              MD042871
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   READ      FOKEYD

     C                   ENDDO

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDeals - Subroutine to process Dealing generated             *
      *           account keys                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrUpdate, SrExtCust                                    *
      *                                                               *
      *****************************************************************

     C     SrDeals       BEGSR

     C                   READ      DKEYSDP

      ** Read until a record is not found

     C                   DOW       NOT %EOF(DKEYSDP)

      ** xxIyybbbbI (Interim Interest Due)
      ** xxVyybbbbI (up front interest amount at value date)
      ** xxMyybbbbi (interest due at maturity)
      ** where xx is CD, CI, IT, TD, DT, FT, LT

     C                   IF        D_EDAT <= BJRDNB
     C                             AND D_RECI = 'D'
     C                   IF        %SUBST(D_AKEY:1:2) = 'CD'
     C                             OR %SUBST(D_AKEY:1:2) = 'CI'
     C                             OR %SUBST(D_AKEY:1:2) = 'IT'
     C                             OR %SUBST(D_AKEY:1:2) = 'TD'
     C                             OR %SUBST(D_AKEY:1:2) = 'DT'
     C                             OR %SUBST(D_AKEY:1:2) = 'FT'
     C                             OR %SUBST(D_AKEY:1:2) = 'LT'
     C                   IF        %SUBST(D_AKEY:3:1) = 'I'
     C                             and %SUBST(D_AKEY:10:1) = 'I'
     C                             or  %SUBST(D_AKEY:3:1)  = 'V'
     C                             and %SUBST(D_AKEY:10:1) = 'I'
     C                             or  %SUBST(D_AKEY:3:1)  = 'M'
     C                             and %SUBST(D_AKEY:10:1) = 'I'
     C                   EVAL      Wdtyp = %SUBST(D_AKEY:1:2)
     C                   EVAL      Wdlst = %SUBST(D_AKEY:4:2)
     C                   MOVE      D_DLNO        Wdlno
     C                   MOVE      D_SETP        Wstyp
     C                   MOVE      D_OSAC        Wsacc
     C                   EVAL      Wcurr = D_ECCY
     C                   EVAL      Wrevi = D_REVI

     C                   EXSR      SrDealCust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                             OR Wrevi = 1
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = D_BRCA

     C                   EVAL      CPACNO = 'DL' + Wdlno
     C                   EVAL      CPCCY = D_ECCY
     C                   EVAL      CPPSTA = D_EAMT
     C                   EVAL      CPVDAT = D_EDAT

     C                   EVAL      CPTYPE = 'DLINT'
     C                   EVAL      CPPAYT = 'I'
     C                   EVAL      Wrevi = D_REVI
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Deal types FR, RF, RP, RR

      ** FRVyybbbUL
      ** RFIyybbbPI
      ** RPIyybbbPI
      ** RRIyybbbPI

     C                   IF        D_EDAT <= BJRDNB
     C                             AND D_RECI = 'D'
     C                   IF        %SUBST(D_AKEY:1:2) = 'FR'
     C                             OR %SUBST(D_AKEY:1:2) = 'RF'
     C                             OR %SUBST(D_AKEY:1:2) = 'RP'
     C                             OR %SUBST(D_AKEY:1:2) = 'RR'
     C                   IF        (%SUBST(D_AKEY:3:1) = 'V'
     C                             OR %SUBST(D_AKEY:3:1) = 'I')
     C                             AND %SUBST(D_AKEY:9:2) = 'PI'

     C                   EVAL      Wdtyp = %SUBST(D_AKEY:1:2)
     C                   EVAL      Wdlst = %SUBST(D_AKEY:4:2)
     C                   MOVE      D_DLNO        Wdlno
     C                   MOVE      D_SETP        Wstyp
     C                   MOVE      D_OSAC        Wsacc
     C                   EVAL      Wcurr = D_ECCY
     C                   EVAL      Wrevi = D_REVI

     C                   EXSR      SrDealCust
     C                   EXSR      SrExtCust
                                                                                            MD043793
     C                   IF        %SUBST(D_AKEY:1:2) = 'FR'                                MD043793
                                                                                            MD043793
     C                   CALL      'AOBOOKR0'                                               MD043793
     C                   PARM      *BLANKS       PRTCD                                      MD043793
     C                   PARM      '*KEY    '    POPTN                                      MD043793
     C                   PARM      E_BOKC        PPFTC                                      MD043793
     C     SDBOOK        PARM      SDBOOK        DSFDY                                      MD043793
     C                                                                                      MD043793
     C                   IF        BDHGIN = 'N'                                             MD043793
     C                   EVAL      Wcust = *BLANKS                                          MD043793
     C                   ENDIF                                                              MD043793
     C                   ENDIF                                                              MD043793
                                                                                            MD043793
     C                   IF        Wcust <> *BLANKS
     C                             OR Wrevi = 1
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = D_BRCA

     C                   EVAL      CPACNO = 'DL' + Wdlno
     C                   EVAL      CPCCY = D_ECCY
     C                   EVAL      CPPSTA = D_EAMT
     C                   EVAL      CPVDAT = D_EDAT

     C                   EVAL      CPTYPE = 'FRAIN'
     C                   EVAL      CPPAYT = 'O'
     C                   EVAL      Wrevi = D_REVI
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ***xxDyybbbBC*(Sale*amount*-*Base*ccy)***************************                     MD042828
      ***xxDyybbbFC*(Sale*amount*-*Foreign*ccy)************************                     MD042828
      ***where*xx*is*deal*types*CX,*FP,*FS,*OP,*OT,*PI,*PS,*SI,*SW*****                     MD042828
      ***xxVyybbbBC*(Sale*amount*-*Base*ccy)***************************            MD042828 MD043943
      ***xxVyybbbFC*(Sale*amount*-*Foreign*ccy)************************            MD042828 MD043943
      ***where*xx*is*deal*types*CX,*FP,*FS,*OP,*OT,*PI,*SI,*SW*********            MD042828 MD043943
      *****************************************************************                     MD043943
     C**********         IF        D_EDAT <= BJRDNB                                         MD043943
     C**********                   AND D_RECI = 'D'                                         MD043943
     C**********         IF        %SUBST(D_AKEY:1:2) = 'CX'                                MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'FP'                             MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'FS'                             MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'OP'                             MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'OT'                             MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'PI'                             MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'PS'                    MD042828 MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'SI'                             MD043943
     C**********                   OR %SUBST(D_AKEY:1:2) = 'SW'                             MD043943
     C**********         IF        %SUBST(D_AKEY:3:1) = 'D'                                 MD042828
     C**********         IF        %SUBST(D_AKEY:3:1) = 'V'                        MD042828 MD043943
     C**********                   AND %SUBST(D_AKEY:9:2) = 'BC'                            MD043943
     C**********                   OR %SUBST(D_AKEY:3:1) = 'D'                              MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'V'                     MD042828 MD043943
     C**********                   AND %SUBST(D_AKEY:9:2) = 'FC'                            MD043943
     C**********         EVAL      Wdtyp = %SUBST(D_AKEY:1:2)                               MD043943
     C**********         EVAL      Wdlst = %SUBST(D_AKEY:4:2)                               MD043943
     C**********         MOVE      D_DLNO        Wdlno                                      MD043943
     C**********         MOVE      D_SETP        Wstyp                                      MD043943
     C**********         MOVE      D_OSAC        Wsacc                                      MD043943
     C**********         EVAL      Wcurr = D_ECCY                                           MD043943
      *****************************************************************                     MD043943
     C**********         EVAL      WPROC = 'N'                                              MD043943
     C*****D_DLNO        CHAIN     DLDLBBL1                                                 MD043943
     C**********         IF        %FOUND(DLDLBBL1)                                         MD043943
      *****************************************************************                     MD043943
     C**********         CALLB     'ZFWDT'                                                  MD043943
     C**********         PARM      W_DDAT        ZDAYNO                                     MD043943
     C**********         PARM      3             ZNRDYS                                     MD043943
     C**********         PARM      *ZERO         ZDYNBR                                     MD043943
     C**********         PARM      W_SLCY        ZCCY                                       MD043943
     C**********         PARM      *BLANKS       ZLOC                                       MD043943
      *****************************************************************                     MD043943
     C**********         IF        W_VDAT >= ZDYNBR                                         MD043943
     C**********         EVAL      WPROC = 'Y'                                              MD043943
     C**********         ENDIF                                                              MD043943
     C**********         ENDIF                                                              MD043943
      *****************************************************************                     MD043943
     C**********         EVAL      Wrevi = D_REVI                                           MD043943
      *****************************************************************                     MD043943
     C**********         EXSR      SrDealCust                                               MD043943
     C**********         EXSR      SrExtCust                                                MD043943
     C**********         IF        Wcust <> *BLANKS                                         MD043943
     C**********                   AND WPROC = 'Y'                                          MD043943
     C**********                   OR Wrevi = 1                                             MD043943
     C**********         EVAL      CPCUSD = Wcust                                           MD042828
      *****************************************************************                     MD043943
     C**********         EVAL      CPBRCH = D_BRCA                                          MD042828
      *****************************************************************                     MD043943
     C**********         EVAL      CPACNO = 'DL' + Wdlno                                    MD042828
     C**********         EVAL      CPCCY = D_ECCY                                           MD042828
     C**********         EVAL      CPPSTA = D_EAMT                                          MD042828
     C**********         EVAL      CPVDAT = D_EDAT                                          MD042828
      *****************************************************************                     MD043943
     C**********         EVAL      CPTYPE = 'FXFWD'                                         MD042828
     C**********         EVAL      CPPAYT = 'O'                                             MD042828
     C**********         EVAL      Wrevi = D_REVI                                           MD042828
     C**********         EXSR      SrUpdate                                                 MD042828
     C**********         EVAL      CACBCNUM = Wcust                                MD042828 MD043943
     C**********         EVAL      CACBCURR = D_ECCY                               MD042828 MD043943
     C**********         EVAL      CACBBRCH = D_BRCA                               MD042828 MD043943
     C**********         EVAL      CACBACOD = *ZERO                                MD042828 MD043943
     C**********         EVAL      CACBSEQ = *ZERO                                 MD042828 MD043943
     C**********         EVAL      CACBDACC = *ZERO                                MD042828 MD043943
     C**********         EVAL      CACBAMNT = D_EAMT                               MD042828 MD043943
     C**********         EVAL      CACCTYPE = 'FXFWD'                              MD042828 MD043943
     C**********         EVAL      CACCTRNN = 'DL' + Wdlno                         MD042828 MD043943
     C**********         EVAL      CACCJANO = *BLANKS                              MD042828 MD043943
     C**********         EVAL      CACCACHL = *BLANKS                              MD042828 MD043652
     C**********         EVAL      CACCACTY = *BLANKS                              MD042828 MD043652
     C**********         EVAL      CACCACHL = Wcust                                MD043652 MD043943
     C**********         EVAL      CACCACTY = 'CUST'                               MD043652 MD043943
     C**********         EVAL      CACCJATP = *BLANKS                              MD042828 MD043943
     C**********         WRITE     GLFCABD0                                        MD042828 MD043943
      *****************************************************************            MD042828 MD043943
     C**********         EVAL      JCJANO = CACBCNUM                               MD042828 MD043943
     C*****JCJANO        SETLL     SDJACCL0                                        MD042828 MD043943
     C*****JCJANO        READE     SDJACCL0                                        MD042828 MD043943
      *****************************************************************            MD042828 MD043943
     C**********         DOW       NOT %EOF(SDJACCL0)                              MD042828 MD043943
     C**********         EVAL      CACCJANO = JCJANO                               MD042828 MD043943
     C**********         EVAL      CACBCNUM = JCCUST                               MD042828 MD043943
     C**********         IF        JCCUST <> *BLANKS                               MD042828 MD043943
     C**********         EVAL      CACCACHL = JCCUST                               MD042828 MD043943
     C**********         EVAL      CACCACTY = 'CUST'                               MD042828 MD043943
     C**********         ELSE                                                      MD042828 MD043943
     C**********         EVAL      CACCACHL = JCNAHO                               MD042828 MD043943
     C**********         EVAL      CACCACTY = 'NAHO'                               MD042828 MD043943
     C**********         ENDIF                                                     MD042828 MD043943
     C**********         EVAL      CACCJATP = 'M'                                  MD042828 MD043943
     C**********         WRITE     GLFCABD0                                        MD042828 MD043943
      *****************************************************************            MD042828 MD043943
      *****************************************************************            MD042828 MD043943
     C*****JCJANO        READE     SDJACCL0                                        MD042828 MD043943
     C**********         ENDDO                                                     MD042828 MD043943
     C**********         ENDIF                                                              MD043943
     C**********         ENDIF                                                              MD043943
     C**********         ENDIF                                                              MD043943
     C**********         ENDIF                                                              MD043943

      ** Deal types RX
      ** RXVyybbbTA (Their principal amount - foreign currency at value date)
      ** RXVyybbBTA (Their principal amount - base currency at value date)
      ** RXDyybbITA (Their principal increase amount - foreign currency at principal change date )
      ** RXDyybBITA (Their principal increase amount - base currency at principal change date)
      ** RXMyybbDTA (Their principal decrease amount - foreign currrency at principal change date)
      ** RXMyybBDTA (Their principal decrease amount - base currency at principal change date)
      ** RXMyybbbTA (Their principal amount - foreign currency at maturity date)
      ** RXMyybbBTA (Their principal amount - base currency at maturity date)
      ** RXMyybbDOA (Our Principal Decrease Amount - foreign currency)
      ** RXMyybBDOA (Our Principal Decrease Amount - base currency)
      ** RXMyybbbOA (Our Principal Amount - foreign currency)
      ** RXMyybbBOA (Our Principal Amount - base currency)

     C**********         IF        D_EDAT <= BJRDNB                                         MD042828
     C**********                   AND D_RECI = 'D'                                         MD042828
     C**********         IF        %SUBST(D_AKEY:1:2) = 'RX'                                MD042828
     C**********         IF        %SUBST(D_AKEY:3:1) = 'V'                                 MD042828
     C**********                   AND %SUBST(D_AKEY:9:2) = 'TA'                            MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'V'                              MD042828
     C**********                   AND %SUBST(D_AKEY:8:3) = 'BTA'                           MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'D'                              MD042828
     C**********                   AND %SUBST(D_AKEY:8:3) = 'ITA'                           MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'D'                              MD042828
     C**********                   AND %SUBST(D_AKEY:7:4) = 'BITA'                          MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:8:3) = 'DTA'                           MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:7:4) = 'BDTA'                          MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:9:2) = 'TA'                            MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:8:3) = 'BTA'                           MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:8:3) = 'DOA'                           MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:7:4) = 'BDOA'                          MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:9:2) = 'OA'                            MD042828
     C**********                   OR %SUBST(D_AKEY:3:1) = 'M'                              MD042828
     C**********                   AND %SUBST(D_AKEY:8:3) = 'BOA'                           MD042828
     C**********         EVAL      Wdtyp = %SUBST(D_AKEY:1:2)                               MD042828
     C**********         EVAL      Wdlst = %SUBST(D_AKEY:4:2)                               MD042828
     C**********         MOVE      D_DLNO        Wdlno                                      MD042828
     C**********         MOVE      D_SETP        Wstyp                                      MD042828
     C**********         MOVE      D_OSAC        Wsacc                                      MD042828
     C**********         EVAL      Wcurr = D_ECCY                                           MD042828
     C**********         EVAL      Wrevi = D_REVI                                           MD042828
      *****************************************************************                     MD042828
     C**********         EXSR      SrDealCust                                               MD042828
     C**********         EXSR      SrExtCust                                                MD042828
     C**********         IF        Wcust <> *BLANKS                                         MD042828
     C**********                   OR Wrevi = 1                                             MD042828
     C**********         EVAL      CPCUSD = Wcust                                           MD042828
      *****************************************************************                     MD042828
     C**********         EVAL      CPBRCH = D_BRCA                                          MD042828
      *****************************************************************                     MD042828
     C**********         EVAL      CPACNO = 'DL' + Wdlno                                    MD042828
     C**********         EVAL      CPCCY = D_ECCY                                           MD042828
     C**********         EVAL      CPPSTA = D_EAMT                                          MD042828
     C**********         EVAL      CPVDAT = D_EDAT                                          MD042828
      *****************************************************************                     MD042828
     C**********         EVAL      CPTYPE = 'RXAMT'                                         MD042828
     C**********         EVAL      CPPAYT = 'O'                                             MD042828
     C**********         EVAL      Wrevi = D_REVI                                           MD042828
     C**********         EXSR      SrUpdate                                                 MD042828
     C**********         ENDIF                                                              MD042828
     C**********         ENDIF                                                              MD042828
     C**********         ENDIF                                                              MD042828
     C**********         ENDIF                                                              MD042828

      ** Deal types RS, RX
      ** xxVyybbbPB (Buy-Out Amount Payable)
      ** xxVyybbbPF (Fee/Premium Amount Payable)
      ** xxIyybbbPI (Gross total interest to pay)
      ** xxIyybbbPC (Total interest to pay when capitalisation)

     C                   IF        D_EDAT <= BJRDNB
     C                             AND D_RECI = 'D'
     C                   IF        %SUBST(D_AKEY:1:2) = 'RS'
     C                             OR %SUBST(D_AKEY:1:2) = 'RX'
     C                   IF        %SUBST(D_AKEY:3:1) = 'V'
     C                             AND %SUBST(D_AKEY:9:2) = 'PB'
     C                             OR %SUBST(D_AKEY:3:1) = 'V'
     C                             AND %SUBST(D_AKEY:9:2) = 'PF'
     C                             OR %SUBST(D_AKEY:3:1) = 'V'
     C                             AND %SUBST(D_AKEY:9:2) = 'PF'
     C                             OR %SUBST(D_AKEY:3:1) = 'I'
     C                             AND %SUBST(D_AKEY:9:2) = 'PI'
     C                             OR %SUBST(D_AKEY:3:1) = 'I'
     C                             AND %SUBST(D_AKEY:9:2) = 'PC'
     C                   EVAL      Wdtyp = %SUBST(D_AKEY:1:2)
     C                   EVAL      Wdlst = %SUBST(D_AKEY:4:2)
     C                   MOVE      D_DLNO        Wdlno
     C                   MOVE      D_SETP        Wstyp
     C                   MOVE      D_OSAC        Wsacc
     C                   EVAL      Wcurr = D_ECCY
     C                   EVAL      Wrevi = D_REVI

     C                   EXSR      SrDealCust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                             OR Wrevi = 1
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = D_BRCA

     C                   EVAL      CPACNO = 'DL' + Wdlno
     C                   EVAL      CPCCY = D_ECCY
     C                   EVAL      CPPSTA = D_EAMT
     C                   EVAL      CPVDAT = D_EDAT

     C                   IF        %SUBST(D_AKEY:9:2) = 'PI'
     C                             OR %SUBST(D_AKEY:9:2) = 'PC'
     C                   IF        %SUBST(D_AKEY:1:2) = 'RS'
     C                   EVAL      CPTYPE = 'RSINT'
     C                   ELSE
     C                   EVAL      CPTYPE = 'RXINT'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CPTYPE = 'FEES'
     C                   ENDIF
     C                   IF        %SUBST(D_AKEY:3:1) = 'I'
     C                   EVAL      CPPAYT = 'I'
     C                   ELSE
     C                   EVAL      CPPAYT = 'O'
     C                   ENDIF
     C                   EVAL      Wrevi = D_REVI
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                            MD042828
     C                   IF        D_EDAT <= BJRDNB                                         MD042828
     C                             AND D_RECI = 'D'                                         MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'CD'                                MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'CI'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'IT'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'TD'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'DT'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'FT'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'LT'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'FR'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'RF'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'RP'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'RR'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'CX'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'FP'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'FS'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'OP'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'OT'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'PI'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'PS'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'SI'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'SW'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'RS'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'RX'                             MD042828
     C                   IF        (%SUBST(D_AKEY:3:1) = 'M'                                MD042828
     C                             AND %SUBST(D_AKEY:10:1) = 'A'                            MD042828
     C                             AND %SUBST(D_AKEY:1:2) <> 'RX')                          MD042828
     C                             OR (%SUBST(D_AKEY:1:2) = 'RX')                           MD042828
     C                             AND %SUBST(D_AKEY:3:1) = 'M'                             MD042828
     C                             AND %SUBST(D_AKEY:6:2) = '  '                            MD042828
     C                             AND %SUBST(D_AKEY:9:2) = 'TA'                            MD042828
     C                   EVAL      Wdtyp = %SUBST(D_AKEY:1:2)                               MD042828
     C                   EVAL      Wdlst = %SUBST(D_AKEY:4:2)                               MD042828
     C                   MOVE      D_DLNO        Wdlno                                      MD042828
     C                   MOVE      D_SETP        Wstyp                                      MD042828
     C                   MOVE      D_OSAC        Wsacc                                      MD042828
     C                   EVAL      Wcurr = D_ECCY                                           MD042828
     C                   EVAL      Wrevi = D_REVI                                           MD042828
                                                                                            MD042828
     C                   EXSR      SrDealCust                                               MD042828
     C                   EXSR      SrExtCust                                                MD042828
                                                                                            MD042828
     C                   IF        Wcust <> *BLANKS                                         MD042828
     C                             OR Wrevi = 1                                             MD042828
     C                   MOVE      Wcust         CACBCNUM                                     CGL185
     C                   EVAL      CACBCNUM = Wcust                                         MD042828
     C                   EVAL      CACBCURR = D_ECCY                                        MD042828
     C                   EVAL      CACBBRCH = D_BRCA                                        MD042828
     C                   EVAL      CACBACOD = *ZERO                                         MD042828
     C                   EVAL      CACBSEQ = *ZERO                                          MD042828
     C                   EVAL      CACBDACC = *ZERO                                         MD042828
     C                   EVAL      CACBAMNT = D_EAMT                                        MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'TD'                                MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'IT'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'CD'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'CI'                             MD042828
     C                   EVAL      CACCTYPE = 'MMMAT'                                       MD042828
     C                   ENDIF                                                              MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'FT'                                MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'DT'                             MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'LT'                             MD042828
     C                   EVAL      CACCTYPE = 'FDMAT'                                       MD042828
     C                   ENDIF                                                              MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'FR'                                MD042828
     C                   EVAL      CACCTYPE = 'FRMAT'                                       MD042828
     C                   ENDIF                                                              MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'RR'                                MD042828
     C                             OR %SUBST(D_AKEY:1:2) = 'RP'                             MD042828
     C                   EVAL      CACCTYPE = 'RPMAT'                                       MD042828
     C                   ENDIF                                                              MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'RF'                                MD042828
     C                   EVAL      CACCTYPE = 'RFMAT'                                       MD042828
     C                   ENDIF                                                              MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'RS'                                MD042828
     C                   EVAL      CACCTYPE = 'RSMAT'                                       MD042828
     C                   ENDIF                                                              MD042828
     C                   IF        %SUBST(D_AKEY:1:2) = 'RX'                                MD042828
     C                   EVAL      CACCTYPE = 'RXMAT'                                       MD042828
     C                   ENDIF                                                              MD042828
     C                   EVAL      CACCTRNN = 'DL' + Wdlno                                  MD042828
     C                   EVAL      CACCJANO = *BLANKS                                       MD042828
     C**********         EVAL      CACCACHL = *BLANKS                              MD042828 MD043652
     C**********         EVAL      CACCACTY = *BLANKS                              MD042828 MD043652
     C                   EVAL      CACCACHL = Wcust                                         MD043652
     C                   EVAL      CACCACTY = 'CUST'                                        MD043652
     C                   EVAL      CACCJATP = *BLANKS                                       MD042828
     C                   IF        WCusn = Wcust                                              CGL185
     C                   EVAL      CACBAMNT = *Zero                                           CGL185
     C                   ENDIF                                                                CGL185
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
     C                   EVAL      JCJANO = CACBCNUM                                        MD042828
     C     JCJANO        SETLL     SDJACCL0                                                 MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
                                                                                            MD042828
     C                   DOW       NOT %EOF(SDJACCL0)                                       MD042828
     C                   EVAL      CACCJANO = JCJANO                                        MD042828
     C                   EVAL      CACBCNUM = JCCUST                                        MD042828
     C                   IF        JCCUST <> *BLANKS                                        MD042828
     C                   EVAL      CACCACHL = JCCUST                                        MD042828
     C                   EVAL      CACCACTY = 'CUST'                                        MD042828
     C                   ELSE                                                               MD042828
     C                   EVAL      CACCACHL = JCNAHO                                        MD042828
     C                   EVAL      CACCACTY = 'NAHO'                                        MD042828
     C                   ENDIF                                                              MD042828
     C                   EVAL      CACCJATP = 'M'                                           MD042828
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
                                                                                            MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
     C                   ENDDO                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828

     C                   READ      DKEYSDP

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoans - Subroutine to process Lending generated             *
      *           account keys                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrUpdate, SrExtCust, AOLOANR0                          *
      *                                                               *
      *****************************************************************

     C     SrLoans       BEGSR

     C                   READ      LKEY1DP

      ** Read until a record is not found

     C                   DOW       NOT %EOF(LKEY1DP)

      ** Loans
      ** xxRyybrsbI where xx and yy (loan type and sub type) has
      ** processing type 66, 69, or 72
      ** xxVyybrsbD - discount loan (processing type 67)

     C                   IF        L1_EDAT <= BJRDNB
     C                             AND L1_RECI = 'D'
     C                   IF        %SUBST(L1_AKEY:3:1) = 'R'
     C                             AND %SUBST(L1_AKEY:10:1) = 'I'
     C                             OR  %SUBST(L1_AKEY:3:1) = 'V'
     C                             AND %SUBST(L1_AKEY:10:1) = 'D'
     C                             OR %SUBST(L1_AKEY:3:1) = 'R'                             MD042828
     C                             AND %SUBST(L1_AKEY:10:1) = 'A'                           MD042828
     C                   EVAL      Wdtyp  = %SUBST(L1_AKEY:1:2)
     C                   EVAL      Wdtyp2 = %SUBST(L1_AKEY:1:2)
     C                   EVAL      Wdstp = %SUBST(L1_AKEY:4:2)

     C                   EVAL      KLoan = L1_LNNO
     C                   EVAL      KRcdt = 'A'
     C     KLoank        CHAIN     CLOAN

     C**********         IF        L_PTYP = 66                                              MD042828
     C**********                   OR L_PTYP = 67                                           MD042828
     C**********                   OR L_PTYP = 69                                           MD042828
     C**********                   OR L_PTYP = 72                                           MD042828
     C                   IF        ((L_PTYP = 66                                            MD042828
     C                             OR L_PTYP = 69                                           MD042828
     C                             OR L_PTYP = 72)                                          MD042828
     C                             AND (%SUBST(L1_AKEY:3:1) = 'R'                           MD042828
     C                             AND %SUBST(L1_AKEY:10:1) = 'I'                           MD042828
     C                             OR  %SUBST(L1_AKEY:3:1) = 'V'                            MD042828
     C                             AND %SUBST(L1_AKEY:10:1) = 'D'))                         MD042828
     C                             OR (L_PTYP = 67                                          MD042828
     C                             AND %SUBST(L1_AKEY:3:1) = 'R'                            MD042828
     C                             AND %SUBST(L1_AKEY:10:1) = 'A')                          MD042828
     C                   MOVE      L_PTYP        Wlnpt
     C                   MOVE      L1_LNNO       Wdlno
     C                   MOVE      L1_SETP       Wstyp
     C                   MOVE      L1_OSAC       Wsacc
     C                   EVAL      Wcurr = L1_ECCY
     C                   EVAL      Wrevi = L1_REVI

     C                   EXSR      SrLoanCust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                             OR Wrevi = 1
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = L1_BRCA

     C                   EVAL      CPACNO = 'LE' + Wdlno
     C                   EVAL      CPCCY = L1_ECCY
     C                   EVAL      CPPSTA = L1_EAMT
     C                   EVAL      CPVDAT = L1_EDAT

     C                   EVAL      CPTYPE = 'LEINT'
     C                   IF        L_PTYP = 67                                              MD042828
     C                   EVAL      CPTYPE = 'LEMAT'                                         MD042828
     C                   ENDIF                                                              MD042828
     C                   EVAL      CPPAYT = 'I'
     C                   EVAL      Wrevi = L1_REVI
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Loan maturity                                                                      MD042828
                                                                                            MD042828
     C                   IF        L1_EDAT <= BJRDNB                                        MD042828
     C                             AND L1_RECI = 'D'                                        MD042828
     C                   IF        %SUBST(L1_AKEY:3:1) = 'R'                                MD042828
     C                             AND %SUBST(L1_AKEY:10:1) = 'A'                           MD042828
     C                   EVAL      Wdtyp  = %SUBST(L1_AKEY:1:2)                             MD042828
     C                   EVAL      Wdtyp2 = %SUBST(L1_AKEY:1:2)                             MD042828
     C                   EVAL      Wdstp = %SUBST(L1_AKEY:4:2)                              MD042828
                                                                                            MD042828
     C                   EVAL      KLoan = L1_LNNO                                          MD042828
     C                   EVAL      KRcdt = 'A'                                              MD042828
     C     KLoank        CHAIN     CLOAN                                                    MD042828
                                                                                            MD042828
     C                   IF        L_PTYP = 66                                              MD042828
     C                             OR L_PTYP = 69                                           MD042828
     C                             OR L_PTYP = 72                                           MD042828
     C                   MOVE      L_PTYP        Wlnpt                                      MD042828
     C                   MOVE      L1_LNNO       Wdlno                                      MD042828
     C                   MOVE      L1_SETP       Wstyp                                      MD042828
     C                   MOVE      L1_OSAC       Wsacc                                      MD042828
     C                   EVAL      Wcurr = L1_ECCY                                          MD042828
     C                   EVAL      Wrevi = L1_REVI                                          MD042828
                                                                                            MD042828
     C                   EXSR      SrLoanCust                                               MD042828
     C                   EXSR      SrExtCust                                                MD042828
     C                   IF        Wcust <> *BLANKS                                         MD042828
     C                             OR Wrevi = 1                                             MD042828
     C                   EVAL      CACBCNUM = Wcust                                         MD042828
     C                   EVAL      CACBCURR = L1_ECCY                                       MD042828
     C                   EVAL      CACBBRCH = L1_BRCA                                       MD042828
     C                   EVAL      CACBACOD = *ZERO                                         MD042828
     C                   EVAL      CACBSEQ = *ZERO                                          MD042828
     C                   EVAL      CACBDACC = *ZERO                                         MD042828
     C                   EVAL      CACBAMNT = L1_EAMT                                       MD042828
     C                   EVAL      CACCTYPE = 'LEMAT'                                       MD042828
     C                   EVAL      CACCTRNN = 'LE' + Wdlno                                  MD042828
     C                   EVAL      CACCJANO = *BLANKS                                       MD042828
     C**********         EVAL      CACCACHL = *BLANKS                              MD042828 MD043652
     C**********         EVAL      CACCACTY = *BLANKS                              MD042828 MD043652
     C                   EVAL      CACCACHL = Wcust                                         MD043652
     C                   EVAL      CACCACTY = 'CUST'                                        MD043652
     C                   EVAL      CACCJATP = *BLANKS                                       MD042828
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
     C                   EVAL      JCJANO = CACBCNUM                                        MD042828
     C     JCJANO        SETLL     SDJACCL0                                                 MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
                                                                                            MD042828
     C                   DOW       NOT %EOF(SDJACCL0)                                       MD042828
     C                   EVAL      CACCJANO = JCJANO                                        MD042828
     C                   EVAL      CACBCNUM = JCCUST                                        MD042828
     C                   IF        JCCUST <> *BLANKS                                        MD042828
     C                   EVAL      CACCACHL = JCCUST                                        MD042828
     C                   EVAL      CACCACTY = 'CUST'                                        MD042828
     C                   ELSE                                                               MD042828
     C                   EVAL      CACCACHL = JCNAHO                                        MD042828
     C                   EVAL      CACCACTY = 'NAHO'                                        MD042828
     C                   ENDIF                                                              MD042828
     C                   EVAL      CACCJATP = 'M'                                           MD042828
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
                                                                                            MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
     C                   ENDDO                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828

     C                   READ      LKEY1DP

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoan2 - Subroutine to process Lending generated             *
      *           account keys                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrUpdate, SrExtCust, AOLOANR0                          *
      *                                                               *
      *****************************************************************

     C     SrLoan2       BEGSR

      ** Loan events 3

     C                   READ      LKEY3DP

      ** Read until a record is not found

     C                   DOW       NOT %EOF(LKEY3DP)

      ** Loans
      ** xxRyybrsbI where xx and yy (loan type and sub type) has
      ** processing type 66, 67, 69, or 72

     C                   IF        L2_EDAT <= BJRDNB
     C                             AND L2_RECI = 'D'
     C                             AND %SUBST(L2_AKEY:3:1) = 'R'
     C                             AND %SUBST(L2_AKEY:10:1) = 'I'
     C                             OR %SUBST(L2_AKEY:3:1) = 'R'                             MD042828
     C                             AND %SUBST(L2_AKEY:10:1) = 'A'                           MD042828
     C                   EVAL      Wdtyp = %SUBST(L2_AKEY:1:2)
     C                   EVAL      Wdstp = %SUBST(L2_AKEY:4:2)

     C                   EVAL      KLoan = L2_LNNO
     C                   EVAL      KRcdt = 'A'
     C     KLoank        CHAIN     CLOAN

     C**********         IF        L_PTYP = 66                                              MD042828
     C**********                   OR L_PTYP = 67                                           MD042828
     C**********                   OR L_PTYP = 69                                           MD042828
     C**********                   OR L_PTYP = 72                                           MD042828
     C                   IF        ((L_PTYP = 66                                            MD042828
     C                             OR L_PTYP = 69                                           MD042828
     C                             OR L_PTYP = 72)                                          MD042828
     C                             AND %SUBST(L2_AKEY:10:1) = 'I')                          MD042828
     C                             OR (L_PTYP = 67                                          MD042828
     C                             AND %SUBST(L2_AKEY:10:1) = 'A')                          MD042828

     C                   MOVE      L_PTYP        Wlnpt
     C                   MOVE      L2_LNNO       Wdlno
     C                   MOVE      L2_SETP       Wstyp
     C                   MOVE      L2_OSAC       Wsacc
     C                   EVAL      Wcurr = L2_ECCY
     C                   EVAL      Wrevi = L2_REVI

     C                   EXSR      SrLoanCust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                             OR Wrevi = 1
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = L2_BRCA

     C                   EVAL      CPACNO = 'LE' + Wdlno
     C                   EVAL      CPCCY = L2_ECCY
     C                   EVAL      CPPSTA = L2_EAMT
     C                   EVAL      CPVDAT = L2_EDAT

     C                   EVAL      CPTYPE = 'LEINT'
     C                   IF        L_PTYP = 67                                              MD042828
     C                   EVAL      CPTYPE = 'LEMAT'                                         MD042828
     C                   ENDIF                                                              MD042828
     C                   EVAL      CPPAYT = 'I'
     C                   EVAL      Wrevi = L2_REVI
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF


      ** Loan maturity                                                                      MD042828
                                                                                            MD042828
     C                   IF        L2_EDAT <= BJRDNB                                        MD042828
     C                             AND L2_RECI = 'D'                                        MD042828
     C                   IF        %SUBST(L2_AKEY:3:1) = 'R'                                MD042828
     C                             AND %SUBST(L2_AKEY:10:1) = 'A'                           MD042828
     C                   EVAL      Wdtyp  = %SUBST(L2_AKEY:1:2)                             MD042828
     C                   EVAL      Wdtyp2 = %SUBST(L2_AKEY:1:2)                             MD042828
     C                   EVAL      Wdstp = %SUBST(L2_AKEY:4:2)                              MD042828
                                                                                            MD042828
     C                   EVAL      KLoan = L2_LNNO                                          MD042828
     C                   EVAL      KRcdt = 'A'                                              MD042828
     C     KLoank        CHAIN     CLOAN                                                    MD042828
                                                                                            MD042828
     C                   IF        L_PTYP = 66                                              MD042828
     C                             OR L_PTYP = 69                                           MD042828
     C                             OR L_PTYP = 72                                           MD042828
     C                   MOVE      L_PTYP        Wlnpt                                      MD042828
     C                   MOVE      L2_LNNO       Wdlno                                      MD042828
     C                   MOVE      L2_SETP       Wstyp                                      MD042828
     C                   MOVE      L2_OSAC       Wsacc                                      MD042828
     C                   EVAL      Wcurr = L2_ECCY                                          MD042828
     C                   EVAL      Wrevi = L2_REVI                                          MD042828
                                                                                            MD042828
     C                   EXSR      SrLoanCust                                               MD042828
     C                   EXSR      SrExtCust                                                MD042828
     C                   IF        Wcust <> *BLANKS                                         MD042828
     C                             OR Wrevi = 1                                             MD042828
     C                   EVAL      CACBCNUM = Wcust                                         MD042828
     C                   EVAL      CACBCURR = L2_ECCY                                       MD042828
     C                   EVAL      CACBBRCH = L2_BRCA                                       MD042828
     C                   EVAL      CACBACOD = *ZERO                                         MD042828
     C                   EVAL      CACBSEQ = *ZERO                                          MD042828
     C                   EVAL      CACBDACC = *ZERO                                         MD042828
     C                   EVAL      CACBAMNT = L2_EAMT                                       MD042828
     C                   EVAL      CACCTYPE = 'LEMAT'                                       MD042828
     C                   EVAL      CACCTRNN = 'LE' + Wdlno                                  MD042828
     C                   EVAL      CACCJANO = *BLANKS                                       MD042828
     C**********         EVAL      CACCACHL = *BLANKS                              MD042828 MD043652
     C**********         EVAL      CACCACTY = *BLANKS                              MD042828 MD043652
     C                   EVAL      CACCACHL = Wcust                                         MD043652
     C                   EVAL      CACCACTY = 'CUST'                                        MD043652
     C                   EVAL      CACCJATP = *BLANKS                                       MD042828
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
     C                   EVAL      JCJANO = CACBCNUM                                        MD042828
     C     JCJANO        SETLL     SDJACCL0                                                 MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
                                                                                            MD042828
     C                   DOW       NOT %EOF(SDJACCL0)                                       MD042828
     C                   EVAL      CACCJANO = JCJANO                                        MD042828
     C                   EVAL      CACBCNUM = JCCUST                                        MD042828
     C                   IF        JCCUST <> *BLANKS                                        MD042828
     C                   EVAL      CACCACHL = JCCUST                                        MD042828
     C                   EVAL      CACCACTY = 'CUST'                                        MD042828
     C                   ELSE                                                               MD042828
     C                   EVAL      CACCACHL = JCNAHO                                        MD042828
     C                   EVAL      CACCACTY = 'NAHO'                                        MD042828
     C                   ENDIF                                                              MD042828
     C                   EVAL      CACCJATP = 'M'                                           MD042828
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
                                                                                            MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
     C                   ENDDO                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
                                                                                            MD042828
     C                   READ      LKEY3DP

     C                   ENDDO

     C                   ENDSR


      *****************************************************************
      *                                                               *
      * SrSecurities - Subroutine to process Securities generated     *
      *                account keys                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrUpdate, SrExtCust                                    *
      *                                                               *
      *****************************************************************

     C     SrSecurities  BEGSR

     C                   READ      SEKEYD

      ** Read until a record is not found

     C                   DOW       NOT %EOF(SEKEYD)

      ** Dividend and coupon
      ** iiiS-D--yy--mvn---DI or iiiS-S--yy--mvn---DI

     C                   IF        S_EVDT <= BJRDNB
     C                             AND S_RECI = 'D'
     C                   IF        %SUBST(S_ACKY:4:2) = 'S '
     C                             AND %SUBST(S_ACKY:7:2) = '  '
     C                             AND %SUBST(S_ACKY:11:2) = '  '
     C                             AND %SUBST(S_ACKY:16:5) = '   DI'
     C                   IF        %SUBST(S_ACKY:6:1) = 'D'
     C                             OR %SUBST(S_ACKY:6:1) = 'S'
     C                   MOVE      S_STLT        Wstyp
     C                   MOVE      S_STLA        Wsacc
     C                   EVAL      Wcurr = S_EVCY
     C                   MOVE      S_CSTN        Wcust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = S_BRHA
     C                   MOVE      S_TRFR        Wtrfr
     C**********         IF        WTRFR = '000000'                                         MD043943
     C                   EVAL      CPACNO = Wcust + S_SESH
     C**********         ELSE                                                               MD043943
     C**********         EVAL      CPACNO = Wcust + S_SESH + WTRFR                          MD043943
     C**********         ENDIF                                                              MD043943
     C                   EVAL      CPCCY = S_EVCY
     C                   EVAL      CPPSTA = S_EVAM
     C                   EVAL      CPVDAT = S_EVDT

     C                   EVAL      CPTYPE = 'SEPOS'
     C                   EVAL      CPPAYT = 'D'
     C                   MOVE      S_RVRS        Wrevi
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Trades
      ** iiiSPDbbyy--mvn---CV or iiiSPSbbyy--mvn---CV

     C                   IF        S_EVDT <= BJRDNB
     C                             AND S_RECI = 'D'
     C                   IF        (%SUBST(S_ACKY:4:3) = 'SPD'
     C                             AND %SUBST(S_ACKY:11:2) = '  '
     C                             AND %SUBST(S_ACKY:16:5) = '   CV')
     C                             OR (%SUBST(S_ACKY:4:3) = 'SPS'
     C                             AND %SUBST(S_ACKY:11:2) = '  '
     C                             AND %SUBST(S_ACKY:16:5) = '   CV')
     C                   MOVE      S_STLT        Wstyp
     C                   MOVE      S_STLA        Wsacc
     C                   EVAL      Wcurr = S_EVCY
     C                   MOVE      S_CSTN        Wcust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = S_BRHA
     C                   MOVE      S_TRFR        Wtrfr
     C**********         IF        WTRFR = '000000'                                         MD043943
     C                   EVAL      CPACNO = Wcust + S_SESH
     C**********         ELSE                                                               MD043943
     C**********         EVAL      CPACNO = Wcust + S_SESH + WTRFR                          MD043943
     C**********         ENDIF                                                              MD043943
     C                   EVAL      CPCCY = S_EVCY
     C                   EVAL      CPPSTA = S_EVAM
     C                   EVAL      CPVDAT = S_EVDT

     C                   EVAL      CPTYPE = 'SESAL'
     C                   EVAL      CPPAYT = 'G'
     C                   MOVE      S_RVRS        Wrevi
     C                   EVAL      Wtrade = 'Y'
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Securities maturity
      ** iiiS-D--yy--mvn---CV or iiiS-S--yy--mvn---CV
      ** iiiStDbbyy--mvn---CV or iiiStSbbyy--mvn---CV

     C                   IF        S_EVDT <= BJRDNB
     C                             AND S_RECI = 'D'
     C                   IF        %SUBST(S_ACKY:4:2) = 'S '
     C                             AND %SUBST(S_ACKY:7:2) = '  '
     C                             AND %SUBST(S_ACKY:11:2) = '  '
     C                             AND %SUBST(S_ACKY:16:5) = '   CV'
     C                             OR %SUBST(S_ACKY:4:1) = 'S'
     C                             AND %SUBST(S_ACKY:11:2) = '  '
     C                             AND %SUBST(S_ACKY:16:5) = '   CV'
     C                             AND %SUBST(S_ACKY:5:1) <> 'P'
     C                   IF        %SUBST(S_ACKY:6:1) = 'D'
     C                             OR %SUBST(S_ACKY:6:1) = 'S'
     C                   MOVE      S_STLT        Wstyp
     C                   MOVE      S_STLA        Wsacc
     C                   EVAL      Wcurr = S_EVCY
     C                   MOVE      S_CSTN        Wcust
     C                   EXSR      SrExtCust
     C                   IF        Wcust <> *BLANKS
     C                   EVAL      CPCUSD = Wcust

     C                   EVAL      CPBRCH = S_BRHA
     C                   MOVE      S_TRFR        Wtrfr
     C**********         IF        WTRFR = '000000'                                         MD043943
     C                   EVAL      CPACNO = Wcust + S_SESH
     C**********         ELSE                                                               MD043943
     C**********         EVAL      CPACNO = Wcust + S_SESH + WTRFR                          MD043943
     C**********         ENDIF                                                              MD043943
     C                   EVAL      CPCCY = S_EVCY
     C                   EVAL      CPPSTA = S_EVAM
     C                   EVAL      CPVDAT = S_EVDT

     C                   EVAL      CPTYPE = 'SEMAT'
     C                   EVAL      CPPAYT = 'G'
     C                   MOVE      S_RVRS        Wrevi
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** iiiL-dbb----mvn---FV                                                               MD042828
                                                                                            MD042828
     C                   IF        S_EVDT <= BJRDNB                                         MD042828
     C                             AND S_RECI = 'D'                                         MD042828
     C                   IF        %SUBST(S_ACKY:4:2) = 'L '                                MD042828
     C                             AND %SUBST(S_ACKY:11:2) = '  '                           MD042828
     C                             AND %SUBST(S_ACKY:16:5) = '   FV'                        MD042828
                                                                                            MD042828
     C                   MOVE      S_STLT        Wstyp                                      MD042828
     C                   MOVE      S_STLA        Wsacc                                      MD042828
     C                   EVAL      Wcurr = S_EVCY                                           MD042828
     C                   MOVE      S_CSTN        Wcust                                      MD042828
     C                   EXSR      SrExtCust                                                MD042828
     C                   IF        Wcust <> *BLANKS                                         MD042828
     C                   EVAL      CACBCNUM = Wcust                                         MD042828
     C                   EVAL      CACBCURR = S_EVCY                                        MD042828
     C                   EVAL      CACBBRCH = S_BRHA                                        MD042828
     C                   EVAL      CACBACOD = *ZERO                                         MD042828
     C                   EVAL      CACBSEQ = *ZERO                                          MD042828
     C                   EVAL      CACBDACC = *ZERO                                         MD042828
     C                   EVAL      CACBAMNT = S_EVAM                                        MD042828
     C                   EVAL      CACCTYPE = 'SEMVD'                                       MD042828
     C                   EVAL      CACCTRNN = Wcust + S_SESH                                MD042828
     C                   EVAL      CACCJANO = *BLANKS                                       MD042828
     C**********         EVAL      CACCACHL = *BLANKS                              MD042828 MD043652
     C**********         EVAL      CACCACTY = *BLANKS                              MD042828 MD043652
     C                   EVAL      CACCACHL = Wcust                                         MD043652
     C                   EVAL      CACCACTY = 'CUST'                                        MD043652
     C                   EVAL      CACCJATP = *BLANKS                                       MD042828
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
     C                   EVAL      JCJANO = CACBCNUM                                        MD042828
     C     JCJANO        SETLL     SDJACCL0                                                 MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
                                                                                            MD042828
     C                   DOW       NOT %EOF(SDJACCL0)                                       MD042828
     C                   EVAL      CACCJANO = JCJANO                                        MD042828
     C                   EVAL      CACBCNUM = JCCUST                                        MD042828
     C                   IF        JCCUST <> *BLANKS                                        MD042828
     C                   EVAL      CACCACHL = JCCUST                                        MD042828
     C                   EVAL      CACCACTY = 'CUST'                                        MD042828
     C                   ELSE                                                               MD042828
     C                   EVAL      CACCACHL = JCNAHO                                        MD042828
     C                   EVAL      CACCACTY = 'NAHO'                                        MD042828
     C                   ENDIF                                                              MD042828
     C                   EVAL      CACCJATP = 'M'                                           MD042828
     C                   WRITE     GLFCABD0                                                 MD042828
                                                                                            MD042828
                                                                                            MD042828
     C     JCJANO        READE     SDJACCL0                                                 MD042828
     C                   ENDDO                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
     C                   ENDIF                                                              MD042828
                                                                                            MD042828
     C                   READ      SEKEYD

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdate - Subroutine to write record to customer             *
      *            activity/payment amounts file                      *
      *                                                               *
      * Called by: SrDeals, SrLoans, SrSecurities, SrFutOpt           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrUpdate      BEGSR

      ** Delete record if reversal indicator is 1

     C                   IF        Wrevi = 1
     C                   EVAL      Kpcusd = CPCUSD
     C                   EVAL      Kpacno = CPACNO
     C                   EVAL      Kpccy  = CPCCY

     C                   IF        Wtrade = ' '
     C     Kpacno        SETLL     GLCAPAL1
     C     Kpacno        READE     GLCAPAL1
     C                   DOW       NOT %EOF(GLCAPAL1)
     C                             AND KPACNO = C_CPACNO
     C                   DELETE    GLCAPAD1
     C     Kpacno        READE     GLCAPAL1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      Wtrade = ' '
     C                   EVAL      Kppsta = CPPSTA
     C     Kcapa         SETLL     GLCAPAL3
     C     Kcapa         READE     GLCAPAL3
     C                   DOW       NOT %EOF(GLCAPAL3)
     C                             AND KPACNO = B_CPACNO
     C                             AND KPPSTA = B_CPPSTA
     C                   DELETE    GLCAPAD2
     C     Kcapa         READE     GLCAPAL3
     C                   ENDDO
     C                   ENDIF

     C                   ELSE

      ** Write record

     C                   EVAL      CPJANO = *BLANKS
     C                   EVAL      CPACHL = CPCUSD
     C                   EVAL      CPACTY = 'CUST'
     C                   EVAL      CPJATP = ' '
     C
     C                   WRITE     GLCAPAD0

     C                   EVAL      JCJANO = CPCUSD
     C     JCJANO        SETLL     SDJACCL0
     C     JCJANO        READE     SDJACCL0

     C                   DOW       NOT %EOF(SDJACCL0)
     C                   EVAL      CPJANO = JCJANO
     C                   EVAL      CPCUSD = JCCUST
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      CPACHL = JCCUST
     C                   EVAL      CPACTY = 'CUST'
     C                   ELSE
     C                   EVAL      CPACHL = JCNAHO
     C                   EVAL      CPACTY = 'NAHO'
     C                   ENDIF
     C                   EVAL      CPJATP = 'M'
     C                   WRITE     GLCAPAD0


     C     JCJANO        READE     SDJACCL0
     C                   ENDDO

     C                   ENDIF

      ** Initialize fields

     C                   EVAL      CPCUSD = *BLANKS
     C                   EVAL      CPBRCH = *BLANKS
     C                   EVAL      CPACNO = *BLANKS
     C                   EVAL      CPCCY = *BLANKS
     C                   EVAL      CPPSTA = *ZEROS
     C                   EVAL      CPVDAT = *ZEROS
     C                   EVAL      CPTYPE = *BLANKS
     C                   EVAL      CPPAYT = *BLANKS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExtCust - Subroutine to identify the customer of the        *
      *             account                                           *
      *                                                               *
      * Called by: SrDeals, SrLoans, SrSecurities, SrFutOpt           *
      *                                                               *
      * Calls: AOACCTR0, AONOSTR0                                     *
      *                                                               *
      *****************************************************************

     C     SrExtCust     BEGSR

     C                   EVAL      Wbrch = *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      Wcust         PCust
     C                   PARM                    PKySt
     C     SDCUSD        PARM      SDCUSD        DSSDY
     C                   IF        Prtcd <> *BLANKS
     C                   EVAL      Wcust = *BLANKS
     C                   ELSE
     C                   EVAL      Wbrch = BBBRCD
     C                   ENDIF

     C                   SELECT                                                               CGL185
     C                   WHEN      Wstyp = 01                                                 CGL185
     C                             OR Wstyp = 02                                              CGL185
     C                             OR Wstyp = 07                                              CGL185
     C                             OR Wstyp = 08                                              CGL185
     C                             OR Wstyp = 12                                              CGL185
                                                                                              CGL185
     C                   CALLB     'AONOSTR0'                                                 CGL185
     C                   PARM                    Prtcd                                        CGL185
     C                   PARM      '*KEY   '     Poptn                                        CGL185
     C                   PARM      *BLANKS       Pcnum                                        CGL185
     C                   PARM      Wcurr         Pcycd                                        CGL185
     C                   PARM      *BLANKS       Paccd                                        CGL185
     C                   PARM      *BLANKS       Pacsq                                        CGL185
     C                   PARM      Wsacc         Pnonb                                        CGL185
     C                   PARM      *BLANKS       Pbrca                                        CGL185
     C                   PARM      *BLANKS       Pcssn                                        CGL185
     C                   PARM      *BLANKS       Ppnoi                                        CGL185
     C     SDNOST        PARM      SDNOST        Dsfdy                                        CGL185
                                                                                              CGL185
     C                   IF        Prtcd = *BLANKS                                            CGL185
     C                   EVAL      Wcusn = A7CUST                                             CGL185
     C                   ELSE                                                                 CGL185
     C                   EVAL      Wcusn = *BLANKS                                            CGL185
     C                   ENDIF                                                                CGL185
                                                                                              CGL185
     C                   WHEN      Wstyp = 14                                                 CGL185
     C                   CALLB     'AOACCTR0'                                                 CGL185
     C                   PARM      *BLANKS       Prtcd                                        CGL185
     C                   PARM      '*KEY   '     Poptn                                        CGL185
     C                   PARM      WSACC         Pretl                                        CGL185
     C                   PARM      *BLANKS       Pcnum                                        CGL185
     C                   PARM      *BLANKS       Pcucd                                        CGL185
     C                   PARM      *BLANKS       Paccd                                        CGL185
     C                   PARM      *BLANKS       Pacsq                                        CGL185
     C                   PARM      *BLANKS       Pbrca                                        CGL185
     C     SDACCT        PARM      SDACCT        Dssdy                                        CGL185
                                                                                              CGL185
     C                   IF        Prtcd = *BLANKS                                            CGL185
     C                   MOVE      *BLANKS       Wcusn                                        CGL185
     C                   MOVE      CNUM          Wcusn                                        CGL185
     C                   ELSE                                                                 CGL185
     C                   EVAL      Wcusn = *BLANKS                                            CGL185
     C                   ENDIF                                                                CGL185
                                                                                              CGL185
     C                   WHEN      Wstyp = 05                                                 CGL185
                                                                                              CGL185
     C                   EVAL      Wcusn = WSACC                                              CGL185
                                                                                              CGL185
     C                   OTHER                                                                CGL185
     C                   EVAL      Wcusn = *BLANKS                                            CGL185
                                                                                              CGL185
     C                   ENDSL                                                                CGL185
                                                                                              CGL185
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDealCust - Subroutine to identify the customer of the       *
      *              deal                                             *
      *                                                               *
      * Called by: SrDeals                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrDealCust    BEGSR

     C     D_DLNO        CHAIN     DEALALL
     C                   EVAL      Wcust = *Blanks
     C                   IF        %FOUND(DEALALL)
     C                   MOVE      E_CNUM        Wcust
     C                   IF        E_RCDT = 'C'
     C                             AND E_CHNA <> *Blanks
     C                   MOVE      E_CHNA        Wcust
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoanCust - Subroutine to identify the customer of the       *
      *              loan                                             *
      *                                                               *
      * Called by: SrLoans                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrLoanCust    BEGSR

     C                   EVAL      Wcust = *Blanks
     C                   IF        %FOUND(CLOAN)
     C                   MOVE      L_CNUM        Wcust
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: Main Processing, AOBANKR0                              *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Pmodule

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL000611'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*FIRST  '    Poptn
     C     SDBANK        PARM      SDBANK        Dsfdy

      ** Database Error

     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 02
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Initialize fields

     C                   EVAL      CPCUSD = *BLANKS
     C                   EVAL      CPBRCH = *BLANKS
     C                   EVAL      CPACNO = *BLANKS
     C                   EVAL      CPCCY = *BLANKS
     C                   EVAL      CPPSTA = *ZEROS
     C                   EVAL      CPVDAT = *ZEROS
     C                   EVAL      CPTYPE = *BLANKS
     C                   EVAL      CPPAYT = *BLANKS

     C     KLoank        KLIST
     C                   KFLD                    KLoan
     C                   KFLD                    KRcdt
     C     Kcapa         KLIST
     C                   KFLD                    Kpacno
     C                   KFLD                    Kppsta

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
