     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Correspondence authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  CGCORRAUT - Correspondence Authorisation                     *
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
      *  Last Amend No. CSD053             Date 01Jun06               *
      *  Prev Amend No. CGL029             Date 03Sep01               *
      *                 CSD012  *CREATE    Date 14Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCGCORRL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas CG Correspondence Details update index
 
     FCGCORRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas CG Correspondence Details retrieval index
 
     FCGCDSHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas CG Correspondence Details Shadow file Update
 
     FCGCDSHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@CORRL0:CGCDSHAU)
      ** Midas CG Correspondence Details Shadow file Retrieve
 
     FSDAULGL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Function (Rtv)
 
     FSDAULGL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD3)
     F                                     COMMIT
      ** Midas SD Authorisation Log - by Function (Upd)
 
     F/COPY WNCPYSRC,CGCORRF001
 
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
 
     D @1DBRC        E DS                  EXTNAME(CGCORRPD)
      * UPD : Correspondence Details
 
     D #1DBRC        E DS                  EXTNAME(CGCORRPD) PREFIX(#)
      * Stored shadow file format fields
 
     D UBA             DS          5000
      **  1st Record format
     D  MAIN1                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,CGCORRD001
 
     D UPA             DS          5000
      **  2nd Record format
     D  MAIN2                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,CGCORRD002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PKEY            DS
     D  PCORR                  1     10
      *
     D @RUN            S              1
     D CPY2@           S             80
 
     D RUNDAT          DS            13
     D  RDNB                   8     10P 0
     D FUNCD           C                   CONST('CORRESPONDENT DETAILS')
 
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
     C     KAULG         CHAIN     SDAULGL2                           80
      *
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     PCORR         KCORR
      *
      ** Access original record details from from master file
     C                   MOVE      *BLANKS       UBA
      *
     C     KKEY1         CHAIN     CGCORRL1                           80
      *
     C                   IF        *IN80 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CGCORRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     KCORR         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
      ** Access record to be authorised from shadow file
     C                   MOVE      *BLANKS       UPA
      *
     C     KKEY1         CHAIN     CGCDSHL1                           80
      *
     C                   IF        ALACTN = 'A'
     C                   MOVE      *BLANKS       UPA
     C                   MOVE      @1DBRC        MAIN2
     C                   ELSE
     C                   MOVE      *BLANKS       UBA
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
     C/COPY WNCPYSRC,CGCORRC002
 
      ** Call program SDAUTHCMP to display differences
 
     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'CGCORRPD'    FILE             10
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
     C     KAULG         CHAIN     SDAULGL3                           80
      *
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   DELETE    SDAULGD3
     C                   ENDIF
 
      ** Delete record from Shadow file
     C     KKEY1         CHAIN     CGCDSHL0                           80
      *
     C                   IF        *IN80 = '0'
     C                   DELETE    CGCDSHD0
     C                   ENDIF
 
     C/COPY WNCPYSRC,CGCORRC003
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRUpdate - Update master file with shadow file details        *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** If action is 'D', Update record with CDRECI = '*'
      ** -------------------------------------------------
 
     C                   IF        ALACTN = 'D'
     C     KKEY1         CHAIN     CGCDSHL0                           80
 
 B2  C                   IF        *IN80 = '0'
 
      ** Hold shadow record image
     C                   MOVEL     *BLANKS       #1DBRC
     C                   MOVEL     @1DBRC        #1DBRC
     C                   MOVEL     *BLANKS       @1DBRC
     C     KKEY1         CHAIN     CGCORRL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CGCORRPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     KCORR         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
      ** Replace values with shadow record image
     C                   MOVEL     *BLANKS       @1DBRC
     C                   MOVEL     #1DBRC        @1DBRC
     C                   MOVE      '*'           CDRECI
     C                   UPDATE    @CORRL0
      *
 E1  C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'I', Insert record.
      ** --------------------------------
 
     C                   IF        ALACTN = 'I'
     C     KKEY1         CHAIN     CGCDSHL0                           80
 
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CGCDSHPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     KCORR         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Hold shadow record image
     C                   MOVEL     *BLANKS       #1DBRC
     C                   MOVEL     @1DBRC        #1DBRC
     C                   MOVEL     *BLANKS       @1DBRC
     C     KKEY1         CHAIN     CGCORRL0                           80
 B3  C                   IF        *IN80 = '0'
      *
      ** Replace values with shadow record image
     C                   MOVEL     *BLANKS       @1DBRC
     C                   MOVEL     #1DBRC        @1DBRC
     C                   UPDATE    @CORRL0
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       @1DBRC
     C                   MOVEL     #1DBRC        @1DBRC
     C                   WRITE     @CORRL0
 
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
 
      ** If action is 'A', Update record.
      ** --------------------------------
 
 B1  C                   IF        ALACTN = 'A'
     C     KKEY1         CHAIN     CGCDSHL0                           80
 
 B2  C                   IF        *IN80 = '0'
 
      ** Hold shadow record image
     C                   MOVEL     *BLANKS       #1DBRC
     C                   MOVEL     @1DBRC        #1DBRC
     C                   MOVEL     *BLANKS       @1DBRC
     C     KKEY1         CHAIN     CGCORRL0                           80
 
 B3  C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CGCORRL0'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     KCORR         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
 X3  C                   ELSE
      ** Replace values with shadow record image
     C                   MOVEL     *BLANKS       @1DBRC
     C                   MOVEL     #1DBRC        @1DBRC
     C                   UPDATE    @CORRL0
      *
 E3  C                   ENDIF
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,CGCORRC004
 
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
     C                   EVAL      DBPGM = 'CGCORRAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA
 
      ** Get Rundate - Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   Z-ADD     RDNB          WURDNB            5 0
 
      *
      ** Define Keylists
     C     KAULG         KLIST
     C                   KFLD                    @FUNC            21
     C                   KFLD                    PKEY
      *
     C                   MOVEL     FUNCD         @FUNC
 
     C     KKEY1         KLIST
     C                   KFLD                    KCORR            10
      *
     C/COPY WNCPYSRC,CGCORRC001
 
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
