     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Outgoing Payments SSI Update')                *
      **********************************************************************
      *                                                                    *
      *  Midas - API Funds Transfer Module                                 *
      *                                                                    *
      *  FTOPSIUPD - Outgoing Payments SSI Primary Details Screen          *
      *              validation                                            *
      *                                                                    *
      *  Function:  Primary detail screen validation for Outgoing          *
      *             Payments Standard Settlement Instructions              *
      *                                                                    *
      *  (c) Finastra International Limited 2002                           *
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template (Recompile)                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT018 - Standard Settlement Instructions for                     *
      *           Outgoing Payments                                        *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FFTOSSIL1  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      **  Outgoing Payments Standard Settlement Instructions
      *
     FFTOSIXL0  UF A E           K DISK    COMMIT
     F                                     PREFIX(X)
     F                                     RENAME(FTOSSID0: FTOSIXD0)
     F                                     INFSR(*PSSR)
      **  Unauthorised Outgoing Payments Standard Settlement Instructions
      *
      ********************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
      *
     D K@DRCY          S                   LIKE(OSDRCY)
     D K@DRAC          S                   LIKE(OSDRAC)
     D K@REF1          S                   LIKE(OSREF1)
     D K@REF2          S                   LIKE(OSREF2)
     D K@CRCY          S                   LIKE(OSCRCY)
      *
      ** Timestamp for the tranaction
     D Timestamp       S               Z
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D CurSSIFileFmt E DS                  EXTNAME(FTOSSIPD)
     D                                     PREFIX(Cr)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIValidFmt   E DS                  EXTNAME(FTVOPSIPD)
      * Outgoing Payment SSI details in valid File Format
      *
     D NewSSIFileFmt E DS                  EXTNAME(FTOSSIPD)
     D  QQDRA1       E                     EXTFLD(QQDRAC)                                     CGL029
     D  QQORB1       E                     EXTFLD(QQORBK)                                     CGL029
     D  QQCDR1       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Outgoing Payment SSI in File Format
      *
     D NewSSIFileFmtXE DS                  EXTNAME(FTOSSIPD)
     D                                     PREFIX(X)
      * Unauthorised Outgoing Payment SSI in File Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Ix              S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **********************************************************************
      /EJECT
      **********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      **  Initialisation
     C                   Exsr      INIT
      *
      **  Update details
     C                   Exsr      UpdDtls
      *
      **  Return to calling program
     C                   Return
      *
      /EJECT
      **********************************************************************
      * INIT - Initialisation Processing each time module is invoked
      **********************************************************************
     C     INIT          BEGSR
      *
     C                   Move      OVDRCY        K@DRCY
     C                   Move      OVDRAC        K@DRAC
     C                   Move      OVREF1        K@REF1
     C                   Move      OVREF2        K@REF2
     C                   Move      OVCRCY        K@CRCY
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * UpdDtls - Update File Details
      **********************************************************************
     C     UpdDtls       Begsr
      *                                                                         CFT014
      ** Generate timestamp                                                     CFT014
     C                   CallB     'ZAGENTMSTM'                                 CFT014
     C                   Parm                    Timestamp                      CFT014
      *
      **  Retrieve SSI details from master file if they exist
     C     K@OSSI        Chain     FTOSSIL1                           90
      *
      **  Retrieve SSI details from unauthorised file if they exist
     C     K@OSSI        Chain     FTOSIXL0                           91
      *
      ** Perform file updates according to action
     C                   Select
      *
      ** Insert: Write new record to master file and unauthorised file
     C     OVCHTP        Wheneq    'I'
     C                   Eval      NewSSIFileFmt = SSIValidFmt
     C                   Eval      OSTMST = Timestamp                           CFT014
     C                   Eval      NewSSIFileFmtX = SSIValidFmt
     C                   Eval      XOSTMST = Timestamp                          CFT014
     C                   Write     FTOSSID0
     C                   Write     FTOSIXD0
      *
      ** Amend:   Update master file and write/update unauthorised record
     C     OVCHTP        Wheneq    'A'
     C                   Move      OVSTAT        OSSTAT
     C                   Update    FTOSSID0
     C                   Eval      XOSTMST = Timestamp                          CFT014
     C                   Eval      NewSSIFileFmtX = SSIValidFmt
     C     *in91         Ifeq      *off
     C                   Update    FTOSIXD0
     C                   Else
     C                   Write     FTOSIXD0
     C                   Endif
      *
      ** Authorise:  Update master file and remove unauthorised details
     C     OVCHTP        Wheneq    'X'
     C                   Eval      NewSSIFileFmt = SSIValidFmt
     C                   Eval      OSTMST = Timestamp                           CFT014
     C                   Update    FTOSSID0
     C                   Delete    FTOSIXD0
      *
      ** Delete:   Update master file and remove unauthorised details
     C     OVCHTP        Wheneq    'D'
     C                   Eval      NewSSIFileFmt = SSIValidFmt
     C                   Eval      OSTMST = Timestamp                           CFT014
     C                   Update    FTOSSID0
     C  N91              Delete    FTOSIXD0
     C                   Endsl
      *
      **  Commit the details
     C                   Commit
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program entry parameter list
     C     *Entry        Plist
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Valid file layout
     C                   Parm                    SSIValidFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *
      ** Initialize program name
     C                   Movel     'FTOPSIUPD'   DBPGM
      *
      *
      **  Key list to access LF/FTOSSIL1
     C     K@OSSI        Klist
     C                   Kfld                    K@DRCY
     C                   Kfld                    K@DRAC
     C                   Kfld                    K@REF1
     C                   Kfld                    K@REF2
     C                   Kfld                    K@CRCY
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
