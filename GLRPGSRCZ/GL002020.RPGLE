     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Available Balance Enquiry')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL002020 - Available Balance Enquiry                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. 248653             Date 17Feb12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 09May06               *
      *                 BUG5334 *CREATE    Date 10Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  248653  - Format Overdraft Line to display the correct value *
      *            on the screen (Applied for AR914562)               *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG5334 - Retail Account Balance Check. Fix for CRE010.      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGL002020DFCF   E             WORKSTN
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** External Data Area for Linked Enquiry Processing
     DEMSDS          E DS                  EXTNAME(EMDTA)
     D CNUMP                 141    146
     D CURRP                 147    149
     D ACODP                 150    159
     D ACSQP                 160    161
     D BRCHP                 162    164
     D LINKP                 165    166
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*KCUST****       S              6S 0                                                   CSD027A
     D KCUST           S              6                                                      CSD027A
     D KCCY            S              3
     D KACOD           S             10S 0
     D KACSQ           S              2S 0
     D KBRCA           S              3
 
     D PRTCD           S              7
     D POPTN           S              7
 
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
     D WKCLBL          S             15  0
     D WKAVBL          S             15  0
     D WRUN            S              1
     D WKODLN          S             15  0                                                    248653
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      KCCY = CURRP
     C                   EVAL      KBRCA = BRCHP
     C                   MOVEL     CNUMP         KCUST
     C                   MOVEL     ACODP         KACOD
     C                   MOVEL     ACSQP         KACSQ
 
     C     KACCT         CHAIN     MEMOSL1                            40
 
     C                   IF        *IN40 = *ON
     C                   EVAL      DBFILE = 'MEMOS'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = CNUMP + CURRP + ACODP +
     C                                     ACSQP + BRCHP
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KACCT         CHAIN     ACCNTL0                            41
 
     C                   IF        *IN41 = *ON
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = CNUMP + CURRP + ACODP +
     C                                     ACSQP + BRCHP
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        *IN40 = *OFF and *IN41 = *OFF
     C                   EXSR      SRInitial
     C                   EXSR      SRWriteDet
     C                   ENDIF
 
     C     *LOCK         IN        EMSDS
 
     C                   IF        *INKC = *ON
     C                   EVAL      RETND = 'Q'
     C                   ELSE
 
     C                   IF        *INKL = *ON
     C                   EVAL      RETND = 'U'
     C                   ELSE
     C                   EVAL      RETND = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   OUT       EMSDS
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitial - Initialise Display File Fields                   *
      *                                                               *
      *****************************************************************
 
     C     SRInitial     BEGSR
 
     C                   EVAL      *IN26 = *OFF
 
     C                   EVAL      DDBRCA = *BLANKS
     C                   EVAL      DDCCY = *BLANKS
     C                   EVAL      DDANAM = *BLANKS
     C                   EVAL      DDCNUM = *BLANKS
     C                   EVAL      DDACOD= *BLANKS
     C                   EVAL      DDACSQ = *BLANKS
     C                   EVAL      DDCLBL = *BLANKS
     C                   EVAL      DDHELD = *BLANKS
     C                   EVAL      DDBCOA = *BLANKS
     C                   EVAL      DDODLN = *BLANKS
     C                   EVAL      DDTOTA = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteDet - Write Available Balance Details                 *
      *                                                               *
      *****************************************************************
 
     C     SRWriteDet    BEGSR
 
     C                   EVAL      DDBRCA = BRCHP
     C                   EVAL      DDCCY = CURRP
     C                   EVAL      DDANAM = ANAM
     C                   MOVEL     CNUMP         DDCNUM
     C                   MOVEL     ACODP         DDACOD
     C                   MOVEL     ACSQP         DDACSQ
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    DDCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = DDCCY
     C                   EVAL      DBASE  = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ZDECS = A6NBDP
 
      ** Format Cleared Balance
 
     C                   EVAL      WKCLBL = CLBLN * (-1)
     C                   MOVE      WKCLBL        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDCLBL
 
      ** Format Total fo Held Items
 
     C                   MOVE      HELD          ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDHELD
 
      ** Format Blocked Collateral Amount
 
     C                   MOVE      BCOA          ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDBCOA
 
      ** Format Overdraft Line
 
     C                   IF        ODED >= BJRDNB and ODLN <> 0
     C                   EVAL      *IN26 = *ON
     C                   EVAL      WKODLN = ODLN                                              248653
     C                   DO        ZDECS                                                      248653
     C                   EVAL      WKODLN = WKODLN * 10                                       248653
     C                   ENDDO                                                                248653
     C**********         MOVE      ODLN          ZFLD15                                       248653
     C                   MOVE      WKODLN        ZFLD15                                       248653
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDODLN
     C                   ENDIF
 
      ** Format Available Balance
 
     C                   EVAL      WKAVBL = WKCLBL - HELD - BCOA
 
     C                   IF        *IN26 = *ON
     C**********         ADD       ODLN          WKAVBL                                       248653
     C                   ADD       WKODLN        WKAVBL                                       248653
     C                   ENDIF
 
     C                   MOVE      WKAVBL        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDTOTA
 
     C                   WRITE     GL002020F0
     C                   EXFMT     GL002020D0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZSEDIT - Edit Screen Field                                   *
      *                                                               *
      *****************************************************************
 
     C     ZSEDIT        BEGSR
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM = 'GL002020'
     C                   EVAL      SWSID = PSJobName
     C                   EVAL      SUSER = PSUser
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *DTAARA       DEFINE                  EMSDS
     C                   IN        EMSDS
 
     C     KACCT         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR - Program Exception Error Routine                          *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
