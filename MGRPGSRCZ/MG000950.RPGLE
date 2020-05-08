     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
     H FTRANS
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG MT950 Message Generation')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG000950 - Midas MG MT950 Message Generation                 *
      *                                                               *
      *  Function:  This program formats the MT950 message and        *
      *             outputs it to MGOREFPD and MGOMSGPD.              *
      *                                                               *
      *  Called By: GLC001431                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. EML107             Date 08May20               *
      *  Prev Amend No. EML104             Date 06Feb20               *
      *                 CMG006             Date 15Oct19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042357           Date 02Dec16               *
      *                 MD042041           Date 21Oct16               *
      *                 MD024641           Date 10Feb14               *
      *                 CGL146A            Date 10Jul13               *
      *                 CGL146             Date 10Jul13               *
      *                 AR972805           Date 27Feb13               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25800A          Date 16Sep09               *
      *                 BUG25799           Date 03Sep09               *
      *                 BUG25800           Date 01Sep09               *
      *                 BUG23740           Date 19Apr09               *
      *                 BUG23557           Date 30Mar09               *
      *                 BUG23209           Date 06Mar09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 27Oct03               *
      *                 CGL013  *Create    Date 14May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML107 - Output IBAN in Sender Account Number field          *
      *           Use core hook MGH00094 and added EML107_001         *
      *  EML104 - Upgrade EML010 to FB Midas 2.1 SP21                 *
      *           Structured field :86:                               *
      *           Used hook MGH00092, MGH00094                        *
      *           Added hook EML104_014                               *
      *  CMG006 - Account identification of MT940 and MT942.          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042357 - Do not write IBAN to SWIFT Account on MGOREFPD    *
      *  MD042041 - Tag 61 is not sorted by DRCR and PSTA. Added a    *
      *             system value that when is set to 'Y', program     *
      *             use another logical file that is also sorted by   *
      *             DRCR and PSTA.                                    *
      *  MD024641 - The field :65: Forward Available Balance is not   *
      *             correct if the statement date is in the past      *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *            Added hooks: CGL146_087, CGL146_089, CGL146_091    *
      *                         CGL146_094, CGL146_095, CGL146_096    *
      *                         CGL146_097, CGL146_128, CGL146_129    *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_063, CGL146_064     *
      *  AR972805 - Remove equate translation as done externally.     *
      *             Recompile over FTCPYSRC,FTSWIFTRAN.               *
      *             (Child: AR972806)                                 *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,MGH00048                                 *
      *             WNCPYSRC,MGH00049                                 *
      *             WNCPYSRC,MGH00050                                 *
      *             WNCPYSRC,MGH00051                                 *
      *             WNCPYSRC,MGH00052                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25800A - revert fix applied                               *
      *  BUG25799 - Field 25 of MT950 is blank                        *
      *  BUG25800 - Missing subfield 4 - field 61 of MT940            *
      *             at regression test                                *
      *  BUG23740 - Account Number for SWIFT messages is always in    *
      *             IBAN format                                       *
      *  BUG23557 - GLC001430 00001 is failing                        *
      *  BUG23209 - Extend the size of MULT from 2000 to 9000         *
      *  CER030 - Multicash German Feature                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                              *
      *  01        -   EOF MGF950L0                                   *
      *  02        -   Chain failed in SDNWRKL1                       *
      *  03        -   Chain failed in GLNWACL0                       *
      *  15        -   Error on call to ZM0040, ZM0060                *
      *  41        -   Error on write to MGOREFPD                     *
      *  42        -   Error on write to MGOMSGPD                     *
      *  62        -   EOF MGX950L0                                   *
      *  U7 U8 LR                                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRProc        - Detail processing                            *
      *  Format_MT950  - Format MT950 Message                         *
      *  Format_20     - Format Field 20 Transaction Number           *
      *  Format_25     - Format Field 25, Account Identification      *
      *  Format_28     - Format Field 28C Entry and Page Number       *
      *  Format_60     - Format Field 60  Opening Balance             *
      *  Format_61     - Format Repeating field  61                   *
      *  Format_62     - Format Field 62a Closing Balance             *
      *  Format_64     - Format Field 64  Closing Available Balance   *
      *  Format_F62    - Format Final Field 62                        *
      *  SROref        - Output Record to MGOREFPD                    *
      *  SROMsg        - Output to PF/MGOMSGPD                        *
      *  SRAccLen      - Accumulate Message Length                    *
      *  SRDetFldLen   - Determine Field Length                       *
      *  SR_Clear1     - Clear work fields after each MGF950PD read   *
      *  SR_Clear2     - Clear work fields bef procg continuation page*
      *  Get_NwrkDet   - Get Network Details                          *
      *  Get_NwrkAcDet -  Get Network Account Details                 *
      *  Call_ZM0040   - Convert amount o SWIFT format                *
      *  Call_ZM0060   - Convert date to YYMMDD format                *
      *  *INZSR        - Program Initialisation routine               *
      *  *PSSR         - Program exception error routine              *
      *  *SREND        - Subroutine to End Program                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FMGF950L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMGX950L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(X_)
     FMGX950L1  UF   E           K DISK    INFSR(*PSSR)                                     MD042041
     F                                     COMMIT                                           MD042041
     F                                     PREFIX(X_)                                       MD042041
     F                                     RENAME(MGX950D0:MGX950D1)                        MD042041
     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR)
     FGLNWACL0  IF   E           K DISK    INFSR(*PSSR)
     FMGOREFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
     F                                     RENAME(MGOREFD0:MGOREFL)
     F/COPY WNCPYSRC,MGH00092
     FMGOREFPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMGOMSGPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMG000950AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      /COPY OFCPYSRCZ,CGL146_128                                                             CGL146A
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D AMFLD           S              1    DIM(50)
     D AL100           S              1    DIM(100)

      ** File Information Data Structure for MG000950AU
     D SPOOLU          DS
     D   WFileU               83     92
     D   WFNumU              123    124B 0

     D*MULT*****       DS                  OCCURS(2000)                                     BUG23209
     D MULT            DS                  OCCURS(9000)                                     BUG23209
     D  MTAG                   1      5
     D  MFLD                   6     55
     D  CTRC                  56     57
      * Multiple ocurrence data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Externally described DS for currency details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Externally described DS for branch details

     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      ** Externally described DS for message management details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** Externally described DS for customer details

      ** Externam DS SC Switchable Features

      ** External DS for SAR Details                                                        BUG25800
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG25800
                                                                                            BUG25800
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access objects - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long data structure

     D                 DS
     D   WCrlf                 1      2
     D   WWCr                  1      1
     D   WWLf                  2      2
      /COPY OFCPYSRCZ,CGL146_087                                                             CGL146A

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


     D P@SARD          S              6A                                        Feature       CMG006
     D ACFMTPGM        S             10A                                                      CMG006
     D FldDstn         S             20    INZ('MT94xFld25Dstn')                              CMG006
     D Kdstn1          S             10A                                                      CMG006

      ** Work variables

     D PCusN           S              6
     D*PAcctCde*       S              4                                                       CGL029
     D PAcctCde        S             10A                                                      CGL029
     D PAcctSeq        S              2
     D*WMsgCount       S              5  0                                                  BUG23209
     D WMsgCount       S              7  0                                                  BUG23209
     D WRundNum        S              6  0
     D WRundChr        S              6
     D WAccount        S             34
     D WPrvCBAL        S             15  0
     D WPrvCDate       S              5  0
     D*WLength1*       S              6  0                                                  BUG23557
     D*WLength2*       S              6  0                                                  BUG23557
     D WLength1        S              7  0                                                  BUG23557
     D WLength2        S              7  0                                                  BUG23557
     D WString100      S            100
     D WFldLen         S              3  0
     D WFld61Len       S              3  0
     D W62Loc          S              4  0
     D WTRNO           S             16
     D WHrdt           S              6
     D WRun            S              1
     D X               S              6  0
     D Q               S              6  0
     D NewPage         S              1
     D PageClBal       S             15  0
     D PageClDate      S              5  0
     D Subfld1         S              6
     D Subfld2         S              4
     D Subfld3         S              2
     D Subfld4         S              1
     D Subfld5         S             15
     D Subfld6         S              4
     D Subfld7         S             16
     D Subfld8         S             18
     D Subfld9         S             34
     D SavTrno         S             16
     D CER030          S              1A                                                    BUG25800
     D PSard           S              6A                                                    BUG25800
     D
     D                 DS
     D  KNwrk                  1      6
     D  KBrca                  7      9
     D**KCnum***              10     15  0                                                    CSD027
     D  KCnum                 10     15                                                       CSD027
     D  KCcy                  16     18
     D***KAccd**               19     22  0                                                   CGL029
     D***KAcsq**               23     24  0                                                   CGL029
     D***KNaty**               25     25                                                      CGL029
     D***KNetAc*                1     25                                                      CGL029
     D  KAccd                 19     28  0                                                    CGL029
     D  KAcsq                 29     30  0                                                    CGL029
     D  KNaty                 31     31                                                       CGL029
     D  KNetAc                 1     31                                                       CGL029

     D                 DS
     D   WSeqNum               1      6  0
     D   WSeqChr               1      6
     D                 DS
     D   WPageNum              1      5  0
     D   WPageChr              1      5
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146
      /COPY OFCPYSRCZ,CGL146_129                                                             CGL146A
     D SValK1          C                   CONST('MT94xAddedSortfor61')                     MD042041
     D WSort61         S              1A                                                    MD042041
     D SysValK1        S             20A                                                    MD042041
     D SysValK2        S             20A                                                    MD042041
     D SysValK3        S             20A                                                    MD042041
     D SysValK4        S             20A                                                    MD042041
     D SysValK5        S             20A                                                    MD042041
     D SysValK6        S             20A                                                    MD042041
     D SysValK7        S             20A                                                    MD042041
     D SysValK8        S             20A                                                    MD042041
     D SysValK9        S             20A                                                    MD042041
     D SysValK10       S             20A                                                    MD042041
     D SysVal1         S            200A                                                    MD042041
     D SysVal2         S            200A                                                    MD042041
     D SysVal3         S            200A                                                    MD042041
     D SysVal4         S            200A                                                    MD042041
     D SysVal5         S            200A                                                    MD042041
     D SysVal6         S            200A                                                    MD042041
     D SysVal7         S            200A                                                    MD042041
     D SysVal8         S            200A                                                    MD042041
     D SysVal9         S            200A                                                    MD042041
     D SysVal10        S            200A                                                    MD042041

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

      ** End the program

     C                   EXSR      SREnd

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Detail processing                                   *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR

     C                   EVAL      *IN01 = *OFF

     C     *LOVAL        SETLL     MGF950L0                               01
     C                   READ      MGF950L0                               01

     C                   DOW       *IN01 = *OFF
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_089                                                             CGL146A

      ** Clear Work fields
     C                   EXSR      SR_Clear1

      ** Get network details
     C                   EXSR      Get_NwrkDet

      ** Get network account details
     C                   EXSR      Get_NwrkAcDet

     C                   DoU       NewPage  = *Blank

      ** Clear Work fields
     C                   EXSR      SR_Clear2

      ** Format message
     C                   EXSR      Format_MT950

      ** ... output to PF/MGOREFPD

     C                   EXSR      SRORef

      ** ... output to PF/MGOMSGPD

     C                   EXSR      SROMsg

      ** Accumulate number of MT950s generated
     C                   Add       1             Count950

     C                   Enddo

      ** Delete MGF950PD record
     C                   Delete    MGF950L0
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_096                                                             CGL146A

      ** Comit all changes

     C                   COMMIT

     C                   READ      MGF950L0                               01

     C                   Enddo

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Clear1 - Clear work fields after each MGF950PD read       *
      *                                                               *
      *****************************************************************
     C     SR_Clear1     BEGSR

      *  Clear Multiple Data structure
     C                   Eval      X = 1
     C                   Dow       X <= Q
     C     X             Occur     MULT
     C                   Eval      MTAG = *Blanks
     C                   Eval      MFLD = *Blanks
     C                   Eval      X = X + 1
     C                   Enddo

     C                   Eval      WAccount = *blank
     C                   Eval      WPageNum = *zero
     C                   Eval      NewPage  = *blank

      *  Reset Message length count to reflect allocated length for
      *  header and trailer.
     C                   Eval      WMsgCount = 100

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Clear2 - Clear work fields before processing continuation *
      *              page                                             *
      *                                                               *
      *****************************************************************
     C     SR_Clear2     BEGSR

      *  Clear Multiple Data structure
     C                   Eval      X = 1
     C                   Dow       X <= Q
     C     X             Occur     MULT
     C                   Eval      MTAG = *Blanks
     C                   Eval      MFLD = *Blanks
     C                   Eval      X = X + 1
     C                   Enddo

     C                   Eval      WPageNum = WPageNum + 1
     C                   Eval      NewPage  = *blank

      *  Reset Message length count to reflect allocated length for
      *  header and trailer.
     C                   Eval      WMsgCount = 100

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccLen    - Accumulate Message Length                      *
      *                                                               *
      *****************************************************************
     C     SRAccLen      BEGSR
      *
      *  Add 5 for message tag and CRLF
     C                   Eval      WMsgCount = WMsgCount + 5
     C                   Eval      WMsgCount = WMsgCount + 2

      *  Determine fld length
     C                   MoveA     MFLD          AMFLD
     C                   Eval      X = 50

     C                   Dow       X > 0  AND
     C                             AMFLD(X) = *blank
     C                   Eval      X = X - 1
     C                   Enddo

      *  Add field length to message length
     C                   Add       X             WMsgCount

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetFldLen  - Determine Field Length                        *
      *                                                               *
      *****************************************************************
     C     SRDetFldLen   BEGSR

      *  Determine fld length
     C                   Eval      X = 100

     C                   Dow       X > 0 AND
     C                             AL100(X) = *blank
     C                   Eval      X = X - 1
     C                   Enddo

     C                   Z-add     X             WFldLen

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Get_NwrkDet - Get Network Details                            *
      *                                                               *
      *****************************************************************
     C     Get_NwrkDet   BEGSR

      *  Access Network Details to retrieve message settings
     C     MGNWRK        Chain     SDNWRKL1                           02

     C                   If        *IN02 = *ON
     C     *Lock         In        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'SDNWRKL1'
     C                   Eval      DBKEY = MGNWRK
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Get_NwrkAcDet  Get Network Account Details                   *
      *                 and account details                           *
      *                                                               *
      *****************************************************************
     C     Get_NwrkAcDet BEGSR

      *  Access Network Account Details
     C                   Eval      KNwrk  = MGNWRK
     C                   Eval      KBrca  = MGBRCA
     C                   Eval      KCnum  = MGCNUM
     C                   Eval      Kccy   = MGCCY
     C                   Eval      KAccd  = MGACCD
     C                   Eval      KAcsq  = MGACSQ
     C                   Eval      KNaty  = MGNATY

     C     KNwrkAc       Chain     GLNWACL0                           03

     C                   If        *IN03 = *On
     C     *Lock         In        LDA
     C                   Eval      DBASE = 2
     C                   Eval      DBFILE = 'GLNWACL0'
     C                   Eval      DBKEY = KNetAc
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif

     C
     C*  Get SWIFT account code currency
     C                   Call      'AOCURRR0'
     C                   Parm      '*DBERR'      @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      MGCCY         @CCY              3
     C     SDCURR        Parm      SDCURR        DSSDY

      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVEL     MGCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Movel     MGCNUM        PCusN
     C                   Movel     MGACCD        PAcctCde
     C                   Movel     MGACSQ        PAcctSeq
     C/COPY WNCPYSRC,MGH00048
     C                   If        CMG006 = 'Y' and KNwrk = 'SWIFT'                           CMG006
     C                   Exsr      SrGetDs                                                    CMG006
     C                   Endif                                                                CMG006

     C*  Output IBAN, RE or GL account.
      *                                                                                       CMG006
     C                   If        CMG006 = 'Y'                                               CMG006
     C                   CLEAR                   ACFMTPGM                                     CMG006
     C                   Endif                                                                CMG006
     C                   IF        CMG006 = 'Y' and KNwrk = 'SWIFT'                           CMG006
     C                                          and WDstn =  Kdstn1                           CMG006
     C                   Eval      ACFMTPGM =  'MGFLD25'                                      CMG006
     C                   Exsr      ACNTFMT                                                    CMG006
     C                   ELSE                                                                 CMG006
     C                   If        CER030 = 'Y'                                             BUG25799
      *                                                                                     BUG25799
     C*  Output IBAN, RE or GL account.
     C                   SELECT                                                             BUG23740
      *                                                                                     BUG23740
     C                   WHEN      EDACNF = '*IBAN'                                         BUG23740
     C                   Select
     C                   When      MGIBAN <> *Blank
     C                   Movel     MGIBAN        WAccount
     C                   When      MGACNO <> 0
     C                   Movel     MGACNO        WAccount
     C                   Other
     C                   Eval      WAccount = MGBRCA + PCusN + MGCCY +
     C                                        PAcctCde + PAcctSeq
     C                   Endsl
      *                                                                                     BUG23740
     C                   WHEN      EDACNF = '*LEDGER'                                       BUG23740
     C                   EVAL      WAccount = MGBRCA                                        BUG23740
     C                                      + PCusN                                         BUG23740
     C                                      + MGCCY                                         BUG23740
     C                                      + PAcctcde                                      BUG23740
     C                                      + PAcctSeq                                      BUG23740
      *                                                                                     BUG23740
     C                   WHEN      EDACNF = '*RETAIL'                                       BUG23740
     C                   IF        MGACNO <> *ZEROS                                         BUG23740
     C                   MOVE      *BLANKS       WAccount                                   BUG23740
     C                   MOVEL     MGACNO        WAccount                                   BUG23740
     C                   ELSE                                                               BUG23740
     C                   EVAL      WAccount = MGBRCA + PCusN + MGCCY +                      BUG23740
     C                                        PAcctcde + PAcctSeq                           BUG23740
     C                   ENDIF                                                              BUG23740
      *                                                                                     BUG23740
     C                   ENDSL                                                              BUG23740
      *                                                                                     BUG25799
      ** CER030 = 'N'                                                                       BUG25799
     C                   Else                                                               BUG25799
      *                                                                                     BUG25799
     C                   Select                                                             BUG25799
     C                   When      MGIBAN <> *Blank                                         BUG25799
     C                   Movel     MGIBAN        WAccount                                   BUG25799
     C                   When      MGACNO <> 0                                              BUG25799
     C                   Movel     MGACNO        WAccount                                   BUG25799
     C                   Other                                                              BUG25799
     C                   Eval      WAccount = MGBRCA + PCusN + MGCCY +                      BUG25799
     C                                        PAcctCde + PAcctSeq                           BUG25799
     C                   Endsl                                                              BUG25799
     C/COPY WNCPYSRC,MGH00049
      *                                                                                     BUG25799
     C                   EndIf                                                              BUG25799
     C                   ENDIF                                                                CMG006

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Format_MT950 - Format MT950 Message                          *
      *                                                               *
      *****************************************************************
     C     Format_MT950  BEGSR

     C/COPY OFCPYSRCZ,CGL146_143                                                            MD024641
                                                                                            MD024641
      * Field :20: Transaction number
     C                   Exsr      Format_20
      *
      * Field :25: Account Identification
     C                   Exsr      Format_25
      *
      * Field :28C: Entry Number and Page Number
     C                   Exsr      Format_28
      *
     C                   Exsr      Format_60
      *
      * Repeating field :61: Statement Line
      *
     C                   Exsr      Format_61
      *
      * Field :62a: Closing Balance  (non-final)
     C                   Exsr      Format_62
      *
      * Do not format the following fields if new page.
      *
     C                   If        NewPage  <>'Y'
      *
      * Field :64: Closing Available Balance
     C/COPY OFCPYSRCZ,CGL146_142                                                            MD024641
     C                   Exsr      Format_64
     C/COPY OFCPYSRCZ,CGL146_141                                                            MD024641
      *
      *  Field :62: Revisited (record final closing balance)
     C                   Exsr      Format_F62
      *
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_20 - Format Field 20 Transaction Number                *
      *                                                               *
      *****************************************************************

     C     Format_20     BEGSR

      *  Field :20: Transaction number  = 'GL' + rundate in YYMMDD + sequence
      *
     C                   Eval      Q = 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':20:'
     C                   Eval      WSeqNum = WSeqNum + 1
      /COPY OFCPYSRCZ,CGL146_091                                                             CGL146A
     C                   Eval      SavTrno = 'GL' + WRundChr + WSeqChr
     C                   Eval      MFLD    = SavTrno
     C                   Eval      CTRC    = WCrLf
      *
     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_25 - Format Field 25, Account Identification           *
      *                                                               *
      *****************************************************************

     C     Format_25     BEGSR

      *  Field :25: Account Identification = IBAN, RE or GL account
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':25:'
     C                   Eval      MFLD = WAccount
     C/COPY WNCPYSRC,MGH00093
     C                   Eval      CTRC    = WCrLf
      *
     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_28 - Format Field 28C Entry and Page Number            *
      *                                                               *
      *****************************************************************

     C     Format_28     BEGSR

      *  Field :28C: Entry Number and Page Number

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':28C:'
     C                   Movel     MGSTNO        MFLD
     C                   Cat       '/':0         MFLD
     C                   Cat       WPageChr:0    MFLD
     C                   Eval      CTRC    = WCrLf
      *
     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_60 - Format Field 60  Opening Balance                  *
      *                                                               *
      *****************************************************************

     C     Format_60     BEGSR

      *  Field :60a: Opening Balance

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
      *  If page number is = 1, use opening balance and date from MGF950PD (option F)
      *  Else, use closing balance and date from previous page (option M)
      *
     C                   If        WPageNum = 1
     C                   Eval      MTAG = ':60F:'
     C                   Z-add     MGIOBL        ZAMT
     C                   Z-add     MGLSDT        ZMDAY
     C                   Else
     C                   Eval      MTAG = ':60M:'
     C                   Z-add     WPrvCBAL      ZAMT
     C                   Z-add     WPrvCDate     ZMDAY
      /COPY OFCPYSRCZ,CGL146_097                                                             CGL146A
     C                   Endif
      *
      *  Set this amount as starting point for this page's Closing Balance
     C                   Z-add     ZAMT          PageClBal
      *
      *  Determine DR/CR
     C                   If        ZAMT > *Zeros
     C                   Movel     'D'           MFLD
     C                   Else
     C                   Movel     'C'           MFLD
     C                   Endif
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   Eval      %subst(MFLD :2:6)   = ZMDATE
     C                   Eval      %subst(MFLD :8:3)   = A6SWCY
     C                   Eval      %subst(MFLD :11:15) = ZSAMNT
     C                   Eval      CTRC    = WCrLf

     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_61    - Format Repeating field  61                     *
      *                                                               *
      *****************************************************************

     C     Format_61     BEGSR

      *    Format only if postings exist in MGX950L0 for this network account

     C                   IF        WSort61 = 'Y'                                            MD042041
     C     KNwrkAc       SETLL     MGX950L1                                                 MD042041
     C                   READ      MGX950L1                               65                MD042041
     C                   ELSE                                                               MD042041
     C     KNwrkAc       Setll     MGX950L0

     C                   READ      MGX950L0                               65
     C                   ENDIF                                                              MD042041

     C                   DOW       *IN65 = *OFF  And
     C                             KNWrk = X_MGNWRK  And
     C                             KBrca = X_MGBRCA  And
     C                             KCnum = X_MGCNUM  And
     C                             KCcy  = X_MGCCY   And
     C                             KAccd = X_MGACCD  And
     C                             KAcsq = X_MGACSQ  And
     C                             KNaty = X_MGNATY

      *    Begin Formatting Field :61:

     C                   Eval      WString100 = *Blank
     C                   Eval      Subfld1    = *Blank
     C                   Eval      Subfld2    = *Blank
     C                   Eval      Subfld3    = *Blank
     C                   Eval      Subfld4    = *Blank
     C                   Eval      Subfld5    = *Blank
     C                   Eval      Subfld6    = *Blank
     C                   Eval      Subfld7    = *Blank
     C                   Eval      Subfld8    = *Blank
     C                   Eval      Subfld9    = *Blank

      *    Subfld 1 = Value date in YYMMDD

     C                   Z-add     X_MGVALD      ZMDAY
      *
     C                   Exsr      Call_ZM0060
     C                   Eval      Subfld1 = ZMDATE

      *    Subfld 2 = Posting date in MMDD
     C                   Z-add     X_MGPSTD      ZMDAY
     C                   Exsr      Call_ZM0060
     C                   Move      ZMDATE        Subfld2

      *    Subfld 3 = Debit/Credit Indicator
     C                   Movel     X_MGDRCR      Subfld3

      *    Subfld 4 = Funds Code
     C/COPY WNCPYSRC,MGH00050
     C                   IF        ED5F61 = 'Y'                                               CER030
     C**********                   and CER030 = 'Y'                               BUG25800 BUG25800A
     C**********                   or  CER030 = 'N'                               BUG25800 BUG25800A
     C                   Move      A6SWCY        Subfld4
     C/COPY WNCPYSRC,MGH00051
     C                   ENDIF                                                                CER030

      *    Subfld 5 = Posting Amount
     C                   Z-add     X_MGPSTA      ZAMT
     C                   Exsr      Call_ZM0040
     C                   Movel     ZSAMNT        Subfld5


      *    Subfld 6 = Transaction type identification code
     C                   Movel     X_MGSFD6      Subfld6

      *    Subfld 7 = Reference for the Account Owner
     C                   Movel     X_MGSFD7      Subfld7

      *    Subfld 8 = Account Servicing Institution's Reference
     C                   Movel     X_MGSFD8      Subfld8

      *    Subfld 9 = Supplementary Details
     C                   Movel     X_MGSFD9      Subfld9

      *    Concatenate Fld 61 subfields into 1 long string and determine length

     C                   Movel     Subfld1       Wstring100
     C                   Cat       Subfld2:0     Wstring100
     C                   Cat       Subfld3:0     Wstring100
     C                   Cat       Subfld4:0     Wstring100
     C                   Cat       Subfld5:0     Wstring100
     C                   Cat       Subfld6:0     Wstring100
     C                   Cat       Subfld7:0     Wstring100
     C                   Cat       Subfld8:0     Wstring100

     C                   MoveA     *Blanks       AL100
     C                   MoveA     WString100    AL100
     C                   Exsr      SRDetFldLen

     C*  Add 4 for tag and 2 for CRLF
     C                   Eval      Wfld61Len = WFldLen + 4 + 2

     C*  Field 61 subfield 9
     C                   MoveA     *Blanks       AL100
     C                   MoveA     Subfld9       AL100
     C                   Exsr      SRDetFldLen
     C*  Add 2 for CRLF
     C                   Eval      Wfld61Len = Wfld61Len + WFldLen + 2


      *    Leave this posting for next page if:
      *    (1)  Max MT950 Length < £current message count + Fld 62 Closing
      *         Balance approx length + current Fld 61 length]
      *    (2)  OR  MT950 Length >= £current message count + current fld 61 length
      *          Fld 62 Closing Balance Approximate length]
      *         But only fld 64 is left to output and adding this field will
      *         exceed maximum length.
      *    Else place this posting in MULT DS

     C                   Eval      WLength1 = WMsgCount + 32 + WFld61Len
     C                   Eval      WLength2 = WLength1  + 32
     C
     C                   If        ED5MXL < Wlength1 OR
     C                             ED5MXL >=  Wlength1 AND
     C                             ED5MXL <   Wlength2

     C                   Eval      NewPage  = 'Y'
     C                   Leave

     C                   Else
      *
      *   Move Fld 61 into the multiple data structure
      *     First 50 characters
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':61:'
     C                   Movel     WString100    MFLD
     C                   Eval      CTRC    = WCrLf
      *     More than 50 characters
     C                   If        %subst(WString100 : 51 : 50 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(WString100 : 51 : 50)
     C                   Endif
      *     Subfld 9
     C                   If        Subfld9 <> *blank
     C********           Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = Subfld9
     C                   Endif
      *
      *  Update Message Length
      *
     C                   Eval      WMsgCount = WMsgCount + WFld61Len
      *
      *  Accumulate this page's Closing Balance
      *
     C                   If        %subst(X_MGDRCR : 1 : 1) = 'D'
     C                   Eval      PageClBal = PageClBal + X_MGPSTA
     C                   Else
     C                   Eval      PageClBal = PageClBal - X_MGPSTA
     C                   Endif
      *
      *  Record the value date used   for use in :62a:
     C                   Z-add     X_MGVALD      PageClDate
      *
      *  Delete record from MGX950PD
      *
     C                   IF        WSort61 = 'Y'                                            MD042041
     C                   DELETE    MGX950L1                                                 MD042041
     C                   ELSE                                                               MD042041
     C                   Delete    MGX950L0
     C                   ENDIF                                                              MD042041
      *
     C                   Endif

     C                   IF        WSort61 = 'Y'                                            MD042041
     C                   READ      MGX950L1                               65                MD042041
     C                   ELSE                                                               MD042041
     C                   READ      MGX950L0                               65
     C                   ENDIF                                                              MD042041

     C                   Enddo

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_62 - Format Field 62a Closing Balance                  *
      *                                                               *
      *****************************************************************

     C     Format_62     BEGSR

      *  Field :62a: Closing Balance  (non-final)

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
      *  At this stage, assume this is not the final page.  This will be
      *  revisited once the final field 86 is output.
      *
     C                   Eval      MTAG = ':62M:'
     C                   Z-add     PageClBal     ZAMT
     C                   Z-add     PageClDate    ZMDAY
      /COPY OFCPYSRCZ,CGL146_097                                                             CGL146A
      *
      *  Record occurence number for later update if last page
      *
     C                   Z-add     Q             W62Loc
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   If        PageClBal > *Zeros
     C                   Movel     'D'           MFLD
     C                   Else
     C                   Movel     'C'           MFLD
     C                   Endif

     C                   Eval      %subst(MFLD :2:6)   = ZMDATE
     C                   Eval      %subst(MFLD :8:3)   = A6SWCY
     C                   Eval      %subst(MFLD :11:15) = ZSAMNT
     C                   Eval      CTRC    = WCrLf

     C                   Z-add     PageClBal     WPrvCBAL
     C                   Z-add     ZMDAY         WPrvCDate

     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_64 - Format Field 64  Closing Available Balance        *
      *                                                               *
      *****************************************************************

     C     Format_64     BEGSR

      *  Field :64: Closing Available Balance
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
     C                   Eval      MTAG = ':64:'
     C                   Z-add     MGCLBL        ZAMT
     C                   Z-add     BJRDNB        ZMDAY
      /COPY OFCPYSRCZ,CGL146_097                                                             CGL146A
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   If        MGCLBL > *Zeros
     C                   Movel     'D'           MFLD
     C                   Else
     C                   Movel     'C'           MFLD
     C                   Endif

     C                   Eval      %subst(MFLD :2:6)   = ZMDATE
     C                   Eval      %subst(MFLD :8:3)   = A6SWCY
     C                   Eval      %subst(MFLD :11:15) = ZSAMNT
     C                   Eval      CTRC    = WCrLf

     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_F62 - Format Final Field 62                            *
      *                                                               *
      *****************************************************************

     C     Format_F62    BEGSR

      *  Field :62: Revisited (record final closing balance)

     C     W62Loc        Occur     MULT
      *
     C                   Eval      MTAG = ':62F:'
     C                   Z-add     MGFCBL        ZAMT
     C                   Z-add     BJRDNB        ZMDAY
      /COPY OFCPYSRCZ,CGL146_097                                                             CGL146A
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   If        MGFCBL > *Zeros
     C                   Movel     'D'           MFLD
     C                   Else
     C                   Movel     'C'           MFLD
     C                   Endif

     C                   Eval      %subst(MFLD :2:6)   = ZMDATE
     C                   Eval      %subst(MFLD :8:3)   = A6SWCY
     C                   Eval      %subst(MFLD :11:15) = ZSAMNT
     C                   Eval      CTRC    = WCrLf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROref - Output Record to MGOREFPD                            *
      *                                                               *
      *****************************************************************

     C     SROref        BEGSR

      ** Initialise fields on PF/MGOREFPD

     C                   CLEAR                   MGOREFD0
     C
     C                   Eval      SYTM = *Blanks
     C                   Eval      MODI = 'GL'
     C
     C                   Eval      TRNO = SavTRNO
     C                   Eval      TRNF = *Blanks
     C                   Eval      TRNM = *Blanks
     C                   Eval      MTRN = *Blanks
     C                   Eval      TNTP = *Blanks
     C                   Eval      SBTP = *Blanks
     C                   Eval      EVTP = *Blanks
     C                   Eval      NWRK = MGNWRK
     C/COPY OFCPYSRCZ,CGL146_063                                                              CGL146
     C/COPY WNCPYSRC,EML104_014                                                               EML104

     C**********         Call      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *blanks       P@RTCD            7
     C                   Parm      '*KEY   '     P@OPTN            7
     C                   Parm      MGBRCA        P@BRCA            3
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029

      ** Error on call
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVEL     MGBRCA        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Move      A8BICN        SECN

     C                   If        MGNWRK = 'SWIFT '
     C                   Eval      NWSN = A8BTID
     C                   ENDIF

     C                   Movel     MGCNUM        DECN

     C                   Movel     DECN          PKEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PKEY1            10
     C                   PARM      *BLANK        PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     PKEY1         DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   Select
     C                   When      MGNWRK = 'SWIFT '
     C                   Movel     BBCSID        NWDS
     C                   When      MGNWRK = 'TELEX '
     C                   Movel     BBTXA1        NWDS
     C                   When      MGNWRK = 'STTX  '
     C                   Movel     BBSTAD        NWDS
     C                   Endsl

     C                   Movel     *Blanks       NWBN
     C                   Movel     '950'         MTPY

     C                   If        A6DPRU = 'Y'
     C                   Eval      MPRY = 'U'
     C                   Else
     C                   Eval      MPRY = 'N'
     C                   End

     C                   If        MGDMST = 'C'
     C                   Movel     '1'           MGSG
     C                   Movel     'CRTD'        MGST
     C                   Else
     C                   Movel     '2'           MGSG
     C                   Movel     'RSND'        MGST
     C                   Endif

     C                   Movel     *blanks       LSCC
     C                   Movel     *blanks       F57U
     C                   Movel     *blanks       PTST
     C                   Movel     *blanks       CARQ
     C                   Movel     *blanks       MPDE
     C                   Movel     WHrdt         HRDT
     C                   Movel     WRundNum      MGDE
     C                   Z-add     NA5LST        MGTM
     C                   Move      BJMRDT        LADT
     C                   Time                    LATM

     C                   If        MGST = 'RSND'
     C                   Move      BJMRDT        RELD
     C                   Eval      LATM = MGTM
     C                   Else
     C                   Move      *Blanks       RELD
     C                   Eval      RELT = 0
     C                   End

     C                   Eval      RUSR = *blanks
     C                   Eval      RWSN = *blanks

     C                   Movel     *blanks       AMTX
     C                   Movel     *blanks       AMTS
     C                   Movel     *blanks       SVDT
     C                   Move      MGCCY         CCY
     C                   Z-add     0             NSNO

     C                   Select
      *                                                                                     MD042357
      ** Don't use IBAN - Internal IUS pgms not designed to use.                            MD042357
      ** Revert to Re AcNo                                                                  MD042357
      *                                                                                     MD042357
     C**********         When      MGIBAN <> *Blank                                         MD042357
     C**********         Movel     MGIBAN        SACN                                       MD042357
     C**********         Movel     *blanks       AORR                                       MD042357
     C/COPY WNCPYSRC,EML107_001
     C                   When      MGACNO <> 0
     C                   Movel     MGACNO        SACN
     C                   Movel     'R'           AORR
     C                   Other
     C**********         Eval      SACN = %SUBST(WAccount:4:15)                               CGL029
     C                   EVAL      SACN = %SUBST(WAccount:4:21)                               CGL029
     C                   Movel     'A'           AORR
     C                   Endsl

     C                   Move      *blanks       DESI
     C                   Move      MGBRCA        BRCA
     C                   Move      *blanks       OTHB
     C                   Move      *blanks       RCBR
     C                   Move      *blanks       OTHT
     C                   Move      *blanks       NETI

     C                   If        A6NDWR = 'Y'
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '3'
     C                   Else
     C                   Eval      DELC = '1'
     C                   Endif
      *
     C                   Else
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '2'
     C                   Else
     C                   Eval      DELC = *Blanks
     C                   Endif
     C                   Endif
      *
      ** Ensure message priority and delivery notification valid
      ** MPRY = 'U' DELC = '1' or '3',
      ** MPRY = 'N' DELC = ' ' or '2'.
     C     MPRY          IFEQ      'U'
     C     DELC          ANDEQ     ' '
     C     MPRY          OREQ      'U'
     C     DELC          ANDEQ     '2'
     C                   MOVEL     '1'           DELC
     C                   END
      *
     C     MPRY          IFEQ      'N'
     C     DELC          ANDEQ     '1'
     C     MPRY          OREQ      'N'
     C     DELC          ANDEQ     '3'
     C                   MOVEL     '2'           DELC
     C                   END

     C                   Move      *blanks       DYST
     C                   Move      *blanks       RSID
     C                   Move      *blanks       MSE1
     C                   Move      *blanks       ELIN
     C                   Move      *blanks       SSAC
     C                   Move      *blanks       MIR
     C                   Eval      TSKS = 'Y'
     C                   Eval      TSKY = *Blanks
     C                   Eval      TSEQ = *Zeros
     C                   Eval      CFPF = *Blanks
     C                   Eval      PT210 = *Zeros
     C                   Eval      AVDT = *Zeros
     C                   Eval      ASEQ = *Zeros
     C                   Eval      TODY = *Blanks
      *
      ** Set-up Message Generation Century flag
      *
     C                   Movel     MGDE          YY                2 0
     C                   If        YY < 72
     C                   Eval      CIND = '2'
     C                   Else
     C                   Eval      CIND = '1'
     C                   Endif
     C                   Eval      CINDV = *Blanks
     C                   Move      *Blanks       CLSS              1

     C                   Write     MGOREFD0                             41

     C                   If        *IN41 = *ON
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'Write  '     DBKEY
     C                   MOVEL     'MGOREFPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   ENDSR
      *****************************************************************                       CMG006
      *                                                               *                       CMG006
      * SrGetDs - Get SWIFT destination                               *                       CMG006
      *                                                               *                       CMG006
      *****************************************************************                       CMG006
                                                                                              CMG006
     C     SrGetDs       BEGSR                                                                CMG006
                                                                                              CMG006
     C                   Movel     MGCNUM        PKEY1                                        CMG006
                                                                                              CMG006
     C                   CALL      'AOCUSTR0'                                                 CMG006
     C                   PARM      *BLANKS       PRTCD             7                          CMG006
     C                   PARM      '*KEY   '     POPTN             7                          CMG006
     C                   PARM                    PKEY1            10                          CMG006
     C                   PARM      *BLANK        PKYST             7                          CMG006
     C     SDCUST        PARM      SDCUST        DSSDY                                        CMG006
      ** Error on call                                                                        CMG006
     C     @RTCD         IFNE      *BLANK                                                     CMG006
     C     *LOCK         IN        LDA                                                        CMG006
     C                   Z-ADD     11            DBASE                                        CMG006
     C                   MOVEL     PKEY1         DBKEY                                        CMG006
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CMG006
     C                   OUT       LDA                                                        CMG006
     C                   EXSR      *PSSR                                                      CMG006
     C                   Else                                                                 CMG006
     C                   Eval      Kdstn1  =  BBCSID                                          CMG006
     C                   ENDIF                                                                CMG006
     C
     C                   ENDSR                                                                CMG006
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROMsg - Output to PF/MGOMSGPD                               *
      *                                                               *
      *****************************************************************
     C     SROMsg        BEGSR

      ** Process Multiple Occurence Data Structure

     C                   Movel     *blanks       PTDL
     C                   Movel     SavTrno       TRNO
     C                   EVAL      X = 1
      *
      **  Write multiple occurrence data structure to MGOMSGPD
     C                   Z-ADD     1             X
     C     X             OCCUR     MULT
      *
     C                   Dow       X <= Q
     C                   Write     MGOMSGD0                             42
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C                   If        *IN42
     C     *LOCK         IN        LDA
     C                   Z-Add     6             DBASE
     C                   Movel     '       '     DBKEY
     C                   Movel     'MGOMSGPD'    DBFILE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Eval      X = X + 1
     C     X             OCCUR     MULT
     C                   Enddo

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Call_ZM0040 - Convert amount to SWIFT format                  *
      *                                                               *
      *****************************************************************

     C     Call_ZM0040   BEGSR
      *
      *  Convert Amount to SWIFT format
      *
     C                   Movel     MGCCY         ZCCY
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMT             13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT           15
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC            1                          222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0040'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Call_ZM0060 - Convert date to YYMMDD format                   *
      *                                                               *
      *****************************************************************

     C     Call_ZM0060   BEGSR

     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZMDATE            6
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     8             DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      *****************************************************************                       CMG006
      *                                                               *                       CMG006
      * ACNTFMT     - Format Account                                  *                       CMG006
      *                                                               *                       CMG006
      *****************************************************************                       CMG006

     C     ACNTFMT       BEGSR                                                                CMG006

     C                   Movel     MGCCY         PCCY              3                          CMG006
     C                   Movel     MGACNO        PACNO            10                          CMG006

     C                   Call      ACFMTPGM                                                   CMG006
     C                   Parm                    PCCY              3                          CMG006
     C                   Parm                    PACNO            10                          CMG006
     C                   Parm                    PACCID           35                          CMG006

     C                   EVAL      WAccount = PACCID                                          CMG006

     C                   ENDSR                                                                CMG006
      /EJECT
     C/COPY OFCPYSRCZ,CGL146_095                                                             CGL146A
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Read in Installation Data

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error.

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access SDMGMEPD for message management data

     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG    '    PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDMGME        PARM      SDMGME        DSFDY

      ** Database error.

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMGMEPD'
     C                   EVAL      DBASE = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            BUG25800
     C                   CallB     'AOSARDR0'                                               BUG25800
     C                   PARM      *Blanks       PRtcd                                      BUG25800
     C                   PARM      '*VERIFY'     POptn                                      BUG25800
     C                   PARM      'CER030'      PSard                                      BUG25800
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG25800
                                                                                            BUG25800
      ** Database error                                                                     BUG25800
                                                                                            BUG25800
     C                   IF        (PRtcd <> *Blanks) and                                   BUG25800
     C                             (PRtcd <> '*NRF   ')                                     BUG25800
     C                   EVAL      DBKEY = 'CER030'                                         BUG25800
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG25800
     C                   EVAL      DBASE = 11                                               BUG25800
     C                   EXSR      *PSSR                                                    BUG25800
     C                   ENDIF                                                              BUG25800
                                                                                            BUG25800
     C                   IF        PRtcd  = *Blanks                                         BUG25800
     C                   EVAL      CER030 = 'Y'                                             BUG25800
     C                   ELSE                                                               BUG25800
     C                   EVAL      CER030 = 'N'                                             BUG25800
     C                   ENDIF                                                              BUG25800

      ** Check if CMG006 is switched on.                                                      CMG006

     C                   CALL      'AOSARDR0'                                                 CMG006
     C                   PARM      *BLANKS       P@RTCD                                       CMG006
     C                   PARM      '*KEY   '     P@OPTN                                       CMG006
     C                   PARM      'CMG006'      P@SARD                                       CMG006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG006
      *                                                                                       CMG006
     C     P@RTCD        IFEQ      *BLANKS                                                    CMG006
     C                   MOVE      'Y'           CMG006            1                          CMG006
     C                   ELSE                                                                 CMG006
     C                   MOVE      'N'           CMG006                                       CMG006
     C                   ENDIF                                                                CMG006
      * Check system values                                                                   CMG006
     C                   CALL      'AOSVALR0'                                                 CMG006
     C                   PARM                    @RTCD             7                          CMG006
     C                   PARM      FldDstn       SysValK1                                     CMG006
     C                   PARM                    SVAL1           200                          CMG006
     C                   PARM      *BLANK        SVALK2           20                          CMG006
     C                   PARM                    SVAL2           200                          CMG006
     C                   PARM      *BLANK        SVALK3           20                          CMG006
     C                   PARM                    SVAL3           200                          CMG006
     C                   PARM      *BLANK        SVALK4           20                          CMG006
     C                   PARM                    SVAL4           200                          CMG006
     C                   PARM      *BLANK        SVALK5           20                          CMG006
     C                   PARM                    SVAL5           200                          CMG006
     C                   PARM      *BLANK        SVALK6           20                          CMG006
     C                   PARM                    SVAL6           200                          CMG006
     C                   PARM      *BLANK        SVALK7           20                          CMG006
     C                   PARM                    SVAL7           200                          CMG006
     C                   PARM      *BLANK        SVALK8           20                          CMG006
     C                   PARM                    SVAL8           200                          CMG006
     C                   PARM      *BLANK        SVALK9           20                          CMG006
     C                   PARM                    SVAL9           200                          CMG006
     C                   PARM      *BLANK        SVALK0           20                          CMG006
     C                   PARM                    SVAL10          200                          CMG006
      *                                                                                       CMG006
     C     @RTCD         IFNE      *BLANK                                                     CMG006
     C                   MOVEL     Flddstn       DBKEY                                        CMG006
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CMG006
     C                   MOVEL     '001'         DBASE                                        CMG006
     C                   SETON                                        U7U8                    CMG006
     C                   EXSR      *PSSR                                                      CMG006

     C                   ELSE                                                                 CMG006

     C                   MOVEL     SVAL1         WDstn            10            Dstn Destn    CMG006

     C                   ENDIF                                                                CMG006

     C/COPY WNCPYSRC,MGH00094
     C/COPY OFCPYSRCZ,CGL146_064                                                              CGL146
     C/COPY OFCPYSRCZ,CGL146_094                                                             CGL146A
      *
      **  Convert history retention date to YYMMDD
      *
     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   Exsr      Call_ZM0060
     C                   MOVE      ZMDATE        WHrdt
      *
     C                   Eval      ZMDAY = BJRDNB
     C                   Exsr      Call_ZM0060
     C                   Move      ZMDATE        WRundNum
     C                   Move      ZMDATE        WRundChr
      *

      **  Initialise constant fields
      *
     C                   Eval      WCrLf = *LOVAL
     C                   BITON     '457'         WWCr
     C                   BITON     '257'         WWLf

      ** Key List

     C     KNwrkAc       KLIST
     C                   KFLD                    KNwrk
     C                   KFLD                    KBrca
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
     C                   KFLD                    KNaty
     C/COPY WNCPYSRC,MGH00095

     C/COPY OFCPYSRCZ,CGL146_144                                                            MD024641
     C/COPY OFCPYSRCZ,CGL146_146                                                            MD024641
                                                                                            MD024641
      *  Access last generated sequence number from MGOREFPD
     C                   Eval      WTrno = 'GL' + WRundChr + '999999'
     C     WTrno         SETGT     MGOREFL0
     C                   READP     MGOREFL0                               15
      *    If ReadP successful, and first 8 characters of record read equals
      *    'GL' + rundate, store sequence number
     C                   If        *IN15 = *Off And
     C                             %subst(E_TRNO: 1 : 8) = 'GL' + WRundChr
     C                   Eval      WSeqChr = %subst(E_TRNO : 9 : 6)
     C                   Else
      *    Else  ReadP not successful or first 2 components do not match,
      *    this is first GL message so set sequence to blank
     C                   Eval      WSeqChr = *blank
     C                   Endif

     C                   Eval      Count950 = 0

     C/COPY WNCPYSRC,MGH00052
      *                                                                                     MD042041
     C                   CALL      'AOSVALR0'                                               MD042041
     C                   PARM      *BLANKS       PRtcd                                      MD042041
     C                   PARM      SValK1        SysValK1                                   MD042041
     C                   PARM                    SysVal1                                    MD042041
     C                   PARM      *BLANKS       SysValK2                                   MD042041
     C                   PARM                    SysVal2                                    MD042041
     C                   PARM      *BLANKS       SysValK3                                   MD042041
     C                   PARM                    SysVal3                                    MD042041
     C                   PARM      *BLANKS       SysValK4                                   MD042041
     C                   PARM                    SysVal4                                    MD042041
     C                   PARM      *BLANKS       SysValK5                                   MD042041
     C                   PARM                    SysVal5                                    MD042041
     C                   PARM      *BLANKS       SysValK6                                   MD042041
     C                   PARM                    SysVal6                                    MD042041
     C                   PARM      *BLANKS       SysValK7                                   MD042041
     C                   PARM                    SysVal7                                    MD042041
     C                   PARM      *BLANKS       SysValK8                                   MD042041
     C                   PARM                    SysVal8                                    MD042041
     C                   PARM      *BLANKS       SysValK9                                   MD042041
     C                   PARM                    SysVal9                                    MD042041
     C                   PARM      *BLANKS       SysValK10                                  MD042041
     C                   PARM                    SysVal10                                   MD042041
      *                                                                                     MD042041
     C                   IF        PRtcd <> *BLANKS                                         MD042041
      *                                                                                     MD042041
     C     *LOCK         IN        LDA                                                      MD042041
     C                   EVAL      DBPGM = 'MG000950'                                       MD042041
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD042041
     C                   EVAL      DBASE = 014                                              MD042041
     C                   EVAL      DBKEY = %TRIM(SysValK1)                                  MD042041
     C                   OUT       LDA                                                      MD042041
      *                                                                                     MD042041
     C                   EXSR      *PSSR                                                    MD042041
      *                                                                                     MD042041
     C                   ELSE                                                               MD042041
      *                                                                                     MD042041
     C                   MOVEL     SysVal1       WSort61                                    MD042041
     C                   ENDIF                                                              MD042041
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND  - Subroutine to End Program                            *
      *                                                               *
      *****************************************************************

     C     SREND         BEGSR

      **   Output Report Header

     C                   Write     HEADAU

      **   If there is a DB Error, Output the DB Error Information.
     C                   If        *INU7 = *ON
     C                   Write     DBERROR
     C                   Else
     C                   Write     HASRUN
     C                   Endif
      *
      *  End program
     C                   Seton                                        LR
     C                   Return

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

     C                   DUMP

     C                   ROLBK
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SREnd

     C                   ENDSR
      ********************************************************************
     O/COPY FTCPYSRC,FTSWIFTRAN
