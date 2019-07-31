     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Counterparty nostros authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCPNOAUT - Counterparty Nostros Authorisation               *
      *                                                               *
      *  Function:  This program performs the update processes that   *
      *             are to be carrired out on the unauthorised record *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 03Sep01               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCNSTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Counterparty Nostros Update index
 
     FSDCNSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Counterparty Nostros Retrieval index
 
     FSDCNSHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Counterparty Nostro Shadow file Update
 
     FSDCNSHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@AWREDN:AWREDNAU)
      ** Midas SD Counterparty Nostro Shadow file Retrieval
 
     FSDFCTLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Standing Data Controls
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Key (Rtv)
 
     FSDAULGL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD1)
     F                                     COMMIT
      ** Midas SD Authorisation Log - by Key (Upd)
 
     F/COPY WNCPYSRC,SDCPNOF001
 
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Fisrt DS for Access Programs, Short Data Structure
 
     D @1DBRC        E DS                  EXTNAME(SDCNSTPD)
      * UPD : Counterparty Nostros update
 
     D #1DBRC        E DS                  EXTNAME(SDCNSTPD) PREFIX(#)
      * Stored shadow file format fields
 
     D UBA             DS          5000
      **  1st Record format
     D  MAIN1                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDCPNOD001
 
     D UPA             DS          5000
      **  2nd Record format
     D  MAIN2                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDCPNOD002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PARC            DS           148
      * RCD : Counterparty Nostros retrieval
      * I : MAP Counterparty Nostro Code
     D  PACPNC                 1      8
      * I : MAP Last Change Date
     D  PALCD                  9     11P 0
      * I : MAP Type of Last Change
     D  PATYLC                12     12
      * I : MAP Counterparty Nostro Name
     D  PACPNM                13     47
      * I : MAP Counterparty Nostro Town
     D  PACNTN                48     67
      * I : MAP Customer Shortname part 1
     D  PACSN1                68     74
      * I : MAP Customer Shortname part 2
     D  PACSN2                75     77
 
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
     C                   MOVEL     PKEY          KKEY1             8
      *
     C     KKEY1         CHAIN     SDCNSTL1                           80
      *
     C                   IF        *IN80 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCNSTPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVE      *BLANKS       UBA
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
      ** Access record to be authorised from shadow file
     C     KKEY1         CHAIN     SDCNSHL1                           80
      *
     C                   IF        ALACTN = 'A'
     C                   MOVE      *BLANKS       UPA
     C                   MOVE      @1DBRC        MAIN2
     C                   ELSE
     C                   MOVE      *BLANKS       UBA
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
     C/COPY WNCPYSRC,SDCPNOC002
 
      ** Call program SDAUTHCMP to display differences
 
     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'SDCNSTPD'    FILE             10
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
     C     KKEY1         CHAIN     SDCNSHL0                           80
      *
     C                   IF        *IN80 = '0'
     C                   DELETE    SDCNSHD0
     C                   ENDIF
 
     C/COPY WNCPYSRC,SDCPNOC003
 
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
     C     KKEY1         CHAIN     SDCNSTL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCNSTPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   DELETE    @AWREDM
      *
     C                   EXSR      SRDltRecUpd
     C                   EXSR      SRStdCtl
     C                   MOVE      'D'           AWTYLC
     C                   EXSR      SRBckgrdUpd
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'I', Insert record.
      ** --------------------------------
 
     C                   IF        ALACTN = 'I'
     C     KKEY1         CHAIN     SDCNSHL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCNSHPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   WRITE     @AWREDM
      *
     C                   EXSR      SRStdCtl
     C                   EXSR      SRBckgrdUpd
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'A', Update record.
      ** --------------------------------
 
 B1  C                   IF        ALACTN = 'A'
     C     KKEY1         CHAIN     SDCNSHL0                           80
 
 B2  C                   IF        *IN80 = '0'
 
      ** Hold shadow record image
     C                   MOVEL     @1DBRC        #1DBRC
     C     KKEY1         CHAIN     SDCNSTL0                           80
 
 B3  C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCNSTPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
 X3  C                   ELSE
      ** Replace values with shadow record image
     C                   MOVEL     #1DBRC        @1DBRC
     C                   UPDATE    @AWREDM
      *
     C                   EXSR      SRStdCtl
     C                   EXSR      SRBckgrdUpd
 E3  C                   ENDIF
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,SDCPNOC004
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRBckgrdUpd - Background Update via SD0221U                   *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    :                                                    *
      *****************************************************************
     C     SRBckgrdUpd   BEGSR
 
      * Background Update CNST - Counterparty Nostros  *
     C                   CLEAR                   PARC
     C                   MOVEL     AWCPNC        PACPNC                         Counterparty No
     C                   Z-ADD     AWLCD         PALCD                          Last Change Dat
     C                   MOVEL     AWTYLC        PATYLC                         Type of Last Ch
     C                   MOVEL     AWCPNM        PACPNM                         Counterparty No
     C                   MOVEL     AWCNTN        PACNTN                         Counterparty No
     C                   MOVEL     AWCSN1        PACSN1                         Customer Shortn
     C                   MOVEL     AWCSN2        PACSN2                         Customer Shortn
      *
     C                   CALL      'SD0221U'                            90      Background Upda
     C     W0RTN         PARM      W0RTN         WQ0017            7            *Return code
     C                   PARM                    PARC                           RCD: Counterpar
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     ERRMSG
     C                   ENDIF
 
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ERRMSG
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
     C                   MOVEL     'SDCNSTPD'    PBFNME                         File name
     C                   MOVEL     AWCPNC        PBLKEY                         Long Key
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
     C                   MOVEL     'SDCNSTPD'    WKFLNM
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
     C                   MOVEL     'SDCNSTPD'    DBKEY
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
     C                   EVAL      DBPGM = 'SDCPNOAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA
 
      ** Get Rundate - Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   Z-ADD     RDNB          WURDNB            5 0
 
     C/COPY WNCPYSRC,SDCPNOC001
 
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
