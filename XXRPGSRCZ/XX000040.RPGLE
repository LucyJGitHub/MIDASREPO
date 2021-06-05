     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Customer Details Changes Extract')                  *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM040**-*GL*Customer*Details*Changes*Extract*****************                       LUC109
      *  XX000040 - GL Customer Details Changes Extract               *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Customer Detail Changes Extract                    *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. LUC010             Date 21Aug01               *
      *                 178040             Date 19Apr00               *
      *                 169941             Date 28Oct99               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 02Feb99               *
      *                 MMI043 *Create     Date 07Dec98               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  LUC010 - Changes to Head Office Extracts                     *
      *  178040 - Deletion record not output if rec. found on FEANADSD*
      *  169941 - Branch code C0120 should default to extract header  *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Change request No. 3                                *
      *  MMI043 - Customer Detail Changes Extract                     *
      *                                                               *
      *****************************************************************
      *
      ** Bank Details
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
      *
      ** Bank Extension Details
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
      *
      ** Customer Details
     FSDCUSTLZ  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(UREFDS)
     F                                     RENAME(SDCUSTD0:SDCUSTZ0)
      *
      ** Customer Details
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer Extension Details
     FSDCUSTY0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Interface Bank Details
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Branch codes
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** General Ledger ICD
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
      *
      ** Customer Details Work file
      *                                                                   MMI043
     FSDCTRYY0  IF   E           K DISK    INFSR(*PSSR)                         MMI043
      ** Country Codes File                                               MMI043
      *                                                                   MMI043
     FSDCMRKL1  IF   E           K DISK    INFSR(*PSSR)                         LUC010
      ** Customer Marketing Groups file                                   LUC010
      *                                                                   LUC010
     FWKFEANA   IF A E           K DISK    INFSR(*PSSR)
      *
      ** FEANA Latest Customer Extraction and Sent details
     FFEANADL0  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Customer Extract Details
     FFEANA     O    E             DISK    INFSR(*PSSR)
      *
      ** Customer Extract Audit Report
     F***GLM040AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000040AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - Loop on SDBRCHL1 file                                  *
      *   21 - Control the loop on SDCUSTLZ                           *
      *   22 - Retreival of Customer extension details SDCUSTY0       *
      *   23 - Saved records from FEANADSD Transmitted file           *
      *   25 - Loop on FEANADSD for deleted records                   *
      *   26 - Retreival of Customer details SDCUSTPD                 *
      *   27 - Read branch records from the work file                 *
      *                                                               *
      *  90-99    Used by Standard Subroutines                        *
      *                                                               *
      *  88       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Database Error report                                        *
      *                                                               *
      *  1 - SDBANKPD                                                 *
      *  2 - SDGELRPP                                                 *
      *  3 - SDINTFPD                                                 *
      *  4 - SDBRCHL1                                                 *
      *  6 - SDGELRPD                                                 *
      *  7 - SDCTRYPD                                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *  #S200  - Main Processing                                     *
      *  #S210  - Detail Processing                                   *
      *  #S300  - Determine if Customer record has been deleted       *
      *  #S310  - Physical delete of record from Saved trans details  *
      *  #S400  - Write records to the transmission file from work fle*
      *  #S500  - Program Termination                                 *
      *  #S600  - Error Reporting                                     *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * Compile Time Arrays                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D ERR@            S             35    DIM(1) CTDATA PERRCD(1)              Error description
      *
      ***File*information*for*printer*file*GLM040AU********************                       LUC109
      ** File information for printer file XX000040AU                                         LUC109
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      **
     D UREFDS          DS
     D  URFMT                261    270
      *
      ** Data structure for data-base error processing
     D DBERR           DS           256    INZ
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** Header Record
     D HEADER          DS                  INZ
     D  FBKCD                  1      3
     D  FGPCD                  4      6
     D  FEXFL                  7     11    INZ('FEANA')
     D  FSYSD                 12     19
     D  FLACD                 20     27
     D  FLWDM                 28     35
     D  FNWKD                 36     43
     D  FILL01                44     78
      *
      ** Branch Header Record
     D BRCHHD          DS                  INZ
     D  FBRCD                  1      3
     D  FILL02                 4     78
      *
      ** Detail Record format and Layouts
     D DET001          DS                  INZ
     D  FPROG1                 1      3    INZ('001')
     D  WKCMCD                 4      6
     D  WKBRCD                 7      9
     D  WKACTN                10     10
     D  WKCUST                11     16
     D  WKCNA1                17     51
     D  C9820                 52     55                                         LUC010
     D  C9821                 56     59                                         LUC010
     D  C9822                 60     63                                         LUC010
     D  C9823                 64     66                                         LUC010
     D  C9824                 67     74  0                                      LUC010
     D  C9825                 75     78  0                                      LUC010
     D************************************** 52  78 FILL03                LUC010
      *
      ** Detail record format 2
     D DET002          DS                  INZ
     D  FPROG2                 1      3    INZ('002')
     D  WKCNA2                 4     38
     D  WKCNA3                39     73
     D  FILL04                74     78
      *
      ** Detail record format 3
     D DET003          DS                  INZ
     D  FPROG3                 1      3    INZ('003')
     D  WKCNA4                 4     38
     D  WKCOLC                39     40
     D  WKCNCZ                41     42
     D  WKGRZ                 43     43
     D  WKIDF                 44     44
     D  WKCPT                 45     45
     D  WKCSTY                46     46
     D  WKPAIN                47     47
     D  WKPCNB                48     53  0
     D  WKACOC                54     55
     D  WKLICD                56     58  0
     D  WKLINC                59     60  0
     D  WKBNBI                61     61
     D  WKBCCD                62     62
     D  WKCSID                63     74
     D  WKIRB                 75     77
     D  FILL05                78     78
      *                                                                   MMI043
     D DET004          DS                  INZ                                  MMI043
      ** Detail record format 4                                           MMI043
     D  FPROG4                 1      3    INZ('004')                           MMI043
     D  WKHGAR                 4      4                                         MMI043
     D  WKRPNM                 5     24                                         MMI043
     D  WKRPTN                25     34                                         MMI043
     D  FILL07                35     78                                         MMI043
      *
      ** Trailer Record
     D TRAILR          DS                  INZ
     D  FCONT                  1      6  0
     D  FILL06                 7     78
      *
      ** DateStamp
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
      *****************************************************************
      *
      ** First pass to write records for Insert and Amend
     C                   EXSR      #S200
      *
      ** Second pass to select all Deleted records
     C                   EXSR      #S300
      *
      ** Third pass to Read work file and write transission records
     C                   EXSR      #S400
      *
      ** Termination
     C                   EXSR      #S500
      /EJECT
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
     C                   MOVE      *OFF          *IN98
     C                   MOVE      '9'           XXRSNO
     C                   MOVEL(P)  'N'           UTRSRQ
     C                   Z-ADD     *ZERO         ERRCNT            6 0
      *
     C                   READ      SDBANKPD                               98    Bank details
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL(P)  'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVEL(P)  '*NONE'       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPP                               98    Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL(P)  'SDGELRPP'    DBFILE                         * DB ERR  002 *
     C                   MOVEL(P)  '*NONE'       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Determine which Branch is used for bank/company code
     C     BJSLCD        CHAIN     SDINTFPD                           98        Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL(P)  'SDINTFPD'    DBFILE                         * DB ERR  003 *
     C                   MOVEL(P)  '*NONE'       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine Bank/company code for header
     C     S9BRCH        CHAIN     SDBRCHL1                           98        Branch
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     4             DBASE                          ***************
     C                   MOVEL(P)  'SDBRCHL1'    DBFILE                         * DB ERR  004 *
     C                   MOVEL(P)  '*NONE'       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPD                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     5             DBASE                          ***************
     C                   MOVEL(P)  'SDGELRPD'    DBFILE                         * DB ERR  006 *
     C                   MOVEL(P)  '*NONE'       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Audit report Header fields
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
      *
      ** System Date
     C                   MOVE      UDATE         @SYDT
     C     @@YYT         IFGT      50
     C                   MOVE      '19'          @@YY
     C                   ELSE
     C                   MOVE      '20'          @@YY
     C                   ENDIF
     C                   MOVE      DATST         FSYSD
      *
      ** Last Accounting Date
     C                   MOVE      MLACT         FLACD
     C*                    CALL 'GLM053'
     C*                    PARM           BKAPDT
     C*                    PARM           FLACD
     C*                    PARM *ZERO     WFLACD  80
     C*                    MOVE WFLACD    FLACD
      *
      ** Last Working Day of Month
     C                   MOVE      MMDAT         FLWDM
      *
      ** Next Working Day
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    BJDNWD
     C*                    PARM           FNWKD
     C                   PARM      *ZERO         WFNWKD            8 0
     C                   MOVE      WFNWKD        FNWKD
      *
      ** Write Header Record
     C                   MOVE      '00'          RECC
     C                   MOVEL(P)  HEADER        DATA
      *
     C                   WRITE     FEANAF
      *
      ** Increment The Record Count
     C                   Z-ADD     1             COUNT             6 0
      *
     C                   ENDSR
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *  #S200  -  Generate Detail Records                            *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:     #BSPL                                             *
      *                                                               *
      *****************************************************************
     C     #S200         BEGSR
      *
      ** Read all Customer Details for the Branch
     C     *LOVAL        SETLL     SDCUSTLZ
     C                   READ      SDCUSTLZ                               21
      *
      ** Process all customer records until end of file
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
      ** Retreive Customer details Extension record
     C     BBCUST        CHAIN     SDCUSTY0                           22
      *
      ** If no record found - Initialise record format
     C     *IN22         IFEQ      *ON
      *
     C                   CLEAR                   MGREL
     C                   CLEAR                   MITDR
     C                   CLEAR                   MCNTP
     C                   CLEAR                   MBCAT
     C                   CLEAR                   MITRF
     C                   CLEAR                   MTCCY
     C                   CLEAR                   MTAMT
     C                   CLEAR                   MTYEAR
      *
      ** Set up data for the error report
     C                   MOVEL(P)  BBCUST        REPCNO
     C                   MOVEL(P)  '#S200'       REPPRG
     C                   MOVEL(P)  ERR@(1)       REPMSG
     C                   MOVEL(P)  BBCUST        REPKEY
     C                   MOVEL(P)  *BLANKS       REPDTA
      *
     C                   EXSR      #S600
      *
     C                   ENDIF
      *
      ** Determine Bank/company code for header
     C     BBBRCD        CHAIN     SDBRCHL1                           98        Branch
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     5             DBASE                          ***************
     C                   MOVEL(P)  'SDBRCHL1'    DBFILE                         * DB ERR  004 *
     C                   MOVE(P)   *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine which record format has been used
     C     URFMT         IFEQ      'SDCUSTD0'
      *
      ** Only extract if details have been amended, Inserted or Deleted
     C                   EXSR      #S210
      *
      ** Run is at end of month - Write Details
     C                   ELSE
     C                   EXSR      #S220
     C                   ENDIF
      *
      ** If a record is to included in the transmision file
     C     UTRSRQ        IFEQ      'Y'
      *
      ** Write Detail Record
     C                   EXSR      #S230
     C                   ENDIF
      *
      ** Read Next record
     C                   READ      SDCUSTLZ                               21
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S210                                         *
      *                                                               *
      *  Function    :  Controls the Creation of daily records        *
      *                 If no specified customer details have changed *
      *                 the record will be ignored and the next       *
      *                 customer record within the branch read        *
      *                                                               *
      *  Called by   :  #S200 - Controls the generation of Customer   *
      *                         details both on a daily and monthly   *
      *                         extract                               *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S210         BEGSR
      *
      ** Reset Transmission required Indicator
     C                   RESET                   UTRSRQ
      *
      ** Try and retrive Customer details from the saved FEANA file
     C     BBCUST        CHAIN     FEANADL0                           23
      *
      ** If record not found - set action code to 'I' and continue
     C     *IN23         IFEQ      *ON
      *
     C                   MOVEL     'I'           WKACTN
     C                   MOVEL(P)  'Y'           UTRSRQ            1
      *
     C                   ELSE
      *                                                                          178040
      ** If record Deleted, make sure #S230 is executed                          178040
     C     BBTYLC        IFEQ      'D'
     C                   MOVEL     'D'           WKACTN
     C                   MOVEL     'Y'           UTRSRQ
     C                   ELSE
      *
      ** Record found - Compare
      **     Customer Name and Address Line 1,2,3,4
      **      Country of Location/Citizenship
      **       Customer Type/Local Industry Code
      *
     C     BBCNA1        IFNE      BSCNA1
     C     BBCNA2        ORNE      BSCNA2
     C     BBCNA3        ORNE      BSCNA3
     C     BBCNA4        ORNE      BSCNA4
      *
     C     BBCNCZ        ORNE      BSCNCZ
     C     BBCOLC        ORNE      BSCOLC
      *
     C     BBCSTY        ORNE      BSCSTY
     C     BBLICD        ORNE      BSLICD
      *
      ** Amendments found - Set up action code
     C                   MOVEL     'A'           WKACTN
     C                   MOVEL(P)  'Y'           UTRSRQ
     C                   ENDIF
      *                                                                          178040
     C                   ENDIF
      *                                                                          178040
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S220                                         *
      *                                                               *
      *  Function    :  Controls the Creation of monthly records      *
      *                 All active records found on SDCUSTMO will be  *
      *                 writen to the transmission file               *
      *                                                               *
      *  Called by   :  #S200 - Controls the generation of Customer   *
      *                         details both on a daily and monthly   *
      *                         extract                               *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S220         BEGSR
      *
      ** Reset Transmission required and action Indicator
     C                   MOVEL(P)  'Y'           UTRSRQ
     C                   MOVEL     'O'           WKACTN
      *
      ** Try and retrive Customer details from the saved FEANA file
     C     BBCUST        CHAIN     FEANADL0                           23
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S230                                         *
      *                                                               *
      *  Function    :  To write the customer details built via S220  *
      *                 (if Daily) or Via S230 if monthly to the      *
      *                 Itialian customer details transmision file    *
      *                 FEANA                                         *
      *                                                               *
      *                 It builds in sequence the three Customer      *
      *                                                               *
      *  Called by   :  #S200 - Controls the generation of Customer   *
      *                         details both on a daily and monthly   *
      *                         extract                               *
      *                                                               *
      *  Calls       :  #S240 - Write and Update Customer details     *
      *                                                               *
      *****************************************************************
      *
     C     #S230         BEGSR
      *
      ** IF Record is flagged as deleted, skip processing.
     C     BBTYLC        IFEQ      'D'
     C     BBLCD         ANDLT     BJRDNB
     C                   GOTO      SKIP
     C                   ENDIF
      *
      ** Write Work file record
      **   Contains     Companys code
     C                   MOVE      A8CMCD        WKCMCD
      ******************Branch code                                       169941
     C*********************MOVELBBBRCD    WKBRCD    P                     169941
      **                Branch code C0120 to extract header               169941
     C                   MOVEL(P)  S9BRCH        WKBRCD                                        16994
      **                Customer Number
     C                   MOVEL(P)  BBCUST        WKCUST
      **                Counterparty Name and Address line 1
     C                   MOVEL(P)  BBCNA1        WKCNA1                         Address 1
      **                Counterparty Name and Address line 2
     C                   MOVEL(P)  BBCNA2        WKCNA2                         Address 2
      **                Counterparty Name and Address line 3
     C                   MOVEL(P)  BBCNA3        WKCNA3                         Address 3
      **                Counterparty Name and Address line 4
     C                   MOVEL(P)  BBCNA4        WKCNA4                         Address 4
      **                Country of democile
     C                   MOVEL(P)  BBCOLC        WKCOLC                         Domicile
      **                Country of citizenship
     C                   MOVEL(P)  BBCNCZ        WKCNCZ                         Citizenship
      **                Grandi Relazioni Flag
     C                   MOVEL(P)  MGREL         WKGRZ
      **                Italy driven flag
     C                   MOVEL(P)  MITDR         WKIDF
      **                Counterparty Type
     C                   MOVEL(P)  MCNTP         WKCPT
      **                Customer type
     C                   MOVEL(P)  BBCSTY        WKCSTY                         Customer typ
      **                Parent Indicator
     C                   MOVEL(P)  BBPAIN        WKPAIN                         Parent Ind
      **                Parent Customer Number
     C                   MOVEL(P)  BBPCNB        WKPCNB                         Parent Cust No
      **                Account Officer
     C                   MOVEL(P)  BBACOC        WKACOC                         Account Officer
      **                Industry Code
     C                   MOVEL(P)  BBLICD        WKLICD                         local Ind Cd
      **                Institution Code
     C                   MOVEL(P)  BBLINC        WKLINC
      **                Bank Indicator
     C                   MOVEL(P)  BBBNBI        WKBNBI
      **                Bank Category Code
     C                   MOVEL(P)  MBCAT         WKBCCD
      **                Swift Address
     C                   MOVEL(P)  BBCSID        WKCSID
      **                Italian Reference Branch
     C                   MOVEL(P)  MITRF         WKIRB
      *                                                                   MMI043
      ** Get geographical area of head office                             MMI043
      *                                                                   MMI043
     C*          BJCNCD    CHAINSDCTRYY0             77                   MMI043
     C     WKCNCZ        CHAIN     SDCTRYY0                           77                       MMI04
     C     *IN77         IFEQ      *OFF                                                        MMI04
     C                   MOVEL     MGEOA         WKHGAR                                        MMI04
     C                   ELSE                                                                  MMI04
     C                   MOVE      *BLANK        WKHGAR
     C*                    Z-ADD7         DBASE            ***************MMI043
     C*                    MOVEL'SDCTRYY0'DBFILE    P      * DB ERR  007 *MMI043
     C*                    MOVELBJCNCD    DBKEY     P      ***************MMI043
     C*                    EXSR *PSSR                                     MMI043
     C                   ENDIF                                                                 MMI04
      *                                                                   MMI043
      ** Get Customer report name and report town                         MMI043
      *                                                                   MMI043
     C                   MOVEL(P)  BBCRNM        WKRPNM                                        MMI04
     C                   MOVEL(P)  BBCRTN        WKRPTN                                        MMI04
      *                                                                   LUC010
      ** Get Internal rating, Local classification and External rating    LUC010
      *                                                                   LUC010
     C                   MOVE      BBRWCD        C9820                                         LUC01
      *                                                                   LUC010
     C     BBCUST        CHAIN     SDCMRKL1                           98                       LUC01
     C     *IN98         IFEQ      *ON                                                         LUC01
     C                   MOVE      *BLANKS       C9821                                         LUC01
     C                   MOVE      *BLANKS       C9822                                         LUC01
     C                   ELSE                                                                  LUC01
     C                   MOVE      D7GPC4        C9821                                         LUC01
     C                   MOVE      D7GPC5        C9822                                         LUC01
     C                   ENDIF                                                                 LUC01
      *                                                                   LUC010
      ** Get Turnover currency, amount and year                           LUC010
      *                                                                   LUC010
     C                   MOVE      MTCCY         C9823                                         LUC01
     C                   Z-ADD     MTAMT         C9824                                         LUC01
     C                   MOVE      MTYEAR        C9825                                         LUC01
      *
      ** Write record to Workfile
     C                   WRITE     WKFEAND0
      *
      ** Write record to Customer save file
     C                   EXSR      #S240
      *
     C     SKIP          TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S240                                         *
      *                                                               *
      *  Function    :  Write or Update record on the FEANA control   *
      *                 file.                                         *
      *                                                               *
      *  Called by   :  #S230 - Controls the generation of Customer   *
      *                         details both on a daily and monthly   *
      *                         extract                               *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S240         BEGSR
      *
      ** Set up Saved Data
     C                   MOVEL(P)  BBCUST        BSCUST
      *
     C                   MOVEL(P)  BBCNA1        BSCNA1                         Address 1
     C                   MOVEL(P)  BBCNA2        BSCNA2                         Address 2
     C                   MOVEL(P)  BBCNA3        BSCNA3                         Address 3
     C                   MOVEL(P)  BBCNA4        BSCNA4                         Address 4
      *
     C                   MOVEL(P)  BBCNCZ        BSCNCZ                         Citizenship
     C                   MOVEL(P)  BBCOLC        BSCOLC                         Domicile
      *
     C                   MOVEL(P)  BBCSTY        BSCSTY                         Customer typ
     C                   MOVEL(P)  BBLICD        BSLICD                         local Ind Cd
      *
      ** If record already exists - Update
     C     *IN23         IFEQ      *OFF
      *
      ** Update saved details record
     C                   UPDATE    FEANADS0
     C                   ELSE
      *
      ** New saved details record
     C                   WRITE     FEANADS0
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #S300  -   Determine if Customer record has been deleted     *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls:     #S310    -   Delete record from saved file        *
      *                      -   Write record to Transmission file    *
      *                                                               *
      *****************************************************************
      *
     C     #S300         BEGSR
      *
      ** Read all records from the saved file
     C     *LOVAL        SETLL     FEANADL0
     C                   READ      FEANADL0                               25
      *
      ** Continue Reading transmission file until end-of-file
     C     *IN25         DOWEQ     *OFF
      *
      ** retreive Corresponding record from the Customer Details file
     C     BSCUST        CHAIN     SDCUSTL1                           26
      *
      ** If record not found - report as deleted
     C     *IN26         IFEQ      *ON
      *
      ** Write record to Transmission file and delete from the save fil
     C                   EXSR      #S310
     C                   ENDIF
      *
      **  Read Next record
     C                   READ      FEANADL0                               25
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S310                                         *
      *                                                               *
      *  Function    :  To write a deletion type record to the        *
      *                 transmission file and delete the record from  *
      *                 the saved transmission details                *
      *                                                               *
      *  Called by   :  #S300 - Determines if a customer record that  *
      *                         has been transmiited has been         *
      *                         physical deleted                      *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S310         BEGSR
      *
      ** Write a Deletion type Work file record
      *
      **                Companys code
     C                   MOVE      A8CMCD        WKCMCD
      *
      **                Branch code
     C                   MOVEL(P)  A8BRCD        WKBRCD
      *
      **                Action Code
     C                   MOVEL     'D'           WKACTN
      *
      **                Customer Number
     C                   MOVEL(P)  BSCUST        WKCUST
      *
      **                Counterparty Name and Address line 1
     C                   MOVEL(P)  BSCNA1        WKCNA1                         Address 1
      *
      **                Counterparty Name and Address line 2
     C                   MOVEL(P)  BSCNA2        WKCNA2                         Address 2
      *
      **                Counterparty Name and Address line 3
     C                   MOVEL(P)  BSCNA3        WKCNA3                         Address 3
      *
      **                Counterparty Name and Address line 4
     C                   MOVEL(P)  BSCNA4        WKCNA4                         Address 4
      *
      **                Country of democile
     C                   MOVEL(P)  BSCOLC        WKCOLC                         Domicile
      *
      **                Country of citizenship
     C                   MOVEL(P)  BSCNCZ        WKCNCZ                         Citizenship
      *
      **                Grandi Relazioni Flag
     C                   CLEAR                   WKGRZ
      *
      **                Italy driven flag
     C                   CLEAR                   WKIDF
      *
      **                Counterparty Type
     C                   CLEAR                   WKCPT
      *
      **                Customer type
     C                   MOVEL(P)  BSCSTY        WKCSTY                         Customer typ
      *
      **                Parent Indicator
     C                   CLEAR                   WKPAIN                         Parent Ind
      *
      **                Parent Customer Number
     C                   CLEAR                   WKPCNB                         Parent Cust No
      *
      **                Account Officer
     C                   CLEAR                   WKACOC                         Account Officer
      *
      **                Industry Code
     C                   MOVEL(P)  BSLICD        WKLICD                         local Ind Cd
      *
      **                Institution Code
     C                   CLEAR                   WKLINC
      *
      **                Bank Indicator
     C                   CLEAR                   WKBNBI
      *
      **                Bank Category Code
     C                   CLEAR                   WKBCCD
      *
      **                Swift Address
     C                   CLEAR                   WKCSID
      *
      **                Italian Reference Branch
     C                   CLEAR                   WKIRB
      *                                                                   MMI043
      ** H.O. Geographical Area                                           MMI043
      *                                                                   MMI043
     C                   CLEAR                   WKHGAR                                        MMI04
      *                                                                   MMI043
      ** Report Name                                                      MMI043
      *                                                                   MMI043
     C                   CLEAR                   WKRPNM                                        MMI04
      *                                                                   MMI043
      ** Report Town                                                      MMI043
      *                                                                   MMI043
     C                   CLEAR                   WKRPTN                                        MMI04
      *                                                                   LUC010
      ** Internal rating                                                  LUC010
      *                                                                   LUC010
     C                   CLEAR                   C9820                                         LUC01
      *                                                                   LUC010
      ** Local classification                                             LUC010
      *                                                                   LUC010
     C                   CLEAR                   C9821                                         LUC01
      *                                                                   LUC010
      ** External rating                                                  LUC010
      *                                                                   LUC010
     C                   CLEAR                   C9822                                         LUC01
      *                                                                   LUC010
      ** Turnover currency                                                LUC010
      *                                                                   LUC010
     C                   CLEAR                   C9823                                         LUC01
      *                                                                   LUC010
      ** Turnover amount                                                  LUC010
      *                                                                   LUC010
     C                   CLEAR                   C9824                                         LUC01
      *                                                                   LUC010
      ** Turnover year                                                    LUC010
      *                                                                   LUC010
     C                   CLEAR                   C9825                                         LUC01
      *
      ** Write record to Workfile
     C                   WRITE     WKFEAND0
      *
      ** Delete record from the Customer save file
     C                   DELETE    FEANADS0
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #S400  -   Write records to the transmission file from the   *
      *             Work File.                                        *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls:     #S410                                             *
      *                                                               *
      *****************************************************************
      *
     C     #S400         BEGSR
      *
      ** Read all Branches
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               20
      *
      ** Continue Reading Branch file until end-of-file
     C     *IN20         DOWEQ     *OFF
      *
      ** Branch Code
     C                   MOVEL(P)  A8BRCD        FBRCD
      *
      ** Write Branch Header Record
     C                   MOVE      '02'          RECC
     C                   MOVEL(P)  BRCHHD        DATA
     C                   WRITE     FEANAF
      *
      ** Increment record Count
     C                   ADD       1             COUNT
      *
     C                   MOVE      FBRCD         WKBRCD
      *
      **  Generate Detail Records
     C                   EXSR      #S410
      *
      ** Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FEANAF
     C                   ADD       1             COUNT
      *
      ** Read Next record
     C                   READ      SDBRCHL1                               20
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S410  -  Generate Detail Records                            *
      *                                                               *
      *  Called By: #S400                                             *
      *  Calls:     #S420                                             *
      *                                                               *
      *****************************************************************
      *
     C     #S410         BEGSR
      *
      * Read all Customer Details for the Branch
     C     FBRCD         SETLL     WKFEAND0
     C     FBRCD         READE     WKFEAND0                               27
      *
      ** Process all customer records until end of file
     C     *IN27         DOWEQ     *OFF                                         Until eof
      *
      ** Write Detail Record
     C                   EXSR      #S420
      *
      ** Read Next record
     C     FBRCD         READE     WKFEAND0                               27
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S420                                         *
      *                                                               *
      *  Function    :  To write the customer details built via S220  *
      *                 (if Daily) or Via S230 if monthly to the      *
      *                 Itialian customer details transmision file    *
      *                 FEANA                                         *
      *                                                               *
      *                 It builds in sequence the three Customer recs *
      *                                                               *
      *  Called by   :  #S410 - Controls the generation of Customer   *
      *                         details both on a daily and monthly   *
      *                         extract                               *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S420         BEGSR
      *
      ** Write first record sequence
      **   Contains     Companys code
      **                Branch code
      **                Action Code
      **                Customer Number
      **                Counterparty Name and Address line 1
      *
     C                   MOVE      '05'          RECC
     C                   MOVEL(P)  DET001        DATA
     C                   WRITE     FEANAF
      *
      ** Write second record sequence
      **   Contains     Counterparty Name and Address line 2
      **                Counterparty Name and Address line 3
      *
     C                   MOVE      '05'          RECC
     C                   MOVEL(P)  DET002        DATA
     C                   WRITE     FEANAF
      *
      ** Write third record sequence
      **   Contains     Counterparty Name and Address line 4
      **                Country of democile
      **                Country of citizenship
      **                Grandi Relazioni Flag
      **                Italy driven flag
      **                Counterparty Type
      **                Customer type
      **                Parent Indicator
      **                Parent Customer Number
      **                Account Officer
      **                Industry Code
      **                Institution Code
      **                Bank Indicator
      **                Bank Category Code
      **                Swift Address
      **                Italian Reference Branch
      *
     C                   MOVE      '05'          RECC
     C                   MOVEL(P)  DET003        DATA
     C                   WRITE     FEANAF
      *                                                                   MMI043
      ** Write fourth record sequence with the ff. fields                 MMI043
      ** head office geographical area, report name, and report town      MMI043
      *                                                                   MMI043
     C                   MOVE      '05'          RECC                                          MMI04
     C                   MOVEL(P)  DET004        DATA                                          MMI04
     C                   WRITE     FEANAF                                                      MMI04
      *
      ** Increment record Count
     C                   ADD       4             COUNT
      *
      ** reset record formats
     C                   RESET                   DET001
     C                   RESET                   DET002
     C                   RESET                   DET003
     C                   RESET                   DET004                                        MMI04
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S500                                         *
      *                                                               *
      *  Function    :  Program termination and write Transmision     *
      *                 Trailer record.                               *
      *                                                               *
      *  Called by   :  Main Line - On program Completion.            *
      *                 *PSSR - If any database errors are detected.  *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S500         BEGSR
      *
      ** Check switches to determine if Database error detected
     C     *IN88         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
     C                   WRITE     HEADAU                                       Report header
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ELSE
      *
      ** Write Trailer Record
     C                   ADD       1             COUNT
     C                   Z-ADD     COUNT         FCONT
     C                   MOVE      '99'          RECC
     C                   MOVE      TRAILR        DATA
     C                   WRITE     FEANAF
      *
      **  If errors have been produced - set set of report
     C     ERRCNT        IFGT      *ZERO
     C                   WRITE     EOR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Exit the program
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *    #S600     - Extract Record Error Processing                *
      *                                                               *
      *    This section will write a record to an error report that   *
      *    details all file error's encountered during the run        *
      *                                                               *
      *    This replaces the normal Midas error routine for Database  *
      *    errors.                                                    *
      *                                                               *
      *    Called By -                                                *
      *    CALLS     -                                                *
      *                                                               *
      *****************************************************************
      *
     C     #S600         BEGSR
      *
      ** Determine if a new page has to be written
      **   WWOFL1 - Overflow line number, WWPTL1 - Current line number
     C     WWOFL1        SUB       WWPTL1        WWLINE            2 0
      *
      ** write new error header if required
     C     WWLINE        IFLT      5
     C                   WRITE     ERRHDR
     C                   ENDIF
      *
      ** Accumulate the error count and write the detail record
     C                   ADD       1             ERRCNT
     C                   WRITE     ERRDET                                       Report error
      *
     C                   ENDSR
      *
      *****************************************************************
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
     C     *PSSR         BEGSR                                                              **
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
     C**********         MOVEL     'GLM040'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000040'    DBPGM                          Set program idLUC109
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
     C                   EXSR      #S500                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2016
**  ERR@
SDCUSTY0 RECORD NOT FOUND
