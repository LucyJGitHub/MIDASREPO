     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Remove orphan records left in HOR extension files')    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Head Office Reporting                                *
      *                                                               *
      ***HORDROP*-*Remove*orphan*records*left*in*HOR*extension*files***                       LUC109
      *  XX000060 - Remove orphan records left in HOR extension files *                       LUC109
      *                                                               *
      *  Function:  This program removes orphaned records in HOF      *
      *             extension files.                                  *
      *                                                               *
      *                                                               *
      ***(C)*Copyright*Midas-Kapiti*International*Ltd.*2002************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 21Sep16               *
      *  Prev Amend No. LUC013             Date 28May08               *
      *                 LONDON             Date 06Feb04               *
      *                 MUI009             Date 06Feb04               *
      *                 213609             Date 03Jan03               *
      *                 205749  *CREATE    Date 20May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  LUC013 - Increase account code to 10 long.                   *
      *  LONDON - Only for London branch - Purge Bank of England      *
      *           Customer Extension file.                            *
      *  MUI009 - R4.1 upgrade: add ACCNTBX0 and DEALSDX0.            *
      *  213609 - Printer overflow.                                   *
      *  205749 - Removal of orphaned records in HOR extension files  *
      *                                                               *
      *****************************************************************
      *
      * Amount accruals
     F***AMACCDX0  UF   E             DISK                                                    LUC109
     FAMACC     IF   E           K DISK
     F                                     IGNORE(AMACCAF)
     F*           AMACCDF                           KIGNORE
     F                                     IGNORE(AMACCZF)
      *
      * Facilities
     FFCLTYX0   UF   E             DISK
     FFCLTY     IF   E           K DISK
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYFNF)
     F*           FCLTYFMF                          KIGNORE
     F                                     IGNORE(FCLTYZZF)
      *
      * Customer Loans
     FCLOANCX0  UF   E             DISK
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F*           CLOANCLF                          KIGNORE
     F                                     IGNORE(CLOANZ1F)
      *
      * Deals
     FDEALSCX0  UF   E             DISK
     FDEALSC    IF   E           K DISK
      *                                                                   MUI009
      * Deals (NAP)                                                       MUI009
     FDEALSDX0  UF   E             DISK                                         MUI009
     FDLDLDDL1  IF   E           K DISK                                         MUI009
      *
      * DealsDB                                                                 LUC109
     FDEALSBX0  UF   E             DISK                                         LUC109
      * DealsDE                                                                 LUC109
     FDEALSEX0  UF   E             DISK                                         LUC109
      * DealsDG                                                                 LUC109
     FDEALSGX0  UF   E             DISK                                         LUC109
      *                                                                         LUC109
     FDEALS     IF   E           K DISK                                         LUC109
     F                                     IGNORE(DEALSDAF)                     LUC109
     F                                     IGNORE(DEALSDCF)                     LUC109
     F                                     IGNORE(DEALSDDF)                     LUC109
     F                                     IGNORE(DEALSDFF)                     LUC109
      *
      * Country codes
     FSDCTRYX0  UF   E             DISK
     FSDCTRYL0  IF   E           K DISK
      *
      * Customers
     FSDCUSTX0  UF   E             DISK
      * Bank of England customers                                         LONDON
     FBYCUSTX0  UF   E             DISK                                         LONDON
      * Midas customer file
     FSDCUSTL0  IF   E           K DISK
      *                                                                   MUI009
      * Accounts                                                          MUI009
     FACCNTBX0  UF   E             DISK                                         MUI009
     FACCNTL0   IF   E           K DISK                                         MUI009
      *
      * Report
     F***HORDROP1  O    E             PRINTER USROPN                                          LUC109
     FXX000060P1O    E             PRINTER USROPN                                             LUC109
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01  - Delete Mode                                           *
      *   03  - No Details to Report                                  *
      *   04  - End of Report                                         *
      *   89  - End of File                                           *
      *                                                               *
      *   98  - Used by Standard Subroutines                          *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *  PROCES - Read file and delete as necessary                   *
      *                                                               *
      *****************************************************************
     D/EJECT
      *
      ** Data structure for compilation  - copyright insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      ** Local data area for database error details
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** Bank details and rundate
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  RUND         E                     EXTFLD(BJMRDT)
     D  TITL         E                     EXTFLD(BJURPT)
      *
      ** Dummy data structure for access program AOSARDR0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     I***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     I/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      *                                                                   MUI009
      ** Rename fields to avoid conflict                                  MUI009
      *                                                                   MUI009
     IFCLTYFMF                                                                  MUI009
     I              CNUM                        FCCNUM                                        LUC109
     I              MCCY                        FCMCCY                          MUI009
      *
      /EJECT
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      **  Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Input Parameters: Mode
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
      ** Prepare LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C**********         MOVEL     'HORDROP '    DBPGM                                        LUC109
     C                   MOVEL     'XX000060'    DBPGM                                        LUC109
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Switch Mode Indicator.
      *
     C     MODE          IFEQ      'D'
     C     MODE          OREQ      'd'
     C                   MOVE      *ON           *IN01
     C                   ENDIF
      *
      ** Set up keys.
      *
     C     KEYFAC        KLIST
     C                   KFLD                    MCNUM
     C                   KFLD                    MFACT
     C                   KFLD                    MFCNO
      *                                                                   MUI009
     C     KEYACC        KLIST                                                                 MUI00
     C                   KFLD                    MCNUM                                         MUI00
     C                   KFLD                    MCCY                                          MUI00
     C                   KFLD                    MACOD                                         MUI00
     C                   KFLD                    MACSQ                                         MUI00
     C                   KFLD                    MBRCA                                         MUI00
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PROCES
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to read files and delete as necessary    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
      **  Loop through the files.
      *
     C********** 1         DO   6         FILEID  10                      MUI009
     C********** 1         DO   8         FILEID  10                MUI009LONDON
     C*****1             DO        9             FILEID            2 0            LONDO LUC109
     C     1             DO        12            FILEID            2 0                  LUC109
      *
      ** Report Work fields.
      *
     C                   Z-ADD     12            LNCNT             2 0
     C                   Z-ADD     0             TOTREC
      *
      ** Open report file.
      *
     C**********         OPEN      HORDROP1                                                   LUC109
     C                   OPEN      XX000060P1                                                 LUC109
      *
      ** Set up correct title details.
      *
     C                   SELECT
     C     FILEID        WHENEQ    1
     C**********         MOVE      'AMACCDX0'    FILENA                                       LUC109
     C     FILEID        WHENEQ    2
     C                   MOVE      'FCLTYX0 '    FILENA
     C     FILEID        WHENEQ    3
     C                   MOVE      'CLOANCX0'    FILENA
     C     FILEID        WHENEQ    4
     C                   MOVE      'DEALSCX0'    FILENA
     C     FILEID        WHENEQ    5
     C                   MOVE      'SDCTRYX0'    FILENA
     C     FILEID        WHENEQ    6
     C                   MOVE      'SDCUSTX0'    FILENA
     C     FILEID        WHENEQ    7                                                           MUI00
     C                   MOVE      'ACCNTBX0'    FILENA                                        MUI00
     C     FILEID        WHENEQ    8                                                           MUI00
     C                   MOVE      'DEALSDX0'    FILENA                                        MUI00
     C     FILEID        WHENEQ    9                                                           LONDO
     C                   MOVE      'BYCUSTX0'    FILENA                                        LONDO
     C     FILEID        WHENEQ    10                                                     LUC109
     C                   MOVE      'DEALSBX0'    FILENA                                   LUC109
     C     FILEID        WHENEQ    11                                                     LUC109
     C                   MOVE      'DEALSGX0'    FILENA                                   LUC109
     C     FILEID        WHENEQ    12                                                     LUC109
     C                   MOVE      'DEALSEX0'    FILENA                                   LUC109
     C                   ENDSL
      *
      ** Print header.
      *
     C                   WRITE     HEADER
      *
      **  Read first record from File.
      *
     C                   EXSR      RECREA
      *
      ** If no records on file, set on *IN03.
      *
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *IN03
     C                   ELSE
     C                   WRITE     SUBHDR
     C                   ENDIF
      *
      **  Do While Not End of File.
      *
     C     *IN99         DOWEQ     *OFF
      *
     C                   EXSR      RECCHN
      *
     C     *IN98         IFEQ      *ON
      *
      ** Check for overflow before writing details.
      *
     C     LNCNT         IFGT      56
     C                   WRITE     CONTN
     C                   WRITE     HEADER
     C                   WRITE     SUBHDR
     C                   Z-ADD     12            LNCNT
     C                   ENDIF
      *
     C                   EXSR      RECMOV
     C                   WRITE     DETAIL
     C                   ADD       1             TOTREC
     C                   ADD       1             LNCNT
     C                   MOVE      '0'           *IN93
      *
     C     *IN01         IFEQ      *ON
     C                   EXSR      RECDEL
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Read next record.
     C                   EXSR      RECREA
      *
     C                   ENDDO
      *
     C********** LNCNT     IFGT 56                                        213609
     C     LNCNT         IFGT      55                                                          21360
     C                   WRITE     HEADER
     C                   Z-ADD     12            LNCNT
     C                   ENDIF
      *
     C                   MOVE      '1'           *IN04
     C                   WRITE     TRAILER
      *
     C**********         CLOSE     HORDROP1                                                   LUC109
     C                   CLOSE     XX000060P1                                                 LUC109
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RECREA - Read record                                         *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     RECREA        BEGSR
      *
     C                   SELECT
      *
     C     FILEID        WHENEQ    1
     C**********         READ      AMACCDX0                               99                  LUC109
     C                   MOVE      *ON           *IN99                                        LUC109
      *
     C     FILEID        WHENEQ    2
     C                   READ      FCLTYX0                                99
      *
     C     FILEID        WHENEQ    3
     C                   READ      CLOANCX0                               99
      *
     C     FILEID        WHENEQ    4
     C                   READ      DEALSCX0                               99
      *
     C     FILEID        WHENEQ    5
     C                   READ      SDCTRYX0                               99
      *
     C     FILEID        WHENEQ    6
     C                   READ      SDCUSTX0                               99
      *                                                                   MUI009
     C     FILEID        WHENEQ    7                                                           MUI00
     C                   READ      ACCNTBX0                               99                   MUI00
      *                                                                   MUI009
     C     FILEID        WHENEQ    8                                                           MUI00
     C                   READ      DEALSDX0                               99                   MUI00
      *                                                                   LONDON
     C     FILEID        WHENEQ    9                                                           LONDO
     C                   READ      BYCUSTX0                               99                   LONDO
      *                                                                             LUC109
     C     FILEID        WHENEQ    10                                               LUC109
     C                   READ      DEALSBX0                               99        LUC109
      *                                                                             LUC109
     C     FILEID        WHENEQ    11                                               LUC109
     C                   READ      DEALSGX0                               99        LUC109
      *                                                                             LUC109
     C     FILEID        WHENEQ    12                                               LUC109
     C                   READ      DEALSEX0                               99        LUC109
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RECCHN - Chain record                                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     RECCHN        BEGSR
      *
     C                   SELECT
      *
     C     FILEID        WHENEQ    1
     C*****MAREF         CHAIN     AMACCDF                            98                      LUC109
      *
     C     FILEID        WHENEQ    2
     C     KEYFAC        CHAIN     FCLTYFMF                           98
      *
     C     FILEID        WHENEQ    3
     C     MLNRF         CHAIN     CLOANCLF                           98
      *
     C     FILEID        WHENEQ    4
     C     MDLNO         CHAIN     DEALSDCF                           98
      *
     C     FILEID        WHENEQ    5
     C     MCNCD         CHAIN     @A4REBS                            98
      *
     C     FILEID        WHENEQ    6
     C     MCUST         CHAIN     @BBREBG                            98
      *                                                                   MUI009
     C     FILEID        WHENEQ    7                                                           MUI00
     C     KEYACC        CHAIN     ACCNTABF                           98                       MUI00
      *                                                                   MUI009
     C     FILEID        WHENEQ    8                                                           MUI00
     C     MDLNO         CHAIN     DEALSDDF                           98                       MUI00
      *                                                                   LONDON
     C     FILEID        WHENEQ    9                                                           LONDO
     C     LCUST         CHAIN     @BBREBG                            98                       LONDO
      *                                                                             LUC109
     C     FILEID        WHENEQ    10                                               LUC109
     C     MDLNO         CHAIN     DEALSDBF                           98            LUC109
      *                                                                             LUC109
     C     FILEID        WHENEQ    11                                               LUC109
     C     MDLNO         CHAIN     DEALSDGF                           98            LUC109
      *                                                                             LUC109
     C     FILEID        WHENEQ    12                                               LUC109
     C     MDLNO         CHAIN     DEALSDEF                           98            LUC109
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RECDEL - Delete record                                       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     RECDEL        BEGSR
      *
     C                   SELECT
      *
     C     FILEID        WHENEQ    1
     C**********         DELETE    AMACCDX0                                                   LUC109
      *
     C     FILEID        WHENEQ    2
     C                   DELETE    FCLTYX0
      *
     C     FILEID        WHENEQ    3
     C                   DELETE    CLOANCX0
      *
     C     FILEID        WHENEQ    4
     C                   DELETE    DEALSCX0
      *
     C     FILEID        WHENEQ    5
     C                   DELETE    SDCTRYX0
      *
     C     FILEID        WHENEQ    6
     C                   DELETE    SDCUSTX0
      *                                                                   MUI009
     C     FILEID        WHENEQ    7                                                           MUI00
     C                   DELETE    ACCNTBX0                                                    MUI00
      *                                                                   MUI009
     C     FILEID        WHENEQ    8                                                           MUI00
     C                   DELETE    DEALSDX0                                                    MUI00
      *                                                                   LONDON
     C     FILEID        WHENEQ    9                                                           LONDO
     C                   DELETE    BYCUSTX0                                                    LONDO
      *                                                                             LUC109
     C     FILEID        WHENEQ    10                                               LUC109
     C                   DELETE    DEALSBX0                                         LUC109
      *                                                                             LUC109
     C     FILEID        WHENEQ    11                                               LUC109
     C                   DELETE    DEALSGX0                                         LUC109
      *                                                                             LUC109
     C     FILEID        WHENEQ    12                                               LUC109
     C                   DELETE    DEALSEX0                                         LUC109
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RECMOV - Copy significant details of the extension record    *
      *           to the report fields                                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     RECMOV        BEGSR
      *
     C                   SELECT
      *
     C     FILEID        WHENEQ    1
     C**********         MOVEL     MAREF         WTMP09            9                          LUC109
     C**********         MOVE      ' - '         WTMP09                                       LUC109
     C**********         MOVE      MASOC         WTMP06            6                          LUC109
     C*****WTMP09        CAT       WTMP06        WTMP15           15                          LUC109
     C**********         MOVEL(P)  WTMP15        LINE                                         LUC109
      *
     C     FILEID        WHENEQ    2
     C**********         MOVEL     MCNUM         WTMP09                                       LUC109
     C                   MOVEL     MCNUM         WTMP09            9                          LUC109
     C                   MOVE      ' - '         WTMP09
     C                   MOVE      MFACT         WTMP03            3
     C     WTMP09        CAT       WTMP03        WTMP12           12
     C*****WTMP12        CAT       ' - '         WTMP15                                       LUC109
     C     WTMP12        CAT       ' - '         WTMP15           15                          LUC109
     C                   MOVE      MFCNO         WTMP02            2
     C     WTMP15        CAT       WTMP02        WTMP17           17
     C                   MOVEL(P)  WTMP17        LINE
      *
     C     FILEID        WHENEQ    3
     C                   MOVEL(P)  MLNRF         LINE
      *
     C     FILEID        WHENEQ    4
     C     FILEID        OREQ      8                                                           MUI00
     C     FILEID        OREQ      10                                                         LUC109
     C     FILEID        OREQ      11                                                         LUC109
     C     FILEID        OREQ      12                                                         LUC109
     C                   MOVEL(P)  MDLNO         LINE
      *
     C     FILEID        WHENEQ    5
     C                   MOVEL(P)  MCNCD         LINE
      *
     C     FILEID        WHENEQ    6
     C                   MOVEL(P)  MCUST         LINE
      *                                                                   MUI009
     C     FILEID        WHENEQ    7                                                           MUI00
     C                   MOVEL(P)  MCNUM         LINE                                          MUI00
     C                   CAT       '-':1         LINE                                          MUI00
     C                   CAT       MCCY:1        LINE                                          MUI00
     C                   CAT       '-':1         LINE                                          MUI00
     C****                 MOVE MACOD     WTMP04  4                       MUI009
     C                   MOVE      MACOD         WTMP10           10
     C****                 CAT  WTMP04:1  LINE                            MUI009
     C                   CAT       WTMP10:1      LINE
     C                   CAT       '-':1         LINE                                          MUI00
     C                   MOVE      MACSQ         WTMP02                                        MUI00
     C                   CAT       WTMP02:1      LINE                                          MUI00
     C                   CAT       '-':1         LINE                                          MUI00
     C                   CAT       MBRCA:1       LINE                                          MUI00
      *                                                                   LONDON
     C     FILEID        WHENEQ    9                                                           LONDO
     C                   MOVEL(P)  LCUST         LINE                                          LONDO
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C***/C*PY*ZSRSRC,ZDATE2Z4                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z4LE                                                                 LUC109
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
