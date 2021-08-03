     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Customer Details Changes Extract')                  *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM032B*-*GL*Customer*Details*Changes*Extract*****************                       LUC109
      *  XX00032B - GL Customer Details Changes Extract               *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Incorporate External extract to workfile           *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. 159964             Date 22Aug99               *
      *                 MMI043             Date 17Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Customer Detail Changes Extract                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
      ** Engagement Transaction Extract work File
     FFECRFTI   IF   F   80        DISK    INFSR(*PSSR)
      *
      ** Engagement Transaction Extract File
     FWKFECRF   O    E             DISK    INFSR(*PSSR)
      *
      ** Engagement Transaction Extract Audit Report
     F***GLM032AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000032AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 -    First record format read                            *
      *   02 -    Second record format read                           *
      *   03 -    Third record format read                            *
      *   20 -    Engagement Transaction controoling loop             *
      *                                                               *
      *  90-99    Used by Standard Subroutines                        *
      *                                                               *
      *  88       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *  #S200  - Main Processing                                     *
      *  #S210  - First record extraction                             *
      *  #S220  - Second record Extraction                            *
      *  #S230  - Third record extraction                             *
      *  #S232  - Write Work File record                              *
      *  #S300  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * Compile Time Arrays                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      *
      ***File*information*for*printer*file*GLM040AU********************                       LUC109
      ** File information for printer file XX000032AU                                         LUC109
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256    INZ
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** DateStamp
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
      *
      ** External Mapping Data File
     IFECRFTI   NS  01    2 C5    5 C1
      *
      ** Detail Record format and Layouts
     I                                  3    5  FPROG1
     I                                  6    8  C9003
     I                                  9   11  C0120
     I                                 12   14  C9149
     I                                 15   29  C9150
     I                                 30   47  C9151
     I                                 48   53  C5125
     I                                 54   56  C0150
     I                                 57   75  C9112
      *
      ** Detail record format 2
     IFECRFTI   NS  02    2 C5    5 C2
     I                                  3    5  FPROG2
     I                                  6   24  C9113
     I                                 25   32  C0051
     I                                 33   40  C0052
     I                                 41   43  C9019
     I                                 44   45  C9020
     I                                 46   53  C9021
     I                                 54   61  C9022
     I                                 62   65  C9153
     I                                 66   69  C9154
     I                                 70   71  C0110
      *
      ** Detail record format 3
     IFECRFTI   NS  03    2 C5    5 C3
     I                                  3    5  FPROG3
     I                                  6   24  C0301
     I                                 25   32  C0441
     I                                 33   34  C0581
     I                                 35   35  C0582
     I                                 36   36  C0584
     I                                 37   37  C0637
     I                                 38   38  C0638
     I                                 39   44  C9140
     I                                 45   46  C9141
     I                                 47   47  C0814
     I                                 48   48  C5064
     I                                 49   54  C5653
     I                                 55   58  C9343
     I                                 59   62  C9344
     I          NS
      *****************************************************************
      *
     C                   EXSR      #S200                                        Main process
      *
     C                   EXSR      #S300                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR                                                  Initialisation
      *
      ** Initialise Database Error data structure
     C     *DTAARA       DEFINE    LDA           WLDA            256
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     WLDA          DBERR
     C                   OUT       WLDA
      *
      ** Key list/parameter list definition
     C     @@KEY         KLIST
     C                   KFLD                    XXRSNO            1
     C                   KFLD                    XXACCD            4
     C                   KFLD                    XXDRCR            1
      *
      ** Initial housekeeping
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #S200  -  Main process                                       *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls:     #S210  - First record extraction                  *
      *             #S220  - Second record Extraction                 *
      *             #S230  - Third record extraction                  *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      ** Read all Records from the Italian extraction file
     C     1             SETLL     FECRFTI
     C                   READ      FECRFTI                                20
      *
      ** Continue Reading until end-of-file
     C     *IN20         DOWEQ     *OFF
      *
      ** Depending on progress Number set up records details
     C     *IN01         CASEQ     *ON           #S210
     C     *IN02         CASEQ     *ON           #S220
     C     *IN03         CASEQ     *ON           #S230
     C                   ENDCS
      *
      ** Reset Record Indicators
     C                   MOVEA     '000'         *IN(01)
      *
      ** Read Next record
     C                   READ      FECRFTI                                20
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S210  -  First record extraction                            *
      *                                                               *
      *  Called By: #S200 - Main process                              *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #S210         BEGSR
      *
      **   Contains     Companys code
     C                   MOVEL(P)  C9003         WKCMCD
      **                Branch code
     C                   MOVEL(P)  C0120         WKBRCD
      **                Module Code
     C                   MOVEL(P)  C9149         WKMDCD
      **                Deal Number
     C                   MOVEL(P)  C9150         WKDLNO
      **                Account Number for Contingent Liabilities
     C                   MOVEL(P)  C9151         WKCACC
      **                Anagraphic code
     C                   MOVEL(P)  C5125         WKCUST
      **                Currency code
     C                   MOVEL(P)  C0150         WKCCYC
      **                Charges debited in the month
     C                   MOVEL(P)  C9112         WKCRDB
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #S220  -  Second record extraction                           *
      *                                                               *
      *  Called By: #S200 - Main process                              *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #S220         BEGSR
      *
      ** Write second record sequence
      **   Contains     Commisions debited in the month
     C                   MOVEL(P)  C9113         WKCMDB
      **                Issuing Date
     C                   MOVEL(P)  C0051         WKISSD
      **                Expiry Date
     C                   MOVEL(P)  C0052         WKEXPD
      **                Facility Type
     C                   MOVEL(P)  C9019         WKFTYP
      **                Facility Number
     C                   MOVEL(P)  C9020         WKFSEQ
      **                Creedit Line starting date
     C                   MOVEL(P)  C9021         WKCSDE
      **                Credit Line expiry date
     C                   MOVEL(P)  C9022         WKCEDE
      **                Local G/L code - Contingent
     C                   MOVEL(P)  C9153         WKLGLC
      **                Local G/L code - Contingent Contra
     C                   MOVEL(P)  C9154         WKLGCC
      **                Country Code
     C                   MOVEL(P)  C0110         WKCCCL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #S230  -  Third Record Extraction                            *
      *                                                               *
      *  Called By: #S200 - Main process                              *
      *                                                               *
      *  Calls:     #S232   Write Work File record                    *
      *                                                               *
      *****************************************************************
      *
     C     #S230         BEGSR
      *
      ** Move data from third record sequence to work file
      **   Contains     Accounting Balance
     C                   MOVEL(P)  C0301         WKACCB
      **                Yearly Commission Percentage
     C                   MOVEL(P)  C0441         WKYCOP
      **                Type of Liability
     C                   MOVEL(P)  C0581         WKLIBT
      **                Released/Requested to
     C                   MOVEL(P)  C0582         WKRRQT
      **                Consortium Transaction
     C                   MOVEL(P)  C0584         WKCTRN
      **                Underlying Transaction
     C                   MOVEL(P)  C0637         WKTUDT
      **                Export Transaction
     C                   MOVEL(P)  C0638         WKLETR
      **                Confirming Banks Customer Number
     C                   MOVEL(P)  C9140         WKPCNB
      **                Beneficiary Country Code
     C                   MOVEL(P)  C9141         WKBNCC
      **                Credit Type
     C                   MOVEL(P)  C0814         WKCDTP
      **                Maturity Code
     C                   MOVEL(P)  C5064         WKMATC
      **                Consortium Customer Number
     C                   MOVEL(P)  C5653         WKCTAN
      **                BSPL code
     C                   MOVEL(P)  C9343         WKBSPA
      **                BSPL Code - Contra
     C                   MOVEL(P)  C9344         WKBSPB
      *
      ** Write record to work file
     C                   EXSR      #S232
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #S232  -  Write Work File Record                             *
      *                                                               *
      *  Called By: #S230 - Third Record Extraction                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #S232         BEGSR
      *
      ** Write record to Work File
     C                   WRITE     WKFECRD0
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S300                                         *
      *                                                               *
      *  Function    :  Program termination of external transmission  *
      *                 details.                                      *
      *                                                               *
      *  Called by   :  Main Process                                  *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S300         BEGSR
      *
      ** Check switches to determine if Database error detected
     C     *IN88         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
     C                   WRITE     HEADAU                                       Report header
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ENDIF
      *
      ** Exit the program
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  #AUDIT - Produce #AUDIT Report and End Program               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
      *
     C     DBPGM         IFEQ      *BLANKS
     C**********         MOVEL     'GLM032B'     DBPGM                          Set program idLUC109
     C                   MOVEL     'XX00032B'    DBPGM                          Set program idLUC109
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *IN88                          Database error
     C                   MOVE      *ON           *INU7                                         15996
     C                   MOVE      *ON           *INU8                                         15996
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      #S300                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2016
