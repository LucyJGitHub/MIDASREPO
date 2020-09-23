     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVRF*: OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)             : *
/*OVRF*: OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)              : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate GL & retail account number')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GLVRLAC - Validate GL & Retail Account Number                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR939238           Date 23Apr12               *
      *  Prev Amend No. AR1001991          Date 06Aug12               *
      *                 CRE114             Date 19Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042377           Date 01Dec16               *
      *                 MD034451C          Date 02Mar16               *
      *                 MD041157           Date 09Aug16               *
      *                 MD030959           Date 17Jun15               *
      *                 AR648606           Date 30Oct14               *
      *                 MD000091           Date 08May13               *
      *                 AR401983           Date 11Dec12               *
      *                 AR685469           Date 03Oct12               *
      *                 263834             Date 17Mar10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27532           Date 26Apr10               *
      *                 BUG27045A          Date 13Apr10               *
      *                 BUG27045           Date 18Feb10               *
      *                 CRE401             Date 26Nov09               *
      *                 242011             Date 04Sep06               *
      *                 CGL062             Date 19Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 253927 (BUG18124)  Date 17Apr08               *
      *                 253689 (BUG17640)  Date 09Apr08               *
      *                 248156A            Date 20Jun07               *
      *                 250349             Date 20Sep07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12768           Date 29Nov06               *
      *                 224897             Date 06Jun06               *
      *                 226550             Date 06Jun06               *
      *                 237598 (Reopen)    Date 10Mar06               *
      *                 237598             Date 15Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG4615            Date 26Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3584            Date 28Jul04               *
      *                 BUG2304            Date 30Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 216306             Date 11Apr03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 24Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR939238 - Array Index Error whenever during retail account  *
      *             closure when there are more than 20 Stopped or    *
      *             Held Items. Send RE71055/6 only once.             *
      *             (Child:AR939239)                                  *
      *  AR1001991 - Cannot close a/cs. Error message "MsgId RE75964 -*
      *              Ac cannot be mbr of Group A/c Hierarchy" is      *
      *              encounter. Accounts are allowed to be closed if  *
      *              removed from ZS hierarchy and GA hierarchy. Fix  *
      *              partially patterned in GEMS Fix 249548.          *
      *              (Child:AR1001992)                                *
      *  CRE114   - Modulus 10 for Retail Account Number (FOB006)     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042377 - Error RE71053 should only be validated against a  *
      *             retail account since GL account does not have a   *
      *             record in REIACD.                                 *
      *  MD034451C - Recompiled due to changed PF/HELDIHB             *
      *  MD041157 - Failure to close an account.  Check correct       *
      *             network files during account closure.             *
      *  MD030959 - Recompiled due to changed PF/HELDIHC.             *
      *  AR648606 - TI Interface error. If TI account flag is 'Y',    *
      *             account closure should not be allowed.            *
      *             (Child:AR648607)                                  *
      *  MD000091 - Event Codes Substitution                          *
      *  AR401983 - User cannot close an account due to error message *
      *             'RE71072: Cannot close account. Future valued     *
      *             postings in Items in Clearing exist.' Applied fix *
      *             245916 to modify fix 237598, to allow postings    *
      *             with value date of today's rundate.               *
      *             (Child: AR401982)                                 *
      *  AR685469 - User cannot close account due to error message    *
      *             'RE71052: Account name must be same as account    *
      *             name for this account file. Trimmed leading spaces*
      *             of ANAM before comparing it with the Account name *
      *             on midas plus screen. (Child: AR692551)           *
      *  263834 - MEC105 failed due to deleted accounts still used as *
      *           Swift reference. Amended program in a way that      *
      *           deletion is not allowed when record exists in file  *
      *           SWACSSB. Applied fix 263818.                        *
      *  BUG27532 - Several fields are blank in the confirmation page *
      *             (Recompile)                                       *
      *  BUG27045A - Override the fix of Bug 27045 (Recompile)        *
      *  BUG27045 - Amend via SOAP removes Document Linkage           *
      *             (Recompile)                                       *
      *  CRE401 - 4-Eyes Checking Gaps - Sweeps (Recompile)           *
      *  242011 - Moduls 11 Check only applies for Insert action      *
      *  CGL062 - Moduls 11 Check on Retail Account Number            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  253927 - Amend program such that error message for sweep     *
      *           check is displayed in the screen after Close Account*
      *           button was hit                                      *
      *  253689 - Check for existing sweep transactions before        *
      *           account closure (BUG17640)                          *
      *  248156A - Prevent CHQBKL1 from being locked by QZDASOINIT.   *
      *  250349 - Error message ID RE71072 is missing in the screen.  *
      *           Only one message ID RE71072 should be display in    *
      *           the screen                                          *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG12768 - Can't delete Account even with deleted            *
      *             standing orders                                   *
      *  224897 - Amend program such that deleted standing orders     *
      *           are excluded from check for existing outstanding    *
      *           standing orders.                                    *
      *  226550 - Amend program such that account closure is not      *
      *           allowed if account is linked to a prime account or  *
      *           linked to a live secondary account.                 *
      *           Apply fixes 219970 and 214871.                      *
      *  237598 - (Reopen) Recompiled due to change in PF/CLEARPD.    *
      *  237598 - Validate account if Items in Clearing still exists. *
      *           Account cannot be closed with pending future valued *
      *           postings.                                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG4615 - Show warning message upon deletion of account      *
      *            with cheque book details still existing            *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3584 - Increase the size of the file control fields       *
      *            (recompile).                                       *
      *  BUG2304 - Various file layout changes. Recompile.            *
      *  CGL029 - Increase account code to 10 digits                  *
      *  216306 - Deletion of Account not allowed if part of          *
      *           Zero balancing/Sweeping or Group Account hierarchies*
      *           (CRE008)                                            *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** RE Sweep details by credit account number
     FRESWEPL4  IF   E           K DISK    INFSR(*PSSR)
     FRESWEPL5  IF   E           K DISK    INFSR(*PSSR)                                       253927
     F                                     RENAME(RESWEPD0:RESWEP5F)                          253927
     FRESWEPL6  IF   E           K DISK    INFSR(*PSSR)                                       253689
     F                                     RENAME(RESWEPD0:RESWEP6F)                          253689
     F*RESWEPL2  IF   E           K DISK    INFSR(*PSSR)                               253689 253927
     F*                                     RENAME(RESWEPD0:RESWEP2F)                  253689 253927
     FRESWEPL7  IF   E           K DISK    INFSR(*PSSR)                                       253689
     F                                     RENAME(RESWEPD0:RESWEP7F)                          253689
     FRESWEPL8  IF   E           K DISK    INFSR(*PSSR)                                       253927
     F                                     RENAME(RESWEPD0:RESWEP8F)                          253927
      *
      ** GL Account by Branch file
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTLXF)
      *
      ** RE Account Number file
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMTBF)
      *
      ** RE Interest & Charges file
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REIACAF:REIACAXF)
     F                                     RENAME(REIACDF:REIACDXF)
     F                                     RENAME(REIACZF:REIACZXF)
      *
      ** GL Account Master file
     FRELINKL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** RE Stopped Cheques
     FSTOPC     IF   E           K DISK    INFSR(*PSSR)
      *
      ** RE Held Intems file - by branch
     FHELDIL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(HELDIHCF)
      ** GL Items for clearing file                                                           237598
     FCLEAR1    IF   E           K DISK    INFSR(*PSSR)                                       237598
      *
      ** RE Standing Orders by debit a/c num
     FSTANDL2   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(STANDSBF:STAND2)
      *
      ** RE Standing Orders by credit a/c num
     FSTANDL3   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(STANDSBF:STAND3)
      *
      ** SD Nostro details by full account number
     FSDNOSTL2  IF   E           K DISK    INFSR(*PSSR)
      *                                                                         216306
      ** RE Group Account Member Extension                                      216306
     FREGAMXL1  IF   E           K DISK    INFSR(*PSSR)                         216306
      *                                                                         216306
      ** RE Zero Bal/Swep Member Extension                                      216306
     FREZSMXL1  IF   E           K DISK    INFSR(*PSSR)                         216306
      *                                                                                      BUG4615
      ** RE Cheque Book File                                                                 BUG4615
     FCHQBKL1   IF   E           K DISK    INFSR(*PSSR)                                      BUG4615
     F                                     PREFIX(C_)                                        BUG4615
     F                                     USROPN                                            248156A
      *                                                                                       226550
      ** LF to allow a chain on prime linked account                                          226550
      *                                                                                       226550
     FRELINKJ2  IF   E           K DISK    INFSR(*PSSR)                                       226550
     FREACCML1  IF   E           K DISK    INFSR(*PSSR)                                    AR1001991
     FSWACB     IF   E           K DISK    INFSR(*PSSR)                                       263834
     F                                     IGNORE(SWACSSAF)                                   263834
     F                                     IGNORE(SWACSSCF)                                   263834
     FGLNWACL5  IF   E           K DISK    INFSR(*PSSR)                                     MD041157
     F                                     PREFIX(G_)                                       MD041157
      **  Midas GL GLNWACPD - By Brch/Custno/ccy/acod/accseq                                MD041157
     FGLNW94L7  IF   E           K DISK    INFSR(*PSSR)                                     MD041157
     F                                     PREFIX(H_)                                       MD041157
      ** Midas GL GLNW94PD - By Brch/Custno/ccy/acod/accseq                                 MD041157

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

      ** Constants for Translating Lower to Upper Case
     D LO              C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')

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
                                                                                             BUG4615
      ** Array of Fields with warnings.                                                      BUG4615
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                    BUG4615
                                                                                             BUG4615
      ** Array of warning message IDs                                                        BUG4615
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                       BUG4615
                                                                                             BUG4615
      ** Array of warning message data.                                                      BUG4615
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                     BUG4615

     D RETA            S              1    DIM(10)
     D NUM             S              1    DIM(10) CTDATA PERRCD(10)

     D @ANAM           S                   LIKE(ANAM)
     D @SNAM           S                   LIKE(DDANAM)

     D                 DS
     D  RETNR                  1     10  0
     D  RETN1                  1      5  0
     D  RETN2                  6     10  0

     D                 DS
     D***ACKEY**               11     18                                                      CGL029
     D  ACKEY                  1     24                                                       CGL029
     D  WWBRCA                 1      3
     D**WWCNUM**               4      9  0                                                    CSD027
     D  WWCNUM                 4      9A                                                      CSD027
     D  WWCCY                 10     12
     D***WWACOD*               13     16  0                                                   CGL029
     D***WWASEQ*               17     18  0                                                   CGL029
     D  WWACOD                13     22  0                                                    CGL029
     D  WWASEQ                23     24  0                                                    CGL029

      ** Switchable Features Details File                                                   MD041157
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD041157
      ** External data structure for access programs (long)                                 MD041157
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD041157
                                                                                            MD041157
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CRE114
      ** External DS for Bank ICD                                                             CRE114
     D                                     PREFIX(Ds)                                         CRE114
      *                                                                                       CRE114
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
                                                                                              CGL029
     D ACCD            S             24                                                       CGL029
     D DDACod          S             10                                                       CGL029
     D WWACDE          S             10                                                       CGL029
      *                                                                                     AR685469
      ** Work variable for ANAM to trim leading spaces                                      AR685469
     D XANAM           S             20                                                     AR685469

     D Mod11Chk        S              1                                                       CGL062
     D P@Rtcd          S              7A                                                      CGL062
     D P@Op01          S             20A                                                      CGL062
     D P@Vl01          S            200A                                                      CGL062
     D P@Op02          S             20A                                                      CGL062
     D P@Vl02          S            200A                                                      CGL062
     D P@Op03          S             20A                                                      CGL062
     D P@Vl03          S            200A                                                      CGL062
     D P@Op04          S             20A                                                      CGL062
     D P@Vl04          S            200A                                                      CGL062
     D P@Op05          S             20A                                                      CGL062
     D P@Vl05          S            200A                                                      CGL062
     D P@Op06          S             20A                                                      CGL062
     D P@Vl06          S            200A                                                      CGL062
     D P@Op07          S             20A                                                      CGL062
     D P@Vl07          S            200A                                                      CGL062
     D P@Op08          S             20A                                                      CGL062
     D P@Vl08          S            200A                                                      CGL062
     D P@Op09          S             20A                                                      CGL062
     D P@Vl09          S            200A                                                      CGL062
     D P@Op10          S             20A                                                      CGL062
     D P@Vl10          S            200A                                                      CGL062
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************

     IRESWEPD0
     I              TRAT                        SWTRAT
     IRESWEP5F                                                                                253927
     I              TRAT                        SWTRAT                                        253927
     IRESWEP6F                                                                                253689
     I              TRAT                        SWTRAT                                        253689
     I*RESWEP2F                                                                        253689 253927
     I*              TRAT                        SWTRAT                                253689 253927
     IRESWEP7F                                                                                253689
     I              TRAT                        SWTRAT                                        253689
     IRESWEP8F                                                                                253927
     I              TRAT                        SWTRAT                                        253927
     I** RENAME CLEAR FIELDS                                                                  237598
     I*                                                                                       237598
     IAPOSTPDF                                                                                237598
     I              TRAT                        CLTRAT                                        237598
     I              ACKEY                       CLACKEY                                       237598
     IFUSIONJF                                                                                226550
     I              BRCA                        JBRCA                                         226550
     I              CNUM                        JCUST                                         226550
     I              CCY                         JTCCY                                         226550
     I              ACOD                        JACOD                                         226550
     I              ACSQ                        JACSQ                                         226550
     I              LTAB                        JTABD                                         226550
     ISWACSSBF                                                                                263834
      ** Rename RECI to prevent overwrite from pf/REIACD, RPG REIACXX                         263834
      *                                                                                       263834
     I              RECI                        RECISW                                        263834
     I              CNUMA                       CNUMSW                                        263834
     I              CCY                         CCYSW                                         263834
     I              ACODQQ                      ACDQSW                                        263834
     I              ACSQ                        ACSQSW                                        263834
     I              CFSB                        CFSBSW                                        263834
     I              LSTD                        LSTDSW                                        263834
     I              NSTD                        NSTDSW                                        263834
     I              ACNO                        ACNOSW                                        263834
     I              STFQ                        STFQSW                                        263834
     I              STDY                        STDYSW                                        263834
     I              LSNO                        LSNOSW                                        263834
     I              UPRI                        UPRISW                                        263834
     I              DDIS                        DDISSW                                        263834
     I              BRCA                        BRCASW                                        263834
     I              IND                         INDSW                                         263834
     I              ZZ006                       ZZ06SW                                        263834
     I              LCD                         LCDSW                                         263834
     I              CHTP                        CHTPSW                                        263834
     I              TNLU                        TNLUSW                                        263834
     I              MT94                        MT94SW                                        263834
     I              ACOD                        ACODSW                                        263834
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

     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blanks       FldNamXAr
     C                   Movel     *Blanks       MsgIDXAr
     C                   Movel     *Blanks       MsgDtaXAr
     C                   Z-add     0             Idx
      *
     C                   Exsr      SrVANam
      *
     C                   Exsr      SrVAcNo
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDANamOK      IfEq      'N'
     C     DDAcNoOK      OrEq      'N'
     C     DDCUSNOK      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVANam - Validate Account Name                               *
      *****************************************************************
     C     SrVANam       BEGSR
      *
     C     DDAnam        IfEq      *Blanks
     C     DDACTN        AndEq     'D'
     C                   Move      'N'           DDAnamOk
     C                   Add       1             Idx
     C                   Movel     'DDANAM'      FldNamXAr(Idx)
     C                   Movel     'RE71043'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** If action code is D check that no Sweep is scheduled.
     C*****DDACTN        IfEq      'D'                                                        253927
     C**********         Move      DDCUSN        WWCNUM                                       253927
     C**********         Move      DDACod        WWACOD                                       253927
     C**********         Move      DDASeq        WWASEQ                                       253927
     C*****KACCNT        Chain     RESWEPL4                           83                      253689
      *                                                                                       253689
      ** Check for Credit Sweep Account                                                       253689
      *                                                                                       253689
     C*****Acno*         Chain     RESWEP6F                           83               253689 253927
     C******In83         IfEq      '0'                                                        253927
     C*****RECI*         AndEq     'D'                                                        253927
     C**********         Move      'N'           DDAnamOk                                     253927
     C**********         Add       1             Idx                                          253927
     C**********         Movel     SWEP          MsgDtaXAr(Idx)                               253927
     C**********         Movel     'DDANAM'      FldNamXAr(Idx)                               253927
     C**********         Movel     'RE72015'     MsgIDXAr(Idx)                                253927
     C**********         EndIf                                                                253927
      *                                                                                       253689
     C*****KACCNT        Chain     RESWEPL4                           83               253689 253927
     C******In83         IfEq      '0'                                                 253689 253927
     C*****RECI*         AndEq     'D'                                                 253689 253927
     C*****ATYP*         AndEq     'R'                                                 253689 253927
     C**********         Move      'N'           DDAnamOk                              253689 253927
     C**********         Add       1             Idx                                   253689 253927
     C**********         Movel     SWEP          MsgDtaXAr(Idx)                        253689 253927
     C**********         Movel     'DDANAM'      FldNamXAr(Idx)                        253689 253927
     C**********         Movel     'RE72015'     MsgIDXAr(Idx)                         253689 253927
     C**********         EndIf                                                         253689 253927
      *                                                                                       253689
      ** Check for Debit Sweep Account                                                        253689
      *                                                                                       253689
     C*****Acno*         Chain     RESWEP2F                           83               253689 253927
     C*****AIn83         IfEq      '0'                                                 253689 253927
     C*****AECI*         AndEq     'D'                                                 253689 253927
     C**********         Move      'N'           DDAnamOk                              253689 253927
     C**********         Add       1             Idx                                   253689 253927
     C**********         Movel     SWEP          MsgDtaXAr(Idx)                        253689 253927
     C**********         Movel     'DDANAM'      FldNamXAr(Idx)                        253689 253927
     C**********         Movel     'RE72015'     MsgIDXAr(Idx)                         253689 253927
     C**********         EndIf                                                         253689 253927
      *                                                                                       253689
     C*****KACCNT        Chain     RESWEP7F                           83               253689 253927
     C******In83         IfEq      '0'                                                 253689 253927
     C*****RECI*         AndEq     'D'                                                 253689 253927
     C*****ATYP*         AndEq     'R'                                                 253689 253927
     C**********         Move      'N'           DDAnamOk                              253689 253927
     C**********         Add       1             Idx                                   253689 253927
     C**********         Movel     SWEP          MsgDtaXAr(Idx)                        253689 253927
     C**********         Movel     'DDANAM'      FldNamXAr(Idx)                        253689 253927
     C**********         Movel     'RE72015'     MsgIDXAr(Idx)                         253689 253927
     C**********         EndIf                                                         253689 253927
     C**********         EndIf                                                         253689 253927
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVAcNo - Validate Account Number                             *
      *****************************************************************
     C     SrVAcNo       BEGSR
      *
     C     DDACTN        IfEq      'I'
     C     DDACTN        OrEq      'D'
      *
      ** Retail no. validation only if retail number used
     C     BMRANR        IfEq      'Y'
      *
     C     DDAcNo        IfNe      *Blanks
      *
     C     WWRetl        IfEq      'N'
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71047'     MsgIDXAr(Idx)
     C                   Else
     C                   MoveA     DDAcNo        RETA
     C                   Z-add     1             Idx1              2 0
     C                   Move      '1'           *In80
      *
     C     Idx1          DowLt     11
     C     *In80         AndEq     *On
     C     RETA(Idx1)    LookUp    NUM                                    80
     C                   Add       1             Idx1
     C                   End
      *
     C     *In80         IfEq      '0'
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71048'     MsgIDXAr(Idx)
     C                   Else
      ** MUST BE GREATER THAN 0 AND LOWER THAN 9999999999
     C                   Z-ADD     99999         RETN1
     C                   Z-ADD     99998         RETN2
     C                   MOVE      DDAcNo        WWRKEY           10 0
      *
     C     WWRKEY        IfLT      1
     C     WWRKEY        OrGT      RETNR
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71046'     MsgIDXAr(Idx)
                                                                                              CGL062
     C                   Else                                                                 CGL062
      ** If Modulus 11 Checking is enabled, perform this validation                           CGL062
                                                                                              CGL062
     C**********         If        Mod11Chk = 'Y'                                      CGL062 242011
     C                   If        (Mod11Chk = 'Y' And DDACTN = 'I')                          242011
     C                   Eval      @ACNO = DDAcno                                             CGL062
     C                   CALLB     'ZAMOD11VAL'                                               CGL062
     C                   PARM      *BLANKS       ReturnCode                                   CGL062
     C                   PARM                    @ACNO            10                          CGL062
     C                   PARM      *BLANKS       @AcNoOk           1                          CGL062
                                                                                              CGL062
     C                   If        ReturnCode <> *BLANKS                                      CGL062
     C                   Eval      DBFile = 'ZAMOD11VAL'                                      CGL062
     C                   Eval      DBKey  = @ACNO                                             CGL062
     C                   Eval      DBase  = 02                                                CGL062
     C                   Exsr      *PSSR                                                      CGL062
     C                   EndIf                                                                CGL062
                                                                                              CGL062
     C                   If        @AcNoOk <> 'Y'                                             CGL062
     C                   Move      'N'           DDAcNoOk                                     CGL062
     C                   Add       1             Idx                                          CGL062
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)                               CGL062
     C                   Movel     'RE62001'     MsgIDXAr(Idx)                                CGL062
     C                   EndIf                                                                CGL062
                                                                                              CGL062
     C                   EndIf                                                                CGL062
     C                   EndIf
                                                                                             BUG4615
      ** Issue a warning if a Cheque book is still connected to the account                  BUG4615
                                                                                             BUG4615
     C                   OPEN      CHQBKL1                                                   248156A
     C     WWRKEY        CHAIN     CHQBKL1                            05                     BUG4615
     C                   IF        *IN05 = *OFF                                              BUG4615
     C                   EVAL      WFldNmXAr(1) = '*ANY   '                                  BUG4615
     C                   EVAL      WMsgIDXAr(1) = 'RE71124'                                  BUG4615
     C                   ENDIF                                                               BUG4615
     C                   CLOSE     CHQBKL1                                                   248156A
      *
     C                   EndIf
     C                   EndIf
      *
     C                   Else
      *
     C     WWRetl        IfEq      'Y'
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71046'     MsgIDXAr(Idx)
     C                   EndIf
      *
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
      *
      ** Insert Mode Only
     C     DDActn        IfEq      'I'
     C     Idx           AndEq     0
      *
      ** Retail number must not exist on retail account file
     C     DDAcno        IfNe      *Blanks
     C                   Move      DDAcno        WWRKEY           10 0
     C     WWRKEY        Chain     ACNUM                              80
     C     *IN80         IFEQ      '0'
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71049'     MsgIDXAr(Idx)
     C                   EndIf
     C                   EndIf
      *
     C     Idx           IfEq      0
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVEL     DDCCy         WWCCY
     C                   MOVE      DDACod        WWACOD
     C                   MOVE      DDASeq        WWASEQ
     C                   MOVE      DDBrca        WWBRCA
      *
     C     KACCNT        CHAIN     ACCNTLXX                           80
      *
     C     *IN80         IFNE      '1'
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Add       1             Idx
     C                   Movel     'DDCUSN'      FldNamXAr(Idx)
     C                   Movel     'RE71020'     MsgIDXAr(Idx)
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
      *
      ** Delete Mode Only
     C     DDActn        IfEq      'D'
     C     Idx           AndEq     0
      *
      ** ACCOUNT NUMBER VALIDATION
      *
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCUSN        WWCNBR
     C                   MOVEL     DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACOD        WWACDE
     C                   MOVE      DDASEQ        WWASEQ
     C                   MOVE      DDBRCA        WWBRCA
      *
     C     KACCNT        CHAIN     ACCNTLXX                           80
      *
     C     *IN80         IFNE      '0'
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Add       1             Idx
     C                   Movel     'DDCUSN'      FldNamXAr(Idx)
     C                   Movel     'RE71044'     MsgIDXAr(Idx)
      *
     C                   Else
      *
      ** IF ACCOUNT FOUND IT CANNOT BE FLAGGED FOR CLOSURE
     C     RECI          IfEq      '*'
     C     DACC          ORNE      0
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Add       1             Idx
     C                   Movel     'DDCUSN'      FldNamXAr(Idx)
     C                   Movel     'RE71045'     MsgIDXAr(Idx)
     C                   EndIf
     C                   EndIf
      *
      ** IF RETAIL ACCOUNT ENTERED MUST BELONG TO SAME ACCOUNT
      *
     C     DDACNO        IFNE      *BLANKS
     C                   MOVE      DDACNO        WWRKEY
     C     WWRKEY        IFNE      ACNO
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71046'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** ACCOUNT NAME ENTERED MUST BE THE SAME AS ON ACCOUNT
      *
      ** Translate Account names to Upper Case
     C     LO:UP         XLATE     ANAM          @ANAM
     C     LO:UP         XLATE     DDANAM        @SNAM
      *                                                                                     AR685469
      ** Trim leading spaces of ANAM                                                        AR685469
      *                                                                                     AR685469
     C                   EVAL      XANAM = %TRIML(@ANAM)                                    AR685469
      *
     C*****@SNAM         IFNE      @ANAM                                                    AR685469
     C     @SNAM         IFNE      XANAM                                                    AR685469
     C                   Move      'N'           DDAnamOk
     C                   Add       1             Idx
     C                   Movel     'DDANAM'      FldNamXAr(Idx)
     C                   Movel     'RE71052'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** ACCOUNT CAN NOT BE CLOSE AT SAME DATE THEN OPENEING LDAC 'Y'
      *
     C     BMLDAI        IFEQ      'Y'
     C     DACO          ANDEQ     BJRDNB
     C                   Move      'N'           DDAnamOk
     C                   Add       1             Idx
     C                   Movel     'DDANAM'      FldNamXAr(Idx)
     C                   Movel     'RE71058'     MsgIDXAr(Idx)
     C                   ENDIF
      *                                                                                     AR648606
      ** Check if TI Account is equal to 'Y'                                                AR648606
      *                                                                                     AR648606
     C     A5TIAC        IFEQ      'Y'                                                      AR648606
     C                   Move      'N'           DDCUSNOk                                   AR648606
     C                   Move      'N'           DDCcyOk                                    AR648606
     C                   Move      'N'           DDACodOk                                   AR648606
     C                   Move      'N'           DDASeqOk                                   AR648606
     C                   Move      'N'           DDAcNoOk                                   AR648606
     C                   Add       1             Idx                                        AR648606
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)                             AR648606
     C                   Movel     'RE72035'     MsgIDXAr(Idx)                              AR648606
     C                   ENDIF                                                              AR648606
      *                                                                         (16306
      *  Account cannot be a part of ZB/Sw  or GA hierarchy                     216306
     C*                                                                         216306
     C     KSTAND        CHAIN     REGAMXL1                           80        216306
     C     *IN80         IfEq      '0'                                          216306
      *                                                                                    AR1001991
      ** Check if member id 'live' in hierachy members                                     AR1001991
      *                                                                                    AR1001991
     C     GMEID         CHAIN     REACCML1                           80                   AR1001991
     C     *IN80         IfEq      '0'                                                     AR1001991
     C                   Move      'N'           DDCUSNOk                       216306
     C                   Move      'N'           DDCcyOk                        216306
     C                   Move      'N'           DDACodOk                       216306
     C                   Move      'N'           DDASeqOk                       216306
     C                   Move      'N'           DDAcNoOk                       216306
     C                   Add       1             Idx                            216306
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)                 216306
     C                   Movel     'RE75964'     MsgIDXAr(Idx)                  216306
     C                   EndIf                                                  216306
     C                   EndIf                                                             AR1001991
     C*                                                                         216306
     C     KSTAND        CHAIN     REZSMXL1                           80        216306
     C     *IN80         IfEq      '0'                                          216306
      *                                                                                    AR1001991
      ** Check if member id 'live' in hierachy members                                     AR1001991
      *                                                                                    AR1001991
     C     ZMMEID        CHAIN     REACCML1                           80                   AR1001991
     C     *IN80         IfEq      '0'                                                     AR1001991
     C                   Move      'N'           DDCUSNOk                       216306
     C                   Move      'N'           DDCcyOk                        216306
     C                   Move      'N'           DDACodOk                       216306
     C                   Move      'N'           DDASeqOk                       216306
     C                   Move      'N'           DDAcNoOk                       216306
     C                   Add       1             Idx                            216306
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)                 216306
     C                   Movel     'RE75965'     MsgIDXAr(Idx)                  216306
     C                   EndIf                                                  216306
     C                   EndIf                                                             AR1001991
      *
      ** ACCOUNT CANNOT BE AN ALTERNATIVE ACCOUNT
     C                   IF        ATYP = 'R'                                               MD042377
     C     KREIAC        CHAIN     REIACDXF                           80
      *
     C                   IF        *IN80 = '0'                                              MD042377
     C     NOALT         IfGT      0
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71053'     MsgIDXAr(Idx)
     C                   EndIf
     C                   ENDIF                                                              MD042377
     C                   ENDIF                                                              MD042377
      *
      ** ACCOUNT CANNOT BE A PRIME ACCOUNT
      *
     C                   MOVE      DDBRCA        WWSPTA
     C*****KRELNK        CHAIN     RELINKL1                           80                      226550
      *                                                                                       226550
      **  Chain to primary linked account                                                     226550
      *                                                                                       226550
     C     KRELNK        CHAIN     RELINKJ2                           80                      226550
     C******IN80         IfEq      '0'                                                        226550
     C     *IN80         DOWEQ     '0'                                                        226550
      *                                                                                       226550
      ** Move details for secondary account into key to allow CHAIN                           226550
      ** on ACCNTAB to see if secondary account has been closed.                              226550
      *                                                                                       226550
     C                   MOVEL     JBRCA         W@BRCA            3                          226550
     C                   MOVEL     JCUST         W@CNUM            6                          226550
     C                   MOVEL     JTCCY         W@CCY             3                          226550
     C                   MOVEL     JACOD         W@ACOD           10                          226550
     C                   MOVEL     JACSQ         W@ACSQ            2                          226550
      *                                                                                       226550
      ** Check status of secondary account using AOACSTV0.                                    226550
      *                                                                                       226550
     C                   CALL      'AOACSTV0'                                                 226550
     C                   PARM      '*DBERR  '    @RTCD             7                          226550
     C                   PARM      '*KEY    '    @OPTN             7                          226550
     C                   PARM                    @RETL            10                          226550
     C                   PARM                    W@CNUM                                       226550
     C                   PARM                    W@CCY                                        226550
     C                   PARM                    W@ACOD                                       226550
     C                   PARM                    W@ACSQ                                       226550
     C                   PARM                    W@BRCA                                       226550
     C                   PARM      *BLANKS       @ACST             1                          226550
      *                                                                                       226550
      **  If account is found, and isn't closed then output error                             226550
      *                                                                                       226550
     C     @ACST         IFEQ      'O'                                                        226550
     C     @ACST         OREQ      'F'                                                        226550
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71054'     MsgIDXAr(Idx)
     C                   MOVE      '1'           *IN80                                        226550
      *                                                                                       226550
      **  ELSE see if there is another account linked to the                                  226550
      **  primary. If there is, see if this account is closed or not                          226550
      *                                                                                       226550
     C                   ELSE                                                                 226550
     C     KRELNK        READE     RELINKJ2                               80                  226550
     C                   ENDIF                                                                226550
      *                                                                                       226550
     C                   ENDDO                                                                226550
      *                                                                                       226550
     C**********         EndIf                                                                226550
      *                                                                                       226550
      ** Check if account is linked to a prime account                                        226550
      *                                                                                       226550
     C     KRELNK        CHAIN     RELINKL1                           80                      226550
     C     *IN80         IFEQ      '0'                                                        226550
     C                   Move      'N'           DDCUSNOk                                     226550
     C                   Move      'N'           DDCcyOk                                      226550
     C                   Move      'N'           DDACodOk                                     226550
     C                   Move      'N'           DDASeqOk                                     226550
     C                   Move      'N'           DDAcNoOk                                     226550
     C                   Add       1             Idx                                          226550
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)                               226550
     C                   Movel     'RE71073'     MsgIDXAr(Idx)                                226550
     C                   ENDIF                                                                226550
      *
      **  CHECK FOR STOPPED CHEQUES - ERROR IF OUTSTANDING
      **  *IN90 SETON IF RECORD FOUND FOR THIS KEY
      *
     C                   Move      False         *IN90
     C     KACCNT        SETLL     STOPC                                  90
     C     *IN90         IfEq      True
     C                   Move      False         *IN90
     C     *IN90         DOWNE     True
     C     KACCNT        READE     STOPC                                  90
     C     *IN90         IFEQ      False
     C     RECI          ANDNE     '*'
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71055'     MsgIDXAr(Idx)
      *                                                                                     AR939238
      ** Only send message once. Exit DO loop                                               AR939238
      *                                                                                     AR939238
     C                   Eval      *IN90=True                                               AR939238
     C                   EndIf
     C                   EndDo
     C                   EndIf
      *
      **  CHECK FOR HELD ITEMS - ERROR IF OUTSTANDING
      **  *IN90 SETON IF RECORD FOUND FOR THIS KEY
      *
     C                   Move      False         *IN90
     C     KACCNT        SETLL     HELDIL1                                90
     C     *IN90         IfEq      True
     C                   Move      False         *IN90
     C     *IN90         DOWNE     True
     C     KACCNT        READE     HELDIL1                                90
     C     *IN90         IFEQ      False
     C     RECI          ANDNE     '*'
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71056'     MsgIDXAr(Idx)
      *                                                                                     AR939238
      ** Only send message once. Exit DO loop                                               AR939238
      *                                                                                     AR939238
     C                   Eval      *IN90=True                                               AR939238
     C                   EndIf
     C                   EndDo
     C                   EndIf
      *                                                                                       237598
     C                   Move      False         *IN90                                        237598
     C     KACCNT        SETLL     CLEAR1                                 90                  237598
     C     *IN90         IfEq      True                                                       237598
     C                   Move      False         *IN90                                        237598
     C     *IN90         DOWNE     True                                                       237598
     C                   EVAL      VALD = 0                                                 AR401983
     C                   EVAL      VUDT = 0                                                 AR401983
     C     KACCNT        READE     CLEAR1                                 90                  237598
     C     *IN90         IFEQ      False                                                      237598
     C     RECI          ANDNE     '*'                                                        237598
     C     VALD          IFGT      BJRDNB                                                   AR401983
     C     VUDT          ORGT      BJRDNB                                                   AR401983
     C                   Move      'N'           DDCUSNOk                                     237598
     C                   Move      'N'           DDCcyOk                                      237598
     C                   Move      'N'           DDACodOk                                     237598
     C                   Move      'N'           DDASeqOk                                     237598
     C                   Move      'N'           DDAcNoOk                                     237598
     C                   Add       1             Idx                                          237598
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)                               237598
     C                   Movel     'RE71072'     MsgIDXAr(Idx)                                237598
     C                   LEAVE                                                                250349
     C                   ENDIF                                                              AR401983
     C                   EndIf                                                                237598
     C                   EndDo                                                                237598
     C                   EndIf                                                                237598
      *
      ** ACCOUNT CANNOT HAVE ANY ENTRIES ON THE STANDING ORDERS FILE
      *
     C     KSTAND        CHAIN     STAND2                             80
     C     *IN80         IfEq      '0'
     C     RECI          ANDNE     '*'                                                      BUG12768
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71059'     MsgIDXAr(Idx)
     C                   EndIf
      *
     C     KSTAND        CHAIN     STAND3                             80
     C     *IN80         IFEQ      '0'
     C     RECI          ANDNE     '*'                                                        224897
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71059'     MsgIDXAr(Idx)
     C                   EndIf
      *                                                                                       253927
     C     ACNO          CHAIN     RESWEP6F                           80                      253927
     C     *IN80         IFEQ      '1'                                                        253927
     C     KACCNT2       CHAIN     RESWEP5F                           80                      253927
     C     *IN80         IFEQ      '1'                                                        253927
     C     ACNO          CHAIN     RESWEP8F                           80                      253927
     C     *IN80         IFEQ      '1'                                                        253927
     C     KACCNT        CHAIN     RESWEP7F                           80                      253927
     C                   ENDIF                                                                253927
     C                   ENDIF                                                                253927
     C                   ENDIF                                                                253927
      *                                                                                       253927
     C     *IN80         IFEQ      '0'                                                        253927
     C     RECI          ANDEQ     'D'                                                        253927
     C     ATYP          ANDEQ     'R'                                                        253927
     C                   Move      'N'           DDCUSNOk                                     253927
     C                   Move      'N'           DDCcyOk                                      253927
     C                   Move      'N'           DDACodOk                                     253927
     C                   Move      'N'           DDASeqOk                                     253927
     C                   Move      'N'           DDAcNoOk                                     253927
     C                   Add       1             Idx                                          253927
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)                               253927
     C                   Movel     'RE72035'     MsgIDXAr(Idx)                                253927
     C                   EndIf                                                                253927
      *                                                                                       253927
      *
      ** Account should not have an attached nostro
      *
     C     KNOST         CHAIN     @NOSTBH                            80
     C     *IN80         IFEQ      '0'
     C                   Move      'N'           DDCUSNOk
     C                   Move      'N'           DDCcyOk
     C                   Move      'N'           DDACodOk
     C                   Move      'N'           DDASeqOk
     C                   Move      'N'           DDAcNoOk
     C                   Add       1             Idx
     C                   Movel     'DDAcNo'      FldNamXAr(Idx)
     C                   Movel     'RE71070'     MsgIDXAr(Idx)
     C                   MOVEL     A7CYCD        NOSD              5
     C                   MOVE      A7NONB        NOSD
     C**********         MOVEL     NOSD          MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(NOSD))                                 MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(NOSD)                     MD000091
     C                   EndIf
      *                                                                                     MD041157
      ** If CGL013 is on, account should not have an attached GLNW record.                  MD041157
      *                                                                                     MD041157
     C     CGL013        IFEQ      'Y'                                                      MD041157
     C     SWAKEY        CHAIN     GLNWACL5                           80                    MD041157
     C     *IN80         IFEQ      '0'                                                      MD041157
     C     G_NARECI      ANDNE     '*'                                                      MD041157
     C                   MOVE      'N'           DDCUSNOk                                   MD041157
     C                   MOVE      'N'           DDCcyOk                                    MD041157
     C                   MOVE      'N'           DDACodOk                                   MD041157
     C                   MOVE      'N'           DDASeqOk                                   MD041157
     C                   MOVE      'N'           DDAcNoOk                                   MD041157
     C                   ADD       1             Idx                                        MD041157
     C                   MOVEL     'DDANAM'      FldNamXAr(Idx)                             MD041157
     C                   MOVEL     '5045554'     MsgIDXAr(Idx)                              MD041157
     C                   ELSE                                                               MD041157
     C     SWAKEY        CHAIN     GLNW94L7                           80                    MD041157
     C     *IN80         IFEQ      '0'                                                      MD041157
     C     H_N4RECI      ANDNE     '*'                                                      MD041157
     C                   MOVE      'N'           DDCUSNOk                                   MD041157
     C                   MOVE      'N'           DDCcyOk                                    MD041157
     C                   MOVE      'N'           DDACodOk                                   MD041157
     C                   MOVE      'N'           DDASeqOk                                   MD041157
     C                   MOVE      'N'           DDAcNoOk                                   MD041157
     C                   ADD       1             Idx                                        MD041157
     C                   MOVEL     'DDANAM'      FldNamXAr(Idx)                             MD041157
     C                   MOVEL     '5045554'     MsgIDXAr(Idx)                              MD041157
     C                   ENDIF                                                              MD041157
     C                   ENDIF                                                              MD041157
     C                   ELSE                                                               MD041157
      *                                                                                       263834
      ** Account should not have an attached SWACSSB record.                                  263834
      *                                                                                       263834
     C     SWAKEY        CHAIN     SWACSSBF                           80                      263834
     C     *IN80         IFEQ      '0'                                                        263834
     C     RECISW        ANDNE     '*'                                                        263834
     C                   MOVE      'N'           DDCUSNOk                                     263834
     C                   MOVE      'N'           DDCcyOk                                      263834
     C                   MOVE      'N'           DDACodOk                                     263834
     C                   MOVE      'N'           DDASeqOk                                     263834
     C                   MOVE      'N'           DDAcNoOk                                     263834
     C                   ADD       1             Idx                                          263834
     C                   MOVEL     'DDANAM'      FldNamXAr(Idx)                               263834
     C                   MOVEL     '5045554'     MsgIDXAr(Idx)                                263834
     C                   ENDIF                                                                263834
     C                   ENDIF                                                              MD041157
      *
      ** IF NO ERROR SET CONFIRMATION INDICATOR ON
      *
     C     Idx           IfEq      0
     C                   MOVE      '1'           *IN42
     C                   EndIf
      *
      ** If User Defined Correspondence installed and the account is a
      ** non=title account and the action code is delete call CGC0025.
      *
     C     BGN1ST        IfEq      'Y'
     C     A5TOIN        AndNE     'Y'
      *
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      'D'           ACTN              1
     C**********         PARM      ACKEY         ACCD             18                          CGL029
     C                   PARM      ACKEY         ACCD                                         CGL029
      *
      ** If cannot delete
      *
     C     @RTCD         IfEq      'CGD1184'
     C                   Add       1             Idx
     C                   Movel     *Blanks       FldNamXAr(Idx)
     C                   Movel     'RE70000'     MsgIDXAr(Idx)
     C                   SETOFF                                       42
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
      *                                                                                       CRE114
      ** If CRE114 is on and Action Code is 'I' and Retail Numbers are used                   CRE114
      ** and Apply Modulus-10 Check is on in the Bank's ICD and the Retail                    CRE114
      ** Account Number isn't blank, call to GLVGMD10 to compute and verify                   CRE114
      ** the check digit (10th position) of this later field                                  CRE114
      *                                                                                       CRE114
     C                   If        CRE114 = 'Y'                                               CRE114
     C                             And DDACTN = 'I'                                           CRE114
     C                             And BMRANR = 'Y'                                           CRE114
     C                             And WWRetl = 'Y'                                           CRE114
     C                             And DsBJMODT = 'Y'                                         CRE114
     C                             And DDAcNo <> *Blanks                                      CRE114
      *                                                                                       CRE114
     C                   CallB (E) 'GLVGMD10'                                                 CRE114
     C                   Parm                    RetCodeIn                                    CRE114
     C                   Parm      DDAcNo        P@Fld10          10                          CRE114
      *                                                                                       CRE114
     C                   Select                                                               CRE114
     C                   When      %Error                                                     CRE114
     C                   Move      'N'           DDAcNoOk                                     CRE114
     C                   Add       1             Idx                                          CRE114
     C                   Movel     'DDACNO'      FldNamXAr(Idx)                               CRE114
     C                   Movel     'Y2U0032'     MsgIDXAr(Idx)                                CRE114
     C                   Movel     'GLVGMD10'    MsgDtaXAr(Idx)                               CRE114
      *                                                                                       CRE114
     C                   When      RetCodeIn = 'REL0022'                                      CRE114
     C                   Move      'N'           DDAcNoOk                                     CRE114
     C                   Add       1             Idx                                          CRE114
     C                   Movel     'DDACNO'      FldNamXAr(Idx)                               CRE114
      ** Invalid entry – Retail account number does not pass Modulus 10 check                 CRE114
     C                   Movel     'REL0022'     MsgIDXAr(Idx)                                CRE114
     C                   EndSl                                                                CRE114
      *                                                                                       CRE114
     C                   EndIf                                                                CRE114
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        Plist
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDActn            1
     C                   Parm                    DDBrca            3
     C                   Parm                    DDCUSN            6
     C                   Parm                    DDCcy             3
     C**********         Parm                    DDACod            4                          CGL029
     C                   Parm                    DDACod                                       CGL029
     C                   Parm                    DDASeq            2
     C                   Parm                    DDAcNo           10
     C                   Parm                    DDANam           20
      *
      ** Output of Sr/VACSQ
     C                   Parm                    WWRetl            1
      *
      ** ICD
     C                   Parm                    BMRANR            1
     C                   Parm                    BMLDAI            1
     C                   Parm                    BGN1ST            1
     C                   Parm                    BJRDNB            5 0
      *
      ** Access from SDACODPD from pgm/GLVACSQ
     C                   Parm                    A5TOIN            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Account Name - Ok
      ** Retail Account - Ok
      ** Customer - OK
      ** Currency - OK
      ** Account code - OK
      ** Account Seq - OK
     C                   Parm                    DDANamOK          1
     C                   Parm                    DDAcNoOK          1
     C                   Parm                    DDCUSNOK          1
     C                   Parm                    DDCcyOK           1
     C                   Parm                    DDACodOK          1
     C                   Parm                    DDASeqOK          1
                                                                                             BUG4615
      * Warning message IDs/message data (arrays) from/to caller                             BUG4615
                                                                                             BUG4615
     C                   Parm                    WFldNmXAr                                   BUG4615
     C                   Parm                    WMsgIDXAr                                   BUG4615
     C                   Parm                    WMsgDtXAr                                   BUG4615
      *
      **  Define key list to access ACCNTLXX, STOPC, HELDIL1 & RESWEPL4
     C     KACCNT        KLIST
     C                   KFLD                    WWBRCA
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWCCY
     C                   KFLD                    WWACOD
     C                   KFLD                    WWASEQ
      *                                                                                       253927
     C     KACCNT2       KLIST                                                                253927
     C                   KFLD                    WWCNUM                                       253927
     C                   KFLD                    WWCCY                                        253927
     C                   KFLD                    WWACOD                                       253927
     C                   KFLD                    WWASEQ                                       253927
     C                   KFLD                    WWBRCA                                       253927
      *
      **  Define key list to access REIACXX
     C     KREIAC        KLIST
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWCCY
     C                   KFLD                    WWACOD
     C                   KFLD                    WWASEQ
     C                   KFLD                    WWBRCA
      *
      **  Define key list to access RELINKL1
     C     KRELNK        KLIST
     C                   KFLD                    WWSPTA            3
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWCCY
     C                   KFLD                    WWACOD
     C                   KFLD                    WWASEQ
      *
      **  Define key list to access STANDL2 and STANDL3
     C     KSTAND        KLIST
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWCCY
     C                   KFLD                    WWACOD
     C                   KFLD                    WWASEQ
     C                   KFLD                    WWBRCA
      *
      **  Define key list to access SDNOSTL2
     C     KNOST         KLIST
     C                   KFLD                    WWCNBR            6
     C                   KFLD                    WWCCY
     C**********         KFLD                    WWACDE            4                          CGL029
     C                   KFLD                    WWACDE                                       CGL029
     C                   KFLD                    WWASEQ
     C                   KFLD                    WWBRCA
      *                                                                                       263834
     C     SWAKEY        KLIST                                                                263834
     C                   KFLD                    WWBRCA                                       263834
     C                   KFLD                    WWCNBR                                       263834
     C                   KFLD                    WWCCY                                        263834
     C                   KFLD                    WWACOD                                       263834
     C                   KFLD                    WWASEQ                                       263834
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C** Obtain System Value Modulus11lChk                                                    CGL062
     C                   Eval      P@Op01 = 'Modulus11Chk'                                    CGL062
                                                                                              CGL062
     C                   Call      'AOSVALR0'                                                 CGL062
     C                   Parm      *Blanks       P@Rtcd                                       CGL062
     C                   Parm                    P@Op01                                       CGL062
     C                   Parm      *Blanks       P@Vl01                                       CGL062
     C                   Parm      *Blanks       P@Op02                                       CGL062
     C                   Parm      *Blanks       P@Vl02                                       CGL062
     C                   Parm      *Blanks       P@Op03                                       CGL062
     C                   Parm      *Blanks       P@Vl03                                       CGL062
     C                   Parm      *Blanks       P@Op04                                       CGL062
     C                   Parm      *Blanks       P@Vl04                                       CGL062
     C                   Parm      *Blanks       P@Op05                                       CGL062
     C                   Parm      *Blanks       P@Vl05                                       CGL062
     C                   Parm      *Blanks       P@Op06                                       CGL062
     C                   Parm      *Blanks       P@Vl06                                       CGL062
     C                   Parm      *Blanks       P@Op07                                       CGL062
     C                   Parm      *Blanks       P@Vl07                                       CGL062
     C                   Parm      *Blanks       P@Op08                                       CGL062
     C                   Parm      *Blanks       P@Vl08                                       CGL062
     C                   Parm      *Blanks       P@Op09                                       CGL062
     C                   Parm      *Blanks       P@Vl09                                       CGL062
     C                   Parm      *Blanks       P@Op10                                       CGL062
     C                   Parm      *Blanks       P@Vl10                                       CGL062
                                                                                              CGL062
      **  If the Return Code is blank, set Modulus 11 Check Flag                              CGL062
     C                   If        P@Rtcd = *Blanks                                           CGL062
     C                   Eval      Mod11Chk = P@Vl01                                          CGL062
     C                   EndIf                                                                CGL062
                                                                                              CGL062
      *                                                                                     MD041157
      ** Check if CGL013 is switched on.                                                    MD041157
      *                                                                                     MD041157
     C                   MOVE      'N'           CGL013            1                        MD041157
     C                   CALLB     'AOSARDR0'                                               MD041157
     C                   PARM      *BLANKS       @RTCD                                      MD041157
     C                   PARM      '*VERIFY'     @OPTN                                      MD041157
     C                   PARM      'CGL013'      @SARD                                      MD041157
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD041157
      *                                                                                     MD041157
     C     @RTCD         IFEQ      *BLANKS                                                  MD041157
     C                   MOVE      'Y'           CGL013                                     MD041157
     C                   ENDIF                                                              MD041157
      *                                                                                       CRE114
      ** Check if CRE114 is switched on.                                                      CRE114
      *                                                                                       CRE114
     C                   MOVE      'N'           CRE114            1                          CRE114
     C                   CALLB     'AOSARDR0'                                                 CRE114
     C                   PARM      *BLANKS       @RTCD                                        CRE114
     C                   PARM      '*VERIFY'     @OPTN                                        CRE114
     C                   PARM      'CRE114'      @SARD                                        CRE114
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE114
      *                                                                                       CRE114
     C     @RTCD         IFEQ      *BLANKS                                                    CRE114
     C                   MOVE      'Y'           CRE114                                       CRE114
     C                   ENDIF                                                                CRE114
      *                                                                                       CRE114
      ** Access Bank details via access program                                               CRE114
      ** (database error handling done in access program)                                     CRE114
      *                                                                                       CRE114
     C                   If        CRE114 = 'Y'                                               CRE114
     C                   CallB     'AOBANKR0'                                                 CRE114
     C                   Parm      '*DBERR'      @RTCD                                        CRE114
     C                   Parm      '*FIRST'      @OPTN                                        CRE114
     C     SDBANK        Parm                    DSFDY                                        CRE114
     C                   EndIf                                                                CRE114
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** NUM
0123456789