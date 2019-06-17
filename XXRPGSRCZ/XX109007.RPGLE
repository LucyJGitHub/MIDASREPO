     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('G-AML Account Extract Program')                        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***SCJ00006*-*G-AML*Account*Extract*Program**********************
      *  XX109007 - G-AML Account Extract Program                     *
      *                                                               *
      *  Function:  This program extracts account details and         *
      *             generates an extraction report                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109             Date 22May18               *
      *  Prev Amend No. JMI026I02          Date 15Oct08               *
      *                 JMI026             Date 29Sep08               *
      *                 JMI026  *CREATE    Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109 - G-AML PreProcessor (Upgrade to FB Midas)            *
      *  JMI026I02 - Multiply CLBL by -1                              *
      *  JMI026 - Amended program to extact dates with the correct    *
      *           year.                                               *
      *  JMI026 - G-AML PreProcessor                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
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
     F*REAMADY0  IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     FXXAMADL0  IF   E           K DISK    INFSR(*PSSR)                                       JMI109
     F*SDGAMLX0  IF   E             DISK    INFSR(*PSSR)                                      JMI109
     FXXGAMLPD  IF   E             DISK    INFSR(*PSSR)                                       JMI109
     F*RECIFFPP  O    E             DISK    INFSR(*PSSR)                                      JMI109
     FXXCIFFPD  O    E             DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Extraction report
     F*SCJ00006P1O    E             PRINTER INFDS(SPOOL1)                                     JMI109
     FXX109007P1O    E             PRINTER INFDS(SPOOL1)                                      JMI109
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
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)
      *
      ** Externally described DS for Account Officers
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Switchable Feature
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ***File*Information*Data*Structure*for*SCJ0006P1.                                       JMI109
      ** File Information Data Structure for XX109007P1.                                      JMI109
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
      ** Other fields used
     D WRun            S              1    INZ(' ')
     D WFirst          S              1    INZ('Y')
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
      *
      **
     D VarTmp          S           5000    Varying
     D PrvBRCH         S                   Like(BRCA)
     D Ctr             S              6  0 Inz(1)
     D CCtr            S              6
     D DateIn          S              5P 0                                                    JMI026
     D DateOut         S              8S 0                                                    JMI026
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
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C*****              READ      REAMADY0                               88                  JMI109
     C                   READ      XXAMADL0                               88                  JMI109
     C*****              OPEN      SCJ00006P1                                                 JMI109
     C                   OPEN      XX109007P1                                                 JMI109
      *
     C                   EVAL      PrvBRCH = BRCA
      *
     C     *IN88         DOWEQ     *OFF
      *
      ** Concatenate values
      *
      * Version
     C                   EVAL      GFLDS = %Trim(GFLDS) + 'PRIME-7.2' + '~'
      * ID
     C                   MOVE      ACNO          WACNO            10
     C                   EVAL      VarTmp = %Trim(WACNO)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Name
     C                   EVAL      VarTmp = %Trim(ANAM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Monitor
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Exemption Status
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Notes
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Branch
     C                   EVAL      VarTmp = %Trim(BRCA)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      ** Convert Open Date
      *
     C                   CALLB     'ZDATE9'                                                   JMI026
     C                   PARM      DACO          DateIn                                       JMI026
     C                   PARM                    DateOut                                      JMI026
     C                   PARM                    @Rtn              1                          JMI026
      *
     C                   MOVE      DateOut       WADATE            8                          JMI026
      * Open Date
     C                   EVAL      VarTmp = %Trim(WADATE)                                     JMI026
     C                   IF        WADATE = '00000000'                                        JMI026
     C                   EVAL      VarTmp = *Blanks
     C                   ENDIF
     C                   EVAL      GFLDS = %Trim(GFLDS) + %Trim(VarTmp) + '~'
     C                   EVAL      WADATE = '00000000'                                        JMI026
      * Owner Branch
     C                   EVAL      VarTmp = %Trim(BRCA)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Owner Dept
     C                   EVAL      VarTmp = %Trim(GOPDPT)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Owner Oper
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Closed
     C                   IF        ACST = 'C'
     C                   EVAL      GFLDS = %Trim(GFLDS) + '1' + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
     C                   ENDIF
      *
      ** Convert Close Date
      *
     C                   IF        ACST = 'C'
      *
     C                   CALLB     'ZDATE9'                                                   JMI026
     C                   PARM      DACC          DateIn                                       JMI026
     C                   PARM                    DateOut                                      JMI026
     C                   PARM                    @Rtn                                         JMI026
      *
     C                   MOVE      DateOut       WADATE                                       JMI026
      *
     C                   ENDIF
      * Close Date
     C                   EVAL      VarTmp = %Trim(WADATE)                                     JMI026
     C                   IF        WADATE = '00000000' Or ACST <> 'C'                         JMI026
     C                   EVAL      VarTmp = *Blanks
     C                   ENDIF
     C                   EVAL      GFLDS = %Trim(GFLDS) + %Trim(VarTmp) + '~'
     C                   EVAL      WADATE = '00000000'                                        JMI026
      * Close Reason
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Type
     C                   EVAL      GFLDS = %Trim(GFLDS) + 'R' + '~'
      * Reference
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Request
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Policy Amount
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Policy Expiry Date
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Free Look End Date
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Cash Value
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Single Premium
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      ** Access Customer Details
      *
     C                   MOVE      CNUM          WCNUM             6
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WCNUM         @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Access the Account Officer details.
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    BBACOC
     C     SDACOF        PARM      SDACOF        DSFDY
      *
     C                   IF        @Rtcd <> *BLANKS
      *
     C                   IF        @Rtcd = '*NRF'
     C                   CLEAR                   SDACOF
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = BBACOC
     C                   EVAL      DBFile = 'SDACOFPD'
     C                   EVAL      DBase = 905
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      * Account Officer
     C                   EVAL      VarTmp = %Trim(AZACON)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      *
      ** Get the currency decimal places of accounting ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CCY           @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     CCY           DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
      ** Format Balance Amt
      *
     C                   IF        CLBL <> *ZEROS                                          JMI026I02
     C                   EVAL      CLBL = CLBL * -1                                        JMI026I02
     C                   ENDIF                                                             JMI026I02
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM      CLBL          @@AMTW           13 0
     C                   PARM      A6NBDP        @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
      * Balance Amt
     C                   EVAL      VarTmp = %Trim(@@AMTD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Source of Payments
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Ac Status
     C                   EVAL      VarTmp = %Trim(ACST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Account Relationship
     C                   EVAL      GFLDS = %Trim(GFLDS) + 'OWNER' + '~'
      * Account Party
     C                   EVAL      VarTmp = %Trim(WCNUM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp
      *
      ***Write*to*RECIFFPP                                                                    JMI109
      ** Write to XXCIFFPD                                                                    JMI109
     C*****              WRITE     RECIFFD0                                                   JMI109
     C                   WRITE     XXCIFFD0                                                   JMI109
      *
      ** Process Report Lines.
     C                   EXSR      SRPrint
      *
      ** Keep Branch before next read
     C                   EVAL      PrvBRCH = BRCA
      *
      ** Read next record.
     C*****              READ      REAMADY0                               88                  JMI109
     C                   READ      XXAMADL0                               88                  JMI109
      *
     C                   EVAL      GFLDS = ' '
      *
     C                   ENDDO
      *
      ** Write Total Extracted for Branch
      *
     C                   EXSR      SRPrint
      *
     C*****              CLOSE     SCJ00006P1                                                 JMI109
     C                   CLOSE     XX109007P1                                                 JMI109
      *
     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

      ** Ensure Detail Spool File recorded by RCF.
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
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If EOF, write Totals
      *
     C                   IF        *IN88 = *On
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   EVAL      RBRCD = BRCA
     C                   EVAL      RBRCH = A8BRNM
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write Total Extracted for Branch
      *
     C                   EVAL      RBRCD1 = PrvBRCH
     C                   WRITE     TRAIL1
      *
      ** Write Total Customer Details extracted
      *
     C                   WRITE     TRAIL2
      *
     C                   LeaveSr
     C                   ENDIF
      *
      ** Access Branch details
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BRCA          @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** If new Branch, write total for Branch
      *
     C                   IF        BRCA <> PrvBRCH
     C                   EVAL      RBRCD1 = PrvBRCH
     C                   WRITE     TRAIL1
     C                   EVAL      RBRCNT = 0
     C                   EVAL      RBRCNT = 1
     C                   EVAL      RBRCD = BRCA
     C                   EVAL      RBRCH = A8BRNM
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   EVAL      RBRCD = BRCA
     C                   EVAL      RBRCH = A8BRNM
     C                   WRITE     HEADP1
     C                   EVAL      *IN21 = *Off
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
     C                   CLEAR                   DETAIL
      *
     C                   EVAL      CCtr = %Char(Ctr) + '.'
     C                   MOVEL     CCtr          RNUM
     C                   EVAL      RACCID = WACNO
     C                   EVAL      RACCNM = ANAM
     C                   IF        ACST = 'C'
     C                   EVAL      RCLSED = 'Y'
     C                   ELSE
     C                   EVAL      RCLSED = 'N'
     C                   ENDIF
     C                   EVAL      RTYPE  = 'R'
     C                   EVAL      RACCREL = 'Owner'
     C                   EVAL      RACCPRT = WCNUM
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
     C                   ADD       1             RBRCNT
     C                   ADD       1             RTOTAL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
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
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @Rtcd
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        @Rtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *                                                                                       JMI026
      ** Retrieve Operating Dept
      *
     C*****              READ      SDGAMLX0                                                   JMI109
     C                   READ      XXGAMLPD                                                   JMI109
     C                   MOVE      GOPDPT        WDPT             10
     C                   EVAL      PSeq = *Blanks
     C                   ENDSR
      *
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

     C                   IF        WRun = *Blank
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
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
