     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('G-AML Activity Extract Program')                       *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      ***SCJ00007*-*G-AML*Activity*Extract*Program*********************
      *  XX109008 - G-AML Activity Extract Program                    *
      *                                                               *
      *  Function:  This program extracts activity details and        *
      *            generates a report for those records not extracted *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109CC1          Date 20Feb20               *
      *  Prev Amend No. JMI109             Date 23May18               *
      *                 262960             Date 27Nov09               *
      *                 JMI026I02          Date 15Oct08               *
      *                 JMI026             Date 29Sep08               *
      *                 JMI026  *CREATE    Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109CC1 - Consider Account Transfer Transactions           *
      *  JMI109 - G-AML PreProcessor (Upgrade to FB Midas)            *
      *  262960 - JMI026 problem - Extract for G-AML processing       *
      *           is incorrect. Formalised fix. Correct the parameter *
      *           passed in AOACUSR0.                                 *
      *  JMI026I02 - Amended program to correctly extract the CashTran*
      *           field and to remove the ~ on the last field         *
      *  JMI026 - Amended program to extract the reference for        *
      *           journal entries with the batch ID, to correctly     *
      *           extract the addresses,by ordering account.  Also,   *
      *           amended program so that it will extract customer    *
      *           exchanges (GETP = 'E' instead of 'A').              *
      *  JMI026 - G-AML PreProcessor                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas GL COB postings detail LF
     F*EODPOPY0  IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     FXXEODPL0  IF   E           K DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Midas GL Account Postings Detail LF
     F*APOSTY0   IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     FXXPOSTL0  IF   E           K DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Midas GL Account Postings Detail LF
     F*APOSTY1   IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     FXXPOSTL1  IF   E           K DISK    INFSR(*PSSR)                                       JMI109
     F                                     IGNORE(@@POSY0)
      *
      ** Midas SD G-AML PF
     F*SDGAMLX0  IF   E             DISK    INFSR(*PSSR)                                      JMI109
     FXXGAMLPD  IF   E             DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Midas SD Activity Type LF
     F*SDATYPY0  IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     FXXATYPL0  IF   E           K DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Midas FT Inc. Payments
     FINPAY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas FT Out. Payments
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas FT Cheques to be Paid
     FCQPAC     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas FT Cheques For Collection
     FCQCOD     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD G-AML Activity Details Extract
     F*REACEFPP  O    E             DISK    INFSR(*PSSR)                                      JMI109
     FXXACEFPD  O    E             DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Midas SD G-AML Activity Details Formatted Extract
     F*REACFFPP  O    E             DISK    INFSR(*PSSR)                                      JMI109
     FXXACFFPD  O    E             DISK    INFSR(*PSSR)                                       JMI109
      *
      ** G-AML Activity Details Not Extracted Audit Report
     F*SCJ00007P1O    E             PRINTER INFDS(SPOOL1)                                     JMI109
     FXX109008P1O    E             PRINTER INFDS(SPOOL1)                                      JMI109
     F                                     USROPN
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN21)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Historic Exchange rates record format data structure
     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Externally described DS for Bank code Details
     D SDBNCD        E DS                  EXTNAME(SDBNCDPD)
      *
      ** Externally described DS for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      ** DS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Midas GP Used by access pgms,dummy data                                              262960
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     262960
      *                                                                                       262960
      ***File*Information*Data*Structure*for*SCJ00007P1                                       JMI109
      ** File Information Data Structure for XX109008P1                                       JMI109
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      *
      ** Power Array
     D POWERA          S              7  0 DIM(7) CTDATA PERRCD(1)
      *
      ** CashTran Array                                                                    JMI026I02
     D CASHTRAN        S              4    DIM(16) CTDATA PERRCD(8)                        JMI026I02
      *                                                                                    JMI026I02
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Parameters for ZALIGN
     D PzAlignOk       S              1A
     D PzADig          S              2P 0
     D PzADec          S              1P 0
     D PzField         S             16A
      *
      ** Parameters for ZA0920
     D P9Rtcd          S             10
     D P9AmtNum        S             13  0
     D P9NumDec        S              1  0
     D P9Sepa          S              1
     D P9AmtChr        S             14
      *
     D WDATA           DS           100
     D  WRERUN                 1      1
     D  WFDATE                 2      6
      *
     D W0FT            DS           128
      ** Currency
     D  W0CCY                  1      3
      ** Settlement Type
     D  W0STMT                 4      5
      ** Mandatory Text - convert BIC identifiers
     D  W0MTXT                 6      6
      ** Message Tag
     D  W0MTAG                 7     11
      ** Construct of data in field
     D  W0TYPE                12     12
      ** Number of Lines available
     D  W0NLIN                13     14  0
      ** Network and Message Type
     D  W0NWRK                15     20
     D  W0MTPY                21     23
      ** Calling Program
     D  W0CPGM                24     33
      ** Action *PRINT/*ENQ/*MSG GEN
     D  W0ACT                 34     41
      ** Critical Reporting - Database error if 'Y'.
      ** If no BIC directory and BIC entered, no error.
     D  W0CRIT                42     42
      ** Force Midas Address - where possible
     D  W0MADD                43     43
      ** If Retail, get first address from account
     D  W0RTAD                44     44
      ** Alternative Address
     D  W0ALTN                45     45
      ** Address Type
     D  W0ADTP                46     46
      *
      ** Redefining address fields data structure
     D                 DS
     D WADDRSS                 1    175
     D WADCHK1                 1     35
     D WADCHK2                36     70
     D WADCHK3                71    105
     D WADCHK4               106    140
     D WADCHK5               141    175
      *
      ** Working Variables
     D WEXT            S              1    INZ(' ')
     D WRun            S              1    INZ(' ')
     D WFirst          S              1    INZ('Y')
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
     D BankDec#        S              1  0
     D I               S              3  0 Inz(0)                                          JMI026I02
     D PosPNAR         S              5U 0                                                 JMI026I02
     D #CASH           S              4    Inz(' ')                                        JMI026I02
      *
      **
     D VarTmp          S           5000    Varying
     D Ctr             S              6  0 Inz(1)
     D CCtr            S              6
     D WEnd            S              1    Inz('N')
     D #M              S              1  0 Inz(0)
     D InAmt           S             20  4 Inz(0)
     D BaseAmt         S             20P 4 Inz(0)
     D #FxAmt          S             14
     D #BsAmt          S             14
     D #ValueDate      S              8
     D #PostDate       S              8
     D WBNCD           S              1
     D WCUST           S              1
     D WBRCH           S              3
     D #RCPY           S              1
     D DateIn          S              5P 0
     D DateOut         S              8S 0
     D*PosPNAR1*       S              5U 0                                                 JMI026I02
     D*PosPNAR2*       S              5U 0                                                 JMI026I02
     D*PosPNAR3*       S              5U 0                                                 JMI026I02
     D WFLAG           S              1
     D #Batch          S              3
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation                   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   EXSR      SRINIT
      *
      ***Read*main*file*EODPOPY0*or*APOSTY0                                                   JMI109
      ** Read main file XXEODPL0 or XXPOSTL0                                                  JMI109
      **  Set-up keys for customer exchange records first
     C                   EVAL      WGETP = 'E'
     C                   EVAL      WTTP  = ' '
     C                   EVAL      WTST  = ' '
     C*****              EVAL      WCNUM = 0                                                  JMI109
     C                   EVAL      WCNUM = '      '                                           JMI109
      ** Set module type
     C                   EVAL      WMOD = 'CE'
      *
     C*****              OPEN      SCJ00007P1                                                 JMI109
     C                   OPEN      XX109008P1                                                 JMI109
      *
     C                   IF        WDATE = 0
     C*****EODKY         SETLL     EODPOPY0                                                   JMI109
     C*****              READ      EODPOPY0                               80                  JMI109
     C     EODKY         SETLL     XXEODPL0                                                   JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C     APOSTKY       SETLL     @POSTY1
     C                   READ      @POSTY1                                80
     C                   ELSE
     C     APOSTKY       SETLL     @POSTY0
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
      *
      ** Read while not end of file and GETP = 'E'
     C                   DOW       *IN80 = *OFF
     C                              and PSTD = WDATE and WDATE <> 0
     C                             or *IN80 = *OFF and WDATE = 0
      ** Check if GETP changed
     C                   IF        WGETP <> GETP
     C                   LEAVE
     C                   ENDIF
      ** Check if record read is to be extracted
     C                   EXSR      EXTYN
      *
     C                   IF        WEXT = 'N'
      ***Write*detail*for*SCJ00007P1*(not*to*be*extracted)                                    JMI109
      ** Write detail for XX109008P1 (not to be extracted)                                    JMI109
     C                   EXSR      SRPRNT
     C                   ELSE
     C                   EXSR      EXTRACT
     C                   ENDIF
      *
     C                   IF        WDATE = 0
     C*****              READ      EODPOPY0                               80                  JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C                   READ      @POSTY1                                80
     C                   ELSE
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      **  Set-up keys for Funds Transfer records
     C                   EVAL      WGETP = 'G'
     C                   EVAL      WTTP  = ' '
     C                   EVAL      WTST  = ' '
     C*****              EVAL      WCNUM = 0                                                  JMI109
     C                   EVAL      WCNUM = '      '                                           JMI109
      ** Set module type
     C                   EVAL      WMOD = 'FT'
      *
     C                   IF        WDATE = 0
     C*****EODKY         SETLL     EODPOPY0                                                   JMI109
     C*****              READ      EODPOPY0                               80                  JMI109
     C     EODKY         SETLL     XXEODPL0                                                   JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C     APOSTKY       SETLL     @POSTY1
     C                   READ      @POSTY1                                80
     C                   ELSE
     C     APOSTKY       SETLL     @POSTY0
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
      *
      ** Read while not end of file and GETP = 'G'
     C                   DOW       *IN80 = *OFF
     C                              and PSTD = WDATE and WDATE <> 0
     C                             or *IN80 = *OFF and WDATE = 0
      ** Check if GETP changed
     C                   IF        WGETP <> GETP
     C                   LEAVE
     C                   ENDIF
      *
      ** Check if record read is to be extracted
     C                   EXSR      EXTYN
      *
     C                   IF        WEXT = 'N'
      ***Write*detail*for*SCJ00007P1*(not*to*be*extracted)                                    JMI109
      ** Write detail for XX109008P1 (not to be extracted)                                    JMI109
     C                   EXSR      SRPRNT
     C                   ELSE
     C                   EXSR      EXTRACT
     C                   ENDIF
      *
     C                   IF        WDATE = 0
     C*****              READ      EODPOPY0                               80                  JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C                   READ      @POSTY1                                80
     C                   ELSE
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      **  Set-up keys for Journal Entry records
     C                   EVAL      WGETP = ' '
     C                   EVAL      WTTP  = ' '
     C                   EVAL      WTST  = ' '
     C*****              EVAL      WCNUM = 0                                                  JMI109
     C                   EVAL      WCNUM = '      '                                           JMI109
      ** Set module type
     C                   EVAL      WMOD = 'GL'
      *
     C                   IF        WDATE = 0
     C*****EODKY         SETLL     EODPOPY0                                                   JMI109
     C*****              READ      EODPOPY0                               80                  JMI109
     C     EODKY         SETLL     XXEODPL0                                                   JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C     APOSTKY       SETLL     @POSTY1
     C                   READ      @POSTY1                                80
     C                   ELSE
     C     APOSTKY       SETLL     @POSTY0
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
      *
      ** Read while not end of file and GETP = ' '
     C                   DOW       *IN80 = *OFF
     C                              and PSTD = WDATE and WDATE <> 0
     C                             or *IN80 = *OFF and WDATE = 0
      ** Check if GETP changed
     C                   IF        WGETP <> GETP
     C                   LEAVE
     C                   ENDIF
      *
      ** Check if record read is to be extracted
     C                   EXSR      EXTYN
      *
     C                   IF        WEXT = 'N'
      ***Write*detail*for*SCJ00007P1*(not*to*be*extracted)                                    JMI109
      ** Write detail for XX109008P1 (not to be extracted)                                    JMI109
     C                   EXSR      SRPRNT
     C                   ELSE
     C                   EXSR      EXTRACT
     C                   ENDIF
      *
     C                   IF        WDATE = 0
     C*****              READ      EODPOPY0                               80                  JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C                   READ      @POSTY1                                80
     C                   ELSE
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      **  Set-up keys for Teller Transaction records
     C                   EVAL      WGETP = 'N'
     C                   EVAL      WTTP  = ' '
     C                   EVAL      WTST  = ' '
     C*****              EVAL      WCNUM = 0                                                  JMI109
     C                   EVAL      WCNUM = '      '                                           JMI109
      ** Set module type
     C                   EVAL      WMOD = 'TT'
      *
     C                   IF        WDATE = 0
     C*****EODKY         SETLL     EODPOPY0                                                   JMI109
     C*****              READ      EODPOPY0                               80                  JMI109
     C     EODKY         SETLL     XXEODPL0                                                   JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C     APOSTKY       SETLL     @POSTY1
     C                   READ      @POSTY1                                80
     C                   ELSE
     C     APOSTKY       SETLL     @POSTY0
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
      *
      ** Read while not end of file and GETP = 'N'
     C                   DOW       *IN80 = *OFF
     C                              and PSTD = WDATE and WDATE <> 0
     C                             or *IN80 = *OFF and WDATE = 0
      ** Check if GETP changed
     C                   IF        WGETP <> GETP
     C                   LEAVE
     C                   ENDIF
      *
      ** Check if record read is to be extracted
     C                   EXSR      EXTYN
      *
     C                   IF        WEXT = 'N'
      ***Write*detail*for*SCJ00007P1*(not*to*be*extracted)                                    JMI109
      ** Write detail for XX109008P1 (not to be extracted)                                    JMI109
     C                   EXSR      SRPRNT
     C                   ELSE
     C                   EXSR      EXTRACT
     C                   ENDIF
      *
     C                   IF        WDATE = 0
     C*****              READ      EODPOPY0                               80                  JMI109
     C                   READ      XXEODPL0                               80                  JMI109
     C                   ELSE
     C                   IF        WFLAG = 'Y'
     C                   READ      @POSTY1                                80
     C                   ELSE
     C                   READ      @POSTY0                                80
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      **  Set-up keys for Account Transfer Transaction records                             JMI109CC1
     C                   EVAL      WGETP = 'L'                                             JMI109CC1
     C                   EVAL      WTTP  = ' '                                             JMI109CC1
     C                   EVAL      WTST  = ' '                                             JMI109CC1
     C                   EVAL      WCNUM = '      '                                        JMI109CC1
      ** Set module type                                                                   JMI109CC1
     C                   EVAL      WMOD = 'AT'                                             JMI109CC1
      *                                                                                    JMI109CC1
     C                   IF        WDATE = 0                                               JMI109CC1
     C     EODKY         SETLL     XXEODPL0                                                JMI109CC1
     C                   READ      XXEODPL0                               80               JMI109CC1
     C                   ELSE                                                              JMI109CC1
     C                   IF        WFLAG = 'Y'                                             JMI109CC1
     C     APOSTKY       SETLL     @POSTY1                                                 JMI109CC1
     C                   READ      @POSTY1                                80               JMI109CC1
     C                   ELSE                                                              JMI109CC1
     C     APOSTKY       SETLL     @POSTY0                                                 JMI109CC1
     C                   READ      @POSTY0                                80               JMI109CC1
     C                   ENDIF                                                             JMI109CC1
     C                   ENDIF                                                             JMI109CC1
      *                                                                                    JMI109CC1
      ** Read while not end of file and GETP = 'L'                                         JMI109CC1
     C                   DOW       *IN80 = *OFF                                            JMI109CC1
     C                              and PSTD = WDATE and WDATE <> 0                        JMI109CC1
     C                             or *IN80 = *OFF and WDATE = 0                           JMI109CC1
      ** Check if GETP changed                                                             JMI109CC1
     C                   IF        WGETP <> GETP                                           JMI109CC1
     C                   LEAVE                                                             JMI109CC1
     C                   ENDIF                                                             JMI109CC1
      *                                                                                    JMI109CC1
      ** Check if record read is to be extracted                                           JMI109CC1
     C                   EXSR      EXTYN                                                   JMI109CC1
      *                                                                                    JMI109CC1
     C                   IF        WEXT = 'N'                                              JMI109CC1
      ** Write detail for XX109008P1 (not to be extracted)                                 JMI109CC1
     C                   EXSR      SRPRNT                                                  JMI109CC1
     C                   ELSE                                                              JMI109CC1
     C                   EXSR      EXTRACT                                                 JMI109CC1
     C                   ENDIF                                                             JMI109CC1
      *                                                                                    JMI109CC1
     C                   IF        WDATE = 0                                               JMI109CC1
     C                   READ      XXEODPL0                               80               JMI109CC1
     C                   ELSE                                                              JMI109CC1
     C                   IF        WFLAG = 'Y'                                             JMI109CC1
     C                   READ      @POSTY1                                80               JMI109CC1
     C                   ELSE                                                              JMI109CC1
     C                   READ      @POSTY0                                80               JMI109CC1
     C                   ENDIF                                                             JMI109CC1
     C                   ENDIF                                                             JMI109CC1
     C                   ENDDO                                                             JMI109CC1
      *                                                                                    JMI109CC1
      ** Write Total Extracted at end of file
     C                   EVAL      WEnd = 'Y'
     C                   EXSR      SRPRNT
     C*****              CLOSE     SCJ00007P1                                                 JMI109
     C                   CLOSE     XX109008P1                                                 JMI109
      *
      ** Program End
     C                   EXSR      SREnd
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXTRACT - Extract G-AML Activity Details                     *
      *                                                               *
      *****************************************************************
     C     EXTRACT       BEGSR
      *
      ** Initialise flatfile field
     C                   EVAL      GFLDS = ' '
      ***Initialise*REACEFPP*fields                                                           JMI109
      ** Initialise XXACEFPD fields                                                           JMI109
     C                   EVAL      GTYPE = 0
     C                   EVAL      GCNUM = ' '
     C                   EVAL      GACNO = ' '
     C                   EVAL      GCASH = ' '
     C                   EVAL      GBAMT = 0
     C                   EVAL      GRCPY = 0
     C                   EVAL      GCURR = ' '
     C                   EVAL      GFXAM = 0
     C                   EVAL      GREF  = ' '
     C                   EVAL      GVDAT = ' '
     C                   EVAL      GBDAT = ' '
      * CUSTOMER ID
     C                   MOVEL     CNUM          GCNUM
     C                   MOVEL     CNUM          #CNUM             6
     C                   EVAL      VarTmp = %Trim(#CNUM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * ACCOUNT
     C                   MOVEL     ACNO          GACNO
     C                   MOVEL     ACNO          #ACNO            10
     C                   EVAL      VarTmp = %Trim(#ACNO)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * TYPE
     C                   EVAL      GTYPE = GASEQ
     C                   EVAL      VarTmp = %Trim(GATYP)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * CASH TRAN
     C**********         EVAL      PosPNAR1 = %scan('CASH':PNAR:1)                         JMI026I02
     C**********         EVAL      PosPNAR2 = %scan('Cash':PNAR:1)                         JMI026I02
     C**********         EVAL      PosPNAR3 = %scan('cash':PNAR:1)                         JMI026I02
     C                   EVAL      I = 1                                                   JMI026I02
     C                   EVAL      PosPNAR = 0                                             JMI026I02
     C                   DOW       I < 17                                                  JMI026I02
     C                   EVAL      #CASH = CASHTRAN(I)                                     JMI026I02
     C                   EVAL      PosPNAR = %scan(#CASH:PNAR:1)                           JMI026I02
     C                   IF        PosPNAR > 0                                             JMI026I02
     C                   LEAVE                                                             JMI026I02
     C                   ELSE                                                              JMI026I02
     C                   EVAL      I = I + 1                                               JMI026I02
     C                   ENDIF                                                             JMI026I02
     C                   ENDDO                                                             JMI026I02
      *                                                                                    JMI026I02
      ** For Teller Transaction, check if Posting Narrative has 'CASH' on it
      ** regardless of case
     C                   IF        WMOD = 'TT'
     C**********         IF        PosPNAR1 > 0 or PosPNAR2 > 0                            JMI026I02
     C**********                    or PosPNAR3 > 0                                        JMI026I02
     C                   IF        PosPNAR > 0                                             JMI026I02
     C                   EVAL      GCASH = '1'
     C                   ELSE
     C                   EVAL      GCASH = '0'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      GCASH = '0'
     C                   ENDIF
     C                   EVAL      VarTmp = %Trim(GCASH)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * BASE AMOUNT
      ** Retrieve number of decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      CCY           PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = CCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      #M = A6NBDP + 1
     C                   EVAL(H)   InAmt = PSTA / POWERA(#M)
     C                   IF        WDATE = 0
     C                   IF        A6MDIN = 'M'
     C                   EVAL      BaseAmt = InAmt * A6SPRT
     C                   ELSE
     C                   EVAL      BaseAmt = InAmt / A6SPRT
     C                   ENDIF
     C                   EVAL      P9AmtNum = BaseAmt
     C                   EVAL      P9NumDec = BankDec#
      ** Format Posting Amount
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        P9Rtcd
     C                   PARM                    P9AmtNum
     C                   PARM                    P9NumDec
     C                   PARM      '.'           P9Sepa
     C                   PARM      *BLANK        P9AmtChr
      ** Error calling module
     C                   IF        P9Rtcd <> ' '
     C                   EVAL      DBFile = 'ZA0920  '
     C                   EVAL      DBase = 004
     C                   EVAL      DBKey = '*CALL   '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      #BsAmt = P9AmtChr
     C                   EVAL      VarTmp = %Trim(#BsAmt)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
     C                   SELECT
     C                   WHEN      BankDec# = 0
     C                   MOVE      BaseAmt       #BsAmt0          18 0
     C                   Z-ADD     #BsAmt0       GBAMT
     C                   WHEN      BankDec# = 1
     C                   MOVE      BaseAmt       #BsAmt1          18 1
     C                   Z-ADD     #BsAmt1       GBAMT
     C                   WHEN      BankDec# = 2
     C                   MOVE      BaseAmt       #BsAmt2          18 2
     C                   Z-ADD     #BsAmt2       GBAMT
     C                   WHEN      BankDec# = 3
     C                   MOVE      BaseAmt       #BsAmt3          18 3
     C                   Z-ADD     #BsAmt3       GBAMT
     C                   ENDSL
      *
     C                   ELSE
      ** Access History Exchange Rates
     C                   CALL      'AOCUHSR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WDATE         PDATE             5 0
     C                   PARM      CCY           PCCY
     C     SDCUHS        PARM      SDCUHS        DSSDY
      *
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = CCY
     C                   EVAL      DBFile = 'SDCUHSPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        G2MDIN = 'M'
     C                   EVAL      BaseAmt = InAmt * G2SPRT
     C                   ELSE
     C                   EVAL      BaseAmt = InAmt / G2SPRT
     C                   ENDIF
     C                   EVAL      P9AmtNum = BaseAmt
     C                   EVAL      P9NumDec = BankDec#
      ** Format Posting Amount
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        P9Rtcd
     C                   PARM                    P9AmtNum
     C                   PARM                    P9NumDec
     C                   PARM      '.'           P9Sepa
     C                   PARM      *BLANK        P9AmtChr
      ** Error calling module
     C                   IF        P9Rtcd <> ' '
     C                   EVAL      DBFile = 'ZA0920  '
     C                   EVAL      DBase = 004
     C                   EVAL      DBKey = '*CALL   '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      #BsAmt = P9AmtChr
     C                   EVAL      VarTmp = %Trim(#BsAmt)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
     C                   SELECT
     C                   WHEN      BankDec# = 0
     C                   MOVE      BaseAmt       #BsAmt0          18 0
     C                   Z-ADD     #BsAmt0       GBAMT
     C                   WHEN      BankDec# = 1
     C                   MOVE      BaseAmt       #BsAmt1          18 1
     C                   Z-ADD     #BsAmt1       GBAMT
     C                   WHEN      BankDec# = 2
     C                   MOVE      BaseAmt       #BsAmt2          18 2
     C                   Z-ADD     #BsAmt2       GBAMT
     C                   WHEN      BankDec# = 3
     C                   MOVE      BaseAmt       #BsAmt3          18 3
     C                   Z-ADD     #BsAmt3       GBAMT
     C                   ENDSL
      *
     C                   ENDIF
      *
      * RECEIVE/PAY
     C                   IF        DRCR = 0
     C                   EVAL      GRCPY = 2
     C                   EVAL      #RCPY = '2'
     C                   ELSE
     C                   EVAL      GRCPY = 1
     C                   EVAL      #RCPY = '1'
     C                   ENDIF
     C                   EVAL      VarTmp = %Trim(#RCPY)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * CURRENCY
     C                   EVAL      GCURR = CCY
     C                   EVAL      VarTmp = %Trim(CCY)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * FIX AMOUNT
     C                   EVAL      P9AmtNum = PSTA
     C                   EVAL      P9NumDec = A6NBDP
      ** Format Posting Amount
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        P9Rtcd
     C                   PARM                    P9AmtNum
     C                   PARM                    P9NumDec
     C                   PARM      '.'           P9Sepa
     C                   PARM      *BLANK        P9AmtChr
      ** Error calling module
     C                   IF        P9Rtcd <> ' '
     C                   EVAL      DBFile = 'ZA0920  '
     C                   EVAL      DBase = 004
     C                   EVAL      DBKey = '*CALL   '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      #FxAmt = P9AmtChr
     C                   EVAL      VarTmp = %Trim(#FxAmt)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   MOVE      PSTA          #FxAmt0          18 0
     C                   Z-ADD     #FxAmt0       GFXAM
     C                   WHEN      A6NBDP = 1
     C                   MOVE      PSTA          #FxAmt1          18 1
     C                   Z-ADD     #FxAmt1       GFXAM
     C                   WHEN      A6NBDP = 2
     C                   MOVE      PSTA          #FxAmt2          18 2
     C                   Z-ADD     #FxAmt2       GFXAM
     C                   WHEN      A6NBDP = 3
     C                   MOVE      PSTA          #FxAmt3          18 3
     C                   Z-ADD     #FxAmt3       GFXAM
     C                   ENDSL
      *
      * REFERENCE
     C                   MOVEL     OTRF          #OTRF            15
     C                   IF        WMOD = 'GL'                                                JMI026
     C                   EVAL      #Batch = %subst(SPOS:1:3)                                  JMI026
     C                   EVAL      GREF = #Batch                                              JMI026
     C                   EVAL      VarTmp = %Trim(#Batch)                                     JMI026
     C                   ELSE                                                                 JMI026
     C                   EVAL      GREF = OTRF
     C                   EVAL      VarTmp = %Trim(OTRF)
     C                   ENDIF                                                                JMI026
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * VALUE DATE IN YYYYMMDD
     C                   IF        VALD <> 0
     C                   Z-ADD     VALD          DateIn
     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   PARM                    @Rtn
      *
     C                   MOVEL     DateOut       GVDAT
     C                   MOVEL     DateOut       #ValueDate
     C                   EVAL      VarTmp = %Trim(#ValueDate)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   Eval      GVDAT = '00000000'
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BOOK DATE IN YYYYMMDD (POSTING DATE)
     C                   IF        PSTD <> 0
     C                   Z-ADD     PSTD          DateIn
     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   PARM                    @Rtn
      *
     C                   MOVEL     DateOut       GBDAT
     C                   MOVEL     DateOut       #PostDate
     C                   EVAL      VarTmp = %Trim(#PostDate)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   Eval      GBDAT = '00000000'
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BENEFICIARY CUSTOMER ID
     C                   SELECT
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Beneficiary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     ** Pay reference not found in OTPAYDD, assign blanks.
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Beneficiary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Pay reference not found in INPAYDD, assign blanks.
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For TT, CE, and GL module
     C                   WHEN      WMOD = 'TT' or WMOD = 'CE' or WMOD = 'GL'
     C                             OR WMOD = 'AT'                                         JMI109CC1
     C                   IF        DRCR = 1
     C                   MOVE      *BLANKS       #CNUM
     C                   MOVEL     CNUM          #CNUM
     C                   EVAL      VarTmp = %Trim(#CNUM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For others , assign blanks
     C                   OTHER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BENEFICIARY
     C                   SELECT
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Beneficiary from is not a customer#
     C                   EVAL      VarTmp = %Trim(BNC2)+ %Trim(BNC1)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** Pay reference not found in OTPAYDD, assign blanks
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Beneficiary from is not a customer#
     C                   EVAL      VarTmp = %Trim(BNC2)+ %Trim(BNC1)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** Pay reference not found in INPAYDD, assign blanks
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For CE, TT, and GL
     C                   WHEN      WMOD = 'CE' or WMOD = 'TT' or WMOD = 'GL'
     C                             OR WMOD = 'AT'                                         JMI109CC1
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      ** For others, assign blanks
     C                   OTHER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BENEFICIARY ACCOUNT
     C                   SELECT
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
      ** Check if bank code
     C                   IF        BNCT <>'R' and  %subst(BNC1:1:1) <> '/'
     C                   MOVEL     BNC1          PBNCD
     C                   EXSR      SRBNCD
     C                   ENDIF
      ** BNC1 is a retail account or an account line or bank code
     C                   IF        BNCT = 'R' or %subst(BNC1:1:1) = '/'
     C                             OR WBNCD = 'Y'
      *
     C                   IF        %subst(BNC1:1:1) = '/'
     C                   EVAL      VarTmp = %subst(BNC1:2:34)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BNC1)
     C                   ENDIF
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Pay reference not found in OTPAYDD
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
      ** Check if bank code
     C                   IF        BNCT <>'R' and  %subst(BNC1:1:1) <> '/'
     C                   MOVEL     BNC1          PBNCD
     C                   EXSR      SRBNCD
     C                   ENDIF
      ** BNC1 is a retail account or an account line
     C                   IF        BNCT = 'R' or %subst(BNC1:1:1) = '/'
     C                             OR WBNCD = 'Y'
      *
     C                   IF        %subst(BNC1:1:1) = '/'
     C                   EVAL      VarTmp = %subst(BNC1:2:34)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BNC1)
     C                   ENDIF
      *
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Pay reference not found in INPAYDD
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Other
     C                   OTHER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BENEFICIARY ADDRESS
     C                   SELECT
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from is a customer#
     C                   IF        WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Beneficiary from is not a customer # but an address
     C                   IF        BNCT = 'A'
      * Address 1
     C                   IF        BNC1 <> ' '
     C                   EVAL      VarTmp = %Trim(BNC1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BNC2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BNC2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BNC2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BNC1 = ' ' and BNC2 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      *
      ** Beneficiary from OTPAY is not a customer# and not an address
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Pay reference not found in OTPAYDD
     C                   ELSE
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      *
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from is a customer#
     C                   IF        WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Beneficiary from is not a customer # but an address
     C                   IF        BNCT = 'A'
      * Address 1
     C                   IF        BNC1 <> ' '
     C                   EVAL      VarTmp = %Trim(BNC1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BNC2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BNC2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BNC2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BNC1 = ' ' and BNC2 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      *
      ** Beneficiary from INPAY is not a customer# and not an address
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Pay reference not found in INPAYDD
     C                   ELSE
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      *
     C                   OTHER
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDSL
      *
      * BENEFICIARY CITY
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BENEFICIARY STATE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BENEFICIARY ZIP
      ** SWIFT2007 is ON
     C                   IF        CSW207 = 'Y'
     C                   SELECT
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from OTPAY is a customer#, access AOACUSR0 using BBCUST
     C                   IF        WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Beneficiary from OTPAY is not a customer#, access AOACUSR0 using CNUM of EODPOPD
     C                   EXSR      SRACUSC
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      ** Pay reference not found in OTPAYDD, assign blank
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from INPAY is a customer#, access AOACUSR0 using BBCUST
     C                   IF        WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Beneficiary from INPAY is not a customer#, access AOACUSR0 using CNUM of EODPOPD
     C                   EXSR      SRACUSC
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      ** Pay reference not found in INPAYDD, assign blank
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      ** CSW207 is OFF (Beneficiary Zip should be blank)
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BENEFICIARY COUNTRY
     C                   SELECT
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Beneficiary from is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Pay reference not found in OTPAYDD, assign blank
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRBNC1
      ** Beneficiary from is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Beneficiary from is not a customer#
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** Pay reference not found in INPAYDD
     C                   ELSE
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BENEFICIARY BANK CUSTOMER ID
      ** For OP
     C                   IF        WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRDST1
      ** DST1 is an account line
     C                   IF        %subst(DST1:1:1) = '/' and
     C                             WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** DST1 not an account line
     C                   IF        %subst(DST1:1:1) <> '/' and
     C                             WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
      ** Pay reference not found in OTPAYDD
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Others
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BENEFICIARY BANK
      ** For OP
     C                   IF        WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRDST1
      ** DST1 is an account line
     C                   IF        %subst(DST1:1:1) = '/' and
     C                             WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** DST1 not an account line
     C                   IF        %subst(DST1:1:1) <> '/' and
     C                             WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(DST1)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      ** Pay reference not found in OTPAYDD
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Others
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BENEFICIARY BANK ID
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BENEFICIARY BANK ACCOUNT
      ** For OP
     C                   IF        WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
      ** Check if bank code
     C                   IF        DSTT <>'R' and  %subst(DST1:1:1) <> '/'
     C                   MOVEL     DST1          PBNCD
     C                   EXSR      SRBNCD
     C                   ENDIF
      ** DST1 is a retail account or an account line
     C                   IF        DSTT = 'R' or %subst(DST1:1:1) = '/'
     C                             OR WBNCD = 'Y'
      *
     C                   IF        %subst(DST1:1:1) = '/'
     C                   EVAL      VarTmp = %subst(DST1:2:34)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(DST1)
     C                   ENDIF
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Other
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BENEFICIARY BANK ADDRESS
      ** For OP
     C                   IF        WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRDST1
      ** DST1 is an account line and DST2 is a customer
     C                   IF        %subst(DST1:1:1) = '/' and
     C                             WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA2 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA2 = ' ' and BBCNA3 = ' '
     C                              and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** DST1 is not an account line and DST1 is a customer
     C                   IF        %subst(DST1:1:1) <> '/' and
     C                             WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA2 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA2 = ' ' and BBCNA3 = ' '
     C                               and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** DST1 is not a customer but an address
     C                   IF        WCUST = 'N' and DSTT = 'A'
      * Address 1
     C                   IF        DST2 <> ' '
     C                   EVAL      VarTmp = %Trim(DST2)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        DST3 <> ' '
     C                   IF        Vartmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DST3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(DST3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        DST4 <> ' '
     C                   IF        Vartmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DST4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(DST4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        DST2 = ' ' and DST3 = ' '
     C                              and DST4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** DST1 is not a customer and not an address
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference is not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Others
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BENEFICIARY BANK CITY
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BENEFICIARY BANK STATE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BENEFICIARY BANK ZIP
      ** SWIFT2007 is ON and OP records
     C                   IF        CSW207 = 'Y' and WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRDST1
      ** DST1 is an account line
     C                   IF        %subst(DST1:1:1) = '/' and
     C                             WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** DST1 not an account line
     C                   IF        %subst(DST1:1:1) <> '/' and
     C                             WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
      ** Pay reference is not found in OTPAYDD
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** SWIFT2007 is OFF and for other modules
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BENEFICIARY BANK COUNTRY
      ** For OP
     C                   IF        WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRDST1
      ** DST1 is an account line
     C                   IF        %subst(DST1:1:1) = '/' and
     C                             WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** DST1 not an account line
     C                   IF        %subst(DST1:1:1) <> '/' and
     C                             WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
      ** Pay reference not found in OTPAYDD
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** Others
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * INTERMEDIARY CUSTOMER ID
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      *
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * INTERMEDIARY
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      VarTmp = %Trim(INB1)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer# and account line
     C                   IF        %subst(INB1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Intermediary is a customer# and not an account line
     C                   IF        %subst(INB1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** Intermediary is not an IP or OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * INTERMEDIARY ID
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer#
     C                   IF        WCUST = 'Y'
     C                   IF        BBCSID <> ' '
     C                   EVAL      VarTmp = %Trim(BBCSID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBSTAD <> ' '
     C                   EVAL      VarTmp = %Trim(BBSTAD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBCHID <> 0
     C                   MOVEL     BBCHID        #BBCHID           6
     C                   EVAL      VarTmp = %Trim(#BBCHID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** BBCSID & BBSTAD is blanks and BBCHID is 0
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer# and an account line
     C                   IF        %subst(INB1:1:1) = '/' and WCUST = 'Y'
     C                   IF        BBCSID <> ' '
     C                   EVAL      VarTmp = %Trim(BBCSID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBSTAD <> ' '
     C                   EVAL      VarTmp = %Trim(BBSTAD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBCHID <> 0
     C                   MOVEL     BBCHID        #CHID             6
     C                   EVAL      VarTmp = %Trim(#CHID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** BBCSID & BBSTAD is blanks and BBCHID is 0
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Intermediary is a customer# and not an account line
     C                   IF        %subst(INB1:1:1) <> '/' and WCUST = 'Y'
     C                   IF        BBCSID <> ' '
     C                   EVAL      VarTmp = %Trim(BBCSID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBSTAD <> ' '
     C                   EVAL      VarTmp = %Trim(BBSTAD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBCHID <> 0
     C                   MOVEL     BBCHID        #CHID             6
     C                   EVAL      VarTmp = %Trim(#CHID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** BBCSID & BBSTAD is blanks and BBCHID is 0
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * INTERMEDIARY ACCOUNT
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ADDRESS
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer#
     C                   IF        WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Intermediary is not a customer# but an address
     C                   IF        INBT = 'A'
      * Address 1
     C                   IF        INB1 <> ' '
     C                   EVAL      VarTmp = %Trim(INB1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        INB2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(INB2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(INB2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        INB3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(INB3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(INB3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        INB4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(INB4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(INB4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        INB1 = ' ' and INB2 = ' ' and
     C                              INB3 = ' ' and INB4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Intermediary is not a customer# and not an address
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer# and an account line
     C                   IF        %subst(INB1:1:1) = '/' and WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Intermediary is a customer# and an account line
     C                   IF        %subst(INB1:1:1) <> '/' and WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Intermediary is not a customer# but an address
     C                   IF        INBT = 'A' and WCUST = 'N'
      * Address 1
     C                   IF        INB1 <> ' '
     C                   EVAL      VarTmp = %Trim(INB1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        INB2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(INB2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(INB2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        INB3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(INB3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(INB3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        INB4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(INB4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(INB4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        INB1 = ' ' and INB2 = ' ' and
     C                              INB3 = ' ' and INB4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      *
      ** Intermediary is not a customer# and an address
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * INTERMEDIARY CITY
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY STATE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ZIP
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C                              and CSW207 = 'Y'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer#
     C                   IF        WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C                              and CSW207 = 'Y'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer# and account line
     C                   IF        %subst(INB1:1:1) = '/' and WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Intermediary is a customer# and not an account line
     C                   IF        %subst(INB1:1:1) <> '/' and WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * INTERMEDIARY COUNTRY
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRINB1
      ** Intermediary is a customer# and an account line
     C                   IF        %subst(INB1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Intermediary is a customer# and an account line
     C                   IF        %subst(INB1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Intermediary is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING CUSTOMER ID
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORCIP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is not a customer#, assign blanks
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD, assign blanks
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORCOP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is not a customer#, assign blanks
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD, assign blanks
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For TT, CE, and GL
     C                   WHEN      WMOD = 'TT' or WMOD = 'CE' or WMOD = 'GL'
     C                             OR WMOD = 'AT'                                         JMI109CC1
     C                   IF        DRCR = 1
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   MOVE      *BLANKS       #CNUM
     C                   MOVEL     CNUM          #CNUM
     C                   EVAL      VarTmp = %Trim(#CNUM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING CUSTOMER
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORCIP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is not a customer#
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(ORC1)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORCOP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is not a customer#
     C                   EVAL      VarTmp = %Trim(ORC1)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDSL
      *
      * BY ORDERING CUSTOMER ACCOUNT
      ** For Incoming or RecPay = 1, leave it blank                                           JMI026
     C                   IF        WMOD = 'FT' and WTYP = 'IN'                                JMI026
     C                              OR #RCPY = '1'                                            JMI026
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'                                 JMI026
     C                   ELSE                                                                 JMI026
      ** Account number of APOSTPD/EODPOPD/GLACPHPD                                           JMI026
     C                   MOVE      *BLANKS       #ACNO
     C                   MOVEL     ACNO          #ACNO
     C                   EVAL      VarTmp = %Trim(#ACNO)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF                                                                JMI026
      *
      * BY ORDERING CUSTOMER ADDRESS
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORCIP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is not a customer# but an address
     C                   IF        ORCT = 'A' and WCUST = 'N'
      * Address 1
     C                   IF        ORC1 <> ' '
     C                   EVAL      VarTmp = %Trim(ORC1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        ORC2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(ORC2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(ORC2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        ORC3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(ORC3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(ORC3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        ORC1 = ' ' and ORC2 = ' '
     C                              and ORC3 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is not a customer# and not an address
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORCOP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is not a customer# but an address
     C                   IF        ORCT = 'A'
      * Address 1
     C                   IF        ORC1 <> ' '
     C                   EVAL      VarTmp = %Trim(ORC1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        ORC2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(ORC2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(ORC2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        ORC3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(ORC3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(ORC3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        ORC1 = ' ' and ORC2 = ' '
     C                              and ORC3 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      *
      ** Ordering Customer is not a customer# and address
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EXSR      SRCUST
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JJI026
     C**********         EVAL      VarTmp = ' '                                               JJI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDSL
      *
      * BY ORDERING CUSTOMER CITY
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BY ORDERING CUSTOMER STATE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BY ORDERING CUSTOMER ZIP
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C                              and CSW207 = 'Y'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORCIP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is not a customer#
     C                   EXSR      SRACUSC
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EXSR      SRACUSC
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C                              and CSW207 = 'Y'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORCOP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Customer is not a customer#
     C                   EXSR      SRACUSC
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EXSR      SRACUSC
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ENDIF
      ** Not IP and OP but CSW207 is ON
     C                   WHEN      (WMOD = 'FT' and CSW207 = 'Y' and
     C                               WTYP <> 'IN') or
     C                             (WMOD = 'FT' and CSW207 = 'Y' and
     C                               WTYP <> 'OP') or
     C                             (WMOD <> 'FT' and CSW207 = 'Y')
     C                   EXSR      SRACUSC
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** CSW207 is OFF
     C                   OTHER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING CUSTOMER COUNTRY
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORCIP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORCOP
      ** Ordering Customer is a customer# and an account line
     C                   IF        %subst(ORC1:1:1) = '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is a customer# and not an account line
     C                   IF        %subst(ORC1:1:1) <> '/' and WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Customer is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING BANK CUSTOMER ID
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORBIP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORBOP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING BANK
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORBIP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORBOP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING BANK ID
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORBIP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   IF        BBCSID <> ' '
     C                   EVAL      VarTmp = %Trim(BBCSID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBSTAD <> ' '
     C                   EVAL      VarTmp = %Trim(BBSTAD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBCHID <> 0
     C                   EVAL      #CHID = ' '
     C                   MOVEL     BBCHID        #CHID
     C                   EVAL      VarTmp = %Trim(#CHID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** BBCSID & BBSTAD is blanks and BBCHID is 0
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORBOP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   IF        BBCSID <> ' '
     C                   EVAL      VarTmp = %Trim(BBCSID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBSTAD <> ' '
     C                   EVAL      VarTmp = %Trim(BBSTAD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   IF        BBCHID <> 0
     C                   EVAL      #CHID = ' '
     C                   MOVEL     BBCHID        #CHID
     C                   EVAL      VarTmp = %Trim(#CHID)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** BBCSID & BBSTAD is blanks and BBCHID is 0
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING BANK ACCOUNT
      ** For OP
     C                   IF        WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
      ** Check if bank code
     C                   IF        ORBT <>'R'
     C                   MOVEL     ORBK          PBNCD
     C                   EXSR      SRBNCD
     C                   ENDIF
      ** ORBK is a retail account
     C                   IF        ORBT = 'R'OR WBNCD = 'Y'
     C                   MOVE      *BLANKS       #ACNO
     C                   MOVEL     ORBK          #ACNO
     C                   EVAL      VarTmp = %Trim(#ACNO)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Other
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * BY ORDERING BANK ADDRESS
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORBIP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Bank is not a customer# but an address
     C                   IF        ORBT = 'A'
      * Address 1
     C                   IF        ORB1 <> ' '
     C                   EVAL      VarTmp = %Trim(ORB1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        ORB2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(ORB2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(ORB2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        ORB1 = ' ' and ORB2 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Bank is not a customer# and not an address
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORBOP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
      * Address 1
     C                   IF        BBCNA1 <> ' '
     C                   EVAL      VarTmp = %Trim(BBCNA1)
     C                   ELSE
     C                   EVAL      VarTmp = ' '
     C                   ENDIF
      * Address 2
     C                   IF        BBCNA2 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA2)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA3)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> ' '
     C                   IF        VarTmp <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(BBCNA4)
     C                   ENDIF
     C**********         ELSE                                                                 JMI026
     C**********         EVAL      VarTmp = ' '                                               JMI026
     C                   ENDIF
      *
     C                   IF        BBCNA1 = ' ' and BBCNA2 = ' ' and
     C                              BBCNA3 = ' ' and BBCNA4 = ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING BANK CITY
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BY ORDERING BANK STATE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * BY ORDERING BANK ZIP
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C                              and CSW207 = 'Y'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORBIP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C                              and CSW207 = 'Y'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORBOP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EXSR      SRACUSB
     C                   IF        @Rtcd <> ' '
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ELSE
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * BY ORDERING BANK COUNTRY
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EXSR      SRORBIP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in INPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EXSR      SRORBOP
      ** Ordering Bank is a customer#
     C                   IF        WCUST = 'Y'
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** Ordering Bank is not a customer#
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
      ** Pay reference not found in OTPAYDD
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
     C                   OTHER
      ** For not IP and OP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDSL
      *
      * INSTRUCTIONS
     C                   SELECT
      ** For CP
     C                   WHEN      WMOD = 'FT' and WTYP = 'CP'
     C     #OTRF         CHAIN     CQPAC
     C                   IF        %found(CQPAC)
      * Instructions 1
     C                   EVAL      VarTmp = %Trim(DCH1)
      * Instructions 2
     C                   IF        DCH2 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DCH2)
     C                   ENDIF
      * Instructions 3
     C                   IF        DCH3 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DCH3)
     C                   ENDIF
      * Instructions 4
     C                   IF        DCH4 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DCH4)
     C                   ENDIF
      * Instructions 5
     C                   IF        DCH5 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DCH5)
     C                   ENDIF
      * Instructions 6
     C                   IF        DCH6 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DCH6)
     C                   ENDIF
      *
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** No record found in CQPAC
     C                   EVAL      VarTmp = %Trim(PNAR)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** For CQ
     C                   WHEN      WMOD = 'FT' and WTYP = 'CQ'
     C     #OTRF         CHAIN     CQCOD
     C                   IF        %found(CQCOD)
      * Instructions 1
     C                   EVAL      VarTmp = %Trim(NAR1)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** No record found in CQCOD
     C                   EVAL      VarTmp = %Trim(PNAR)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
      * Instructions 1
     C                   EVAL      VarTmp = %Trim(DTP1)
      * Instructions 2
     C                   IF        DTP2 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DTP2)
     C                   ENDIF
      * Instructions 3
     C                   IF        DTP3 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DTP3)
     C                   ENDIF
      * Instructions 4
     C                   IF        DTP4 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DTP4)
     C                   ENDIF
      *
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** No record found in INPAY
     C                   EVAL      VarTmp = %Trim(PNAR)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
      * Instructions 1
     C                   EVAL      VarTmp = %Trim(DTP1)
      * Instructions 2
     C                   IF        DTP2 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DTP2)
     C                   ENDIF
      * Instructions 3
     C                   IF        DTP3 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DTP3)
     C                   ENDIF
      * Instructions 4
     C                   IF        DTP4 <> ' '
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(DTP4)
     C                   ENDIF
      *
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
      ** No record found in OTPAY
     C                   EVAL      VarTmp = %Trim(PNAR)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      *
      ** Not CP, CQ, IP, and OP
     C                   OTHER
     C                   EVAL      VarTmp = %Trim(PNAR)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDSL
      *
      * OWNER BRANCH
     C                   SELECT
      ** For IP
     C                   WHEN      WMOD = 'FT' and WTYP = 'IN'
     C     #OTRF         CHAIN     INPAY
     C                   IF        %found(INPAY)
     C                   EVAL      VarTmp = %Trim(BRCA)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(BBBRCD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** For OP
     C                   WHEN      WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   EVAL      VarTmp = %Trim(BRCA)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(BBBRCD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDIF
      ** For not IP and OP
     C                   OTHER
     C                   EXSR      SRCUST
     C                   EVAL      VarTmp = %Trim(BBBRCD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ENDSL
      *
      * OWNER DEPARTMENT
     C                   EVAL      VarTmp = %Trim(GOPDPT)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * COST CENTER
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY CUSTOMER ID 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ID 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ACCOUNT 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ADDRESS 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY CITY 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY STATE 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ZIP 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY COUNTRY 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY CUSTOMER ID 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ID 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ACCOUNT 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ADDRESS 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY CITY 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY STATE 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ZIP 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY COUNTRY 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY CUSTOMER ID 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ID 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ACCOUNT 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ADDRESS 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY CITY 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY STATE 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY ZIP 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INTERMEDIARY COUNTRY 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * EXEMPTION STATUS
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * PAYMENT METHOD
     C                   IF        WMOD = 'FT' and WTYP = 'OP'
     C     #OTRF         CHAIN     OTPAY
     C                   IF        %found(OTPAY)
     C                   MOVEL     STMT          #STMT             2
     C                   EVAL      VarTmp = %Trim(#STMT)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      *
      * INSTRUMENT TYPE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INSTRUMENT NAME
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INSTRUMENT QUANTITY
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * INSTRUMENT PRICE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * RELATED REFERENCE
     C                   EVAL      VarTmp = %Trim(OTRF)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      * REFERENCE TYPE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      * NOTES
     C**********         EVAL      GFLDS = %Trim(GFLDS) + '~'                              JMI026I02
     C                   EVAL      GFLDS = %Trim(GFLDS)                                    JMI026I02
      *
      ***Write*to*REACEFPP*(Extracted*Records*File)                                           JMI109
     C*****              WRITE     REACEFD0                                                   JMI109
      ** Write to XXACEFPD (Extracted Records File)                                           JMI109
     C                   WRITE     XXACEFD0                                                   JMI109
      *
      ***Write*to*REACFFPP*(Flatfile)                                                         JMI109
     C*****              WRITE     REACFFD0                                                   JMI109
      ** Write to XXACFFPD (Flatfile)                                                         JMI109
     C                   WRITE     XXACFFD0                                                   JMI109
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBNC1 - Check if BNC1 is a customer number                  *
      *                                                               *
      *****************************************************************

     C     SRBNC1        BEGSR
      *
      ***Set*up*the*paramaters*for*SCJ00001                                                   JMI109
      ** Set up the paramaters for XX109014                                                   JMI109
     C                   EVAL      W0RTN  = ' '
      *
     C                   CLEAR                   W0FT
     C                   EVAL      W0CCY  = ' '
     C                   EVAL      W0STMT = ' '
     C                   EVAL      W0NLIN = 5
     C                   EVAL      W0ACT  = '*ENQ'
     C                   EVAL      W0TYPE = BNCT
      *
     C                   CLEAR                   W0LINS
     C                   EVAL      WADDRSS = ' '
     C                   EVAL      WADCHK1 = BNC1
     C                   EvalR     WADCHK2 = BNC2
     C                   EVAL      WADCHK3 = BNC3
     C                   EVAL      WADCHK4 = BNC4
     C                   EVAL      WADCHK5 = BNC5
     C                   MOVEL     WADDRSS       W0LINS
      *
     C                   EVAL      WCUST = 'N'
     C                   EVAL      WBRCH = *BLANKS
      *
     C                   IF        WTYP = 'OP'
     C                   EVAL      WBRCH = ORBB
     C                   ELSE
      *
     C                   IF        WTYP = 'IN'
     C                   EVAL      WBRCH = ORBR
     C                   ENDIF
     C                   ENDIF
      *
     C*****              CALL      'SCJ00001'                                                 JMI109
     C                   CALL      'XX109014'                                                 JMI109
     C                   PARM                    W0RTN             7
     C                   PARM                    W0FT
     C                   PARM                    W0LINS          256
     C                   PARM                    SDCUST
     C                   PARM                    WBRCH
     C                   PARM                    WCUST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDST1 - Check if DST1 is a customer number                  *
      *                                                               *
      *****************************************************************

     C     SRDST1        BEGSR
      *
      ***Set*up*the*paramaters*for*SCJ00001                                                   JMI109
      ** Set up the paramaters for XX109014                                                   JMI109
     C                   EVAL      W0RTN  = ' '
      *
     C                   CLEAR                   W0FT
     C                   EVAL      W0CCY  = ' '
     C                   EVAL      W0STMT = ' '
     C                   EVAL      W0NLIN = 5
     C                   EVAL      W0ACT  = '*ENQ'
     C                   EVAL      W0TYPE = DSTT
      *
     C                   CLEAR                   W0LINS
     C                   EVAL      WADDRSS = ' '
     C                   EVAL      WADCHK1 = DST1
     C                   EvalR     WADCHK2 = DST2
     C                   EVAL      WADCHK3 = DST3
     C                   EVAL      WADCHK4 = DST4
     C                   MOVEL     WADDRSS       W0LINS
      *
     C                   EVAL      WCUST = 'N'
     C*****              CALL      'SCJ00001'                                                 JMI109
     C                   CALL      'XX109014'                                                 JMI109
     C                   PARM                    W0RTN             7
     C                   PARM                    W0FT
     C                   PARM                    W0LINS          256
     C                   PARM                    SDCUST
     C                   PARM                    WBRCH
     C                   PARM                    WCUST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINB1 - Check if INB1 is a customer number                  *
      *                                                               *
      *****************************************************************

     C     SRINB1        BEGSR
      *
      ***Set*up*the*paramaters*for*SCJ00001                                                   JMI109
      ** Set up the paramaters for XX109014                                                   JMI109
     C                   EVAL      W0RTN  = ' '
      *
     C                   CLEAR                   W0FT
     C                   EVAL      W0CCY  = ' '
     C                   EVAL      W0STMT = ' '
     C                   EVAL      W0NLIN = 5
     C                   EVAL      W0ACT  = '*ENQ'
     C                   EVAL      W0TYPE = INBT
      *
     C                   CLEAR                   W0LINS
     C                   EVAL      WADDRSS = ' '
     C                   EVAL      WADCHK1 = INB1
     C                   EvalR     WADCHK2 = INB2
     C                   EVAL      WADCHK3 = INB3
     C                   EVAL      WADCHK4 = INB4
     C                   EVAL      WADCHK5 = INB5
     C                   MOVEL     WADDRSS       W0LINS
      *
     C                   EVAL      WCUST = 'N'
     C*****              CALL      'SCJ00001'                                                 JMI109
     C                   CALL      'XX109014'                                                 JMI109
     C                   PARM                    W0RTN             7
     C                   PARM                    W0FT
     C                   PARM                    W0LINS          256
     C                   PARM                    SDCUST
     C                   PARM                    WBRCH
     C                   PARM                    WCUST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORCIP - Check if ORC1 is a customer number for IP          *
      *                                                               *
      *****************************************************************

     C     SRORCIP       BEGSR
      *
      ***Set*up*the*paramaters*for*SCJ00001                                                   JMI109
      ** Set up the paramaters for XX109014                                                   JMI109
     C                   EVAL      W0RTN  = ' '
      *
     C                   CLEAR                   W0FT
     C                   EVAL      W0CCY  = ' '
     C                   EVAL      W0STMT = ' '
     C                   EVAL      W0NLIN = 5
     C                   EVAL      W0ACT  = '*ENQ'
     C                   EVAL      W0TYPE = ORCT
      *
     C                   CLEAR                   W0LINS
     C                   EVAL      WADDRSS = ' '
     C                   EVAL      WADCHK1 = ORC1
     C                   EvalR     WADCHK2 = ORC2
     C                   EVAL      WADCHK3 = ORC3
     C                   EVAL      WADCHK4 = ORC4
     C                   EVAL      WADCHK5 = ORC5
     C                   MOVEL     WADDRSS       W0LINS
      *
     C                   EVAL      WCUST = 'N'
     C*****              CALL      'SCJ00001'                                                 JMI109
     C                   CALL      'XX109014'                                                 JMI109
     C                   PARM                    W0RTN             7
     C                   PARM                    W0FT
     C                   PARM                    W0LINS          256
     C                   PARM                    SDCUST
     C                   PARM                    WBRCH
     C                   PARM                    WCUST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORCOP - Check if ORC1 is a customer number for OP          *
      *                                                               *
      *****************************************************************

     C     SRORCOP       BEGSR
      *
      ***Set*up*the*paramaters*for*SCJ00001                                                   JMI109
      ** Set up the paramaters for XX109014                                                   JMI109
     C                   EVAL      W0RTN  = ' '
      *
     C                   CLEAR                   W0FT
     C                   EVAL      W0CCY  = SMCY
     C                   EVAL      W0STMT = ' '
     C                   EVAL      W0NLIN = 5
     C                   EVAL      W0ACT  = '*ENQ'
     C                   EVAL      W0TYPE = ORCT
      *
     C                   CLEAR                   W0LINS
     C                   EVAL      WADDRSS = ' '
     C                   EVAL      WADCHK1 = ORC1
     C                   EvalR     WADCHK2 = ORC2
     C                   EVAL      WADCHK3 = ORC3
     C                   EVAL      WADCHK4 = ORC4
     C                   EVAL      WADCHK5 = ORC5
     C                   MOVEL     WADDRSS       W0LINS
      *
     C                   EVAL      WCUST = 'N'
     C*****              CALL      'SCJ00001'                                                 JMI109
     C                   CALL      'XX109014'                                                 JMI109
     C                   PARM                    W0RTN             7
     C                   PARM                    W0FT
     C                   PARM                    W0LINS          256
     C                   PARM                    SDCUST
     C                   PARM                    WBRCH
     C                   PARM                    WCUST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORBIP - Check if ORB1 is a customer number for IP          *
      *                                                               *
      *****************************************************************

     C     SRORBIP       BEGSR
      *
      ***Set*up*the*paramaters*for*SCJ00001                                                   JMI109
      ** Set up the paramaters for XX109014                                                   JMI109
     C                   EVAL      W0RTN  = ' '
      *
     C                   CLEAR                   W0FT
     C                   EVAL      W0CCY  = ' '
     C                   EVAL      W0STMT = ' '
     C                   EVAL      W0NLIN = 5
     C                   EVAL      W0ACT  = '*ENQ'
     C                   EVAL      W0TYPE = ORBT
      *
     C                   CLEAR                   W0LINS
     C                   EVAL      WADDRSS = ' '
     C                   EVAL      WADCHK1 = ORB1
     C                   EvalR     WADCHK2 = ORB2
     C                   EVAL      WADCHK3 = ORB3
     C                   EVAL      WADCHK4 = ORB4
     C                   EVAL      WADCHK5 = ORB5
     C                   MOVEL     WADDRSS       W0LINS
      *
     C                   EVAL      WCUST = 'N'
     C*****              CALL      'SCJ00001'                                                 JMI109
     C                   CALL      'XX109014'                                                 JMI109
     C                   PARM                    W0RTN             7
     C                   PARM                    W0FT
     C                   PARM                    W0LINS          256
     C                   PARM                    SDCUST
     C                   PARM                    WBRCH
     C                   PARM                    WCUST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORBOP - Check if ORBK is a customer number for OP          *
      *                                                               *
      *****************************************************************

     C     SRORBOP       BEGSR
      *
      ***Set*up*the*paramaters*for*SCJ00001                                                   JMI109
      ** Set up the paramaters for XX109014                                                   JMI109
     C                   EVAL      W0RTN  = ' '
      *
     C                   CLEAR                   W0FT
     C                   EVAL      W0CCY  = SMCY
     C                   EVAL      W0STMT = ' '
     C                   EVAL      W0NLIN = 5
     C                   EVAL      W0ACT  = '*ENQ'
     C                   EVAL      W0TYPE = ORBT
      *
     C                   CLEAR                   W0LINS
     C                   EVAL      WADDRSS = ' '
      *
     C                   EVAL      WBRCH = ORBR
      *
     C                   MOVEL     ORBK          WADCHK1
     C                   MOVEL     WADDRSS       W0LINS
      *
     C                   EVAL      WCUST = 'N'
     C*****              CALL      'SCJ00001'                                                 JMI109
     C                   CALL      'XX109014'                                                 JMI109
     C                   PARM                    W0RTN             7
     C                   PARM                    W0FT
     C                   PARM                    W0LINS          256
     C                   PARM                    SDCUST
     C                   PARM                    WBRCH
     C                   PARM                    WCUST
      *
     C                   EVAL      WBRCH = '*BLANKS'
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST - Access AOCUSTR0                                     *
      *                                                               *
      *****************************************************************

     C     SRCUST        BEGSR
      *
     C                   EVAL      ##CNUM = ' '
     C                   MOVE      CNUM          ##CNUM            6
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      ##CNUM        PKey1            10
     C                   PARM      *BLANKS       PKyst             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = ##CNUM
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACUSB - Access AOACUSR0 with BBCUST as key                 *
      *                                                               *
      *****************************************************************

     C     SRACUSB       BEGSR
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BBCUST        P@CUST            6
     C*****SDACUS        PARM      SDACUS        DSSDY                                        262960
     C     SDACUS        PARM      SDACUS        DSLDY                                        262960
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACUSC - Access AOACUSR0 with CNUM as key                   *
      *                                                               *
      *****************************************************************

     C     SRACUSC       BEGSR
      *
     C                   EVAL      ##CNUM = ' '
     C                   MOVE      CNUM          ##CNUM
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ##CNUM        P@CUST            6
     C*****SDACUS        PARM      SDACUS        DSSDY                                        262960
     C     SDACUS        PARM      SDACUS        DSLDY                                        262960
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial subroutine                                  *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR
      *
      ** Determine if the file to be read is APOSTPD or GLACPHPD
      ** if WDATE is not equal to 0
      *
     C                   IF        WDATE <> 0
     C                   EVAL      WFLAG = 'N'
      *
     C*****WDATE         SETLL     APOSTY1                                                    JMI109
     C*****              READ      APOSTY1                                                    JMI109
     C     WDATE         SETLL     XXPOSTL1                                                   JMI109
     C                   READ      XXPOSTL1                                                   JMI109
     C*****              DOW       not %eof(APOSTY1)                                          JMI109
     C*****              IF        %found(APOSTY1)                                            JMI109
     C                   DOW       not %eof(XXPOSTL1)                                         JMI109
     C                   IF        %found(XXPOSTL1)                                           JMI109
     C                   EVAL      WFLAG = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXTYN - Determine if a record should be extracted            *
      *                                                               *
      *****************************************************************

     C     EXTYN         BEGSR
      *
     C                   EVAL      WEXT = 'N'
      *
      ** Non-journal entries (module type is equal to CE, FT, or TT)
     C                   IF        WMOD <> 'GL'
      ** Set up key with the ff. combinations
      *---------------------------------------------------------*
      ** Module | Type   | Subtype| Start Range | End Range     *
      ** WMOD   | Present| Present| 0           | 0             *
      *---------------------------------------------------------*
     C                   MOVEL     OTTP          WTYP
     C                   MOVEL     OTST          WSTYP
     C                   EVAL      WSRNG = 0
     C                   EVAL      WERNG = 0
      *
     C*****ATYPKY        CHAIN     SDATYPY0                                                   JMI109
     C*****              IF        %FOUND(SDATYPY0)                                           JMI109
     C     ATYPKY        CHAIN     XXATYPL0                                                   JMI109
     C                   IF        %FOUND(XXATYPL0)                                           JMI109
     C                   EVAL      WEXT = 'Y'
     C                   ENDIF
      *
      ** If no record found on the first condition
     C                   IF        WEXT = 'N'
      ** Set up key with the ff. combinations
      *---------------------------------------------------------*
      ** Module | Type   | Subtype| Start Range | End Range     *
      ** WMOD   | Present| Blanks | 0           | 0             *
      *---------------------------------------------------------*
     C                   MOVEL     OTTP          WTYP
     C                   EVAL      WSTYP = ' '
     C                   EVAL      WSRNG = 0
     C                   EVAL      WERNG = 0
      *
     C*****ATYPKY        CHAIN     SDATYPY0                                                   JMI109
     C*****              IF        %FOUND(SDATYPY0)                                           JMI109
     C     ATYPKY        CHAIN     XXATYPL0                                                   JMI109
     C                   IF        %FOUND(XXATYPL0)                                           JMI109
     C                   EVAL      WEXT = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** If no record found on the second condition
     C                   IF        WEXT = 'N'
      ** Set up key with the ff. combinations (this is for CE and TT only)
      *---------------------------------------------------------*
      ** Module | Type   | Subtype| Start Range | End Range     *
      ** WMOD   | Blanks | Blanks | 0           | 0             *
      *---------------------------------------------------------*
     C                   EVAL      WTYP  = ' '
     C                   EVAL      WSTYP = ' '
     C                   EVAL      WSRNG = 0
     C                   EVAL      WERNG = 0
      *
     C*****ATYPKY        CHAIN     SDATYPY0                                                   JMI109
     C*****              IF        %FOUND(SDATYPY0)                                           JMI109
     C     ATYPKY        CHAIN     XXATYPL0                                                   JMI109
     C                   IF        %FOUND(XXATYPL0)                                           JMI109
     C                   EVAL      WEXT = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF                                                  non-journal

      ** Journal Entries (GL module type)
     C                   IF        WMOD = 'GL'
      ** Set up key with the ff. combinations
      *---------------------------------------------------------*
      ** Module | Type   | Subtype| Start Range | End Range     *
      ** WMOD   | Blanks | Blanks | 0           | 0             *
      *---------------------------------------------------------*
     C                   EVAL      WTYP  = ' '
     C                   EVAL      WSTYP = ' '
     C                   EVAL      WSRNG = 0
     C                   EVAL      WERNG = 0
     C                   MOVEL     SPOS          TESTRANGE         3 0
      *
     C*****ATYPKY        SETLL     SDATYPY0                                                   JMI109
     C*****              READ      SDATYPY0                                                   JMI109
     C*****              DOW       not %eof(SDATYPY0)                                         JMI109
     C     ATYPKY        SETLL     XXATYPL0                                                   JMI109
     C                   READ      XXATYPL0                                                   JMI109
     C                   DOW       not %eof(XXATYPL0)                                         JMI109
     C                   IF        GMOD = 'GL'
     C                   IF        GSRNG <= TESTRANGE and
     C                             GERNG >= TESTRANGE
     C                   EVAL      WEXT = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C*****              READ      SDATYPY0                                                   JMI109
     C                   READ      XXATYPL0                                                   JMI109
     C                   ENDDO
      *
     C                   ENDIF                                                  journal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBNCD - Determine if record is bank code                    *
      *                                                               *
      *****************************************************************

     C     SRBNCD        BEGSR
     C                   EVAL      WBNCD = 'N'
     C                   CALL      'AOBNCDR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PBNCD            11
     C     SDBNCD        PARM      SDBNCD        DSSDY
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      WBNCD = 'Y'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRNT - Print details                                       *
      *                                                               *
      *****************************************************************

     C     SRPRNT        BEGSR

      ** Ensure Detail Spool File recorded by RCF
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
      *
      ** If EOF, write Totals
      *
     C                   IF        WEnd = 'Y'
      *
     C                   IF        *IN21 = *On
     C                   WRITE     HEADP1
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
      *
      ** Write Total Activity Details not extracted
      *
     C                   WRITE     TRAIL1
      *
     C                   LeaveSr
     C                   ENDIF
      *
      ** Write details to printer fields
     C                   CLEAR                   DETAIL
      *
     C                   EVAL      CCtr   = %Char(Ctr) + '.'
     C                   MOVEL     CCtr          RNUM
     C                   EVAL      RGMOD  = WMOD
     C                   EVAL      RGTYP  = OTTP
     C                   EVAL      RGSTYP = OTST
     C                   MOVEL     CNUM          RCNUM
     C                   MOVEL     ACNO          RACNO
     C                   EVAL      RCCY   = CCY
      *
      ** Format Amount for the report
      ** Retrieve number of decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      CCY           PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = CCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      PSTA          ZFIELD           16
     C                   MOVE      A6NBDP        ZDECS             1 0
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
      *
     C                   MOVE      ZFIELD        RPAMT
     C                   EVAL      RNARR  = PNAR
     C                   EVAL      RSRC   = SPOS
     C                   EVAL      RREF   = PREF
      *
      * Posting Date in YYYYMMDD
     C                   Z-ADD     PSTD          DateIn
     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   PARM                    @Rtn              1
      *
     C                   MOVEL     DateOut       RPDAT
      *
      * Value Date in YYYYMMDD
     C                   Z-ADD     VALD          DateIn
     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   PARM                    @Rtn
      *
     C                   MOVEL     DateOut       RVDAT
      *
      ** Write Detail
     C                   IF        *IN21 = *On
     C                   WRITE     HEADP1
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
      *
     C                   WRITE     DETAIL
      *
      ** Add to Totals
      *
     C                   ADD       1             Ctr
     C                   ADD       1             RTNPOS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      *  SREnd - Set Last Record on and Return                        *
      *                                                               *
      *****************************************************************

     C     SREnd         BEGSR
      *
      ** End Program
     C                   EVAL      *INLR ='1'
     C                   RETURN

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturn           7
     C                   PARM                    PSeq              5
     C                   PARM                    PData           100
      *
     C                   EVAL      WDATA = PData
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @Rtcd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @Optn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve number of decimal places for the bank's currency code
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      BJCYCD        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = CCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      BankDec# = A6NBDP
      *
      ** Report Work fields
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *
      ** Check switchable feature CSW207
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @Rtcd             7
     C                   Parm      '*VERIFY'     @Optn             7
     C                   Parm      'CSW207'      @Sard             6
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @Rtcd = ' '
     C                   Move      'Y'           CSW207            1
     C                   Else
     C                   Move      'N'           CSW207
     C                   Endif
      *
      ** Retrieve Operating Dept
     C*****              READ      SDGAMLX0                                                   JMI109
     C                   READ      XXGAMLPD                                                   JMI109
     C                   MOVE      GOPDPT        WDPT             10
     C                   MOVEL     WFDATE        WDATE             5 0
     C                   EVAL      PSeq = ' '
      *
      ** Key fields
     C     EODKY         KLIST
     C                   KFLD                    WGETP             1
     C                   KFLD                    WTTP             10
     C                   KFLD                    WTST             10
     C*****              KFLD                    WCNUM             6 0
     C                   KFLD                    WCNUM             6
      *
     C     APOSTKY       KLIST
     C                   KFLD                    WDATE
     C                   KFLD                    WGETP
     C                   KFLD                    WTTP
     C                   KFLD                    WTST
     C                   KFLD                    WCNUM
      *
     C     ATYPKY        KLIST
     C                   KFLD                    WMOD              2
     C                   KFLD                    WTYP              2
     C*****              KFLD                    WSTYP             2                       JMI109CC1
     C                   KFLD                    WSTYP             5                       JMI109CC1
     C                   KFLD                    WSRNG             3 0
     C                   KFLD                    WERNG             3 0
      *
     C                   MOVEL     *BLANKS       WBRCH
     C                   ENDSR
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
     C     *PSSR         BEGSR

     C                   IF        WRun = ' '
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      PReturn = '*ERROR'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
**  POWERA - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  CASHTRAN - Array of Cash combinations
cashcAshcaShcasHcAsHcaSHcASHcASh
CashCAshCAsHCaShCaSHCasHCAShCASH
