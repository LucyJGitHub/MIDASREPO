     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - DB update')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEPDCLUPD  - Midas LE Past Due Call Loan                     *
      *               database update                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE164             Date 18Aug14               *
      *  Prev Amend No. AR1054914          Date 19Aug14               *
      *                 AR1001250          Date 06Jun13               *
      *                 AR827807           Date 24Apr13               *
      *                 AR826115           Date 07Dec12               *
      *                 AR706513A          Date 05Jul12               *
      *                 CLE148             Date 05Jul12               *
      *                 AR724682           Date 01Aug12               *
      *                 AR719589           Date 01Aug12               *
      *                 AR705750           Date 01Aug12               *
      *                 AR551942           Date 01Aug12               *
      *                 AR549587           Date 01Aug12               *
      *                 AR317473B          Date 01Aug12               *
      *                 AR467031           Date 01Aug12               *
      *                 AR317473A          Date 01Aug12               *
      *                 AR322731           Date 01Aug12               *
      *                 AR322571           Date 01Aug12               *
      *                 AR321628           Date 01Aug12               *
      *                 AR317473           Date 01Aug12               *
      *                 AR214141A          Date 01Aug12               *
      *                 263840             Date 01Aug12               *
      *                 263415             Date 01Aug12               *
      *                 263412             Date 01Aug12               *
      *                 263360             Date 01Aug12               *
      *                 263289             Date 01Aug12               *
      *                 263228             Date 01Aug12               *
      *                 262967             Date 01Aug12               *
      *                 262871             Date 01Aug12               *
      *                 262851             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR1054914 - CLE134: Wrong book in ZZ PDCL. Populate fee loan *
      *              book code with book code of loan from PF/CLOANCL.*
      *            - Applied for MD025682                             *
      *  AR1001250 - CLE148: FEE PDCL not displayed in projected      *
      *              account movements. Update the value of SDST and  *
      *              MDST after populating the value of PSTM and RSTM *
      *              fields. (Child: AR1001251)                       *
      *  AR827807 - Loan Fee PDCL does not default sequence number    *
      *             from Facility. SFDC00572444 (Child: AR827808)     *
      *  AR826115 - Component LEC0456 failed due to DBERR 10 in file  *
      *             SDBSRTPD. Removed validation of BPBRCF to prevent *
      *             database error when BPBRCF='N'. (Child: AR826116) *
      *  AR706513A - Branch not populated for PDCL created for fee for*
      *              settlement 05. Corrected mapping of fields.      *
      *              (Child: AR719825A)                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR724682 - COB component LEC06 10011 failed with DB erro on  *
      *             LE0461                                            *
      *           - Renamed variables for LEFCAML3 to prevent         *
      *             incorrect update on FCLTYFN (Child: AR724683)     *
      *  AR719589 - Wrong base rate change indicator for PDCL (fee)   *
      *           - Fix is to use the correct variable AUBSRI from    *
      *             SDFEEPD  (Child: AR719590)                        *
      *  AR705750 - Use FCXR and FMDI of origin loan for PDCL for     *
      *             loan (Child: AR705927)                            *
      *  AR551942 - Impossible to reactivate Penalty default rate     *
      *             after deletion (Child: AR551943)                  *
      *  AR549587 - An error during Default Penalty Rate changing     *
      *             (Child: AR549657)                                 *
      *  AR317473B - Wrong projected movements (in addition to Defect *
      *              2018) (Child: AR317474)                          *
      *  AR467031  - Wrong Outstanding Interest amount for PDCL after  *
      *              (Child: AR467032)                                 *
      *  AR317473A - Wrong projected movements (in addition to Defect *
      *              2018) (Child: AR317474)                          *
      *  AR322731 - LEC0212A job on MSGW because APISERVER is locking *
      *             CLOAN (Child: AR322732)                           *
      *  AR322571 - Wrong PDCL account seq. no. (Child: AR322572)     *
      *  AR321628 - Unable to create specific PDCL (Child: AR321629)  *
      *  AR317473 - Wrong projected movements (in addition to Defect  *
      *             2018) (Child: AR317474)                           *
      *  AR214141A - LE0457 was crashing in our Past due test system  *
      *              (Child: AR214147)                                *
      *  263840 - Ensure CAMD and OAMn fields are updated correctly   *
      *  263415 - Allow for a PDCL for Interest only                  *
      *  263412 - Wrong update of YPOSEQ when MR is created           *
      *  263360 - PDCL for interest creation with wrong amount        *
      *  263289 - FSEQ is Fee Sequence not Facility Sequence          *
      *  263228 - Incorrect interest rate value                       *
      *  262967 - The value date of the original loan Manual          *
      *           Repayment should match the value date of the PDCLs  *
      *  262871 - LOAMSZ1 Trailer error                               *
      *  262851 - Interest PDCL error                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *           CC03: Generation of Past Due Call Loans for Fees    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Loan Amendments for Updating
     FLOAMS     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(LA_)
 
      ** Loans file C
     FCLOAN     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(C1)
 
      ** Customer Lending Facility file
     FFCLTY     UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
 
      ** Fees file - update
     FLEFEEDL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      ** Loan Transaction Index Detail
     F***LTRIX**     UF   F   43        DISK    COMMIT                                      AR322731
     FLTRIX     O  A F   45        DISK    COMMIT                                           AR322731
     F                                     INFSR(*PSSR)
     F                                     INFDS(FLDTX)
 
      ** Loan Link file
     FLEPDUEPD  O    E             DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      ** Fee Link file
     FLEPDUFPD  O    E             DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      ** Record extension
     FCLONCLQD  O    E             DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      ** Penalties file
     FLEPRATL1  IF   E           K DISK
 
      ** Midas historic base rates by code + date
     FSDBSHSL1  IF   E           K DISK
 
      ** Midas PM Portfolio Defns by Front Office ID
     FPMPORTL1  IF   E           K DISK
 
      ** SD Branch Codes by Customer Number
     FSDBRCHL5  IF   E           K DISK
 
      ** LE Facility Amendements
     FLEFCAML3  IF   E           K DISK
     F                                     RENAME(LEFCAMPF:LEFCAMD3)
     F                                     PREFIX(FC_)                                      AR724682
 
      ** Loan Amendments for Updating
     FLELOMKL3  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(LOAMSDHF:LOMKSDHF)
     F                                     RENAME(LOAMSDKF:LOMKSDKF)
     F                                     RENAME(LOAMSZ1F:LOMKSZ1F)
     F                                     PREFIX(LA_)
      *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
 
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
      ** For CCy Conversion
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)
 
     D***@BIC***         S              6    DIM(150)                                      AR214141A
     D @BIC            S              6    DIM(999)                                        AR214141A
     D SHSETT          S             40A
     D WFSEQ           S              2  0                                                    263289
 
     D                 DS
     D  WPRME                  1     12
     D  WLPFI                  1      1
     D  WPTFC                  2      7
     D  WPTFT                  8     10  0
     D  WPTFN                 11     12  0
 
     D DSBCN           S              3  0 INZ DIM(9)
     D DSBCE           S              3  0 INZ DIM(9)
 
     D DSRCN           S              3  0 INZ DIM(9)
     D DSRCE           S              3  0 INZ DIM(9)
 
      ** Data structure for database error message
     D                 DS
     D  WFCUS                         6
     D  WFTYP                         3  0
     D***WFSEQ**                       2  0                                                   263289
     D  WFCSQ                         2  0                                                    263289
     D  WDBKEY                       11
 
      ** Data structure of rundates
     D                 DS
     D  RUN0                   1      3P 0
     D  RUN1                   4      6P 0
     D  RUN2                   7      9P 0
     D  RUN3                  10     12P 0
     D  RUN4                  13     15P 0
     D  RUN5                  16     18P 0
     D  RUN6                  19     21P 0
     D  RUN7                  22     24P 0
     D  RUN8                  25     27P 0
     D  RUN9                  28     30P 0
     D  RUNS                   1     30P 0
     D                                     DIM(10) ASCEND
 
      ** Data structure of drawn amounts
     D                 DS
     D  OAM1                   1      7P 0
     D  OAM2                   8     14P 0
     D  OAM3                  15     21P 0
     D  OAM4                  22     28P 0
     D  OAM5                  29     35P 0
     D  OAM6                  36     42P 0
     D  OAM7                  43     49P 0
     D  OAM8                  50     56P 0
     D  OAM9                  57     63P 0
     D  OA10                  64     70P 0
     D  OAM                    1     70P 0
     D                                     DIM(10)
 
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
 
      ** Work file of update to LE position files
     D Z#ASTK          DS          2048
     D Z#BSTK          DS          2048
 
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
      ** Output parameters on call to AOPLCSR1
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
 
      ** Fields used for update of MEMOS, PRONO etc
     D                 DS
     D  Z#ADTA                 1    256
     D  SHRECI                 1      1
     D  SHLNRF                 2      7
     D  SHVDAT                 8     12  0
     D  SHLASN                13     15  0
     D  SHPTYP                21     22
     D  SHAMTP                23     24
     D  SHCCY                 35     37
     D  SHPRAM                38     44P 0
     D  SHTAMT                66     72P 0
     D  SHBRCA                73     75
     D  SHREPT                82     82  0
     D  SHAUTO                83     83
     D  SHTIST                85    124
 
     D  Z#ADTB               257    512
     D  SHOSBR               261    263
     D  SHCHTP               317    317
 
     D  Z#ADTD               769   1024
     D  SHPNAM              1001   1007P 0
 
     D  Z#ADTE              1025   1280
     D  SHSCCY              1061   1063
     D  SHICCY              1064   1066
     D  SHREXR              1090   1096P 8
     D  SHREXI              1097   1097
     D  SHPSCY              1098   1100
     D  SHPEXR              1101   1107P 8
     D  SHPEXI              1108   1108
     D   SHSTAL             1109   1109
 
      ** Timestamp for the transaction
     D TimeStamp       S             26Z
 
      ** Externally desc'd DS for valid PDCL data
     D LEVPDCL       E DS                  EXTNAME(LEVPDCLPD)
 
      ** Current transaction record in file format Loan
     D PDCLFilFmtLoanE DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(C_)
 
      ** Current transaction record in file format Loan 2
     D PDCLFilFmtLoaKE DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)
 
      ** Current transaction record in file format Fee
     D PDCLFilFmtFee E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(E_)
 
      ** Current transaction record in file format Facility
     D PDCLFilFmtFctyE DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(M_)
 
      ** AO data structre
     D DSSDY         E DS
     D DSFDY         E DS
 
      ** Fee codes
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
 
      ** Currency Info
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Portfolio ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** Portfolio management customer details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
 
      ** Base Rate Info
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC2       E                     EXTFLD(QQDFAC)
 
      ** DS for getting the system prefix when CSC011 is installed
     D SC24X7        E DS                  EXTNAME(SC24X7)
 
      ** Branches Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for loan ICD details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
 
      ** Data structure for loan ICD details
     D SDLOAN1       E DS                  EXTNAME(SDLOANPD)
     D                                     PREFIX(@)
 
      ** Data structure for Lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** Data structure for Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Data structure for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Data structure for Next Available Loan Number
     D SDLENO        E DS                  EXTNAME(SDLENOPD)
 
      ** Externally desc'd DS for valid loan Details CL
     D LEVCliL       E DS                  EXTNAME(LEVCLILPD)
     D                                     PREFIX(L_)
 
      ** Externally desc'd DS for valid loan Details CL
     D LEVCliK       E DS                  EXTNAME(LEVCLIKPD)
     D                                     PREFIX(R_)
 
      ** Data Structure for PF/LTRIX
     D FLDTX           DS
     D  TXSTS            *STATUS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Dummy message ID and message file fields for use on the calls
      ** to ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D @@RTCD          S              7A
 
     D PFNCCD          S              8A
 
      ** Parameters for AOWLCCR0
     D PCUST           S             10A
     D PSTKEY          S              7A
 
      ** Parameters for AOCUSTR0
     D @Return         S              6A
     D @Type           S              1A
 
      ** Parameters for ZARTVJOBA
     D CSC011          S              1A
 
     D NBCDY           S              3  0
     D NBCSD           S              5  0
     D NRCDY           S              3  0
     D NRCSD           S              5  0
 
     D @@MODE          S              6A
     D @@RSMD          S              1A
     D ACTN            S              1A
     D FOTRID          S             20A
     D Ix              S              3P 0
 
     D C               S              2P 0
     D DBError         S            132A
     D MsgSndRtn       S             10A
 
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
 
     DTXT01            C                   CONST('Original Loan Ref ')
     DTXT02            C                   CONST('Original Fee  Ref ')
 
     D LOANTYPE        S              4A
 
      ** Setup keys for master files
     DWFECU            S              6
     DWFFAC            S              5  0
     DWFLNO            S              6
     DWLOAN            S              6
     DWFECD            S              2
     DWLTYP            S              2
     DWSUTP            S              2
     DWCLAS            S              4
     DWFACT            S              3  0
     DWFCNO            S              2  0
     DWRCDT            S              1
     DWLASN            S              3  0
     DWLSEQ            S                   LIKE(L_CLLASQ)
 
      ** System Value Parameter
     D SeqFlg          S              1A
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
 
      ** Work Variables
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWK2           S              4  0
     D ZZWK3           S             15  0
     D ZZNEGD          S              5
 
     D ZMDI1           S              1
     D ZRATE1          S             13  8
     D ZNBDP1          S              1  0
     D ZMDI2           S              1
     D ZRATE2          S             13  8
     D ZNBDP2          S              1  0
     D ZRATEX          S             13  8
     D ZMDIX           S              1
     D ZEXCH           S             13  8
     D ZMD             S              1
     D ZAMTCI          S             15  0
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0
 
     D WAMTP           S              2
     D WBRTT           S              2
     D WRTSP           S             11  7
     D WPRAM           S             13  0
     D WINTA           S             13  0
     D WTAMT           S             13  0
     D WSETP           S              2  0
     D WTSEN           S             10
     D PCURR           S              3
     D PBRAT           S              2
     D WBRTE           S             11  7
 
     D WNACD           S              1
     D WOSBR           S              3
     D WRSTM           S              2  0
     D WRIBN           S              8
     D WRIBA           S             35
     D WROBN           S              6
     D WROCN           S              6
     D WPSTM           S              2  0
     D WRCRN           S              8
     D WRCRA           S             35
     D WRONS           S             18
     D WPONS           S             18
     D WOSAC           S             18
     D WBASR           S             11  7
 
     D W#1ST3          S              3
     D W1ST11          S             11
 
     D*PCNEXT***       S              8  0                                                    CLE148
     D PCNEXT          S              8                                                       CLE148
 
     D WPCRF           S             15
 
     D @PRANG          S              2
 
     D @BRCA           S              3
 
     D PPTIN           S              1
     D PGNTF           S              1
     D PTDT1           S             35
     D PTDT2           S             35
     D PTDT3           S             35
     D PTREF           S             15
     D W#SEQ           S              4  0
 
     D ReservId        S             10
 
     D CallModCode     S              3
 
     D WAUTOA          S              1
     D WAUTOY          S              1
     D PFPTF           S              1
 
     D WPLON           S              6
 
     D WRK24           S             24
 
     D WrkPart         S              1
 
     D WRVCRC          S              1
     D WVLDT           S              5  0
 
     D CDPF            S              1  0
 
     D WSPRTF          S             13  8
     D WMDINF          S              1
 
     D SPRME           S             12
 
     D PRI1            S              1  0
 
     D ZDAYNO          S              5  0
     D ZNRDYS          S              2  0
     D ZDYNBR          S              5  0
     D ZCCY            S              3
     D ZLOC            S              3
 
     D NATN            S              5  0
 
     D RRNA            S              5  0
 
     D DDACTN          S              1
     D DDFRNT          S             20
     D WIUSR           S             10
 
     D RtnCode         S              7
 
     D CGL058          S              1
     D CLE002          S              1
     D CLE005          S              1
     D CLE009          S              1
     D CLE014          S              1
     D CLE023          S              1
     D CLE025          S              1
     D CLE028          S              1
     D CLE031          S              1
     D CEU004          S              1
 
     D WKLNR           S              6
     D WKVDT           S              5  0
     D WKLSN           S              3  0
 
     D WRCDT1          S              1
 
     D PLoanType       S              2
     D PLSubType       S              2
     D PLClass         S              4
 
     D WFCOD           S              2
 
     D @FECD           S              2
 
     D @KEY1           S              3
     D @KEY2           S              2
     D @KEY3           S             10
     D @CCY            S              3
     D @KYST           S              7
 
     D @BRCD           S              3
 
     D WRK_139         S             13  9
 
     D WMDINC          S              1
     D WSPRTC          S             13  8
 
     D PRTNC           S              1
     D PBOOK           S              2
     D PTRTP           S              5
     D PSUTP           S              2
     D PBRAN           S              3
     D PDEPT           S              3
     D PUSER           S             10
     D PACOF           S              2
     D PCNUM           S              6
     D PPRFC           S              4
 
     D WPTCS           S              1
 
     D WORLN           S              6
     D WLOANT          S              6
     D WFSEQT          S              2
     D WFACLT          S              5
 
     D WFCXR           S             13  8
     D WROFXR          S              1
 
     D OFCXRT          S             15  9
 
     D PRAM_Fac        S             13  0
 
     D WrkPRAMS        S             13  0
 
     D DAYNO           S              5  0
     D ENDAY           S              5  0
 
     D FCBAL           S             13  0
 
     D WKSWRI          S              1
 
     D WTCCY           S              3
     D WCMDI           S              1
     D WCAXR           S             13  8
 
     D WRVCRF          S              1
 
     D CDPC            S              1  0
 
     D WTRCA           S              1
 
     D ICUSTN          S              6
 
     D CX              S              1  0
     D I               S              3  0
     D X               S              2  0
     D W               S              3  0
 
     D AOOULE          S              1
     D SETT09          S              1
 
     D IN17            S              1
 
     D LXRRN           S              5  0
     D PRTCD           S              7                                                       CLE148
     D PUPDT           S              1                                                       CLE148
 
      ** Working DS with Amounts
     D                 DS
     D  PRAMR                  1     13  0
     D  INTAR                 14     26  0
     D  PNAMR                 27     39  0
     D  TAMTR                 40     52  0
     D  WTXAR                 53     65  0
     D  SAMT                   1     65
 
      ** Loan Amendment Current Amount in numeric  (on Valid format
      ** LOAMSDKF)
     D  OPRAM                 66     78  0
     D  OINTA                 79     91  0
     D  OPNAM                 92    104  0
     D  OTAMT                105    117  0
     D  OWTXA                118    130  0
     D  OAMT                  66    130
 
      ** Input Amount in numeric  (on Valid format LEVMAPY)
 
      ** Take on account - Principal
     D WTLPR           DS
     D  WKPABR                 1      3
     D  WKPACL                 4      9
     D  WKPACY                10     12
     D  WKPAAC                13     22  0
     D  WKPASE                23     24  0
 
      ** Take on account - Interest
     D WTLIN           DS
     D  WKIABR                 1      3
     D  WKIACL                 4      9
     D  WKIACY                10     12
     D  WKIAAC                13     22  0
     D  WKIASE                23     24  0
 
      ** Take on account - Fee
     D WPDFA           DS
     D  WKFABR                 1      3
     D  WKFACL                 4      9
     D  WKFACY                10     12
     D  WKFAAC                13     22  0
     D  WKFASE                23     24  0
 
      ** DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
 
     D  OldSettlDS     DS
 
      ** Old settlement details
     D  OSETP                  1      2  0
     D  OOSAC                  3     20
     D  OTSEN                 21     30
     D  OFACO                 31     40
     D  OLDSET                 1     40
 
     D  NewSettlDS     DS
 
      ** New settlement details
     D  WTYP                   1      2
     D  WOURS                  3     20
     D  WTHRS                 21     30
     D  WFACO                 31     40
     D  WSETT                  1     40
 
      ** Dummy timestamp
     D TimeStmpDS      DS
     D  RetYear                1      4A   INZ('0001')
     D                         5      5A   INZ('-')
     D  RetMonth               6      7A   INZ('01')
     D                         8      8A   INZ('-')
     D  RetDay                 9     10A   INZ('01')
     D                        11     11A   INZ('-')
     D  RetHour               12     13A   INZ('00')
     D                        14     14A   INZ('.')
     D  RetMin                15     16A   INZ('00')
     D                        17     17A   INZ('.')
     D  RetSec                18     19A   INZ('00')
     D                        20     20A   INZ('.')
     D  RetMilli              21     23A   INZ('000')
     D  RetMicro              24     26A   INZ('000')
 
      ** LTRIX file
     I***LTRIX**     NS        1 CH                                                         AR322731
     I**********                        1    1  RECI                                        AR322731
     I**********                        2    2  RCDT                                        AR322731
     I**********                        3    8 0LNRF                                        AR322731
     I**********                   P    9   11 0NORE                                        AR322731
     I**********                   P   12   14 0FLSZ                                        AR322731
     I**********                   P   15   17 0RRLC                                        AR322731
     I**********                   P   18   20 0RRNA                                        AR322731
     I**********                   P   21   23 0RRLX                                        AR322731
     I**********                   P   24   26 0RRXP                                        AR322731
     I**********                   P   27   29 0NLNR                                        AR322731
     I**********                   P   30   32 0NLAR                                        AR322731
     I**********                       33   33 0STPI                                        AR322731
     I**********                   P   38   40 0TNLU                                        AR322731
 
      ** Loan transactions index file - Detail record
     I***LTRIX**     NS        1 CD    2 CA                                                 AR322731
     I*********OR         1 CD    2 CL                                                      AR322731
      ** Loans transactions index file - Catchall                                           AR322731
     I**********                        1    1  RECI                                        AR322731
     I**********                        2    2  RCDT                                        AR322731
     I**********                        3    8 0LNRF                                        AR322731
     I**********                        9   13 0VDAT                                        AR322731
     I**********                       14   16 0LASN                                        AR322731
     I**********                       17   17  CHTP                                        AR322731
     I**********                       18   18  CNRQ                                        AR322731
     I**********                       19   19  CNPR                                        AR322731
     I**********                       20   20  REPR                                        AR322731
     I**********                       21   25 0RRLA                                        AR322731
     I**********                       26   26  LADI                                        AR322731
     I**********                       27   27 0PRI1                                        AR322731
     I**********                   P   35   37 0RRNT                                        AR322731
     I**********                   P   38   40 0TNLU                                        AR322731
      ** Loans transactions index file - Catchall
     I**********NS
     I**********                        1    1  RECI                                        AR322731
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Insert transaction
 
     C                   IF        DDACTN = 'I'
 
     C                   IF        RecordType = Loan
 
      ** Process LOAN for PRINCIPAL
 
     C     NSEIN         IFEQ      'N'                                                        263415
     C     NSEIN         OREQ      'Y'                                                        263415
     C     NPDPR         ANDNE     0                                                          263415
     C                   EXSR      LOANPRINC
     C                   ENDIF                                                                263415
 
     C                   IF        NSEIN = 'Y'
     C                             AND NPDIN <> 0                                             263415
 
      ** Process LOAN for INTEREST
 
     C                   EXSR      LOANINTER
 
     C                   ENDIF
 
      ** Process LOAN AMENDMENTS
 
     C                   EXSR      SETLOAMS
 
     C                   ELSE
 
      ** Process FEE for AMOUNT
 
     C                   EXSR      FEEAMOUNT
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Exit from Program
 
     C     EXIT          TAG
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LOANPRINC - Process the Principal for the LOAN PDCL           *
      *                                                               *
      *****************************************************************
 
     C     LOANPRINC     BEGSR
 
      ** Prepare static data
 
     C                   EXSR      SETLOANP
 
      ** Assign new loan number
 
     C                   EXSR      ACS_NXTAVL
 
      ** Set up the link record for the Principal
 
     C                   EXSR      SETLEPDUEPD1
 
      ** Set up new CLOANCL/CK data
 
     C                   EXSR      SETCLOANCx
 
      ** Write new loan
 
     C                   EXSR      SETCLIPUPD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTRAL  -  Update Loan Amendments Trailer File                *
      *                                                               *
      *****************************************************************
 
     C     SRTRAL        BEGSR
 
     C     DDACTN        IFEQ      'I'
 
      ** CLE134 loan amendments trailer
 
     C                   MOVE      *BLANKS       WKLNR
     C                   MOVE      *BLANKS       WKVDT
     C                   MOVE      *BLANKS       WKLSN
 
     C     KLAKEY        CHAIN     LELOMKL3                           89
 
      ** The record does not exist, file cleared
 
     C     *IN89         IFEQ      *ON
     C                   MOVE      'H'           LA_RECI
     C                   MOVEL     *BLANKS       LA_LNRF
     C                   Z-ADD     *ZEROS        LA_VDAT
     C                   Z-ADD     *ZEROS        LA_LASN
     C                   Z-ADD     *ZEROS        LA_EVCD
     C                   MOVE      *BLANKS       LA_PAQI
     C                   Z-ADD     *ZEROS        LA_PELAP
     C                   MOVE      *BLANKS       LA_ZZ002
     C                   MOVE      *BLANKS       LA_ZZ289
     C                   Z-ADD     *ZEROS        LA_LCD
     C                   MOVE      *BLANKS       LA_CHTP
     C                   Z-ADD     *ZEROS        LA_TNLU
     C                   WRITE     LOMKSDHF
     C                   ENDIF
 
      ** CLE134 loan amendments trailer
 
     C                   MOVE      '999999'      WKLNR
     C                   MOVE      '99999'       WKVDT
     C                   MOVE      '999'         WKLSN
 
     C     *LIKE         DEFINE    LA_VDAT       W#VDAT
     C     *LIKE         DEFINE    LA_LNRF       W#LNRF
     C                   Z-ADD     LA_VDAT       W#VDAT
     C                   MOVEL     LA_LNRF       W#LNRF
 
     C     KLAKEY        CHAIN     LELOMKL3                           89
 
      ** The record does not exist, file cleared
 
     C     *IN89         IFEQ      *ON
 
     C     KLAKEY        CHAIN     LOAMS                              88
 
      ** Loan amendments cleared, abort
 
     C     *IN88         IFEQ      *ON
 
     C                   MOVEL(P)  'LOAMS   '    DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVEL     '999999'      DBKEY
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** The CLE134 file is empty, set it up using the LOAMSZ1 file
      ** plus defaults
 
     C                   Z-ADD     1             LA_NORE
     C                   Z-ADD     1             LA_NINS
     C                   Z-ADD     1             LA_NLRA
     C                   Z-ADD     0             LA_NLRB
     C                   Z-ADD     1             LA_NINS
     C                   Z-ADD     1             LA_NDEL
     C                   Z-ADD     1             LA_NLRA
     C                   Z-ADD     0             LA_VLBF
     C                   Z-ADD     0             LA_VLBL
     C                   Z-ADD     0             LA_VRIF
     C                   Z-ADD     0             LA_VRIL
     C                   Z-ADD     0             LA_VRDF
     C                   Z-ADD     0             LA_VRDL
     C                   Z-ADD     0             LA_VRAF
     C                   Z-ADD     0             LA_VRAL
     C                   Z-ADD     0             LA_VRRF
     C                   Z-ADD     0             LA_VRRL
 
     C                   ENDIF
 
     C                   ELSE
 
     C     LA_NORE       ADD       1             LA_NORE
     C     LA_NINS       ADD       1             LA_NINS
     C     LA_NLRA       ADD       1             LA_NLRA
 
     C                   ENDIF
 
     C**********         MOVE      LA_PRAM       ZZAMT                                        262871
     C                   MOVE      LA_TAMT       ZZAMT                                        262871
     C                   Z-ADD     LA_VRIF       ZZTOTI
     C                   Z-ADD     LA_VRIL       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        LA_VRIF
     C                   Z-ADD     ZZTOTD        LA_VRIL
     C                   Z-ADD     LA_VRRF       ZZTOTI
     C                   Z-ADD     LA_VRRL       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        LA_VRRF
     C                   Z-ADD     ZZTOTD        LA_VRRL
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      0             LA_TNLU
 
     C                   IF        *IN89 = *ON
     C                   WRITE     LOMKSZ1F
     C                   ELSE
     C                   UPDATE    LOMKSZ1F
     C                   ENDIF
 
      ** Restore values after updating loan amendments trailer
 
     C                   MOVE      W#VDAT        LA_VDAT
     C                   MOVE      W#LNRF        LA_LNRF
 
      ** Update main trailer
 
     C                   MOVE      '999999'      WKLNR
     C                   MOVE      '99999'       WKVDT
     C                   MOVE      '999'         WKLSN
 
     C     *LIKE         DEFINE    LA_VDAT       W#VDAT
     C     *LIKE         DEFINE    LA_LNRF       W#LNRF
     C                   Z-ADD     LA_VDAT       W#VDAT
     C**********         Z-ADD     LA_LNRF       W#LNRF                                       CLE148
     C                   MOVEL     LA_LNRF       W#LNRF                                       CLE148
      *
     C     KLAKEY        CHAIN     LOAMS                              99
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL(P)  'LOAMS'       DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVEL     '999999'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     LA_NORE       ADD       1             LA_NORE
     C     LA_NINS       ADD       1             LA_NINS
     C     LA_NLRA       ADD       1             LA_NLRA
 
     C**********         MOVE      LA_PRAM       ZZAMT                                        262871
     C                   MOVE      LA_TAMT       ZZAMT                                        262871
     C                   Z-ADD     LA_VRIF       ZZTOTI
     C                   Z-ADD     LA_VRIL       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        LA_VRIF
     C                   Z-ADD     ZZTOTD        LA_VRIL
     C                   Z-ADD     LA_VRRF       ZZTOTI
     C                   Z-ADD     LA_VRRL       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        LA_VRRF
     C                   Z-ADD     ZZTOTD        LA_VRRL
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      0             LA_TNLU
 
     C                   UPDATE    LOAMSZ1F
 
      ** Restore values after updating loan amendments trailer
 
     C                   MOVE      W#VDAT        LA_VDAT
     C                   MOVE      W#LNRF        LA_LNRF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZADD - Subroutine to add an amount to the total             *
      *                                                               *
      *****************************************************************
 
     C     GLZADD        BEGSR
 
     C                   Z-ADD     ZZAMT         ZZAMT                    91
     C   91              GOTO      ZZAEND
 
      ** Split ZZAMT into integer and decimal fields
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
 
     C                   EXSR      GLZSUM
 
     C     ZZAEND        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZSUM - Subroutine to carry out the additon for subroutine   *
      *                                                               *
      *****************************************************************
 
     C     GLZSUM        BEGSR
 
     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
 
      ** Determine sign of ZZAMTI & D, 92 if negative
 
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
 
      ** Determine sign of ZZTOTI & D, 91 if negative
 
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
 
      ** If ZZTOTAL is zero, return ZZAMOUNT
 
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND
 
      ** If signs differ bypass overflow checks
 
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
 
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
 
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
 
      ** If the modulus of ZZWK3 is less than the one of ZZTOTI
      ** then an overflow has occurred
 
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
 
      ** If overflow zeroise ZZAMT, set 99 on and let ZZTOT fields intact
 
     C   99              Z-ADD     0             ZZAMT
     C                   GOTO      ZZSEND
 
      ** The 'signs' are different
 
     C     ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it positive to compare with ZZTOT
 
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
 
      ** If ZZTOT was negative, make it positive to compare with ZZAMT
 
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Both ZZAMT and ZZTOT are now positive
 
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
 
      ** If ZZTOT equals ZZAMT return zero
 
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
 
      ** If ZZTOT greater than ZZAMT
 
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
 
      ** If ZZAMT greater than ZZTOT
 
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
 
      ** Reverse sign of ZZTOT if larger I/P fields were negative
 
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
 
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
 
     C     ZZSEND        TAG
 
      ** If ZZTOTD is zero, and ZZTOTI is negative set up ZZNEGD
 
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETLOAMS - Set up the Loan Amendments                         *
      *                                                               *
      *****************************************************************
 
     C     SETLOAMS      BEGSR
 
     C                   IF        AYPOPR = 'Y'
     C                             AND (AYIBSR <> 0 OR AYPBSR <> 0
     C                                  OR AYPBRT <> 0 OR AYIBRT <> 0)
      ** BC Loan Amendment
 
     C                   MOVE      'BC'          WAMTP
     C                   IF        NSEIN <> 'Y'
     C                   MOVE      AYPBSR        WBRTT
     C                   EVAL      WBRTE = AYPBRT
     C                   ELSE
     C                   MOVE      AYIBSR        WBRTT
     C                   EVAL      WBRTE = AYIBRT
     C                   ENDIF
 
     C                   Z-ADD     0             WRTSP
     C                   Z-ADD     0             WPRAM
     C                   Z-ADD     0             WINTA
     C                   Z-ADD     0             WTAMT
     C                   Z-ADD     0             WSETP
     C                   MOVE      *BLANKS       WTSEN
     C                   IF        WBRTT <> '00'
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      C_CCY         PCURR
     C                   PARM      WBRTT         PBRAT
     C     SDBSRT        PARM      SDBSRT        DSSDY
 
     C                   IF        @RTCD = *BLANKS
     C                   IF        BJRDNB < BAVDNR
     C                   Z-ADD     BACBSR        WBRTE
     C                   ELSE
     C                   Z-ADD     BANBRT        WBRTE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      C_NACD        WNACD
     C                   MOVE      *BLANKS       WOSBR
     C                   Z-ADD     0             WRSTM
     C                   MOVE      *BLANKS       WRIBN
     C                   MOVE      *BLANKS       WRIBA
     C                   MOVE      *BLANKS       WROBN
     C                   MOVE      *BLANKS       WROCN
     C                   Z-ADD     0             WPSTM
     C                   MOVE      *BLANKS       WRCRN
     C                   MOVE      *BLANKS       WRCRA
     C                   MOVE      *BLANKS       WRONS
     C                   MOVE      *BLANKS       WPONS
     C                   EXSR      SETPCRF
     C                   MOVE      *BLANKS       WOSAC
     C                   Z-ADD     0             WBASR
     C                   EXSR      SETLOAMSDK
     C                   ENDIF
 
     C                   IF        AYPOPR = 'Y'
     C                             AND (AYIRSP <> 0 OR AYPRSP <> 0)
 
      ** SC Loan Amendment
 
     C                   MOVE      'SC'          WAMTP
     C                   MOVE      *ZEROS        WBRTT
     C                   IF        NSEIN <> 'Y'
     C                   Z-ADD     AYPRSP        WRTSP
     C                   ELSE
     C                   Z-ADD     AYIRSP        WRTSP
     C                   ENDIF
 
     C                   Z-ADD     0             WPRAM
     C                   Z-ADD     0             WINTA
     C                   Z-ADD     0             WTAMT
     C                   Z-ADD     0             WSETP
     C                   MOVE      *BLANKS       WTSEN
     C                   Z-ADD     0             WBRTE
     C                   MOVE      C_NACD        WNACD
     C                   MOVE      *BLANKS       WOSBR
     C                   Z-ADD     0             WRSTM
     C                   MOVE      *BLANKS       WRIBN
     C                   MOVE      *BLANKS       WRIBA
     C                   MOVE      *BLANKS       WROBN
     C                   MOVE      *BLANKS       WROCN
     C                   Z-ADD     0             WPSTM
     C                   MOVE      *BLANKS       WRCRN
     C                   MOVE      *BLANKS       WRCRA
     C                   MOVE      *BLANKS       WRONS
     C                   MOVE      *BLANKS       WPONS
     C                   EXSR      SETPCRF
     C                   MOVE      *BLANKS       WOSAC
     C                   Z-ADD     0             WBASR
     C                   EXSR      SETLOAMSDK
     C                   ENDIF
 
     C                   IF        NDEPI = 'Y'
 
      ** MR Manual Repayment
 
     C                   MOVE      'MR'          WAMTP
     C                   MOVE      *ZEROS        WBRTT
     C                   Z-ADD     0             WRTSP
     C                   Z-ADD     NPDPR         WPRAM
     C                   Z-ADD     NPDIN         WINTA
     C                   EVAL      WTAMT = WPRAM + WINTA
     C                   IF        C_PTYP = 66
     C                             OR C_PTYP = 67
     C                             OR (C_PTYP = 69 OR C_PTYP = 72)
     C                             AND CLE005 = 'Y'
     C                   Z-ADD     C_PSTM        WSETP
     C                   ELSE
     C                   Z-ADD     C_RSTM        WSETP
     C                   ENDIF
 
     C                   MOVEL     C_RIBN        WTSEN
     C                   Z-ADD     0             WBRTE
     C                   MOVE      *BLANKS       WNACD
     C                   IF        C_PTYP = 66
     C                             OR C_PTYP = 67
     C                             OR (C_PTYP = 69 OR C_PTYP = 72)
     C                             AND CLE005 = 'Y'
     C                   MOVE      C_OSDB        WOSBR
     C                   ELSE
     C                   MOVE      C_OMDB        WOSBR
     C                   ENDIF
 
     C                   IF        C_PTYP = 66
     C                             OR C_PTYP = 67
     C                             OR (C_PTYP = 69 OR C_PTYP = 72)
     C                             AND CLE005 = 'Y'
     C                   Z-ADD     0             WRSTM
     C                   ELSE
     C                   Z-ADD     C_RSTM        WRSTM
     C                   ENDIF
 
     C                   IF        WRSTM <> 0
     C                   MOVE      C_RIBN        WRIBN
     C                   ELSE
     C                   MOVE      *BLANKS       WRIBN
     C                   ENDIF
 
     C                   IF        WRSTM <> 0
     C                   MOVE      C_RIBA        WRIBA
     C                   ELSE
     C                   MOVE      *BLANKS       WRIBA
     C                   ENDIF
 
     C                   IF        WRSTM <> 0
     C                   MOVE      C_ROBN        WROBN
     C                   ELSE
     C                   MOVE      *BLANKS       WROBN
     C                   ENDIF
 
     C                   IF        WRSTM <> 0
     C                   MOVE      C_ROCN        WROCN
     C                   ELSE
     C                   MOVE      *BLANKS       WROCN
     C                   ENDIF
 
     C                   IF        C_PTYP = 66
     C                             OR C_PTYP = 67
     C                             OR (C_PTYP = 69 OR C_PTYP = 72)
     C                             AND CLE005 = 'Y'
     C                   Z-ADD     C_PSTM        WPSTM
     C                   ELSE
     C                   Z-ADD     0             WPSTM
     C                   ENDIF
 
     C                   IF        WRSTM <> 0
     C                   MOVE      C_RCRN        WRCRN
     C                   ELSE
     C                   MOVE      *BLANKS       WRCRN
     C                   ENDIF
 
     C                   IF        WRSTM <> 0
     C                   MOVE      C_RCRA        WRCRA
     C                   ELSE
     C                   MOVE      *BLANKS       WRCRA
     C                   ENDIF
 
     C                   IF        WRSTM <> 0
     C                   MOVE      C_RONS        WRONS
     C                   ELSE
     C                   MOVE      *BLANKS       WRONS
     C                   ENDIF
 
     C                   IF        WPSTM <> 0
     C                   MOVE      C_PONS        WPONS
     C                   ELSE
     C                   MOVE      *BLANKS       WPONS
     C                   ENDIF
 
     C                   EXSR      SETPCRF
 
     C                   IF        C_PTYP = 66
     C                             OR C_PTYP = 67
     C                             OR (C_PTYP = 69 OR C_PTYP = 72)
     C                             AND CLE005 = 'Y'
     C                   MOVE      C_PONS        WOSAC
     C                   ELSE
     C                   MOVE      C_RONS        WOSAC
     C                   ENDIF
 
     C                   Z-ADD     0             WBASR
     C                   EXSR      SETLOAMSDK
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETPCRF - Set up the PC Transaction reference                 *
      *                                                               *
      *****************************************************************
 
     C     SETPCRF       BEGSR
 
     C                   MOVE      C_BRCA        @BRCA
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     BRCA          DBKEY
     C                   OUT       LDA
     C                   MOVE      '*ERR001'     @@RTCD
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     A8MQSM        W#1ST3
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT                                       CLE148
                                                                                              CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        WPCRF
     C                   MOVE      '0001'        WPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETCLIPUPD - Set LECLIPUPD                                    *
      *                                                               *
      *****************************************************************
 
     C     SETCLIPUPD    BEGSR
 
      ** Write record to extension file (CLIP handles it in Java)
 
     C                   MOVE      L_CLLNRF      LQLNRF
     C                   MOVE      L_CLBRCA      LQBRCA
     C                   MOVE      L_CLFRNT      LQFRID
     C                   WRITE     CLONLQD0
 
      ** Update the main set of files in CLIP
 
     C                   CALLB     'LECLIPUPD'
 
      ** Return Code
 
     C                   PARM      *BLANKS       @RTCD
 
      ** Externally described DS for valid loan Detail CL
 
     C                   PARM                    LEVCliL
 
      ** Externally described DS for valid loan Detail CK
 
     C                   PARM                    LEVCliK
 
      ** Loan number ranges file
 
     C                   PARM                    @PRANG
 
      ** PC Processing
 
     C                   PARM                    PPTIN
     C                   PARM                    PGNTF
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF
     C                   PARM                    W#SEQ
 
      ** Reservation ID (input from VU only)
 
     C                   PARM                    ReservId
 
      ** Calling module
 
     C                   PARM                    CallModCode
 
      ** Switchable features
 
     C                   PARM                    CLE028
     C                   PARM      'N'           WAUTOA
     C                   PARM      '1'           WAUTOY
     C                   PARM                    PFPTF
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'LECLIPUPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 030
     C                   MOVE      '*ERR030'     @@RTCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LOANINTER - Process the Interest for the LOAN PDCL            *
      *                                                               *
      *****************************************************************
 
     C     LOANINTER     BEGSR
 
      ** Prepare static data
 
     C                   EXSR      SETLOANI
 
      ** Assign new loan number
 
     C                   EXSR      ACS_NXTAVL
 
      ** Set up the link record for the Interest
 
     C                   EXSR      SETLEPDUEPD2
 
      ** Set up new CLOANCL/CK data
 
     C                   EXSR      SETCLOANCx
 
      ** Write new loan
 
     C                   EXSR      SETCLIPUPD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FEEAMOUNT - Process the Amount for the FEE PDCL               *
      *                                                               *
      *****************************************************************
 
     C     FEEAMOUNT     BEGSR
 
      ** Set up data for/from original fee
 
     C                   EXSR      SETFEE
 
      ** Assign new loan number
 
     C                   EXSR      ACS_NXTAVL
 
      ** Set up the link record for the Interest
 
     C                   EXSR      SETLEPDUFPD
 
      ** Set up new CLOANCL/CK data
 
     C                   EXSR      SETCLOANCx
 
      ** Write new loan
 
     C                   EXSR      SETCLIPUPD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETLEPDUEPD1 - LEPDUEPD x Loan - Principal                    *
      *                                                               *
      *****************************************************************
 
     C     SETLEPDUEPD1  BEGSR
 
     C                   CLEAR                   LEPDUED0
 
      ** 'D' record
 
     C                   MOVE      'D'           YRECI
     C**********         Z-ADD     F9NALN        NPLON                                        CLE148
     C                   MOVEL     F9NALA        NPLON                                        CLE148
     C                   MOVEL     NPLON         YPLON
     C                   Z-ADD     NSDAT         YVDAT
     C                   MOVEL     NORLN         YPORG
     C                   MOVE      C_BRCA        YBRCA
 
     C                   IF        NSEIN = 'N'
     C                   EVAL      YPDCT = 'T'
     C                   ELSE
     C                   EVAL      YPDCT = 'P'
     C                   ENDIF
 
     C                   Z-ADD     NPDPR         YPCPAM
     C                   IF        YPDCT = 'T'
     C                   Z-ADD     NPDIN         YPDINT
     C                   ELSE
     C                   Z-ADD     0             YPDINT
     C                   ENDIF
 
     C                   MOVE      NFAMU         YPFAMU
     C                   MOVE      NSEIN         YPSIIN
     C                   MOVE      NCAPI         YPCIIN
 
     C                   MOVE      NTLPR         WTLPR
     C                   MOVE      WKPABR        YTKPABR
     C                   MOVE      WKPACL        YTKPACL
     C                   MOVE      WKPACY        YTKPACY
     C                   Z-ADD     WKPAAC        YTKPAAC
     C                   Z-ADD     WKPASE        YTKPASE
 
     C                   MOVE      NTLIN         WTLIN
     C                   MOVE      WKIABR        YTKIABR
     C                   MOVE      WKIACL        YTKIACL
     C                   MOVE      WKIACY        YTKIACY
     C                   Z-ADD     WKIAAC        YTKIAAC
     C                   Z-ADD     WKIASE        YTKIASE
 
     C                   MOVE      NRIDT         YRIDT
     C                   MOVE      NRCAT         YRCAT
     C                   MOVE      NBIDT         YBIDT
     C                   MOVE      NBCAT         YBCAT
     C                   MOVE      NDEPI         YDECRE
     C                   Z-ADD     NSDAT         YPDVDT
     C                   Z-ADD     BJRDNB        YLCD
     C                   MOVE      'I'           YTYLC
     C                   MOVE      WIUSR         YPIUSE
     C                   MOVE      'I'           YPCBIC
     C                   Z-ADD     0             YPOREP
     C                   Z-ADD     0             YPOREI
     C                   Z-ADD     0             YPOSEQ
     C                   MOVE      DDFRNT        YPFRNT
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
 
     C                   WRITE     LEPDUED0
 
      ** 'P' record
 
     C                   MOVE      'P'           YRECI
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
     C                   IF        YDECRE = 'Y'
     C                   IF        YPCBIC = 'I'  AND WLASN = 0                                263412
 
      ** Set up the sequence number checking what is used already on                          263412
      ** LOAMS, key by PDCL loan value date                                                   263412
 
     C                   MOVEL     NORLN         WPLON                                        263412
     C     KLOAM         SETGT     LOAMS                                                      263412
     C     KLOAM         READPE    LOAMS                                9999                  263412
     C                   IF        *IN99 = *OFF                                               263412
     C                   EVAL      WLASN = LA_LASN + 1                                        263412
     C                   ELSE                                                                 263412
     C                   EVAL      WLASN = 1                                                  263412
     C                   ENDIF                                                                263412
     C                   ENDIF                                                                263412
                                                                                              263412
     C                   Z-ADD     YPCPAM        YPOREP
     C                   Z-ADD     YPDINT        YPOREI
     C**********         IF        WAMTP = 'MR'                                               263412
     C                   Z-ADD     WLASN         YPOSEQ
     C**********         ENDIF                                                                263412
     C                   ENDIF
 
     C                   WRITE     LEPDUED0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETLEPDUEPD2 - LEPDUEPD x Loan - Interest                     *
      *                                                               *
      *****************************************************************
 
     C     SETLEPDUEPD2  BEGSR
 
     C                   CLEAR                   LEPDUED0
 
      ** 'D' record
 
     C                   MOVE      'D'           YRECI
     C**********         Z-ADD     F9NALN        NPLO2                                        CLE148
     C                   MOVEL     F9NALA        NPLO2                                        CLE148
     C**********         Z-ADD     NPLO2         YPLON                                        CLE148
     C                   MOVEL     NPLO2         YPLON                                        CLE148
     C                   Z-ADD     NSDAT         YVDAT
     C                   MOVEL     NORLN         YPORG
     C                   MOVE      C_BRCA        YBRCA
     C                   Z-ADD     0             YPCPAM
     C                   Z-ADD     NPDIN         YPDINT
     C                   MOVE      'I'           YPDCT
     C                   MOVE      NFAMU         YPFAMU
     C                   MOVE      NSEIN         YPSIIN
     C                   MOVE      NCAPI         YPCIIN
 
     C                   MOVE      NTLPR         WTLPR
     C                   MOVE      WKPABR        YTKPABR
     C                   MOVE      WKPACL        YTKPACL
     C                   MOVE      WKPACY        YTKPACY
     C                   Z-ADD     WKPAAC        YTKPAAC
     C                   Z-ADD     WKPASE        YTKPASE
 
     C                   MOVE      NTLIN         WTLIN
     C                   MOVE      WKIABR        YTKIABR
     C                   MOVE      WKIACL        YTKIACL
     C                   MOVE      WKIACY        YTKIACY
     C                   Z-ADD     WKIAAC        YTKIAAC
     C                   Z-ADD     WKIASE        YTKIASE
 
     C                   MOVE      NRIDT         YRIDT
     C                   MOVE      NRCAT         YRCAT
     C                   MOVE      NBIDT         YBIDT
     C                   MOVE      NBCAT         YBCAT
     C                   MOVE      NDEPI         YDECRE
     C                   Z-ADD     NSDAT         YPDVDT
     C                   Z-ADD     BJRDNB        YLCD
     C                   MOVE      'I'           YTYLC
     C                   MOVE      WIUSR         YPIUSE
     C                   MOVE      'I'           YPCBIC
     C                   Z-ADD     0             YPOREP
     C                   Z-ADD     0             YPOREI
     C                   Z-ADD     0             YPOSEQ
     C                   MOVE      DDFRNT        YPFRNT
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
 
     C                   WRITE     LEPDUED0
 
      ** 'P' record
 
     C                   MOVE      'P'           YRECI
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
     C                   IF        YDECRE = 'Y'
     C                   IF        YPCBIC = 'I'  AND WLASN = 0                                263412
 
      ** Set up the sequence number checking what is used already                             263412
      ** on LOAMS, key by PDCL loan value date                                                263412
                                                                                              263412
     C                   MOVEL     NORLN         WPLON                                        263412
     C     KLOAM         SETGT     LOAMS                                                      263412
     C     KLOAM         READPE    LOAMS                                9999                  263412
     C                   IF        *IN99 = *OFF                                               263412
     C                   EVAL      WLASN = LA_LASN + 1                                        263412
     C                   ELSE                                                                 263412
     C                   EVAL      WLASN = 1                                                  263412
     C                   ENDIF                                                                263412
     C                   ENDIF                                                                263412
                                                                                              263412
     C                   Z-ADD     YPCPAM        YPOREP
     C                   Z-ADD     YPDINT        YPOREI
     C**********         IF        WAMTP = 'MR'                                               263412
     C                   Z-ADD     WLASN         YPOSEQ
     C**********         ENDIF                                                                263412
     C                   ENDIF
 
     C                   WRITE     LEPDUED0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETLEPDUFPD - LEPDUFPD x Fee - Principal                      *
      *                                                               *
      *****************************************************************
 
     C     SETLEPDUFPD   BEGSR
 
      ** Update Fees with new PDCL data
 
     C**********         EVAL      FEPLNR = F9NALN                                            CLE148
     C                   EVAL      FEPLNR = F9NALA                                            CLE148
     C                   UPDATE    LEFEEDF
 
      ** Setup the new link records for the fees
 
     C                   CLEAR                   LEPDUFD0
 
      ** Primary record
 
     C                   MOVE      'P'           YRECI
     **********          Z-ADD     F9NALN        NPLON                                        CLE148
     C                   MOVEL     F9NALA        NPLON                                        CLE148
     C                   MOVEL     NPLON         YPLON
     C                   MOVE      E_FEBRCA      YBRCA
     C                   Z-ADD     NSDAT         YVDAT
     C                   MOVEL     NORLN         YPORG
     C                   MOVE      NFECU         YECNUM
     C                   MOVE      NFFAC         YEFACL
     C                   MOVE      NFSEQ         YESEQ
     C                   MOVE      NFLNO         YPORG
     C                   Z-ADD     NPDFA         YPCPAM
     C                   Z-ADD     0             YPDINT
     C                   MOVE      NFAMU         YPFAMU
     C                   MOVE      NSEIN         YPSIIN
     C                   MOVE      NCAPI         YPCIIN
 
     C                   MOVE      NTLFE         WPDFA
     C                   MOVE      WKFABR        YTKPABR
     C                   MOVE      WKFACL        YTKPACL
     C                   MOVE      WKFACY        YTKPACY
     C                   MOVE      WKFAAC        YTKPAAC
     C                   MOVE      WKFASE        YTKPASE
 
     C                   MOVE      NRIDT         YRIDT
     C                   MOVE      NRCAT         YRCAT
     C                   MOVE      NBIDT         YBIDT
     C                   MOVE      NBCAT         YBCAT
     C                   MOVE      NDEPI         YDECRE
     C                   Z-ADD     NSDAT         YPDVDT
     C                   Z-ADD     BJRDNB        YLCD
     C                   MOVE      'I'           YTYLC
     C                   MOVE      WIUSR         YPIUSE
     C                   MOVE      'I'           YPCBIC
     C                   Z-ADD     0             YPOREP
     C                   Z-ADD     0             YPOREI
     C                   Z-ADD     0             YPOSEQ
     C                   MOVE      DDFRNT        YPFRNT
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
 
     C                   WRITE     LEPDUFD0
 
      ** Details record
 
     C                   MOVE      'D'           YRECI
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
 
     C                   WRITE     LEPDUFD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETLOAMSDK - LOAMSDK xx Amendment x Loan                      *
      *                                                               *
      *****************************************************************
 
     C     SETLOAMSDK    BEGSR
 
      ** Set up the sequence number checking what is used already
      ** on LOAMS, key by PDCL loan + value date
 
     C     KLOAM         KLIST
     C                   KFLD                    WPLON
     C                   KFLD                    NSDAT
     C                   MOVEL     NORLN         WPLON
     C                   IF        WLASN = 0                                                  263412
     C     KLOAM         SETGT     LOAMS
     C     KLOAM         READPE    LOAMS                                9999
     C                   IF        *IN99 = *OFF
     C                   EVAL      WLASN = LA_LASN + 1
     C                   ELSE
     C                   EVAL      WLASN = 1
     C                   ENDIF
     C                   ENDIF                                                                263412
 
     C                   CLEAR                   LOAMSDKF
 
     C                   MOVE      'D'           LA_RECI
     C                   MOVEL     NORLN         LA_LNRF
     C**********         Z-ADD     BJRDNB        LA_VDAT                                      262967
     C                   Z-ADD     NSDAT         LA_VDAT                                      262967
     C                   Z-ADD     WLASN         LA_LASN
     C                   Z-ADD     2             LA_MRIN
     C                   MOVE      C_LTYP        LA_LTYP
     C                   MOVE      C_SUTP        LA_SUTP
     C                   MOVE      C_PTYP        LA_PTYP
     C                   MOVE      WAMTP         LA_AMTP
     C                   Z-ADD     0             LA_PRSQ
     C                   MOVE      WBRTT         LA_BRTT
     C                   Z-ADD     WRTSP         LA_RTSP
     C                   MOVE      C_CCY         LA_CCY
     C                   Z-ADD     WPRAM         LA_PRAM
     C                   Z-ADD     WINTA         LA_INTA
     C                   Z-ADD     0             LA_WTXA
     C                   Z-ADD     0             LA_FEAM
     C                   Z-ADD     WTAMT         LA_TAMT
     c                   MOVE      C_BRCA        LA_BRCA
     C                   MOVE      C_CNUM        LA_CNUM
     C                   MOVE      '0'           LA_REPT
     C                   MOVE      'C'           LA_AUTO
     C                   MOVE      *BLANKS       LA_STAI
     C                   MOVE      WSETP         LA_SETP
     C                   MOVE      WSETP         WTYP                                       AR317473
     C                   MOVE      WTSEN         LA_TSEN
     C                   MOVE      WTSEN         WTHRS                                      AR317473
     C                   MOVE      *BLANKS       LA_FACO
     C                   MOVE      *BLANKS       WFACO                                      AR317473
     C                   MOVE      *BLANKS       LA_SPI1
     C                   MOVE      *BLANKS       LA_SPI2
     C                   MOVE      *BLANKS       LA_SPI3
     C                   BITOFF    '01234567'    LA_LAIN
     C                   Z-ADD     WBRTE         LA_BRTE
     C                   MOVE      *BLANKS       LA_SPIN
     C                   Z-ADD     0             LA_CALC
     C                   MOVE      *BLANKS       LA_WTIN
     C                   MOVE      'A'           LA_LLAG
     C                   MOVE      *BLANKS       LA_LWOI
     C                   Z-ADD     0             LA_XAVD
     C                   Z-ADD     0             LA_XASQ
     C                   MOVE      C_FCUS        LA_FCUS
     C                   MOVE      C_FTYP        LA_FTYP
     C                   MOVE      C_FSEQ        LA_FSEQ
     C                   MOVE      *BLANKS       LA_ROLN
     C                   BITOFF    '01234567'    LA_PONI
     C                   MOVE      *BLANKS       LA_CNFY
     C                   MOVE      *BLANKS       LA_TLXY
     C                   MOVE      *BLANKS       LA_CBLY
     C                   MOVE      *BLANKS       LA_INTC
     C                   MOVE      WNACD         LA_NACD
     C                   MOVE      *BLANKS       LA_ROLN
     C                   Z-ADD     0             LA_LSWCC
     C                   Z-ADD     0             LA_LSWSC
     C                   MOVE      WOSBR         LA_OSBR
     C                   MOVE      C_FCLB        LA_FCLB
     C                   Z-ADD     0             LA_LSMD
 
     C                   Z-ADD     BJRDNB        LA_ORED
     C                   Z-ADD     BJRDNB        LA_LCD
     C                   MOVE      'I'           LA_CHTP
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      0             LA_TNLU
 
     C                   Z-ADD     WRSTM         LA_RSTM
     C                   MOVE      WRIBN         LA_RIBN
     C                   MOVE      WRIBA         LA_RIBA
     C                   MOVE      WROBN         LA_ROBN
     C                   MOVE      WROCN         LA_ROCN
     C                   Z-ADD     WPSTM         LA_PSTM
     C                   MOVE      *BLANKS       LA_PIBN
     C                   MOVE      *BLANKS       LA_PIBA
     C                   MOVE      *BLANKS       LA_POBN
     C                   MOVE      *BLANKS       LA_POCN
     C                   MOVE      WRCRN         LA_RCRN
     C                   MOVE      WRCRA         LA_RCRA
     C                   MOVE      *BLANKS       LA_RVNO
     C                   MOVE      *BLANKS       LA_AWBN
     C                   MOVE      *BLANKS       LA_AWBA
     C                   MOVE      *BLANKS       LA_BENN
     C                   MOVE      *BLANKS       LA_BENA
     C                   MOVE      *BLANKS       LA_DTP1
     C                   MOVE      *BLANKS       LA_DTP2
     C                   MOVE      *BLANKS       LA_DTP3
     C                   MOVE      *BLANKS       LA_DTP4
     C                   MOVE      *BLANKS       LA_DCHG
     C                   MOVE      *BLANKS       LA_BTB1
     C                   MOVE      *BLANKS       LA_BTB2
     C                   MOVE      *BLANKS       LA_BTB3
     C                   MOVE      *BLANKS       LA_BTB4
     C                   MOVE      *BLANKS       LA_BTB5
     C                   MOVE      *BLANKS       LA_BTB6
     C                   MOVE      *BLANKS       LA_CVMR
     C                   Z-ADD     0             LA_FSRP
     C                   MOVE      *BLANKS       LA_FSGN
     C                   MOVE      *BLANKS       LA_FPRC
     C                   Z-ADD     0             LA_COFA
     C                   MOVE      *BLANKS       LA_IRCF
     C                   MOVE      *BLANKS       LA_FRCF
     C                   MOVE      *BLANKS       LA_DFTP
     C                   MOVE      *BLANKS       LA_DFST
     C                   MOVE      'M'           LA_MNSG
     C                   MOVE      'N'           LA_GASS
     C                   MOVE      'N'           LA_GPRT
     C                   MOVE      'N'           LA_NRLI
     C                   MOVE      *BLANK        LA_ROLN
     C                   Z-ADD     0             LA_ROSN
     C                   MOVE      *BLANKS       LA_ROBR
     C                   MOVE      '000000'      LA_RORC
     C                   MOVE      *BLANKS       LA_PDGN
     C                   MOVE      *BLANKS       LA_GRIN
     C                   MOVE      *BLANKS       LA_RLCY
     C                   Z-ADD     0             LA_PNAM
     C                   MOVE      *BLANKS       LA_PAST
     C                   MOVE      'A'           LA_ASTS
     C                   MOVE      WIUSR         LA_IUSR
     C                   MOVE      *BLANKS       LA_AUSR
     C                   MOVE      *BLANKS       LA_XUSR
     C                   MOVE      WPCRF         LA_PCRF
     C                   MOVE      *BLANKS       LA_PCOB
     C                   MOVE      'N'           LA_MTPD
     C                   MOVE      *BLANKS       LA_PDDI
     C                   MOVE      *BLANKS       LA_PTDI
     C                   MOVE      *BLANKS       LA_SCCY
     C                   MOVE      *BLANKS       LA_ICCY
     C                   MOVE      *BLANKS       LA_ECIN
     C                   MOVE      *BLANKS       LA_REPI
     C                   Z-ADD     0             LA_CHDU
     C                   Z-ADD     0             LA_INTN
     C                   Z-ADD     0             LA_FSPRAM
     C                   Z-ADD     0             LA_REXR
     C                   MOVE      *BLANKS       LA_REXI
     C                   MOVE      *BLANKS       LA_PSCY
     C                   MOVE      *BLANKS       LA_PEXR
     C                   MOVE      *BLANKS       LA_PEXI
     C                   MOVE      *BLANKS       LA_STAL
     C                   MOVE      DDFRNT        LA_FRNT
     C                   MOVE      *BLANKS       LA_AFRT
     C                   MOVE      *BLANKS       LA_REPA
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    LA_TMST
     C                   MOVE      WOSAC         LA_OSAC
     C                   MOVE      WOSAC         WOURS                                      AR317473
     C                   MOVE      WRONS         LA_RONS
     C                   MOVE      WPONS         LA_PONS
     C                   MOVE      *BLANKS       LA_AUTH
     C                   MOVE      *BLANKS       LA_FRCY
     C                   Z-ADD     0             LA_FRAM
     C                   Z-ADD     0             LA_FINT
     C                   Z-ADD     0             LA_FTXA
     C                   Z-ADD     0             LA_FTOT
     C                   Z-ADD     0             LA_FPEN
     C                   Z-ADD     WBASR         LA_BASR
     C                   MOVE      *BLANKS       LA_SLTP
     C                   MOVE      *BLANKS       LA_SLST
     C                   MOVE      C_CLAS        LA_CLAS
     C                   MOVE      *BLANKS       LA_DFCL
     C                   MOVE      *BLANKS       LA_SLCL
 
     C                   WRITE     LOAMSDKF
     C                   WRITE     LOMKSDKF
 
     C                   IF        WAMTP = 'MR'
 
      ** Update Facility
 
     C                   Z-ADD     LA_PRAM       OPRAM
     C                   Z-ADD     LA_INTA       OINTA
     C                   Z-ADD     LA_PNAM       OPNAM
     C                   Z-ADD     LA_TAMT       OTAMT
     C                   Z-ADD     LA_WTXA       OWTXA
     C                   MOVE      *BLANK        WAMTP
 
     C                   MOVE      OAMT          SAMT
 
     C                   EXSR      SRFCLT
 
      ** Update LTRIX
 
     C                   EXSR      SRLTRX
 
      ** Generate reversal Shadow Posting if Interest Payment due                          AR317473B
      ** tonight will now no longer take place.                                            AR317473B
                                                                                           AR317473B
     C     C_REPT        IFEQ      2                                                       AR317473B
     C     C_NIDT        ANDLT     BJDNWD                                                  AR317473B
     C     C_AUTO        ANDEQ     'C'                                                     AR317473B
     C     LA_INTA       ANDGT     0                                                       AR317473B
                                                                                           AR317473B
     C                   MOVE      WSETT         SHSETT                                    AR317473B
     C                   EXSR      SRSHAD                                                  AR317473B
     C                   MOVE      Z#ADTA        Z#BDT1                                    AR317473B
     C                   MOVE      Z#ADTB        Z#BDT2                                    AR317473B
                                                                                           AR317473B
     C     CEU004        IFEQ      'Y'                                                     AR317473B
     C     CLE031        OREQ      'Y'                                                     AR317473B
     C                   MOVE      Z#ADTE        Z#BDT5                                    AR317473B
     C                   ENDIF                                                             AR317473B
                                                                                           AR317473B
     C                   EXSR      SRUSHD                                                  AR317473B
     C                   ENDIF                                                             AR317473B
                                                                                           AR317473B
      *****Shadow posting - Before Status**********************************                AR317473A
      *****Update on shadow posting shd only be done if not a Risk loan****                AR317473A
      *****If it is a Risk loan then it should have an interest payment.***                AR317473A
      **********                                                                           AR317473A
     C*****LA_PTYP       IFEQ      61                                                      AR317473A
     C*****LA_PTYP       OREQ      62                                                      AR317473A
     C*****LA_PTYP       OREQ      63                                                      AR317473A
     C*****LA_PTYP       OREQ      64                                                      AR317473A
     C*****LA_PTYP       OREQ      65                                                      AR317473A
     C*****LA_PTYP       OREQ      66                                                      AR317473A
     C*****LA_PTYP       OREQ      67                                                      AR317473A
     C*****LA_PTYP       OREQ      68                                                      AR317473A
     C*****LA_PTYP       OREQ      69                                                      AR317473A
     C*****LA_PTYP       OREQ      70                                                      AR317473A
     C*****LA_INTA       ANDNE     0                                                       AR317473A
     C*****LA_PTYP       OREQ      71                                                      AR317473A
     C*****LA_INTA       ANDNE     0                                                       AR317473A
     C*****LA_PTYP       OREQ      72                                                      AR317473A
     C*****LA_INTA       ANDNE     0                                                       AR317473A
      **********                                                                           AR317473A
     C*****L_CLCHTP      IFNE      'X'                                                     AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      OLDSET        SHSETT                                    AR317473A
     C**********         EXSR      SRSHAD                                                  AR317473A
     C**********         MOVE      Z#ADTA        Z#BDT1                                    AR317473A
     C**********         MOVE      Z#ADTB        Z#BDT2                                    AR317473A
      **********                                                                           AR317473A
     C*****CEU004        IFEQ      'Y'                                                     AR317473A
     C*****CLE031        OREQ      'Y'                                                     AR317473A
     C**********         MOVE      Z#ADTE        Z#BDT5                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
      *****Shadow posting - After Status*****                                              AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      WSETT         SHSETT                                    AR317473A
     C**********         EXSR      SRSHAD                                                  AR317473A
     C**********         MOVE      Z#ADTA        Z#ADT1                                    AR317473A
     C**********         MOVE      Z#ADTB        Z#ADT2                                    AR317473A
     C**********         MOVE      Z#ADTD        Z#ADT4                                    AR317473A
      **********                                                                           AR317473A
     C*****CEU004        IFEQ      'Y'                                                     AR317473A
     C*****CLE031        OREQ      'Y'                                                     AR317473A
     C**********         MOVE      Z#ADTE        Z#ADT5                                    AR317473A
     C**********         ENDIF                                                             AR317473A
     C**********         EXSR      SRUSHD                                                  AR317473A
      **********                                                                           AR317473A
     C**********         ENDIF                                                             AR317473A
     C**********         ENDIF                                                             AR317473A
     C                   ENDIF
 
      ** Fix trailer
 
     C                   EXSR      SRTRAL
 
     C                   ENDSR
 
      *****************************************************************
      **/EJECT*********************************************************                    AR317473A
      *****************************************************************                    AR317473A
      *****************************************************************                    AR317473A
      **SRSHAD***-*Set*up*details*for*shadow*post**********************                    AR317473A
      **Called*by:*SRWRIT,*SRUPDT**************************************                    AR317473A
      **Calls****:*None************************************************                    AR317473A
      *****************************************************************                    AR317473A
      *****************************************************************                    AR317473A
      **********                                                                           AR317473A
     C*****SRSHAD        BEGSR                                                             AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      LA_RECI       SHRECI                                    AR317473A
     C**********         MOVE      LA_LNRF       SHLNRF                                    AR317473A
     C**********         Z-ADD     LA_VDAT       SHVDAT                                    AR317473A
     C**********         Z-ADD     LA_LASN       SHLASN                                    AR317473A
     C**********         MOVE      LA_PTYP       SHPTYP                                    AR317473A
     C**********         MOVE      LA_AMTP       SHAMTP                                    AR317473A
     C**********         MOVE      LA_CCY        SHCCY                                     AR317473A
     C**********         Z-ADD     LA_PRAM       SHPRAM                                    AR317473A
     C**********         Z-ADD     LA_TAMT       SHTAMT                                    AR317473A
     C**********         MOVE      LA_BRCA       SHBRCA                                    AR317473A
     C**********         Z-ADD     0             SHREPT                                    AR317473A
     C**********         MOVE      SHSETT        SHTIST                                    AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      LA_OSBR       SHOSBR                                    AR317473A
      **********                                                                           AR317473A
     C*****DDACTN        IFNE      'R'                                                     AR317473A
     C**********         MOVE      LA_CHTP       SHCHTP                                    AR317473A
     C**********         ELSE                                                              AR317473A
     C**********         MOVE      'R'           SHCHTP                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      LA_PNAM       SHPNAM                                    AR317473A
      **********                                                                           AR317473A
     C*****CEU004        IFEQ      'Y'                                                     AR317473A
     C**********         MOVE      LA_SCCY       SHSCCY                                    AR317473A
     C**********         MOVE      LA_ICCY       SHICCY                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C*****CLE031        IFEQ      'Y'                                                     AR317473A
     C**********         Z-ADD     LA_REXR       SHREXR                                    AR317473A
     C**********         MOVE      LA_REXI       SHREXI                                    AR317473A
     C**********         MOVE      LA_PSCY       SHPSCY                                    AR317473A
     C**********         Z-ADD     LA_PEXR       SHPEXR                                    AR317473A
     C**********         MOVE      LA_PEXI       SHPEXI                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      LA_STAL       SHSTAL                                    AR317473A
      **********                                                                           AR317473A
     C**********         ENDSR                                                             AR317473A
      **********                                                                           AR317473A
      *****************************************************************
      /EJECT                                                                               AR317473A
      *****************************************************************                    AR317473A
      *                                                               *                    AR317473A
      * SRSHAD - Set up details for shadow post                       *                    AR317473B
      * Called by: SetLOAMSDK                                         *                    AR317473B
      * Calls    : None                                               *                    AR317473B
      *                                                               *                    AR317473A
      *****************************************************************                    AR317473A
                                                                                           AR317473A
     C     SRSHAD        BEGSR                                                             AR317473B
                                                                                           AR317473B
     C                   MOVE      LA_RECI       SHRECI                                    AR317473B
     C                   MOVE      LA_LNRF       SHLNRF                                    AR317473B
     C                   Z-ADD     LA_VDAT       SHVDAT                                    AR317473B
     C                   Z-ADD     LA_LASN       SHLASN                                    AR317473B
     C                   MOVE      LA_PTYP       SHPTYP                                    AR317473B
     C                   MOVE      LA_AMTP       SHAMTP                                    AR317473B
     C                   MOVE      LA_CCY        SHCCY                                     AR317473B
     C                   Z-ADD     0             SHPRAM                                    AR317473B
     C                   Z-ADD     LA_INTA       SHTAMT                                    AR317473B
     C                   MOVE      LA_BRCA       SHBRCA                                    AR317473B
     C                   Z-ADD     0             SHREPT                                    AR317473B
     C                   MOVE      SHSETT        SHTIST                                    AR317473B
     C                   MOVE      LA_OSBR       SHOSBR                                    AR317473B
                                                                                           AR317473B
     C     DDACTN        IFNE      'R'                                                     AR317473B
     C                   MOVE      LA_CHTP       SHCHTP                                    AR317473B
     C                   ELSE                                                              AR317473B
     C                   MOVE      'R'           SHCHTP                                    AR317473B
     C                   ENDIF                                                             AR317473B
                                                                                           AR317473B
     C                   MOVE      LA_PNAM       SHPNAM                                    AR317473B
                                                                                           AR317473B
     C     CEU004        IFEQ      'Y'                                                     AR317473B
     C                   MOVE      LA_SCCY       SHSCCY                                    AR317473B
     C                   MOVE      LA_ICCY       SHICCY                                    AR317473B
     C                   ENDIF                                                             AR317473B
                                                                                           AR317473B
     C     CLE031        IFEQ      'Y'                                                     AR317473B
     C                   Z-ADD     LA_REXR       SHREXR                                    AR317473B
     C                   MOVE      LA_REXI       SHREXI                                    AR317473B
     C                   MOVE      LA_PSCY       SHPSCY                                    AR317473B
     C                   Z-ADD     LA_PEXR       SHPEXR                                    AR317473B
     C                   MOVE      LA_PEXI       SHPEXI                                    AR317473B
     C                   ENDIF                                                             AR317473B
                                                                                           AR317473B
     C                   MOVE      LA_STAL       SHSTAL                                    AR317473B
                                                                                           AR317473B
     C                   ENDSR                                                             AR317473B
                                                                                           AR317473B
      *****************************************************************                    AR317473A
      ***/EJECT********************************************************                    AR317473A
      *****************************************************************                    AR317473A
      *****************************************************************                    AR317473A
      **SRUSHD**-**Shadow*posting*update*******************************                    AR317473A
      **Called*by:*SRWRIT,*SRUPDT**************************************                    AR317473A
      **Calls****:*AOOULAU1********************************************                    AR317473A
      **Calls****:*AOOULEU1********************************************                    AR317473A
      *****************************************************************                    AR317473A
      *****************************************************************                    AR317473A
      **********                                                                           AR317473A
     C*****SRUSHD        BEGSR                                                             AR317473A
      **********                                                                           AR317473A
      *****Do*On-line*updates******************************************                    AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      *BLANKS       @RTCD                                     AR317473A
     C**********         CALL      'AOOULAU1'                                              AR317473A
     C**********         PARM                    @RTCD                                     AR317473A
     C**********         PARM                    Z#BSTS                                    AR317473A
     C**********         PARM                    Z#ASTS                                    AR317473A
     C**********         PARM                    Z#WSTS                                    AR317473A
      **********                                                                           AR317473A
     C*****@RTCD         IFEQ      '*ERROR*'                                               AR317473A
     C**********         MOVE      '*ERR002'     @@RTCD                                    AR317473A
     C**********         EXSR      *PSSR                                                   AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
      **We*only*need*to*call*AOOULEU1*if*the*Pay*our*Nostro*fields*****                    AR317473A
      **are*different*for*the*Loan*and*Manual*repayment.***************                    AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      'N'           AOOULE                                    AR317473A
     C**********         MOVE      'N'           SETT09                                    AR317473A
     C*****C_PTYP        IFEQ      61                                                      AR317473A
     C*****C_PTYP        OREQ      62                                                      AR317473A
     C*****C_PTYP        OREQ      63                                                      AR317473A
     C*****C_PTYP        OREQ      64                                                      AR317473A
     C*****C_PTYP        OREQ      65                                                      AR317473A
     C*****C_PTYP        OREQ      68                                                      AR317473A
     C*****C_PTYP        OREQ      70                                                      AR317473A
     C*****C_PTYP        OREQ      71                                                      AR317473A
      **********                                                                           AR317473A
     C*****L_CLRSTM      IFEQ      9                                                       AR317473A
     C*****LA_RSTM       OREQ      9                                                       AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      'Y'           SETT09                                    AR317473A
     C*****L_CLRSTM      IFNE      LA_RSTM                                                 AR317473A
     C*****L_CLSCCY      ORNE      LA_SCCY                                                 AR317473A
     C**********         MOVE      'Y'           AOOULE                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         ENDIF                                                             AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C*****C_PTYP        IFEQ      66                                                      AR317473A
     C*****C_PTYP        OREQ      67                                                      AR317473A
     C*****C_PTYP        OREQ      69                                                      AR317473A
     C*****C_PTYP        OREQ      72                                                      AR317473A
      **********                                                                           AR317473A
     C*****C_PSTM        IFEQ      9                                                       AR317473A
      **********                                                                           AR317473A
     C**********         MOVE      'Y'           SETT09                                    AR317473A
     C*****C_PSTM        IFNE      LA_PSTM                                                 AR317473A
     C*****C_PSCY        ORNE      LA_PSCY                                                 AR317473A
     C**********         MOVE      'Y'           AOOULE                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         ENDIF                                                             AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C*****C_PONS        IFNE      LA_PONS                                                 AR317473A
     C*****SETT09        ANDNE     'Y'                                                     AR317473A
     C*****AOOULE        OREQ      'Y'                                                     AR317473A
      **********                                                                           AR317473A
     C**********         IF        C_PTYP = 66 or C_PTYP = 67 or                           AR317473A
     C**********                   C_PTYP = 69 or C_PTYP = 72                              AR317473A
      **********                                                                           AR317473A
      **For*Insert*****************************************************                    AR317473A
     C*****L_CLCHTP      IFEQ      'I'                                                     AR317473A
     C**********         MOVE      *BLANKS       @RTCD                                     AR317473A
     C**********         MOVEL     PDCLFilFmtLoanZ#BSTS                                    AR317473A
     C*****L_CLCPAM      SUB       LA_PRAM       L_CLCPAM                                  AR317473A
     C**********         MOVEL     PDCLFilFmtLoanZ#ASTS                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **For*Reverse****************************************************                    AR317473A
     C*****L_CLCHTP      IFEQ      'R'                                                     AR317473A
     C**********         MOVE      *BLANKS       @RTCD                                     AR317473A
     C*****L_CLCPAM      SUB       LA_PRAM       L_CLCPAM                                  AR317473A
     C**********         MOVEL     PDCLFilFmtLoanZ#BSTS                                    AR317473A
     C*****L_CLCPAM      ADD       LA_PRAM       L_CLCPAM                                  AR317473A
     C**********         MOVEL     PDCLFilFmtLoanZ#ASTS                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
      ***For*Authorise*************************************************                    AR317473A
     C*****L_CLCHTP      IFEQ      'X'                                                     AR317473A
     C*****L_CLCHTP      OREQ      'A'                                                     AR317473A
     C**********         EVAL      @RTCD = *BLANKS                                         AR317473A
     C**********         MOVEL     PDCLFilFmtLoanZ#BSTS                                    AR317473A
     C**********         MOVEL     PDCLFilFmtLoanZ#ASTS                                    AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         CALL      'AOOULEU1'                                              AR317473A
     C**********         PARM                    @RTCD                                     AR317473A
     C**********         PARM                    Z#BSTS                                    AR317473A
     C**********         PARM                    Z#ASTS                                    AR317473A
     C**********         PARM                    Z#WSTS                                    AR317473A
     C**********         PARM                    Z#BSTK                                    AR317473A
     C**********         PARM                    Z#ASTK                                    AR317473A
      **********                                                                           AR317473A
     C*****@RTCD         IFEQ      '*ERROR*'                                               AR317473A
     C**********         MOVE      '*ERR003'     @@RTCD                                    AR317473A
     C**********         EXSR      *PSSR                                                   AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         ENDIF                                                             AR317473A
      **********                                                                           AR317473A
     C**********         ENDSR                                                             AR317473A
      **********                                                                           AR317473A
      *****************************************************************                    AR317473A
      /EJECT                                                                               AR317473A
      *****************************************************************                    AR317473A
      *                                                               *                    AR317473A
      * SRUSHD  -  Shadow posting update                              *                    AR317473B
      * Called by: SETLOAMSDK                                         *                    AR317473B
      * Calls    : AOOULAU0                                           *                    AR317473B
      *                                                               *                    AR317473B
      *****************************************************************                    AR317473A
                                                                                           AR317473A
     C     SRUSHD        BEGSR                                                             AR317473B
                                                                                           AR317473B
      ** Set Z#ASTS to ensure no 'after' posting is done                                   AR317473B
                                                                                           AR317473B
     C                   MOVE      'SC'          WRK24                                     AR317473B
     C                   MOVEL     WRK24         Z#ADT1                                    AR317473B
                                                                                           AR317473B
      ** Do On-line updates                                                                AR317473B
                                                                                           AR317473B
     C                   MOVE      *BLANKS       @RTCD                                     AR317473B
     C                   CALL      'AOOULAU0'                                              AR317473B
     C                   PARM                    @RTCD                                     AR317473B
     C                   PARM                    Z#BSTS                                    AR317473B
     C                   PARM                    Z#ASTS                                    AR317473B
     C                   PARM                    Z#WSTS                                    AR317473B
                                                                                           AR317473B
     C     @RTCD         IFEQ      '*ERROR*'                                               AR317473B
     C                   MOVE      '*ERR002'     @@RTCD                                    AR317473B
     C                   EXSR      *PSSR                                                   AR317473B
     C                   ENDIF                                                             AR317473B
                                                                                           AR317473B
     C                   ENDSR                                                             AR317473B
                                                                                           AR317473B
      *****************************************************************                    AR317473A
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFCLT   - Facility file update                               *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : FCLTSR                                             *
      *                                                               *
      *****************************************************************
 
     C     SRFCLT        BEGSR
 
     C                   MOVE      'N'           WrkPart
 
     C     DDACTN        IFEQ      'I'
 
      ** Access FACILITY 'A' record
 
     C                   MOVE      'A'           WRCDT1
     C                   MOVE      LA_FCUS       WFCUS
     C                   MOVE      LA_FTYP       WFTYP
     C**********         MOVE      LA_FSEQ       WFSEQ                                        263289
     C                   MOVE      LA_FSEQ       WFCSQ                                        263289
 
     C     KFCLT         CHAIN(n)  FCLTY                              50
     C     *IN50         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR004'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL(P)  WDBKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF
 
      ** Access FACILITY 'B' record
 
     C                   MOVE      'B'           WRCDT1
     C     KFCLT         CHAIN     FCLTY                              50
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR005'     @@RTCD
     C                   MOVEL     'LEMPDCLPD'   DBPGM
     C                   MOVEL(p)  'FCLTY'       DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL(P)  WDBKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF
 
      ** Access LEFCAMPD file for change in revolving credit.
 
     C                   MOVE      ' '           WRVCRC
     C                   Z-ADD     0             WVLDT
     C     KFCAM         SETLL     LEFCAML3
     C     KFCAM         READE     LEFCAML3                               85
 
     C     *IN85         DOWEQ     *OFF
     C     WRVCRC        ANDEQ     ' '
     C*****RECI*         IFEQ      'D'                                                      AR724682
     C*****FATP*         ANDEQ     'RC'                                                     AR724682
     C     FC_RECI       IFEQ      'D'                                                      AR724682
     C     FC_FATP       ANDEQ     'RC'                                                     AR724682
     C**********         MOVE      RVCR          WRVCRC                                     AR724682
     C**********         Z-ADD     VLDT          WVLDT                                      AR724682
     C                   MOVE      FC_RVCR       WRVCRC                                     AR724682
     C                   Z-ADD     FC_VLDT       WVLDT                                      AR724682
     C                   ENDIF
     C     KFCAM         READE     LEFCAML3                               85
     C                   ENDDO
 
      ** Access FCCY record for decimal places
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      FCCY          PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR006'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     FCCY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Save currency details to work field
 
     C                   MOVE      A6NBDP        CDPF
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     A6SPRT        WSPRTF
     C                   MOVE      A6MDIN        WMDINF
     C                   ENDIF
     C                   EXSR      FCLTSR
 
     C                   Z-ADD     BJRDNB        M_LCD
     C                   MOVE      'A'           M_CHTP
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      0             M_TNLU
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    STMP
     C                   UPDATE    FCLTYFNF                             50
 
      ** Update superfacility of the tranche, if any, for CLE005
 
     C     CLE005        IFEQ      'Y'
     C     TRCA          ANDEQ     'TR'
     C                   MOVEL     L_CLLPFI      WLPFI
     C                   MOVEL     L_CLPTFC      WPTFC
     C                   MOVEL     L_CLPTFT      WPTFT
     C                   MOVEL     L_CLPTFN      WPTFN
     C                   MOVEL     WPRME         SPRME
     C                   EXSR      SRUPCA
     C                   MOVEL     SPRME         WPRME
     C                   MOVEL     WLPFI         L_CLLPFI
     C                   MOVEL     WPTFC         L_CLPTFC
     C                   MOVEL     WPTFT         L_CLPTFT
     C                   MOVEL     WPTFN         L_CLPTFN
     C                   ENDIF
 
      ** Update also the Participant facility if existing
 
     C     C_LPFI        IFNE      ' '
 
     C                   MOVE      'Y'           WrkPART
 
     C                   MOVEL     C_PTFC        WFCUS
     C                   MOVEL     C_PTFT        WFTYP
     C**********         MOVEL     C_PTFN        WFSEQ                                        263289
     C                   MOVEL     C_PTFN        WFCSQ                                        263289
     C                   MOVE      'A'           WRCDT1
 
     C     KFCLT         CHAIN(N)  FCLTY                              50
 
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE
     C                   Z-ADD     16            DBASE
     C                   MOVEL(P)  WDBKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access FACILITY 'B' record
 
     C                   MOVE      'B'           WRCDT1
     C     KFCLT         CHAIN     FCLTY                              50
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR007'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL(P)  WDBKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF
 
      ** Access FCCY record for decimal places
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      FCCY          PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR008'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVEL     FCCY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF
 
     C                   MOVE      A6NBDP        CDPF
 
     C                   EXSR      FCLTSR
 
     C                   Z-ADD     BJRDNB        M_LCD
     C                   MOVE      'A'           M_CHTP
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      0             M_TNLU
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    STMP
     C                   UPDATE    FCLTYFNF                             50
 
     C                   ENDIF
     C                   ENDIF
 
     C     ENDFCL        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLTRX  -  Update Loan Transaction Index Detail (LTRIX)       *
      * Called by:                                                    *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRLTRX        BEGSR
 
     C     DDACTN        IFEQ      'X'
     C     BPMRAU        ANDEQ     'Y'
     C     CLE002        ANDEQ     'Y'
 
     C     DDACTN        OREQ      'I'
     C     BPMRAU        ANDNE     'Y'
 
     C     DDACTN        OREQ      'R'
     C     BPMRAU        ANDEQ     'Y'
     C     CLE002        ANDEQ     'Y'
     C     XUSR          ANDNE     *BLANK
 
     C     DDACTN        OREQ      'R'
     C     BPMRAU        ANDNE     'Y'
 
     C     DDACTN        OREQ      'A'
     C     BPMRAU        ANDNE     'Y'
 
     C**********         MOVE      *IN17         IN17                                       AR322731
     C**********         MOVE      '1'           *IN17                                      AR322731
     C**********         MOVE      '0'           *IN79                                      AR322731
 
     C******IN17         DOUEQ     '0'                                                      AR322731
     C*****RECI          ANDEQ     *BLANK                                                   AR322731
     C******IN79         OREQ      '1'                                                      AR322731
 
     C**********         Z-ADD     1             LXRRN                                      AR322731
 
      ** Access LTRIX header
 
     C*****LXRRN         CHAIN(N)  LTRIX                              79                    AR322731
 
     C******IN79         IFEQ      '0'                                                      AR322731
     C*****RECI          IFEQ      'H'                                                      AR322731
     C*****RRNA          IFGT      FLSZ                                                     AR322731
     C**********         MOVE      '1'           *INU8                                      AR322731
     C**********         ENDIF                                                              AR322731
     C**********         ELSE                                                               AR322731
     C**********         MOVE      *ON           *IN79                                      AR322731
     C**********         ENDIF                                                              AR322731
     C**********         ENDIF                                                              AR322731
      *
     C******IN79         IFEQ      *ON                                                      AR322731
     C******INU8         OREQ      *ON                                                      AR322731
     C******LOCK         IN        LDA                                                      AR322731
     C**********         EVAL      @@RTCD = '*RECUPD'                                       AR322731
     C**********         MOVEL     'LEPDCLUPD'   DBPGM                                      AR322731
     C**********         MOVEL     'LTRIX   '    DBFILE                                     AR322731
     C**********         Z-ADD     28            DBASE                                      AR322731
     C**********         MOVEL     LXRRN         DBKEY                                      AR322731
     C**********         OUT       LDA                                                      AR322731
     C**********         EXSR      *PSSR                                                    AR322731
     C**********         ENDIF                                                              AR322731
 
     C**********         MOVE      RRNA          LXRRN                                      AR322731
 
     C*****LXRRN         CHAIN     LTRIX                              7917                  AR322731
      **********                                                                            AR322731
     C******IN17         IFEQ      '1'                                                      AR322731
     C*****TXSTS         IFEQ      1218                                                     AR322731
     C**********         UNLOCK    LTRIX                                                    AR322731
     C**********         ELSE                                                               AR322731
     C**********         MOVE      '1'           *IN79                                      AR322731
     C**********         ENDIF                                                              AR322731
     C**********         ENDIF                                                              AR322731
 
     C**********         ENDDO                                                              AR322731
     C**********         MOVE      IN17          *IN17                                      AR322731
 
     C******IN79         IFEQ      '1'                                                      AR322731
     C******LOCK         IN        LDA                                                      AR322731
     C**********         EVAL      @@RTCD = '*RECUPD'                                       AR322731
     C**********         MOVEL     'LEPDCLUPD'   DBPGM                                      AR322731
     C**********         MOVEL     'LTRIX   '    DBFILE                                     AR322731
     C**********         Z-ADD     29            DBASE                                      AR322731
     C**********         MOVEL     LXRRN         DBKEY                                      AR322731
     C**********         OUT       LDA                                                      AR322731
     C**********         EXSR      *PSSR                                                    AR322731
     C**********         ENDIF                                                              AR322731
 
     C**********         Z-ADD     0             PRI1                                       AR322731
     C                   Z-ADD     0             PRI1                                       AR322731
 
      ** Check settlement type
 
     C     LA_SETP       IFEQ      01
     C     LA_SETP       OREQ      02
     C     LA_SETP       OREQ      07
     C     LA_SETP       OREQ      08
     C     LA_SETP       OREQ      12
 
      ** Obtain lowest telex notice days between loan & local CCY
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      C_CCY         PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR009'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVEL     C_CCY         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Default to local CCY for telex notice calculation
 
     C                   Z-ADD     A6TXND        ZNRDYS
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
 
      ** For settlement types 01, 07, & 08 use loan currency instead
 
     C     LA_SETP       IFEQ      01
     C     LA_SETP       OREQ      07
     C     LA_SETP       OREQ      08
     C                   Z-ADD     A6TXND        ZNRDYS
     C                   MOVE      C_CCY         ZCCY
     C                   ENDIF
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
 
     C     LA_VDAT       IFLE      ZDYNBR
     C     LA_VDAT       IFGE      BJRDNB
     C                   Z-ADD     1             PRI1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      0             NATN
 
      ** Update LTRIX detail record
 
     C                   Z-ADD     0             RRNA                                       AR322731
     C                   EXCEPT    LTRIXD
 
      ** Get header record
 
     C**********         Z-ADD     1             LXRRN                                      AR322731
     C*****LXRRN         CHAIN     LTRIX                              79                    AR322731
 
     C******IN79         IFEQ      '1'                                                      AR322731
     C******LOCK         IN        LDA                                                      AR322731
     C**********         MOVE      '*ERR010'     @@RTCD                                     AR322731
     C**********         MOVEL     'LEPDCLUPD'   DBPGM                                      AR322731
     C**********         MOVEL     'LTRIX   '    DBFILE                                     AR322731
     C**********         Z-ADD     10            DBASE                                      AR322731
     C**********         MOVEL     LXRRN         DBKEY                                      AR322731
     C**********         OUT       LDA                                                      AR322731
     C**********         EXSR      *PSSR                                                    AR322731
     C**********         ENDIF                                                              AR322731
 
      ** Update relevant control fields
 
     C*****NORE          ADD       1             NORE                                       AR322731
     C*****RRNA          ADD       1             RRNA                                       AR322731
     C*****NLAR          ADD       1             NLAR                                       AR322731
 
     C**********         CALLB     'ZTNLU1'                                                 AR322731
     C**********         PARM      *BLANKS       @RTCD                                      AR322731
     C**********         PARM      0             NATN                                       AR322731
 
     C**********         EXCEPT    LTRIXH                                                   AR322731
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkSysValue - Check if Customer-Level Fees will be           *
      *                condsidered                                    *
      *                                                               *
      *****************************************************************
 
     C     ChkSysValue   BEGSR
 
      ** Check if Window Maintenance is activated
 
     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      POP01 = 'PDCLAccSeqNo'
     C                   EVAL      PVL01 = *BLANKS
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM                    POP01
     C                   PARM                    PVL01
     C                   PARM      *BLANKS       POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM      *BLANKS       POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM      *BLANKS       POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM      *BLANKS       POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
 
     C                   EVAL      SeqFlg = *BLANKS
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     PVL01         SeqFlg
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    @@RTCD
 
     C                   PARM                    DDACTN
 
      ** Valid values
 
     C                   PARM                    LEVPDCL
     C                   PARM                    NBCDY
     C                   PARM                    NBCSD
     C                   PARM                    NRCDY
     C                   PARM                    NRCSD
 
      ** Record Type
 
     C                   PARM                    RecordType
 
      ** Front Office ID
 
     C                   PARM                    DDFRNT
 
      ** Transaction Details in File Format: Loan 1
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Transaction Details in File Format: Loan 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Transaction Details in File Format: Fee
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Transaction Details in File Format: Facility
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** Other fields
 
     C                   PARM                    WIUSR
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get first branch for zone
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C                   PARM                    @BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 910
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if PDCL Loan Sequence will be implemented
 
     C                   EXSR      ChkSysValue
 
      ** Get General Ledger Details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** Database Error
 
     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 911
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Modules Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
 
      ** Database Error
 
     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 912
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Lending ICD
 
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCLNDPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 011
     C                   MOVE      '*ERR011'     @@RTCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   MOVE      '*ERR012'     @@RTCD
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** First read, store BICN
 
     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ      SDBRCHL5                               99
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      @@RTCD = '*RECUPD'
     c     *LOCK         IN        LDA
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVE      'SDBRCHL5'    DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     13            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C     *IN99         DOUEQ     *ON
     C                   ADD       1             I
     C                   MOVE      A8BICN        @BIC(I)
     C                   READ      SDBRCHL5                               99
     C                   ENDDO
 
     C                   ENDIF
 
      ** CARs
 
     C                   MOVE      'N'           CGL058
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL058'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL058
     C                   ENDIF
 
     C                   MOVE      'N'           CLE002
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   ENDIF
 
     C                   MOVE      'N'           CLE005
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ENDIF
 
     C                   MOVE      'N'           CLE009
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   ENDIF
 
     C                   MOVE      'N'           CLE014
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   ENDIF
 
     C                   MOVE      'N'           CLE023
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE023
     C                   ENDIF
 
     C                   MOVE      'N'           CLE025
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE025'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025
     C                   ENDIF
 
     C                   MOVE      'N'           CLE028
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE028'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE028
     C                   ENDIF
 
     C                   MOVE      'N'           CLE031
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE031'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE031
     C                   ENDIF
 
     C                   MOVE      'N'           CEU004
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   ENDIF
 
      ** Key Lists
 
     C     KSEQ          KLIST                                                                263412
     C                   KFLD                    YBRCA                                        263412
     C                   KFLD                    YPORG                                        263412
     C                   KFLD                    YPDVDT                                       263412
                                                                                              263412
     C     KLOAN         KLIST
     C                   KFLD                    WLOAN
 
     C     KLAKEY        KLIST
     C                   KFLD                    WKLNR
     C                   KFLD                    WKVDT
     C                   KFLD                    WKLSN
 
     C     KFEE          KLIST
     C                   KFLD                    WFECU
     C                   KFLD                    WFFAC
     C                   KFLD                    WFLNO
     C                   KFLD                    WFSEQ
 
     C     KFAC          KLIST
     C                   KFLD                    WFECU
     C                   KFLD                    WFACT
     C                   KFLD                    WFCNO
     C                   KFLD                    WRCDT
 
     C     KFCOD         KLIST
     C                   KFLD                    WFECD
 
     C     KFCLT         KLIST
     C                   KFLD                    WFCUS
     C                   KFLD                    WFTYP
     C**********         KFLD                    WFSEQ                                        263289
     C                   KFLD                    WFCSQ                                        263289
     C                   KFLD                    WRCDT1
 
     C     KFCAM         KLIST
     C                   KFLD                    WFCUS
     C                   KFLD                    WFTYP
     C**********         KFLD                    WFSEQ                                        263289
     C                   KFLD                    WFCSQ                                        263289
 
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return
     C                   PARM                    @Type
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETLOANP - SETUP Original loan and preliminary data           *
      *                                                               *
      *****************************************************************
 
     C     SETLOANP      BEGSR
 
     C                   EVAL      WLOAN = NORLN
 
      ** Retrieve and update the loan AUTO flag
 
     C     KLOAN         CHAIN     CLOAN                              99
 
     C                   IF        *IN99 = *ON OR
     C                             C1RECI <> 'D'
     C                   MOVE      '*ERR036'     @@RTCD
     C                   MOVE      NORLN         DBKEY
     C                   EVAL      DBFILE = 'CLOANCL'
     C                   EVAL      DBASE = 36
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Set Loan AUTO flag to 'C' for a loan
 
     C                   EVAL      C1AUTO = 'C'
 
      ** Reporting
 
     C                   EVAL      C1RIDT = NRIDT
     C                   EVAL      C1RCAT = NRCAT
     C                   EVAL      C1RIDC = 0
     C                   EVAL      C1RCAC = 0
     C                   EVAL      C1RCDY = NRCDY
     C                   EVAL      C1RCSD = NRCSD
     C                   EVAL      C1RICC = 0
 
      ** Basel II
 
     C                   EVAL      C1BIDT = NBIDT
     C                   EVAL      C1BCAT = NBCAT
     C                   EVAL      C1BIDC = 0
     C                   EVAL      C1BCAC = 0
     C                   EVAL      C1BCDY = NBCDY
     C                   EVAL      C1BCSD = NBCSD
     C                   EVAL      C1RICC = 0
 
     C                   UPDATE    CLOANCLF
 
     C                   ENDIF
 
      ** Retrieve base rates, penalties, ranges, etc. for all
 
     C                   EVAL      WLTYP = C_LTYP
     C                   EVAL      WSUTP = C_SUTP
     C                   EVAL      WCLAS = C_CLAS
 
      ** Find type/subtype info
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WLTYP         PLoanType
     C                   PARM      WSUTP         PLSubType
     C                   PARM      WCLAS         PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C     WLTYP         CAT       WSUTP         DBKEY
     C                   MOVE      WCLAS         DBKEY
     C                   MOVE      '*ERR013'     @@RTCD
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 013
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Find range for PDCL loan
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AYPPLT        PLoanType
     C                   PARM      AYPPLS        PLSubType
     C                   PARM      AYPPLC        PLClass
     C     SDLOAN1       PARM      SDLOAN1       DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C     AYPPLT        CAT       AYPPLS        DBKEY
     C                   MOVE      AYPPLC        DBKEY
     C                   MOVE      '*ERR035'     @@RTCD
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 035
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Override the AY fields of the original loan where necessary
 
     C                   MOVE      @AYLNTY       AYLNTY
     C                   MOVE      @AYLNST       AYLNST
     C                   MOVE      @AYLCD        AYLCD
     C                   MOVE      @AYTYLC       AYTYLC
     C                   MOVE      @AYLNTD       AYLNTD
     C                   MOVE      @AYLNPT       AYLNPT
     C                   MOVE      @AYEXPC       AYEXPC
     C                   MOVE      @AYINN1       AYINN1
     C                   MOVE      @AYINNR       AYINNR
     C                   MOVE      @AYLVLD       AYLVLD
     C                   MOVE      @AYDPRC       AYDPRC
     C                   MOVE      @AYRANG       AYRANG
     C                   MOVE      @AYILTY       AYILTY
     C                   MOVE      @AYILST       AYILST
     C                   MOVE      @PLDPCD       PLDPCD
     C                   MOVE      @PLDRCD       PLDRCD
     C                   MOVE      @PLCRED       PLCRED
     C                   MOVE      @AYYLDC       AYYLDC
     C                   MOVE      @AYFYLD       AYFYLD
     C                   MOVE      @AYYLDM       AYYLDM
     C                   MOVE      @AYFYCM       AYFYCM
     C                   MOVE      @AYZONE       AYZONE
     C                   MOVE      @AYACAI       AYACAI
     C                   MOVE      @AYLNCL       AYLNCL
     C                   MOVE      @AYILCL       AYILCL
     C                   MOVE      @AYIUSR       AYIUSR
     C                   MOVE      @AYAUSR       AYAUSR
     C                   MOVE      @AYXUSR       AYXUSR
     C                   MOVE      @AYAACC       AYAACC
     C                   MOVE      @AYEACC       AYEACC
     C                   MOVE      @AYGPDT       AYGPDT
     C                   MOVE      @AYOVRD       AYOVRD
     C**********         MOVE      @AYPCKO       AYPCKO                                       CLE164
     C                   MOVE      @AYPGID       AYPGID                                       CLE164
 
      ** Access Penalties files and override values
 
     C     WLOAN         CHAIN     LEPRATL1                           99
 
     C                   IF        *IN99 = *OFF
     C                   IF        B2CAPI <> ' '                                            AR467031
     C                   EVAL      AYCAPI = B2CAPI
     C                   ENDIF                                                              AR467031
                                                                                            AR467031
     C                   IF        B2SPLI <> ' '                                            AR467031
     C                   EVAL      AYSIIN = B2SPLI
     C                   ENDIF                                                              AR467031
                                                                                            AR467031
     C**********         IF        B2PBSR <> 0                                     AR467031 AR549587
     C                   EVAL      AYPBSR = B2PBSR
     C**********         ENDIF                                                     AR467031 AR549587
                                                                                            AR467031
     C                   EVAL      AYPBRT = B2PBRT
 
     C**********         IF        B2PRSP <> 0                                     AR467031 AR549587
     C                   EVAL      AYPRSP = B2PRSP
     C**********         ENDIF                                                     AR467031 AR549587
                                                                                            AR467031
     C**********         IF        B2PRAT <> ' '                                   AR467031 AR549587
     C                   EVAL      AYPRSI = B2PRAT
     C**********         ENDIF                                                     AR467031 AR549587
                                                                                            AR467031
     C                   IF        B2PICB <> 0                                              AR467031
     C                   EVAL      AYPICB = B2PICB
     C                   ENDIF                                                              AR467031
                                                                                            AR467031
     C                   IF        B2IBSR <> 0                                              AR467031
     C                   EVAL      AYIBSR = B2IBSR
     C                   ENDIF                                                              AR467031
                                                                                            AR467031
     C                   IF        B2IBRT <> 0
     C                   EVAL      AYIBRT = B2IBRT
     C                   ENDIF
 
     C                   IF        B2IRSP <> 0                                              AR467031
     C                   EVAL      AYIRSP = B2IRSP
     C                   ENDIF                                                              AR467031
                                                                                            AR467031
     C                   IF        B2IRAT <> ' '                                            AR467031
     C                   EVAL      AYIRSI = B2IRAT
     C                   ENDIF                                                              AR467031
                                                                                            AR467031
     C                   IF        B2IICB <> 0                                              AR467031
     C                   EVAL      AYIICB = B2IICB
     C                   ENDIF                                                              AR467031
                                                                                            AR467031
     C                   IF        B2POPR <> ' '                                            AR467031
     C                   EVAL      AYPOPR = B2POPR
     C                   ENDIF                                                              AR467031
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETLOANI - SETUP Original loan and preliminary data           *
      *                                                               *
      *****************************************************************
 
     C     SETLOANI      BEGSR
 
     C                   EVAL      WLOAN = NORLN
 
      ** Retrieve and update the loan AUTO flag
 
     C     KLOAN         CHAIN     CLOAN                              99
 
     C                   IF        *IN99 = *ON OR
     C                             C1RECI <> 'D'
     C                   MOVE      '*ERR040'     @@RTCD
     C                   MOVE      NORLN         DBKEY
     C                   EVAL      DBFILE = 'CLOANCL'
     C                   EVAL      DBASE = 40
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Set Loan AUTO flag to 'C' for a loan
 
     C                   EVAL      C1AUTO = 'C'
 
      ** Reporting
 
     C                   EVAL      C1RIDT = NRIDT
     C                   EVAL      C1RCAT = NRCAT
     C                   EVAL      C1RIDC = 0
     C                   EVAL      C1RCAC = 0
     C                   EVAL      C1RCDY = NRCDY
     C                   EVAL      C1RCSD = NRCSD
     C                   EVAL      C1RICC = 0
 
      ** Basel II
 
     C                   EVAL      C1BIDT = NBIDT
     C                   EVAL      C1BCAT = NBCAT
     C                   EVAL      C1BIDC = 0
     C                   EVAL      C1BCAC = 0
     C                   EVAL      C1BCDY = NBCDY
     C                   EVAL      C1BCSD = NBCSD
     C                   EVAL      C1RICC = 0
 
     C                   UPDATE    CLOANCLF
 
     C                   ENDIF
 
      ** Retrieve base rates, penalties, ranges, etc. for all
 
     C                   EVAL      WLTYP = C_LTYP
     C                   EVAL      WSUTP = C_SUTP
     C                   EVAL      WCLAS = C_CLAS
 
      ** Find type/subtype info
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WLTYP         PLoanType
     C                   PARM      WSUTP         PLSubType
     C                   PARM      WCLAS         PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C     WLTYP         CAT       WSUTP         DBKEY
     C                   MOVE      WCLAS         DBKEY
     C                   MOVE      '*ERR041'     @@RTCD
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 042
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Find range for PDCL loan
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AYIPLT        PLoanType
     C                   PARM      AYIPLS        PLSubType
     C                   PARM      AYIPLC        PLClass
     C     SDLOAN1       PARM      SDLOAN1       DSFDY                                        262851
     C*****SDLOAN        PARM      SDLOAN        DSSDY                                        262851
 
     C                   IF        @RTCD <> *BLANKS
     C     AYIPLT        CAT       AYIPLS        DBKEY
     C                   MOVE      AYIPLC        DBKEY
     C                   MOVE      '*ERR043'     @@RTCD
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 043
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Override the AY fields of the original loan where necessary
 
     C                   MOVE      @AYLNTY       AYLNTY
     C                   MOVE      @AYLNST       AYLNST
     C                   MOVE      @AYLCD        AYLCD
     C                   MOVE      @AYTYLC       AYTYLC
     C                   MOVE      @AYLNTD       AYLNTD
     C                   MOVE      @AYLNPT       AYLNPT
     C                   MOVE      @AYEXPC       AYEXPC
     C                   MOVE      @AYINN1       AYINN1
     C                   MOVE      @AYINNR       AYINNR
     C                   MOVE      @AYLVLD       AYLVLD
     C                   MOVE      @AYDPRC       AYDPRC
     C                   MOVE      @AYRANG       AYRANG
     C                   MOVE      @AYILTY       AYILTY
     C                   MOVE      @AYILST       AYILST
     C                   MOVE      @PLDPCD       PLDPCD
     C                   MOVE      @PLDRCD       PLDRCD
     C                   MOVE      @PLCRED       PLCRED
     C                   MOVE      @AYYLDC       AYYLDC
     C                   MOVE      @AYFYLD       AYFYLD
     C                   MOVE      @AYYLDM       AYYLDM
     C                   MOVE      @AYFYCM       AYFYCM
     C                   MOVE      @AYZONE       AYZONE
     C                   MOVE      @AYACAI       AYACAI
     C                   MOVE      @AYLNCL       AYLNCL
     C                   MOVE      @AYILCL       AYILCL
     C                   MOVE      @AYIUSR       AYIUSR
     C                   MOVE      @AYAUSR       AYAUSR
     C                   MOVE      @AYXUSR       AYXUSR
     C                   MOVE      @AYAACC       AYAACC
     C                   MOVE      @AYEACC       AYEACC
     C                   MOVE      @AYGPDT       AYGPDT
     C                   MOVE      @AYOVRD       AYOVRD
     C**********         MOVE      @AYPCKO       AYPCKO                                       CLE164
     C                   MOVE      @AYPGID       AYPGID                                       CLE164
 
      ** Access Penalties files and override values
 
     C     WLOAN         CHAIN     LEPRATL1                           99
 
     C                   IF        *IN99 = *OFF
     C                   IF        B2CAPI <> ' '                                            AR549587
     C                   EVAL      AYCAPI = B2CAPI
     C                   ENDIF                                                              AR549587
                                                                                            AR549587
     C                   IF        B2SPLI <> ' '                                            AR549587
     C                   EVAL      AYSIIN = B2SPLI
     C                   ENDIF                                                              AR549587
                                                                                            AR549587
     C                   EVAL      AYPBSR = B2PBSR
     C                   EVAL      AYPBRT = B2PBRT
     C                   EVAL      AYPRSP = B2PRSP
     C                   EVAL      AYPRSI = B2PRAT
     C                   EVAL      AYPICB = B2PICB
     C                   EVAL      AYIBSR = B2IBSR
     C                   EVAL      AYIBRT = B2IBRT
     C                   EVAL      AYIRSP = B2IRSP
     C                   EVAL      AYIRSI = B2IRAT
                                                                                            AR549587
     C                   IF        B2IICB <> 0                                              AR549587
     C                   EVAL      AYIICB = B2IICB
     C                   ENDIF                                                              AR549587
                                                                                            AR549587
     C                   EVAL      AYPOPR = B2POPR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETFEE - SETUP Original fee and preliminary data              *
      *                                                               *
      *****************************************************************
 
     C     SETFEE        BEGSR
 
      ** Retrieve and update the fee AUTO flag
 
     C                   EVAL      WFECU = NFECU
     C                   EVAL      WFSEQ = NFSEQ
     C                   EVAL      WFFAC = NFFAC
     C                   EVAL      WFLNO = NFLNO
 
     C     KFEE          CHAIN     LEFEEDL0
 
     C                   IF        NOT %FOUND OR
     C                             FERECI <> 'D'
     C                   EVAL      DBKEY = 'KFEE'
     C                   EVAL      DBFILE = 'LEFEEDL0'
     C                   EVAL      DBASE = 902
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set Loan Fee AUTO flags to 'C'
 
     C                   EVAL      FEAUTO = 'C'
     C                   EVAL      FEAUT2 = 'C'
 
      ** Reporting
 
     C                   EVAL      FERIDT = NRIDT
     C                   EVAL      FERCAT = NRCAT
     C                   EVAL      FERIDC = 0
     C                   EVAL      FERCAC = 0
     C                   EVAL      FERCSD = NRCSD
     C                   EVAL      FERCDY = NRCDY
     C                   EVAL      FERICC = 0
 
      ** Basel II
 
     C                   EVAL      FEBIDT = NBIDT
     C                   EVAL      FEBCAT = NBCAT
     C                   EVAL      FEBIDC = 0
     C                   EVAL      FEBCAC = 0
     C                   EVAL      FEBCSD = NBCSD
     C                   EVAL      FEBCDY = NBCDY
     C                   EVAL      FERICC = 0
 
      ** Retrieve Fee Code information
 
     C                   MOVE      FEFCOD        WFCOD
 
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WFCOD         @FECD
     C     SDFEE         PARM      SDFEE         DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDFEEPD'
     C                   EVAL      DBKEY = @FECD
     C                   EVAL      DBASE = 14
     C                   MOVE      '*ERR014'     @@RTCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve base rates, penalties, ranges, etc. for all
 
     C                   EVAL      WLTYP = AUCLTY
     C                   EVAL      WSUTP = AUCLST
     C                   EVAL      WCLAS = AUCLCL
 
      ** Find type/subtype info
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WLTYP         PLoanType
     C                   PARM      WSUTP         PLSubType
     C                   PARM      WCLAS         PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C     WLTYP         CAT       WSUTP         DBKEY
     C                   MOVE      WCLAS         DBKEY
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 15
     C                   MOVE      '*ERR015'     @@RTCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     NPDFA         NPDPR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETCLOANCx - Setup new loan                                   *
      *                                                               *
      *****************************************************************
 
     C     SETCLOANCx    BEGSR
 
     C                   EVAL      WLSEQ = *ZEROS
 
      ** SET FIELDS ON INSERT
 
     C                   EVAL      L_CLRECI = 'D'
     C**********         EVAL      L_CLLNRF = F9NALN                                          CLE148
     C                   EVAL      L_CLLNRF = F9NALA                                          CLE148
     C                   EVAL      L_CLRCDT = 'A'
     C                   EVAL      L_CLMRIN = 1
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLCNUM = C_CNUM
     C                   EVAL      WLSEQ = C_FSEQ
     C                   ELSE
     C                   EVAL      L_CLCNUM = E_FECNUM
     C                   IF        RecordType = FeeLoan                                     AR827807
     C                   EVAL      WLSEQ  = C_FSEQ                                          AR827807
     C                   ELSE                                                               AR827807
     C                   MOVE      E_FEFACL      WLSEQ
     C                   ENDIF                                                              AR827807
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLBRCA = C_BRCA
     C                   ELSE
     C                   EVAL      L_CLBRCA = E_FEBRCA
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      RecordType = Loan AND NPLO2 = *BLANK
     C                   EVAL      L_CLLTYP = AYPPLT
     C                   EVAL      L_CLSUTP = AYPPLS
     C                   EVAL      L_CLCLAS = AYPPLC
 
     C                   WHEN      RecordType = Loan AND NPLO2 = *BLANK
     C                   EVAL      L_CLLTYP = AYIPLT
     C                   EVAL      L_CLSUTP = AYIPLS
     C                   EVAL      L_CLCLAS = AYIPLC
 
     C                   WHEN      RecordType <> Loan
     C                   EVAL      L_CLLTYP = AUCLTY
     C                   EVAL      L_CLSUTP = AUCLST
     C                   EVAL      L_CLCLAS = AUCLCL
     C                   ENDSL
 
     C                   EVAL      L_CLPTYP = AYLNPT
 
      ** Setup LoanType
 
     C                   SELECT
     C                   WHEN      L_CLPTYP = 61
     C                             OR L_CLPTYP = 62
     C                             OR L_CLPTYP = 63
     C                             OR L_CLPTYP = 70
     C                             OR L_CLPTYP = 80
     C                             AND CLE028 = 'Y'
     C                   EVAL      LoanType = 'LOAN'
 
     C                   WHEN      L_CLPTYP = 64
     C                             OR L_CLPTYP = 65
     C                             OR L_CLPTYP = 68
     C                             OR L_CLPTYP = 71
     C                   EVAL      LoanType = 'PTPU'
 
     C                   WHEN      L_CLPTYP = 66 OR
     C                             L_CLPTYP = 67 OR
     C                             L_CLPTYP = 69 OR
     C                             L_CLPTYP = 72
     C                   EVAL      LoanType = 'PTSO'
     C                   ENDSL
 
     C**********         EVAL      L_CLDDAT = BJRDNB
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLDDAT = C_DDAT
     C                   ELSE
     C                   EVAL      L_CLDDAT = E_FEORED
     C                   ENDIF
 
     C                   EVAL      L_CLVDAT = NSDAT
     C                   EVAL      L_CLMDAT = 0
     C**********         EVAL      L_CLLASQ = 1                                             AR322571
     C                   IF        SeqFlg = 'Y'
     C                   EVAL      L_CLLASQ = WLSEQ
     C                   ELSE
     C                   EVAL      L_CLLASQ = C_LASQ                                        AR322571
     C                   ENDIF
 
     C                   IF        RecordType = Loan OR
     C                             RecordType = FeeLoan
     C                   EVAL      L_CLFCUS = C_FCUS
     C                   ELSE
     C                   EVAL      L_CLFCUS = E_FECNUM
     C                   ENDIF
 
     C                   IF        RecordType = Loan OR
     C                             RecordType = FeeLoan
     C                   EVAL      L_CLFTYP = C_FTYP
     C                   ELSE
     C                   MOVEL     E_FEFACL      L_CLFTYP
     C                   ENDIF
 
     C                   IF        RecordType = Loan OR
     C                             RecordType = FeeLoan
     C                   EVAL      L_CLFSEQ = C_FSEQ
     C                   ELSE
     C                   MOVE      E_FEFACL      L_CLFSEQ
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLCCY = C_CCY
     C                   ELSE
     C                   EVAL      L_CLCCY = E_FEFCCY
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      (NPDIN <> 0 AND NPDPR <> 0)
     C                             AND NSEIN = 'N' AND NCAPI = 'Y'
     C                   EVAL      L_CLCPAM = NPDIN + NPDPR                                 AR321628
 
     C**********         WHEN      (NPDIN <> 0 AND NPDPR = 0                                  263360
     C**********                   OR NPDIN <> 0 AND NPDPR <> 0 AND NSEIN = 'Y')              263360
     C**********                   AND NPLO2 <> 0                                             263360
 
     C                   WHEN      (NPDIN<>0 AND NPDPR=0)                                     263360
     C                             OR (NPDIN<>0 AND NPDPR<>0 AND NSEIN='Y')                   263360
     C                             AND (NPLO2<>*BLANK)                                        263360
     C                   EVAL      L_CLCPAM = NPDIN
 
     C**********         WHEN      (NPDIN = 0 AND NPDPR <> 0                                  263360
     C**********                   OR NPDIN <> 0 AND NPDPR <> 0 AND NSEIN = 'Y')              263360
     C**********                   AND NPLO2 = 0                                              263360
 
     C                   WHEN      (NPDIN=0 AND NPDPR<>0)                                     263360
     C                             OR (NPDIN<>0 AND NPDPR<>0 AND NSEIN='Y')                   263360
     C                             AND (NPLO2=*BLANK)                                         263360
     C                   EVAL      L_CLCPAM = NPDPR
     C                   ENDSL
 
     C                   EVAL      L_CLINTC = 'N'
 
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        NPLO2 = *BLANK
     C                   EVAL      L_CLBRTT = AYPBSR
     C                   EVAL      L_CLBRTE = AYPBRT
     C                   ELSE
     C                   EVAL      L_CLBRTT = AYIBSR
     C                   EVAL      L_CLBRTE = AYIBRT
     C                   ENDIF
 
     C                   WHEN      RecordType = FeeLoan OR
     C                             RecordType = FeeFacility
     C                   EVAL      L_CLBRTT = AUCBSR
     C                   EVAL      L_CLBRTE = AUCBRT
     C                   ENDSL
 
     C                   IF        L_CLBRTT <> 0
     C                   MOVE      L_CLCCY       @KEY1
     C                   MOVE      L_CLBRTT      @KEY2
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM                    @KEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
 
     C                   IF        @RTCD <> *BLANKS OR
     C**********                   BPBRCF <> 'Y' OR                                         AR826115
     C                             L_CLCCY <> BACYCD
     C     @KEY1         CAT       @KEY2         DBKEY
     C                   EVAL      DBFILE = 'SDBSRTPD'
     C                   EVAL      DBASE = 17
     C                   MOVE      '*ERR017'     @@RTCD
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        L_CLBRTT = 0
     C                   ELSE
     C                   IF        L_CLVDAT < BAVDNR
     C                   EVAL      L_CLBRTE = BACBSR
     C                   ELSE
     C                   EVAL      L_CLBRTE = BANBRT
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   IF        NPLO2 = *BLANK
     C                   EVAL      L_CLRTSP = AYPRSP
     C                   ELSE
     C                   EVAL      L_CLRTSP = AYIRSP
     C                   ENDIF
     C                   ELSE
     C                   EVAL      L_CLRTSP = AUCRSP
     C                   ENDIF
                                                                                            AR826115
     C                   IF        BPBRCF = 'N'                                             AR826115
     C                   EVAL      L_CLBRTT = 0                                             AR826115
     C                   EVAL      L_CLBRTE = 0                                             AR826115
      *                                                                                     AR826115
     C                   IF        L_CLSPIN = 'A'                                           AR826115
     C                   EVAL      L_CLRTSP = C_BRTE + C_RTSP                               AR826115
     C                   ELSE                                                               AR826115
     C                   EVAL      L_CLRTSP = C_BRTE - C_RTSP                               AR826115
     C                   ENDIF                                                              AR826115
      *                                                                                     AR826115
     C                   EVAL      L_CLSPIN    = ' '                                        AR826115
     C                   ENDIF                                                              AR826115
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLMARG = C_MARG
     C                   ELSE
     C                   EVAL      L_CLMARG = 0
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   IF        NPLO2 = *BLANK
     C                   EVAL      L_CLSPIN = AYPRSI
     C                   ELSE
     C                   EVAL      L_CLSPIN = AYIRSI
     C                   ENDIF
     C                   ELSE
     C                   EVAL      L_CLSPIN = AUCRIN
     C                   ENDIF
                                                                                              263228
     C                   IF        L_CLSPIN = *BLANKS                                         263228
     C**********         IF        L_CLBRTE   <> 0             OR                    263228 AR549587
     C**********                   L_CLRTSP   <> 0                                   263228 AR549587
     C                   EVAL      L_CLSPIN = 'A'                                             263228
     C**********         ENDIF                                                       263228 AR549587
     C                   ENDIF                                                                263228
                                                                                              263228
      ** Interest rate
 
     C                   SELECT
     C                   WHEN      L_CLSPIN = 'A'
     C     L_CLBRTE      ADD       L_CLRTSP      L_CLINTR
 
     C                   WHEN      L_CLSPIN = 'S'
     C     L_CLBRTE      SUB       L_CLRTSP      L_CLINTR
 
     C                   WHEN      L_CLSPIN = 'P'
     C     L_CLRTSP      DIV       100           WRK_139
     C     WRK_139       MULT(h)   L_CLBRTE      L_CLINTR
 
     C**********         WHEN      L_CLSPIN = *Blank                                        AR549587
     C**********         Z-ADD     L_CLRTSP      L_CLINTR                                   AR549587
     C                   ENDSL
 
     C                   SELECT
     C                   WHEN      L_CLBRTT = 0 AND L_CLBRTE = 0
     C                   EVAL      L_CLCHIN = *BLANKS
 
     C                   WHEN      L_CLBRTT <> 0 AND
     C                             RecordType = FeeLoan OR
     C                             L_CLBRTT <> 0 AND
     C                             RecordType = FeeFacility
     C                             OR (L_CLBRTE <> 0
     C                             AND RecordType = FeeLoan)
     C                             OR (L_CLBRTE <> 0
     C                             AND RecordType = FeeFacility)
     C**********         EVAL      L_CLCHIN = AUCRIN                                        AR719589
     C                   EVAL      L_CLCHIN = AUBSRI                                        AR719589
 
     C                   WHEN      L_CLBRTT <> 0 AND
     C                             RecordType = Loan
     C                             OR (L_CLBRTE <> 0
     C                             AND RecordType = Loan)
     C                   EVAL      L_CLCHIN = C_CHIN
     C                   ENDSL
     C
     C                   EVAL      L_CLWTRT = 0
     C                   EVAL      L_CLWTIN = *BLANKS
     C                   EVAL      L_CLREPT = 2
     C                   EVAL      L_CLRAMT = 0
     C                   EVAL      L_CLNRPD = 0
     C                   EVAL      L_CLRFRQ = *BLANKS
     C                   EVAL      L_CLRDYN = 0
 
     C                   IF        RecordType = Loan OR
     C                             RecordType = FeeLoan
     C                   EVAL      L_CLFCCY = C_FCCY
     C                   ELSE
     C                   EVAL      L_CLFCCY = M_FCCY
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLLIND = C_LIND
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      E_FECNUM      @KEY3
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   MOVE      L_CLLIND      BBLICD
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLCRSK = C_CRSK
     C                   ELSE
     C                   EVAL      L_CLCRSK = M_CRSK
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLACOF = C_ACOF
     C                   ELSE
     C                   EVAL      L_CLACOF = E_FEACOF
     C                   ENDIF
 
     C                   MOVE      'B'           L_CLNACD
 
     C                   IF        RecordType = Loan
     C                   EVAL      L_CLRELI = C_RELI
     C                   ELSE
     C                   MOVE      *BLANKS       L_CLRELI
     C                   ENDIF
 
     C                   MOVE      'C'           L_CLAUTO
     C                   Z-ADD     0             L_CLPSAM
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      L_CLCCY       @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Z-ADD     A6SPRT        L_CLBCXR
 
     C                   MOVE      A6MDIN        WMDINC
     C                   Z-ADD     A6SPRT        WSPRTC
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      L_CLFCCY      @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   MOVE      A6MDIN        WMDINF
     C                   Z-ADD     A6SPRT        WSPRTF
 
      ** Use FCXR from origin loan to avoid discrepancy on fachisa                          AR705750
      ** OL Amount not equal to PDCL amount                                                 AR705750
                                                                                            AR705750
     C**********         IF        L_CLFCCY <> BJCYCD                                       AR705750
     C**********         IF        (WMDINC = 'M' and WMDINF = 'M')                          AR705750
     C**********                   OR (WMDINC = 'D' and WMDINF = 'D')                       AR705750
     C**********         EVAL      L_CLFCXR = WSPRTF / WSPRTC                               AR705750
     C**********         ELSE                                                               AR705750
     C**********         EVAL      L_CLFCXR = WSPRTF * WSPRTC                               AR705750
     C**********         ENDIF                                                              AR705750
     C**********         ELSE                                                               AR705750
 
     C                   IF        RecordType = Loan                                        AR705750
     C                   EVAL      L_CLFCXR = C_FCXR                                        AR705750
     C                   ELSE                                                               AR705750
     C                   EVAL      L_CLFCXR = WSPRTC
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_QQOSDA
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_TSTN        L_CLTSTN
     C                   ELSE
     C                   IF        E_PTFI <> *BLANKS
     C                   MOVE      E_AWBN        L_CLTSTN
     C                   ELSE
     C                   MOVE      E_RIBN        L_CLTSTN
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_QQOMDA
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_TMAN        L_CLTMAN
     C                   ELSE
     C                   IF        E_PTFI <> *BLANKS
     C                   MOVE      E_AWBN        L_CLTMAN
     C                   ELSE
     C                   MOVE      E_RIBN        L_CLTMAN
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_BENN        L_CLFACO
     C                   ELSE
     C                   MOVE      E_BENN        L_CLFACO
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   Z-ADD     C_RLDT        L_CLRLDT
     C                   Z-ADD     C_NROD        L_CLNROD
     C                   MOVE      C_RLFQ        L_CLRLFQ
     C                   Z-ADD     C_RLDY        L_CLRLDY
     C                   MOVE      C_RDFC        L_CLRDFC
     C                   ELSE
     C                   Z-ADD     0             L_CLRLDT
     C                   Z-ADD     0             L_CLNROD
     C                   MOVE      *BLANKS       L_CLRLFQ
     C                   Z-ADD     0             L_CLRLDY
     C                   MOVE      'N'           L_CLRDFC
     C                   ENDIF
 
     C                   Z-ADD     0             L_CLNBRA
     C                   Z-ADD     0             L_CLNRTS
     C                   MOVE      *BLANKS       L_CLNSIN
     C                   Z-ADD     0             L_CLNCAS
     C                   Z-ADD     0             L_CLAWTP
     C                   Z-ADD     0             L_CLWTRD
     C                   Z-ADD     0             L_CLWTWD
     C                   Z-ADD     0             L_CLIWOD
     C                   Z-ADD     0             L_CLPWOD
     C                   MOVE      WMDINC        L_CLBMDI
 
     C                   IF        RecordType = Loan                                        AR705750
     C                   EVAL      L_CLFMDI = C_FMDI                                        AR705750
     C                   ELSE                                                               AR705750
     C                   SELECT
     C                   WHEN      L_CLFCCY <> BJCYCD AND WMDINF ='M'
     C                   EVAL      L_CLFMDI = 'D'
 
     C                   WHEN      L_CLFCCY <> BJCYCD AND WMDINF ='D'
     C                   EVAL      L_CLFMDI = 'M'
 
     C                   WHEN      L_CLFCCY = BJCYCD
     C                   EVAL      L_CLFMDI = WMDINC
     C                   ENDSL
     C                   ENDIF                                                              AR705750
 
     C                   Z-ADD     0             L_CLPDIN
     C                   Z-ADD     0             L_CLLSWC
     C                   Z-ADD     0             L_CLLSWS
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_OSDB        L_CLOSDB
     C                   MOVE      C_OMDB        L_CLOMDB
     C                   MOVE      C_ORBR        L_CLORBR
     C                   ELSE
      *                                                                                    AR706513A
      ** For fees, OSDB is the receipt and OMDB is the pay                                 AR706513A
      *                                                                                    AR706513A
     C**********         MOVE      E_OSDB        L_CLOSDB                                  AR706513A
     C**********         MOVE      E_OMDB        L_CLOMDB                                  AR706513A
     C**********         MOVE      C_ORBR        L_CLORBR                                  AR706513A
     C                   MOVE      E_OSDB        L_CLOMDB                                  AR706513A
     C                   MOVE      E_OMDB        L_CLOSDB                                  AR706513A
     C                   MOVE      E_FEBRCA      L_CLORBR                                  AR706513A
     C                   IF        CGL058 = 'Y'
     C                             AND BGMBIN = 'Y'
     C                             AND BKOBRU = 'Y'
     C                   EVAL      L_CLORBR = BBBRCD
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        BKOBRU = 'Y'
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       PRTNC
     C                   PARM      L_CLBOKC      PBOOK
     C                   PARM                    PTRTP
     C                   PARM                    PSUTP
     C                   PARM                    PBRAN
     C                   PARM      *BLANKS       PDEPT
     C                   PARM                    PUSER
     C                   PARM                    PACOF
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PPRFC
     C                   MOVE      PPRFC         L_CLPRFC
     C                   ENDIF
 
     C                   IF        RecordType = Loan OR
     C                             RecordType = FeeLoan
     C                   MOVE      C_FCLB        L_CLFCLB
     C                   ELSE
     C                   MOVE      M_BRCA        L_CLFCLB
     C                   ENDIF
 
     C                   MOVE      *BLANK        L_CLMLNR
 
     C                   IF        LoanType <> 'PTSO'
     C                   MOVE      BPBTIN        L_CLBTIN
     C                   Z-ADD     BPDBDY        L_CLBLDY
     C                   ELSE
     C                   MOVE      *BLANKS       L_CLBTIN
     C                   Z-ADD     0             L_CLBLDY
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_OLNO        L_CLOLNO
     C                   ELSE
     C                   MOVE      *BLANKS       L_CLOLNO
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_CLRCSI
 
     C                   IF        RecordType = Loan
     C                   IF        NSEIN = 'N'
     C                   Z-ADD     AYPICB        L_CLICBS
     C                   ELSE
                                                                                            AR467031
      ** Use Interest/Principal field                                                       AR467031
                                                                                            AR467031
     C                   SELECT                                                             AR467031
     C                   WHEN       YPDCT = 'I'                                             AR467031
     C                   Z-ADD     AYIICB        L_CLICBS
                                                                                            AR467031
     C                   WHEN       YPDCT = 'P'                                             AR467031
     C                   Z-ADD     AYPICB        L_CLICBS                                   AR467031
     C                   ENDSL                                                              AR467031
     C                   ENDIF
 
     C                   ELSE
     C                   Z-ADD     0             L_CLICBS
     C                   IF        AUICBS <> 0
     C                   Z-ADD     AUICBS        L_CLICBS
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_CLIPFR
     C                   Z-ADD     0             L_CLTOTI
     C                   Z-ADD     0             L_CLNIDT
     C                   Z-ADD     0             L_CLIBDT
     C                   Z-ADD     NSDAT         L_CLSLID
     C                   Z-ADD     0             L_CLAIPD
     C                   Z-ADD     NSDAT         L_CLDLRC
     C                   Z-ADD     0             L_CLIACD
     C                   Z-ADD     0             L_CLAITC
     C                   Z-ADD     0             L_CLTFEP
     C                   Z-ADD     0             L_CLAIAP
     C                   Z-ADD     0             L_CLIPRD
     C                   Z-ADD     0             L_CLIPRM
     C                   Z-ADD     0             L_CLICTD
     C                   Z-ADD     0             L_CLAIMN
     C                   Z-ADD     0             L_CLRBDT
     C                   Z-ADD     0             L_CLNOPS
     C                   MOVE      *BLANKS       L_CLNCHI
     C                   Z-ADD     0             L_CLIFDY
     C                   BITOFF    '01234567'    L_CLCNFI
     C                   MOVE      'I'           L_CLCHTP
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_ADDI        L_CLADDI
     C                   ELSE
     C                   IF        BKALDI = 'Y'
     C                   MOVE      'L'           L_CLADDI
     C                   ELSE
     C                   MOVE      'F'           L_CLADDI
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     0             L_CLORMD
     C                   Z-ADD     0             L_CLORTI
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_BOKC        L_CLBOKC
     C                   MOVE      C_COCU        L_CLCOCU
     C                   MOVE      C_RECE        L_CLRECE
     C                   ELSE
     C                   IF        RecordType = FeeLoan                                    AR1054914
     C                   MOVE      C_BOKC        L_CLBOKC                                  AR1054914
     C                   ELSE                                                              AR1054914
     C                   MOVE      BPDBKC        L_CLBOKC
     C                   ENDIF                                                             AR1054914
     C                   MOVE      *BLANKS       L_CLCOCU
     C                   MOVE      *BLANKS       L_CLRECE
     C                   ENDIF
 
     C                   Z-ADD     0             L_CLOMDT
     C                   Z-ADD     0             L_CLNIPD
     C                   Z-ADD     0             L_CLNMDT
     C                   MOVE      'Y'           L_CLAPMI
 
     C                   IF        RecordType = Loan
 
     C                   IF        C_RSTM > 0 AND C_PSTM = 0
     C                   MOVE      C_RSTM        C_PSTM
     C                   MOVE      C_RONS        C_PONS
     C                   MOVE      C_OMDB        L_CLOSDB                                  AR706513A
     C                   ENDIF
 
     C                   IF        C_RSTM = 0 AND C_PSTM > 0
     C                   MOVE      C_PSTM        C_RSTM
     C                   MOVE      C_PONS        C_RONS
     C                   MOVE      C_OSDB        L_CLOMDB                                  AR706513A
     C                   ENDIF
 
     C                   ELSE
     C                   IF        E_RSTM > 0 AND E_PSTM = 0
     C                   MOVE      E_RSTM        E_PSTM
     C                   MOVE      E_RONS        E_PONS
      *                                                                                    AR706513A
      ** Initialise loan's SDST (start settlement) and Start settlement branch             AR706513A
      *                                                                                    AR706513A
     C                   MOVE      E_RSTM        L_CLSDST                                  AR706513A
     C                   MOVE      E_OSDB        L_CLOSDB                                  AR706513A
     C                   ENDIF
     C**********         IF        C_RSTM = 0 AND C_PSTM > 0                               AR706513A
     C                   IF        E_RSTM = 0 AND E_PSTM > 0                               AR706513A
     C                   MOVE      E_PSTM        E_RSTM
     C                   MOVE      E_PONS        E_RONS
      *                                                                                    AR706513A
      ** Initialise loan's MDST (maturity settlement) and Maturity Branch                  AR706513A
      *                                                                                    AR706513A
     C                   MOVE      E_PSTM        L_CLMDST                                  AR706513A
     C                   MOVE      E_OMDB        L_CLOMDB                                  AR706513A
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        RecordType = Loan
     C                   Z-ADD     C_RSTM        L_CLRSTM
     C                   ELSE
     C                   Z-ADD     E_RSTM        L_CLRSTM
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_QQRONS
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_RIBN        L_CLRIBN
     C                   MOVE      C_RIBA        L_CLRIBA
     C                   MOVE      C_ROBN        L_CLROBN
     C                   MOVE      C_ROCN        L_CLROCN
     C                   Z-ADD     C_PSTM        L_CLPSTM
     C                   ELSE
     C                   MOVE      E_RIBN        L_CLRIBN
     C                   MOVE      E_RIBA        L_CLRIBA
     C                   MOVE      E_ROBN        L_CLROBN
     C                   MOVE      E_ROCN        L_CLROCN
     C                   Z-ADD     E_PSTM        L_CLPSTM
     C                   ENDIF
 
     C                   IF        RecordType = Loan                                       AR706513A
     C**********         IF        Loantype <> 'PSTO'                                      AR1001250
     C                   IF        Loantype <> 'PTSO'                                      AR1001250
     C                   MOVE      C_PSTM        L_CLSDST
     C                   MOVE      C_RSTM        L_CLMDST
     C                   ELSE
     C                   MOVE      C_RSTM        L_CLSDST
     C                   MOVE      C_PSTM        L_CLMDST
     C                   ENDIF
     C                   ELSE                                                              AR1001250
     C                   MOVE      E_PSTM        L_CLSDST                                  AR1001250
     C                   MOVE      E_RSTM        L_CLMDST                                  AR1001250
     C                   ENDIF                                                             AR706513A
      *
     C                   IF        RecordType = Loan
     C                   MOVE      C_PIBN        L_CLPIBN
     C                   MOVE      C_PIBA        L_CLPIBA
     C                   MOVE      C_POBN        L_CLPOBN
     C                   MOVE      C_POCN        L_CLPOCN
     C                   MOVE      C_RCRN        L_CLRCRN
     C                   MOVE      C_RCRA        L_CLRCRA
     C                   MOVE      C_RVNO        L_CLRVNO
     C                   MOVE      C_AWBN        L_CLAWBN
     C                   MOVE      C_AWBA        L_CLAWBA
     C                   MOVE      C_BENN        L_CLBENN
     C                   MOVE      C_BENA        L_CLBENA
     C                   MOVE      C_DTP1        L_CLDTP1
     C                   MOVE      C_DTP2        L_CLDTP2
     C                   MOVE      C_DTP3        L_CLDTP3
     C                   MOVE      C_DTP4        L_CLDTP4
     C                   MOVE      C_BTB1        L_CLBTB1
     C                   MOVE      C_BTB2        L_CLBTB2
     C                   MOVE      C_BTB3        L_CLBTB3
     C                   MOVE      C_BTB4        L_CLBTB4
     C                   MOVE      C_BTB5        L_CLBTB5
     C                   MOVE      C_BTB6        L_CLBTB6
     C                   MOVE      C_CVMR        L_CLCVMR
     C                   ELSE
     C                   MOVE      M_PIBN        L_CLPIBN
     C                   MOVE      M_PIBA        L_CLPIBA
     C                   MOVE      M_POBN        L_CLPOBN
     C                   MOVE      M_POCN        L_CLPOCN
     C                   MOVE      M_RCRN        L_CLRCRN
     C                   MOVE      M_RCRA        L_CLRCRA
     C                   MOVE      M_RVNO        L_CLRVNO
     C                   MOVE      M_AWBN        L_CLAWBN
     C                   MOVE      M_AWBA        L_CLAWBA
     C                   MOVE      M_BENN        L_CLBENN
     C                   MOVE      M_BENA        L_CLBENA
     C                   MOVE      M_DTP1        L_CLDTP1
     C                   MOVE      M_DTP2        L_CLDTP2
     C                   MOVE      M_DTP3        L_CLDTP3
     C                   MOVE      M_DTP4        L_CLDTP4
     C                   MOVE      M_BTB1        L_CLBTB1
     C                   MOVE      M_BTB2        L_CLBTB2
     C                   MOVE      M_BTB3        L_CLBTB3
     C                   MOVE      M_BTB4        L_CLBTB4
     C                   MOVE      M_BTB5        L_CLBTB5
     C                   MOVE      M_BTB6        L_CLBTB6
     C                   MOVE      M_CVMR        L_CLCVMR
     C                   ENDIF
 
     C                   IF        RecordType = Loan OR
     C                             RecordType = FeeLoan
     C                   MOVE      C_PTFR        L_CLPTFR
     C                   ELSE
 
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        ANDNE     'Y'
 
     C                   MOVE      *BLANKS       L_CLPTFR
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     L_CLBRCA      I#BRCA
     C                   MOVEL     L_CLCNUM      I#CUST
     C                   MOVEL     L_CLBOKC      I#BOOK
     C                   MOVEL     L_CLPTFR      I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
 
     C                   CALLB     'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSSDY
 
     C                   MOVE      'N'           WPTCS
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           WPTCS
     C                   ENDIF
 
     C     WPTCS         IFEQ      'Y'
     C     C_CNUM        SETLL     PMPORTL1
     C     C_CNUM        READE     PMPORTL1
     C                   DOW       %FOUND
     C                   IF        PNRECI = 'D'
     C                   MOVE      PNPTFR        L_CLPTFR
     C                   ENDIF
     C     C_CNUM        READE     PMPORTL1
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_CLHLEX
 
     C                   IF        RecordType = Loan
     C                   Z-ADD     C_FSRP        L_CLFSRP
     C                   MOVE      C_FSGN        L_CLFSGN
     C                   MOVE      C_FPRC        L_CLFPRC
     C                   ELSE
     C                   Z-ADD     0             L_CLFSRP
     C                   MOVE      *BLANKS       L_CLFSGN
     C                   MOVE      E_FEPRFC      L_CLFPRC
     C                   ENDIF
 
     C                   Z-ADD     0             L_CLTCOF
     C                   Z-ADD     0             L_CLACPD
     C                   Z-ADD     0             L_CLACDA
     C                   Z-ADD     0             L_CLACAJ
     C                   Z-ADD     0             L_CLACAP
     C                   Z-ADD     0             L_CLCOFD
     C                   Z-ADD     0             L_CLCOFM
     C                   Z-ADD     0             L_CLCFCD
     C                   Z-ADD     0             L_CLNFRS
     C                   MOVE      *BLANKS       L_CLNFSN
     C                   MOVE      *BLANKS       L_CLNFPC
     C                   Z-ADD     0             L_CLPDCF
     C                   Z-ADD     0             L_CLFCTD
     C                   Z-ADD     0             L_CLFWOD
     C                   MOVE      *BLANKS       L_CLDFTP
     C                   MOVE      *BLANKS       L_CLDFST
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_MCRA        L_CLMCRA
     C                   ELSE
     C                   MOVE      *BLANKS       L_CLMCRA
     C                   ENDIF
 
     C                   Z-ADD     0             L_CLFCRA
     C                   MOVE      'M'           L_CLPDDI
     C                   MOVE      'M'           L_CLPTDI
     C                   Z-ADD     0             L_CLGDPR
     C                   Z-ADD     0             L_CLGDIN
     C                   MOVE      'N'           L_CLLNKS
     C                   MOVE      'M'           L_CLMNSG
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_GASS        L_CLGASS
     C                   ELSE
     C                   MOVE      *BLANKS       L_CLGASS
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_CLGPRT
     C                   MOVE      *BLANK        L_CLTOLN
     C                   MOVE      WIUSR         L_CLIUSR
     C                   MOVE      *BLANKS       L_CLAUSR
     C                   MOVE      *BLANKS       L_CLXUSR
     C                   MOVE      *BLANKS       L_CLRATF
     C                   MOVE      *BLANKS       L_CLLPFI
     C                   MOVE      *BLANKS       L_CLPTFC
     C                   Z-ADD     0             L_CLPTFT
     C                   Z-ADD     0             L_CLPTFN
     C                   MOVE      *BLANKS       L_CLPCOB
     C                   Z-ADD     0             L_CLLRLD
     C                   Z-ADD     0             L_CLLMCD
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_SCCY        L_CLSCCY
     C                   MOVE      C_ICCY        L_CLICCY
     C                   ELSE
     C                   MOVE      E_FESCCY      L_CLSCCY
     C                   MOVE      E_FEICCY      L_CLICCY
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_CLREPI
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_RFDY        L_CLRFDY
     C                   MOVE      C_RFRI        L_CLRFRI
     C                   MOVE      C_RFRT        L_CLRFRT
     C                   MOVE      C_RFAR        L_CLRFAR
     C                   ELSE
     C                   MOVE      *BLANKS       L_CLRFDY
     C                   MOVE      *BLANKS       L_CLRFRI
     C                   MOVE      *BLANKS       L_CLRFRT
     C                   MOVE      *BLANKS       L_CLRFAR
     C                   ENDIF
 
     C                   MOVE      *BLANKS       L_CLYLDC
     C                   MOVE      *BLANKS       L_CLFYLD
     C                   Z-ADD     0             L_CLURPL
     C                   Z-ADD     0             L_CLPLAM
     C                   Z-ADD     0             L_CLPLDT
     C                   Z-ADD     0             L_CLYUPL
     C                   MOVE      'N'           L_CLADIF
     C                   MOVE      'N'           L_CLADCF
     C                   Z-ADD     0             L_CLCHGA
     C                   MOVE      'N'           L_CLICIF
     C                   Z-ADD     0             L_CLFLTI
     C                   Z-ADD     0             L_CLFRPD
     C                   Z-ADD     0             L_CLACCH
     C                   Z-ADD     0             L_CLFSEFUP
     C                   Z-ADD     0             L_CLFSECUP
     C                   Z-ADD     0             L_CLAIPN
     C                   Z-ADD     0             L_CLAITN
     C                   Z-ADD     0             L_CLAIAN
     C                   Z-ADD     0             L_CLIPRN
     C                   Z-ADD     0             L_CLAIMN
     C                   Z-ADD     0             L_CLTOTN
     C                   Z-ADD     0             L_CLICTN
     C                   Z-ADD     0             L_CLIWON
     C                   Z-ADD     0             L_CLIPNM
     C                   Z-ADD     0             L_CLPDNN
     C                   Z-ADD     0             L_CLFSCPAM
     C                   Z-ADD     0             L_CLFPAM
     C                   Z-ADD     0             L_CLREXR
     C                   MOVE      *BLANKS       L_CLREXI
     C                   MOVE      *BLANKS       L_CLPSCY
     C                   Z-ADD     0             L_CLPEXR
     C                   MOVE      *BLANKS       L_CLPEXI
     C                   MOVE      *BLANKS       L_CLSTAL
     C                   MOVE      DDFRNT        L_CLFRNT
     C                   MOVE      *BLANKS       L_CLAFRT
     C                   MOVE      *BLANKS       L_CLREPA
     C                   MOVEL     TimeStmpDS    L_CLTMES
 
     C                   IF        RecordType = Loan
     C                   MOVE      C_OSDA        L_CLOSDA
     C                   MOVE      C_OMDA        L_CLOMDA
     C                   MOVE      C_RONS        L_CLRONS
     C                   MOVE      C_PONS        L_CLPONS
     C                   ELSE
     C                   MOVE      E_PONS        L_CLOSDA
     C                   MOVE      E_RONS        L_CLOMDA
     C                   MOVE      E_RONS        L_CLRONS
     C                   MOVE      E_PONS        L_CLPONS
     C                   ENDIF
 
     C                   MOVE      'Y'           L_CLAUTH
     C                   Z-ADD     0             L_TFDP
     C                   Z-ADD     0             L_TFDPA
     C                   Z-ADD     0             L_TFAM
     C                   Z-ADD     0             L_TFAC
     C                   Z-ADD     0             L_TFOF
     C                   Z-ADD     0             L_AFDP
     C                   Z-ADD     0             L_CFDP
     C                   Z-ADD     0             L_AMDS
     C                   Z-ADD     0             L_AMADJ
     C                   Z-ADD     0             L_ANADJ
     C                   Z-ADD     0             L_DSAM
     C                   Z-ADD     0             L_AMCOST
     C                   Z-ADD     0             L_YMCOST
     C                   Z-ADD     0             L_YAINT
     C                   Z-ADD     0             L_CLBASR
     C                   Z-ADD     0             L_CLNBSR
     C                   MOVE      *BLANKS       L_CLSLTP
     C                   MOVE      *BLANKS       L_CLSLST
 
     C                   MOVE      L_CLCLAS      L_CLDFCL
     C                   MOVE      *BLANKS       L_CLSLCL
 
     C                   IF        RecordType = Loan
     C                   MOVE      AYFAMU        L_CLFAMU
     C                   ELSE
     C                   MOVE      AUFAMU        L_CLFAMU
     C                   ENDIF
 
     C                   Z-ADD     *ZEROS        L_CLRIDT
     C                   Z-ADD     *ZEROS        L_CLRIDC
     C                   Z-ADD     *ZEROS        L_CLRCAT
     C                   Z-ADD     *ZEROS        L_CLRCAC
     C                   Z-ADD     *ZEROS        L_CLRICC
     C                   Z-ADD     *ZEROS        L_CLBIDT
     C                   Z-ADD     *ZEROS        L_CLBIDC
     C                   Z-ADD     *ZEROS        L_CLBCAT
     C                   Z-ADD     *ZEROS        L_CLBCAC
     C                   Z-ADD     *ZEROS        L_CLBICC
 
     C                   MOVE      *BLANKS       L_CLFPNR
 
      ** Set up in LECLIPUPD
 
     C**********         Z-ADD     0             L_CLOINR
     C**********         Z-ADD     0             L_CLOIDT
     C**********         Z-ADD     0             L_CLLONI
     C**********         Z-ADD     0             L_CLACEI
     C**********         Z-ADD     0             L_CLTLXI
     C**********         Z-ADD     0             L_CLCBLI
     C**********         Z-ADD     0             L_CLORED
     C**********         Z-ADD     0             L_CLLCD
     C**********         Z-ADD     0             L_CLTNLU
     C**********         Z-ADD     0             L_CLCNCF
     C**********         Z-ADD     0             L_CLPCRF
     C**********         Z-ADD     0             L_CLLSTS
 
      ** CLOANCK
 
     C                   MOVE      'D'           R_CLRECI
     C**********         Z-ADD     F9NALN        R_CLLNRF                                     CLE148
     C                   MOVEL     F9NALA        R_CLLNRF                                     CLE148
     C                   MOVE      'B'           R_CLRCDT
     C                   Z-ADD     4             R_CLMRIN
     C                   MOVE      NORLN         WORLN
     C                   MOVE      E_FELOAN      WLOANT
     C                   MOVE      E_FEFSEQ      WFSEQT
     C                   MOVE      E_FEFACL      WFACLT
 
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C     TXT01         CAT       WORLN         R_CLNAR1
 
     C                   WHEN      RecordType = FeeLoan
     C     TXT02         CAT       E_FECNUM      R_CLNAR1
     C     R_CLNAR1      CAT       WLOANT        R_CLNAR1
     C     R_CLNAR1      CAT       WFSEQT        R_CLNAR1
 
     C                   WHEN      RecordType = FeeFacility
     C     TXT02         CAT       E_FECNUM      R_CLNAR1
     C     R_CLNAR1      CAT       WFACLT        R_CLNAR1
     C     R_CLNAR1      CAT       WFSEQT        R_CLNAR1
     C                   ENDSL
 
     C                   MOVE      *BLANKS       R_CLNAR2
     C                   MOVE      *BLANKS       R_CLNAR3
     C                   MOVE      *BLANKS       R_CLNAR4
     C                   Z-ADD     L_CLCPAM      R_CLOPAM
     C                   Z-ADD     0             R_CLFRBC
     C                   Z-ADD     0             R_CLYPLN
     C                   Z-ADD     0             R_CLYFLN
     C                   Z-ADD     0             R_CLYWLN
     C                   Z-ADD     0             R_CLABLN
     C                   Z-ADD     0             R_CLYPLC
     C                   Z-ADD     0             R_CLYFLC
     C                   Z-ADD     0             R_CLYWLC
     C                   Z-ADD     0             R_CLABLC
     C                   Z-ADD     0             R_CLWWLN
     C                   Z-ADD     0             R_CLIWLN
     C                   Z-ADD     0             R_CLPWLN
     C                   Z-ADD     0             R_CLRDST
 
     C                   IF        RecordType = Loan
     C                   MOVE      K_SPI1        R_CLSPI1
     C                   MOVE      K_SPI2        R_CLSPI2
     C                   MOVE      K_SPI3        R_CLSPI3
     C                   ELSE
     C                   MOVE      *BLANKS       R_CLSPI1
     C                   MOVE      *BLANKS       R_CLSPI2
     C                   MOVE      *BLANKS       R_CLSPI3
     C                   ENDIF
 
     C                   Z-ADD     0             R_CLYILN
     C                   MOVE      *BLANKS       R_CLF57U
     C                   MOVE      *BLANKS       R_CLTHRN
     C                   Z-ADD     0             R_CLNPRA
     C                   Z-ADD     0             R_CLNDAM
     C                   MOVE      *BLANKS       R_CLRLBR
     C                   MOVE      'I'           R_CLCHTP
     C                   Z-ADD     0             R_CLRRST
     C                   MOVE      *BLANKS       R_CLRRIB
     C                   MOVE      *BLANKS       R_CLRRBA
     C                   MOVE      *BLANKS       R_CLRROB
     C                   MOVE      *BLANKS       R_CLRROC
     C                   MOVE      *BLANKS       R_CLNCCY
     C                   Z-ADD     0             R_CLNFCE
     C                   MOVE      *BLANKS       R_CLNFMD
     C                   Z-ADD     0             R_CLNLRA
     C                   MOVE      *BLANKS       R_CLRSTS
     C                   MOVE      *BLANKS       R_CLRIUS
     C                   MOVE      *BLANKS       R_CLRXUS
     C                   MOVE      *BLANKS       R_CLRPCR
     C                   MOVE      *BLANKS       R_CLRLSB
     C                   Z-ADD     0             R_CLRPST
     C                   MOVE      *BLANKS       R_CLRPIB
     C                   MOVE      *BLANKS       R_CLRPBA
     C                   MOVE      *BLANKS       R_CLRPOB
     C                   MOVE      *BLANKS       R_CLRPOC
     C                   MOVE      *BLANKS       R_CLRRCR
     C                   MOVE      *BLANKS       R_CLRRCA
     C                   MOVE      *BLANKS       R_CLRRVN
     C                   MOVE      *BLANKS       R_CLRAWB
     C                   MOVE      *BLANKS       R_CLRAWA
     C                   MOVE      *BLANKS       R_CLRBEN
     C                   MOVE      *BLANKS       R_CLRBNA
     C                   MOVE      *BLANKS       R_CLRDP1
     C                   MOVE      *BLANKS       R_CLRDP2
     C                   MOVE      *BLANKS       R_CLRDP3
     C                   MOVE      *BLANKS       R_CLRDP4
     C                   MOVE      *BLANKS       R_CLRDCH
     C                   MOVE      *BLANKS       R_CLRBB1
     C                   MOVE      *BLANKS       R_CLRBB2
     C                   MOVE      *BLANKS       R_CLRBB3
     C                   MOVE      *BLANKS       R_CLRBB4
     C                   MOVE      *BLANKS       R_CLRBB5
     C                   MOVE      *BLANKS       R_CLRBB6
     C                   MOVE      *BLANKS       R_CLRCVM
     C                   Z-ADD     0             R_CLNBCE
     C                   MOVE      *BLANKS       R_CLNBMD
     C                   MOVE      *BLANKS       R_CLRRSC
     C                   MOVE      *BLANKS       R_CLRPSC
     C                   MOVE      *BLANKS       R_CLRICY
     C                   MOVE      *BLANKS       R_CLECIN
     C                   MOVE      *BLANKS       R_CLRPSM
     C                   MOVE      *BLANKS       R_CLRPTS
     C                   MOVE      *BLANKS       R_CLRPSB
     C                   MOVE      *BLANKS       R_CLRFAO
     C                   MOVE      *BLANKS       R_CLFYLB
     C                   Z-ADD     0             R_CLRRSR
     C                   MOVE      *BLANKS       R_CLRRSI
     C                   Z-ADD     0             R_CLRPSR
     C                   MOVE      *BLANKS       R_CLRPSI
     C                   MOVE      *BLANKS       R_CLRSTA
     C                   MOVE      *BLANKS       R_CLAFRT
     C                   MOVE      *BLANKS       R_CLREPA
     C                   MOVEL     TimeStmpDS    R_CLTMES
     C                   MOVE      *BLANKS       R_CLORVD
     C                   MOVE      *BLANKS       R_CLRRON
     C                   MOVE      *BLANKS       R_CLRPON
     C                   MOVE      *BLANKS       R_CLRPOS
 
      ** Defined in LECLIPUPD
 
     C**********         Z-ADD     0             R_CLORED
     C**********         Z-ADD     0             R_CLLCD
     C**********         Z-ADD     0             R_CLTNLU
     C**********         Z-ADD     0             R_CLNCPA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * ACS_NXTAVL - ACCESS NEXT AVAILABLE LOAN REFERENCE            *
      *                                                              *
      ****************************************************************
 
     C     ACS_NXTAVL    BEGSR
 
     C                   CALL      'AOLENOU0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      AYRANG        @PRANG
     C     SDLENO        PARM      SDLENO        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     @PRANG        DBKEY
     C                   MOVEL     'SDLENOPD'    DBFILE
     C                   Z-ADD     91            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C*****F9NALN        IFGT      0                                                          CLE148
     C*****F9NALN        SUB       1             F9NALN                                       CLE148
     C**********         ENDIF                                                                CLE148
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FCLTSR   - Sub-routine to update exposure.                    *
      *            internal customer                                  *
      * Called by: SRFCLT                                             *
      * Calls    :  QFCLTY                                            *
      *                                                               *
      *****************************************************************
 
     C     FCLTSR        BEGSR
 
     C                   IF          L_CLPTYP = 66 OR
     C                               L_CLPTYP = 67 OR
     C                               L_CLPTYP = 69 OR
     C                               L_CLPTYP = 72
     C                   MOVE      *ON           *IN52
     C                   ELSE
     C                   MOVE      *OFF          *IN52
     C                   ENDIF
 
      ** Convert amounts into facility currency equivalent
 
     C     WTRCA         IFEQ      *BLANK
 
     C     CLE023        IFEQ      'Y'
     C     L_CLRLDT      ANDLT     BJRDNB
     C     L_CLRLDT      ANDNE     *ZERO
     C     R_CLNFCE      ANDNE     *ZERO
     C     R_CLNCCY      ANDEQ     *BLANKS
     C                   Z-ADD     R_CLNFCE      WFCXR
     C                   MOVE      'Y'           WROFXR
     C                   ELSE
     C                   Z-ADD     L_CLFCXR      WFCXR
     C                   MOVE      'N'           WROFXR
     C                   ENDIF
 
     C     CDPF          SUB       A6NBDP        CX
     C     CX            ADD       4             CX
     C     L_CLFMDI      IFEQ      'D'
     C     WROFXR        ANDEQ     'N'
     C     R_CLNFMD      OREQ      'D'
     C     WROFXR        ANDEQ     'Y'
     C     WFCXR         MULT(H)   Powr(Cx)      OFCXRT
     C     1             DIV       OFCXRT        OFCXRT
     C                   ELSE
     C     WFCXR         MULT(H)   Powr(Cx)      OFCXRT
     C                   ENDIF
 
     C     PRAMR         MULT(H)   OFCXRT        PRAM_Fac
 
      ** Convert amount to facility currency using spot rates
 
     C     CLE023        IFEQ      'Y'
     C                   MOVE      A6MDIN        ZMDI1
     C                   IF        CLE023 = 'Y'
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   Z-ADD     A6NBDP        ZNBDP1
     C                   ENDIF
 
     C                   MOVE      WMDINF        ZMDI2
     C                   Z-ADD(H)  WSPRTF        ZRATE2
     C                   Z-ADD     CDPF          ZNBDP2
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      0             ZRATEX
     C                   PARM      *BLANKS       ZMDIX
 
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
     C                   Z-ADD     PRAMR         ZAMTCI
     C                   MOVE      LA_CCY        ZCCYI
     C                   MOVE      FCCY          ZCCYO
     C                   Z-ADD     ZNBDP1        ZCDPI
     C                   Z-ADD     ZNBDP2        ZCDPO
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      0             ZAMTCO
 
     C                   Z-ADD     ZAMTCO        WrkPRAMS
     C                   ENDIF
 
     C                   ENDIF
 
      **  Set up fields for availability updating
 
     C**********         Z-ADD     C_MDAT        ENDAY                    40                  263840
     C******IN40         IFEQ      '1'                                                        263840
     C**********         Z-ADD     99999         ENDAY                                        263840
     C                   Z-ADD     99999         ENDAY                                        263840
     C**********         ENDIF                                                                263840
     C**********         Z-ADD     C_VDAT        DAYNO                                        263840
     C                   Z-ADD     LA_VDAT       DAYNO                                        263840
 
     C                   MOVEA     '00'          *IN(41)
 
      ** Similar update for a non-syndicated loan and part purchased,
      ** internal parts purchased and funding participant
 
     C*****M_RVCR        IFEQ      'Y'                                                        263840
     C*****WRVCRC        ANDEQ     ' '                                                        263840
     C*****M_RVCR        OREQ      'N'                                                        263840
     C*****WRVCRC        ANDEQ     'Y'                                                        263840
     C*****WVLDT         ANDLE     BJRDNB                                                     263840
     C*****WrkPart       OREQ      'Y'                                                        263840
     C*****C_GASS        ANDEQ     'A'                                                        263840
 
      ** Participation sold
 
     C     *IN52         IFEQ      '0'
     C     C_LPFI        ANDEQ     ' '
     C     WrkPart       OREQ      'Y'
     C     DDACTN        IFEQ      'I'
     C                   MOVE      '1'           *IN41
     C                   ELSE
     C                   MOVE      '1'           *IN42
     C                   ENDIF
 
      ** Similar update for a non-syndicated parts sold, and prime facilities
 
     C                   ELSE
     C     DDACTN        IFEQ      'I'
     C                   MOVE      '1'           *IN42
     C                   ELSE
     C                   MOVE      '1'           *IN41
     C                   ENDIF
     C                   ENDIF
     C**********         ENDIF                                                                263840
 
     C                   Z-ADD     PRAM_Fac      FCBAL
 
      ** Do not update for parts sold with recourse and
      ** if CLE023 is not installed.  If CLE023 is installed, do not
      ** update for parts sold for non-participant facility with or
      ** without recourse.  Also do not update
      ** Prime facility of a syndicated loan
 
     C     *IN52         IFEQ      '1'
     C     C_RCSI        ANDEQ     'Y'
     C     C_LPFI        ANDEQ     ' '
     C     CLE023        ANDEQ     'N'
 
     C     *IN52         OREQ      '1'
     C     C_LPFI        ANDEQ     ' '
     C     CLE023        ANDEQ     'Y'
 
     C     WrkPart       OREQ      'N'
     C     C_LPFI        ANDNE     ' '
     C                   MOVEA     '00'          *IN(41)
     C                   ENDIF
 
      ** If customer is branch internal customer, then no update to
      ** facility availability
 
     C                   EXSR      SRCIBC
 
      ** If ind  43 is on, then customer is an internal customer
      ** Or, if LPFI equals 'I', then loan is an IPP
 
     C     *IN43         IFEQ      '1'
     C     C_LPFI        ANDNE     'I'
     C     C_LPFI        OREQ      'I'
     C     WrkPart       ANDEQ     'N'
     C                   MOVE      '0'           *IN43
     C                   ELSE
 
     C     *IN41         IFEQ      '1'
     C     *IN42         OREQ      '1'
     C                   EXSR      QFCLTY
     C                   ENDIF
 
     C                   ENDIF
 
      **  UPDATE EXPOSURE
 
      ** Internal parts purchased and funding participants are updated
      ** just like any normal loan.  Prime facilities are updated only
      ** when sold without recourse just like a parts sold
      ** Also, since future-dated manual repayments can now be entered,
      ** update exposure only when value date is not in the future
      ** Update CAMD of Prime or normal facility only if loan is not
      ** a parts sold.  If CLE023 is installed, update the exposure
      ** only if normal loan or a funded loan is sold without recourse
 
     C     LA_VDAT       IFLE      BJRDNB
     C     C_LPFI        IFNE      *BLANK
     C     DDACTN        IFEQ      'I'
     C     WrkPart       ANDEQ     'Y'
     C     DDACTN        OREQ      'R'
     C     WrkPart       ANDEQ     'N'
     C     L_CLRCSI      ANDNE     'Y'
     C     C_LPFI        ANDNE     'I'
 
     C     WrkPart       IFEQ      'Y'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'
     C     CAMD          SUB       PRAM_Fac      CAMD
     C                   ENDIF
 
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'
     C     CEXP          SUB       WrkPRAMS      CEXP
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** 'C'hanged
 
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
 
     C                   ENDIF
 
     C     DDACTN        IFEQ      'R'
     C     WrkPart       ANDEQ     'Y'
     C     DDACTN        OREQ      'I'
     C     WrkPart       ANDEQ     'N'
     C     L_CLRCSI      ANDNE     'Y'
     C     C_LPFI        ANDNE     'I'
 
     C     WrkPart       IFEQ      'Y'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'
     C     CAMD          ADD       PRAM_Fac      CAMD
     C                   ENDIF
 
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'
     C     CEXP          ADD       WrkPRAMS      CEXP
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** 'C'hanged
 
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
 
     C                   ENDIF
 
      ** normal, non-syndicated loans
 
     C                   ELSE
 
     C     *IN52         IFEQ      '0'
     C     DDACTN        ANDEQ     'I'
     C     *IN52         OREQ      '1'
     C     DDACTN        ANDEQ     'R'
     C     L_CLRCSI      ANDNE     'Y'
 
     C     *IN52         IFEQ      '0'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'
     C     CAMD          SUB       PRAM_Fac      CAMD
     C                   ENDIF
 
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'
     C     CEXP          SUB       WrkPRAMS      CEXP
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** 'C'hanged
 
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
 
     C                   ENDIF
 
     C     *IN52         IFEQ      '0'
     C     DDACTN        ANDEQ     'R'
     C     *IN52         OREQ      '1'
     C     DDACTN        ANDEQ     'I'
     C     L_CLRCSI      ANDNE     'Y'
 
     C     *IN52         IFEQ      '0'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'
     C     CAMD          ADD       PRAM_Fac      CAMD
     C                   ENDIF
 
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'
     C     CEXP          ADD       WrkPRAMS      CEXP
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** changed
 
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPCA   - Sub-routine to update credit agreement             *
      * Called by: SRFCLT                                             *
      * Calls    : FCLTSR                                             *
      *                                                               *
      *****************************************************************
 
     C     SRUPCA        BEGSR
 
      **  Whenever the facility utilisation is updated for a tranche,
      **  update the credit agreement/superfacility as well
 
     C                   MOVE      FCCY          WTCCY
     C                   MOVE      CMDI          WCMDI
     C                   Z-ADD     CAXR          WCAXR
     C                   MOVEL     CANM          WFCUS
     C                   MOVEL     CAFT          WFTYP
     C**********         MOVEL     CAFN          WFSEQ                                        263289
     C                   MOVEL     CAFN          WFCSQ                                        263289
     C                   MOVE      'A'           WRCDT1
 
      ** Save the revolving credit indicator specified for the tranche
 
     C     CLE014        IFEQ      'Y'
     C                   MOVE      M_RVCR        WRVCRF
     C                   ENDIF
 
     C     KFCLT         CHAIN(N)  FCLTY                              79
 
     C     *IN79         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR018'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'FCLTY'       DBFILE
     C                   Z-ADD     18            DBASE
     C                   MOVEL(P)  WDBKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If the revolving credit indicator for the credit agreement is
      ** 'T', use the saved tranche revolving credit indicator as the
      ** credit agreement revolving indicator.
 
     C     CLE014        IFEQ      'Y'
 
     C     M_RVCR        IFEQ      'T'
     C                   MOVE      WRVCRF        M_RVCR
     C                   ENDIF
 
     C                   ENDIF
     C                   MOVE      'B'           WRCDT1
     C     KFCLT         CHAIN     FCLTY                              79
 
     C     *IN79         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR019'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE
     C                   Z-ADD     19            DBASE
     C                   MOVEL(P)  WDBKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If tranche and superfacility currencies are different, get
      ** superfacility currency details
 
     C     WTCCY         IFNE      FCCY
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FCCY          PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*ERR020'     @@RTCD
     C                   MOVEL     'LEPDCLUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     20            DBASE
     C                   MOVEL     FCCY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Convert facility amount to credit facility currency
 
     C                   Z-ADD     A6NBDP        CDPC
     C                   EVAL      CX = CDPC - CDPF + 4
     C     WCMDI         IFEQ      'D'
     C     WCAXR         DIV(H)    POWR(Cx)      OFCXRT
     C     1             DIV       OFCXRT        OFCXRT
     C                   ELSE
     C     WCAXR         MULT(H)   POWR(CX)      OFCXRT
     C                   ENDIF
 
     C                   MULT(H)   OFCXRT        PRAM_Fac
 
      ** Convert facility amount to Credit agreement facility using
      ** spot rate for later update of Current exposure
 
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     WSPRTF        ZRATE1
     C                   MOVE      WMDINF        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   MOVE      A6MDIN        ZMDI2
     C                   Z-ADD     CDPF          ZNBDP1
     C                   Z-ADD     CDPC          ZNBDP2
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
 
     C                   Z-ADD     WrkPRAMS      ZAMTCI
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
     C                   MOVE      WTCCY         ZCCYI
     C                   MOVE      FCCY          ZCCYO
     C                   Z-ADD     ZNBDP1        ZCDPI
     C                   Z-ADD     ZNBDP2        ZCDPO
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      0             ZAMTCO
 
     C                   Z-ADD     ZAMTCO        WrkPRAMS
     C                   ENDIF
     C                   ENDIF
 
      ** Update facility exposure and availability
 
     C                   MOVE      'Y'           WTRCA
     C                   EXSR      FCLTSR
     C                   Z-ADD     BJRDNB        M_LCD
     C                   MOVE      'A'           M_CHTP
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      0             M_TNLU
     C                   UPDATE    FCLTYFNF                             50
     C                   MOVE      *BLANK        WTRCA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCIBC   - Sub-routine to see if a customer is also a branch  *
      *            internal customer                                  *
      * Called by: SRFCLT                                             *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRCIBC        BEGSR
 
     C                   MOVE      '0'           *IN43
 
     C                   MOVEL     L_CLCNUM      ICUSTN
 
     C                   Z-ADD     1             W
     C     ICUSTN        LOOKUP    @BIC(W)                                43
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * QFCLTY   - Sub-routine to update availability array - FCLTY   *
      * Called by: SRFCLT                                             *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     QFCLTY        BEGSR
 
     C     DAYNO         IFEQ      0
     C                   GOTO      ENDFCT
     C                   ENDIF
 
     C                   Z-ADD     1             X
     C*****ENDAY         LOOKUP    RUNS(X)                            40  40                  263840
     C     ENDAY         LOOKUP    RUNS(X)                                40                  263840
     C     *IN40         IFEQ      '0'
     C                   Z-ADD     99            X
 
      ** with Manual Repayment on loans during I/C
      ** the availability (i.e. undrawn amount) should be updated
      ** to reflect the repayment.
      ** RUNS,1 = The previous working day
      ** ENDAY  = Maturity date of loan
 
     C                   ELSE
                                                                                              204708
      ** If Loan is not autosettled, then the O/S principal of that                           204708
      ** loan is included in all elements of the drawn amount array,                          204708
      ** even beyond the maturity date of the loan. So this MR amount                         204708
      ** should update all elements of the array if the loan is                               204708
      ** non-autosettled                                                                      204708
                                                                                              204708
     C     LA_AUTO       IFEQ      'N'                                                        204708
     C                   Z-ADD     99            X                                            204708
     C                   ENDIF                                                                204708
                                                                                              204708
     C*****ENDAY         IFLE      RUNS(1)                                                    263840
     C**********         Z-ADD     99            X                                            263840
     C**********         ENDIF                                                                263840
     C                   ENDIF
 
     C                   Z-ADD     1             W
     C*****DAYNO         LOOKUP    RUNS(W)                            40  40                  263840
     C     DAYNO         LOOKUP    RUNS(W)                                40                  263840
     C     *IN40         IFEQ      '0'
     C     DAYNO         IFGT      RUNS(10)                                                   263840
     C                   GOTO      ENDFCT
     C                   ELSE                                                                 263840
     C                   Z-ADD     1             W                                            263840
     C                   ENDIF                                                                263840
     C                   ENDIF
 
     C     W             DOWLE     10
     C     W             ANDLT     X
 
     C     *IN41         IFEQ      '1'
     C     CLE025        ANDEQ     'N'
     C     OAM(W)        SUB       FCBAL         OAM(W)
     C                   ENDIF
 
     C     *IN42         IFEQ      '1'
     C     CLE025        ANDEQ     'N'
     C     OAM(W)        ADD       FCBAL         OAM(W)
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** changed
 
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
 
     C     W             ADD       1             W
     C                   ENDDO
 
     C     ENDFCT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
 
      *****************************************************************
      /EJECT
      *****************************************************************
     O***LTRIX** E            LTRIXH                                                        AR322731
     O**********             NORE                11P                                        AR322731
     O**********             RRNA                20P                                        AR322731
     O**********             NLNR                29P                                        AR322731
     O**********             NATN                40P                                        AR322731
 
      ** Output LTRIX detail record
 
     O**********E            LTRIXD                                                         AR322731
     OLTRIX     EADD         LTRIXD                                                         AR322731
     O                                            2 'DA'
     O                       LA_LNRF              8
     O                       LA_VDAT             13
     O**********             LASN                16                                         AR322731
     O                       LA_LASN             16                                         AR322731
     O                       CHTP                17
     O                                           18 'N'
     O                                           19 'N'
     O                                           25 '00001'
     O                                           26 'N'
     O                       PRI1                27
     O                       RRNA                37P
     O                       NATN                40P
     O                                           43 '000'                                   AR322731
     O                                           44 ' '                                     AR322731
     O                                           45 ' '                                     AR322731
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
**  POWR -- USED IN CURRENCY CONVERSION(FACILITY)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
