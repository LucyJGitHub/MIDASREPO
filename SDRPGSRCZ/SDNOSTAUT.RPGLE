     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(SDNOSTAU) TOFILE(SDNOSTL0) SHARE(*NO)            *
/*XBIB*  OVRDBF FILE(SDNOSHAU) TOFILE(SDNOSHL0) SHARE(*NO)            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Nostro details authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNOSTAUT - Nostro Details Authorisation                     *
      *                                                               *
      *  Function:  This program performs the update processes that   *
      *             are to be carrired out on the unauthorised record *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. B07400             Date 16May06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 235845             Date 06Sep05               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  B07400 - Nostro Codes maintenance not updating TABLETL.      *
      *           Re-arranged parm list when calling TABLETL.         *
      *  CSD027 - Conversion Of Customer Number to alpha.             *
      *  235845 - Fixed to correct parameters.                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDNOSTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Nostro details update
 
     FSDNOSTAU  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@A7REBE:REBEAU)
      ** Midas SD Nostro details retrieve
 
     FSDNOSHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Nostro Details Shadow file Update
 
     FSDNOSHAU  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@NOSHL0:SDNOSHDA)
      ** Midas SD Nostro Details Shadow file Retrieve
 
     FSDFCTLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Standing Data Controls
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Key (Rtv)
 
     FSDAULGL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD1)
     F                                     COMMIT
      ** Midas SD Authorisation Log - by Key (Upd)
 
     F/COPY WNCPYSRC,SDNOSTF001
 
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
 
     D @1DBRC        E DS                  EXTNAME(SDNOSTPD)
      * UPD : Nostro Details update
 
     D #1DBRC        E DS                  EXTNAME(SDNOSTPD) PREFIX(#)
      * Stored shadow file format fields
 
     D UBA             DS          5000
      **  1st Record format
     D  MAIN1                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDNOSTD001
 
     D UPA             DS          5000
      **  2nd Record format
     D  MAIN2                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDNOSTD002
 
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
 
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
 
     D PKEY            DS
     D  PCYCD                  1      3
     D  PNONB                  4      5
 
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
     C                   MOVE      PCYCD         KCYCD
     C                   MOVE      PNONB         KNONB
      *
     C     KKEY1         CHAIN     SDNOSTAU                           80
      *
     C                   IF        *IN80 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDNOSTPD'    DBFILE
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
     C     KKEY1         CHAIN     SDNOSHAU                           80
      *
     C                   IF        ALACTN = 'A'
     C                   MOVE      *BLANKS       UPA
     C                   MOVE      @1DBRC        MAIN2
     C                   ELSE
     C                   MOVE      *BLANKS       UBA
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
     C/COPY WNCPYSRC,SDNOSTC002
 
      ** Call program SDAUTHCMP to display differences
 
     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'SDNOSTPD'    FILE             10
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
     C     KKEY1         CHAIN     SDNOSHL0                           80
      *
     C                   IF        *IN80 = '0'
     C                   DELETE    @NOSHL0
     C                   ENDIF
 
     C/COPY WNCPYSRC,SDNOSTC003
 
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
     C     KKEY1         CHAIN     SDNOSTL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   DELETE    @A7REBE
      *
     C                   EXSR      SRDltRecUpd
     C                   EXSR      SRStdCtl
     C                   MOVE      'D'           A7TYLC
     C                   EXSR      SRBckgrdUpd
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'I', Insert record.
      ** --------------------------------
 
     C                   IF        ALACTN = 'I'
     C     KKEY1         CHAIN     SDNOSHL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDNOSHPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   WRITE     @A7REBE
      *
     C                   EXSR      SRStdCtl
     C                   MOVE      'I'           A7TYLC                                       235845
     C                   EXSR      SRBckgrdUpd
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'A', Update record.
      ** --------------------------------
 
 B1  C                   IF        ALACTN = 'A'
     C     KKEY1         CHAIN     SDNOSHL0                           80
 
 B2  C                   IF        *IN80 = '0'
 
      ** Hold shadow record image
     C                   MOVEL     @1DBRC        #1DBRC
     C     KKEY1         CHAIN     SDNOSTL0                           80
 
 B3  C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
 X3  C                   ELSE
      ** Replace values with shadow record image
     C                   MOVEL     #1DBRC        @1DBRC
     C                   UPDATE    @A7REBE
      *
     C                   EXSR      SRStdCtl
     C                   MOVE      'A'           A7TYLC                                       235845
     C                   EXSR      SRBckgrdUpd
 E3  C                   ENDIF
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,SDNOSTC004
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRBckgrdUpd - Background Update via TABLETL                   *
      *                                                               *
      * Called by: SRUpdate                                           *
      * Calls    :                                                    *
      *****************************************************************
     C     SRBckgrdUpd   BEGSR
 
      * Update TABLETL - Nostro Details
     C                   CALL      'TABLETL'                            90      update TABLETL
     C     W0RTN         PARM      *BLANK        WQ0004            7            *Return code
     C                   PARM      A7CYCD        WQ0005            3            Currency Code
     C                   PARM      A7NONB        WQ0006            2            Nostro Number
     C**********         PARM      A7ACCD        WQ0007            4                          CGL029
     C                   PARM      A7ACCD        WQ0007           10                          CGL029
     C                   PARM      A7CUST        WQ0008            6            Customer Number
     C                   PARM      A7ACSN        WQ0009            2 0          Account sequenc
     C                   PARM      A7NOSN        WQ0010           10            Nostro Shortnam
     C*****              PARM      A7OANN        WQ0017           14                   235845 B07400
     C                   PARM      A7OACN        WQ0011           35                          B07400
     C                   PARM      A7ORAC        WQ0012           25            Our Receive Acc
     C                   PARM      A7PNOI        WQ0013            1            Prime Nostro In
     C                   PARM      A7BRCD        WQ0014            3            Branch code
     C                   PARM      A7TYLC        WQ0015            1            Type of Last Ch
     C                   PARM      A7LCD         WQ0016            5 0          Run day number
     C**********         PARM      A7OACN        WQ0011           35                          235845
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
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      *
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDNOSTPD'    PAFNME                         File name
     C                   MOVEL     PKEY          PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
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
     C                   MOVEL     'SDNOSTPD'    WKFLNM
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
     C                   MOVEL     'SDNOSTPD'    DBKEY
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
     C                   EVAL      DBPGM = 'SDNOSTAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA
 
      ** Get Rundate - Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   Z-ADD     RDNB          WURDNB            5 0
 
      ** Define Key list
 
     C     KKEY1         KLIST
     C                   KFLD                    KCYCD             3
     C                   KFLD                    KNONB             2
 
     C/COPY WNCPYSRC,SDNOSTC001
 
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
(c) Misys International Banking Systems Ltd. 2002
