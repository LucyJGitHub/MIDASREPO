     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('G-AML Customer Extract Program')                       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***SCJ00005*-*G-AML Customer Extract Program*********************
      *  XX1090006 - G-AML Customer Extract Program                   *
      *                                                               *
      *  Function:  This program extracts customer details and        *
      *             generates an extraction report                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109             Date 23May18               *
      *  Prev Amend No. JMI026I02          Date 15Oct08               *
      *                 JMI026             Date 29Sep08               *
      *                 JMI026  *CREATE    Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109 - G-AML PreProcessor (Upgrade to FB Midas)            *
      *  JMI026I02 - Recompiled program due to changes in SDGAMLX0    *
      *  JMI026 - Amended program to extract customer type with       *
      *           BBCSTY, SWIFTTID with blanks and dates with the     *
      *           correct year.                                       *
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
     F*SDCUSTY0  IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     FXXCUSTL0  IF   E           K DISK    INFSR(*PSSR)                                       JMI109
     F*SDGAMLX0  IF   E             DISK    INFSR(*PSSR)                                      JMI109
     FXXGAMLPD  IF   E             DISK    INFSR(*PSSR)                                       JMI109
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*SDCUX5L0  IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     F*********                            USROPN                                             JMI109
     F*SDCSTFPP  O    E             DISK    INFSR(*PSSR)                                      JMI109
     FXXCSTFPD  O    E             DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Extraction report
     F*SCJ00005P1O    E             PRINTER INFDS(SPOOL1)                                     JMI109
     FXX109006P1O    E             PRINTER INFDS(SPOOL1)                                      JMI109
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
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ***File*Information*Data*Structure*for*SCJ0005P1.
      ** File Information Data Structure for XX109006P1.
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
     D PrvBRCH         S                   Like(BBBRCD)
     D Ctr             S              6  0 Inz(1)
     D CCtr            S              6
     D TYPE            S             11    Inz(*Blanks)
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
     C*****              READ      SDCUSTY0                               88                  JMI109
     C                   READ      XXCUSTL0                               88                  JMI109
     C*****              OPEN      SCJ00005P1                                                 JMI109
     C                   OPEN      XX109006P1                                                 JMI109
      *
     C                   EVAL      PrvBRCH = BBBRCD
      *
     C     *IN88         DOWEQ     *OFF
      *
      ** Chain to SDACUSL1
      *
     C                   IF        %Open(SDACUSL1)
     C     BBCUST        CHAIN     SDACUSL1
     C                   ENDIF
      *
      ** Chain to SDCUX5L0
      *
     C*****              IF        %Open(SDCUX5L0)                                            JMI109
     C*****              MOVE      BBCUST        CUSN              6 0                        JMI109
     C*****CUSN          CHAIN     SDCUX5L0                                                   JMI109
     C*****              ENDIF                                                                JMI109
      *
      ** Concatenate values
      *
      * Customer ID
     C                   EVAL      VarTmp = %Trim(BBCUST)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Parent
     C                   EVAL      VarTmp = %Trim(BBPCNB)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Report Name
     C                   EVAL      VarTmp = %Trim(BBCRNM)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * DBA
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * SicCode
     C                   EVAL      VarTmp = %Trim(BBLICD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Address 1
     C                   EVAL      VarTmp = %Trim(BBCNA1)
      * Address 2
     C                   IF        BBCNA2 <> *Blanks
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA2)
     C                   ENDIF
      * Address 3
     C                   IF        BBCNA3 <> *Blanks
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA3)
     C                   ENDIF
      * Address 4
     C                   IF        BBCNA4 <> *Blanks
     C                   EVAL      VarTmp = %Trim(VarTmp) + '$' + %Trim(BBCNA4)
     C                   ENDIF
      *
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * City
     C                   EVAL      VarTmp = %Trim(BBCRTN)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * State
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Zip
     C                   IF        CSW207 = 'Y'
     C                   EVAL      VarTmp = %Trim(E5ZIPC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      * Country
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Telephone
     C                   EVAL      VarTmp = %Trim(BBCTNB)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Email
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * TIN
     C                   IF        CSW207 = 'Y' And E5IDTP = 'TX'
     C                   EVAL      VarTmp = %Trim(E5TINO)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C*****              ELSEIF    CSD078 = 'Y'                                               JMI109
     C*****              EVAL      VarTmp = %Trim(BBTAXN)                                     JMI109
     C*****              EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'                        JMI109
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      * Passport No.
     C                   IF        CSW207 = 'Y' And E5IDTP = 'CC'
     C                   EVAL      VarTmp = %Trim(E5TINO)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      * DOB
     C                   IF        CSW207 = 'Y'
     C                   EVAL      VarTmp = %Trim(E5DBTH)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      * Type of Business
     C                   EVAL      VarTmp = %Trim(BBLINC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Source of Funds
     C                   EVAL      VarTmp = %Trim(BBFUND)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
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
      * Account Off Tel
     C                   EVAL      VarTmp = %Trim(AZAPHN) + %Trim(AZAEXT)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Acct Off Email
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Comp Officer
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Comp Off Tel
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Comp Off Email
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * IdList
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Notes
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Exemption Status
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Owner Branch
     C                   EVAL      VarTmp = %Trim(BBBRCD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Owner Dept
     C                   EVAL      VarTmp = %Trim(GOPDPT)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Owner Oper
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Risk Class
     C                   EVAL      VarTmp = %Trim(BBRWCD)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Country of Incorp
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Country of Origin
     C                   EVAL      VarTmp = %Trim(BBCNCZ)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * OffShore Corp
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Bearer Shares
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Nome De Plune
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * CTR Amt
     C                   EVAL      GFLDS = %Trim(GFLDS) + '10000.00' + '~'
      * User 1
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * User 2
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * User 3
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * User 4
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * User 5
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Bus Relation Nature
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Prev Relations
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Political Pos
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * US Person
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Sex
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Customer Type
     C                   EVAL      VarTmp = %Trim(BBCSTY)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Corr Bank Relation
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * High Risk Resp Bank
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Offshore Bank
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Pay Through AC
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * PEP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Regulated Affiliate
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Resident
     C                   EVAL      GFLDS = %Trim(GFLDS) + '1' + '~'
      * RF Calculate
     C                   EVAL      GFLDS = %Trim(GFLDS) + '1' + '~'
      * Shell Bank
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * License No.
     C                   IF        CSW207 = 'Y' And E5IDTP = 'CU'
     C                   EVAL      VarTmp = %Trim(E5TINO)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
     C                   ENDIF
      * License State
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * SwiftTID
     C**********         EVAL      VarTmp = %Trim(BBCSID)                                     JMI026
     C**********         EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'                        JMI026
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'                                 JMI026
      * Embassy
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Foreign Govt
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Charity Org
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * DoCIP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '1' + '~'
      * Prospect
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Asset size
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Income
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Ind Or Bus Type
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * FEP
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * MSB
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * On Probation
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
      * Prob Start Date
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Prob End Date
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Prob Reason
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      * Closed
     C                   IF        BBCLST = 'Y'
     C                             or BBDTDL <> 0
     C                   EVAL      GFLDS = %Trim(GFLDS) + '1' + '~'
     C                   ELSE
     C                   EVAL      GFLDS = %Trim(GFLDS) + '0' + '~'
     C                   ENDIF
      *
      ** Convert Closed Date
      *
     C                   EVAL      WADATE = '00000000'                                        JMI026
     C                   IF        BBCLST = 'Y'
      *
     C                   CALLB     'ZDATE9'                                                   JMI026
     C                   PARM      BBCLDT        DateIn                                       JMI026
     C                   PARM                    DateOut                                      JMI026
     C                   PARM                    @Rtn              1                          JMI026
      *                                                                                       JMI026
     C                   MOVE      DateOut       WADATE            8                          JMI026
     C                   ENDIF
      *                                                                                       JMI026
     C                   IF        BBDTDL <> 0
      *
     C                   CALLB     'ZDATE9'                                                   JMI026
     C                   PARM      BBDTDL        DateIn                                       JMI026
     C                   PARM                    DateOut                                      JMI026
     C                   PARM                    @Rtn                                         JMI026
      *
     C                   MOVE      DateOut       WADATE                                       JMI026
     C                   ENDIF
      * Closed Date
     C                   Eval      VarTmp = %Trim(WADATE)                                     JMI026
     C                   IF        WADATE = '00000000' Or BBCLST <> 'Y'                       JMI026
     C                             and BBDTDL = 0
     C                   EVAL      VarTmp = *Blanks
     C                   ENDIF
     C                   EVAL      GFLDS = %Trim(GFLDS) + %Trim(VarTmp) + '~'
      * Closed Reason
     C                   EVAL      GFLDS = %Trim(GFLDS) + '~'
      *
      ** Convert Open Date
      *
     C                   EVAL      WADATE = '00000000'                                        JMI026
     C                   CALLB     'ZDATE9'                                                   JMI026
     C                   PARM      BBORED        DateIn                                       JMI026
     C                   PARM                    DateOut                                      JMI026
     C                   PARM                    @Rtn                                         JMI026
      *                                                                                       JMI026
     C                   MOVE      DateOut       WADATE                                       JMI026
      *
      * Open Date
     C                   Eval      VarTmp = %Trim(WADATE)                                     JMI026
     C                   IF        WADATE = '00000000'                                        JMI026
     C                   EVAL      VarTmp = *Blanks
     C                   ENDIF
     C                   EVAL      GFLDS = %Trim(GFLDS) + %Trim(VarTmp) + '~'
      * Country of Residence
     C                   EVAL      VarTmp = %Trim(BBCOLC)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp + '~'
      * Country of Citizenship
     C                   EVAL      VarTmp = %Trim(BBCNCZ)
     C                   EVAL      GFLDS = %Trim(GFLDS) + VarTmp
      *
      ** Write to SDCSTFPP
     C*****              WRITE     SDCSTFD0                                                   JMI109
     C                   WRITE     XXCSTFD0                                                   JMI109
      *
      ** Process Report Lines.
     C                   EXSR      SRPrint
      *
      ** Keep Branch before next read
     C                   EVAL      PrvBRCH = BBBRCD
      *
      ** Read next record.
     C*****              READ      SDCUSTY0                               88                  JMI109
     C                   READ      XXCUSTL0                               88                  JMI109
      *
     C                   EVAL      GFLDS = ' '
      *
     C                   ENDDO
      *
      ** Write Total Extracted for Branch
      *
     C                   EXSR      SRPrint
      *
      ** Close User controlled files
      *
     C                   IF        %Open(SDACUSL1)
     C                   Close     SDACUSL1
     C                   ENDIF
      *
     C*****              IF        %Open(SDCUX5L0)                                            JMI109
     C*****              Close     SDCUX5L0                                                   JMI109
     C*****              ENDIF                                                                JMI109
      *
     C*****              CLOSE     SCJ00005P1                                                 JMI109
     C                   CLOSE     XX109006P1                                                 JMI109
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
     C                   EVAL      RBRCD = BBBRCD
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
     C                   PARM      BBBRCD        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** If new Branch, write total for Branch
      *
     C                   IF        BBBRCD <> PrvBRCH
     C                   EVAL      RBRCD1 = PrvBRCH
     C                   WRITE     TRAIL1
     C                   EVAL      RBRCNT = 0
     C                   EVAL      Ctr = 1
     C                   EVAL      RBRCD = BBBRCD
     C                   EVAL      RBRCH = A8BRNM
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   EVAL      RBRCD = BBBRCD
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
     C                   EVAL      RCUSID = BBCUST
     C                   EVAL      RRPTNM = BBCRNM
     C                   EVAL      RRSKCL = BBRWCD
     C                   EVAL      RCUSTY = TYPE
     C                   EVAL      RCUSAD1 = BBCNA1
     C                   EVAL      RCUSAD2 = BBCNA2
     C                   EVAL      RCUSAD3 = BBCNA3
     C                   EVAL      RCUSAD4 = BBCNA4
     C                   EVAL      RCNTRY = BBCOLC
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
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        @Rtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @Optn
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
      ** Check switchable feature CSW207                                                      JMI026
      *                                                                                       JMI026
     C                   Call      'AOSARDR0'                                                 JMI026
     C                   Parm      *Blanks       @Rtcd             7                          JMI026
     C                   Parm      '*VERIFY'     @Optn             7                          JMI026
     C                   Parm      'CSW207'      @Sard             6                          JMI026
     C     SCSARD        Parm      SCSARD        DSFDY                                        JMI026
                                                                                              JMI026
     C                   If        @Rtcd = *Blanks                                            JMI026
     C                   Open      SDACUSL1
     C                   Move      'Y'           CSW207            1                          JMI026
     C                   Else                                                                 JMI026
     C                   Move      'N'           CSW207                                       JMI026
     C                   Endif                                                                JMI026
      *                                                                                       JMI026
      ** Check switchable feature CSD078                                                      JMI026
      *                                                                                       JMI026
     C                   Call      'AOSARDR0'                                                 JMI026
     C                   Parm      *Blanks       @Rtcd                                        JMI026
     C                   Parm      '*VERIFY'     @Optn                                        JMI026
     C                   Parm      'CSD078'      @Sard                                        JMI026
     C     SCSARD        Parm      SCSARD        DSFDY                                        JMI026
                                                                                              JMI026
     C                   If        @Rtcd = *Blanks                                            JMI026
     C*****              Open      SDCUX5L0
     C                   Move      'Y'           CSD078            1                          JMI026
     C                   Else                                                                 JMI026
     C                   Move      'N'           CSD078                                       JMI026
     C                   Endif                                                                JMI026
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
