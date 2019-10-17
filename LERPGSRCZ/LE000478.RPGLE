     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Past Due Classification Update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000478 - Past Due Classification Update                    *
      *                                                               *
      *           The function of this program is to update the       *
      *           Reporting and Basel II Past Due Classification      *
      *           values.                                             *
      *           Furthermore, it will:                               *
      *           - repair any missing Initial Date/Classification    *
      *             values.                                           *
      *           - update the daily/period counters for manual       *
      *             changes made to Origin Loan/Fee.                  *
      *           - set the Basel II Past Due flag on the customer    *
      *             record.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD053837           Date 13Sep19               *      
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 MD028099           Date 27Oct14               *
      *                 CGL132             Date 01May13               *
      *                 MD021823           Date 19Sep13               *
      *                 AR1097467A         Date 11Apr13               *
      *                 AR1097467          Date 05Apr13               *
      *                 AR746035           Date 14Oct12               *
      *                 AR322177           Date 01Aug12               *
      *                 AR217905           Date 01Aug12               *
      *                 263411             Date 01Aug12               *
      *                 263079             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD053837 - Inconsistency in Basel II initial date and        *
      *             classification for fees. Create separate codes    *
      *             that retrieve loan details by facility for origin *
      *             fee. Pattern codes from origin loan in SR/XRCLOAF.*
      *           - Remove KF_BRCA as key for CLOAF as loans of diff  *
      *             branch with facility are not retrieved.           *
      *           - Use event control date instead of rundate as class*
      *             is not incremented on ANWD COB.                   *      
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  MD028099 - Fix to prevent loans RICC/BICC & fees FERICC/     *
      *             FEBICC to be updated when they are already 999.   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  MD021823 - CLOANCL differences after Check Cob 6             *
      *  AR1097467A - Expected 15% COB run optimization not met       *
      *  AR1097467 - Expected 15% COB run optimization not met        *
      *  AR746035 - LEC0478 fellover with a message 'The target for   *
      *             a numeric operation is too small to hold the      *
      *             result'. Increase the size of field DSCPAM_t from *
      *             (13,0) to (17,0). (Child: AR746036)               *
      *  AR322177 - Component LEC0478 failure in COB                  *
      *           - Wrong update of Category fields                   *
      *             (Child: AR322178)                                 *
      *  AR217905 - LE0000478 allows for the BPLCCY to be *BLANKS     *
      *           - Issue a DB error if BPLCCY is blank               *
      *             (Child: AR217939)                                 *
      *  263411 - Wrong Loan Activity displayed for Original Loan     *
      *  263079 - Customer Past Due Flag error                        *
      *         - only update if blank or Y (never when N)            *
      *         - Only update Past Due flag and increment             *
      *           Classification when                                 *
      *           Basel II/Reporting PD Methodology is A              *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     F/SPACE
      *****************************************************************
     F***LEPDUEL8  IP   E           K DISK    INFSR(*PSSR)                                AR1097467A
     F***LEPDUFL8  IS   E           K DISK    INFSR(*PSSR)                                AR1097467A
     FLEPDUEL8  IF   E           K DISK    INFSR(*PSSR)                                   AR1097467A
     FLEPDUFL8  IF   E           K DISK    INFSR(*PSSR)                                   AR1097467A
     FHISTSL0   IF   E           K DISK    INFSR(*PSSR) PREFIX(H_)
     F                                     IGNORE(HISTSHMF)
     F                                     IGNORE(HISTSHQF)
     FLEPDLHL1  IF   E           K DISK    INFSR(*PSSR) PREFIX(T_)
     F                                     RENAME(LEPDLHD0:LEPDLHL1F)
     FLEPDFHL1  IF   E           K DISK    INFSR(*PSSR) PREFIX(T_)
     F                                     RENAME(LEPDFHD0:LEPDFHL1F)
     F***LEPDUEL9  IF   E           K DISK    INFSR(*PSSR)                                AR1097467A
     F**********                           RENAME(LEPDUED0:LEPDUEL9F)                     AR1097467A
     F***LEPDUFL9  IF   E           K DISK    INFSR(*PSSR)                                AR1097467A
     F**********                           RENAME(LEPDUFD0:LEPDUFL9F)                     AR1097467A
     FCLOAN     IF   E           K DISK    INFSR(*PSSR) PREFIX(P_)
     F                                     RENAME(CLOANCLF:CLOANF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FCLOAF     IF   E           K DISK    INFSR(*PSSR) PREFIX(F_)
     F                                     RENAME(CLOANCLF:CLOAFF)
     F***CLOANL4   UF   E           K DISK    INFSR(*PSSR) PREFIX(O_)                         263411
     FCLOANC    UF   E           K DISK    INFSR(*PSSR) PREFIX(O_)                            263411
     F                                     IGNORE(CLOANHHF)                                   263411
     F                                     IGNORE(CLOANCKF)                                   263411
     F                                     IGNORE(CLOANZ1F)                                   263411
     FLEFEEDL1  UF   E           K DISK    INFSR(*PSSR) PREFIX(O_)
     FSDACUSL6  UF   E           K DISK    INFSR(*PSSR)
     FSDACUSL1  UF   E           K DISK    INFSR(*PSSR) PREFIX(A_)
     F***LEPDLHPD  UF A E           K DISK    INFSR(*PSSR) PREFIX(D_)                     AR1097467A
     F***LEPDFHPD  UF A E           K DISK    INFSR(*PSSR) PREFIX(D_)                     AR1097467A
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)                                    AR1097467
      ** Currency Codes/Details for Cache Loading                                          AR1097467

     D/EJECT

      ** Key Fields

     D W_DATE          S                   LIKE(BJRDNB)                                     AR322177
     D KE5CUST         S                   LIKE(E5CUST)

     D KF_FCUS         S                   LIKE(F_FCUS)
     D KF_FTYP         S                   LIKE(F_FTYP)
     D KF_FSEQ         S                   LIKE(F_FSEQ)
     D*KF_BRCA**       S                   LIKE(F_BRCA)                                     MD053837

     D KH_LNRF         S                   LIKE(H_LNRF)
     D KH_VDAT         S                   LIKE(H_VDAT)

     D KO_RECI         S                   LIKE(O_RECI)
     D KO_LNRF         S                   LIKE(O_LNRF)

     D KO_FECNUM       S                   LIKE(O_FECNUM)
     D KO_FEFACL       S                   LIKE(O_FEFACL)
     D KO_FELOAN       S                   LIKE(O_FELOAN)
     D KO_FEFSEQ       S                   LIKE(O_FEFSEQ)

     D KP_LNRF         S                   LIKE(P_LNRF)

     D KT_YPRECI       S                   LIKE(T_YPRECI)
     D KT_YPORG        S                   LIKE(T_YPORG)
     D*Kt_YBRCA        S                   LIKE(t_YBRCA)
     D KT_YECNUM       S                   LIKE(T_YECNUM)
     D KT_YEFACL       S                   LIKE(T_YEFACL)
     D KT_YESEQ        S                   LIKE(T_YESEQ)
     D KT_YPDVDT       S                   LIKE(T_YPDVDT)

     D KT_YPORG2       S                   LIKE(T_YPORG2)
     D KT_YBRCA2       S                   LIKE(T_YBRCA2)
     D KT_YPDVDT2      S                   LIKE(T_YPDVDT2)

      ** Entry Parameter                                                                  AR1097467A
     D W#TYPE          S             10A                                                  AR1097467A
                                                                                          AR1097467A
      ** External Definitions
     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,PROCPARMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details

     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** ICD Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                MD053837
      ** General Ledger details                                                             MD053837
      *                                                                                     MD053837
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects

      ***Cache*Areas***************************************************                    AR1097467
     D***DSCURR*         S                   INZ DIM(500) LIKE(SDCURR)                     AR1097467
     D***DSCYCD*         S                   INZ DIM(500) LIKE(A6CYCD)                     AR1097467
      ** +--------------------------------------+                                          AR1097467
      ** ¦ Cache Work Variables and Storage     ¦                                          AR1097467
      ** ¦ ================================     ¦                                          AR1097467
      ** +--------------------------------------+                                          AR1097467
                                                                                           AR1097467
     D ULIdx           S              4P 0 INZ                                             AR1097467
     D CacheHit        S               N   INZ                                             AR1097467
     D ArrSzCcy        C                   CONST(250)                                      AR1097467
     D SrcCcy          S                   INZ LIKE(A6CYCD)                                AR1097467
                                                                                           AR1097467
      ** Currency Cache (key and detail storage)                                           AR1097467
                                                                                           AR1097467
     D KeyCcy          S                   INZ LIKE(SrcCcy)                                AR1097467
     D                                     DIM(ArrSzCcy) ASCEND                            AR1097467
                                                                                           AR1097467
     D DSCcy         E DS                  INZ EXTNAME(SDCURRL1:*INPUT)                    AR1097467
     D                                     DIM(ArrSzCcy) QUALIFIED                         AR1097467
                                                                                           AR1097467
      ** Cache index                                                                       AR1097467
                                                                                           AR1097467
     D CcyIdx          DS                  INZ QUALIFIED                                   AR1097467
     D  Last                               LIKE(ULIdx)                                     AR1097467
     D  Current                            LIKE(ULIdx) INZ(1)                              AR1097467
     D  Prev                               LIKE(ULIdx) INZ(1)                              AR1097467

      ** Work Variables

      ** Description
     D DSBCD           S             25    INZ DIM(9)

      ** Cumulative Days
     D DSBCN           S              3  0 INZ DIM(9) ASCEND

      ** Period Days
     D DSBCE           S              3  0 INZ DIM(9)

      ** Description
     D DSRCD           S             25    INZ DIM(9)

      ** Cumulative Days
     D DSRCN           S              3  0 INZ DIM(9) ASCEND

      ** Period Days
     D DSRCE           S              3  0 INZ DIM(9)

      **
     D DSCPAM          S                   INZ LIKE(F_CPAM)
     D***DSCPAM_T        S                   INZ LIKE(F_CPAM)                               AR746035
     D DSCPAM_t        S             17  0 INZ                                              AR746035
     D DSCYDP1         S              1  0 INZ
     D DSCYDP2         S              1  0 INZ
     D DSDYS           S              5  0 INZ
     D DSMDIN1         S              1    INZ
     D DSMDIN2         S              1    INZ
     D DSORIGREF       S              6    INZ
     D DSPDCLREF       S              6    INZ
     D DSPDCU          S                   INZ LIKE(E5PDCU)
     D DSPDSDT         S                   INZ LIKE(T_YPDVDT)
     D DSPVDVDT        S                   INZ LIKE(H_VDAT)
     D DSRATE1         S             13  8 INZ
     D DSRATE2         S             13  8 INZ
     D DSRECTYPE       S              1    INZ

     D DSUPDATE        S              1    INZ
     D DSYPDVDT        S                   INZ LIKE(T_YPDVDT)

     D DSP_CPAM        S                   INZ LIKE(P_CPAM)

     D @CYCD           S              3

      ** PDCL Loan Key Details
     D DSPDUE_K        DS
     D  YPORG
     D  YBRCA

     D DSPDUE_KS       DS                  INZ LIKEDS(DSPDUE_K)

      ** PDCL Fee Key Details
     D DSPDUF_K        DS
     D  YECNUM
     D  YEFACL
     D  YESEQ
     D  YPORG2
     D  YBRCA2

     D DSPDUF_KS       DS                  INZ LIKEDS(DSPDUF_K)

      ** Loan PDCL History Key Details (LEPDLHL1)
     D DSPDLH_K        DS
     D  T_YPORG

     D DSPDLH_KS       DS                  INZ LIKEDS(DSPDLH_K)

      ** Fee PDCL History Key Details (LEPDFHL1)
     D DSPDFH_K        DS
     D  T_YECNUM
     D  T_YEFACL
     D  T_YESEQ
     D  T_YPORG2
     D  T_YBRCA2

     D DSPDFH_KS       DS                  INZ LIKEDS(DSPDFH_K)

      ** Indexes
     D #A              S              9  0 INZ
     D***#C*****         S              9  0 INZ                                           AR1097467
     D #P              S              9  0 INZ

     I/EJECT

     I***LEPDUED0      01                                                                 AR1097467A

     I***LEPDUFD0      02                                                                 AR1097467A
     ILEPDUFD0                                                                            AR1097467A
     I              YPORG                       YPORG2
     I              YBRCA                       YBRCA2

     I***LEPDUFL9F                                                                        AR1097467A
     I*********     YPORG                       YPORG2                                    AR1097467A
     I*********     YBRCA                       YBRCA2                                    AR1097467A

     ILEPDFHL1F
     I              YPORG                       t_YPORG2
     I              YBRCA                       t_YBRCA2
     I              YPDVDT                      t_YPDVDT2

     C/EJECT
      *****************************************************************
      * Main Processing Control                                       *
      *****************************************************************

      ** Process Request

      ** Proc Origin Loans
                                                                                          AR1097467A
     C                   IF        W#TYPE = '*LOANREP' or                                 AR1097467A
     C                             W#TYPE = '*LOANBAS'                                    AR1097467A
     C     *START        SETLL     LEPDUEL8                                               AR1097467A
     C                   READ      LEPDUEL8                                               AR1097467A
     C                   DOW       NOT %EOF(LEPDUEL8)                                     AR1097467A
     C***01*****         EXSR      PPDUE                                                  AR1097467A
     C                   EXSR      PPDUE                                                  AR1097467A
     C                   READ      LEPDUEL8                                               AR1097467A
     C                   ENDDO                                                            AR1097467A
     C                   ENDIF                                                            AR1097467A

      ** Proc Origin Fee
     C                   IF        W#TYPE = '*FEEREP' or                                  AR1097467A
     C                             W#TYPE = '*FEEBAS'                                     AR1097467A
     C     *START        SETLL     LEPDUFL8                                               AR1097467A
     C                   READ      LEPDUFL8                                               AR1097467A
     C                   DOW       NOT %EOF(LEPDUFL8)                                     AR1097467A
     C***02*****         EXSR      PPDUF                                                  AR1097467A
     C                   EXSR      PPDUF                                                  AR1097467A
     C                   READ      LEPDUFL8                                               AR1097467A
     C                   ENDDO                                                            AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   EVAL      *INLR = *ON                                            AR1097467A
     C                   RETURN                                                           AR1097467A
                                                                                          AR1097467A
      *****************************************************************
      /EJECT
      *****************************************************************
      *  PPDUE - Process Origin Loan/PDCL Link Details                *
      *****************************************************************
     C     PPDUE         BEGSR

      ** If Change of Origin Loan;

     C                   IF         DSPDUE_KS <> DSPDUE_K
     C                   EVAL       DSPDUE_KS  = DSPDUE_K

      ** Retrieve Loan PDCL History Details

     C                   EVAL      KT_YPRECI   = 'T'
     C                   EVAL      KT_YPORG    = YPORG
     C                   EVAL      KT_YPDVDT   = BJRDNB
     C     KLEPDLHL1     SETGT     LEPDLHL1
     C     KLEPDLHL1A    READPE(E) LEPDLHL1

     C                   IF        %EOF(LEPDLHL1)
     C                   CLEAR                   LEPDLHL1F
     C                   ENDIF

      ** Retrieve Origin Loan Details

     C**********         EVAL      Ko_RECI     = 'D'                                          263411
     C                   EVAL      KO_LNRF     = YPORG
     C*****KCLOANL4      CHAIN(E)  CLOANL4                                                    263411
     C     KCLOANL4      CHAIN(E)  CLOANC                                                     263411

     C                   IF        %ERROR
     C**********         EVAL      DBFILE      = 'CLOANL4'                                    263411
     C                   EVAL      DBFILE      = 'CLOANC'                                     263411
     C                   EVAL      DBKEY       = DSPDUE_KS
     C                   EVAL      DBASE       = 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set/Update Origin Loan Details

     C**********         IF        %FOUND(CLOANL4)                                            263411
     C                   IF        %FOUND(CLOANC)                                             263411
     C                   EXSR      XSCLOANL4

     C                   IF        DSUPDATE    = 'Y'
     C                   EVAL      DSUPDATE    = 'N'
     C                   EXSR      XUCLOANL4
                                                                                            MD021823
     C                   ELSE                                                               MD021823
     C                   IF        W#TYPE = '*LOANREP' AND                                  MD021823
     C                             O_FPNR = 'N'                                             MD021823
     C                   EXCEPT    OCLOAN                                                   MD021823
     C                   ENDIF                                                              MD021823
                                                                                            MD021823
     C                   ENDIF

      ** If Basel II Class > 1, Retrieve/Update Customer Details

     C                   IF        W#TYPE = '*LOANBAS'                                    AR1097467A
     C                   IF        BPMTDL      = 'A'                                          263079
     C                   IF        O_BCAT      > 1
     C                   EVAL      KE5CUST     = O_CNUM
     C                   EXSR      XUACUSL0
     C                   ENDIF
     C                   ENDIF                                                                263079
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  PPDUF - Process Origin Fee/PDCL Link Details                 *
      *****************************************************************
     C     PPDUF         BEGSR

      ** If Change of Origin Fee;

     C                   IF         DSPDUF_KS <> DSPDUF_K
     C                   EVAL       DSPDUF_KS  = DSPDUF_K

      ** Retrieve Fee PDCL History Details

     C                   EVAL      KT_YPRECI   = 'T'
     C                   EVAL      KT_YPORG2   = YPORG2
     C                   EVAL      KT_YECNUM   = YECNUM
     C                   EVAL      KT_YEFACL   = YEFACL
     C                   EVAL      KT_YESEQ    = YESEQ
     C                   EVAL      KT_YBRCA2   = YBRCA2
     C                   EVAL      KT_YPDVDT2  = YPDVDT
     C     KLEPDFHL1     SETGT     LEPDFHL1
     C     KLEPDFHL1A    READPE(E) LEPDFHL1

     C                   IF        %EOF(LEPDFHL1)
     C                   CLEAR                   LEPDFHL1F
     C                   ENDIF

      ** Retrieve Origin Fee Details

     C                   EVAL      KO_FECNUM   = YECNUM
     C                   EVAL      KO_FEFACL   = YEFACL
     C                   EVAL      KO_FELOAN   = YPORG2
     C                   EVAL      KO_FEFSEQ   = YESEQ
     C     KLEFEEDL1     CHAIN(E)  LEFEEDL1

     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LEFEEDL1'
     C                   EVAL      DBKEY       = DSPDUF_KS
     C                   EVAL      DBASE       = 200
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set/Update Origin Fee Details

     C                   IF        %FOUND(LEFEEDL1)
     C                   EXSR      XSLEFEEDL1

     C                   IF        DSUPDATE    = 'Y'
     C                   EVAL      DSUPDATE    = 'N'
     C                   EXSR      XULEFEEDL1
     C                   ENDIF

      ** If Basel II Class > 1, Retrieve/Update Customer Details

     C                   IF        W#TYPE = '*FEEBAS'                                     AR1097467A
     C                   IF        BPMTDL      = 'A'                                          263079
     C                   IF        O_FEBCAT    > 1
     C**********         EVAL      KE5CUST     = O_CNUM                                   AR1097467A
     C                   EVAL      KE5CUST     = YECNUM                                   AR1097467A
     C                   EXSR      XUACUSL0
     C                   ENDIF
     C                   ENDIF                                                                263079
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  XSCLOANL4 - Set Origin Loan Details                          *
      *****************************************************************
     C     XSCLOANL4     BEGSR

     C                   IF        W#TYPE = '*LOANREP'                                    AR1097467A
                                                                                          AR1097467A
      ** Initialisation

     C                   EVAL      O_FPNR      = 'N'

      ** REPORTING PAST DUE DETAILS:
      ** - Repair Incorrect Data Values

     C                   IF        T_YPCLOB    > 0
     C                   IF        O_RIDT      = 0
     C                   EVAL      O_RIDT      = T_YPDSDT
     C                   EVAL      O_RCAT      = 0

     C                   EVAL      O_RIDC      = 0
     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** set W_DATE = run date if RIDT is less than run date,                               AR322177
      ** else set i = next working date                                                     AR322177
                                                                                            AR322177
     C                   IF        O_RIDT     <= BJRDNB                                     AR322177
     C                   EVAL      W_DATE= BJRDNB                                           AR322177
     C                   ELSE                                                               AR322177
     C                   EVAL      W_DATE= BJDNWD                                           AR322177
     C                   ENDIF                                                              AR322177
                                                                                            AR322177
     C                   IF        O_RCAT      = 0
     C**********         IF        o_RIDT     <= BJRDNB                                     AR322177
     C**********         EVAL      DSDys       = BJRDNB - o_RIDT                            AR322177
     C                   IF        O_RIDT     <= W_DATE                                     AR322177
     C                   EVAL      DSDYS       = W_DATE - O_RIDT                            AR322177

     C                   IF        DSDYS       > 999
     C                   EVAL      DSDYS       = 999
     C                   ENDIF

     C                   EVAL      O_RCAT      = %LOOKUPGT(DSDYS:DSRCN)
     C                   EVAL      O_RCSD      = 0
     C                   EVAL      O_RCDY      = 0
     C                   EVAL      O_RCAC      = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        O_RCSD      = 0
     C                   EVAL      O_RCSD      = O_RIDT

     C                   IF        O_RCAT      > 1
     C                   EVAL      O_RCSD     += DSRCN(O_RCAT-1)
     C                   ENDIF

     C                   IF        O_RCAT      > 0                                          AR322177
     C                   EVAL      O_RCDY      = DSRCE(O_RCAT)
     C                   ENDIF                                                              AR322177

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF

      ** - If Initial Date/Class Changed Today, Increment Count

     C                   IF        O_RIDC      > 0             OR
     C                             O_RCAC      > 0
     C                   If        O_RICC < 999                                             MD028099
     C                   EVAL      O_RICC     += 1
     C                   Endif                                                              MD028099

     C                   EVAL      O_FPNR      = 'Y'
     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** - If Principal Amount <= 0, Reset All Values

     C                   IF        T_YPCLOB   <= 0
     C                   IF        O_RIDT     <> 0             OR
     C                             O_RCAT     <> 0
     C                   EVAL      O_RIDT      = 0
     C                   EVAL      O_RCAT      = 0
     C                   EVAL      O_RCSD      = 0
     C                   EVAL      O_RCDY      = 0
     C                   EVAL      O_RICC      = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** - Else Principal Amount Exist;
      ** If End of Period Reached, Increment
      ** Classification & Reset Counts

     C                   ELSE
     C                   IF        BPRMTL      = 'A'                                          263079
     C                   IF        O_RCAT      < 9             AND
     C                             DSRCD(O_RCAT+1) <> *BLANKS  AND
     C**********                   BJRDNB     >= O_RCSD + O_RCDY                            MD053837
     C                             WECD       >= O_RCSD + O_RCDY                            MD053837
     C                   EVAL      O_RCSD      = O_RCSD + O_RCDY
     C                   EVAL      O_RCAT     += 1
     C                   EVAL      O_RCDY      = DSRCE(O_RCAT)

     C                   EVAL      O_FPNR      = 'Y'
     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF                                                                263079
     C                   ENDIF
                                                                                          AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   IF        W#TYPE = '*LOANBAS'                                    AR1097467A

      ** BASEL II PAST DUE DETAILS:
      ** - Repair Incorrect Data Values

     C                   IF        T_YPCLOB    > 0
     C                   IF        O_BIDT      = 0
     C                   EVAL      O_BIDT      = T_YPDSDT
     C                   EVAL      O_BCAT      = 0

     C                   EVAL      O_BIDC      = 0
     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** set W_DATE = run date if BIDT is less than run date,                               AR322177
      ** else set i = next working date                                                     AR322177
     C                   IF        O_BIDT     <= BJRDNB                                     AR322177
     C                   EVAL      W_DATE= BJRDNB                                           AR322177
     C                   ELSE                                                               AR322177
     C                   EVAL      W_DATE= BJDNWD                                           AR322177
     C                   ENDIF                                                              AR322177
                                                                                            AR322177
     C                   IF        O_BCAT      = 0
     C**********         IF        o_BIDT     <= BJRDNB                                     AR322177
     C**********         EVAL      DSDys       = BJRDNB - o_BIDT                            AR322177
     C                   IF        O_BIDT     <= W_DATE                                     AR322177
     C                   EVAL      DSDYS       = W_DATE - O_BIDT                            AR322177

     C                   IF        DSDYS       > 999
     C                   EVAL      DSDYS       = 999
     C                   ENDIF

     C                   EVAL      O_BCAT      = %LOOKUPGT(DSDYS:DSBCN)
     C                   EVAL      O_BCSD      = 0
     C                   EVAL      O_BCDY      = 0
     C                   EVAL      O_BCAC      = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        O_BCSD      = 0
     C                   EVAL      O_BCSD      = O_BIDT

     C                   IF        O_BCAT      > 1
     C                   EVAL      O_BCSD     += DSBCN(O_BCAT-1)
     C                   ENDIF

     C                   IF        O_BCAT      > 0                                          AR322177
     C                   EVAL      O_BCDY      = DSBCE(O_BCAT)
     C                   ENDIF                                                              AR322177

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF

      ** - If Initial Date/Class Changed Today, Increment Count

     C                   IF        O_BIDC      > 0             OR
     C                             O_BCAC      > 0
     C                   If        O_BICC < 999                                             MD028099
     C                   EVAL      O_BICC     += 1
     C                   Endif                                                              MD028099

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** - If Principal Amount = 0, Reset All Values

     C                   IF        T_YPCLOB   <= 0
     C                   IF        O_BIDT     <> 0             OR
     C                             O_BCAT     <> 0
     C                   EVAL      O_BIDT      = 0
     C                   EVAL      O_BCAT      = 0
     C                   EVAL      O_BCSD      = 0
     C                   EVAL      O_BCDY      = 0
     C                   EVAL      O_BICC      = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** - Else Principal Amount Exist;
      ** If End of Period Reached, Increment Classification
      ** & Reset Counts

     C                   ELSE
     C                   IF        BPMTDL      = 'A'                                          263079
     C                   IF        O_BCAT      < 9             AND
     C                             DSBCD(O_BCAT+1) <> *BLANKS  AND
     C**********                   BJRDNB     >= O_BCSD + O_BCDY                            MD053837
     C                             WECD       >= O_BCSD + O_BCDY                            MD053837

     C                   IF        BPLCCY     <> *BLANKS       AND
     C                             BPAMNT     <> 0
     C                   EXSR      XRCLOAF

     C                   IF        BPPERC     <> 0
     C                   EVAL      DSCPAM_T    = DSCPAM_T * BPPERC
     C                   ENDIF
     C                   ENDIF

     C                   IF        BPLCCY      = *BLANKS       OR
     C                             BPLCCY     <> *BLANKS       AND
     C                             DSCPAM_T    > BPAMNT
     C                   EVAL      O_BCSD      = O_BCSD + O_BCDY
     C                   EVAL      O_BCAT     += 1
     C                   EVAL      O_BCDY      = DSBCE(O_BCAT)

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                263079
     C                   ENDIF
                                                                                          AR1097467A
     C                   ENDIF                                                            AR1097467A

     C                   ENDSR
      /EJECT
      *****************************************************************
      *  XSLEFEEDL1 - Set Origin Fee Details                          *
      *****************************************************************

     C     XSLEFEEDL1    BEGSR

     C                   IF        W#TYPE = '*FEEREP'                                     AR1097467A
                                                                                          AR1097467A
      ** Initialisation

      ** REPORTING PAST DUE DETAILS:
      ** - Repair Incorrect Data Values

     C                   IF        T_YPCLOB    > 0
     C                   IF        O_FERIDT    = 0
     C                   EVAL      O_FERIDT    = T_YPDSDT
     C                   EVAL      O_FERCAT    = 0

     C                   EVAL      O_FERIDC    = 0
     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** set W_DATE = run date if RIDT is less than run date,                               AR322177
      ** else set i = next working date                                                     AR322177

     C                   IF        O_FERIDT   <= BJRDNB                                     AR322177
     C                   EVAL      W_DATE= BJRDNB                                           AR322177
     C                   ELSE                                                               AR322177
     C                   EVAL      W_DATE= BJDNWD                                           AR322177
     C                   ENDIF                                                              AR322177
                                                                                            AR322177
     C                   IF        O_FERCAT    = 0
     C**********         IF        o_FERIDT   <= BJRDNB                                     AR322177
     C**********         EVAL      DSDys       = BJRDNB - o_FERIDT                          AR322177
     C                   IF        O_FERIDT   <= W_DATE                                     AR322177
     C                   EVAL      DSDYS       = W_DATE - O_FERIDT                          AR322177

     C                   IF        DSDYS       > 999
     C                   EVAL      DSDYS       = 999
     C                   ENDIF

     C                   EVAL      O_FERCAT    = %LOOKUPGT(DSDYS:DSRCN)
     C                   EVAL      O_FERCSD    = 0
     C                   EVAL      O_FERCDY    = 0
     C                   EVAL      O_FERCAC    = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        O_FERCSD    = 0
     C                   EVAL      O_FERCSD    = O_FERIDT

     C                   IF        O_FERCAT    > 1
     C                   EVAL      O_FERCSD   += DSRCN(O_FERCAT-1)
     C                   ENDIF

     C                   IF        O_FERCAT    > 0                                          AR322177
     C                   EVAL      O_FERCDY    = DSRCE(O_FERCAT)
     C                   ENDIF                                                              AR322177

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

     C                   IF        O_FEPLNR    = *BLANK
     C                   EVAL      O_FEPLNR    = T_YPLON
     C                   ENDIF
     C                   ENDIF

      ** If Initial Date/Class Changed Today, Increment Count

     C                   IF        O_FERIDC    > 0             OR
     C                             O_FERCAC    > 0
     C                   If        O_FERICC < 999                                           MD028099
     C                   EVAL      O_FERICC   += 1
     C                   Endif                                                              MD028099

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** If Principal Amount = 0, Reset All Values

     C                   IF        T_YPCLOB   <= 0
     C                   IF        O_FERIDT   <> 0             OR
     C                             O_FERCAT   <> 0
     C                   EVAL      O_FERIDT    = 0
     C                   EVAL      O_FERCAT    = 0
     C                   EVAL      O_FERCSD    = 0
     C                   EVAL      O_FERCDY    = 0
     C                   EVAL      O_FERICC    = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** Else Principal Amount Exist;
      ** If End of Period Reached, Increment Classification
      ** & Reset Counts

     C                   ELSE
     C                   IF        BPRMTL      = 'A'                                          263079
     C                   IF        O_FERCAT    < 9             AND
     C                             DSRCD(O_FERCAT+1) <> *BLANKS  AND
     C**********                   BJRDNB     >= O_FERCSD + O_FERCDY                        MD053837
     C                             WECD       >= O_FERCSD + O_FERCDY                        MD053837
     C                   EVAL      O_FERCSD    = O_FERCSD + O_FERCDY
     C                   EVAL      O_FERCAT   += 1
     C                   EVAL      O_FERCDY    = DSRCE(O_FERCAT)

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF                                                                263079
     C                   ENDIF
                                                                                          AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   IF        W#TYPE = '*FEEBAS'                                     AR1097467A

      ** BASEL II PAST DUE DETAILS:
      ** - Repair Incorrect Data Values

     C                   IF        T_YPCLOB    > 0
     C                   IF        O_FEBIDT    = 0
     C                   EVAL      O_FEBIDT    = T_YPDSDT
     C                   EVAL      O_FEBCAT    = 0

     C                   EVAL      O_FEBIDC    = 0
     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** set W_DATE = run date if BIDT is less than run date,                               AR322177
      ** else set i = next working date                                                     AR322177
                                                                                            AR322177
     C                   IF        O_FEBIDT   <= BJRDNB                                     AR322177
     C                   EVAL      W_DATE= BJRDNB                                           AR322177
     C                   ELSE                                                               AR322177
     C                   EVAL      W_DATE= BJDNWD                                           AR322177
     C                   ENDIF                                                              AR322177
                                                                                            AR322177
     C                   IF        O_FEBCAT    = 0
     C**********         IF        o_FEBIDT   <= BJRDNB                                     AR322177
     C**********         EVAL      DSDys       = BJRDNB - o_FEBIDT                          AR322177
     C                   IF        O_FEBIDT   <= W_DATE                                     AR322177
     C                   EVAL      DSDYS       = W_DATE - O_FEBIDT                          AR322177

     C                   IF        DSDYS       > 999
     C                   EVAL      DSDYS       = 999
     C                   ENDIF

     C                   EVAL      O_FEBCAT    = %LOOKUPGT(DSDYS:DSBCN)
     C                   EVAL      O_FEBCSD    = 0
     C                   EVAL      O_FEBCDY    = 0
     C                   EVAL      O_FEBCAC    = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        O_FEBCSD    = 0
     C                   EVAL      O_FEBCSD    = O_FEBIDT

     C                   IF        O_FEBCAT    > 1
     C                   EVAL      O_FEBCSD   += DSBCN(O_FEBCAT-1)
     C                   ENDIF

     C                   IF        O_FEBCAT    > 0                                          AR322177
     C                   EVAL      O_FEBCDY    = DSBCE(O_FEBCAT)
     C                   ENDIF                                                              AR322177

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF

      ** - If Initial Date/Class Changed Today, Increment Count

     C                   IF        O_FEBIDC    > 0             OR
     C                             O_FEBCAC    > 0
     C                   If        O_FEBICC < 999                                           MD028099
     C                   EVAL      O_FEBICC   += 1
     C                   Endif                                                              MD028099

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** - If Principal Amount = 0, Reset All Values

     C                   IF        T_YPCLOB   <= 0
     C                   IF        O_FEBIDT   <> 0             OR
     C                             O_FEBCAT   <> 0
     C                   EVAL      O_FEBIDT    = 0
     C                   EVAL      O_FEBCAT    = 0
     C                   EVAL      O_FEBCSD    = 0
     C                   EVAL      O_FEBCDY    = 0
     C                   EVAL      O_FEBICC    = 0

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF

      ** - Else Principal Amount Exist;
      ** If End of Period Reached, Increment Classification

     C                   ELSE
     C                   IF        BPMTDL      = 'A'                                          263079
     C                   IF        O_FEBCAT    < 9               AND
     C                             DSBCD(O_FEBCAT+1) <> *BLANKS  AND
     C**********                   BJRDNB     >= O_FEBCSD + O_FEBCDY                        MD053837
     C                             WECD       >= O_FEBCSD + O_FEBCDY                        MD053837

     C                   IF        BPLCCY     <> *BLANKS       AND
     C                             BPAMNT     <> 0
     C                   EXSR      XRCLOAF

     C                   IF        BPPERC     <> 0
     C                   EVAL      DSCPAM_T    = DSCPAM_T * BPPERC
     C                   ENDIF
     C                   ENDIF

     C                   IF        BPLCCY      = *BLANKS       OR
     C                             BPLCCY     <> *BLANKS       AND
     C                             DSCPAM_T    > BPAMNT
     C                   EVAL      O_FEBCSD    = O_FEBCSD + O_FEBCDY
     C                   EVAL      O_FEBCAT   += 1
     C                   EVAL      O_FEBCDY    = DSBCE(O_FEBCAT)

     C                   EVAL      DSUPDATE    = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                263079
     C                   ENDIF
                                                                                          AR1097467A
     C                   ENDIF                                                            AR1097467A

     C                   ENDSR
      /EJECT
      *****************************************************************
      *  XRCLOAF - Retrieve Loan Details by Facility                  *
      *****************************************************************
     C     XRCLOAF       BEGSR

      ** Initialisation

     C                   EVAL      DSCPAM_T    = 0
      *                                                                                     MD053837
     C                   IF        W#TYPE = '*LOANBAS'                                      MD053837

      ** Retrieve All Loans for a Facility and Accumalate Principal

     C                   EVAL      KF_FCUS     = O_FCUS
     C                   EVAL      KF_FTYP     = O_FTYP
     C                   EVAL      KF_FSEQ     = O_FSEQ
     C**********         EVAL      KF_BRCA     = O_BRCA                                     MD053837
     C     KCLOAF        SETLL     CLOAF
     C     KCLOAF        READE(E)  CLOAF

     C                   DOW       NOT %EOF(CLOAF)
     C                   IF        F_LNRF     <> O_LNRF        AND
     C                             F_RECI      = 'D'
     C                   IF        BPLCCY      = F_CCY
     C                   EVAL      DSCPAM_T   += F_CPAM

     C                   ELSE
     C                   EVAL      @CYCD       = O_CCY
     C                   EXSR      XRSDCURR

     C                   EVAL      DSRATE1     = A6SPRT
     C                   EVAL      DSMDIN1     = A6MDIN
     C                   EVAL      DSCYDP1     = A6NBDP

     C                   IF        DSMDIN1     = 'M'
     C                   EVAL      DSRATE1     = 1/DSRATE1
     C                   ENDIF

     C                   EVAL      DSCPAM_T   += F_CPAM * (DSRATE1 / DSRATE2)
     C                   ENDIF
     C                   ENDIF

     C     KCLOAF        READE(E)  CLOAF
     C                   ENDDO
      *                                                                                     MD053837
     C                   ENDIF                                                              MD053837
      *                                                                                     MD053837
     C                   IF        W#TYPE = '*FEEBAS'                                       MD053837
      *                                                                                     MD053837
     C                   IF        O_FEFACL   <> 0                                          MD053837
     C                   EVAL      KF_FCUS     = O_FECNUM                                   MD053837
     C                   MOVEL     O_FEFACL      KF_FTYP                                    MD053837
     C                   MOVE      O_FEFACL      KF_FSEQ                                    MD053837
     C                   ELSE                                                               MD053837
     C                   EVAL      KP_LNRF     = O_FELOAN                                   MD053837
     C     KCLOAN        CHAIN(E)  CLOAN                                                    MD053837
     C                   IF        %FOUND(CLOAN)                                            MD053837
     C                   EVAL      KF_FCUS     = P_FCUS                                     MD053837
     C                   EVAL      KF_FTYP     = P_FTYP                                     MD053837
     C                   EVAL      KF_FSEQ     = P_FSEQ                                     MD053837
     C                   ENDIF                                                              MD053837
     C                   ENDIF                                                              MD053837
      *                                                                                     MD053837
     C     KCLOAF        SETLL     CLOAF                                                    MD053837
     C     KCLOAF        READE(E)  CLOAF                                                    MD053837
      *                                                                                     MD053837
     C                   DOW       NOT %EOF(CLOAF)                                          MD053837
     C                   IF        F_LNRF      = O_FEPLNR      AND                          MD053837
     C                             F_RECI      = 'D'                                        MD053837
     C                   IF        BPLCCY      = F_CCY                                      MD053837
     C                   EVAL      DSCPAM_T   += F_CPAM                                     MD053837
      *                                                                                     MD053837
     C                   ELSE                                                               MD053837
     C                   EVAL      @CYCD       = F_CCY                                      MD053837
     C                   EXSR      XRSDCURR                                                 MD053837
      *                                                                                     MD053837
     C                   EVAL      DSRATE1     = A6SPRT                                     MD053837
     C                   EVAL      DSMDIN1     = A6MDIN                                     MD053837
     C                   EVAL      DSCYDP1     = A6NBDP                                     MD053837
      *                                                                                     MD053837
     C                   IF        DSMDIN1     = 'M'                                        MD053837
     C                   EVAL      DSRATE1     = 1/DSRATE1                                  MD053837
     C                   ENDIF                                                              MD053837
      *                                                                                     MD053837
     C                   EVAL      DSCPAM_T   += F_CPAM * (DSRATE1 / DSRATE2)               MD053837
     C                   ENDIF                                                              MD053837
     C                   ENDIF                                                              MD053837
      *                                                                                     MD053837
     C     KCLOAF        READE(E)  CLOAF                                                    MD053837
     C                   ENDDO                                                              MD053837
      *                                                                                     MD053837
     C                   ENDIF                                                              MD053837

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ***XRLEFEEDL1*-*Retrieve*Origin*Fee*Details**********************                   AR1097467A
      *****************************************************************
     C*****XRLEFEEDL1    BEGSR                                                            AR1097467A
      *****************************************************************                   AR1097467A
      ***Retrieve*Details**********************************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C*****KLEFEEDL1     CHAIN(E)  LEFEEDL1                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        %ERROR                                                 AR1097467A
     C**********         EVAL      DBFILE      = 'LEFEEDL1'                               AR1097467A
     C**********         EVAL      DBKEY       = DSPDUF_K                                 AR1097467A
     C**********         EVAL      DBASE       = 520                                      AR1097467A
     C**********         EXSR      *PSSR                                                  AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        NOT %FOUND(LEFEEDL1)                                   AR1097467A
     C**********         CLEAR                   LEFEEDF                                  AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         ENDSR                                                            AR1097467A
      *****************************************************************
      /EJECT
      *****************************************************************
      *  XRSDCURR - Retrieve Currency Facility                        *
      *****************************************************************
     C     XRSDCURR      BEGSR

      ** Retrieve Details

     C**********         EVAL      #C          = %LOOKUP(@CYCD:DSCYCD)                     AR1097467
      *****************************************************************                    AR1097467
     C**********         IF        #C          > 0                                         AR1097467
     C**********         EVAL      SDCURR      = DSCURR(#C)                                AR1097467
      *****************************************************************                    AR1097467
     C**********         ELSE                                                              AR1097467
     C                   EVAL      SrcCcy = @CYCD                                          AR1097467
     C                   EXSR      CHKCCY                                                  AR1097467
                                                                                           AR1097467
     C                   IF        NOT CacheHit                                            AR1097467
                                                                                           AR1097467
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        @RTCD      <> *BLANKS
     C                   EVAL      DBFILE      = 'SDCURRPD'
     C                   EVAL      DBKEY       = @CYCD
     C                   EVAL      DBASE       = 530
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF                                                             AR1097467
     C**********         EVAL      #C          = %LOOKUP(' ':DSCYCD)                       AR1097467
      ***************************************************************                      AR1097467
     C**********         IF        #C          = 0                                         AR1097467
     C**********         EVAL      DBFILE      = 'SDCURRPD'                                AR1097467
     C**********         EVAL      DBKEY       = @CYCD                                     AR1097467
     C**********         EVAL      DBASE       = 531                                       AR1097467
     C**********         EXSR      *PSSR                                                   AR1097467
     C**********         ENDIF                                                             AR1097467
      ***************************************************************                      AR1097467
     C**********         EVAL      DSCYCD(#C)  = @CYCD                                     AR1097467
     C**********         EVAL      DSCURR(#C)  = SDCURR                                    AR1097467
     C**********         ENDIF                                                             AR1097467

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                    AR1097467
      *                                                               *                    AR1097467
      * ChkCcy - Check if Currency in Cache                           *                    AR1097467
      *                                                               *                    AR1097467
      *****************************************************************                    AR1097467
      *                                                                                    AR1097467
     C     CHKCCY        BEGSR                                                             AR1097467
                                                                                           AR1097467
      ** Only search cache if Search Key is not blank                                      AR1097467
      ** and cache not empty                                                               AR1097467
                                                                                           AR1097467
     C                   EVAL      CacheHit = False                                        AR1097467
     C                   IF        SrcCcy = *BLANKS OR                                     AR1097467
     C                             CcyIdx.Last = 0                                         AR1097467
     C                   LEAVESR                                                           AR1097467
     C                   ENDIF                                                             AR1097467
                                                                                           AR1097467
      ** Perform search if key is not the recent search                                    AR1097467
      ** otherwise, just resend the details from previous cache                            AR1097467
                                                                                           AR1097467
     C                   IF        SrcCcy = KeyCcy( CcyIdx.Prev )                          AR1097467
     C                   EVAL      CacheHit = True                                         AR1097467
     C                   EVAL      CcyIdx.Current = CcyIdx.Prev                            AR1097467
                                                                                           AR1097467
     C                   ELSE                                                              AR1097467
     C                   EVAL      CcyIdx.Current =                                        AR1097467
     C                                   %LOOKUP( SrcCcy                                   AR1097467
     C                                          : KeyCcy                                   AR1097467
     C                                          : 1 : CcyIdx.Last )                        AR1097467
     C                   IF        CcyIdx.Current > 0                                      AR1097467
     C                   EVAL      CacheHit = True                                         AR1097467
     C                   ENDIF                                                             AR1097467
                                                                                           AR1097467
     C                   ENDIF                                                             AR1097467
                                                                                           AR1097467
     C                   IF        CacheHit                                                AR1097467
     C                   EVAL      SDCURR = DSCcy( CcyIdx.Current )                        AR1097467
     C                   EVAL      CcyIdx.Prev = CcyIdx.Current                            AR1097467
     C                   ENDIF                                                             AR1097467
                                                                                           AR1097467
     C                   ENDSR                                                             AR1097467
      *****************************************************************                    AR1097467
      /EJECT                                                                               AR1097467
      *****************************************************************
      *  XUCLOANL4 - Update Origin Loan Details                       *
      *****************************************************************
     C     XUCLOANL4     BEGSR

      ** Update Details

     C                   UPDATE(E) CLOANCLF

     C                   IF        %ERROR
     C**********         EVAL      DBFILE      = 'CLOANL4'                                    263411
     C                   EVAL      DBFILE      = 'CLOANC'                                     263411
     C                   EVAL      DBKEY       = DSPDUE_KS
     C                   EVAL      DBASE       = 800
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  XUACUSL0 - Update Customer Details                           *
      *****************************************************************
     C     XUACUSL0      BEGSR


      ** Retrieve Customer Details

     C     KSDACUSL0     CHAIN(E)  SDACUSL1

     C                   IF        NOT %FOUND(SDACUSL1)        OR
     C                             %ERROR
     C                   EVAL      DBFILE      = 'SDACUSL1'
     C                   EVAL      DBKEY       = KE5CUST
     C                   EVAL      DBASE       = 810
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         IF        E5PDCU     <> 'Y'                                          263079
     C                   IF        A_E5PDCU    = *BLANK                                       263079
     C                   EVAL      A_E5PDCU    = 'Y'

     C                   UPDATE(E) @ACUSL1

     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'SDACUSL1'
     C                   EVAL      DBKEY       = A_E5CUST
     C                   EVAL      DBASE       = 811
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  XULEFEEDL1 - Update Origin Fee Details                       *
      *****************************************************************
     C     XULEFEEDL1    BEGSR

      ** Update Details

     C                   UPDATE(E) LEFEEDF

     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LEFEEDL1'
     C                   EVAL      DBKEY       = DSPDUF_KS
     C                   EVAL      DBASE       = 820
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *  *INZSR - Initialisation Rountine                             *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST                                                            AR1097467A
     C                   PARM                    W#TYPE                                   AR1097467A
                                                                                          AR1097467A
      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD      <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY       = '*FIRST'
     C                   EVAL      DBFILE      = 'SDBANKPD'
     C                   EVAL      DBASE       = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access ICD Details

     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY

     ** Load Currency Cache                                                                AR1097467
                                                                                           AR1097467
     C     *LOVAL        SETLL     SDCURRL1                                                AR1097467
     C                   READ      SDCURRL1      DSCcy(1)                                  AR1097467
     C                   DOW       NOT %EOF( SDCURRL1 ) AND                                AR1097467
     C                             ULIdx < ArrSzCcy                                        AR1097467
     C                   EVAL      ULIdx = ULIdx + 1                                       AR1097467
     C                   EVAL      KeyCcy( ULIdx ) =                                       AR1097467
     C                                DSCcy( ULIdx ).A6CYCD                                AR1097467
     C                   READ      SDCURRL1      DSCcy(ULIdx)                              AR1097467
     C                   ENDDO                                                             AR1097467
                                                                                           AR1097467
     C                   EVAL      CcyIdx.Last = ULIdx                                     AR1097467
                                                                                           AR1097467
      ** If Found;
      ** - Retrieve ICD Currency Details

     C                   IF        @RTCD       = *BLANKS
                                                                                            AR217905
     C                   IF        BPLCCY      = *BLANKS                                    AR217905
     C     *LOCK         IN        LDA                                                      AR217905
     C                   EVAL      DBKEY       = 'BPLCCY'                                   AR217905
     C                   EVAL      DBFILE      = 'SDCLNDPD'                                 AR217905
     C                   EVAL      DBASE       = 002                                        AR217905
     C                   OUT       LDA                                                      AR217905
     C                   EXSR      *PSSR                                                    AR217905
     C                   ELSE                                                               AR217905

     C                   EVAL      @CYCD       = BPLCCY
     C                   EXSR      XRSDCURR

     C                   EVAL      DSRATE2     = A6SPRT
     C                   EVAL      DSMDIN2     = A6MDIN
     C                   EVAL      DSCYDP2     = A6NBDP

     C                   IF        DSMDIN2     = 'M'
     C                   EVAL      DSRATE2     = 1/DSRATE2
     C                   ENDIF
      *                                                                                     MD053837
      ** Access General Ledger details                                                      MD053837
      *                                                                                     MD053837
     C                   CALL      'AOGELRR0'                                               MD053837
     C                   PARM      '*MSG   '     @RTCD                                      MD053837
     C                   PARM      '*FIRST '     @OPTN                                      MD053837
     C     SDGELR        PARM      SDGELR        DSFDY                                      MD053837
      *                                                                                     MD053837
     C     @RTCD         IFNE      *BLANKS                                                  MD053837
     C     *LOCK         IN        LDA                                                      MD053837
     C                   EVAL      DBKEY       = '*FIRST'                                   MD053837
     C                   EVAL      DBFILE      = 'SDGELRPD'                                 MD053837
     C                   EVAL      DBASE       = 003                                        MD053837
     C                   OUT       LDA                                                      MD053837
     C                   EXSR      *PSSR                                                    MD053837
     C                   ENDIF                                                              MD053837
      *                                                                                     MD053837
      ** Set up event control date                                                          MD053837
      *                                                                                     MD053837
     C                   Z-ADD     BJDNWD        WECD              5 0                      MD053837
     C                   SUB       1             WECD                                       MD053837
      *                                                                                     MD053837
     C     BKAPDT        IFLE      WECD                                                     MD053837
     C                   Z-ADD     BKAPDT        WECD                                       MD053837
     C                   ENDIF                                                              MD053837

      ** - Set Basel II Classification Period Description & Days Arrays

     C                   EVAL      DSBCD(1)    = BPCLD1
     C                   EVAL      DSBCD(2)    = BPCLD2
     C                   EVAL      DSBCD(3)    = BPCLD3
     C                   EVAL      DSBCD(4)    = BPCLD4
     C                   EVAL      DSBCD(5)    = BPCLD5
     C                   EVAL      DSBCD(6)    = BPCLD6
     C                   EVAL      DSBCD(7)    = BPCLD7
     C                   EVAL      DSBCD(8)    = BPCLD8
     C                   EVAL      DSBCD(9)    = BPCLD9

     C                   EVAL      DSBCN(1)    = BPCLN1
     C                   EVAL      DSBCN(2)    = BPCLN2
     C                   EVAL      DSBCN(3)    = BPCLN3
     C                   EVAL      DSBCN(4)    = BPCLN4
     C                   EVAL      DSBCN(5)    = BPCLN5
     C                   EVAL      DSBCN(6)    = BPCLN6
     C                   EVAL      DSBCN(7)    = BPCLN7
     C                   EVAL      DSBCN(8)    = BPCLN8
     C                   EVAL      DSBCN(9)    = BPCLN9

      ** - Determine Number of Days in Each Period

     C                   EVAL      DSBCE       = *ALL'999'
     C                   EVAL      DSBCE(1)    = DSBCN(1)

     C     2             DO        9             #A
     C                   IF        DSBCN(#A)   = 0
     C                   EVAL      DSBCN(#A)   = 999
     C                   ENDIF

     C                   IF        DSBCN(#A)   < 999
     C                   EVAL      DSBCE(#A)   = DSBCN(#A) - DSBCN(#A-1)
     C                   ENDIF
     C                   ENDDO

      ** - Set Reporting Classification Period Description & Days Array

     C                   EVAL      DSRCD(1)    = BPRCD1
     C                   EVAL      DSRCD(2)    = BPRCD2
     C                   EVAL      DSRCD(3)    = BPRCD3
     C                   EVAL      DSRCD(4)    = BPRCD4
     C                   EVAL      DSRCD(5)    = BPRCD5
     C                   EVAL      DSRCD(6)    = BPRCD6
     C                   EVAL      DSRCD(7)    = BPRCD7
     C                   EVAL      DSRCD(8)    = BPRCD8
     C                   EVAL      DSRCD(9)    = BPRCD9

     C                   EVAL      DSRCN(1)    = BPRCN1
     C                   EVAL      DSRCN(2)    = BPRCN2
     C                   EVAL      DSRCN(3)    = BPRCN3
     C                   EVAL      DSRCN(4)    = BPRCN4
     C                   EVAL      DSRCN(5)    = BPRCN5
     C                   EVAL      DSRCN(6)    = BPRCN6
     C                   EVAL      DSRCN(7)    = BPRCN7
     C                   EVAL      DSRCN(8)    = BPRCN8
     C                   EVAL      DSRCN(9)    = BPRCN9

      ** - Determine Number of Days in Each Period

     C                   EVAL      DSRCE       = *ALL'999'
     C                   EVAL      DSRCE(1)    = DSRCN(1)

     C     2             DO        9             #A
     C                   IF        DSRCN(#A)   = 0
     C                   EVAL      DSRCN(#A)   = 999
     C                   ENDIF

     C                   IF        DSRCN(#A)   < 999
     C                   EVAL      DSRCE(#A)   = DSRCN(#A) - DSRCN(#A-1)
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF                                                              AR217905
     C                   ENDIF

      ** Move processing to component LEC004781                                           AR1097467A
                                                                                          AR1097467A
      ***Reset*Past*Due*Customer*Flag**********************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        BPMTDL      = 'A'                               263079 AR1097467A
     C**********         READ(E)   SDACUSL6                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(SDACUSL6)                                     AR1097467A
     C**********         EVAL      E5PDCU      = 'N'                                          263079
     C**********         EVAL      E5PDCU      = *BLANK                            263079 AR1097467A
      **********                                                                          AR1097467A
     C**********         UPDATE(E) SDACUSD0                                               AR1097467A
      **********                                                                          AR1097467A
     C**********         IF        %ERROR                                                 AR1097467A
     C**********         EVAL      DBFILE      = 'SDACUSL6'                               AR1097467A
     C**********         EVAL      DBKEY       = E5CUST                                   AR1097467A
     C**********         EVAL      DBASE       = 010                                      AR1097467A
     C**********         EXSR      *PSSR                                                  AR1097467A
     C**********         ENDIF                                                            AR1097467A
      **********                                                                          AR1097467A
     C**********         READ(E)   SDACUSL6                                               AR1097467A
     C**********         ENDDO                                                            AR1097467A
     C**********         ENDIF                                                     263079 AR1097467A

      ** Move processing to component LEC004782                                           AR1097467A
                                                                                          AR1097467A
      ***Populate*Loans*PDCL*History*File******************************                   AR1097467A
      ***-*Generate*historical*events*for*each*PDCL*for*the*Origin*Loan                   AR1097467A
      ***Repayment*Value*Date******************************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C******LOVAL        SETLL     LEPDUEL9                                               AR1097467A
     C**********         READ(E)   LEPDUEL9                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(LEPDUEL9)                                     AR1097467A
     C**********         EVAL      D_YPRECI    = 'D'                                      AR1097467A
     C**********         EVAL      D_YPORG     = YPORG                                    AR1097467A
     C**********         EVAL      D_YPLON     = YPLON                                    AR1097467A
     C**********         EVAL      D_YPDVDT    = YPDVDT                                   AR1097467A
     C**********         EVAL      D_YPCPAM    = YPCPAM                                   AR1097467A
     C**********         EVAL      D_YPDINT    = YPDINT                                   AR1097467A
     C**********         EVAL      D_YPMOVA    = 0                                        AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        DSPDUE_KS  <> DSPDUE_K                                 AR1097467A
     C**********         EVAL      DSPDUE_KS   = DSPDUE_K                                 AR1097467A
     C**********         EVAL      DSPDCLREF   = *BLANKS                                  AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
      ***Accumulate*Remaining*Events*for*Repayment*Value*Date**********                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         READ(E)   LEPDUEL9                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(LEPDUEL9)          AND                        AR1097467A
     C**********                   D_YPORG     = YPORG         AND                        AR1097467A
     C**********                   D_YPLON     = YPLON         AND                        AR1097467A
     C**********                   D_YPDVDT    = YPDVDT                                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPCPAM   += YPCPAM                                   AR1097467A
     C**********         EVAL      D_YPDINT   += YPDINT                                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         READ(E)   LEPDUEL9                                               AR1097467A
     C**********         ENDDO                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      DSPVDVDT    = YPDVDT                                   AR1097467A
      *****************************************************************                   AR1097467A
      ***Evaluate*Opening/Closing*Balance******************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EXSR      XEVDOPNBAL                                             AR1097467A
      *****************************************************************                   AR1097467A
      ***Write*Balance*Record*&*Set*Variables*for*Next*Cycle***********                   AR1097467A
      **********                                                                          AR1097467A
     C**********         WRITE(E)  LEPDLHD0                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPCLOB    = D_YPOPNB                                 AR1097467A
     C**********         ENDDO                                                            AR1097467A
      *****************************************************************                   AR1097467A
      ***-*Generate*historical*Total*events*for*each*Origin*Loan*on****                   AR1097467A
      ***Repayment*Value*Date******************************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPOPNB    = 0                                        AR1097467A
     C**********         EVAL      D_YPMOVA    = 0                                        AR1097467A
     C**********         EVAL      D_YPCLOB    = 0                                        AR1097467A
     C**********         EVAL      DSPDSDT     = 0                                        AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      KT_YPRECI   = 'D'                                      AR1097467A
     C*****KLEPDLHL1B    SETLL     LEPDLHL1                                               AR1097467A
     C*****KLEPDLHL1B    READE(E)  LEPDLHL1                                               AR1097467A
     C**********         EVAL      DSPDLH_KS   = DSPDLH_K                                 AR1097467A
     C**********         CLEAR                   LEPDLHD0                                 AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(LEPDLHL1)                                     AR1097467A
     C**********         EVAL      D_YPRECI    = 'T'                                      AR1097467A
     C**********         EVAL      D_YPORG     = T_YPORG                                  AR1097467A
     C**********         EVAL      D_YPDVDT    = T_YPDVDT                                 AR1097467A
     C**********         EVAL      D_YPOPNB   += T_YPOPNB                                 AR1097467A
     C**********         EVAL      D_YPMOVA   += T_YPMOVA                                 AR1097467A
     C**********         EVAL      D_YPCLOB   += T_YPCLOB                                 AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        D_YPOPNB   <= 0             AND                        AR1097467A
     C**********                   D_YPCLOB    > 0             OR                         AR1097467A
     C**********                   D_YPOPNB    > 0             AND                        AR1097467A
     C**********                   DSPDSDT     = 0                                        AR1097467A
     C**********         EVAL      DSPDSDT     = T_YPDVDT                                 AR1097467A
      *****************************************************************                   AR1097467A
     C**********         ELSE                                                             AR1097467A
     C**********         IF        D_YPOPNB   <= 0             AND                        AR1097467A
     C**********                   D_YPCLOB   <= 0                                        AR1097467A
     C**********         EVAL      DSPDSDT     = 0                                        AR1097467A
     C**********         ENDIF                                                            AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPDSDT    = DSPDSDT                                  AR1097467A
      *****************************************************************                   AR1097467A
     C*****KLEPDLHL1B    READE(E)  LEPDLHL1                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        DSPDLH_KS  <> DSPDLH_K      OR                         AR1097467A
     C**********                   DSYPDVDT   <> T_YPDVDT      OR                         AR1097467A
     C**********                   %EOF(LEPDLHL1)                                         AR1097467A
      *****************************************************************                   AR1097467A
     C**********         WRITE(E)  LEPDLHD0                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        DSPDLH_KS  <> DSPDLH_K                                 AR1097467A
     C**********         EVAL      DSPDLH_KS   = DSPDLH_K                                 AR1097467A
     C**********         EVAL      DSPDSDT     = 0                                        AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      DSYPDVDT    = T_YPDVDT                                 AR1097467A
     C**********         CLEAR                   LEPDLHD0                                 AR1097467A
     C**********         ENDIF                                                            AR1097467A
     C**********         ENDDO                                                            AR1097467A

      ** Move processing to LEC004783                                                     AR1097467A
                                                                                          AR1097467A
      ***Populate*Fees*PDCL*History*File*******************************                   AR1097467A
      ***-*Generate*historical*events*for*each*PDCL*for*the*Origin*Fee*                   AR1097467A
      ***Repayment*Value*Date******************************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C******LOVAL        SETLL     LEPDUFL9                                               AR1097467A
     C**********         READ(E)   LEPDUFL9                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(LEPDUFL9)                                     AR1097467A
     C**********         EVAL      D_YPRECI    = 'D'                                      AR1097467A
     C**********         EVAL      D_YECNUM    = YECNUM                                   AR1097467A
     C**********         EVAL      D_YEFACL    = YEFACL                                   AR1097467A
     C**********         EVAL      D_YESEQ     = YESEQ                                    AR1097467A
     C**********         EVAL      D_YPORG     = YPORG2                                   AR1097467A
     C**********         EVAL      D_YBRCA     = YBRCA2                                   AR1097467A
     C**********         EVAL      D_YPLON     = YPLON                                    AR1097467A
     C**********         EVAL      D_YPDVDT    = YPDVDT                                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPCPAM    = YPCPAM                                   AR1097467A
     C**********         EVAL      D_YPDINT    = YPDINT                                   AR1097467A
     C**********         EVAL      D_YPMOVA    = 0                                        AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        DSPDUF_KS  <> DSPDUF_K                                 AR1097467A
     C**********         EVAL      DSPDUF_KS   = DSPDUF_K                                 AR1097467A
     C**********         EVAL      DSPDCLREF   = *BLANKS                                  AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
      ***Accumulate*Remaining*Events*for*Repayment*Value*Date**********                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         READ(E)   LEPDUFL9                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(LEPDUFL9)          AND                        AR1097467A
     C**********                   D_YECNUM    = YECNUM        AND                        AR1097467A
     C**********                   D_YEFACL    = YEFACL        AND                        AR1097467A
     C**********                   D_YESEQ     = YESEQ         AND                        AR1097467A
     C**********                   D_YPORG     = YPORG2        AND                        AR1097467A
     C**********                   D_YBRCA     = YBRCA2        AND                        AR1097467A
     C**********                   D_YPLON     = YPLON         AND                        AR1097467A
     C**********                   D_YPDVDT    = YPDVDT                                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPCPAM   += YPCPAM                                   AR1097467A
     C**********         EVAL      D_YPDINT   += YPDINT                                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         READ(E)   LEPDUFL9                                               AR1097467A
     C**********         ENDDO                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      DSPVDVDT    = YPDVDT                                   AR1097467A
      *****************************************************************                   AR1097467A
      ***Evaluate*Opening/Closing*Balance******************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EXSR      XEVDOPNBAL                                             AR1097467A
      *****************************************************************                   AR1097467A
      ***Write*Balance*Record*&*Set*Variables*for*Next*Cycle***********                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         WRITE(E)  LEPDFHD0                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPCLOB    = D_YPOPNB                                 AR1097467A
     C**********         ENDDO                                                            AR1097467A
      *****************************************************************                   AR1097467A
      ***Generate*historical*Total*events*for*each*Origin*Fee*on*******                   AR1097467A
      ***Repayment*Value*Date******************************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPOPNB    = 0                                        AR1097467A
     C**********         EVAL      D_YPMOVA    = 0                                        AR1097467A
     C**********         EVAL      D_YPCLOB    = 0                                        AR1097467A
     C**********         EVAL      DSPDSDT     = 0                                        AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      KT_YPRECI   = 'D'                                      AR1097467A
     C*****KLEPDFHL1B    SETLL     LEPDFHL1                                               AR1097467A
     C*****KLEPDFHL1B    READE(E)  LEPDFHL1                                               AR1097467A
     C**********         EVAL      DSPDFH_KS   = DSPDFH_K                                 AR1097467A
     C**********         CLEAR                   LEPDFHD0                                 AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(LEPDFHL1)                                     AR1097467A
     C**********         EVAL      D_YPRECI    = 'T'                                      AR1097467A
     C**********         EVAL      D_YECNUM    = T_YECNUM                                 AR1097467A
     C**********         EVAL      D_YEFACL    = T_YEFACL                                 AR1097467A
     C**********         EVAL      D_YESEQ     = T_YESEQ                                  AR1097467A
     C**********         EVAL      D_YPORG     = T_YPORG2                                 AR1097467A
     C**********         EVAL      D_YBRCA     = T_YBRCA2                                 AR1097467A
     C**********         EVAL      D_YPLON     = T_YPLON                                  AR1097467A
     C**********         EVAL      D_YPDVDT    = T_YPDVDT2                                AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPOPNB   += T_YPOPNB                                 AR1097467A
     C**********         EVAL      D_YPMOVA   += T_YPMOVA                                 AR1097467A
     C**********         EVAL      D_YPCLOB   += T_YPCLOB                                 AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        D_YPOPNB   <= 0             AND                        AR1097467A
     C**********                   D_YPCLOB    > 0             OR                         AR1097467A
     C**********                   D_YPOPNB    > 0             AND                        AR1097467A
     C**********                   DSPDSDT     = 0                                        AR1097467A
     C**********         EVAL      DSPDSDT     = T_YPDVDT2                                AR1097467A
      *****************************************************************                   AR1097467A
     C**********         ELSE                                                             AR1097467A
     C**********         IF        D_YPOPNB   <= 0             AND                        AR1097467A
     C**********                   D_YPCLOB   <= 0                                        AR1097467A
     C**********         EVAL      DSPDSDT     = 0                                        AR1097467A
     C**********         ENDIF                                                            AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      D_YPDSDT    = DSPDSDT                                  AR1097467A
      *****************************************************************                   AR1097467A
     C*****KLEPDFHL1B    READE(E)  LEPDFHL1                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        DSPDFH_KS  <> DSPDFH_K      OR                         AR1097467A
     C**********                   DSYPDVDT   <> T_YPDVDT2     OR                         AR1097467A
     C**********                   %EOF(LEPDLHL1)                                         AR1097467A
      *****************************************************************                   AR1097467A
     C**********         WRITE(E)  LEPDFHD0                                               AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        DSPDFH_KS  <> DSPDFH_K                                 AR1097467A
     C**********         EVAL      DSPDFH_KS   = DSPDFH_K                                 AR1097467A
     C**********         EVAL      DSPDSDT     = 0                                        AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      DSYPDVDT    = T_YPDVDT2                                AR1097467A
     C**********         CLEAR                   LEPDFHD0                                 AR1097467A
     C**********         ENDIF                                                            AR1097467A
     C**********         ENDDO                                                            AR1097467A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **XEVDOPNBAL*-*Evaluate*Value*Date*Opening*Balance***************                   AR1097467A
      *****************************************************************
     C*****XEVDOPNBAL    BEGSR                                                            AR1097467A
      *****************************************************************                   AR1097467A
      ***Set*Opening/Closing*Balance***********************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        DSPDCLREF  <> D_YPLON                                  AR1097467A
     C**********         EVAL      DSPDCLREF   = D_YPLON                                  AR1097467A
     C**********         EVAL      D_YPOPNB    = 0                                        AR1097467A
     C**********         EVAL      D_YPCLOB    = 0                                        AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      KP_LNRF     = D_YPLON                                  AR1097467A
     C*****KCLOAN        CHAIN(E)  CLOAN                                                  AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        %FOUND(CLOAN)                                          AR1097467A
     C**********         EVAL      D_YPOPNB    = P_CPAM                                   AR1097467A
     C**********         EVAL      D_YPCLOB    = P_CPAM                                   AR1097467A
     C**********         ENDIF                                                            AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
      ***Adjust*Opening*Balance****************************************                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         EVAL      KH_LNRF     = D_YPLON                                  AR1097467A
     C**********         EVAL      KH_VDAT     = D_YPDVDT                                 AR1097467A
     C*****KHISTSL0      SETGT     HISTSL0                                                AR1097467A
     C*****KHISTSL0A     READPE(E) HISTSL0                                                AR1097467A
      *****************************************************************                   AR1097467A
     C**********         DOW       NOT %EOF(HISTSL0)           AND                        AR1097467A
     C**********                   H_VDAT      > DSPVDVDT                                 AR1097467A
      *****************************************************************                   AR1097467A
     C**********         IF        H_AMTP      = 'MR'          OR                         AR1097467A
     C**********                   H_AMTP      = 'MA'          OR                         AR1097467A
     C**********                   H_AMTP      = 'PF'          OR                         AR1097467A
     C**********                   H_AMTP      = 'RE'                                     AR1097467A
     C**********         EVAL      D_YPMOVA   -= H_PRAM                                   AR1097467A
     C**********         EVAL      D_YPOPNB   += H_PRAM                                   AR1097467A
      *****************************************************************                   AR1097467A
     C**********         ELSE                                                             AR1097467A
     C**********         EVAL      D_YPMOVA   += H_PRAM                                   AR1097467A
     C**********         EVAL      D_YPOPNB   -= H_PRAM                                   AR1097467A
     C**********         ENDIF                                                            AR1097467A
      *****************************************************************                   AR1097467A
     C*****KHISTSL0A     READPE(E) HISTSL0                                                AR1097467A
     C**********         ENDDO                                                            AR1097467A
      **********                                                                          AR1097467A
     C**********         ENDSR                                                            AR1097467A
      *****************************************************************
      /EJECT
      *****************************************************************
      *  @DEFN - Definition Rountine                                  *
      *****************************************************************
     C     @DEFN         BEGSR

      ** Entry List

      ** Key List

     C     KCLOAF        KLIST
     C                   KFLD                    KF_FCUS
     C                   KFLD                    KF_FTYP
     C                   KFLD                    KF_FSEQ
     C**********         KFLD                    KF_BRCA                                    MD053837

     C     KCLOANL4      KLIST
     C**********         KFLD                    Ko_RECI                                      263411
     C                   KFLD                    KO_LNRF

     C     KCLOAN        KLIST
     C                   KFLD                    KP_LNRF

     C     KHISTSL0      KLIST
     C                   KFLD                    KH_LNRF
     C                   KFLD                    KH_VDAT

     C     KHISTSL0A     KLIST
     C                   KFLD                    KH_LNRF

     C     KLEFEEDL1     KLIST
     C                   KFLD                    KO_FECNUM
     C                   KFLD                    KO_FEFACL
     C                   KFLD                    KO_FELOAN
     C                   KFLD                    KO_FEFSEQ

     C     KLEPDLHL1     KLIST
     C                   KFLD                    KT_YPRECI
     C                   KFLD                    KT_YPORG
     C                   KFLD                    KT_YPDVDT

     C     KLEPDLHL1A    KLIST
     C                   KFLD                    KT_YPRECI
     C                   KFLD                    KT_YPORG

     C     KLEPDLHL1B    KLIST
     C                   KFLD                    KT_YPRECI

     C     KLEPDFHL1     KLIST
     C                   KFLD                    KT_YPRECI
     C                   KFLD                    KT_YECNUM
     C                   KFLD                    KT_YEFACL
     C                   KFLD                    KT_YESEQ
     C                   KFLD                    KT_YPORG2
     C                   KFLD                    KT_YBRCA2
     C                   KFLD                    KT_YPDVDT2

     C     KLEPDFHL1A    KLIST
     C                   KFLD                    KT_YPRECI
     C                   KFLD                    KT_YECNUM
     C                   KFLD                    KT_YEFACL
     C                   KFLD                    KT_YESEQ
     C                   KFLD                    KT_YPORG2
     C                   KFLD                    KT_YBRCA2

     C     KLEPDFHL1B    KLIST
     C                   KFLD                    KT_YPRECI

     C     KSDACUSL0     KLIST
     C                   KFLD                    KE5CUST

     C                   ENDSR

     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
     OCLOANCLF  E            OCLOAN                                                         MD021823
     O                       O_FPNR                                                         MD021823
**  CPY@
(c) Finastra International Limited 2012
