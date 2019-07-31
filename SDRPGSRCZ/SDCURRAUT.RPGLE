     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Currency details authorisation')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCURRAUT - Currency Details Authorisation                   *
      *                                                               *
      *  Function:  This program performs the update processes that   *
      *             are to be carrired out on the unauthorised record *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD052042           Date 09Oct18               *
      *  Prev Amend No. AR982304           Date 09Oct18               *
      *                 AR737395           Date 09Oct18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 AR982306A          Date 06Mar14               *
      *                 CMG003             Date 04Oct12               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD012   *CREATE   Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052042 - DBase error in SD authorisation for currency      *
      *             details.                                          *
      *  AR982304 - DBERROR authorizing a currency inserted.          *
      *             Initialize data structure '@1DBRC' before update  *
      *             occur. (Child:AR982305)                           *
      *           - Applied for MD052042.                             *
      *  AR737395 - DBERROR in Standing Data Authorisation.           *
      *             Used CLEAR opcode instead of MOVE *blanks when    *
      *             clearing a data structure.  (Child:AR737396)      *
      *           - Applied for MD052042.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *  AR982306A - API Spot rate amendment on newly inserted        *
      *              currency ended in WIP. Extension record should   *
      *              also be inserted for new currencies when CSD012  *
      *              is switched on. (Child: AR982307A)               *
      *              (Applied for: MD025331)                          *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *           - Apply SD Authorisation processing to SD Windows   *
      *             Amend /Copys SDCURRF001, SDCURRD001, SDCURRD002,  *
      *                          SDCURRC002, SDCURRC003, SDCURRC004.  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCURRL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Currency Details Update index
 
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Currency Details Retrival index
 
     FSDCUSHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Currency Details Shadow file Update
 
     FSDCUSHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSHD0:SDCUSHAU)
      ** Midas SD Currency Details Shadow file Retrieve
 
     FSDFCTLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Standing Data Controls
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Key (Rtv)
 
     FSDAULGL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD1)
     F                                     COMMIT
      ** Midas SD Authorisation Log - by Key (Upd)
 
     FRECCY     UF A E           K DISK    IGNORE(RECCYAF)
     F                                     IGNORE(RECCYZF)
      * UPD : Midas RE Installation control data update
      *
     FRECCYDXC  UF A E           K DISK
      * UPD : Midas RE Installation control extension file update
      *
     FRECCYZ    UF   E           K DISK
      * UPD : Midas RE Installation control data trailer update
      ** Extension File                                                                    AR982306A
     FSDCURQL0  UF A E           K DISK                                                    AR982306A
     F                                     COMMIT                                          AR982306A
 
     FSDCMDTL0  UF A E           K DISK    INFSR(*PSSR)                                       CMG003
     F                                     COMMIT                                             CMG003
      ** Midas SD Commodity Details Update index                                              CMG003
                                                                                              CMG003
     FSDCMSHL0  UF A E           K DISK    INFSR(*PSSR)                                       CMG003
     F                                     COMMIT                                             CMG003
     F                                     RENAME(SDCMDTD0:SDCMSHD0)                          CMG003
      ** Midas SD Commodity Details Shadow Update index                                       CMG003
                                                                                              CMG003
     F/COPY WNCPYSRC,SDCURRF001
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MODULE DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CMG003
      * Data Structure for Midas SAR Details                                                  CMG003
                                                                                              CMG003
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Fisrt DS for Access Programs, Short Data Structure
 
     D @1DBRC        E DS                  EXTNAME(SDCURRPD)
      * UPD : Counterparty Nostros update
 
     D #1DBRC        E DS                  EXTNAME(SDCURRPD) PREFIX(#)
      * Stored shadow file format fields
 
     D @1COMM        E DS                  EXTNAME(SDCMDTPD)                                  CMG003
      * Stored Commodity details file format fields                                           CMG003
                                                                                              CMG003
     D #1COMM        E DS                  EXTNAME(SDCMDTPD) PREFIX(#)                        CMG003
      * Stored Commodity shadow file format fields                                            CMG003
                                                                                              CMG003
     D UBA             DS          5000
      **  1st Record format
     D  MAIN1                              LIKE(@1DBRC)
     D  EXTN1                              LIKE(@1COMM)                                       CMG003
     D/COPY WNCPYSRC,SDCURRD001
 
     D UPA             DS          5000
     D  MAIN2                              LIKE(@1DBRC)
     D  EXTN2                              LIKE(@1COMM)                                       CMG003
      **  2nd Record format
     D/COPY WNCPYSRC,SDCURRD002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D RECKEY          DS            12
      * Key field for call to RECCY
     D  W#CYCD                 9     11
     D  W#FILL                12     12
 
     D DNATN           DS             5
      * Data structure to update Last Transaction No. data area
     D  FNATN                  1      5  0
 
     D DNR             DS            15
      * Key field for call to RECCY
     D  NR                     1     15
     D  NR1                    1      3P 0
     D  NR2                    4      6P 0
     D  NR3                    7      9P 0
     D  NR4                   10     12P 0
     D  NR5                   13     15P 0
      *
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
 
     D PBRC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PBFNME                 1     10
      * I :  Long Key
     D  PBLKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PBDR01                61    310
      * I :  Deleted Data Record Pt2
     D  PBDR02               311    560
      * I :  Deleted Data Record Pt3
     D  PBDR03               561    810
      * I :  Deleted Data Record Pt4
     D  PBDR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PBDR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PBDR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PBDR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PBDR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PBDR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PBDR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PBDR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PBDR12              2811   3060
      * I :  Last Change Date
     D  PBLCD               3061   3063P 0
      * I :  Type of Last Change
     D  PBTYLC              3064   3064
 
     D @RUN            S              1
     D CPY2@           S             80
 
     D RUNDAT          DS            13
     D  RDNB                   8     10P 0
 
     D M1CYCD          S              3                                                       CMG003
     D M1SWCY          S              3                                                       CMG003
     D M2CYCD          S              3                                                       CMG003
     D M2SWCY          S              3                                                       CMG003
     D WCOMM1          S             10                                                       CMG003
     D WCOMM2          S             10                                                       CMG003
     D PRTCD           S              7                                                       CMG003
     D POPTN           S              7                                                       CMG003
     D PSARD           S              6                                                       CMG003
     D CMG003          S              1                                                       CMG003
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Access record from authorisation log
     C     PKEY          CHAIN     SDAULGL0                           80
      *
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access original record details from from master file
     C                   MOVE      *BLANKS       UBA
     C                   MOVEL     PKEY          KKEY1             3
      *
     C     KKEY1         CHAIN     SDCURRL1                           80
      *
     C                   IF        *IN80 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     @1DBRC        MAIN1
     C                   MOVEL     A6CYCD        M1CYCD                                       CMG003
     C                   MOVEL     A6SWCY        M1SWCY                                       CMG003
     C                   ENDIF
 
      ** Access original record details from from Commodity file                              CMG003
                                                                                              CMG003
     C                   IF        CMG003 = 'Y'                                               CMG003
     C                   EVAL      WCOMM1 = M1CYCD + '-' + M1SWCY                             CMG003
     C     WCOMM1        CHAIN     SDCMDTL0                           81                      CMG003
     C                   IF        *IN81 = '0'                                                CMG003
     C                   MOVEL     *BLANKS       EXTN1                                        CMG003
     C                   MOVEL     @1COMM        EXTN1                                        CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
      ** Access record to be authorised from shadow file
     C                   MOVE      *BLANKS       UPA
      *
     C     KKEY1         CHAIN     SDCUSHL1                           80
      *
     C                   IF        ALACTN = 'A'
     C                   MOVE      *BLANKS       UPA
     C                   MOVEL     @1DBRC        MAIN2
     C                   MOVEL     A6CYCD        M2CYCD                                       CMG003
     C                   MOVEL     A6SWCY        M2SWCY                                       CMG003
     C                   ELSE
     C                   MOVE      *BLANKS       UBA
     C                   MOVEL     @1DBRC        MAIN1
     C                   MOVEL     A6CYCD        M1CYCD                                       CMG003
     C                   MOVEL     A6SWCY        M1SWCY                                       CMG003
     C                   ENDIF
                                                                                              CMG003
      ** Access record to be authorised from Commodity shadow file                            CMG003
                                                                                              CMG003
     C                   IF        CMG003 = 'Y'                                               CMG003
     C                   EVAL      WCOMM1 = M1CYCD + '-' + M1SWCY                             CMG003
     C                   EVAL      WCOMM2 = M2CYCD + '-' + M2SWCY                             CMG003
     C     WCOMM1        CHAIN     SDCMSHL0                           81                      CMG003
                                                                                              CMG003
     C                   IF        *IN81 = '1'                                                CMG003
     C                   CLEAR                   @1COMM                                       CMG003
     C                   MOVEL     @1COMM        EXTN1                                        CMG003
     C                   MOVEL     @1COMM        EXTN2                                        CMG003
     C                   ELSE                                                                 CMG003
     C                   IF        ALACTN = 'A'                                               CMG003
     C                   MOVEL     *BLANKS       EXTN2                                        CMG003
     C                   MOVEL     @1COMM        EXTN2                                        CMG003
                                                                                              CMG003
      ** For SWIFT Currency code amendment                                                    CMG003
                                                                                              CMG003
     C                   IF        WCOMM1 <> WCOMM2                                           CMG003
     C                             AND A6CMLT = 'D'                                           CMG003
     C                   MOVEL     *BLANKS       EXTN1                                        CMG003
     C                   MOVEL     @1COMM        EXTN1                                        CMG003
     C     WCOMM2        CHAIN     SDCMSHL0                           81                      CMG003
     C                   IF        *IN81 = '0' AND A6CMLT= 'I'                                CMG003
     C                   MOVEL     *BLANKS       EXTN2                                        CMG003
     C                   MOVEL     @1COMM        EXTN2                                        CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
      ** For Precious Metal Indicator set from Y to N                                         CMG003
                                                                                              CMG003
     C                   IF        WCOMM1 = WCOMM2 AND A6CMLT = 'D'                           CMG003
     C                   MOVEL     @1COMM        EXTN1                                        CMG003
     C                   MOVEL     *BLANKS       EXTN2                                        CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   ELSE                                                                 CMG003
     C                   MOVEL     *BLANKS       EXTN1                                        CMG003
     C                   MOVEL     @1COMM        EXTN1                                        CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
 
     C/COPY WNCPYSRC,SDCURRC002
 
      ** Call program SDAUTHCMP to display differences
 
     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'SDCURRPD'    FILE             10
     C                   PARM                    UBA
     C                   PARM                    UPA
      *
     C                   PARM                    PKEY
     C                   PARM                    PACTN
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
 
      * Exit program if Enquire or F3 or F12
     C                   IF        PACTN = 'E' OR @INKC = '1' OR @INKL = '1'
     C                   MOVEL     RETCODE       ERRMSG
     C                   EXSR      SREnd
     C                   ENDIF
 
      * Authorise Requested
     C                   IF        @INKI = '1'
     C                   EXSR      SRUpdate
     C                   EXSR      SRDelete
     C                   ENDIF
 
      * Delete Requested
     C                   IF        @INKJ = '1'
     C                   EXSR      SRDelete
     C                   ENDIF
 
      ** If There were any Errors in the Update functions, Rollback any
      ** updates and end this program, otherwise, Commit the updates
 
     C                   IF        ERRMSG = *BLANKS
     C                   COMMIT
      *
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
      *
      ** End program
     C                   EXSR      SREnd
      /EJECT
      *****************************************************************
      * SRDelete - Delete Authorisation request from Log file and     *
      *            Shadow file.                                       *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRDelete      BEGSR
 
      ** Delete record from Audit Log
     C     PKEY          CHAIN     SDAULGL1                           80
      *
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   DELETE    SDAULGD1
     C                   ENDIF
 
      ** Delete record from Shadow file
     C     KKEY1         CHAIN     SDCUSHL0                           80
      *
     C                   IF        *IN80 = '0'
     C                   DELETE    SDCUSHD0
     C                   ENDIF
 
     C                   EXSR      SRComDelete                                                CMG003
     C/COPY WNCPYSRC,SDCURRC003
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRUpdate - Update master file with shadow file details        *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** If action is 'D', Delete record.
      ** --------------------------------
 
     C                   IF        ALACTN = 'D'
     C     KKEY1         CHAIN     SDCURRL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   DELETE    @A6REA4
      *
     C                   MOVEL     A6CYCD        CQCYCD                                    AR982306A
     C     CQCYCD        CHAIN     SDCURQL0                           90                   AR982306A
     C     *IN90         IFEQ      *ON                                                     AR982306A
     C                   DELETE    SDCURQD0                             90                 AR982306A
     C                   ENDIF                                                             AR982306A
      *                                                                                    AR982306A
     C                   EXSR      SRDltRecUpd
     C                   EXSR      SRStdCtl
     C                   MOVE      'D'           A6TYLC
     C                   EXSR      SRBckgrdUpd
      *
      * If retail module switched on the delete the record on the Retail ICD
     C     BGRTBN        IfEq      'Y'
     C                   EXSR      SRRetICDDlt
     C                   ENDIF
      *
     C                   EXSR      SRComUpdate                                                CMG003
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'I', Insert record.
      ** --------------------------------
 
     C                   IF        ALACTN = 'I'
     C                   CLEAR                   @1DBRC                                     AR982304
     C     KKEY1         CHAIN     SDCUSHL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSHPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   WRITE     @A6REA4
      *
     C                   MOVEL     A6CYCD        CQCYCD                                    AR982306A
     C     CQCYCD        CHAIN     SDCURQL0                           90                   AR982306A
     C     *IN90         IFEQ      *ON                                                     AR982306A
     C                   WRITE     SDCURQD0                             90                 AR982306A
     C                   ENDIF                                                             AR982306A
      *                                                                                    AR982306A
     C                   EXSR      SRStdCtl
     C                   EXSR      SRBckgrdUpd
      *
      * If retail module switched on the write a record on the Retail ICD
     C     BGRTBN        IfEq      'Y'
     C                   EXSR      SRRetICDIns
     C                   ENDIF
      *
     C                   ENDIF
     C                   EXSR      SRComUpdate                                                CMG003
     C                   ENDIF
 
      ** If action is 'A', Update record.
      ** --------------------------------
 
 B1  C                   IF        ALACTN = 'A'
     C**********         MOVE      *BLANKS       @1DBRC                                     AR737395
     C                   CLEAR                   @1DBRC                                     AR737395
     C     KKEY1         CHAIN     SDCUSHL0                           80
 
 B2  C                   IF        *IN80 = '0'
 
      ** Hold shadow record image
     C**********         MOVE      *BLANKS       #1DBRC                                     AR737395
     C                   CLEAR                   #1DBRC                                     AR737395
     C                   MOVEL     @1DBRC        #1DBRC
     C**********         MOVE      *BLANKS       @1DBRC                                     AR737395
     C                   CLEAR                   @1DBRC                                     AR737395
     C     KKEY1         CHAIN     SDCURRL0                           80
 
 B3  C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
 X3  C                   ELSE
      ** Replace values with shadow record image
     C**********         MOVE      *BLANKS       @1DBRC                                     MD052042
     C                   MOVEL     #1DBRC        @1DBRC
     C                   UPDATE    @A6REA4
      *
     C                   EXSR      SRStdCtl
     C                   EXSR      SRBckgrdUpd
     C                   EXSR      SRComUpdate                                                CMG003
 E3  C                   ENDIF
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,SDCURRC004
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRBckgrdUpd - Background Update via SD0021U                   *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    :                                                    *
      *****************************************************************
     C     SRBckgrdUpd   BEGSR
 
      * Background Update CURR - Currency Details      *
     C                   CALL      'SD0021U'                            90           Background Upda
     C     W0RTN         PARM      *BLANK        WQ0105            7                 *Return code
     C                   PARM      A6CYCD        WQ0106            3                 Currency Code
     C**********         PARM      A6SPAE        WQ0107            4                          CGL029
     C**********         PARM      A6FTAE        WQ0108            4                          CGL029
     C**********         PARM      A6SWAE        WQ0109            4                          CGL029
     C**********         PARM      A6TAC4        WQ0110            4                          CGL029
     C**********         PARM      A6TAC5        WQ0111            4                          CGL029
     C                   PARM      A6SPAE        WQ0107           10                          CGL029
     C                   PARM      A6FTAE        WQ0108           10                          CGL029
     C                   PARM      A6SWAE        WQ0109           10                          CGL029
     C                   PARM      A6TAC4        WQ0110           10                          CGL029
     C                   PARM      A6TAC5        WQ0111           10                          CGL029
     C                   PARM      A6CDFN        WQ0112            2                 Cedel Default N
     C                   PARM      A6ECDN        WQ0113            2                 Euroclear Defau
     C                   PARM      A6LCD         WQ0114            5 0               Last Change Dat
     C                   PARM      A6TYLC        WQ0115            1                 Type of Last Ch
     C                   PARM      A6CYNM        WQ0116           14                 Currency Name
     C                   PARM      A6SPRT        WQ0117           13 8               Spot Rate
     C                   PARM      A6SWCY        WQ0118            3                 Swift Currency
     C                   PARM      A6NBDP        WQ0119            1 0               Number of Decim
     C                   PARM      A6TXND        WQ0120            1 0               Telex Notice Da
     C                   PARM      A6PRRT        WQ0121           13 8               Par Rate
     C                   PARM      A6SRC1        WQ0122            4 0               Statutory Retur
     C                   PARM      A6SRC2        WQ0123            4 0               Statutory Retur
     C                   PARM      A6DLCI        WQ0124            1                 Dealing Currenc
     C                   PARM      A6SSNB        WQ0125            2 0               Sort Sequence N
     C                   PARM      A6ERLC        WQ0126           13 8               Exchange Rate -
     C                   PARM      A6MDIN        WQ0127            1                 Multiply/Divide
     C                   PARM      A6MDPR        WQ0128            1                 Multiply/Divide
     C                   PARM      A6MDHB        WQ0129            1                 Multiply/Divide
     C                   PARM      A6MDEX        WQ0130            1                 Multiply/Divide
     C                   PARM      A6NOSN        WQ0131           10                 Nostro Shortnam
     C                   PARM      A6SPDY        WQ0132            3 0               Spot Days
     C                   PARM      A6FXSD        WQ0133            8 0               DRS FX Spot Dat
     C                   PARM      A6MMSD        WQ0134            8 0               DRS MM Spot Dat
     C                   PARM      A6NQDP        WQ0135            1 0               Normally Quoted
     C                   PARM      A6DICB        WQ0136            1                 Default Int. Ca
     C                   PARM      A6SCEX        WQ0137            1 0               Scaling Exponen
     C                   PARM      A6EBDA        WQ0138           29                 Eurobond Data
     C                   PARM      A6HBRT        WQ0139           13 8               Historic Broker
     C                   PARM      A6ENC1        WQ0140            2 0               Euroclear Numer
     C                   PARM      A6ENC2        WQ0141            2 0               Euroclear Numer
     C                   PARM      A6CACD        WQ0142            3                 Cedel Alpha Cod
     C                   PARM      A6CNMC        WQ0143            2 0               Cedel Numeric C
     C                   PARM      A6FRIH        WQ0144            1                 FRI. Holiday
     C                   PARM      A6SATH        WQ0145            1                 SAT. Holiday
     C                   PARM      A6SUNH        WQ0146            1                 SUN. Holiday
     C                   PARM      A6DPBF        WQ0147            1 0               Dec.Places in B
     C                   PARM      A6BYSR        WQ0148           13 8               Buy Spread Rate
     C                   PARM      A6BYSS        WQ0149            1                 Buy Spread Sign
     C                   PARM      A6SLSR        WQ0150           13 8               Sell Spread Rat
     C                   PARM      A6SLSS        WQ0151            1                 Sell Spread Sig
      *
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     ERRMSG
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ERRMSG
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRDltRecUpd - Write Deleted record to Deleted records file    *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    : None                                               *
      *****************************************************************
     C     SRDltRecUpd   BEGSR
      *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PBRC
     C                   MOVEL     'SDCURRPD'    PBFNME                         File name
     C                   MOVEL     A6CYCD        PBLKEY                         Long Key
     C                   MOVEL     WUDR01        PBDR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PBDR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PBDR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PBDR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PBDR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PBDR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PBDR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PBDR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PBDR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PBDR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PBDR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PBDR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PBLCD                          Last Change Dat
     C                   MOVEL     'D'           PBTYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PBRC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     ERRMSG
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRRetICDIns - Insert record on retail ICD                     *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    : None                                               *
      *****************************************************************
     C     SRRetICDIns   BEGSR
      *
      * Set up CHAIN to RECCY
     C                   MOVEL     *BLANKS       RECKEY
     C                   MOVEL     A6CYCD        W#CYCD
     C                   MOVEL     'D'           W#FILL
      *
      * Check if record already exists
     C     RECKEY        CHAIN     RECCY                              90
     C     *IN90         IFEQ      *ON
     C     *IN90         OREQ      *OFF
     C     RECI          ANDEQ     '*'
      * Setup a record on RECCYD with default values
     C                   MOVEL     'D'           RECI                           Record ID
     C                   MOVEL     RECKEY        KEY
     C                   MOVEL     *BLANKS       ZZ017                          Filler
     C                   Z-ADD     WURDNB        ORED                           Orig entry date
     C                   Z-ADD     WURDNB        LCD                            Last chg dat
     C                   MOVEL     'I'           CHTP                           Change type
     C                   Z-ADD     0             HASH                           Hash field
     C                   Z-ADD     0             MIDC                           Min dr int
     C                   Z-ADD     *ALL'9'       MADC                           Max dr int
     C                   Z-ADD     0             MICC                           Min cr int
     C                   Z-ADD     *ALL'9'       MACC                           Max cr int
     C                   MOVEL     *BLANKS       ZZ053                          Filler
     C                   Z-ADD     0             HORT                           Highest O/D rat
     C                   Z-ADD     0             HOMN                           Highest O/D min
     C                   Z-ADD     *ALL'9'       HOMX                           Highest O/D max
     C                   Z-ADD     0             ACRT                           Account - rate
     C                   Z-ADD     0             ACMN                           Account - min
     C                   Z-ADD     *ALL'9'       ACMX                           Account - max
     C                   Z-ADD     0             DIRT                           Debit int rate
     C                   Z-ADD     0             DIMN                           Debit int - min
     C                   Z-ADD     *ALL'9'       DIMX                           Debit int - max
     C                   Z-ADD     0             INFC                           Inactive rate
     C                   Z-ADD     0             MCFC                           Min balance
     C                   Z-ADD     0             AMBC                           Ave min balance
     C                   Z-ADD     0             MSFC                           Min balance
     C                   Z-ADD     0             AMBS                           Ave min balance
     C                   Z-ADD     0             DSFC                           Daily statement
     C                   Z-ADD     0             DSMN                           Daily stmts-min
     C                   Z-ADD     0             DSMX                           Daily stmts-max
     C                   Z-ADD     0             FCFC                           Fixed commissio
     C                   Z-ADD     0             AMO1                           Ccy amt int 1
     C                   Z-ADD     0             AMO2                           Ccy amt int 2
     C                   Z-ADD     0             AMO3                           Ccy amt int 3
     C                   Z-ADD     0             AMO4                           Ccy amt int 4
     C                   Z-ADD     0             AMO5                           Ccy amt int 5
     C                   Z-ADD     0             AMO6                           Ccy amt int 6
     C                   Z-ADD     0             AMO7                           Ccy amt int 7
     C                   Z-ADD     0             AMO8                           Ccy amt int 8
     C                   Z-ADD     0             CMNR                           Main rate
     C                   Z-ADD     0             CMNP                           Main prev rate
     C                   Z-ADD     0             CMNV                           Main Value Date
     C                   Z-ADD     0             CADR                           Additional rate
     C                   Z-ADD     0             CADP                           Addit prev rate
     C                   Z-ADD     0             CADV                           Addit Val Date
     C                   MOVEL     *BLANKS       ZZ175                          Filler
      *
      * Obtain 'Transaction no. of last update'
     C     *DTAARA       DEFINE    MNATN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         ZZWK05            5 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
     C                   Z-ADD     FNATN         TNLU
      *
      * Update file RECCYD if record found, else insert new record
     C     *IN90         IFEQ      *OFF
     C                   UPDATE    RECCYDF
     C                   MOVE      '0'           *IN85
     C                   ELSE
     C                   WRITE     RECCYDF
     C                   MOVE      '1'           *IN85
     C                   ENDIF
      *
      * Setup record in extension file RECCYDX with default values
     C                   MOVEL     A6CYCD        RYCCYD                         Currency code
     C                   Z-ADD     0             RYCHGC                         Demand statment
     C                   Z-ADD     0             RYCHGD                         Daily statment
     C                   Z-ADD     0             RYCHGW                         Weekly statemen
     C                   Z-ADD     0             RYCHGF                         Fortnight stmt
     C                   Z-ADD     0             RYCHGS                         Semi-month stmt
     C                   Z-ADD     0             RYCHGM                         Monthly stmt
     C                   Z-ADD     0             RYCHGT                         Bi-monthly stmt
     C                   Z-ADD     0             RYCHGB                         Lst working day
     C                   Z-ADD     0             RYCHGL                         Lst calender dy
     C                   Z-ADD     0             RYCHGA                         Accrual dt stmt
     C                   Z-ADD     0             RYCHGQ                         Quarterly stmt
     C                   Z-ADD     0             RYCHGX                         Six-month stmt
     C                   Z-ADD     0             RYCHGY                         Yearly stmt
     C                   Z-ADD     0             RYACCH                         Fixed A/C charg
     C                   MOVE      A6NBDP        RYNBDP                         Decimal places
      *
      * Update file RECCYDXC
     C                   WRITE     RECCYDD0
      *
      * Update file trailer file RECCYDZ
     C                   READ      RECCYZ                                 90
     C     *IN85         IFEQ      *ON
     C                   ADD       1             NR1
     C                   ADD       1             NR3
     C                   UPDATE    RECCYZF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRRetICDDlt - Delete record on retail ICD                     *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    : None                                               *
      *****************************************************************
     C     SRRetICDDlt   BEGSR
      *
      * Set up CHAIN to RECCY
     C                   MOVEL     *BLANKS       RECKEY
     C                   MOVEL     A6CYCD        W#CYCD
     C                   MOVEL     'D'           W#FILL
      *
     C     RECKEY        CHAIN     RECCY                              90
     C     *IN90         IFEQ      *OFF
     C                   MOVEL     '*'           RECI                           Record ID
     C                   Z-ADD     WURDNB        LCD                            Last chg dat
     C                   MOVEL     'D'           CHTP                           Change type
      * Update file RECCYD
     C                   UPDATE    RECCYDF
      *
      * Remove record from extention file RECCYDXC
     C     W#CYCD        CHAIN     RECCYDXC                           90
     C     *IN90         IFEQ      *OFF
     C                   DELETE    RECCYDD0
     C                   ENDIF
      *
     C                   READ      RECCYZ                                 61
     C     *IN61         IFEQ      '0'
     C                   SUB       1             NR1
     C                   ADD       1             NR5
     C                   UPDATE    RECCYZF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * SRStdCtl - Update Standing Data Control file                  *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    : None                                               *
      *****************************************************************
     C     SRStdCtl      BEGSR
      *
     C                   MOVE      *BLANKS       WKFLNM           10
     C                   MOVEL     'SDCURRPD'    WKFLNM
     C     WKFLNM        CHAIN     @AHREAU                            9899
      *
      * Record not found
     C     *IN98         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBSRTPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      * Record locked
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '008'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   SELECT
      * Input
     C     ALACTN        WHENEQ    'I'
     C                   EVAL      AHNORC = (AHNORC + 1)
     C                   EVAL      AHNOIN = (AHNOIN + 1)
      *
      * Amend
     C     ALACTN        WHENEQ    'A'
     C                   EVAL      AHNOAM = (AHNOAM + 1)
      *
      * Delete
     C     ALACTN        WHENEQ    'D'
     C                   EVAL      AHNORC = (AHNORC - 1)
     C                   EVAL      AHNODL = (AHNODL + 1)
     C                   ENDSL
      *
     C                   UPDATE    @AHREAU
      *
     C                   ENDSR
      /EJECT
      *****************************************************************                       CMG003
      *                                                               *                       CMG003
      * SRComUpdate - Update Commodity Master file                    *                       CMG003
      *                                                               *                       CMG003
      *****************************************************************                       CMG003
     C     SRComUpdate   BEGSR                                                                CMG003
                                                                                              CMG003
     C                   IF        CMG003 = 'Y'                                               CMG003
      ** If Delete                                                                            CMG003
                                                                                              CMG003
     C                   SELECT                                                               CMG003
     C                   WHEN      ALACTN = 'D'                                               CMG003
     C     WCOMM1        CHAIN     SDCMDTL0                           80                      CMG003
     C                   IF        *IN80 = '0'                                                CMG003
     C                   DELETE    SDCMDTD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
      ** If Insert                                                                            CMG003
                                                                                              CMG003
     C                   WHEN      ALACTN = 'I'                                               CMG003
     C     WCOMM1        CHAIN     SDCMSHL0                           80                      CMG003
     C                   IF        *IN80 = '0'                                                CMG003
     C                   WRITE     SDCMDTD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
      ** If Amend                                                                             CMG003
                                                                                              CMG003
     C                   WHEN      ALACTN = 'A'                                               CMG003
     C                   MOVEL     *BLANKS       @1COMM                                       CMG003
     C     WCOMM1        CHAIN     SDCMSHL0                           80                      CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0' AND A6CMLT = 'A'                               CMG003
     C                   MOVEL     *BLANKS       #1COMM                                       CMG003
     C                   MOVEL     @1COMM        #1COMM                                       CMG003
     C                   MOVE      *BLANKS       @1COMM                                       CMG003
     C     WCOMM1        CHAIN     SDCMDTL0                           80                      CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0'                                                CMG003
     C                   MOVE      *BLANKS       @1COMM                                       CMG003
     C                   MOVEL     #1COMM        @1COMM                                       CMG003
     C                   UPDATE    SDCMDTD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0' AND A6CMLT = 'I'                               CMG003
     C                   WRITE     SDCMDTD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0' AND A6CMLT = 'D'                               CMG003
     C     WCOMM1        CHAIN     SDCMDTL0                           80                      CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0'                                                CMG003
     C                   DELETE    SDCMDTD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   IF        WCOMM1 <> WCOMM2                                           CMG003
     C     WCOMM2        CHAIN     SDCMSHL0                           80                      CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0' AND A6CMLT = 'I'                               CMG003
     C     WCOMM2        CHAIN     SDCMDTD0                           80                      CMG003
     C                   IF        *IN80 = '1'                                                CMG003
     C                   WRITE     SDCMDTD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDSL                                                                CMG003
                                                                                              CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDSR                                                                CMG003
      *****************************************************************                       CMG003
      /EJECT                                                                                  CMG003
      *****************************************************************                       CMG003
      *                                                               *                       CMG003
      * SRComDelete - Delete from Commodity Shadow file               *                       CMG003
      *                                                               *                       CMG003
      *                                                               *                       CMG003
      *****************************************************************                       CMG003
     C     SRComDelete   BEGSR                                                                CMG003
                                                                                              CMG003
     C                   IF        CMG003 = 'Y'                                               CMG003
                                                                                              CMG003
      ** Delete record from Shadow file                                                       CMG003
                                                                                              CMG003
     C     WCOMM1        SETLL     SDCMSHL0                           80                      CMG003
     C     WCOMM1        CHAIN     SDCMSHL0                           80                      CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0'                                                CMG003
     C                   DELETE    SDCMSHD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C     WCOMM2        SETLL     SDCMSHL0                           80                      CMG003
     C     WCOMM2        CHAIN     SDCMSHL0                           80                      CMG003
                                                                                              CMG003
     C                   IF        *IN80 = '0'                                                CMG003
     C                   DELETE    SDCMSHD0                                                   CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDSR                                                                CMG003
      *****************************************************************                       CMG003
      /EJECT                                                                                  CMG003
      *****************************************************************
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : None                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    :                                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    RETCODE           7
     C**********         PARM                    PKEY             20                          CGL029
     C                   PARM                    PKEY             26                          CGL029
     C                   PARM                    PACTN             1
     C                   PARM                    ERRMSG            7
      ** Command Keys
     C                   PARM                    @INKC
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SDCURRAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA
 
      ** Get Rundate - Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   Z-ADD     RDNB          WURDNB            5 0
 
      ** Get Midas Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C/COPY WNCPYSRC,SDCURRC001
 
      ** Check if CMG003 feature is installed                                                 CMG003
                                                                                              CMG003
     C                   EVAL      CMG003 = 'N'                                               CMG003
     C                   CALLB     'AOSARDR0'                                                 CMG003
     C                   PARM      *BLANKS       PRTCD                                        CMG003
     C                   PARM      '*VERIFY'     POPTN                                        CMG003
     C                   PARM      'CMG003'      PSARD                                        CMG003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG003
                                                                                              CMG003
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CMG003
     C     *LOCK         IN        LDA                                                        CMG003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CMG003
     C                   EVAL      DBKEY  = 'CMG003'                                          CMG003
     C                   EVAL      DBASE  = 009                                               CMG003
     C                   OUT       LDA                                                        CMG003
     C                   EXSR      *PSSR                                                      CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   IF        PRTCD = *BLANKS                                            CMG003
     C                   EVAL      CMG003 = 'Y'                                               CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   ENDSR
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
