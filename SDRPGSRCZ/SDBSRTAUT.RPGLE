     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base rate authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTAUT - Base Rate Code Authorisation                     *
      *                                                               *
      *  Function:  This program performs the update processes that   *
      *             are to be carrired out on the unauthorised record *
      *             for base rates.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL029             Date 03Sep01               *
      *  Prev Amend No. CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDBSRTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Base rate Codes
 
     FSDBRSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDBSRTD0:SDBRSHD0)
      ** Midas SD Base Rate Shadow File
 
     FSDBRSHL1  UF A E           K DISK    INFSR(*PSSR)
      ** Midas SD Base Rate Shadow File
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Key (Rtv)
 
     FSDAULGL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD1)
      ** Midas SD Authorisation Log - by Key (Upd)
 
     F/COPY WNCPYSRC,SDBSRTF001
 
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
 
     D @1DBRC        E DS                  EXTNAME(SDBSRTPD)
      * Stored file format fields
 
     D #1DBRC        E DS                  EXTNAME(SDBSRTPD) PREFIX(#)
      * Stored shadow file format fields
 
      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
 
     D UBA             DS          5000
      **  1st Record Format
     D  MAIN1                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDBSRTD001
 
     D UPA             DS          5000
      **  2nd Record Format
     D  MAIN2                              LIKE(@1DBRC)
     D/COPY WNCPYSRC,SDBSRTD002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Override SDBRSHL0
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)
 
     D CSD012          S              1A
     D SVALKK          C                   CONST('AuthReqBaseRateMaint')
     D @RUN            S              1
     D CPY2@           S             80
 
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
     C     PKEY          CHAIN     SDAULGL0                           90
      *
     C                   IF        *IN90 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access record from master file
     C                   MOVEL     PKEY          @PKEY             5
     C                   MOVEL     @PKEY         @CYCD             3
     C                   MOVE      @PKEY         @BSRC             2
 
     C     @KBSRT        CHAIN     SDBSRTL0                           91
      *
     C                   IF        *IN91 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVE      *BLANKS       UBA
     C                   MOVE      @1DBRC        MAIN1
     C                   ENDIF
 
      ** Access record from shadow file
     C     @KBSRT        CHAIN     SDBRSHL0                           91
      *
     C                   IF        ALACTN = 'A'
     C                   MOVEL     *BLANKS       UPA
     C                   MOVEL     @1DBRC        MAIN2
     C                   ELSE
     C                   MOVEL     *BLANKS       UBA
     C                   MOVEL     @1DBRC        MAIN1
     C                   ENDIF
 
     C/COPY WNCPYSRC,SDBSRTC002
 
      ** Call program SDAUTHCMP to display differences
 
     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'SDBSRTPD'    FILE             10
     C                   PARM                    UBA
     C                   PARM                    UPA
 
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
     C     PKEY          CHAIN     SDAULGL1                           90
      *
     C                   IF        *IN90 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   DELETE    SDAULGL1
     C                   ENDIF
 
      ** Delete record from Shadow file
     C     @KBSRT        CHAIN     SDBRSHL1                           91
      *
     C                   IF        *IN91 = '0'
     C                   DELETE    SDBRSHL1
     C                   ENDIF
 
     C/COPY WNCPYSRC,SDBSRTC003
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRUpdate - Update master file with shadow file details        *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C     @KBSRT        CHAIN     SDBRSHL0                           91
 
 B1  C                   IF        *IN91 = '0'
 
      ** Hold shadow record image
     C                   MOVEL     @1DBRC        #1DBRC
     C     @KBSRT        CHAIN     SDBSRTL0                           91
 
 B2  C     *IN91         IFEQ      *ON
     C     ALACTN        ANDNE     'I'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
 X2  C                   ELSE
     C                   MOVEL     PACTN         AUTHMD
 
      ** Update Master file
 
     C                   CALLB     'SDBSRTUPD'
     C                   PARM      *BLANKS       RETURNCODE       10
     C                   PARM                    #1DBRC
      ** Base Rate Auth req
     C                   PARM                    AUTHRQ            1
      ** Authorisation Mode
     C                   PARM                    AUTHMD            1
      *
      ** IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      ** UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C                   IF        RETURNCODE <> *BLANK
     C                   ROLBK
      *
     C                   IF        RETURNCODE =  '*ERROR '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      SREND
      *
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
     C
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,SDBSRTC004
 
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
 
     C* Override SDBRSHL0
     C                   Z-ADD     50            CMDLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    CMDLEN
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    RETCODE           7
     C**********         PARM                    PKEY             20                          CGL029
     C                   PARM                    PKEY             26                          CGL029
     C                   PARM                    PACTN             1
     C                   PARM                    ERRMSG            7
     C                   PARM                    @INKC
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SDBSRTAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA
 
      ** Key list to chain base rate file SDBSRTL0
     C     @KBSRT        KLIST
     C                   KFLD                    @CYCD
     C                   KFLD                    @BSRC
 
      ** Check if CSD012 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSD012'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD012
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF
 
      ** If CSD012 is ON, Check if Base Rate Authorisation is ON
 B1  C     CSD012        IFEQ      'Y'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SDBSRTAUT'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Base Rate Authorisation is On set to Authorise
     C     SVAL11        IFEQ      'Y'
     C                   MOVE      'Y'           AUTHRQ
     C                   ELSE
     C                   MOVE      'N'           AUTHRQ
     C                   ENDIF
      *
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,SDBSRTC001
 
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
** CMD
OVRDBF FILE(SDBRSHL0) TOFILE(SDBRSHL0) SHARE(*NO)
