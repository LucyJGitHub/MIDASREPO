     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*: OVRDBF FILE(SDEXSTAU) TOFILE(SDEXSTL0) SHARE(*NO)          : *
/*XBIB*: OVRDBF FILE(SDEXSTAX) TOFILE(SDEXSTLA) SHARE(*NO)          : *                      BUG6431
/*XBIC*: OVRDBF FILE(SDEXSHAU) TOFILE(SDEXSHL0) SHARE(*NO)          : *                      BUG6431
/*XBID*: OVRDBF FILE(SDEXSHAX) TOFILE(SDEXSHL2) SHARE(*NO)          : *                      BUG6431
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Extended settlements authorisation')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDEXSTAUT - Extended Settlements Authorisation               *
      *                                                               *
      *  Function:  This program performs the update processes that   *
      *             are to be carrired out on the unauthorised record *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 30May14               *
      *                 CSD095             Date 08Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7234            Date 20May05               *
      *                 BUG6431            Date 31Mar05               *
      *                 CDL031             Date 05Dec04               *
      *                 CGL029             Date 03Sep01               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance  Receive Settlement Instructions (Recompile)*
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  BUG7234 - SSI Warning report not showing Deleted details     *
      *  BUG6431 - Amending effective date not displayed on           *
      *            authorisation                                      *
      *  CDL031 - Effective Date on Extended SSI (Recompile)          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *           - Apply SD Authorisation processing to SD Windows   *
      *             Amend /Copys SDEXSTF001, SDEXSTD001, SDEXSTD002,  *
      *                          SDEXSTC001, SDEXSTC002, SDEXSTC003,  *
      *                          SDEXSTC004.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDEXSTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Extended Settlements Update index
 
     FSDEXSTAU  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BYREFX:BYREFAU)
      ** Midas SD Extended Settlements Retrieve
 
     FSDEXSTLA  UF A E           K DISK    INFSR(*PSSR)                                    BUG6431
     F                                     COMMIT                                          BUG6431
      ** Midas SD Extended Settlements Update index - EFFD                                 BUG6431
                                                                                           BUG6431
     FSDEXSTAX  IF   E           K DISK    INFSR(*PSSR)                                    BUG6431
     F                                     RENAME(SDEXSTD0:SDEXSTDX)                       BUG6431
      ** Midas SD Extended Settlements Retrieve                                            BUG6431
                                                                                           BUG6431
     FSDEXSHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Extended Settlements Shadow file
 
     FSDEXSHAU  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDEXSHD0:SDEXSHDA)
      ** Midas SD Extended Settlem Shadow file Retrieve
 
     FSDEXSHL2  UF   E           K DISK    INFSR(*PSSR)                                    BUG6431
     F                                     RENAME(SDEXSHD0:SDEXSHD2)                       BUG6431
     F                                     COMMIT                                          BUG6431
      ** Midas SD Extended Settlements Shadow file - EFFD                                  BUG6431
                                                                                           BUG6431
     FSDEXSHAX  IF   E           K DISK    INFSR(*PSSR)                                    BUG6431
     F                                     RENAME(SDEXSHD0:SDEXSHDX)                       BUG6431
      ** Midas SD Extended Settlem Shadow file Retrieve - EFFD                             BUG6431
                                                                                           BUG6431
     FSDFCTLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Standing Data Controls
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Key (Rtv)
 
     FSDAULGL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD1)
     F                                     COMMIT
      ** Midas SD Authorisation Log - by Key (Upd)
 
     F/COPY WNCPYSRC,SDEXSTF001
 
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
      ** Months short Names                                                               BUG6431
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)                      BUG6431
                                                                                          BUG6431
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                              BUG6431
      **  External data structures for Switchable Features Details                        BUG6431
                                                                                          BUG6431
     D DSSDY         E DS                  EXTNAME(DSSDY)                                 BUG6431
      **  Second data structure for Access Programs, long DS                              BUG6431
                                                                                          BUG6431
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Fisrt DS for Access Programs, Short Data Structure
 
     D @1DBRC        E DS                  EXTNAME(SDEXSTPD)
      * UPD : Extended Settlements update
 
     D #1DBRC        E DS                  EXTNAME(SDEXSTPD) PREFIX(#)
      * Stored shadow file format fields
 
     D UBA             DS          5000
      **  1st Record format
     D  MAIN1                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDEXSTD001
 
     D UPA             DS          5000
      **  2nd Record format
     D  MAIN2                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDEXSTD002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
     D PKEY            DS
     D  PCYCD                  1      3
     D  PCUST                  4      9
     D  PTRTY                 10     11
     D**PEFFD********         12     18                                             BUG6431 CSD095
     D  PSTYP                 12     13                                                     CSD095
     D  PBRCA                 14     16                                                     CSD095
     D  PEFFD                 17     24                                                     CSD095
      *
     D WEFFD           DS                                                                  BUG6431
     D  WDAY                   1      2                                                    BUG6431
     D  WMONTH                 3      5                                                    BUG6431
     D  WYEAR                  6      7                                                    BUG6431
      *                                                                                    BUG6431
     D @RUN            S              1
     D CPY2@           S             80
 
     D RUNDAT          DS            13
     D  RDNB                   8     10P 0
 
     D KEFFD           S                   LIKE(BYEFFD)                                    BUG6431
     D WDATEA          S              6A                                                   BUG6431
     D WMTH            S              2A                                                   BUG6431
     D W               S              2S 0                                                 BUG6431
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
 
     C                   MOVEL     PCUST         KCUST
     C                   MOVEL     PCYCD         KCYCD
     C                   MOVEL     PTRTY         KTRTY
     C                   MOVEL     PBRCA         KBRCA                                        CSD095
     C                   MOVEL     PSTYP         KSTYP                                        CSD095
      *
      ** Access original record details from from master file
     C                   MOVE      *BLANKS       UBA
      *
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C                   EVAL      W = 1                                                   BUG6431
     C                   EVAL      WEFFD = PEFFD                                           BUG6431
     C     WMONTH        LOOKUP    ZMNM(W)                                99               BUG6431
     C                   MOVE      W             WMTH                                      BUG6431
     C                   EVAL      WDATEA = WDAY + WMTH + WYEAR                            BUG6431
      ** Convert Date to Midas Day No                                                      BUG6431
     C                   CALLB     'ZDATE1'                                                BUG6431
     C                   PARM                    WDATEA                                    BUG6431
     C                   PARM      0             KEFFD                                     BUG6431
     C                   PARM      'D'           WDFMT             1                       BUG6431
     C                   PARM      *BLANKS       RTCD              1                       BUG6431
                                                                                           BUG6431
     C     KKEY2         CHAIN     SDEXSTAX                           80                   BUG6431
     C                   ELSE                                                              BUG6431
     C     KKEY1         CHAIN     SDEXSTAU                           80
     C                   ENDIF                                                             BUG6431
      *
     C                   IF        *IN80 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDEXSTPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
      ** Access record to be authorised from shadow file
     C                   MOVE      *BLANKS       UPA
      *
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C     KKEY2         CHAIN     SDEXSHAX                           80                   BUG6431
     C                   ELSE                                                              BUG6431
     C     KKEY1         CHAIN     SDEXSHAU                           80
     C                   ENDIF                                                             BUG6431
      *
     C                   IF        ALACTN = 'A'
     C                   MOVE      *BLANKS       UPA
     C                   MOVE      @1DBRC        MAIN2
     C                   ELSE
     C                   MOVE      *BLANKS       UBA
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
     C/COPY WNCPYSRC,SDEXSTC002
 
      ** Call program SDAUTHCMP to display differences
 
     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'SDEXSTPD'    FILE             10
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
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C     KKEY2         CHAIN     SDEXSHL2                           80                   BUG6431
      *                                                                                    BUG6431
     C                   IF        *IN80 = '0'                                             BUG6431
     C                   DELETE    SDEXSHD2                                                BUG6431
     C                   ENDIF                                                             BUG6431
     C                   ELSE                                                              BUG6431
     C     KKEY1         CHAIN     SDEXSHL0                           80
      *
     C                   IF        *IN80 = '0'
     C                   DELETE    SDEXSHD0
     C                   ENDIF
     C                   ENDIF                                                             BUG6431
 
     C/COPY WNCPYSRC,SDEXSTC003
 
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
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C     KKEY2         CHAIN     SDEXSTLA                           80                   BUG6431
     C                   ELSE                                                              BUG6431
     C     KKEY1         CHAIN     SDEXSTL0                           80
     C                   ENDIF                                                             BUG6431
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDEXSTPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C**********         DELETE    SDEXSTD0                                          BUG6431 BUG7234
     C                   Z-ADD     WURDNB        BYLCD                                       BUG7234
     C                   MOVEL     '*'           BYRECI                                      BUG7234
     C                   UPDATE    SDEXSTD0                                                  BUG7234
     C                   ELSE                                                              BUG6431
     C                   DELETE    @BYREFX
     C                   ENDIF                                                             BUG6431
      *
     C                   EXSR      SRDltRecUpd
     C                   EXSR      SRStdCtl
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'I', Insert record.
      ** --------------------------------
 
     C                   IF        ALACTN = 'I'
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C     KKEY2         CHAIN     SDEXSHL2                           80                   BUG6431
     C                   ELSE                                                              BUG6431
     C     KKEY1         CHAIN     SDEXSHL0                           80
     C                   ENDIF                                                             BUG6431
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDEXSHPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C                   WRITE     SDEXSTD0                                                BUG6431
     C                   ELSE                                                              BUG6431
     C                   WRITE     @BYREFX
     C                   ENDIF                                                             BUG6431
      *
     C                   EXSR      SRStdCtl
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'A', Update record.
      ** --------------------------------
 
 B1  C                   IF        ALACTN = 'A'
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C     KKEY2         CHAIN     SDEXSHL2                           80                   BUG6431
     C                   ELSE                                                              BUG6431
     C     KKEY1         CHAIN     SDEXSHL0                           80
     C                   ENDIF                                                             BUG6431
 
 B2  C                   IF        *IN80 = '0'
 
      ** Hold shadow record image
     C                   MOVEL     *BLANKS       #1DBRC
     C                   MOVEL     @1DBRC        #1DBRC
     C                   MOVEL     *BLANKS       @1DBRC
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C     KKEY2         CHAIN     SDEXSTLA                           80                   BUG6431
     C                   ELSE                                                              BUG6431
     C     KKEY1         CHAIN     SDEXSTL0                           80
     C                   ENDIF                                                             BUG6431
 
 B3  C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDEXSTPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
 X3  C                   ELSE
      ** Replace values with shadow record image
     C                   MOVEL     *BLANKS       @1DBRC
     C                   MOVEL     #1DBRC        @1DBRC
     C     CDL031        IFEQ      'Y'                                                     BUG6431
     C                   UPDATE    SDEXSTD0                                                BUG6431
     C                   ELSE                                                              BUG6431
     C                   UPDATE    @BYREFX
     C                   ENDIF                                                             BUG6431
      *
     C                   EXSR      SRStdCtl
 E3  C                   ENDIF
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,SDEXSTC004
 
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
     C                   MOVEL     'SDEXSTPD'    PBFNME                         File name
     C                   MOVEL     PKEY          PBLKEY                         Long Key
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
      * SRStdCtl - Update Standing Data Control file                  *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    : None                                               *
      *****************************************************************
     C     SRStdCtl      BEGSR
      *
     C                   MOVE      *BLANKS       WKFLNM           10
     C                   MOVEL     'SDEXSTPD'    WKFLNM
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
     C                   MOVEL     'SDEXSTPD'    DBKEY
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
     C                   EVAL      DBPGM = 'SDEXSTAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA
 
      ** Get Rundate - Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   Z-ADD     RDNB          WURDNB            5 0
 
      * CDL031 Switched On ?                                                               BUG6431
     C                   CALL      'AOSARDR0'                                              BUG6431
     C                   PARM      *BLANKS       PRTCD             7                       BUG6431
     C                   PARM      '*VERIFY'     POPTN             7                       BUG6431
     C                   PARM      'CDL031'      PSARD             6                       BUG6431
     C     SCSARD        PARM      SCSARD        DSSDY                                     BUG6431
      *                                                                                    BUG6431
     C     PRTCD         IFEQ      *BLANKS                                                 BUG6431
     C                   MOVE      'Y'           CDL031            1                       BUG6431
     C                   ELSE                                                              BUG6431
     C                   MOVE      'N'           CDL031                                    BUG6431
     C                   ENDIF                                                             BUG6431
      ** Define Key list
 
     C     KKEY1         KLIST
     C                   KFLD                    KCYCD             3
     C                   KFLD                    KCUST             6
     C                   KFLD                    KTRTY             2
     C                   KFLD                    KBRCA             3                          CSD095
     C                   KFLD                    KSTYP             2                          CSD095
 
     C     KKEY2         KLIST                                                           BUG6431
     C                   KFLD                    KCUST                                   BUG6431
     C                   KFLD                    KCYCD                                   BUG6431
     C                   KFLD                    KTRTY                                   BUG6431
     C                   KFLD                    KEFFD                                   BUG6431
     C                   KFLD                    KBRCA             3                          CSD095
     C                   KFLD                    KSTYP             2                          CSD095
                                                                                         BUG6431
     C/COPY WNCPYSRC,SDEXSTC001
 
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
(c) Finastra International Limited 2002
**   ZMNM - Months Short Names
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
